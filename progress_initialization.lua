skyscraper.progress = {}
skyscraper.progress.floors = {}
skyscraper.progress.segments = {}
skyscraper.progress.skyscrapers = {}

--creates an instance of a floor
function skyscraper.progress.create_floor(pos, skyscraperdef, segmentdef, segmentindex, floordef, floorindex)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments[segmentdef]
  end
  
  if type(floordef) == "string" then
    floordef = skyscraper.registered_floors[floordef]
  end
  
  --calculates the y position of where the floor will be placed at
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

--creates an instance of a segment
function skyscraper.progress.create_segment(pos, skyscraperdef, segmentdef, segmentindex)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments[segmentdef]
  end
  
  --calculates the height of the segment
  local segment_height = skyscraper.get_segment_height(segmentdef)
  --calculates the y position of the segment for reference
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
  
  --generates all the floors of the segment
  for i=1, segmentdef.floors do
    local floor_progress = skyscraper.progress.create_floor(pos, skyscraperdef, segmentdef, segmentindex, segmentdef.floor, i)
    table.insert(progress.floors, floor_progress)
  end
  
  table.insert(skyscraper.progress.segments[minetest.pos_to_string(pos)], progress)
  
  return progress
end

--create an instance of a skyscraper so it can be built
function skyscraper.progress.create_skyscraper(pos, skyscraperdef, angle)
  if type(skyscraperdef) == "string" then
    skyscraperdef = skyscraper.registered_skyscrapers[skyscraperdef]
  end
  
  --started implementing an angle feature but haven't started using it yet.
  --offsets will be calculated with angles.
  if type(angle) ~= "number" then
    angle = 0
  elseif angle ~= 0 and angle ~= 90 and angle ~= 180 and angle ~= 270 then
    error("'angle' can only be one of the following: 0, 90, 180, 270")
  end
  
  local progress = {
    name = skyscraperdef.name,
    position = pos,
    angle = angle,
    current_segment = 0,
    height = skyscraper.get_skyscraper_height(skyscraperdef),
    elapsed = 0,
    paused = false,
    completed = false
  }
  
  skyscraper.progress.skyscrapers[minetest.pos_to_string(pos)] = progress
  skyscraper.progress.segments[minetest.pos_to_string(pos)] = {}
  skyscraper.progress.floors[minetest.pos_to_string(pos)] = {}
  
  --generates all the segments of the skyscraper
  for i,v in ipairs(skyscraperdef.segments) do
    skyscraper.progress.create_segment(pos, skyscraperdef, v, i)
  end
  
  return progress
end