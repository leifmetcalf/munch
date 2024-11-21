defmodule MunchWeb.RestaurantLive.SelectComponent do
  use MunchWeb, :live_component

  alias Munch.Restaurants

  def mount(socket) do
    {:ok,
     socket
     |> assign(:restaurants, nil)
     |> assign(:tag, nil)
     |> assign(:form, to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-lg mx-auto">
      <.form
        for={@form}
        id="restaurant-select-form"
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <input
          type="search"
          name={@form[:search].name}
          id={@form[:search].id}
          value={Phoenix.HTML.Form.normalize_value("search", @form[:search].value)}
          class="w-full block border border-zinc-300 rounded-lg focus:border-zinc-400 focus:ring-0"
          autocomplete="off"
          autofocus
          placeholder="Search for a restaurant"
        />
        <ul :if={@restaurants} class="mt-4 divide-y divide-zinc-300">
          <li :for={restaurant <- @restaurants}>
            <button
              name={@form[:restaurant_id].name}
              value={restaurant.id}
              class="w-full py-2 px-3 leading-6 hover:bg-zinc-200 active:text-zinc-700 text-left"
            >
              <%= "#{restaurant.name}" %>
            </button>
          </li>
          <li :if={@restaurants == []}>
            <a
              href={~p"/restaurants/new"}
              target="_blank"
              class="w-full block py-2 px-3 leading-6 hover:bg-zinc-200 active:text-zinc-700 text-left"
            >
              Add new restaurant...
            </a>
          </li>
        </ul>
      </.form>
    </div>
    """
  end

  def handle_event("validate", params = %{"search" => search}, socket) do
    {:noreply,
     socket
     |> assign(:form, to_form(params))
     |> assign(
       :restaurants,
       case search do
         "" ->
           nil

         _ ->
           Restaurants.search_restaurants(search)
       end
     )}
  end

  def handle_event("save", %{"restaurant_id" => restaurant_id}, socket) do
    send(self(), {:restaurant_selected, socket.assigns.tag, restaurant_id})
    {:noreply, socket |> assign(:form, to_form(%{})) |> assign(:restaurants, nil)}
  end

  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end
end
