minetest.register_node("murk:stone", {
	description = "Stone",
	tiles = {"murk_stone.png"},
	groups = {pick = 2, pseudo_wall = 1},
	drop = "murk:cobble",
	stack_max = 32
})

minetest.register_node("murk:stone_brick", {
	description = "Stone Brick",
	tiles = {"murk_stone_brick_top.png", "murk_stone_brick_top.png", "murk_stone_brick_side.png"},
	groups = {pick = 2, pseudo_wall = 1},
	stack_max = 32
})

slabs.register_slab_and_stair("murk:stone_brick", {
	description = "Stone Brick",
	tiles = {"murk_stone_brick_top.png", "murk_stone_brick_top.png", "murk_stone_brick_side.png"},
	groups = {pick = 2},
	stack_max = 32
})

minetest.register_node("murk:cobble", {
	description = "Cobblestone",
	tiles = {"murk_cobble.png"},
	groups = {pick = 1, pseudo_wall = 1},
	stack_max = 64
})

minetest.register_node("murk:moss_cobble", {
	description = "Mossy Cobblestone",
	tiles = {"murk_moss_cobble.png"},
	groups = {pick = 1, pseudo_wall = 1},
	stack_max = 64
})

minetest.register_node("murk:rose_cobble", {
	description = "Rose Cobblestone",
	tiles = {"murk_rose_cobble.png"},
	groups = {pick = 1, pseudo_wall = 1},
	stack_max = 64
})

walls.register_wall("murk:cobble_wall", {
	description = "Cobblestone Wall",
	tiles = {"murk_cobble.png"},
	inventory_image = "murk_cobble_wall_inv.png",
	groups = {pick = 1},
	stack_max = 64
}, "murk:cobble")

walls.register_wall("murk:moss_cobble_wall", {
	description = "Mossy Cobblestone Wall",
	tiles = {"murk_moss_cobble.png"},
	inventory_image = "murk_moss_cobble_wall_inv.png",
	groups = {pick = 1},
	stack_max = 64
}, "murk:moss_cobble")

walls.register_wall("murk:rose_cobble_wall", {
	description = "Rose Cobblestone Wall",
	tiles = {"murk_rose_cobble.png"},
	inventory_image = "murk_rose_cobble_wall_inv.png",
	groups = {pick = 1},
	stack_max = 64
}, "murk:rose_cobble")

walls.register_pedestal("murk:cobble_pedestal", {
	description = "Cobblestone Pedestal",
	tiles = {"murk_cobble.png"},
	groups = {pick = 1},
	stack_max = 64
}, "murk:cobble_wall", "murk:cobble_slab")

slabs.register_slab_and_stair("murk:cobble", {
	description = "Cobblestone",
	tiles = {"murk_cobble.png"},
	groups = {pick = 1},
	stack_max = 64
})

slabs.register_slab_and_stair("murk:moss_cobble", {
	description = "Mossy Cobblestone",
	tiles = {"murk_moss_cobble.png"},
	groups = {pick = 1},
	stack_max = 64
})

minetest.register_node("murk:rose_bush", {
	description = "Rose Bush",
	drawtype = "allfaces_optional",
	paramtype = "light",
	tiles = {"murk_rose_bush.png"},
	groups = {sword = 1, hand = 3},
	stack_max = 64
})

minetest.register_node("murk:obsidian", {
	description = "Obsidian",
	tiles = {"murk_obsidian.png"},
	groups = {pick = 4},
	stack_max = 32
})

minetest.register_node("murk:brick", {
	description = "Bricks",
	tiles = {"murk_brick.png"},
	groups = {pick = 2, pseudo_wall = 1},
	stack_max = 64
})

walls.register_wall("murk:brick_wall", {
	description = "Brick Wall",
	tiles = {"murk_brick_wall_top.png", "murk_brick_wall_top.png", "murk_brick_wall_side.png"},
	inventory_image = "murk_brick_wall_inv.png",
	groups = {pick = 2},
	stack_max = 64
}, "murk:brick")

