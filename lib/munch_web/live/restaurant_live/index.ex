defmodule MunchWeb.RestaurantLive.Index do
  use MunchWeb, :live_view

  alias Munch.Restaurants

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Restaurants
      <:actions>
        <.link navigate={~p"/restaurants/new"}>
          <.button>New Restaurant</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="restaurants"
      rows={@streams.restaurants}
      row_click={fn {_id, restaurant} -> JS.navigate(~p"/restaurant/#{restaurant}") end}
    >
      <:col :let={{_id, restaurant}} label="Name"><%= restaurant.name %></:col>
      <:col :let={{_id, restaurant}} label="Address"><%= restaurant.address %></:col>
      <:action :let={{_id, restaurant}}>
        <div class="sr-only">
          <.link navigate={~p"/restaurant/#{restaurant}"}>Show</.link>
        </div>
        <.link navigate={~p"/restaurant/#{restaurant}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, restaurant}}>
        <.link
          phx-click={JS.push("delete", value: %{id: restaurant.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Restaurants")
     |> stream(:restaurants, Restaurants.list_restaurants())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    restaurant = Restaurants.get_restaurant!(id)
    {:ok, _} = Restaurants.delete_restaurant(restaurant)

    {:noreply, stream_delete(socket, :restaurants, restaurant)}
  end
end
