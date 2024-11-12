defmodule MunchWeb.UserLive.ProfileForm do
  use MunchWeb, :live_view

  alias Munch.Profile

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Profile
    </.header>

    <h2>Featured Restaurants</h2>
    <%= for featured_restaurant <- @featured_restaurants do %>
      <.restaurant_card restaurant={featured_restaurant.restaurant} />
    <% end %>
    <%= if length(@featured_restaurants) < 4 do %>
      <div phx-click={show_modal("#add-featured-restaurant")}>
        <.restaurant_card_add />
      </div>
    <% end %>
    <%= for _ <- 0..(2 - length(@featured_restaurants)) do %>
      <.restaurant_card_skeleton />
    <% end %>

    <.modal id="add-featured-restaurant">
      <.live_component
        module={MunchWeb.RestaurantLive.SelectComponent}
        id="add-featured-restaurant-select"
        submit_action={fn js -> close_modal(js, "#add-featured-restaurant") end}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    featured_restaurants = Profile.list_featured_restaurants(user)
    {:ok, assign(socket, user: user, featured_restaurants: featured_restaurants)}
  end

  @impl true
  def handle_info({:restaurant_selected, restaurant_id}, socket) do
    IO.inspect(restaurant_id)
    {:noreply, socket}
  end
end
