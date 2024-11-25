defmodule MunchWeb.RestaurantLive.ImportManual do
  use MunchWeb, :live_view

  alias Munch.Restaurants
  alias Munch.Restaurants.Restaurant
  alias Munch.Osm

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= @page_title %>
    </.header>

    <p>
      If you can't find the restaurant by search, you can import a restaurant
      by entering its osm_type and osm_id below.
    </p>
    <.simple_form for={@form} id="osm-form" phx-submit="save">
      <.input
        field={@form[:osm_type]}
        type="select"
        label="OSM Type"
        options={["node", "way", "relation"]}
      />
      <.input field={@form[:osm_id]} type="text" label="OSM ID" inputmode="numeric" />
      <:actions>
        <.button phx-disable-with="Importing...">Import</.button>
      </:actions>
    </.simple_form>

    <.back navigate={return_path(@return_to, @restaurant)}>Back</.back>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    restaurant = %Restaurant{}

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:page_title, "New Restaurant")
     |> assign(:restaurant, restaurant)
     |> assign(:form, to_form(Restaurants.change_restaurant(restaurant)))
     |> assign(:osm_form, to_form(%{}))}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("save", %{"osm_type" => osm_type, "osm_id" => osm_id}, socket) do
    case Osm.import_fresh_restaurant(osm_type, osm_id) do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant imported")
         |> push_navigate(to: ~p"/restaurant/#{restaurant}")}

      {:error, error} ->
        {:noreply, socket |> put_flash(:error, error)}
    end
  end

  defp return_path("index", _restaurant), do: ~p"/restaurants"
  defp return_path("show", restaurant), do: ~p"/restaurant/#{restaurant}"
end
