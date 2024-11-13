defmodule MunchWeb.ListLive.Form do
  use MunchWeb, :live_view

  alias Munch.Lists
  alias Munch.Lists.List

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= @page_title %>
      <:subtitle>Use this form to manage list records in your database.</:subtitle>
    </.header>

    <.simple_form for={@form} id="list-form" phx-change="validate" phx-submit="save">
      <.input field={@form[:name]} type="text" label="Name" />
      <div id="item-inputs" phx-hook="SortableInputs" class="flex flex-col gap-2">
        <.inputs_for :let={f} field={@form[:items]}>
          <div class="flex border rounded-lg p-2">
            <input
              type="hidden"
              id={f[:restaurant_id].id}
              name={f[:restaurant_id].name}
              value={f[:restaurant_id].value}
            />

            <input type="hidden" name="list[items_sort][]" value={f.index} />
            <div class="flex-auto">
              <%= @restaurants[f[:restaurant_id].value].name %>
            </div>
            <label>
              <input type="checkbox" name="list[items_drop][]" value={f.index} class="hidden" />
              <.icon name="hero-x-mark" />
            </label>
          </div>
        </.inputs_for>
      </div>
      <input type="hidden" name="list[items_drop][]" />

      <:actions>
        <.button type="button" phx-click={show_modal("restaurant-select-modal")}>
          Add item
        </.button>
        <.button phx-disable-with="Saving...">Save List</.button>
      </:actions>
    </.simple_form>

    <.modal id="restaurant-select-modal">
      <.live_component
        module={MunchWeb.RestaurantLive.SelectComponent}
        id="restaurant-select-component"
      />
    </.modal>

    <.back navigate={return_path(@return_to, @list)}>Back</.back>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    list = Lists.get_list!(id)

    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, list)
    |> assign(:form, to_form(Lists.change_list(list)))
    |> assign(:restaurants, %{})
    |> fill_restaurants()
  end

  defp apply_action(socket, :new, _params) do
    list = %List{}

    socket
    |> assign(:page_title, "New List")
    |> assign(:list, list)
    |> assign(:form, to_form(Lists.change_list(list)))
    |> assign(:restaurants, %{})
    |> fill_restaurants()
  end

  @impl true
  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset = Lists.change_list(socket.assigns.list, list_params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate)) |> fill_restaurants()}
  end

  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.live_action, list_params)
  end

  defp save_list(socket, :edit, list_params) do
    case Lists.update_list(socket.assigns.current_user, socket.assigns.list, list_params) do
      {:ok, list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List updated successfully")
         |> redirect(to: return_path(socket.assigns.return_to, list))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset)) |> fill_restaurants()}
    end
  end

  defp save_list(socket, :new, list_params) do
    case Lists.create_list(socket.assigns.current_user, list_params) do
      {:ok, list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> redirect(to: return_path(socket.assigns.return_to, list))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset)) |> fill_restaurants()}
    end
  end

  defp return_path("index", _list), do: ~p"/lists"
  defp return_path("show", list), do: ~p"/lists/by-id/#{list}"

  @impl true
  def handle_info({:restaurant_selected, nil, restaurant_id}, socket) do
    changeset =
      Lists.changeset_prepend_restaurant(socket.assigns.form.source, restaurant_id)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> fill_restaurants()
     |> push_close_modal("restaurant-select-modal")}
  end

  def fill_restaurants(socket) do
    restaurants =
      Enum.reduce(
        Ecto.Changeset.get_assoc(socket.assigns.form.source, :items, :struct),
        socket.assigns.restaurants,
        fn item, acc ->
          Map.put_new_lazy(
            acc,
            item.restaurant_id,
            fn -> Munch.Repo.preload(item, :restaurant).restaurant end
          )
        end
      )

    assign(socket, :restaurants, restaurants)
  end
end
