defmodule MunchWeb.RestaurantLive.Form do
  use MunchWeb, :live_view

  alias Munch.Restaurants
  alias Munch.Restaurants.Restaurant

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= @page_title %>
      <:subtitle>Use this form to manage restaurant records in your database.</:subtitle>
    </.header>

    <.simple_form for={@form} id="restaurant-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Name" />
      <.input field={@form[:address]} type="text" label="Address" />
      <.input field={@form[:country]} type="text" label="Country" />
      <.input field={@form[:city]} type="text" label="City" />
      <.input field={@form[:neighbourhood]} type="text" label="Neighbourhood" />
      <:actions>
        <.button phx-disable-with="Saving...">Save Restaurant</.button>
      </:actions>
    </.simple_form>

    <.back navigate={return_path(@return_to, @restaurant)}>Back</.back>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    restaurant = Restaurants.get_restaurant!(id)

    socket
    |> assign(:page_title, "Edit Restaurant")
    |> assign(:restaurant, restaurant)
    |> assign(:form, to_form(Restaurants.change_restaurant(restaurant)))
  end

  defp apply_action(socket, :new, _params) do
    restaurant = %Restaurant{}

    socket
    |> assign(:page_title, "New Restaurant")
    |> assign(:restaurant, restaurant)
    |> assign(:form, to_form(Restaurants.change_restaurant(restaurant)))
  end

  @impl true
  def handle_event("validate", %{"restaurant" => restaurant_params}, socket) do
    changeset = Restaurants.change_restaurant(socket.assigns.restaurant, restaurant_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"restaurant" => restaurant_params}, socket) do
    save_restaurant(socket, socket.assigns.live_action, restaurant_params)
  end

  defp save_restaurant(socket, :edit, restaurant_params) do
    case Restaurants.update_restaurant(socket.assigns.restaurant, restaurant_params) do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, restaurant))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_restaurant(socket, :new, restaurant_params) do
    case Restaurants.create_restaurant(restaurant_params) do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, restaurant))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _restaurant), do: ~p"/restaurants"
  defp return_path("show", restaurant), do: ~p"/restaurant/#{restaurant}"
end
