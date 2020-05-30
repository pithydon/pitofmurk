doors = {}

local creative = minetest.setting_getbool("creative_mode")

minetest.register_node("doors:door_top", {
	decription = "Don't allow nodes to be placed in doors",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"blank.png"},
	node_box = {
		type = "fixed",
		fixed = {0.45, -0.5, -0.05, 0.5, 0.5, 0.05}
	},
	pointable = false,
	groups = {not_in_creative_inventory = 1}
})

function doors.register_door(name, def, recipeitem)
	local tiles = {}
	for i,v in ipairs(def.tiles) do
		if type(v) == "string" then
			tiles[i] = {name = v, backface_culling = true}
		elseif v.backface_culling == nil then
			local texture = table.copy(v)
			texture.backface_culling = true
			tiles[i] = texture
		else
			tiles[i] = v
		end
	end
	local door_def = table.copy(def)
	door_def.drawtype = "mesh"
	door_def.paramtype = "light"
	door_def.paramtype2 = "facedir"
	door_def.tiles = tiles
	door_def.groups.door = 1
	door_def.on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local under_node = minetest.get_node(pointed_thing.under)
		local under_node_def = minetest.registered_nodes[under_node.name]
		if placer:get_player_control().sneak == false and under_node_def.on_rightclick then
			under_node_def.on_rightclick(pointed_thing.under, under_node, placer, itemstack, pointed_thing)
			return itemstack
		end
		local pos = pointed_thing.above
		if under_node_def.buildable_to then
			pos = pointed_thing.under
		elseif not minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to then
			return itemstack
		end
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local player_name = placer:get_player_name()
		if not minetest.registered_nodes[minetest.get_node(above).name].buildable_to or minetest.is_protected(pos, player_name) or minetest.is_protected(above, player_name) then
			return itemstack
		end
		local param2 = minetest.dir_to_facedir(vector.subtract(pos, placer:getpos()))
		local side_pos
		if param2 == 0 then
			side_pos = {x = pos.x + 1, y = pos.y, z = pos.z}
		elseif param2 == 1 then
			side_pos = {x = pos.x, y = pos.y, z = pos.z - 1}
		elseif param2 == 2 then
			side_pos = {x = pos.x - 1, y = pos.y, z = pos.z}
		else
			side_pos = {x = pos.x, y = pos.y, z = pos.z + 1}
		end
		local side_node = minetest.get_node(side_pos)
		if side_node.name == "air" or minetest.get_item_group(side_node.name, "door") > 0 then
			param2 = param2 + 2
			if param2 > 3 then
				param2 = param2 - 4
			end
		end
		minetest.set_node(above, {name = "doors:door_top", param2 = param2})
		minetest.set_node(pos, {name = name, param2 = param2})
		if not creative then
			itemstack:take_item()
		end
		return itemstack
	end
	door_def.on_destruct = function(pos)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
	end
	local door_in_def = table.copy(door_def)
	door_in_def.groups.not_in_creative_inventory = 1
	door_in_def.drop = def.drop or name
	door_in_def.on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = name, param2 = node.param2})
	end
	local door_out_def = table.copy(door_in_def)
	door_def.on_rightclick = function(pos, node, clicker)
		if node.param2 == minetest.dir_to_facedir(vector.subtract(pos, clicker:getpos())) then
			minetest.swap_node(pos, {name = name.."_in", param2 = node.param2})
		else
			minetest.swap_node(pos, {name = name.."_out", param2 = node.param2})
		end
	end
	if def.mesh then
		if def.mesh == "apple" then
			door_def.mesh = "doors_apple_door.obj"
			door_in_def.mesh = "doors_apple_door_in.obj"
			door_out_def.mesh = "doors_apple_door_out.obj"
		elseif def.mesh == "glass" then
			door_def.mesh = "doors_glass_door.obj"
			door_in_def.mesh = "doors_glass_door_in.obj"
			door_out_def.mesh = "doors_glass_door_out.obj"
		elseif def.mesh == "metal" then
			door_def.mesh = "doors_metal_door.obj"
			door_in_def.mesh = "doors_metal_door_in.obj"
			door_out_def.mesh = "doors_metal_door_out.obj"
		elseif def.mesh == "wood" then
			door_def.mesh = "doors_wood_door.obj"
			door_in_def.mesh = "doors_wood_door_in.obj"
			door_out_def.mesh = "doors_wood_door_out.obj"
		else
			door_def.mesh = def.mesh[1]
			door_in_def.mesh = def.mesh[2]
			door_out_def.mesh = def.mesh[3]
		end
	else
		door_def.mesh = "doors_door.obj"
		door_in_def.mesh = "doors_door_in.obj"
		door_out_def.mesh = "doors_door_out.obj"
	end
	door_def.collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.125, 0.5, 1.5, 0.125}
	}
	door_def.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.125, 0.5, 1.5, 0.125}
	}
	door_in_def.collision_box = {
		type = "fixed",
		fixed = {0.375, -0.5, -0.125, 0.5, 1.5, 0.6875}
	}
	door_in_def.selection_box = {
		type = "fixed",
		fixed = {0.25, -0.5, -0.125, 0.5, 1.5, 0.875}
	}
	door_out_def.collision_box = {
		type = "fixed",
		fixed = {0.375, -0.5, -0.6875, 0.5, 1.5, 0.128}
	}
	door_out_def.selection_box = {
		type = "fixed",
		fixed = {0.25, -0.5, -0.875, 0.5, 1.5, 0.128}
	}

	minetest.register_node(name, door_def)
	minetest.register_node(name.."_in", door_in_def)
	minetest.register_node(name.."_out", door_out_def)

	if recipeitem then
		minetest.register_craft({
			output = name,
			recipe = {
				{recipeitem, recipeitem},
				{recipeitem, recipeitem},
				{recipeitem, recipeitem}
			}
		})
	end
