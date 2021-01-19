skyscraper.progress = {}
skyscraper.progress.floors = {}
skyscraper.progress.segments = {}
skyscraper.progress.skyscrapers = {}

function skyscraper.progress.create_floor(pos, skyscraperdef, segmentdef, segmentindex, floordef, floorindex)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments[segmentdef]
  end
  
  if type(floordef) == "string" then
    floordef = skyscraper.registered_floors[floordef]
  end
  
  local floor_y = (skyscraper.get_skyscraper_height(skyscraperdef, segmentindex, floorindex - 1) + 1) + pos.y
  
  local progress = {
    name = floordef.name,
    index = floorindex,
    position = {x=pos.x, y=floor_y, z=pos.z},
    current_stage = 0,
    elapsed = 0,
    current_stage_elapsed = 0,
    completed = false
  }
  
  table.insert(skyscraper.progress.floors[minetest.pos_to_string(pos)], progress)
  
  return progress
end

function skyscraper.progress.create_segment(pos, skyscraperdef, segmentdef, segmentindex)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments[segmentdef]
  end
  
  local segment_height = skyscraper.get_segment_height(segmentdef)
  local segment_y = ((skyscraper.get_skyscraper_height(skyscraperdef, segmentindex) - segment_height) + 1) + pos.y
  
  local progress = {
    name = segmentdef.name,
    index = segmentindex,
    position = {x=pos.x, y=segment_y, z=pos.z},
    current_floor = 0,
    height = segment_height,
    elapsed = 0,
    completed = false,
    floors = {}
  }
  
  for i=1, segmentdef.floors do
    local floor_progress = skyscraper.progress.create_floor(pos, skyscraperdef, segmentdef, segmentindex, segmentdef.floor, i)
    table.insert(progress.floors, floor_progress)
  end
  
  table.insert(skyscraper.progress.segments[minetest.pos_to_string(pos)], progress)
  
  return progress
end

function skyscraper.progress.create_skyscraper(pos, skyscraperdef)
  if type(skyscraperdef) == "string" then
    skyscraperdef = skyscraper.registered_skyscrapers[skyscraperdef]
  end
  
  local progress = {
    name = skyscraperdef.name,
    position = pos,
    current_segment = 0,
    height = skyscraper.get_skyscraper_height(skyscraperdef),
    elapsed = 0,
    paused = false,
    completed = false
  }
  
  skyscraper.progress.skyscrapers[minetest.pos_to_string(pos)] = progress
  skyscraper.progress.segments[minetest.pos_to_string(pos)] = {}
  skyscraper.progress.floors[minetest.pos_to_string(pos)] = {}
  
  for i,v in ipairs(skyscraperdef.segments) do
    skyscraper.progress.create_segment(pos, skyscraperdef, v, i)
  end
  
  return progress
end