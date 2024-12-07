defmodule MunchWeb.ListLive.Index do
  use MunchWeb, :live_view

  alias Munch.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Lists
      <:actions>
        <.link navigate={~p"/lists/new"}>
          <.button>New List</.button>
        </.link>
      </:actions>
    </.header>

    <ul class="divide-y divide-zinc-300">
      <li :for={{dom_id, list} <- @streams.lists} id={dom_id}>
        <.link navigate={~p"/lists/by-id/#{list}"}><%= list.name %> <%= list.length %></.link>
      </li>
    </ul>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Lists")
     |> stream(:lists, Lists.list_lists())}
  end
end
