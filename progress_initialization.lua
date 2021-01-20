skyscraper.progress = {}
skyscraper.progress.floors = {}
skyscraper.progress.segments = {}
skyscraper.progress.skyscrapers = {}

local function get_angle(x, y)
  if x >= 0 and y >= 0 then
    return 0
  elseif x >= 0 and y < 0 then
    return 90
  elseif x < 0 and y < 0 then
    return 180
  elseif x < 0 and y >= 0 then
    return 270
  end
end

local function rotate90(x, y)
  if get_angle(x, y) == 0 then
    return x, 0-y
  elseif get_angle(x, y) == 90 then
    return 0-x, y
  elseif get_angle(x, y) == 180 then
    return x, y*(-1)
  elseif get_angle(x, y) == 270 then
    return x*(-1), y
  end
end

local function rotate(x, y, angle)
  if angle == 0 then
    return x, y
  elseif angle == 90 then
    return rotate90(x, y)
  elseif angle == 180 then
    return rotate90(rotate90(x,y))
  elseif angle == 270 then
    return rotate90(rotate90(rotate90(x,y)))
  else
    return x,y
  end
end

--creates an instance of a floor
function skyscraper.progress.create_floor(pos, skyscraperdef, segmentdef, segmentindex, floordef, floorindex, angle)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments[segmentdef]
  end
  
  if type(floordef) == "string" then
    floordef = skyscraper.registered_floors[floordef]
  end
  
  --calculates the y position of where the floor will be placed at
  local floor_y = (skyscraper.get_skyscraper_height(skyscraperdef, segmentindex, floorindex - 1) + 1) + pos.y
  --calculates offset rotation
  local offsetx, offsetz = rotate(skyscraperdef.offset.y + segmentdef.offset.y + floordef.offset.x, 
    skyscraperdef.offset.z + segmentdef.offset.z + floordef.offset.z, angle)
  local offset = {
    x = offsetx,
    y = skyscraperdef.offset.y + segmentdef.offset.y + floordef.offset.y,
    z = offsetz
  }
  
  local progress = {
    name = floordef.name,
    index = floorindex,
    position = {x=pos.x, y=floor_y, z=pos.z},
    actual_position = {x=pos.x + offset.x, y=floor_y + offset.y, z=pos.z + offset.z},
    current_stage = 0,
    elapsed = 0,
    current_stage_elapsed = 0,
    built = false,
    completed = false
  }
  
  table.insert(skyscraper.progress.floors[minetest.pos_to_string(pos)], progress)
  
  return progress
end

--creates an instance of a segment
function skyscraper.progress.create_segment(pos, skyscraperdef, segmentdef, segmentindex, angle)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments[segmentdef]
  end
  
  --calculates the height of the segment
  local segment_height = skyscraper.get_segment_height(segmentdef)
  --calculates the y position of the segment for reference
  local segment_y = ((skyscraper.get_skyscraper_height(skyscraperdef, segmentindex) - segment_height) + 1) + pos.y
  --calculates offset rotation
  local offsetx, offsetz = rotate(skyscraperdef.offset.x + segmentdef.offset.x,
    skyscraperdef.offset.z + segmentdef.offset.z, angle)
  local offset = {
    x = offsetx,
    y = skyscraperdef.offset.y + segmentdef.offset.y,
    z = offsetz
  }
  
  local progress = {
    name = segmentdef.name,
    index = segmentindex,
    position = {x=pos.x, y=segment_y, z=pos.z},
    actual_position = {x=pos.x + offset.x, y=segment_y + offset.y, z=pos.z + offset.z},
    current_floor = 0,
    height = segment_height,
    elapsed = 0,
    started = false,
    built = false,
    completed = false,
    floors = {}
  }
  
  --generates all the floors of the segment
  for i=1, segmentdef.floors do
    local floor_progress = skyscraper.progress.create_floor(pos, skyscraperdef, segmentdef, segmentindex, segmentdef.floor, i, angle)
    table.insert(progress.floors, floor_progress)
  end
  
  table.insert(skyscraper.progress.segments[minetest.pos_to_string(pos)], progress)
  
  return progress
end

--create an instance of a skyscraper so it can be built
function skyscraper.progress.create_skyscraper(pos, skyscraperdef, angle, player)
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
  
  --calculates offset rotation
  local offsetx, offsetz = rotate(skyscraperdef.offset.x, skyscraperdef.offset.z, angle)
  local offset = {
    x = offsetx,
    y = skyscraperdef.offset.y,
    z = offsetz
  }
  
  --Keeping reference to how an offset could potentally be calculated. + = add, wheras - = subtract.
  --0 -> ++
  --90 -> +-
  --180 -> --
  --270 -> -+
  
  local progress = {
    name = skyscraperdef.name,
    position = pos,
    actual_position = {x=pos.x + offset.x, y=pos.y + offset.y, z=offset.z + pos.z},
    angle = angle,
    current_segment = 0,
    height = skyscraper.get_skyscraper_height(skyscraperdef),
    elapsed = 0,
    paused = false,
    built = false,
    completed = false
  }
  
  skyscraper.progress.skyscrapers[minetest.pos_to_string(pos)] = progress
  skyscraper.progress.segments[minetest.pos_to_string(pos)] = {}
  skyscraper.progress.floors[minetest.pos_to_string(pos)] = {}
  
  --generates all the segments of the skyscraper
  for i,v in ipairs(skyscraperdef.segments) do
    skyscraper.progress.create_segment(pos, skyscraperdef, v, i, angle)
  end
  
  if type(skyscraperdef.initialized) == "function" then
    skyscraperdef.initialized(progress, player)
  end
  
  return progress
end

function skyscraper.initialize_skyscraper(pos, skyscraperdef, angle, player)
  return skyscraper.progress.create_skyscraper(pos, skyscraperdef, angle, player)
end