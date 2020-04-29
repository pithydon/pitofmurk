slabs = {}

local creative = minetest.setting_getbool("creative_mode")

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

local get_stair_param = function(node)
	local stair = minetest.get_item_group(node.name, "stair")
	if stair == 1 then
		return node.param2
	elseif stair == 2 then
		if node.param2 < 12 then
			return node.param2 + 4
		else
			return node.param2 - 4
		end
	elseif stair == 3 then
		if node.param2 < 12 then
			return node.param2 + 8
		else
			return node.param2 - 8
		end
	end
end

local get_stair_from_param = function(param, stairs)
	if param < 12 then
		if param < 4 then
			return {name = stairs[1], param2 = param}
		elseif param < 8 then
			return {name = stairs[2], param2 = param - 4}
		else
			return {name = stairs[3], param2 = param - 8}
		end
	else
		if param >= 20 then
			return {name = stairs[1], param2 = param}
		elseif param >= 16 then
			return {name = stairs[2], param2 = param + 4}
		else
			return {name = stairs[3], param2 = param + 8}
		end
	end
end

local stair_param_to_connect = function(param, ceiling)
	local out = {false, false, false, false, false, false, false, false}
	if not ceiling then
		if param == 0 then
			out[3] = true
			out[8] = true
		elseif param == 1 then
			out[2] = true
			out[5] = true
		elseif param == 2 then
			out[4] = true
			out[7] = true
		elseif param == 3 then
			out[1] = true
			out[6] = true
		elseif param == 4 then
			out[1] = true
			out[8] = true
		elseif param == 5 then
			out[2] = true
			out[3] = true
		elseif param == 6 then
			out[4] = true
			out[5] = true
		elseif param == 7 then
			out[6] = true
			out[7] = true
		elseif param == 8 then
			out[3] = true
			out[6] = true
		elseif param == 9 then
			out[5] = true
			out[8] = true
		elseif param == 10 then
			out[2] = true
			out[7] = true
		elseif param == 11 then
			out[1] = true
			out[4] = true
		end
	else
		if param == 12 then
			out[5] = true
			out[8] = true
		elseif param == 13 then
			out[3] = true
			out[6] = true
		elseif param == 14 then
			out[1] = true
			out[4] = true
		elseif param == 15 then
			out[2] = true
			out[7] = true
		elseif param == 16 then
			out[2] = true
			out[3] = true
		elseif param == 17 then
			out[1] = true
			out[8] = true
		elseif param == 18 then
			out[6] = true
			out[7] = true
		elseif param == 19 then
			out[4] = true
			out[5] = true
		elseif param == 20 then
			out[3] = true
			out[8] = true
		elseif param == 21 then
			out[1] = true
			out[6] = true
		elseif param == 22 then
			out[4] = true
			out[7] = true
		elseif param == 23 then
			out[2] = true
			out[5] = true
		end
	end
	return out
end

local stair_connect_to_param = function(connect, ceiling)
	local param
	if not ceiling then
		if connect[3] and connect[8] then
			param = 0
		elseif connect[2] and connect[5] then
			param = 1
		elseif connect[4] and connect[7] then
			param = 2
		elseif connect[1] and connect[6] then
			param = 3
		elseif connect[1] and connect[8] then
			param = 4
		elseif connect[2] and connect[3] then
			param = 5
		elseif connect[4] and connect[5] then
			param = 6
		elseif connect[6] and connect[7] then
			param = 7
		elseif connect[3] and connect[6] then
			param = 8
		elseif connect[5] and connect[8] then
			param = 9
		elseif connect[2] and connect[7] then
			param = 10
		elseif connect[1] and connect[4] then
			param = 11
		end
	else
		if connect[5] and connect[8] then
			param = 12
		elseif connect[3] and connect[6] then
			param = 13
		elseif connect[1] and connect[4] then
			param = 14
		elseif connect[2] and connect[7] then
			param = 15
		elseif connect[2] and connect[3] then
			param = 16
		elseif connect[1] and connect[8] then
			param = 17
		elseif connect[6] and connect[7] then
			param = 18
		elseif connect[4] and connect[5] then
			param = 19
		elseif connect[3] and connect[8] then
			param = 20
		elseif connect[1] and connect[6] then
			param = 21
		elseif connect[4] and connect[7] then
			param = 22
		elseif connect[2] and connect[5] then
			param = 23
		end
	end
	return param
end

