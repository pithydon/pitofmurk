minetest.register_alias("mapgen_stone", "murk:stone")
minetest.register_alias("mapgen_dirt", "murk:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "murk:dirt_with_grass")
minetest.register_alias("mapgen_sand", "murk:sand")
minetest.register_alias("mapgen_river_water_source", "murk:river_water_source")
minetest.register_alias("mapgen_water_source", "murk:water_source")
minetest.register_alias("mapgen_lava_source", "murk:lava_source")
minetest.register_alias("mapgen_gravel", "murk:gravel")
minetest.register_alias("mapgen_cobble", "murk:cobble")
minetest.register_alias("mapgen_stair_cobble", "murk:cobble_stair")
minetest.register_alias("mapgen_mossycobble", "murk:moss_cobble")

local modpath = minetest.get_modpath("mapgen")

minetest.register_biome({
	name = "murk:grassland",
	node_top = "murk:dirt_with_grass",
	depth_top = 1,
	node_filler = "murk:dirt",
	depth_filler = 3,
	node_riverbed = "murk:sand",
	depth_riverbed = 2,
	y_min = 5,
	y_max = 31000,
	heat_point = 50,
	humidity_point = 50,
})

minetest.register_biome({
	name = "murk:apple_orchard",
	node_top = "murk:dirt_with_grass",
	depth_top = 1,
	node_filler = "murk:dirt",
	depth_filler = 3,
	node_riverbed = "murk:sand",
	depth_riverbed = 2,
	y_min = 5,
	y_max = 3100,
	heat_point = 59,
	humidity_point = 60,
})

minetest.register_biome({
	name = "murk:fall",
	node_top = "murk:dirt_with_leaf_grass",
	depth_top = 1,
	node_filler = "murk:dirt",
	depth_filler = 3,
	node_riverbed = "murk:sand",
	depth_riverbed = 2,
	y_min = 10,
	y_max = 31000,
	heat_point = 40,
	humidity_point = 40,
})

minetest.register_biome({
	name = "murk:savanna",
	node_top = "murk:dirt_with_dry_grass",
	depth_top = 1,
	node_filler = "murk:dirt",
	depth_filler = 3,
	node_riverbed = "murk:sand",
	depth_riverbed = 2,
	y_min = 1,
	y_max = 31000,
	heat_point = 30,
	humidity_point = 25,
})


minetest.register_biome({
	name = "murk:tundra",
	node_top = "murk:dirt_with_snow",
	depth_top = 1,
	node_filler = "murk:dirt",
	depth_filler = 3,
	node_riverbed = "murk:sand",
	depth_riverbed = 2,
	y_min = 1,
	y_max = 31000,
	heat_point = 25,
	humidity_point = 50,
})

minetest.register_biome({
	name = "murk:woods",
	node_top = "murk:dirt_with_grass",
	depth_top = 1,
	node_filler = "murk:dirt",
	depth_filler = 3,
	node_riverbed = "murk:sand",
	depth_riverbed = 2,
	y_min = 1,
	y_max = 31000,
	heat_point = 60,
	humidity_point = 68,
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"murk:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.022,
		spread = {x = 250, y = 250, z = 250},
		seed = 418,
		octaves = 2,
		persist = 0.6
	},
	biomes = {"murk:apple_orchard"},
	y_min = 1,
	y_max = 31000,
	schematic = modpath.."/schematics/apple_tree.mts",
	flags = "place_center_x, place_center_z"
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"murk:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.005,
		scale = 0.022,
		spread = {x = 250, y = 250, z = 250},
		seed = 418,
		octaves = 2,
		persist = 0.6
	},
	biomes = {"murk:apple_orchard"},
	y_min = 1,
	y_max = 31000,
	schematic = modpath.."/schematics/apple_tree_apples.mts",
	flags = "place_center_x, place_center_z"
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"murk:dirt_with_dry_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.001,
		scale = 0.002,
		spread = {x = 250, y = 250, z = 250},
		seed = 418,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"murk:savanna"},
	y_min = 1,
	y_max = 31000,
	schematic = modpath.."/schematics/baobab_tree.mts",
	flags = "place_center_x, place_center_z"
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"murk:dirt_with_grass", "murk:dirt_with_leaf_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.022,
		spread = {x = 250, y = 250, z = 250},
		seed = 419,
		octaves = 2,
		persist = 0.6
	},
	biomes = {"murk:apple_orchard", "murk:fall", "murk:woods"},
	y_min = 1,
	y_max = 31000,
	schematic = modpath.."/schematics/oak_tree.mts",
	flags = "place_center_x, place_center_z"
})

minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"murk:dirt_with_leaf_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.002,
		scale = 0.022,
		spread = {x = 250, y = 250, z = 250},
		seed = 184,
		octaves = 2,
		persist = 0.6
	},
	biomes = {"murk:fall"},
	y_min = 1,
	y_max = 42,
	schematic = modpath.."/schematics/dead_oak_tree.mts",
	flags = "place_center_x, place_center_z"
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"murk:dirt_with_leaf_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.002,
		scale = 0.022,
		spread = {x = 250, y = 250, z = 250},
		seed = 184,
		octaves = 2,
		persist = 0.6
	},
	biomes = {"murk:fall"},
	y_min = 20,
	y_max = 31000,
	decoration = "trees:trunk_oak",
	height = 1,
	height_max = 3
})

for i=1,4 do
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"murk:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.05,
			scale = 0.09,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"murk:grassland", "murk:apple_orchard", "murk:woods"},
		y_min = 1,
		y_max = 31000,
		decoration = "murk:grass_"..i,
		param2 = 3
	})
end

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"murk:dirt_with_grass", "murk:dirt_with_dry_grass", "murk:dirt_with_leaf_grass", "murk:dirt_with_snow"},
	sidelen = 16,
	noise_params = {
		offset = -0.6,
		scale = 0.24,
		spread = {x = 150, y = 150, z = 150},
		seed = 329,
		octaves = 6.5,
		persist = 0.9
	},
	biomes = {"murk:grassland", "murk:apple_orchard", "murk:fall", "murk:savanna", "murk:tundra", "murk:woods"},
	y_min = 1,
	y_max = 31000,
	decoration = "murk:rock"
})
