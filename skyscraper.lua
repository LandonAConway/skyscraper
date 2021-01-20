skyscraper.registered_skyscrapers = {}

function skyscraper.register_skyscraper(name, def)
  if type(name) ~= "string" then error("name must be a string.") end
  if type(def.segments) ~= "table" then error("definition.segments must be a table.") end
  
  for i, v in ipairs(def.segments) do
    if skyscraper.registered_segments[v] == nil then
      error("'"..v.."' is not a registered floor.")
    end
  end
  
  def.name = name
  def.offset = def.offset or {x=0,y=0,z=0}
  def.container = def.container or {x=0,y=0,z=0}
  
  skyscraper.registered_skyscrapers[name] = def
end

local function doheight(skyscraperdef, segmentindex, floorindex)
  local count = 0
  local height = 0
  local lastsegment
  segmentindex = segmentindex or 65535
  
  for i,v in ipairs(skyscraperdef.segments) do
    count = count + 1
    if count <= segmentindex then
      local segmentdef = skyscraper.registered_segments[v]
      local segheight = skyscraper.get_segment_height(segmentdef)
      height = height + segheight
      lastsegment = segmentdef
    end
  end
  
  return count, height, lastsegment
end

function skyscraper.get_skyscraper_height(skyscraperdef, segmentindex, floorindex)
  if type(skyscraperdef) == "string" then
    segmentdef = skyscraper.registered_skyscrapers(skyscraperdef)
  end
  
  local count, height, lastsegment = doheight(skyscraperdef, segmentindex)
  
  if (floorindex) then
    local segheight = skyscraper.get_segment_height(lastsegment)
    local partialsegheight = skyscraper.get_segment_height(lastsegment, floorindex)
    height = (height - segheight) + partialsegheight
  end
  
  return height
end