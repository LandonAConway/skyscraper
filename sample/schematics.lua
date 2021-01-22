schematics = {}
schematics.foundation = {}
schematics.floor0 = {}
schematics.floor1= {}
schematics.floor2 = {}

dofile(minetest.get_modpath("skyscraper") .. "/sample/floor0_stage7.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage1.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage2.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage3.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage4.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage5.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage6.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor1_stage7.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/floor2_stage7.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/foundation_stage1.lua")
dofile(minetest.get_modpath("skyscraper") .. "/sample/foundation_stage2.lua")

schematics.floor0.stage1 = schematics.floor1.stage1
schematics.floor0.stage2 = schematics.floor1.stage2
schematics.floor0.stage3 = schematics.floor1.stage3
schematics.floor0.stage4 = schematics.floor1.stage4
schematics.floor0.stage5 = schematics.floor1.stage5
schematics.floor0.stage6 = schematics.floor1.stage6

schematics.floor2.stage1 = schematics.floor1.stage1
schematics.floor2.stage2 = schematics.floor1.stage2
schematics.floor2.stage3 = schematics.floor1.stage3
schematics.floor2.stage4 = schematics.floor1.stage4
schematics.floor2.stage5 = schematics.floor1.stage5
schematics.floor2.stage6 = schematics.floor1.stage6