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

    <.table
      id="lists"
      rows={@streams.lists}
      row_click={fn {_id, list} -> JS.navigate(~p"/lists/#{list}") end}
    >
      <:col :let={{_id, list}} label="Name"><%= list.name %></:col>
      <:action :let={{_id, list}}>
        <div class="sr-only">
          <.link navigate={~p"/lists/#{list}"}>Show</.link>
        </div>
        <.link navigate={~p"/lists/#{list}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, list}}>
        <.link
          phx-click={JS.push("delete", value: %{id: list.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Lists")
     |> stream(:lists, Lists.list_lists())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Lists.get_list!(id)
    {:ok, _} = Lists.delete_list(list)

    {:noreply, stream_delete(socket, :lists, list)}
  end
end
