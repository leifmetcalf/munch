defmodule MunchWeb.ListLive.Show do
  use MunchWeb, :live_view

  alias Munch.Lists

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      List <%= @list.id %>
      <:subtitle>This is a list record from your database.</:subtitle>
      <:actions>
        <.link navigate={~p"/lists/#{@list}/edit?return_to=show"}>
          <.button>Edit list</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @list.name %></:item>
      <:item title="ID"><%= @list.id %></:item>
    </.list>

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
