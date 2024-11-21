defmodule Munch.Osm do
  @moduledoc """
  The OSM context.
  """

  import Ecto.Query, warn: false
  alias Munch.Repo
  alias Munch.Restaurants

  def api_get_object(osm_type, osm_id) do
    resp = Req.get!("https://api.openstreetmap.org/api/0.6/#{osm_type}/#{osm_id}.json")

    decoded = Jason.decode!(resp.body)

    case decoded do
      %{"elements" => [%{"lat" => lattitude, "lon" => longitude, "tags" => tags}]} ->
        %{lattitude: lattitude, longitude: longitude, tags: tags}

      _ ->
        raise "Invalid response from OpenStreetMaps API: #{decoded}"
    end
  end

  def pull_restaurant(osm_type, osm_id) do
    object = api_get_object(osm_type, osm_id)
    %{"name" => name} = object.tags

    Repo.insert!(%Restaurants.Restaurant{
      osm_type: osm_type,
      osm_id: osm_id,
      name: name,
      location: %Geo.Point{coordinates: {object.longitude, object.lattitude}, srid: 4326},
      note: "",
      iso_country_subdivision: "",
      secondary_subdivision: ""
    })
  end

  def copy_osm_restaurants() do
    osm_restaurants = Repo.all(Munch.Osm.Restaurant)

    restaurants =
      osm_restaurants
      |> Enum.map(fn osm_restaurant ->
        %Restaurants.Restaurant{
          osm_type: osm_restaurant.osm_type,
          osm_id: osm_restaurant.osm_id,
          name: osm_restaurant.tags["name"],
          location: osm_restaurant.location,
          note: "",
          iso_country_subdivision: nil,
          secondary_subdivision: nil
        }
      end)
      |> IO.inspect()

    restaurants
    |> Enum.map(fn restaurant ->
      Repo.insert!(restaurant)
    end)
  end

  def sync_restaurant(_restaurant) do
    IO.inspect("TODO: Implement sync with OSM")
  end
end
