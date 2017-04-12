panes = {}

panes.boxes = {
	bars = {
		fixed = {
			{-0.5, 0.375, -0.125, 0.5, 0.5, 0.125},
			{-0.5, -0.5, -0.125, 0.5, -0.375, 0.125},
			{-0.5, -0.375, -0.0625, -0.4375, 0.375, 0.0625},
			{-0.3125, -0.375, -0.0625, -0.1875, 0.375, 0.0625},
			{-0.0625, -0.375, -0.0625, 0.0625, 0.375, 0.0625},
			{0.1875, -0.375, -0.0625, 0.3125, 0.375, 0.0625},
			{0.4375, -0.375, -0.0625, 0.5, 0.375, 0.0625}
		},
		center = {
			{-0.125, 0.375, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.5, -0.125, 0.125, -0.375, 0.125},
			{-0.0625, -0.375, -0.0625, 0.0625, 0.375, 0.0625}
		},
		connect_front = {
			{-0.125, 0.375, -0.5, 0.125, 0.5, -0.125},
			{-0.125, -0.5, -0.5, 0.125, -0.375, -0.125},
			{-0.0625, -0.375, -0.5, 0.0625, 0.375, -0.4375},
			{-0.0625, -0.375, -0.3125, 0.0625, 0.375, -0.1875}
		},
		connect_left = {
			{-0.5, 0.375, -0.125, -0.125, 0.5, 0.125},
			{-0.5, -0.5, -0.125, -0.125, -0.375, 0.125},
			{-0.5, -0.375, -0.0625, -0.4375, 0.375, 0.0625},
			{-0.3125, -0.375, -0.0625, -0.1875, 0.375, 0.0625}
		},
		connect_back = {
			{-0.125, 0.375, 0.125, 0.125, 0.5, 0.5},
			{-0.125, -0.5, 0.125, 0.125, -0.375, 0.5},
			{-0.0625, -0.375, 0.4375, 0.0625, 0.375, 0.5},
			{-0.0625, -0.375, 0.1875, 0.0625, 0.375, 0.3125}
		},
		connect_right = {
			{0.125, 0.375, -0.125, 0.5, 0.5, 0.125},
			{0.125, -0.5, -0.125, 0.5, -0.375, 0.125},
			{0.4375, -0.375, -0.0625, 0.5, 0.375, 0.0625},
			{0.1875, -0.375, -0.0625, 0.3125, 0.375, 0.0625}
		}
	},
	fat = {
		fixed = {-0.5, -0.5, -0.125, 0.5, 0.5, 0.125},
		center = {-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		connect_front = {-0.125, -0.5, -0.5, 0.125, 0.5, -0.125},
		connect_left = {-0.5, -0.5, -0.125, -0.125, 0.5, 0.125},
		connect_back = {-0.125, -0.5, 0.125, 0.125, 0.5, 0.5},
		connect_right = {0.125, -0.5, -0.125, 0.5, 0.5, 0.125}
	},
	flat = {
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625},
		center = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
		connect_front = {-0.0625, -0.5, -0.5, 0.0625, 0.5, -0.0625},
		connect_left = {-0.5, -0.5, -0.0625, -0.0625, 0.5, 0.0625},
		connect_back = {-0.0625, -0.5, 0.0625, 0.0625, 0.5, 0.5},
		connect_right = {0.0625, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
}

local default_pane = panes.boxes.flat

local get_pane = function(num, panes, param2)
	if num == 0 then
		return {name = panes[1], param2 = param2}
	elseif num == 1 or num == 4 or num == 5 then
		return {name = panes[1], param2 = 1}
	elseif num == 2 or num == 8 or num == 10 then
		return {name = panes[1], param2 = 0}
	else
		return {name = panes[2], param2 = 0}
	end
end

local get_mesh_pane = function(num, panes, param2)
	if num == 0 then
		return {name = panes[1], param2 = param2}
	elseif num == 1 or num == 4 or num == 5 then
		return {name = panes[1], param2 = 1}
	elseif num == 2 or num == 8 or num == 10 then
		return {name = panes[1], param2 = 0}
	elseif num == 3 then
		return {name = panes[2], param2 = 0}
	elseif num == 6 then
		return {name = panes[2], param2 = 1}
	elseif num == 12 then
		return {name = panes[2], param2 = 2}
	elseif num == 9 then
		return {name = panes[2], param2 = 3}
	elseif num == 11 then
		return {name = panes[3], param2 = 0}
	elseif num == 7 then
		return {name = panes[3], param2 = 1}
	elseif num == 14 then
		return {name = panes[3], param2 = 2}
	elseif num == 13 then
		return {name = panes[3], param2 = 3}
	else
		return {name = panes[4], param2 = 0}
	end
end

local r_box = {
	type = "fixed",
	fixed = {
		{-0.0625, -0.5, 0.0625, 0.0625, 0.5, 0.5},
		{-0.0625, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
}

local t_box = {
	type = "fixed",
	fixed = {
		{-0.0625, -0.5, 0.0625, 0.0625, 0.5, 0.5},
		{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
}

local x_box = {
	type = "fixed",
	fixed = {
		{-0.0625, -0.5, -0.5, 0.0625, 0.5, 0.5},
		{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
}

function panes.register_pane(name, def)
	local panes = {name, name.."_connect"}
	local n_def = table.copy(def)
	n_def.drawtype = "nodebox"
	n_def.paramtype = "light"
	n_def.groups.pane = 1
	n_def.update_pane = function(pos, param2)
		local num = 0
		local pos_table = {{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}
		local node_table = {{}, {}, {}, {}}
		local node_def_table = {{}, {}, {}, {}}
		for i,v in ipairs(pos_table) do
			local node = minetest.get_node_or_nil(v)
			if node then
				node_table[i] = node
				local node_def = minetest.registered_nodes[node.name] or {}
				node_def_table[i] = node_def
			end
		end
		if node_def_table[1].update_pane and node_table[1].param2 < 4 then
			num = 1
		end
		if node_def_table[2].update_pane and node_table[2].param2 < 4 then
			num = num + 2
		end
		if node_def_table[3].update_pane and node_table[3].param2 < 4 then
			num = num + 4
		end
		if node_def_table[4].update_pane and node_table[4].param2 < 4 then
			num = num + 8
		end
		local node = get_pane(num, panes, param2)
		minetest.swap_node(pos, node)
	end
	n_def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if oldnode.param2 > 3 then
			return
		end
		local pos_table = {{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}
		local update_table = {nil, nil, nil, nil}
		for i,v in ipairs(pos_table) do
			local node = minetest.get_node_or_nil(v)
			if node and node.param2 < 4 then
				local node_def = minetest.registered_nodes[node.name] or {}
				if node_def.update_pane then
					update_table[i] = node_def.update_pane
				end
			end
		end
		if update_table[1] then
			update_table[1](pos_table[1], 1)
		end
		if update_table[2] then
			update_table[2](pos_table[2], 0)
		end
		if update_table[3] then
			update_table[3](pos_table[3], 1)
		end
		if update_table[4] then
			update_table[4](pos_table[4], 0)
		end
	end
	local c_def = table.copy(n_def)
	c_def.groups.not_in_creative_inventory = 1
	c_def.drop = def.drop or name
	c_def.connects_to = def.connects_to or {"group:pane"}
	n_def.paramtype2 = "facedir"
	if def.node_box then
		c_def.node_box = {
			type = "connected",
			fixed = def.node_box.center,
			connect_front = def.node_box.connect_front,
			connect_left = def.node_box.connect_left,
			connect_back = def.node_box.connect_back,
			connect_right = def.node_box.connect_right
		}
		n_def.node_box = {
			type = "fixed",
			fixed = def.node_box.fixed
		}
	else
		c_def.node_box = {
			type = "connected",
			fixed = default_pane.center,
			connect_front = default_pane.connect_front,
			connect_left = default_pane.connect_left,
			connect_back = default_pane.connect_back,
			connect_right = default_pane.connect_right
		}
		n_def.node_box = {
			type = "fixed",
			fixed = default_pane.fixed
		}
	end
	if def.collision_box then
		c_def.collision_box = {
			type = "connected",
			fixed = def.collision_box.center,
			connect_front = def.collision_box.connect_front,
			connect_left = def.collision_box.connect_left,
			connect_back = def.collision_box.connect_back,
			connect_right = def.collision_box.connect_right
		}
		n_def.collision_box = {
			type = "fixed",
			fixed = def.collision_box.fixed
		}
	end
	if def.selection_box then
		c_def.selection_box = {
			type = "connected",
			fixed = def.selection_box.center,
			connect_front = def.selection_box.connect_front,
			connect_left = def.selection_box.connect_left,
			connect_back = def.selection_box.connect_back,
			connect_right = def.selection_box.connect_right
		}
		n_def.selection_box = {
			type = "fixed",
			fixed = def.selection_box.fixed
		}
	end
	n_def.on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local under = pointed_thing.under
		local above = pointed_thing.above
		local param2
		if under.y == above.y then
			local under_node = minetest.get_node(under)
			local top_node = minetest.get_node({x = above.x, y = above.y + 1, z = above.z})
			local bottom_node = minetest.get_node({x = above.x, y = above.y - 1, z = above.z})
			if minetest.get_item_group(under_node.name, "pane") > 0 then
				if under_node.param2 == 4 then
					param2 = 4
				end
			elseif top_node.name == "air" and bottom_node.name == "air" then
				param2 = 4
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing, param2)
	end
	n_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		local node = minetest.get_node(pos)
		local param2 = node.param2
		if param2 > 3 then
			return
		end
		if param2 == 3 then
			param2 = 1
		elseif param2 == 2 then
			param2 = 0
		end
		local num = 0
		local pos_table = {{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}
		local node_table = {{}, {}, {}, {}}
		local node_def_table = {{}, {}, {}, {}}
		for i,v in ipairs(pos_table) do
			local node = minetest.get_node_or_nil(v)
			if node then
				node_table[i] = node
				local node_def = minetest.registered_nodes[node.name] or {}
				node_def_table[i] = node_def
			end
		end
		if node_def_table[1].update_pane and node_table[1].param2 < 4 then
			num = 1
			node_def_table[1].update_pane(pos_table[1], param2)
		end
		if node_def_table[2].update_pane and node_table[2].param2 < 4 then
			num = num + 2
			node_def_table[2].update_pane(pos_table[2], param2)
		end
		if node_def_table[3].update_pane and node_table[3].param2 < 4 then
			num = num + 4
			node_def_table[3].update_pane(pos_table[3], param2)
		end
		if node_def_table[4].update_pane and node_table[4].param2 < 4 then
			num = num + 8
			node_def_table[4].update_pane(pos_table[4], param2)
		end
		local node = get_pane(num, panes, param2)
		minetest.swap_node(pos, node)
	end

	minetest.register_node(name, n_def)
	minetest.register_node(name.."_connect", c_def)
end

function panes.register_mesh_pane(name, def)
	local panes = {name, name.."_r", name.."_t", name.."_x"}
	local tface = def.tiles[1]
	local tedge = def.tiles[2]
	if type(tface) == "string" then
		tface = {name = tface, backface_culling = true}
	elseif tface.backface_culling == nil then
		tface = table.copy(def.tiles[1])
		tface.backface_culling = true
	end
	if type(tedge) == "string" then
		tedge = {name = tedge, backface_culling = true}
	elseif tedge.backface_culling == nil then
		tedge = table.copy(def.tiles[2])
		tedge.backface_culling = true
	end
	local n_def = table.copy(def)
	n_def.paramtype = "light"
	n_def.paramtype2 = "facedir"
	n_def.groups.pane = 1
	n_def.update_pane = function(pos, param2)
		local num = 0
		local pos_table = {{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}
		local node_table = {{}, {}, {}, {}}
		local node_def_table = {{}, {}, {}, {}}
		for i,v in ipairs(pos_table) do
			local node = minetest.get_node_or_nil(v)
			if node then
				node_table[i] = node
				local node_def = minetest.registered_nodes[node.name] or {}
				node_def_table[i] = node_def
			end
		end
		if node_def_table[1].update_pane and node_table[1].param2 < 4 then
			num = 1
		end
		if node_def_table[2].update_pane and node_table[2].param2 < 4 then
			num = num + 2
		end
		if node_def_table[3].update_pane and node_table[3].param2 < 4 then
			num = num + 4
		end
		if node_def_table[4].update_pane and node_table[4].param2 < 4 then
			num = num + 8
		end
		local node = get_mesh_pane(num, panes, param2)
		minetest.swap_node(pos, node)
	end
	n_def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if oldnode.param2 > 3 then
			return
		end
		local pos_table = {{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}
		local update_table = {nil, nil, nil, nil}
		for i,v in ipairs(pos_table) do
			local node = minetest.get_node_or_nil(v)
			if node and node.param2 < 4 then
				local node_def = minetest.registered_nodes[node.name] or {}
				if node_def.update_pane then
					update_table[i] = node_def.update_pane
				end
			end
		end
		if update_table[1] then
			update_table[1](pos_table[1], 1)
		end
		if update_table[2] then
			update_table[2](pos_table[2], 0)
		end
		if update_table[3] then
			update_table[3](pos_table[3], 1)
		end
		if update_table[4] then
			update_table[4](pos_table[4], 0)
		end
	end
	local r_def = table.copy(n_def)
	r_def.drawtype = "mesh"
	r_def.tiles = {tface, tedge}
	r_def.groups.not_in_creative_inventory = 1
	r_def.drop = def.drop or name
	local t_def = table.copy(r_def)
	local x_def = table.copy(r_def)
	n_def.drawtype = "nodebox"
	n_def.tiles = {tedge, tedge, tedge, tedge, tface}
	n_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
	n_def.on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local under = pointed_thing.under
		local above = pointed_thing.above
		local param2
		if under.y == above.y then
			local under_node = minetest.get_node(under)
			local top_node = minetest.get_node({x = above.x, y = above.y + 1, z = above.z})
			local bottom_node = minetest.get_node({x = above.x, y = above.y - 1, z = above.z})
			if minetest.get_item_group(under_node.name, "pane") > 0 then
				if under_node.param2 == 4 then
					param2 = 4
				end
			elseif top_node.name == "air" and bottom_node.name == "air" then
				param2 = 4
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing, param2)
	end
	n_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		local node = minetest.get_node(pos)
		local param2 = node.param2
		if param2 > 3 then
			return
		end
		if param2 == 3 then
			param2 = 1
		elseif param2 == 2 then
			param2 = 0
		end
		local num = 0
		local pos_table = {{x = pos.x, y = pos.y, z = pos.z + 1}, {x = pos.x + 1, y = pos.y, z = pos.z}, {x = pos.x, y = pos.y, z = pos.z - 1}, {x = pos.x - 1, y = pos.y, z = pos.z}}
		local node_table = {{}, {}, {}, {}}
		local node_def_table = {{}, {}, {}, {}}
		for i,v in ipairs(pos_table) do
			local node = minetest.get_node_or_nil(v)
			if node then
				node_table[i] = node
				local node_def = minetest.registered_nodes[node.name] or {}
				node_def_table[i] = node_def
			end
		end
		if node_def_table[1].update_pane and node_table[1].param2 < 4 then
			num = 1
			node_def_table[1].update_pane(pos_table[1], param2)
		end
		if node_def_table[2].update_pane and node_table[2].param2 < 4 then
			num = num + 2
			node_def_table[2].update_pane(pos_table[2], param2)
		end
		if node_def_table[3].update_pane and node_table[3].param2 < 4 then
			num = num + 4
			node_def_table[3].update_pane(pos_table[3], param2)
		end
		if node_def_table[4].update_pane and node_table[4].param2 < 4 then
			num = num + 8
			node_def_table[4].update_pane(pos_table[4], param2)
		end
		local node = get_mesh_pane(num, panes, param2)
		minetest.swap_node(pos, node)
	end
	r_def.mesh = "panes_r.obj"
	r_def.collision_box = r_box
	r_def.selection_box = r_box
	t_def.mesh = "panes_t.obj"
	t_def.collision_box = t_box
	t_def.selection_box = t_box
	x_def.mesh = "panes_x.obj"
	x_def.collision_box = x_box
	x_def.selection_box = x_box

	minetest.register_node(name, n_def)
	minetest.register_node(name.."_r", r_def)
	minetest.register_node(name.."_t", t_def)
	minetest.register_node(name.."_x", x_def)
end
