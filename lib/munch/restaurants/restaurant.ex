defmodule Munch.Restaurants.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "restaurants" do
    field :osm_type, Ecto.Enum, values: [node: "N", way: "W", relation: "R"]
    field :osm_id, :integer
    field :name, :string
    field :display_name, :string
    field :location, Geo.PostGIS.Geometry
    field :note, :string
    field :country, :string
    field :iso_country_subdivision, :string
    field :address, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [
      :osm_type,
      :osm_id,
      :name,
      :display_name,
      :location,
      :note,
      :country,
      :iso_country_subdivision,
      :address
    ])
  end
end