slabs.register_slab_and_stair("murk:brick", {
	description = "Brick",
	tiles = {"murk_brick.png"},
	groups = {pick = 2},
	stack_max = 64
})

minetest.register_node("murk:dirt", {
	description = "Dirt",
	tiles = {"murk_dirt.png"},
	groups = {shovel = 1, hand = 2, soil = 1},
	stack_max = 64
})

for _,v in ipairs({"grass", "yellow_grass", "dry_grass", "leaf_grass", "snow"}) do
	minetest.register_node("murk:dirt_with_"..v, {
		description = "Dirt with "..v:gsub("_", " "),
		tiles = {"murk_"..v..".png", "murk_dirt.png", {name = "murk_dirt.png^murk_"..v.."_side.png", tileable_vertical = false}},
		groups = {shovel = 1, hand = 2, soil = 1},
		drop = "murk:dirt",
		stack_max = 64
	})
end

for i=1,4 do
	local nce = 1
	if i == 1 then
		nce = 0
	end
	minetest.register_node("murk:grass_"..i, {
		description = "Grass",
		drawtype = "plantlike",
		paramtype = "light",
		paramtype2 = "meshoptions",
		place_param2 = 3,
		tiles = {"murk_grass_"..i..".png"},
		inventory_image = "murk_grass_3.png",
		wield_image = "murk_grass_4.png",
		drop = "murk:grass_1",
		waving = 1,
		walkable = false,
		buildable_to = true,
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}
		},
		groups = {sword = 1, hand = 1, not_in_creative_inventory = nce},
		stack_max = 64,
		after_place_node = function(pos)
			minetest.swap_node(pos, {name = "murk:grass_"..math.random(4), param2 = 3})
		end
	})
end

minetest.register_node("murk:gravel", {
	description = "Gravel",
	tiles ={"murk_gravel.png"},
	groups = {shovel = 2, hand = 3, falling_node = 1},
	stack_max = 64
})

minetest.register_node("murk:clay", {
	description = "Clay",
	tiles = {"murk_clay.png"},
	groups = {shovel = 1, hand = 2},
	drop = "murk:clay_lump 4",
	stack_max = 64
})

minetest.register_node("murk:sand", {
	description = "Sand",
	tiles = {"murk_sand.png"},
	groups = {shovel = 1, hand = 2, falling_node = 1},
	stack_max = 64
})

minetest.register_node("murk:sandstone", {
	description = "Sandstone",
	tiles = {"murk_sandstone.png"},
	groups = {pick = 1, hand = 4, pseudo_wall = 1},
	stack_max = 32
})

walls.register_wall("murk:sandstone_wall", {
	description = "Sandstone Wall",
	tiles = {"murk_sandstone.png"},
	inventory_image = "murk_sandstone_wall_inv.png",
	groups = {pick = 1, hand = 4,},
	stack_max = 32
}, "murk:sandstone")

slabs.register_slab_and_stair("murk:sandstone", {
	description = "Sandstone",
	tiles = {"murk_sandstone.png"},
	groups = {pick = 1, hand = 4,},
	stack_max = 32
})

minetest.register_node("murk:sandstone_brick", {
	description = "Sandstone Brick",
	tiles = {"murk_sandstone_brick_top.png", "murk_sandstone_brick_top.png", "murk_sandstone_brick_side.png"},
	groups = {pick = 1, pseudo_wall = 1},
	stack_max = 32
})

slabs.register_slab_and_stair("murk:sandstone_brick", {
	description = "Sandstone Brick",
	tiles = {"murk_sandstone_brick_top.png", "murk_sandstone_brick_top.png", "murk_sandstone_brick_side.png"},
	groups = {pick = 1},
	stack_max = 32
})

minetest.register_node("murk:snow", {
	description = "Snow",
	tiles = {"murk_snow.png"},
	groups = {shovel = 1, hand = 1, falling_node = 1, float = 1},
	stack_max = 64
})

minetest.register_node("murk:snow_brick", {
	description = "Snow Bricks",
	tiles = {"murk_snow_brick.png"},
	groups = {shovel = 1, pick = 2, hand = 2},
	stack_max = 64
})