function slabs.register_slab(name, def, recipeitem, craft)
	local slab_def = table.copy(def)
	slab_def.drawtype = "nodebox"
	slab_def.paramtype = "light"
	slab_def.paramtype2 = "facedir"
	slab_def.groups.slab = 1
	slab_def.tiles = tile_mod(def.tiles)
	slab_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
	}
	if def.on_place then
	elseif recipeitem then
		slab_def.on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local face_pos = minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1
			local on_node = minetest.get_node(under)
			if on_node.name == name and not minetest.is_protected(under, placer:get_player_name()) and
					((on_node.param2 > 19 and under.y > above.y) or (on_node.param2 < 4 and under.y < above.y)) then
				if not creative then
					itemstack:take_item()
				end
				minetest.swap_node(under, {name = recipeitem})
				return itemstack
			end
			local param2 = 0
			if under.y > above.y or (under.y == above.y and face_pos < 0.5) then
				param2 = 22
			end
			return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
		end
	else
		slab_def.on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local face_pos = minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1
			local on_node = minetest.get_node(under)
			local param2 = 0
			if under.y > above.y or (under.y == above.y and face_pos < 0.5) then
				param2 = 22
			end
			return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
		end
	end

	minetest.register_node(name, slab_def)

	if craft ~= false and recipeitem then
		minetest.register_craft({
			output = name.." 4",
			recipe = {{recipeitem, recipeitem}}
		})
		minetest.register_craft({
			output = recipeitem,
			recipe = {{name}, {name}}
		})
	end
end

