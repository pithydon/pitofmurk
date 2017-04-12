local modpath = minetest.get_modpath("murk")

minetest.register_abm({
	nodenames = {"murk:dirt"},
	neighbors = {"murk:dirt_with_grass"},
	interval = 8,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		if (minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z}) or 0) > 13 then
			minetest.swap_node(pos, {name = "murk:dirt_with_grass"})
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:dirt"},
	neighbors = {"murk:dirt_with_dry_grass"},
	interval = 10,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		if (minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z}) or 0) > 13 then
			minetest.swap_node(pos, {name = "murk:dirt_with_dry_grass"})
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:dirt"},
	neighbors = {"murk:dirt_with_leaf_grass"},
	interval = 9,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		if (minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z}) or 0) > 13 then
			minetest.swap_node(pos, {name = "murk:dirt_with_leaf_grass"})
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:dirt"},
	neighbors = {"murk:dirt_with_snow"},
	interval = 40,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		if (minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z}) or 0) > 13 then
			minetest.swap_node(pos, {name = "murk:dirt_with_snow"})
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:dirt_with_grass", "murk:dirt_with_dry_grass", "murk:dirt_with_leaf_grass"},
	interval = 6,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above, 0.5) or 0) < 10 and minetest.get_node_or_nil(above) then
			if node.name == "murk:dirt_with_grass" then
				minetest.swap_node(pos, {name = "murk:dirt_with_yellow_grass"})
			else
				minetest.swap_node(pos, {name = "murk:dirt"})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:dirt_with_yellow_grass"},
	interval = 6,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		local light = minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z}) or 0
		if light < 9 then
			minetest.swap_node(pos, {name = "murk:dirt"})
		elseif light > 13 then
			minetest.swap_node(pos, {name = "murk:dirt_with_grass"})
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:cobble", "murk:cobble_wall", "murk:cobble_slab", "murk:cobble_stair", "murk:cobble_stair_outer", "murk:cobble_stair_inner"},
	neighbors = {"murk:moss_cobble", "murk:moss_cobble_wall", "murk:moss_cobble_slab", "murk:moss_cobble_stair", "murk:moss_cobble_stair_outer", "murk:moss_cobble_stair_inner"},
	interval = 8,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local water = minetest.find_node_near(pos, 1, "group:water")
		local light = minetest.get_node_light(above) or 0
		if light == 0 then
			local pos = minetest.find_node_near(pos, 1, "air")
			if pos then
				light = minetest.get_node_light(pos) or 0
				light = light - 1
			end
		end
		if water and light < 13 and light > 5 then
			local above = minetest.get_node(above)
			if minetest.get_item_group(above.name, "water") == 0 then
				minetest.swap_node(pos, {name = node.name:gsub(":", ":moss_"), param2 = node.param2})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"murk:moss_cobble", "murk:moss_cobble_wall", "murk:moss_cobble_slab", "murk:moss_cobble_stair", "murk:moss_cobble_stair_outer", "murk:moss_cobble_stair_inner"},
	interval = 8,
	chance = 40,
	catch_up = false,
	action = function(pos, node)
		if (minetest.get_node_light({x = pos.x, y = pos.y + 1, z = pos.z}) or 0) > 13 then
			minetest.swap_node(pos, {name = node.name:gsub(":moss_", ":"), param2 = node.param2})
		end
	end
})

--[[
minetest.register_node("murk:schematic_helper", {
	description = "Used to help schematics set param1 and metadata",
	tiles = {"unknown_node.png"},
	groups = {not_in_creative_inventory = 1}
})

minetest.register_abm({
	nodenames = {"murk:schematic_helper"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		if node.param2 == 0 then
			minetest.swap_node(pos, {name = "murk:trunk_apple", param1 = 1})
		else
			minetest.remove_node(pos)
		end
	end
})
--]]
