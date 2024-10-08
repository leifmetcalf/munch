defmodule MunchWeb.RestaurantLive.Show do
  use MunchWeb, :live_view

  alias Munch.Restaurants

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Restaurant <%= @restaurant.id %>
      <:subtitle>This is a restaurant record from your database.</:subtitle>
      <:actions>
        <.link navigate={~p"/restaurants/#{@restaurant}/edit?return_to=show"}>
          <.button>Edit restaurant</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @restaurant.name %></:item>
      <:item title="Address"><%= @restaurant.address %></:item>
    </.list>

    <.back navigate={~p"/restaurants"}>Back to restaurants</.back>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Show Restaurant")
     |> assign(:restaurant, Restaurants.get_restaurant!(id))}
  end
end