end

function doors.register_gate(name, def, recipeitem)
	local gate_def = table.copy(def)
	gate_def.drawtype = "nodebox"
	gate_def.paramtype = "light"
	gate_def.paramtype2 = "facedir"
	gate_def.connect_sides = {"left", "right"}
	if def.groups.wall == nil then
		gate_def.groups.wall = 1
	end
	if def.groups.fence == nil then
		gate_def.groups.fence = 1
	end
	if not def.connects_to then
		gate_def.connects_to = {"group:wall", "group:fence"}
	end
	local gate_open_def = table.copy(gate_def)
	gate_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.25, 0.5, 0.125},
			{0.25, -0.5, -0.125, 0.5, 0.5, 0.125},
			{-0.25, 0.125, -0.125, 0.25, 0.375, 0.125}
		}
	}
	gate_def.collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.25, 0.5, 1, 0.25}
	}
	gate_def.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.125, 0.5, 0.5, 0.125}
	}
	gate_def.on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = name.."_open", param2 = node.param2})
	end
	gate_open_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.25, 0.5, 0.125},
			{0.25, -0.5, -0.125, 0.5, 0.5, 0.125},
			{-0.5, 0.125, -0.625, -0.25, 0.375, -0.125}
		}
	}
	gate_open_def.collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.25, -0.375, 1, 0.25},
			{0.375, -0.5, -0.25, 0.5, 1, 0.25},
			{-0.5, 0, -0.5, -0.375, 0.5, -0.25}
		}
	}
	gate_open_def.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125},
			{-0.5, 0.125, -0.625, -0.25, 0.375, -0.125}
		}
	}
	gate_open_def.on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = name, param2 = node.param2})
	end
	gate_open_def.drop = def.drop or name
	gate_open_def.groups.not_in_creative_inventory = 1

	minetest.register_node(name, gate_def)
	minetest.register_node(name.."_open", gate_open_def)

	if recipeitem then
		minetest.register_craft({
			output = name,
			recipe = {{recipeitem, "tools:stick", recipeitem}}
		})
	end
end

minetest.register_lbm({
	name = "doors:remove_lonely_door_tops",
	nodenames = {"doors:door_top"},
	run_at_every_load = true,
	action = function(pos)
		local node = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
		if node and minetest.get_item_group(node.name, "door") == 0 then
			minetest.remove_node(pos)
		end
	end
})
