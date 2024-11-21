# script for importing osm data into the database

osm_dir = "/home/leif/Documents/munch/osm"

IO.inspect(osm_dir)

# change the area line to
# area["ISO3166-2"="AU-NSW"];
# when it's ready
overpass_query = """
area["name"="Dunedin"];
(
  nwr[amenity=restaurant](area);
  nwr[amenity=fast_food](area);
  nwr[amenity=cafe](area);
  nwr[amenity=bar](area);
  nwr[amenity=pub](area);
  nwr[amenity=food_court](area);
  nwr[amenity=biergarten](area);
);
out;
"""

overpass_uri = "https://overpass-api.de/api/interpreter"

resp = Req.post!(overpass_uri, form: [data: overpass_query])

File.write!(Path.join(osm_dir, "export.osm"), resp.body)

database_config = Munch.Repo.config()

System.cmd("osm2pgsql", [
  "--style=#{Path.join(osm_dir, "style.lua")}",
  "--output=flex",
  "--schema=osm",
  "--database=#{database_config[:database]}",
  "--user=#{database_config[:username]}",
  "--host=#{database_config[:hostname]}",
  "--port=#{database_config[:port]}",
  Path.join(osm_dir, "export.osm")
])

Munch.Osm.copy_osm_restaurants()
