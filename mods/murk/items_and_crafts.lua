local fresh_node = {}
local remove_fresh = function(pos)
	for k,v in pairs(fresh_node) do
		if vector.equals(v, pos) then
			fresh_node[k] = nil
			break
		end
	end
end

for i,v in ipairs({"#9a9a9a", "#595959", "#a99994", "#766651", "#8b4b28", "#5d3f2a", "#c8c08e", "#5d5d4d", "#a1a4ae"}) do
	minetest.register_node("murk:stone_"..i, {
		description = "Stone",
		tiles = {"murk_stone.png^[multiply:"..v},
		groups = {pick = 2, pseudo_wall = 1},
		drop = "murk:stone_"..i.."_cobble",
		stack_max = 1024
	})

	minetest.register_node("murk:stone_"..i.."_cobble", {
		description = "Cobblestone",
		tiles = {"murk_stone_cobble.png^[multiply:"..v},
		groups = {pick = 1, pseudo_wall = 1},
		stack_max = 1024
	})

	minetest.register_node("murk:stone_"..i.."_cobble_mossy", {
		description = "Mossy Cobblestone",
		tiles = {"murk_stone_cobble.png^[multiply:"..v.."^murk_moss_cobble.png"},
		groups = {pick = 1, pseudo_wall = 1},
		stack_max = 1024
	})

	minetest.register_node("murk:stone_"..i.."_block", {
		description = "Stone Block",
		tiles = {"murk_stone_block.png^[multiply:"..v},
		groups = {pick = 1, pseudo_wall = 1},
		stack_max = 1024
	})

	minetest.register_node("murk:stone_"..i.."_brick", {
		description = "Stone Brick",
		paramtype2 = "facedir",
		tiles = {"murk_stone_brick.png^[multiply:"..v},
		groups = {pick = 1, pseudo_wall = 1},
		stack_max = 1024,
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local param2 = 0
			local under_node = minetest.get_node(under)
			local name_comp = under_node.name:split('_')
			if under.y == above.y and name_comp[1] == "murk:stone" and name_comp[3] == "brick" then
				param2 = under_node.param2
			else
				local pos = placer:get_pos()
				local x = pos.x - under.x
				local z = pos.z - under.z
				if math.abs(x) > math.abs(z) then
					param2 = 1
				end
			end
			return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
		end,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			fresh_node[placer:get_player_name()] = pos
			minetest.after(1, remove_fresh, pos)
		end,
		on_punch = function(pos, node, puncher, pointed_thing)
			local player_name = puncher:get_player_name()
			if fresh_node[player_name] and vector.equals(fresh_node[player_name], pos) then
				if node.param2 == 0 then
					minetest.swap_node(pos, {name = node.name, param2 = 1})
				else
					minetest.swap_node(pos, {name = node.name, param2 = 0})
				end
				fresh_node[player_name] = nil
			end
			return minetest.node_punch(pos, node, puncher, pointed_thing)
		end
	})

	minetest.register_node("murk:stone_"..i.."_tile", {
		description = "Stone Tile",
		paramtype2 = "color",
		palette = "murk_stone_palette_256.png",
		tiles = {{name = "murk_stone_tile.png", color = v}},
		overlay_tiles = {"murk_stone_tile_1.png", "murk_stone_tile_1.png", "murk_stone_tile_1.png", "murk_stone_tile_1.png", "murk_stone_tile_2.png"},
		groups = {pick = 1, pseudo_wall = 1},
		stack_max = 1024,
		on_place = function(itemstack, placer, pointed_thing)
			local meta = itemstack:get_meta()
			local param2 = meta:get("palette_index")
			if param2 == nil then
				param2 = i - 1
			end
			return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
		end
	})

	minetest.register_node("murk:stone_"..i.."_chiseled", {
		description = "Chiseled Stone",
		paramtype2 = "facedir",
		tiles = {"murk_stone_chiseled_top.png^[multiply:"..v, "murk_stone_chiseled_top.png^[multiply:"..v, "murk_stone_chiseled.png^[multiply:"..v},
		groups = {pick = 1},
		connect_sides = {"front", "left", "back", "right"},
		stack_max = 1024,
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local param2
			if under.y ~= above.y then
				param2 = 0
			elseif under.z ~= above.z then
				param2 = 4
			else
				param2 = 13
			end
			return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
		end
	})

	local rcolor = "#a99994"
	if i == 3 then rcolor = "#9a9a9a" end
	minetest.register_node("murk:stone_"..i.."_rock", {
		description = "Stone Rock",
		tiles = {"murk_stone.png^[multiply:"..v.."^(murk_stone_rock.png^[multiply:"..rcolor..")"},
		groups = {super_hand = 1, not_in_creative_inventory = 1},
		drop = ""
	})

	mini_blocks.register_all("murk:stone_"..i, {
		description = "Stone",
		tiles = {"murk_stone.png^[multiply:"..v},
		groups = {pick = 1}
	})

	mini_blocks.register_all("murk:stone_"..i.."_cobble", {
		description = "Cobblestone",
		tiles = {"murk_stone_cobble.png^[multiply:"..v},
		groups = {pick = 1}
	})

	mini_blocks.register_all("murk:stone_"..i.."_cobble_mossy", {
		description = "Mossy Cobblestone",
		tiles = {"murk_stone_cobble.png^[multiply:"..v.."^murk_moss_cobble.png"},
		groups = {pick = 1}
	})

	mini_blocks.register_slab("murk:stone_"..i.."_block_slab", {
		description = "Stone Block Slab",
		tiles = {"murk_stone_block.png^[multiply:"..v, "murk_stone_block.png^[multiply:"..v, "murk_stone_slab.png^[multiply:"..v},
		groups = {pick = 2}
	})

	mini_blocks.register_slab("murk:stone_"..i.."_brick_slab", {
		description = "Stone Brick Slab",
		tiles = {"murk_stone_brick.png^[multiply:"..v, "murk_stone_brick.png^[multiply:"..v, "murk_stone_slab.png^[multiply:"..v},
		groups = {pick = 2}
	})

	mini_blocks.register_stair("murk:stone_"..i.."_brick_stair", {
		description = "Stone Brick Stair",
		tiles = {{name = "murk_stone_brick.png^[multiply:"..v, align_style = "none"},
				{name = "murk_stone_brick.png^[multiply:"..v, align_style = "none"}, "murk_stone_brick.png^[multiply:"..v},
		groups = {pick = 2}
	})

	mini_blocks.register_step("murk:stone_"..i.."_brick_step", {
		description = "Stone Brick Step",
		tiles = {
			step = {{name = "murk_stone_slab.png^[multiply:"..v, align_style = "node"}, {name = "murk_stone_slab.png^[multiply:"..v, align_style = "node"},
					"murk_stone_tile.png^[multiply:"..v, "murk_stone_tile.png^[multiply:"..v, "murk_stone_slab.png^[multiply:"..v},
			step_outer = {"murk_stone_tile.png^[multiply:"..v},
			step_inner = {"murk_stone_block.png^[multiply:"..v, "murk_stone_block.png^[multiply:"..v, "murk_stone_tile.png^[multiply:"..v,
					"murk_stone_slab.png^[multiply:"..v, "murk_stone_slab.png^[multiply:"..v, "murk_stone_tile.png^[multiply:"..v}
		},
		groups = {pick = 2}
	})

	barrier.register_wall("murk:stone_"..i.."_cobble_wall", {
		description = "Cobblestone Wall",
		tiles = {"murk_stone_cobble.png^[multiply:"..v},
		groups = {pick = 1}
	})

	barrier.register_wall("murk:stone_"..i.."_cobble_mossy_wall", {
		description = "Mossy Cobblestone Wall",
		tiles = {"murk_stone_cobble.png^[multiply:"..v.."^murk_moss_cobble.png"},
		groups = {pick = 1}
	})

	barrier.register_wall("murk:stone_"..i.."_brick_wall", {
		description = "Stone Brick Wall",
		tiles = {
			wall = {{name = "murk_stone_pedestal.png^[multiply:"..v, align_style = "none"}, "murk_stone_brick.png^[multiply:"..v},
			column = {"murk_stone_brick.png^[multiply:"..v}
		},
		groups = {pick = 1}
	})

	countertop.register_pedestal("murk:stone_"..i.."_pedestal", {
		description = "Stone Pedestal",
		tiles = {"murk_stone.png^[multiply:"..v, "murk_stone.png^[multiply:"..v, "murk_stone_pedestal.png^[multiply:"..v},
		groups = {pick = 1},
		connects_to = {"murk:stone_"..i.."_brick_wall", "murk:stone_"..i.."_brick_wall_column", "murk:stone_"..i.."_pedestal"}
	})

	countertop.register_pedestal("murk:stone_"..i.."_cobble_pedestal", {
		description = "Cobblestone Pedestal",
		tiles = {"murk_stone_cobble.png^[multiply:"..v},
		groups = {pick = 1},
		connects_to = {
			"murk:stone_"..i.."_cobble_wall", "murk:stone_"..i.."_cobble_wall_column",
			"murk:stone_"..i.."_cobble_mossy_wall", "murk:stone_"..i.."_cobble_mossy_wall_column",
			"murk:stone_"..i.."_cobble_pedestal"
		}
	})

	countertop.register_pedestal("murk:stone_"..i.."_chiseled_pedestal", {
		description = "Chiseled Stone Pedestal",
		tiles = {"murk_stone_chiseled_top.png^[multiply:"..v, "murk_stone_chiseled_top.png^[multiply:"..v, "murk_stone_chiseled.png^[multiply:"..v},
		groups = {pick = 1},
		connects_to = {"murk:stone_"..i.."_chiseled", "murk:stone_"..i.."_chiseled_pedestal"}
	})
