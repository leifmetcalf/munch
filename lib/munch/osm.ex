defmodule Munch.Osm do
  @moduledoc """
  The OSM context.
  """

  import Ecto.Query, warn: false
  alias Munch.Repo
  alias Munch.Restaurants

  def osm_get!(path) do
    Req.get!(
      url: path,
      base_url: "https://api.openstreetmap.org/api/0.6",
      headers: [user_agent: "Munch/0.1"]
    )
  end

  def nominatim_get!(path) do
    Req.get!(
      url: path,
      base_url: "https://nominatim.openstreetmap.org",
      headers: [user_agent: "Munch/0.1"]
    )
  end

  def osm_get_object(:node, osm_id) do
    resp = osm_get!("node/#{osm_id}.json")

    case resp.body do
      %{"elements" => [%{"lat" => lattitude, "lon" => longitude, "tags" => tags}]} ->
        {:ok, %{lattitude: lattitude, longitude: longitude, tags: tags}}

      _ ->
        {:error, "Invalid response from OpenStreetMaps API: #{resp}"}
    end
  end

  def osm_get_object(:way, _osm_id) do
    {:error, "Importing ways is not implemented yet"}
  end

  def osm_get_object(:relation, _osm_id) do
    {:error, "Importing relations is not implemented yet"}
  end

  @doc """
  Import a restaurant and queue a task to pull its details from Nominatim.
  """
  def import_fresh_restaurant(osm_type, osm_id) do
    with {:ok, object} <- osm_get_object(osm_type, osm_id),
         {:ok, name} <- Map.fetch(object.tags, "name") do
      point = %Geo.Point{coordinates: {object.longitude, object.lattitude}, srid: 4326}

      Oban.insert(
        Munch.Importer.new(%{
          "osm_type" => osm_type,
          "osm_id" => osm_id
        })
      )

      Repo.insert!(%Restaurants.Restaurant{
        osm_type: osm_type,
        osm_id: osm_id,
        name: name,
        location: point,
        note: "",
        country: "",
        iso_country_subdivision: ""
      })
    end
  end

  def nominatim_get_details(osm_type, osm_id) do
    osm_type_char =
      case osm_type do
        :node -> "N"
        :way -> "W"
        :relation -> "R"
      end

    resp = nominatim_get!("lookup?osm_ids=#{osm_type_char}#{osm_id}&format=jsonv2")

    case resp.body do
      [
        %{
          "lat" => latitude,
          "lon" => longitude,
          "name" => name,
          "display_name" => display_name,
          "address" =>
            %{
              "ISO3166-2-lvl4" => iso_country_subdivision,
              "country" => country
            } = address
        }
      ] ->
        {:ok,
         %{
           osm_type: osm_type,
           osm_id: osm_id,
           name: name,
           display_name: display_name,
           location: %Geo.Point{
             coordinates: {String.to_float(longitude), String.to_float(latitude)},
             srid: 4326
           },
           note: "",
           country: country,
           iso_country_subdivision: iso_country_subdivision,
           address: address
         }}

      _ ->
        {:error, "Invalid response from Nominatim API: #{resp}"}
    end
  end

  @doc """
  Search for restaurants with Nominatim.

  options:

  * `:exclude` - A list of place IDs to exclude from the results.
  """
  def search_restaurants(search, opts \\ []) do
    exclude = Keyword.get(opts, :exclude, [])
    # TODO: use AI to assemble a structured query from the search string
    resp =
      nominatim_get!(
        "search?q=#{search}&layer=poi&exclude=#{exclude |> Enum.join(",")}&format=jsonv2"
      )

    resp.body
    |> Map.new(fn x ->
      case x do
        %{
          "place_id" => place_id,
          "lat" => lattitude,
          "lon" => longitude,
          "display_name" => display_name,
          "osm_type" => osm_type,
          "osm_id" => osm_id
        } ->
          {place_id,
           %{
             lattitude: lattitude,
             longitude: longitude,
             display_name: display_name,
             osm_type: String.to_atom(osm_type),
             osm_id: osm_id
           }}
      end
    end)
  end
end
