defmodule MunchWeb.RestaurantLive.SelectComponent do
  use MunchWeb, :live_component

  alias Munch.Restaurants

  def mount(socket) do
    {:ok,
     socket
     |> assign(:restaurants, nil)
     |> assign(:form, to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="restaurant-select-form"
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <.remote_datalist
          field={@form[:search]}
          label="Add a restaurant"
          value=""
          result_name="restaurant_id"
          results={@restaurants}
          new_link={~p"/restaurants/new"}
          new_label="Add new restaurant..."
        />
      </.simple_form>
    </div>
    """
  end

  def handle_event("validate", params = %{"search" => search}, socket) do
    {:noreply,
     socket
     |> assign(:form, to_form(params))
     |> assign(
       :restaurants,
       case search do
         "" ->
           nil

         _ ->
           Restaurants.search_restaurants(search)
           |> Enum.map(fn restaurant ->
             %{value: restaurant.id, pretty: "#{restaurant.name} (#{restaurant.address})"}
           end)
       end
     )}
  end

  def handle_event("save", %{"restaurant_id" => restaurant_id}, socket) do
    send(self(), {:restaurant_selected, restaurant_id})
    {:noreply, socket}
  end
end
