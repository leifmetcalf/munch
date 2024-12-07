defmodule MunchWeb.ListLive.Show do
  use MunchWeb, :live_view

  alias Munch.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= @list.name %>
      <:subtitle>Inserted <%= @list.inserted_at %></:subtitle>
      <:actions>
        <.link navigate={~p"/lists/by-id/#{@list}/edit?return_to=show"}>
          <.button>Edit list</.button>
        </.link>
      </:actions>
    </.header>

    <h2>Details</h2>
    <ul>
      <li>ID: <%= @list.id %></li>
      <li>Owner: <%= @list.user_id %></li>
      <li>Inserted: <%= @list.inserted_at %></li>
      <li>Updated: <%= @list.updated_at %></li>
    </ul>

    <h2>Items</h2>
    <ul>
      <li :for={item <- @list.items}>
        <%= item.restaurant.name %>
      </li>
    </ul>

    <.back navigate={~p"/lists"}>Back to lists</.back>
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
     |> assign(:page_title, "Show List")
     |> assign(:list, Lists.get_list!(id))}
  end
end
