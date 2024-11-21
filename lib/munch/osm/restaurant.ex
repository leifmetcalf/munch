defmodule Munch.Osm.Restaurant do
  use Ecto.Schema

  @schema_prefix "osm"
  @primary_key false
  schema "restaurants" do
    field :osm_type, Ecto.Enum, values: [node: "N", way: "W", relation: "R"], primary_key: true
    field :osm_id, :integer, primary_key: true
    field :location, Geo.PostGIS.Geometry
    field :tags, :map
  end
end
