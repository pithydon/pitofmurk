barrier = {}

local tile_mod = function(tiles)
	local out = {}
	for i,v in ipairs(tiles) do
		if type(v) == "string" then
			out[i] = {name = v, align_style = "user"}
		elseif v.align_style == nil then
			local tile = table.copy(v)
			tile.align_style = "user"
			out[i] = tile
		else
			out[i] = v
		end
	end
	return out
end

local get_connected_sides = function(pos, node)
	local connected_sides = 0
	local node_def = minetest.registered_nodes[node.name]
	if node_def then
		local connect_nodes = {}
		local connect_groups = {}
		if node_def.connects_to then
			for _,v in ipairs(node_def.connects_to) do
				if v:split(':')[1] == "group" then
					table.insert(connect_groups, v:split(':')[2])
				else
					table.insert(connect_nodes, v)
				end
			end
		end
		for i,v in ipairs({{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z},
				{x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}) do
			local side_node = minetest.get_node_or_nil(v)
			if side_node then
				local side_node_def = minetest.registered_nodes[side_node.name]
				if side_node_def then
					local var = false
					for _,v in ipairs(connect_nodes) do
						if side_node.name == v then
							var = true
							break
						end
					end
					if not var then
						for _,v in ipairs(connect_groups) do
							if minetest.get_item_group(side_node.name, v) > 0 then
								var = true
								break
							end
						end
					end
					if var then
						local side_connect_nodes = {}
						local side_connect_groups = {}
						if side_node_def.connects_to then
							for _,v in ipairs(side_node_def.connects_to) do
								if v:split(':')[1] == "group" then
									table.insert(side_connect_groups, v:split(':')[2])
								else
									table.insert(side_connect_nodes, v)
								end
							end
							for _,v in ipairs(side_connect_nodes) do
								if node.name == v then
									if i == 4 then
										connected_sides = connected_sides + 8
									elseif i == 3 then
										connected_sides = connected_sides + 4
									else
										connected_sides = connected_sides + i
									end
									var = false
									break
								end
							end
							if var then
								for _,v in ipairs(side_connect_groups) do
									if minetest.get_item_group(node.name, v) > 0 then
										if i == 4 then
											connected_sides = connected_sides + 8
										elseif i == 3 then
											connected_sides = connected_sides + 4
										else
											connected_sides = connected_sides + i
										end
										break
									end
								end
							end
						else
							if i == 4 then
								connected_sides = connected_sides + 8
							elseif i == 3 then
								connected_sides = connected_sides + 4
							else
								connected_sides = connected_sides + i
							end
						end
					end
				end
			end
		end
	end
	return connected_sides
end

function barrier.register_wall(name, def)
	local wall_def = table.copy(def)
	wall_def.drawtype = "nodebox"
	wall_def.paramtype = "light"
	wall_def.collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 1, 0.5}
	}
	wall_def.connects_to = def.connects_to or {"group:wall", "group:wall_column", "group:pseudo_wall"}
	wall_def.update_wall = function(pos)
		local connected = get_connected_sides(pos, {name = name})
		if connected == 5 then
			minetest.swap_node(pos, {name = name, param2 = 1})
		elseif connected == 10 then
			minetest.swap_node(pos, {name = name, param2 = 0})
		else
			minetest.swap_node(pos, {name = name.."_column"})
		end
	end
	wall_def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if digger:get_player_control().sneak == false then
			for _,v in ipairs({{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z},
					{x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}) do
				local node_def = minetest.registered_nodes[minetest.get_node(v).name]
				if node_def and node_def.update_wall then
					node_def.update_wall(v)
				end
			end
		end
	end
	wall_def.stack_max = def.stack_max or 1024
	local wall_column_def = table.copy(wall_def)
	if def.tiles.wall then
		wall_def.tiles = tile_mod(def.tiles.wall)
		wall_column_def.tiles = def.tiles.column
	else
		wall_def.tiles = tile_mod(def.tiles)
	end
	wall_def.paramtype2 = "facedir"
	wall_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.25, 0.5, 0.5, 0.25}
	}
	wall_def.groups.wall = 1
	wall_def.connect_sides = {"top", "bottom", "left", "right"}
	wall_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		if placer:get_player_control().sneak == true then
			minetest.swap_node(pos, {name = name.."_column"})
		else
			local connected = get_connected_sides(pos, {name = name})
			if connected == 5 then
				minetest.swap_node(pos, {name = name, param2 = 1})
			elseif connected == 10 then
				minetest.swap_node(pos, {name = name, param2 = 0})
			else
				minetest.swap_node(pos, {name = name.."_column"})
			end
			for _,v in ipairs({{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z},
					{x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}) do
				local node_def = minetest.registered_nodes[minetest.get_node(v).name]
				if node_def and node_def.update_wall then
					node_def.update_wall(v)
				end
			end
		end
	end
	wall_column_def.node_box = {
		type = "connected",
		connect_top = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 0.5, -0.3125},
		connect_left = {-0.5, -0.5, -0.25, -0.3125, 0.5, 0.25},
		connect_back = {-0.25, -0.5, 0.3125, 0.25, 0.5, 0.5},
		connect_right = {0.3125, -0.5, -0.25, 0.5, 0.5, 0.25},
		disconnected_top = {-0.3125, -0.5, -0.3125, 0.3125, 0.6875, 0.3125}
	}
	wall_column_def.selection_box = {
		type = "connected",
		fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 0.5, -0.3125},
		connect_left = {-0.5, -0.5, -0.25, -0.3125, 0.5, 0.25},
		connect_back = {-0.25, -0.5, 0.3125, 0.25, 0.5, 0.5},
		connect_right = {0.3125, -0.5, -0.25, 0.5, 0.5, 0.25}
	}
	wall_column_def.groups.wall_column = 1
	wall_column_def.groups.not_in_creative_inventory = 1
	wall_column_def.drop = def.drop or name

	minetest.register_node(name, wall_def)
	minetest.register_node(name.."_column", wall_column_def)
