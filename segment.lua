skyscraper.registered_segments = {}

function skyscraper.register_segment(name, def)
  if type(name) ~= "string" then error("name must be a string.") end
  if type(def.floor) ~= "string" then error("definition.floor must be a string.") end
  if type(def.floors) ~= "number" then error("definition.floors must be a number.") end
  if type(def.floor_height) ~= "number" then error("definition.floor_height must be a number.") end
  
  if skyscraper.registered_floors[def.floor] == nil then
    error("'"..def.floor.."' is not a registered floor.")
  end
  
  def.name = name
  def.offset = def.offset or {x=0,y=0,z=0}
  
  skyscraper.registered_segments[name] = def
end

function skyscraper.get_segment_height(segmentdef, floorindex)
  if type(segmentdef) == "string" then
    segmentdef = skyscraper.registered_segments(segmentdef)
  end
  
  if floorindex then
    return floorindex * segmentdef.floor_height
  else
   return segmentdef.floors * segmentdef.floor_height
  end
end