skyscraper.storage = {}
local storage = minetest.get_mod_storage()

function skyscraper.storage.set_string(k,v)
  storage:set_string(k,v)
end

function skyscraper.storage.get_string(k)
  return storage:get_string(k)
end