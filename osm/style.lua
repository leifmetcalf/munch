local restaurants = osm2pgsql.define_table({
  name = 'restaurants',
  ids = {
    type = 'any',
    type_column = 'osm_type',
    id_column = 'osm_id',
    create_index = 'unique',
  },
  columns = {
    { column = 'location', type = 'point'},
    { column = 'tags', type = 'jsonb' },
  }
})

local function process_object(object, point)
  restaurants:insert({
    location = point,
    tags = object.tags,
  })
end

function osm2pgsql.process_node(object)
  process_object(object, object:as_point())
end

function osm2pgsql.process_way(object)
  -- TODO: figure out why :as_polygon() fails on some closed ways
  process_object(object, object:as_polygon():centroid())
end

function osm2pgsql.process_relation(object)
  assert(object.tags.type == 'multipolygon')
  process_object(object, object:as_multipolygon():centroid())
end
