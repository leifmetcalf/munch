defmodule MunchWeb.RestaurantLive.Import do
  use MunchWeb, :live_view

  alias Munch.Osm
  alias Munch.Restaurants

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Add a new restaurant by search
    </.header>

    <.simple_form for={@form} id="search-new-form" phx-submit="search">
      <.input field={@form[:search]} type="text" label="Search" />
      <:actions>
        <.button phx-disable-with="Searching...">Search</.button>
      </:actions>
    </.simple_form>
    <ul :if={@results} class="mt-4 divide-y divide-zinc-300">
      <li :for={{place_id, result} <- @results}>
        <button
          phx-click={JS.push("import", value: %{place_id: place_id})}
          phx-disable-with="Importing..."
        >
          <%= result.display_name %>
        </button>
      </li>
      <li :if={@results == %{}}></li>
    </ul>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Import restaurant")
     |> assign(form: to_form(%{}))
     |> assign(results: nil)}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    {:noreply, socket |> assign(results: Osm.search_restaurants(search))}
  end

  def handle_event("import", %{"place_id" => place_id}, socket) do
    place = socket.assigns.results[place_id]
    {:ok, restaurant} = Osm.nominatim_get_details(place.osm_type, place.osm_id)

    case Restaurants.create_restaurant(restaurant) do
      {:ok, restaurant} ->
        {:noreply,
         socket
         |> redirect(to: ~p"/restaurants/by-id/#{restaurant}")
         |> put_flash(:info, "Restaurant imported successfully")}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "Failed to import restaurant")}
    end
  end
end