walls.register_wall("murk:snow_brick_wall", {
	description = "Snow Brick Wall",
	tiles = {"murk_snow_brick_wall_top.png", "murk_snow_brick_wall_top.png", "murk_snow_brick_wall_side.png"},
	inventory_image = "murk_snow_brick_wall_inv.png",
	groups = {shovel = 1, pick = 2, hand = 2},
	connects_to = {"murk:snow_brick", "group:wall"},
	stack_max = 64
}, "murk:snow_brick")

slabs.register_slab_and_stair("murk:snow_brick", {
	description = "Snow Brick",
	tiles = {"murk_snow_brick.png"},
	groups = {shovel = 1, pick = 2, hand = 2},
	stack_max = 64
})

minetest.register_node("murk:water_source", {
	description = "Water",
	drawtype = "liquid",
	waving = 3,
	tiles = {{
		name = "murk_water_source_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2,
		}
	}},
	alpha = 191,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "murk:water_flowing",
	liquid_alternative_source = "murk:water_source",
	liquid_viscosity = 1,
	liquid_renewable = true,
	liquid_range = 8,
	post_effect_color = {a = 191, r = 42, g = 57, b = 117},
	groups = {water = 1},
})

minetest.register_node("murk:water_flowing", {
	description = "Flowing Water",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"murk_water.png"},
	special_tiles = {
		{
			name = "murk_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			}
		},
		{
			name = "murk_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1,
			}
		}
	},
	alpha = 191,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowning = 1,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "murk:water_flowing",
	liquid_alternative_source = "murk:water_source",
	liquid_viscosity = 1,
	liquid_renewable = true,
	liquid_range = 8,
	post_effect_color = {a = 191, r = 42, g = 57, b = 117},
	groups = {water = 1, not_in_creative_inventory = 1},
})

minetest.register_node("murk:river_water_source", {
	description = "River Water",
	drawtype = "liquid",
	waving = 3,
	tiles = {{
		name = "murk_water_source_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2,
		}
	}},
	alpha = 191,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "murk:river_water_flowing",
	liquid_alternative_source = "murk:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 8,
	post_effect_color = {a = 191, r = 42, g = 57, b = 117},
	groups = {water = 1},
})

minetest.register_node("murk:river_water_flowing", {
	description = "Flowing River Water",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"murk_water.png"},
	special_tiles = {
		{
		name = "murk_water_flowing_animated.png",
		backface_culling = false,
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1,
			}
		},
		{
		name = "murk_water_flowing_animated.png",
		backface_culling = false,
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1,
			}
		}
	},
	alpha = 191,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowning = 1,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "murk:river_water_flowing",
	liquid_alternative_source = "murk:river_water_source",
	liquid_viscosity = 1,
	liquid_renewable = false,
	liquid_range = 8,
	post_effect_color = {a = 191, r = 42, g = 57, b = 117},
	groups = {water = 1, not_in_creative_inventory = 1},
})

minetest.register_node("murk:lava_source", {
	description = "Lava",
	drawtype = "liquid",
	waving = 3,
	tiles = {{
		name = "murk_lava_source_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1,
		}
	}},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
	},
	paramtype = "light",
	light_source = 13,
	walkable = true,
	pointable = true,
	diggable = false,
	buildable_to = false,
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "murk:lava_flowing",
	liquid_alternative_source = "murk:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	liquid_range = 3,
	damage_per_second = 8,
	post_effect_color = {a = 255, r = 0, g = 0, b = 0},
	groups = {disable_jump = 1}
})

minetest.register_node("murk:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"murk_lava.png"},
	special_tiles = {
		{
		name = "murk_lava_flowing_animated.png",
		backface_culling = false,
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2,
			}
		},
		{
		name = "murk_lava_flowing_animated.png",
		backface_culling = false,
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 2,
			}
		}
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = 13,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drowning = 1,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "murk:lava_flowing",
	liquid_alternative_source = "murk:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	liquid_range = 3,
	damage_per_second = 8,
	post_effect_color = {a = 255, r = 0, g = 0, b = 0},
	groups = {not_in_creative_inventory = 1},
})

