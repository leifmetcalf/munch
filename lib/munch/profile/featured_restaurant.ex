defmodule Munch.Profile.FeaturedRestaurant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "featured_restaurants" do
    field :position, :integer
    belongs_to :user, Munch.Accounts.User
    belongs_to :restaurant, Munch.Restaurants.Restaurant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(featured_restaurant, attrs) do
    featured_restaurant
    |> cast(attrs, [:position, :restaurant_id])
    |> validate_required([:position, :restaurant_id])
    |> assoc_constraint(:restaurant)
  end
end
