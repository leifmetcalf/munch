defmodule Munch.Restaurants.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "restaurants" do
    field :name, :string
    field :address, :string
    field :country, :string
    field :city, :string
    field :neighbourhood, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [:name, :address, :country, :city, :neighbourhood])
    |> validate_required([:name, :address, :country, :city, :neighbourhood])
  end
end