end

function barrier.register_fence(name, def)
	local fence_def = table.copy(def)
	fence_def.drawtype = "nodebox"
	fence_def.paramtype = "light"
	fence_def.node_box = {
		type = "connected",
		fixed = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
		connect_front = {{-0.125, 0.125, -0.5, 0.125, 0.375, -0.1875}, {-0.125, -0.375, -0.5, 0.125, -0.125, -0.1875}},
		connect_left = {{-0.5, 0.125, -0.125, -0.1875, 0.375, 0.125}, {-0.5, -0.375, -0.125, -0.1875, -0.125, 0.125}},
		connect_back = {{-0.125, 0.125, 0.1875, 0.125, 0.375, 0.5}, {-0.125, -0.375, 0.1875, 0.125, -0.125, 0.5}},
		connect_right = {{0.1875, 0.125, -0.125, 0.5, 0.375, 0.125}, {0.1875, -0.375, -0.125, 0.5, -0.125, 0.125}}
	}
	fence_def.collision_box = {
		type = "connected",
		fixed = {-0.25, -0.5, -0.25, 0.25, 1, 0.25},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 1, -0.25},
		connect_left = {-0.5, -0.5, -0.25, -0.25, 1, 0.25},
		connect_back = {-0.25, -0.5, 0.25, 0.25, 1, 0.5},
		connect_right = {0.25, -0.5, -0.25, 0.5, 1, 0.25}
	}
	if def.groups.fence == nil then
		fence_def.groups.fence = 1
	end
	fence_def.connects_to = def.connects_to or {"group:fence", "group:pseudo_fence"}
	fence_def.stack_max = def.stack_max or 1024

	minetest.register_node(name, fence_def)
end

if minetest.settings:get_bool("creative_mode", false) then
	minetest.register_node("barrier:invisible_wall", {
		description = "Invisible Wall",
		drawtype = "glasslike",
		paramtype = "light",
		tiles = {"barrier_invisible_wall.png"},
		inventory_image = "barrier_invisible_wall.png",
		wield_image = "barrier_invisible_wall.png",
		drop = "",
		groups = {super_hand = 1},
		sunlight_propagates = true,
		walkable = true,
		pointable = true,
		diggable = true
	})

	minetest.register_node("barrier:light_border", {
		description = "Light Border",
		drawtype = "glasslike",
		paramtype = "none",
		tiles = {"barrier_light_border.png"},
		inventory_image = "barrier_light_border_inv.png",
		wield_image = "barrier_light_border_inv.png",
		drop = "",
		groups = {super_hand = 1},
		sunlight_propagates = false,
		walkable = false,
		pointable = true,
		diggable = true
	})
else
	minetest.register_node("barrier:invisible_wall", {
		description = "Invisible Wall",
		drawtype = "glasslike",
		paramtype = "light",
		tiles = {"blank.png"},
		inventory_image = "barrier_invisible_wall.png",
		wield_image = "barrier_invisible_wall.png",
		drop = "",
		groups = {super_hand = 1},
		sunlight_propagates = true,
		walkable = true,
		pointable = false,
		diggable = false
	})

	minetest.register_node("barrier:light_border", {
		description = "Light Border",
		drawtype = "glasslike",
		paramtype = "none",
		tiles = {"blank.png"},
		inventory_image = "barrier_light_border_inv.png",
		wield_image = "barrier_light_border_inv.png",
		drop = "",
		groups = {super_hand = 1},
		sunlight_propagates = false,
		walkable = false,
		pointable = false,
		diggable = false
	})
end
