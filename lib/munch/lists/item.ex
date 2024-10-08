defmodule Munch.Lists.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "list_items" do
    field :position, :integer
    belongs_to :list, Munch.Lists.List, on_replace: :delete
    belongs_to :restaurant, Munch.Restaurants.Restaurant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:position, :list_id, :restaurant_id])
    |> validate_required([:position, :list_id, :restaurant_id])
  end

  @doc false
  def changeset(item, attrs, position) do
    item
    |> cast(attrs, [:list_id, :restaurant_id])
    |> validate_required([:restaurant_id])
    |> assoc_constraint(:restaurant)
    |> put_change(:position, position)
  end
end
