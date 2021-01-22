skyscraper.register_stage("skyscraper:floor0_stage7", {
  schematic = schematics.floor0.stage7,
  steps = 10
})

skyscraper.register_stage("skyscraper:floor1_stage1", {
  schematic = schematics.floor1.stage1,
  steps = 1
})

skyscraper.register_stage("skyscraper:floor1_stage2", {
  schematic = schematics.floor1.stage2,
  steps = 15
})

skyscraper.register_stage("skyscraper:floor1_stage3", {
  schematic = schematics.floor1.stage3,
  steps = 15
})

skyscraper.register_stage("skyscraper:floor1_stage4", {
  schematic = schematics.floor1.stage4,
  steps = 490
})

skyscraper.register_stage("skyscraper:floor1_stage5", {
  schematic = schematics.floor1.stage5,
  steps = 20
})

skyscraper.register_stage("skyscraper:floor1_stage6", {
  schematic = schematics.floor1.stage6,
  steps = 20
})

skyscraper.register_stage("skyscraper:floor1_stage7", {
  schematic = schematics.floor1.stage7,
  steps = 115
})

skyscraper.register_stage("skyscraper:floor2_stage7", {
  schematic = schematics.floor2.stage7,
  steps = 15
})

skyscraper.register_stage("skyscraper:foundation_stage1", {
  schematic = schematics.foundation.stage1,
  steps = 1
})

skyscraper.register_stage("skyscraper:foundation_stage2", {
  schematic = schematics.foundation.stage2,
  steps = 705
})

skyscraper.register_floor("skyscraper:floor_foundation", {
  stages = {
    "skyscraper:foundation_stage1",
    "skyscraper:foundation_stage2"
  },
  steps = 15,
  container = {x=29,y=4,y=29}
})

skyscraper.register_floor("skyscraper:floor0", {
  stages = {
    "skyscraper:floor1_stage1",
    "skyscraper:floor1_stage2",
    "skyscraper:floor1_stage3",
    "skyscraper:floor1_stage4",
    "skyscraper:floor1_stage5",
    "skyscraper:floor1_stage6",
    "skyscraper:floor0_stage7"
  },
  steps = 15,
  container = {x=29,y=4,y=29}
})

skyscraper.register_floor("skyscraper:floor1", {
  stages = {
    "skyscraper:floor1_stage1",
    "skyscraper:floor1_stage2",
    "skyscraper:floor1_stage3",
    "skyscraper:floor1_stage4",
    "skyscraper:floor1_stage5",
    "skyscraper:floor1_stage6",
    "skyscraper:floor1_stage7"
  },
  steps = 15,
  container = {x=29,y=4,y=29}
})

skyscraper.register_floor("skyscraper:floor2", {
  stages = {
    "skyscraper:floor1_stage1",
    "skyscraper:floor1_stage2",
    "skyscraper:floor1_stage3",
    "skyscraper:floor1_stage4",
    "skyscraper:floor1_stage5",
    "skyscraper:floor1_stage6",
    "skyscraper:floor2_stage7"
  },
  steps = 15,
  container = {x=29,y=4,y=29}
})

skyscraper.register_segment("skyscraper:segment_foundation", {
  floor = "skyscraper:floor_foundation",
  floors = 1,
  floor_height = 1,
  container = {x=29,y=1,z=29}
})

skyscraper.register_segment("skyscraper:segment0", {
  floor = "skyscraper:floor0",
  floors = 1,
  floor_height = 4,
  container = {x=29,y=4,y=29}
})

skyscraper.register_segment("skyscraper:segment1", {
  floor = "skyscraper:floor1",
  floors = 35,
  floor_height = 4,
  container = {x=29,y=140,y=29}
})

skyscraper.register_segment("skyscraper:segment2", {
  floor = "skyscraper:floor2",
  floors = 1,
  floor_height = 4,
  container = {x=29,y=4,y=29}
})

skyscraper.register_skyscraper("skyscraper:sample", {
  description = "Sample Skyscraper",
  segments = {
    "skyscraper:segment_foundation",
    "skyscraper:segment0",
    "skyscraper:segment1",
    "skyscraper:segment2"
  },
  container = {x=29,y=149,y=29}
})

minetest.register_craftitem("skyscraper:sample_placer", {
  description = "Skyscraper Sample Placer",
  inventory_image = "skyscraper_sample.png",
  
  on_place = function(itemstack, placer, pointed_thing)
    if pointed_thing.type == "node" then
      local pos = minetest.get_pointed_thing_position(pointed_thing, pointed_thing.above)
      pos = {x=pos.x,y=pos.y-1,z=pos.z}
      
      skyscraper.initialize_skyscraper(pos, "skyscraper:sample", 0, placer)
      skyscraper.start_building_skyscraper(pos)
      
      minetest.chat_send_player(placer:get_player_name(), "Skyscraper placed at: "..minetest.pos_to_string(pos))
    end
  end
})