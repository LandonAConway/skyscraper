skyscraper.register_stage("skyscraper:base", {
  schematic = schematics.floor1.base,
  steps = 1
})

skyscraper.register_stage("skyscraper:floor1_bottom_complete", {
  schematic = schematics.floor1.bottom_complete,
  steps = 20
})

skyscraper.register_stage("skyscraper:floor1_1", {
  schematic = schematics.floor1.stage1,
  steps = 1
})

skyscraper.register_stage("skyscraper:floor1_2", {
  schematic = schematics.floor1.stage2,
  steps = 10
})

skyscraper.register_stage("skyscraper:floor1_3", {
  schematic = schematics.floor1.stage3,
  steps = 30
})

skyscraper.register_stage("skyscraper:floor1_4", {
  schematic = schematics.floor1.stage4,
  steps = 20
})

skyscraper.register_stage("skyscraper:floor1_top_complete", {
  schematic = schematics.floor1.top_complete,
  steps = 20
})

skyscraper.register_floor("skyscraper:floor_base", {
  stages = {
    "skyscraper:base"
  },
  steps = 5,
  container = {x=17,y=4,y=17}
})

skyscraper.register_floor("skyscraper:floor0", {
  stages = {
    "skyscraper:floor1_1",
    "skyscraper:floor1_2",
    "skyscraper:floor1_3",
    "skyscraper:floor1_bottom_complete"
  },
  steps = 5,
  container = {x=17,y=4,y=17}
})

skyscraper.register_floor("skyscraper:floor1", {
  stages = {
    "skyscraper:floor1_1",
    "skyscraper:floor1_2",
    "skyscraper:floor1_3",
    "skyscraper:floor1_4"
  },
  steps = 5,
  container = {x=17,y=4,y=17}
})

skyscraper.register_floor("skyscraper:floor2", {
  stages = {
    "skyscraper:floor1_1",
    "skyscraper:floor1_2",
    "skyscraper:floor1_3",
    "skyscraper:floor1_top_complete"
  },
  steps = 5,
  container = {x=17,y=4,y=17}
})

skyscraper.register_segment("skyscraper:segment_base", {
  floor = "skyscraper:floor_base",
  floors = 1,
  floor_height = 1,
  container = {x=17,y=1,z=17}
})

skyscraper.register_segment("skyscraper:segment0", {
  floor = "skyscraper:floor0",
  floors = 1,
  floor_height = 4,
  container = {x=17,y=4,y=17}
})

skyscraper.register_segment("skyscraper:segment1", {
  floor = "skyscraper:floor1",
  floors = 35,
  floor_height = 4,
  container = {x=17,y=140,y=17}
})

skyscraper.register_segment("skyscraper:segment2", {
  floor = "skyscraper:floor2",
  floors = 1,
  floor_height = 4,
  container = {x=17,y=4,y=17}
})

skyscraper.register_skyscraper("skyscraper:sample", {
  segments = {
    "skyscraper:segment_base",
    "skyscraper:segment0",
    "skyscraper:segment1",
    "skyscraper:segment2"
  },
  container = {x=17,y=149,y=17}
})

minetest.register_craftitem("skyscraper:placer", {
  description = "Skyscraper Sample Placer",
  inventory_image = "placesc.png",
  
  on_place = function(itemstack, placer, pointed_thing)
    if pointed_thing.type == "node" then
      local pos = minetest.get_pointed_thing_position(pointed_thing, pointed_thing.above)
      pos = {x=pos.x,y=pos.y-1,z=pos.z}
      local prog = skyscraper.initialize_skyscraper(pos, "skyscraper:sample", 0, placer)
      skyscraper.start_building_skyscraper(pos)
      minetest.chat_send_all("Skyscraper placed at: "..minetest.pos_to_string(pos))
    end
  end
})