function slabs.register_stair(name, def, recipeitem, stairtiles)
	local stair_inner_def = table.copy(def)
	stair_inner_def.stairs = {name, name.."_outer", name.."_inner"}
	stair_inner_def.drawtype = "nodebox"
	stair_inner_def.paramtype = "light"
	stair_inner_def.paramtype2 = "facedir"
	stair_inner_def.drop = def.drop or name
	stair_inner_def.groups.not_in_creative_inventory = 1
	stair_inner_def.groups.stair = 3
	stair_inner_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0, 0.5},
			{-0.5, -0.5, -0.5, 0, 0, 0}
		}
	}
	stair_inner_def.after_dig_node = function(pos, oldnode)
		local param = get_stair_param(oldnode)
		local ceiling
		if param < 12 then
			ceiling = false
		else
			ceiling = true
		end
		local connect = stair_param_to_connect(param, ceiling)
		local t = {
			{pos = {x = pos.x, y = pos.y, z = pos.z + 2}},
			{pos = {x = pos.x - 1, y = pos.y, z = pos.z + 1}}, {pos = {x = pos.x, y = pos.y, z = pos.z + 1}}, {pos = {x = pos.x + 1, y = pos.y, z = pos.z + 1}},
			{pos = {x = pos.x - 2, y = pos.y, z = pos.z}}, {pos = {x = pos.x - 1, y = pos.y, z = pos.z}},
			{pos = pos, connect = connect},
			{pos = {x = pos.x + 1, y = pos.y, z = pos.z}}, {pos = {x = pos.x + 2, y = pos.y, z = pos.z}},
			{pos = {x = pos.x - 1, y = pos.y, z = pos.z - 1}}, {pos = {x = pos.x, y = pos.y, z = pos.z - 1}}, {pos = {x = pos.x + 1, y = pos.y, z = pos.z - 1}},
			{pos = {x = pos.x, y = pos.y, z = pos.z - 2}}
		}
		for i,v in ipairs(t) do
			if not v.connect then
				local node = minetest.get_node(v.pos)
				local node_def = minetest.registered_nodes[node.name] or {}
				if node_def.stairs then
					t[i].stairs = node_def.stairs
					t[i].connect = stair_param_to_connect(get_stair_param(node), ceiling)
				else
					t[i].connect = {false, false, false, false, false, false, false, false}
				end
			end
		end
		local swap_stair = function(index, n1, n2)
			local connect = {false, false, false, false, false, false, false, false}
			connect[n1] = true
			connect[n2] = true
			local node = get_stair_from_param(stair_connect_to_param(connect, ceiling), t[index].stairs)
			minetest.swap_node(t[index].pos, node)
		end
		if t[3].stairs then
			if t[7].connect[1] and t[3].connect[6] then
				if t[3].connect[1] and t[1].connect[6] then
					if t[2].connect[3] then
						swap_stair(3, 1, 8)
					elseif t[4].connect[7] then
						swap_stair(3, 1, 4)
					end
				elseif t[3].connect[7] then
					swap_stair(3, 4, 7)
				elseif t[3].connect[3] then
					swap_stair(3, 3, 8)
				end
			elseif t[7].connect[2] and t[3].connect[5] then
				if t[3].connect[2] and t[1].connect[5] then
					if t[4].connect[8] then
						swap_stair(3, 2, 3)
					elseif t[2].connect[4] then
						swap_stair(3, 2, 7)
					end
				elseif t[3].connect[4] then
					swap_stair(3, 4, 7)
				elseif t[3].connect[8] then
					swap_stair(3, 3, 8)
				end
			end
		end
		if t[8].stairs then
			if t[7].connect[3] and t[8].connect[8] then
				if t[8].connect[3] and t[9].connect[8] then
					if t[4].connect[5] then
						swap_stair(8, 2, 3)
					elseif t[12].connect[1] then
						swap_stair(8, 3, 6)
					end
				elseif t[8].connect[1] then
					swap_stair(8, 1, 6)
				elseif t[8].connect[5] then
					swap_stair(8, 2, 5)
				end
			elseif t[7].connect[4] and t[8].connect[7] then
				if t[8].connect[4] and t[9].connect[7] then
					if t[12].connect[2] then
						swap_stair(8, 4, 5)
					elseif t[4].connect[6] then
						swap_stair(8, 1, 4)
					end
				elseif t[8].connect[6] then
					swap_stair(8, 1, 6)
				elseif t[8].connect[2] then
					swap_stair(8, 2, 5)
				end
			end
		end
		if t[11].stairs then
			if t[7].connect[5] and t[11].connect[2] then
				if t[11].connect[5] and t[13].connect[2] then
					if t[12].connect[7] then
						swap_stair(11, 4, 5)
					elseif t[10].connect[3] then
						swap_stair(11, 5, 8)
					end
				elseif t[11].connect[3] then
					swap_stair(11, 3, 8)
				elseif t[11].connect[7] then
					swap_stair(11, 4, 7)
				end
			elseif t[7].connect[6] and t[11].connect[1] then
				if t[11].connect[6] and t[13].connect[1] then
					if t[10].connect[4] then
						swap_stair(11, 6, 7)
					elseif t[12].connect[8] then
						swap_stair(11, 3, 6)
					end
				elseif t[11].connect[8] then
					swap_stair(11, 3, 8)
				elseif t[11].connect[4] then
					swap_stair(11, 4, 7)
				end
			end
		end
		if t[6].stairs then
			if t[7].connect[7] and t[6].connect[4] then
				if t[6].connect[7] and t[5].connect[4] then
					if t[10].connect[1] then
						swap_stair(6, 6, 7)
					elseif t[2].connect[5] then
						swap_stair(6, 2, 7)
					end
				elseif t[6].connect[5] then
					swap_stair(6, 2, 5)
				elseif t[6].connect[1] then
					swap_stair(6, 1, 6)
				end
			elseif t[7].connect[8] and t[6].connect[3] then
				if t[6].connect[8] and t[5].connect[3] then
					if t[2].connect[6] then
						swap_stair(6, 1, 8)
					elseif t[10].connect[2] then
						swap_stair(6, 5, 8)
					end
				elseif t[6].connect[2] then
					swap_stair(6, 2, 5)
				elseif t[6].connect[6] then
					swap_stair(6, 1, 6)
				end
			end
		end
	end
	local stair_outer_def = table.copy(stair_inner_def)
	stair_outer_def.groups.stair = 2
	stair_outer_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0, 0, 0.5}
	}
	local stair_def = table.copy(stair_inner_def)
	stair_def.groups.not_in_creative_inventory = 0
	stair_def.groups.stair = 1
	stair_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0.5, 0 ,0.5}
	}
	stair_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		local node = minetest.get_node(pos)
		local ceiling = false
		local face_pos = minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1
		if pointed_thing.under.y > pointed_thing.above.y or (pointed_thing.under.y == pointed_thing.above.y and face_pos < 0.5) then
			ceiling = true
			if node.param2 == 0 then node.param2 = 20
			elseif node.param2 == 1 then node.param2 = 23
			elseif node.param2 == 2 then node.param2 = 22
			elseif node.param2 == 3 then node.param2 = 21
			end
		end
		local connect = stair_param_to_connect(get_stair_param(node), ceiling)
		local t = {
			{pos = {x = pos.x - 1, y = pos.y, z = pos.z + 1}}, {pos = {x = pos.x, y = pos.y, z = pos.z + 1}}, {pos = {x = pos.x + 1, y = pos.y, z = pos.z + 1}},
			{pos = {x = pos.x - 1, y = pos.y, z = pos.z}}, {pos = pos, stairs = {name, name.."_outer", name.."_inner"}, connect = connect}, {pos = {x = pos.x + 1, y = pos.y, z = pos.z}},
			{pos = {x = pos.x - 1, y = pos.y, z = pos.z - 1}}, {pos = {x = pos.x, y = pos.y, z = pos.z - 1}}, {pos = {x = pos.x + 1, y = pos.y, z = pos.z - 1}},
		}
		for i,v in ipairs(t) do
			if not v.connect then
				local node = minetest.get_node(v.pos)
				local node_def = minetest.registered_nodes[node.name] or {}
				if node_def.stairs then
					t[i].stairs = node_def.stairs
					t[i].connect = stair_param_to_connect(get_stair_param(node), ceiling)
				else
					t[i].connect = {false, false, false, false, false, false, false, false}
				end
			end
		end
		local reset_node = function(n1, n2)
			local connect = {false, false, false, false, false, false, false, false}
			connect[n1] = true
			connect[n2] = true
			node = get_stair_from_param(stair_connect_to_param(connect, ceiling), t[5].stairs)
		end
		local swap_stair = function(index, n1, n2)
			local connect = {false, false, false, false, false, false, false, false}
			connect[n1] = true
			connect[n2] = true
			local node = get_stair_from_param(stair_connect_to_param(connect, ceiling), t[index].stairs)
			t[index].connect = connect
			minetest.swap_node(t[index].pos, node)
		end
		if connect[3] then
			if t[4].connect[2] and t[4].connect[5] and t[1].connect[5] and not t[7].connect[2] then
				swap_stair(4, 2, 3)
			elseif t[4].connect[1] and t[4].connect[6] and t[7].connect[1] and not t[1].connect[6] then
				swap_stair(4, 3, 6)
			end
			if t[6].connect[1] and t[6].connect[6] and t[3].connect[6] and not t[9].connect[1] then
				swap_stair(6, 1, 8)
			elseif t[6].connect[2] and t[6].connect[5] and t[9].connect[2] and not t[3].connect[5] then
				swap_stair(6, 5, 8)
			end
			if t[4].connect[3] ~= t[6].connect[8] then
				if t[4].connect[3] then
					if t[2].connect[6] then
						reset_node(1, 8)
					elseif t[8].connect[2] then
						reset_node(5, 8)
					elseif t[2].connect[4] and t[2].connect[7] and t[1].connect[4] and not t[3].connect[7] then
						swap_stair(2, 6, 7)
						reset_node(1, 8)
					elseif t[2].connect[3] and t[2].connect[8] and t[3].connect[8] and not t[1].connect[3] then
						swap_stair(2, 3, 6)
						reset_node(1, 8)
					elseif t[8].connect[3] and t[8].connect[8] and t[9].connect[8] and not t[7].connect[3] then
						swap_stair(8, 2, 3)
						reset_node(5, 8)
					elseif t[8].connect[4] and t[8].connect[7] and t[7].connect[4] and not t[9].connect[7] then
						swap_stair(8, 2, 7)
						reset_node(5, 8)
					end
				else
					if t[2].connect[5] then
						reset_node(2, 3)
					elseif t[8].connect[1] then
						reset_node(3, 6)
					elseif t[2].connect[4] and t[2].connect[7] and t[3].connect[7] and not t[1].connect[4] then
						swap_stair(2, 4, 5)
						reset_node(2, 3)
					elseif t[2].connect[3] and t[2].connect[8] and t[1].connect[3] and not t[3].connect[8] then
						swap_stair(2, 5, 8)
						reset_node(2, 3)
					elseif t[8].connect[3] and t[8].connect[8] and t[7].connect[3] and not t[9].connect[8] then
						swap_stair(8, 1, 8)
						reset_node(3, 6)
					elseif t[8].connect[4] and t[8].connect[7] and t[9].connect[7] and not t[7].connect[4] then
						swap_stair(8, 1, 4)
						reset_node(3, 6)
					end
				end
			end
		elseif connect[2] then
			if t[2].connect[4] and t[2].connect[7] and t[3].connect[7] and not t[1].connect[4] then
				swap_stair(2, 4, 5)
			elseif t[2].connect[3] and t[2].connect[8] and t[1].connect[3] and not t[3].connect[8] then
				swap_stair(2, 5, 8)
			end
			if t[8].connect[3] and t[8].connect[8] and t[9].connect[8] and not t[7].connect[3] then
				swap_stair(8, 2, 3)
			elseif t[8].connect[4] and t[8].connect[7] and t[7].connect[4] and not t[9].connect[7] then
				swap_stair(8, 2, 7)
			end
			if t[2].connect[5] ~= t[8].connect[2] then
				if t[2].connect[5] then
					if t[6].connect[8] then
						reset_node(2, 3)
					elseif t[4].connect[4] then
						reset_node(2, 7)
					elseif t[6].connect[1] and t[6].connect[6] and t[3].connect[6] and not t[9].connect[1] then
						swap_stair(6, 1, 8)
						reset_node(2, 3)
					elseif t[6].connect[2] and t[6].connect[5] and t[9].connect[2] and not t[3].connect[5] then
						swap_stair(6, 5, 8)
						reset_node(2, 3)
					elseif t[4].connect[2] and t[4].connect[5] and t[7].connect[2] and not t[1].connect[5] then
						swap_stair(4, 4, 5)
						reset_node(2, 7)
					elseif t[4].connect[1] and t[4].connect[6] and t[1].connect[6] and not t[7].connect[1] then
						swap_stair(4, 1, 4)
						reset_node(2, 7)
					end
				else
					if t[6].connect[7] then
						reset_node(4, 5)
					elseif t[4].connect[3] then
						reset_node(5, 8)
					elseif t[6].connect[1] and t[6].connect[6] and t[9].connect[1] and not t[3].connect[6] then
						swap_stair(6, 6, 7)
						reset_node(4, 5)
					elseif t[6].connect[2] and t[6].connect[5] and t[3].connect[5] and not t[9].connect[2] then
						swap_stair(6, 2, 7)
						reset_node(4, 5)
					elseif t[4].connect[2] and t[4].connect[5] and t[1].connect[5] and not t[7].connect[2] then
						swap_stair(4, 2, 3)
						reset_node(5, 8)
					elseif t[4].connect[1] and t[4].connect[6] and t[7].connect[1] and not t[1].connect[6] then
						swap_stair(4, 3, 6)
						reset_node(5, 8)
					end
				end
			end
		elseif connect[4] then
			if t[6].connect[1] and t[6].connect[6] and t[9].connect[1] and not t[3].connect[6] then
				swap_stair(6, 6, 7)
			elseif t[6].connect[2] and t[6].connect[5] and t[3].connect[5] and not t[9].connect[2] then
				swap_stair(6, 2, 7)
			end
			if t[4].connect[2] and t[4].connect[5] and t[7].connect[2] and not t[1].connect[5] then
				swap_stair(4, 4, 5)
			elseif t[4].connect[1] and t[4].connect[6] and t[1].connect[6] and not t[7].connect[1] then
				swap_stair(4, 1, 4)
			end
			if t[4].connect[4] ~= t[6].connect[7] then
				if t[4].connect[4] then
					if t[8].connect[1] then
						reset_node(6, 7)
					elseif t[2].connect[5] then
						reset_node(2, 7)
					elseif t[8].connect[3] and t[8].connect[8] and t[7].connect[3] and not t[9].connect[8] then
						swap_stair(8, 1, 8)
						reset_node(6, 7)
					elseif t[8].connect[4] and t[8].connect[7] and t[9].connect[7] and not t[7].connect[4] then
						swap_stair(8, 1, 4)
						reset_node(6, 7)
					elseif t[2].connect[4] and t[2].connect[7] and t[3].connect[7] and not t[1].connect[4] then
						swap_stair(2, 4, 5)
						reset_node(2, 7)
					elseif t[2].connect[3] and t[2].connect[8] and t[1].connect[3] and not t[3].connect[8] then
						swap_stair(2, 5, 8)
						reset_node(2, 7)
					end
				else
					if t[8].connect[2] then
						reset_node(4, 5)
					elseif t[2].connect[6] then
						reset_node(1, 4)
					elseif t[8].connect[3] and t[8].connect[8] and t[9].connect[8] and not t[7].connect[3] then
						swap_stair(8, 2, 3)
						reset_node(4, 5)
					elseif t[8].connect[4] and t[8].connect[7] and t[7].connect[4] and not t[9].connect[7] then
						swap_stair(8, 2, 7)
						reset_node(4, 5)
					elseif t[2].connect[4] and t[2].connect[7] and t[1].connect[4] and not t[3].connect[7] then
						swap_stair(2, 6, 7)
						reset_node(1, 4)
					elseif t[2].connect[3] and t[2].connect[8] and t[3].connect[8] and not t[1].connect[3] then
						swap_stair(2, 3, 6)
						reset_node(1, 4)
					end
				end
			end
		elseif connect[1] then
			if t[8].connect[3] and t[8].connect[8] and t[7].connect[3] and not t[9].connect[8] then
				swap_stair(8, 1, 8)
			elseif t[8].connect[4] and t[8].connect[7] and t[9].connect[7] and not t[7].connect[4] then
				swap_stair(8, 1, 4)
			end
			if t[2].connect[4] and t[2].connect[7] and t[1].connect[4] and not t[3].connect[7] then
				swap_stair(2, 6, 7)
			elseif t[2].connect[3] and t[2].connect[8] and t[3].connect[8] and not t[1].connect[3] then
				swap_stair(2, 3, 6)
			end
			if t[2].connect[6] ~= t[8].connect[1] then
				if t[2].connect[6] then
					if t[4].connect[3] then
						reset_node(1, 8)
					elseif t[6].connect[7] then
						reset_node(1, 4)
					elseif t[4].connect[2] and t[4].connect[5] and t[1].connect[5] and not t[7].connect[2] then
						swap_stair(4, 2, 3)
						reset_node(1, 8)
					elseif t[4].connect[1] and t[4].connect[6] and t[7].connect[1] and not t[1].connect[6] then
						swap_stair(4, 3, 6)
						reset_node(1, 8)
					elseif t[6].connect[1] and t[6].connect[6] and t[9].connect[1] and not t[3].connect[6] then
						swap_stair(6, 6, 7)
						reset_node(1, 4)
					elseif t[6].connect[2] and t[6].connect[5] and t[3].connect[5] and not t[9].connect[2] then
						swap_stair(6, 2, 7)
						reset_node(1, 4)
					end
				else
					if t[4].connect[4] then
						reset_node(6, 7)
					elseif t[6].connect[8] then
						reset_node(3, 6)
					elseif t[4].connect[2] and t[4].connect[5] and t[7].connect[2] and not t[1].connect[5] then
						swap_stair(4, 4, 5)
						reset_node(6, 7)
					elseif t[4].connect[1] and t[4].connect[6] and t[1].connect[6] and not t[7].connect[1] then
						swap_stair(4, 1, 4)
						reset_node(6, 7)
					elseif t[6].connect[1] and t[6].connect[6] and t[3].connect[6] and not t[9].connect[1] then
						swap_stair(6, 1, 8)
						reset_node(3, 6)
					elseif t[6].connect[2] and t[6].connect[5] and t[9].connect[2] and not t[3].connect[5] then
						swap_stair(6, 5, 8)
						reset_node(3, 6)
					end
				end
			end
		end
		minetest.swap_node(pos, node)
	end
	if stairtiles then
		stair_def.tiles = tile_mod(stairtiles[1])
		stair_outer_def.tiles = tile_mod(stairtiles[2])
		stair_inner_def.tiles = tile_mod(stairtiles[3])
	else
		local tiles = tile_mod(def.tiles)
		stair_def.tiles = tiles
		stair_outer_def.tiles = tiles
		stair_inner_def.tiles = tiles
	end

	minetest.register_node(name, stair_def)
	minetest.register_node(name.."_outer", stair_outer_def)
	minetest.register_node(name.."_inner", stair_inner_def)

	if recipeitem then
		minetest.register_craft({
			output = name.." 4",
			recipe = {
				{recipeitem, ""},
				{recipeitem, recipeitem}
			}
		})
		minetest.register_craft({
			output = name.." 4",
			recipe = {
				{"", recipeitem},
				{recipeitem, recipeitem}
			}
		})
		minetest.register_craft({
			output = recipeitem.." 3",
			recipe = {
				{name, name},
				{name, name}
			}
		})
	end
end

function slabs.register_slab_and_stair(recipeitem, def, stairtiles)
	local slab_def = table.copy(def)
	local stair_def = table.copy(def)
	slab_def.description = def.description.." Slab"
	stair_def.description = def.description.." Stair"
	slabs.register_slab(recipeitem.."_slab", slab_def, recipeitem)
	slabs.register_stair(recipeitem.."_stair", stair_def, recipeitem, stairtiles)
end