end

minetest.register_node("murk:rose_cobble", {
	description = "Rose Cobblestone",
	tiles = {"murk_stone_cobble.png^[multiply:#767676^murk_rose_bush.png"},
	groups = {pick = 1, pseudo_wall = 1},
	stack_max = 64
})

barrier.register_wall("murk:rose_cobble_wall", {
	description = "Rose Cobblestone Wall",
	tiles = {"murk_stone_cobble.png^[multiply:#767676^murk_rose_bush.png"},
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

barrier.register_wall("murk:brick_wall", {
	description = "Brick Wall",
	tiles = {"murk_brick_wall_top.png", "murk_brick_wall_top.png", "murk_brick_wall_side.png"},
	groups = {pick = 2},
	stack_max = 64
})

mini_blocks.register_all("murk:brick", {
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

barrier.register_wall("murk:sandstone_wall", {
	description = "Sandstone Wall",
	tiles = {"murk_sandstone.png"},
	groups = {pick = 1, hand = 4,},
	stack_max = 32
})

mini_blocks.register_all("murk:sandstone", {
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

mini_blocks.register_all("murk:sandstone_brick", {
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

barrier.register_wall("murk:snow_brick_wall", {
	description = "Snow Brick Wall",
	tiles = {"murk_snow_brick_wall_top.png", "murk_snow_brick_wall_top.png", "murk_snow_brick_wall_side.png"},
	groups = {shovel = 1, pick = 2, hand = 2},
	connects_to = {"murk:snow_brick", "group:wall", "group:wall_column"},
	stack_max = 64
})

mini_blocks.register_all("murk:snow_brick", {
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

mini_blocks.register_slab("murk:glass_slab", {
	description = "Glass",
	tiles = {"murk_glass.png", "murk_glass.png", "murk_glass_slab.png"},
	sunlight_propagates = true,
	groups = {pick = 1, hand = 1},
	stack_max = 64
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
