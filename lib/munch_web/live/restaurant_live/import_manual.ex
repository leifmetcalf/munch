defmodule MunchWeb.RestaurantLive.ImportManual do
  use MunchWeb, :live_view

  alias Munch.Osm

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Import restaurant manually
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
        options={[:node, :way, :relation]}
      />
      <.input field={@form[:osm_id]} type="text" label="OSM ID" inputmode="numeric" />
      <:actions>
        <.button phx-disable-with="Importing...">Import</.button>
      </:actions>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:form, to_form(%{}))}
  end

  @impl true
  def handle_event("save", %{"osm_type" => osm_type, "osm_id" => osm_id}, socket) do
    case Osm.import_fresh_restaurant(String.to_atom(osm_type), String.to_integer(osm_id))
         |> IO.inspect() do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant imported")
         |> redirect(to: ~p"/restaurants/by-id/#{restaurant}")}

      {:error, error} ->
        {:noreply, socket |> put_flash(:error, error)}
    end
  end
end
