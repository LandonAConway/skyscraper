function skyscraper.progress.get_info(sckyscraperpos, segementindex, floorindex)
  local skyscraperkey = minetest.pos_to_string(sckyscraperpos)
  local skyscraperprog = skyscraper.progress.skyscrapers[skyscraperkey]
  local segmentprog = skyscraper.progress.segments[skyscraperkey][segementindex]
  local floorprog = segmentprog.floors[floorindex]
  
  return skyscraperkey, skyscraperprog, segmentprog, floorprog
end

--counts keys or indexes in a table
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

--gets the current segment progress of the given skyscraper progress
local function get_segment_prog(skyscraperprog)
  if skyscraperprog == nil then
    return nil
  end
  
  local skyscraperkey = minetest.pos_to_string(skyscraperprog.position)
  local segmentindex = skyscraperprog.current_segment
  local segmentprog = skyscraper.progress.segments[skyscraperkey][segmentindex]
  return segmentprog
end

--gets progress of the current floor of the given segment
local function get_floor_prog(skyscraperprog, segmentprog)
  if skyscraperprog == nil then
    return nil
  end
  
  local skyscraperkey = minetest.pos_to_string(skyscraperprog.position)
  local segmentindex = skyscraperprog.current_segment
  local segmentprog = skyscraper.progress.segments[skyscraperkey][segmentindex]
  
  if segmentprog ~= nil then
    local floorprog = segmentprog.floors[segmentprog.current_floor]
    return floorprog
  else
    return nil
  end
end

--builds the stage
function skyscraper.progress.build_stage(pos, segmentindex, floorindex)
  local skyscraperkey = minetest.pos_to_string(pos)
  local skyscraperprog = skyscraper.progress.skyscrapers[skyscraperkey]
  local segmentprog = skyscraper.progress.segments[skyscraperkey][segmentindex]
  local floorprog = segmentprog.floors[floorindex]
  
  local floordef = skyscraper.registered_floors[floorprog.name]
  local stagedef = skyscraper.registered_stages[floordef.stages[floorprog.current_stage]]
  
  if stagedef ~= nil then
    minetest.place_schematic(floorprog.position, stagedef.schematic, "0", nil, true)
  end
end

function skyscraper.progress.start_building_floor(pos, segmentindex, floorindex)
  minetest.register_globalstep(function(dtime)
    local v, message =pcall(function()
      local skyscraperkey = minetest.pos_to_string(pos)
      local skyscraperprog = skyscraper.progress.skyscrapers[skyscraperkey]
      
      --only continue with progress if the skyscraper progress is not paused
      if not skyscraperprog.paused then
        local segmentprog = skyscraper.progress.segments[skyscraperkey][segmentindex]
        local floorprog = segmentprog.floors[floorindex]
  
        local floordef = skyscraper.registered_floors[floorprog.name]
        local stagedef = skyscraper.registered_stages[floordef.stages[floorprog.current_stage]]
        
        --if stagedef is nil then current_stage needs to change, or there are no stages left
        if stagedef == nil then
          --if the current stage is greater than the maximum amount, then complete it.
          if floorprog.current_stage > count(floordef.stages) then
            if not floorprog.completed then
              floorprog.completed = true
            end
          --otherwise, current_stage is probably at 0 and needs to move up 1 so stagedef will not be nil on the next global step
          else
            floorprog.current_stage = floorprog.current_stage + 1
          end
        --if stagedef is not nil then we can use it
        else
          --build the stage if it is time to do so
          if floorprog.current_stage_elapsed > stagedef.steps then
            floorprog.current_stage_elapsed = 0
            skyscraper.progress.build_stage(pos, segmentindex, floorindex)
            --increment current_stage so the next global step will get the next stage definition
            floorprog.current_stage = floorprog.current_stage + 1
          end
        end
        
        --increment the current_stage_elapsed
        floorprog.current_stage_elapsed = floorprog.current_stage_elapsed + dtime
      end
    end)
    
    if (message) then
      minetest.log(message)
    end
  end)
end

--elapses all the types of progress for every one that is not nil
local function elapse(dtime, skyscraperprog, segmentprog, floorprog)
  if skyscraperprog then
    skyscraperprog.elapsed = skyscraperprog.elapsed + dtime
  end
  if segmentprog then
    segmentprog.elapsed = segmentprog.elapsed + dtime
  end
  if floorprog then
    floorprog.elapsed = floorprog.elapsed + dtime
  end
end

--builds the skyscraper
function skyscraper.progress.start_building_skyscraper(pos)
  minetest.register_globalstep(function(dtime)
    local v, message =pcall(function()
      local skyscraperkey = minetest.pos_to_string(pos)
      local skyscraperprog = skyscraper.progress.skyscrapers[skyscraperkey]
      
      --only continue with progress if the skyscraper progress is not paused
      if not skyscraperprog.paused then
        local segmentprog = get_segment_prog(skyscraperprog)
        local floorprog = get_floor_prog(skyscraperprog, segmentprog)
      
        local skyscraperdef = skyscraper.registered_skyscrapers[(skyscraperprog or {name="_"}).name]
        local segmentdef = skyscraper.registered_segments[(segmentprog or {name="_"}).name]
        local floordef = skyscraper.registered_floors[(floorprog or {name="_"}).name]
      
        if segmentprog == nil then
          --if the current segment is higher than the maximum amount of segments then complete the skyscraper
          --if not, continue to up the current segment
          if skyscraperprog.current_segment > count(skyscraperdef.segments, false) then
            if not skyscraperprog.completed then
              --complete the skyscraper if it is not completed
              skyscraperprog.completed = true
            end
          else
            skyscraperprog.current_segment = skyscraperprog.current_segment + 1
          end
        else
          if floorprog == nil then
            --if the current floor is greater than the amount of floors defined by the type of segement then complete the segment
            --if not, continue to up the current floor
            if segmentprog.current_floor > segmentdef.floors then
              if not segmentprog.completed then
                --next segment
                skyscraperprog.current_segment = skyscraperprog.current_segment + 1
                segmentprog.completed = true
              end
            else
              segmentprog.current_floor = segmentprog.current_floor + 1
            end
          else
            --build the floor if it is time
            if floorprog.elapsed >= floordef.steps then
              --build the floor
              skyscraper.progress.start_building_floor(pos, skyscraperprog.current_segment, segmentprog.current_floor)
              --next floor
              segmentprog.current_floor = segmentprog.current_floor + 1
            end
          end
        end
        --elapse time for whatever is not nil. this makes other code clean and readable
        elapse(dtime, skyscraperprog, segmentprog, floorprog)
      end
    end)
    
    if message then
      minetest.log(message)
    end
  end)
end