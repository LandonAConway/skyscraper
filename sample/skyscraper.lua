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
  steps = 5
})

skyscraper.register_floor("skyscraper:floor0", {
  stages = {
    "skyscraper:floor1_1",
    "skyscraper:floor1_2",
    "skyscraper:floor1_3",
    "skyscraper:floor1_bottom_complete"
  },
  steps = 5
})

skyscraper.register_floor("skyscraper:floor1", {
  stages = {
    "skyscraper:floor1_1",
    "skyscraper:floor1_2",
    "skyscraper:floor1_3",
    "skyscraper:floor1_4"
  },
  steps = 5
})

skyscraper.register_floor("skyscraper:floor2", {
  stages = {
    "skyscraper:floor1_1",
    "skyscraper:floor1_2",
    "skyscraper:floor1_3",
    "skyscraper:floor1_top_complete"
  },
  steps = 5
})

skyscraper.register_segment("skyscraper:segment_base", {
  floor = "skyscraper:floor_base",
  floors = 1,
  floor_height = 1
})

skyscraper.register_segment("skyscraper:segment0", {
  floor = "skyscraper:floor0",
  floors = 1,
  floor_height = 4
})

skyscraper.register_segment("skyscraper:segment1", {
  floor = "skyscraper:floor1",
  floors = 35,
  floor_height = 4
})

skyscraper.register_segment("skyscraper:segment2", {
  floor = "skyscraper:floor2",
  floors = 1,
  floor_height = 4
})

skyscraper.register_skyscraper("skyscraper:sample", {
  segments = {
    "skyscraper:segment_base",
    "skyscraper:segment0",
    "skyscraper:segment1",
    "skyscraper:segment2"
  }
})

minetest.register_craftitem("skyscraper:placer", {
  description = "Skyscraper Sample Placer",
  inventory_image = "placesc.png",
  
  on_place = function(itemstack, placer, pointed_thing)
    if pointed_thing.type == "node" then
      local pos = minetest.get_pointed_thing_position(pointed_thing, pointed_thing.above)
      local prog = skyscraper.progress.create_skyscraper(pos, "skyscraper:sample")
      skyscraper.progress.start_building_skyscraper(pos)
      minetest.chat_send_all("Skyscraper placed at: "..minetest.pos_to_string(pos))
    end
  end
})