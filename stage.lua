skyscraper.registered_stages = {}

function skyscraper.register_stage(name, def)
  if type(name) ~= "string" then error("name must be a string.") end
  if type(def.steps) ~= "number" then error("definition.steps must be a number.") end
  if type(def.schematic) ~= "table" then error("definition.schematic must be a table.") end
  
  def.name = name
  def.offset = def.offset or {x=0,y=0,z=0}
  def.container = def.container or {x=0,y=0,z=0}
  
  skyscraper.registered_stages[name] = def
end