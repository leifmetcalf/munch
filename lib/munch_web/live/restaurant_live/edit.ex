defmodule MunchWeb.RestaurantLive.Edit do
  use MunchWeb, :live_view

  alias Munch.Restaurants
  alias Munch.Osm

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Edit restaurant
    </.header>

    <.simple_form for={@form} id="restaurant-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:note]} type="text" label="Note" />
      <:actions>
        <.button phx-disable-with="Saving...">Save Restaurant</.button>
      </:actions>
    </.simple_form>

    <.button phx-click="trigger_sync">Sync OSM Data</.button>

    <.back navigate={return_path(@return_to, @restaurant)}>Back</.back>
    """
  end

  @impl true
  def mount(params = %{"id" => id}, _session, socket) do
    restaurant = Restaurants.get_restaurant!(id)

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:restaurant, restaurant)
     |> assign(:form, to_form(Restaurants.change_restaurant(restaurant)))}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"restaurant" => restaurant_params}, socket) do
    changeset = Restaurants.change_restaurant(socket.assigns.restaurant, restaurant_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"restaurant" => restaurant_params}, socket) do
    case Restaurants.update_restaurant(socket.assigns.restaurant, restaurant_params) do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant updated successfully")
         |> redirect(to: return_path(socket.assigns.return_to, restaurant))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("trigger_sync", _params, socket) do
    case Osm.update_fresh_restaurant(socket.assigns.restaurant) do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> assign(restaurant: restaurant)
         |> put_flash(:info, "Restaurant synced successfully")}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Failed to sync restaurant")}
    end
  end

  defp return_path("index", _restaurant), do: ~p"/restaurants"
  defp return_path("show", restaurant), do: ~p"/restaurants/by-id/#{restaurant}"
end
