defmodule MunchWeb.ItemLive.Show do
  use MunchWeb, :live_view

  alias Munch.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Item <%= @item.id %>
      <:subtitle>This is a item record from your database.</:subtitle>
      <:actions>
        <.link navigate={~p"/list_items/#{@item}/edit?return_to=show"}>
          <.button>Edit item</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Position"><%= @item.position %></:item>
      <:item title="Restaurant ID"><%= @item.restaurant_id %></:item>
      <:item title="List ID"><%= @item.list_id %></:item>
      <:item title="ID"><%= @item.id %></:item>
    </.list>

    <.back navigate={~p"/list_items"}>Back to list_items</.back>
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
     |> assign(:page_title, "Show Item")
     |> assign(:item, Lists.get_item!(id))}
  end
end
