defmodule Munch.Importer do
  use Oban.Worker, queue: :fresh_restaurants

  alias Munch.Restaurants

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"osm_type" => osm_type, "osm_id" => osm_id}}) do
    {:ok, restaurant} =
      Munch.Osm.nominatim_get_details(String.to_atom(osm_type), String.to_integer(osm_id))

    Restaurants.create_restaurant(restaurant)
  end
end
