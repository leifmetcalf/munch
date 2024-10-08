defmodule MunchWeb.ItemLive.Index do
  use MunchWeb, :live_view

  alias Munch.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing List items
      <:actions>
        <.link navigate={~p"/list_items/new"}>
          <.button>New Item</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="list_items"
      rows={@streams.list_items}
      row_click={fn {_id, item} -> JS.navigate(~p"/list_items/#{item}") end}
    >
      <:col :let={{_id, item}} label="Position"><%= item.position %></:col>
      <:action :let={{_id, item}}>
        <div class="sr-only">
          <.link navigate={~p"/list_items/#{item}"}>Show</.link>
        </div>
        <.link navigate={~p"/list_items/#{item}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, item}}>
        <.link
          phx-click={JS.push("delete", value: %{id: item.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing List items")
     |> stream(:list_items, Lists.list_list_items())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Lists.get_item!(id)
    {:ok, _} = Lists.delete_item(item)

    {:noreply, stream_delete(socket, :list_items, item)}
  end
end