minetest.register_node("murk:magma", {
	description = "Magma",
	tiles = {{
		name = "murk_magma_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.3,
		}
	}},
	groups = {pick = 2},
	light_source = 8,
	stack_max = 32
})

minetest.register_node("murk:basalt", {
	description = "Basalt",
	tiles = {"murk_basalt_top.png", "murk_basalt_top.png", "murk_basalt_side.png"},
	groups = {pick = 2},
	stack_max = 32
})

minetest.register_node("murk:mossy_basalt", {
	description = "Mossy Basalt",
	tiles = {"murk_mossy_basalt_top.png", "murk_basalt_top.png", "murk_mossy_basalt_side.png"},
	groups = {pick = 2},
	stack_max = 32
})

panes.register_pane("murk:clay_pane", {
	description = "Clay Pane",
	tiles = {"murk_baked_clay.png"},
	inventory_image = "murk_baked_clay.png",
	groups = {pick = 1, hand = 1},
	stack_max = 64
})

minetest.register_node("murk:giant_clam", {
	description = "Giant Clam",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.25, -0.25, 0.25, 0.5},
			{-0.25, -0.5, -0.5, 0, 0.25, 0.25},
			{0, -0.5, -0.25, 0.25, 0.25, 0.5},
			{0.25, -0.5, -0.5, 0.5, 0.25, 0.25}
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.25, 0.5}
	},
	tiles = {"murk_giant_clam_top.png", "murk_sandstone.png", "murk_sandstone.png^murk_giant_clam_side.png",
			"murk_sandstone.png^murk_giant_clam_side.png", "murk_sandstone.png^murk_giant_clam_side_fb.png"},
	groups = {pick = 2, hand = 2},
	stack_max = 64
})

minetest.register_node("murk:rock", {
	description = "Rock",
	drawtype = "nodebox",
	paramtype = "light",
	tiles = {"murk_rock.png"},
	groups = {dig_immediate = 3, falling_node = 1},
	node_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, -0.25, 0.25}
	},
	stack_max = 64
})

minetest.register_node("murk:glow_rock", {
	description = "Glow Rock",
	drawtype = "nodebox",
	paramtype = "light",
	tiles = {"murk_glow_rock.png"},
	light_source = 8,
	groups = {dig_immediate = 3, falling_node = 1},
	node_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, -0.25, 0.25}
	},
	stack_max = 64
})

minetest.register_node("murk:glowstone", {
	description = "Glowstone",
	paramtype = "light",
	tiles = {"murk_glowstone.png"},
	light_source = 12,
	groups = {pick = 1, hand = 4, falling_node = 1},
	stack_max = 64
})

minetest.register_node("murk:reinforced_glowstone", {
	description = "Reinforced Glowstone",
	paramtype = "light",
	tiles = {"murk_reinforced_glowstone.png"},
	light_source = 11,
	groups = {pick = 1, hand = 4},
	stack_max = 64
})

minetest.register_node("murk:doomstone", {
	description = "Doomstone",
	tiles = {"murk_doomstone_top.png", "murk_doomstone_top.png", "murk_doomstone_side.png"},
	groups = {pick = 3},
	stack_max = 32
})

slabs.register_slab_and_stair("murk:doomstone", {
	description = "Doomstone",
	tiles = {"murk_doomstone_top.png", "murk_doomstone_top.png", "murk_doomstone_side.png"},
	groups = {pick = 3},
	stack_max = 32
})

walls.register_fence("murk:doomstone_fence", {
	description = "Doomstone Fence",
	tiles = {"murk_doomstone_top.png", "murk_doomstone_top.png", "murk_doomstone_fence.png"},
	inventory_image = "murk_doomstone_fence_inv.png",
	wield_image = "murk_doomstone_fence_wield.png",
	groups = {pick = 3},
	connects_to = {"murk:doomstone", "group:fence"},
	stack_max = 32
})

