defmodule MunchWeb.RestaurantLive.Show do
  use MunchWeb, :live_view

  alias Munch.Restaurants

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Restaurant <%= @restaurant.name %>
    </.header>

    <ul>
      <li>OSM Type: <%= @restaurant.osm_type %></li>
      <li>OSM ID: <%= @restaurant.osm_id %></li>
      <li>Display Name: <%= @restaurant.display_name %></li>
      <li>Name: <%= @restaurant.name %></li>
      <li>Note: <%= @restaurant.note %></li>
      <li>
        Location: <%= case @restaurant.location.coordinates do
          {lat, lon} -> "#{lat}, #{lon}"
          _ -> "Unknown"
        end %>
      </li>
      <li>Country: <%= @restaurant.country %></li>
      <li>State: <%= @restaurant.iso_country_subdivision %></li>
      <li>Address: <%= inspect(@restaurant.address) %></li>
    </ul>

    <a href={~p"/restaurants/by-id/#{@restaurant}/edit"}>Edit</a>

    <div id="map" phx-hook="Map"></div>

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
