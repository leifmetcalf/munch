defmodule Munch.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lists" do
    field :name, :string
    belongs_to :user, Munch.Accounts.User
    has_many :items, Munch.Lists.Item, preload_order: [asc: :position], on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:items,
      sort_param: :items_sort,
      drop_param: :items_drop,
      with: &Munch.Lists.Item.changeset/3
    )
  end

  def prepend_restaurant(changeset, restaurant_id) do
    changeset
    |> put_assoc(:items, [
      %Munch.Lists.Item{restaurant_id: restaurant_id}
      | get_field(changeset, :items)
    ])
  end
end
