local timer = 0

local function count(t, ispairs)
  local count = 0
  if ispairs then
    for k,v in pairs(t) do
      count = count + 1
    end
  else
    for i, v in ipairs(t) do
      count = count + 1
    end
  end
  return count
end

local function save_skyscrapers()
  local skyscrapers = minetest.serialize(skyscraper.progress.skyscrapers)
  local segments = minetest.serialize(skyscraper.progress.segments)

  skyscraper.storage.set_string("skyscrapers", skyscrapers)
  skyscraper.storage.set_string("segments", segments)
end

local function load_skyscrapers()
  skyscraper.progress.skyscrapers = minetest.deserialize(skyscraper.storage.get_string("skyscrapers")) or {}
  skyscraper.progress.segments = minetest.deserialize(skyscraper.storage.get_string("segments")) or {}
  
  for skyscraperkey, segmentscollection in pairs(skyscraper.progress.segments) do
    skyscraper.progress.floors[skyscraperkey] = {}
    for i1, segmentprog in ipairs(segmentscollection) do
      for i2, floorprog in ipairs(segmentprog.floors) do
        table.insert(skyscraper.progress.floors[skyscraperkey], floorprog)
      end
    end
  end
end

--removes all existing progress tables for a skyscraper if a stage, floor, segment, or skyscraper is not registered.
local function remove_non_existing()
  --remove skyscraper then its segments and floors
  for skyscraperkey, skyscraperprog in pairs(skyscraper.progress.skyscrapers) do
    if not skyscraper.registered_skyscrapers[skyscraperprog.name] then
      skyscraper.progress.skyscrapers[skyscraperkey] = nil
      skyscraper.progress.segments[skyscraperkey] = nil
      skyscraper.progress.floors[skyscraperkey] = nil
      break
    end
  end
  
  --remove segment then its skyscraper and floors
  for skyscraperkey, segmentcollection in pairs(skyscraper.progress.segments) do
    for segmentindex, segmentprog in ipairs(segmentcollection) do
      if not skyscraper.registered_segments[segmentprog.name] then
        skyscraper.progress.skyscrapers[skyscraperkey] = nil
        skyscraper.progress.segments[skyscraperkey] = nil
        skyscraper.progress.floors[skyscraperkey] = nil
      end
    end
  end
  
  --remove floor then its skyscraper and segments
  for skyscraperkey, floorcollection in pairs(skyscraper.progress.floors) do
    for floorindex, floorprog in ipairs(floorcollection) do
      if not skyscraper.registered_floors[floorprog.name] then
        skyscraper.progress.skyscrapers[skyscraperkey] = nil
        skyscraper.progress.segments[skyscraperkey] = nil
        skyscraper.progress.floors[skyscraperkey] = nil
      end
    end
  end
  
  --remove all if stage doesnt exist
  for skyscraperkey, floorcollection in pairs(skyscraper.progress.floors) do
    for floorindex, floorprog in ipairs(floorcollection) do
      local floordef = skyscraper.registered_floors[floorprog.name]
      for i, v in ipairs(floordef.stages) do
        if not skyscraper.registered_stages[v] then
          skyscraper.progress.skyscrapers[skyscraperkey] = nil
          skyscraper.progress.segments[skyscraperkey] = nil
          skyscraper.progress.floors[skyscraperkey] = nil
        end
      end
    end
  end
end

minetest.register_globalstep(function(dtime)
  timer = timer + dtime
  
  if timer > 50 then
    save_skyscrapers()
  end
end)

minetest.register_on_shutdown(function()
  save_skyscrapers()
end)

minetest.register_on_mods_loaded(function()
  local error, message = pcall(function ()
    load_skyscrapers()
    remove_non_existing()
    
    --continue building unfinished skyscrapers
    for skyscraperkey, segmentcollection in pairs(skyscraper.progress.segments) do
      local skyscraperprog = skyscraper.progress.skyscrapers[skyscraperkey]
      for segmentindex, segmentprog in ipairs(segmentcollection) do
        for floorindex, floorprog in ipairs(segmentprog.floors) do
          if not floorprog.completed then
            local pos = skyscraperprog.position
            skyscraper.progress.start_building_floor(pos, segmentindex, floorindex)
          end
        end
      end
      
      if not skyscraperprog.completed then
        skyscraper.progress.start_building_skyscraper(skyscraperprog.position)
      end
    end
  end)
  
  if (message) then
    minetest.log(message)
  end
end)