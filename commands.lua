minetest.register_chatcommand("show_skyscrapers", {
  params = "",
  description = "Displays all placed skyscrapers by their mame and definition.",
  privs = { skyscraper_admin = true },
  func = function(name, param)
    local skyscrapers = skyscraper.progress.skyscrapers
    for skyscraperkey, skyscraperprog in pairs(skyscrapers) do
      local skyscraperdef = skyscraper.registered_skyscrapers[skyscraperprog.name]
      local position = minetest.pos_to_string(skyscraperprog.position)
      local description
      if skyscraperdef then
        description = skyscraperdef.description or "(No Description)"
      end
      minetest.chat_send_player(name, position.." | "..(description or "(Unknown)"))
    end
  end,
})

minetest.register_chatcommand("delete_skyscraper", {
  params = "<pos>",
  description = "Deletes a skyscraper by pos. This will not delete nodes.",
  privs = { skyscraper_admin = true },
  func = function(name, param)
    local pos
    pcall(function() 
      pos = minetest.string_to_pos(param)
    end)
    
    if pos then
      skyscraper.progress.delete_skyscraper(pos)
      return true, "Skyscraper deleted at: "..minetest.pos_to_string(pos)
    else
      return false, "Position is invalid."
    end
  end,
})

minetest.register_chatcommand("skyscraper_toggle", {
  params = "<pos>",
  description = "Pauses or resumes construction of a skyscraper.",
  privs = { skyscraper_admin = true },
  func = function(name, param)
    local pos
    pcall(function() 
      pos = minetest.string_to_pos(param)
    end)
    
    if pos then
      local skyscraperprog = skyscraper.progress.skyscrapers[minetest.pos_to_string(pos)]
      
      if skyscraperprog then
        local state
        if skyscraperprog.paused then
          state = "Resumed"
          skyscraperprog.paused = false
        else
          state = "Paused"
          skyscraperprog.paused = true
        end
        
        return true, "Skyscraper has been "..state.." at: "..minetest.pos_to_string(pos)
      end
      return false, "A skyscraper does not exist at this position."
    else
      return false, "Position is invalid."
    end
  end,
})