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

    <ul>
      <li :for={{dom_id, restaurant} <- @streams.restaurants} id={dom_id}>
        <.link navigate={~p"/restaurants/by-id/#{restaurant}"}>
          <%= restaurant.display_name %>
        </.link>
      </li>
    </ul>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Restaurants list")
     |> stream(:restaurants, Restaurants.list_restaurants())}
  end
end