if minetest.setting_getbool("opaque_ice") ~= false then
	minetest.register_node("murk:ice", {
		description = "Ice",
		tiles = {"murk_ice.png"},
		paramtype = "light",
		groups = {pick = 1, slippery = 3},
		stack_max = 64
	})

	minetest.register_node("murk:fish_in_ice", {
		description = "Fish in Ice",
		tiles = {"murk_ice.png^murk_fish_in_ice.png"},
		paramtype = "light",
		groups = {pick = 1, slippery = 3},
		stack_max = 64
	})
else
	minetest.register_node("murk:ice", {
		description = "Ice",
		drawtype = "glasslike",
		tiles = {"murk_ice.png^[opacity:243"},
		use_texture_alpha = true,
		paramtype = "light",
		groups = {pick = 1, slippery = 3},
		stack_max = 64
	})

	minetest.register_node("murk:fish_in_ice", {
		description = "Fish in Ice",
		drawtype = "glasslike",
		tiles = {"murk_ice.png^[opacity:243^murk_fish_in_ice.png"},
		use_texture_alpha = true,
		paramtype = "light",
		groups = {pick = 1, slippery = 3},
		stack_max = 64
	})
end

minetest.register_node("murk:glass", {
	description = "Glass",
	drawtype = "glasslike_framed_optional",
	tiles = {"murk_glass.png", "murk_glass_detail.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {pick = 1, hand = 1},
	stack_max = 64
})

slabs.register_slab_and_stair("murk:glass", {
	description = "Glass",
	tiles = {"murk_glass.png", "murk_glass.png", "murk_glass_slab.png"},
	sunlight_propagates = true,
	groups = {pick = 1, hand = 1},
	stack_max = 64
}, {
	{{name = "murk_glass_slab.png", align_style = "node"}, {name = "murk_glass_slab.png", align_style = "node"},
			"murk_glass_stair.png", "murk_glass_stair.png", "murk_glass_slab.png"},
	{"murk_glass_stair.png"},
	{"murk_glass_stair.png"}
})

panes.register_mesh_pane("murk:glass_pane", {
	description = "Glass Pane",
	tiles = {"murk_glass.png", "murk_glass_edge.png"},
	inventory_image = "murk_glass.png",
	sunlight_propagates = true,
	groups = {pick = 1, hand = 1},
	stack_max = 64
})

doors.register_door("murk:glass_door", {
	description = "Glass Door",
	tiles = {"murk_glass_door.png"},
	inventory_image = "murk_glass_door_inv.png",
	mesh = "glass",
	sunlight_propagates = true,
	groups = {pick = 1, hand = 1},
	stack_max = 64
})

minetest.register_craftitem("murk:clay_lump", {
	description = "Clay Lump",
	inventory_image = "murk_clay_lump.png",
	wield_image = "murk_clay_lump.png",
	stack_max = 64
})

minetest.register_craftitem("murk:brick_item", {
	description = "Brick",
	inventory_image = "murk_brick_item.png",
	wield_image = "murk_brick_item.png",
	stack_max = 64
})

minetest.register_craft({
	output = "murk:rock 9",
	recipe = {
		{"murk:gravel"}
	}
})

minetest.register_craft({
	output = "murk:gravel",
	recipe = {
		{"murk:rock", "murk:rock", "murk:rock"},
		{"murk:rock", "murk:rock", "murk:rock"},
		{"murk:rock", "murk:rock", "murk:rock"}
	}
})

minetest.register_craft({
	output = "murk:clay_lump 4",
	recipe = {
		{"murk:clay"}
	}
})

minetest.register_craft({
	output = "murk:clay",
	recipe = {
		{"murk:clay_lump", "murk:clay_lump"},
		{"murk:clay_lump", "murk:clay_lump"}
	}
})

minetest.register_craft({
	output = "murk:brick_item 4",
	recipe = {
		{"murk:brick"}
	}
})

minetest.register_craft({
	output = "murk:brick",
	recipe = {
		{"murk:brick_item", "murk:brick_item"},
		{"murk:brick_item", "murk:brick_item"}
	}
})
