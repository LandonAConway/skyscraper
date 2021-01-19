skyscraper.registered_floors = {}

function skyscraper.register_floor(name, def)
  if type(name) ~= "string" then error("name must be a string.") end
  if type(def.stages) ~= "table" then error("definition.stages must be a table.") end
  if type(def.steps) ~= "number" then error("definition.steps must be a number.") end
  
  def.name = name
  def.offset = def.offset or {x=0,y=0,z=0}
  
  skyscraper.registered_floors[name] = def
end