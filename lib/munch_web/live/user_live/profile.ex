defmodule MunchWeb.UserLive.Profile do
  use MunchWeb, :live_view

  alias Munch.Accounts
  alias Munch.Profile
  alias Munch.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Profile
    </.header>

    <%= if @user == @current_user do %>
      <a href={~p"/users/edit"}>Edit Profile</a>
    <% end %>

    <h2>Featured Restaurants</h2>
    <%= for featured_restaurant <- @featured_restaurants do %>
      <.restaurant_card restaurant={featured_restaurant.restaurant} />
    <% end %>
    <%= for _ <- 0..(3 - length(@featured_restaurants)) do %>
      <.restaurant_card_skeleton />
    <% end %>

    <h2>Lists</h2>
    <%= for list <- @lists do %>
      <div><%= list.name %></div>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user = Accounts.get_user!(id)
    featured_restaurants = Profile.list_featured_restaurants(user)
    lists = Lists.user_lists(user)

    {:noreply,
     assign(socket, user: user, featured_restaurants: featured_restaurants, lists: lists)}
  end
end
