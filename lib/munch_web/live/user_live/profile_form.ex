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
      <.modal id="restaurant-select-modal">
        <.live_component
          module={MunchWeb.RestaurantLive.SelectComponent}
          id={"restaurant-select-component"

        />
    </.modal>
    <% end %>
    <%= if length(@featured_restaurants) < 4 do %>
      <div phx-click={show_modal("restaurant-select-modal")}>
        <.restaurant_card_add tag={length(@featured_restaurants)} />
      </div>
    <% end %>
    <%= for _ <- 0..(2 - length(@featured_restaurants)) do %>
      <.restaurant_card_skeleton />
    <% end %>


    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    featured_restaurants = Profile.list_featured_restaurants(user)
    {:ok, assign(socket, user: user, featured_restaurants: featured_restaurants)}
  end

  @impl true
  def handle_info({:restaurant_selected, position, restaurant_id}, socket) do
    Profile.create_featured_restaurant(socket.assigns.user, %{
      position: position,
      restaurant_id: restaurant_id
    })

    {:noreply, socket |> push_close_modal("restaurant-select-modal")}
  end
end
