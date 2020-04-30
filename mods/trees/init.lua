local modpath = minetest.get_modpath("trees")
local fresh_node = {}
local remove_fresh = function(pos)
	for k,v in pairs(fresh_node) do
		if vector.equals(v, pos) then
			fresh_node[k] = nil
			break
		end
	end
end

for _,v in ipairs({
	{"Apple", "apple", {axe = 2, hand = 4}, {axe = 2, hand = 3}, "apple"},
	{"Baobab", "baobab", {axe = 2, hand = 4}, {axe = 2, hand = 3}},
	{"Oak", "oak", {axe = 2, hand = 4}, {axe = 2, hand = 3}, "wood"},
	{"Willow", "willow", {axe = 2, hand = 4}, {axe = 2, hand = 3}, "wood"}
}) do
	minetest.register_node("trees:sapling_"..v[2], {
		description = v[1].." Sapling",
		drawtype = "plantlike",
		tiles = {"trees_"..v[2].."_sapling.png"},
		inventory_image = "trees_"..v[2].."_sapling.png",
		wield_image = "trees_"..v[2].."_sapling.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.3125, 0.25}
		},
		groups = {snappy = 2, dig_immediate = 3, flammable = 2, attached_node = 1, sapling = 1},
		stack_max = 32
	})

	minetest.register_node("trees:trunk_"..v[2], {
		description = v[1].." Trunk",
		tiles = {"trees_"..v[2].."_trunk_top.png", "trees_"..v[2].."_trunk_top.png", "trees_"..v[2].."_trunk.png"},
		paramtype2 = "facedir",
		groups = v[3],
		stack_max = 32,
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
				param2 = 12
			end
			return minetest.item_place(itemstack, placer, pointed_thing, param2)
		end
	})

	minetest.register_node("trees:leaves_"..v[2], {
		description = v[1].." Leaves",
		drawtype = "allfaces_optional",
		waving = 1,
		paramtype = "light",
		tiles = {"trees_"..v[2].."_leaves.png"},
		special_tiles = {"trees_"..v[2].."_leaves_simple.png"},
		groups = {sword = 1, hand = 1, leaves = 1},
		stack_max = 64
	})

	slabs.register_slab("trees:trunk_"..v[2].."_slab", {
		description = v[1].." Trunk Slab",
		tiles = {"trees_"..v[2].."_trunk_top.png", "trees_"..v[2].."_trunk_top.png", "trees_"..v[2].."_trunk.png"},
		groups = v[3],
		stack_max = 64
	}, "trees:trunk_"..v[2])

	local wood_groups = table.copy(v[4])
	wood_groups.plank = 1
	wood_groups.pseudo_fence = 1
	minetest.register_node("trees:wood_"..v[2], {
		description = v[1].." Planks",
		paramtype2 = "facedir",
		tiles = {"trees_"..v[2].."_wood.png", "trees_"..v[2].."_wood.png", "trees_"..v[2].."_wood.png",
				"trees_"..v[2].."_wood.png", "trees_"..v[2].."_wood.png^[transformR90"},
		groups = wood_groups,
		stack_max = 64,
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local param2 = 0
			if under.y == above.y and under.z ~= above.z then
				param2 = 1
			elseif under.y ~= above.y then
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

	walls.register_fence("trees:wood_"..v[2].."_fence", {
		description = v[1].." Fence",
		tiles = {"trees_"..v[2].."_wood_fence_top.png", "trees_"..v[2].."_wood_fence_top.png", "trees_"..v[2].."_wood_fence_side.png"},
		inventory_image = "trees_"..v[2].."_wood_fence_inv.png",
		wield_image = "trees_"..v[2].."_wood_fence_wield.png",
		groups = v[4],
		stack_max = 64
	}, "trees:wood_"..v[2])

	doors.register_gate("trees:wood_"..v[2].."_gate", {
		description = v[1].." Gate",
		tiles = {"trees_"..v[2].."_wood_gate_top.png", "trees_"..v[2].."_wood_gate_top.png", "trees_"..v[2].."_wood_fence_side.png",
				"trees_"..v[2].."_wood_fence_side.png", "trees_"..v[2].."_wood_gate_side.png"},
		groups = v[4],
		stack_max = 64
	}, "trees:wood_"..v[2])

	slabs.register_slab("trees:wood_"..v[2].."_slab", {
		description = v[1].." Wood Slab",
		tiles = {{name = "trees_"..v[2].."_wood.png", align_style = "node"}, {name = "trees_"..v[2].."_wood.png", align_style = "node"}, "trees_"..v[2].."_wood.png"},
		groups = v[4],
		stack_max = 64,
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local face_pos = minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1
			local on_node = minetest.get_node(under)
			if on_node.name == "trees:wood_"..v[2].."_slab" and not minetest.is_protected(under, placer:get_player_name()) and
					((on_node.param2 > 19 and under.y > above.y) or (on_node.param2 < 4 and under.y < above.y)) then
				if not creative then
					itemstack:take_item()
				end
				if on_node.param2 == 1 or on_node.param2 == 21 then
					minetest.swap_node(under, {name = "trees:wood_"..v[2], param2 = 1})
				else
					minetest.swap_node(under, {name = "trees:wood_"..v[2], param2 = 0})
				end
				return itemstack
			end
			local param2 = 0
			if under.y > above.y or (under.y == above.y and face_pos < 0.5) then
				if under.y == above.y and under.z ~= above.z then
					param2 = 21
				elseif under.y > above.y then
					local pos = placer:get_pos()
					local x = pos.x - under.x
					local z = pos.z - under.z
					if math.abs(x) > math.abs(z) then
						param2 = 21
					else
						param2 = 22
					end
				else
					param2 = 22
				end
			elseif under.y == above.y and under.z ~= above.z then
				param2 = 1
			elseif under.y < above.y then
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
				if node.param2 == 22 then
					minetest.swap_node(pos, {name = node.name, param2 = 21})
				elseif node.param2 == 21 then
					minetest.swap_node(pos, {name = node.name, param2 = 22})
				elseif node.param2 == 0 then
					minetest.swap_node(pos, {name = node.name, param2 = 1})
				else
					minetest.swap_node(pos, {name = node.name, param2 = 0})
				end
				fresh_node[player_name] = nil
			end
			return minetest.node_punch(pos, node, puncher, pointed_thing)
		end
	}, "trees:wood_"..v[2])

	slabs.register_stair("trees:wood_"..v[2].."_stair", {
		description = v[1].." Wood Stair",
		groups = v[4],
		stack_max = 64
	}, "trees:wood_"..v[2], {
		{{name = "trees_"..v[2].."_wood.png", align_style = "node"}, {name = "trees_"..v[2].."_wood.png", align_style = "node"}, "trees_"..v[2].."_wood.png"},
		{{name = "trees_"..v[2].."_wood.png", align_style = "node"}, {name = "trees_"..v[2].."_wood.png", align_style = "node"}, "trees_"..v[2].."_wood.png"},
		{
			{name = "trees_"..v[2].."_wood.png^[lowpart:50:trees_"..v[2].."_wood.png\\^[transformR90", align_style = "node"},
			{name = "trees_"..v[2].."_wood.png^[transformR270^[lowpart:50:trees_"..v[2].."_wood.png", align_style = "node"},
			"trees_"..v[2].."_wood.png"
		}
	})

	local wood_blocks_groups = table.copy(v[4])
	wood_blocks_groups.falling_node = 1
	minetest.register_node("trees:wood_block_"..v[2], {
		description = v[1].." Wood Block",
		tiles = {"trees_"..v[2].."_wood_block.png"},
		groups = wood_blocks_groups,
		stack_max = 64
	})

	doors.register_door("trees:wood_"..v[2].."_door", {
		description = v[1].." Door",
		tiles = {"trees_"..v[2].."_door.png"},
		inventory_image = "trees_"..v[2].."_door_inv.png",
		mesh = v[5],
		groups = v[4],
		stack_max = 64
	}, "trees:wood_"..v[2])

	minetest.register_craft({
		output = "trees:wood_"..v[2].." 2",
		recipe = {{"trees:trunk_"..v[2]}}
	})

	minetest.register_craft({
		output = "trees:wood_block_"..v[2].." 4",
		recipe = {
			{"trees:wood_"..v[2], "trees:wood_"..v[2]},
			{"trees:wood_"..v[2], "trees:wood_"..v[2]}
		}
	})
end

minetest.register_node("trees:apple", {
	description = "Apple",
	drawtype = "nodebox",
	paramtype = "light",
	connects_to = {"trees:trunk_apple"},
	connect_sides = {"top"},
	node_box = {
		type = "connected",
    	connect_top = {-0.25, 0, -0.25, 0.25, 0.5, 0.25},
    	disconnected_top = {-0.25, -0.5, -0.25, 0.25, 0, 0.25}
	},
	tiles = {"trees_apple_top.png", "trees_apple_bottom.png", "trees_apple_side.png"},
	inventory_image = "trees_apple_inv.png",
	groups = {dig_immediate = 3},
	on_use = minetest.item_eat(2),
	stack_max = 64
})

minetest.register_node("trees:apple_unripe", {
	description = "Unripe Apple",
	drawtype = "nodebox",
	paramtype = "light",
	connects_to = {"trees:trunk_apple"},
	connect_sides = {"top"},
	node_box = {
		type = "connected",
    	connect_top = {-0.1875, 0.125, -0.1875, 0.1875, 0.5, 0.1875},
    	disconnected_top = {-0.1875, -0.5, -0.1875, 0.1875, -0.125, 0.1875}
	},
	tiles = {"trees_apple_unripe_top.png", "trees_apple_unripe_bottom.png", "trees_apple_unripe_side.png"},
	inventory_image = "trees_apple_unripe_inv.png",
	groups = {dig_immediate = 3},
	stack_max = 64
})

minetest.register_node("trees:wood_old", {
	description = "Old Planks",
	paramtype2 = "facedir",
	tiles = {"trees_old_wood.png", "trees_old_wood.png", "trees_old_wood.png", "trees_old_wood.png", "trees_old_wood.png^[transformR90"},
	groups = {axe = 1, hand = 3, plank = 1, pseudo_fence = 1},
	stack_max = 64,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local under = pointed_thing.under
		local above = pointed_thing.above
		local param2 = 0
		if under.y == above.y and under.z ~= above.z then
			param2 = 1
		elseif under.y ~= above.y then
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

walls.register_fence("trees:wood_old_fence", {
	description = "Old Fence",
	tiles = {"trees_old_wood_fence_top.png", "trees_old_wood_fence_top.png", "trees_old_wood_fence_side.png"},
	inventory_image = "trees_old_wood_fence_inv.png",
	wield_image = "trees_old_wood_fence_wield.png",
	groups = {axe = 1, hand = 3},
	stack_max = 64
}, "trees:wood_old")

slabs.register_slab("trees:wood_old_slab", {
	description = "Old Wood Slab",
	tiles = {{name = "trees_old_wood.png", align_style = "node"}, {name = "trees_old_wood.png", align_style = "node"}, "trees_old_wood.png"},
	groups = {axe = 1, hand = 3},
	stack_max = 64,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local under = pointed_thing.under
		local above = pointed_thing.above
		local face_pos = minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1
		local on_node = minetest.get_node(under)
		if on_node.name == "trees:wood_old_slab" and not minetest.is_protected(under, placer:get_player_name()) and
				((on_node.param2 > 19 and under.y > above.y) or (on_node.param2 < 4 and under.y < above.y)) then
			if not creative then
				itemstack:take_item()
			end
			if on_node.param2 == 1 or on_node.param2 == 21 then
				minetest.swap_node(under, {name = "trees:wood_old", param2 = 1})
			else
				minetest.swap_node(under, {name = "trees:wood_old", param2 = 0})
			end
			return itemstack
		end
		local param2 = 0
		if under.y > above.y or (under.y == above.y and face_pos < 0.5) then
			if under.y == above.y and under.z ~= above.z then
				param2 = 21
			elseif under.y > above.y then
				local pos = placer:get_pos()
				local x = pos.x - under.x
				local z = pos.z - under.z
				if math.abs(x) > math.abs(z) then
					param2 = 21
				else
					param2 = 22
				end
			else
				param2 = 22
			end
		elseif under.y == above.y and under.z ~= above.z then
			param2 = 1
		elseif under.y < above.y then
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
			if node.param2 == 22 then
				minetest.swap_node(pos, {name = node.name, param2 = 21})
			elseif node.param2 == 21 then
				minetest.swap_node(pos, {name = node.name, param2 = 22})
			elseif node.param2 == 0 then
				minetest.swap_node(pos, {name = node.name, param2 = 1})
			else
				minetest.swap_node(pos, {name = node.name, param2 = 0})
			end
			fresh_node[player_name] = nil
		end
		return minetest.node_punch(pos, node, puncher, pointed_thing)
	end
}, "trees:wood_old")

slabs.register_stair("trees:wood_old_stair", {
	description = "Old Wood Stair",
	groups = {axe = 1, hand = 3},
	stack_max = 64
}, "trees:wood_old", {
	{{name = "trees_old_wood.png", align_style = "node"}, {name = "trees_old_wood.png", align_style = "node"}, "trees_old_wood.png"},
	{{name = "trees_old_wood.png", align_style = "node"}, {name = "trees_old_wood.png", align_style = "node"}, "trees_old_wood.png"},
	{
		{name = "trees_old_wood.png^[lowpart:50:trees_old_wood.png\\^[transformR90", align_style = "node"},
		{name = "trees_old_wood.png^[transformR270^[lowpart:50:trees_old_wood.png", align_style = "node"},
		"trees_old_wood.png"
	}
})

minetest.register_node("trees:wood_block_old", {
	description = "Old Wood Block",
	tiles = {"trees_old_wood_block.png"},
	groups = {axe = 1, hand = 3, falling_node = 1},
	stack_max = 64
})

minetest.register_craft({
	output = "trees:wood_block_old 4",
	recipe = {
		{"trees:wood_old", "trees:wood_old"},
		{"trees:wood_old", "trees:wood_old"}
	}
})

minetest.register_abm({
	nodenames = {"trees:sapling_apple"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		local on = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
		if minetest.get_item_group(on.name, "soil") > 0 and minetest.get_node_light(pos) > 12 then
			minetest.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1}, modpath.."/schematics/apple_tree_sapling_1.mts", "0", nil, false)
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:sapling_baobab"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		local on = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
		if minetest.get_item_group(on.name, "soil") > 0 and minetest.get_node_light(pos) > 12 then
			minetest.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1}, modpath.."/schematics/baobab_tree_sapling_1.mts", "0", nil, false)
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:sapling_oak"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		local on = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
		if minetest.get_item_group(on.name, "soil") > 0 and minetest.get_node_light(pos) > 12 then
			minetest.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1}, modpath.."/schematics/oak_tree_sapling_1.mts", "0", nil, false)
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:sapling_willow"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		local on = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
		if minetest.get_item_group(on.name, "soil") > 0 and minetest.get_node_light(pos) > 12 then
			minetest.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1}, modpath.."/schematics/willow_tree_sapling_1.mts", "0", nil, false)
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:leaves_apple"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		if node.param2 == 1 and minetest.get_node_light(pos) > 12 then
			local node1 = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
			local node2 = minetest.get_node({x = pos.x, y = pos.y - 2, z = pos.z})
			if node1.name == "trees:trunk_apple" and node2.name == "trees:trunk_apple" then
				for _,v in ipairs({
					{x = pos.x, y = pos.y - 1, z = pos.z + 1},
					{x = pos.x + 1, y = pos.y - 1, z = pos.z},
					{x = pos.x, y = pos.y - 1, z = pos.z - 1},
					{x = pos.x - 1, y = pos.y - 1, z = pos.z}
				}) do
					local node = minetest.get_node(v)
					if node.name == "trees:leaves_apple" then
						minetest.remove_node(v)
					end
				end
				minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2}, modpath.."/schematics/apple_tree_sapling_2.mts", "0", nil, false)
			else
				minetest.swap_node(pos, {name = "trees:leaves_apple", param2 = 0})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:leaves_baobab"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		if node.param2 == 1 and minetest.get_node_light(pos) > 12 then
			local node1 = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
			local node2 = minetest.get_node({x = pos.x, y = pos.y - 2, z = pos.z})
			if node1.name == "trees:trunk_baobab" and node2.name == "trees:trunk_baobab" then
				for _,v in ipairs({
					{x = pos.x, y = pos.y - 1, z = pos.z + 1},
					{x = pos.x + 1, y = pos.y - 1, z = pos.z},
					{x = pos.x, y = pos.y - 1, z = pos.z - 1},
					{x = pos.x - 1, y = pos.y - 1, z = pos.z}
				}) do
					local node = minetest.get_node(v)
					if node.name == "trees:leaves_baobab" then
						minetest.remove_node(v)
					end
				end
				if math.random(4) == 1 then
					minetest.place_schematic({x = pos.x - 1, y = pos.y - 2, z = pos.z - 1}, modpath.."/schematics/baobab_tree_sapling_small.mts", "0", nil, false)
				else
					minetest.place_schematic({x = pos.x - 3, y = pos.y - 2, z = pos.z - 3}, modpath.."/schematics/baobab_tree_sapling_2.mts", "0", nil, false)
				end
			else
				minetest.swap_node(pos, {name = "trees:leaves_baobab", param2 = 0})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:leaves_oak"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		if node.param2 == 1 and minetest.get_node_light(pos) > 12 then
			local node1 = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
			local node2 = minetest.get_node({x = pos.x, y = pos.y - 2, z = pos.z})
			if node1.name == "trees:trunk_oak" and node2.name == "trees:trunk_oak" then
				for _,v in ipairs({
					{x = pos.x, y = pos.y - 1, z = pos.z + 1},
					{x = pos.x + 1, y = pos.y - 1, z = pos.z},
					{x = pos.x, y = pos.y - 1, z = pos.z - 1},
					{x = pos.x - 1, y = pos.y - 1, z = pos.z}
				}) do
					local node = minetest.get_node(v)
					if node.name == "trees:leaves_oak" then
						minetest.remove_node(v)
					end
				end
				minetest.place_schematic({x = pos.x - 3, y = pos.y - 3, z = pos.z - 3}, modpath.."/schematics/oak_tree_sapling_2.mts", "0", nil, false)
			else
				minetest.swap_node(pos, {name = "trees:leaves_oak", param2 = 0})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:leaves_willow"},
	interval = 10,
	chance = 25,
	catch_up = false,
	action = function(pos, node)
		if node.param2 == 1 and minetest.get_node_light(pos) > 12 then
			local node1 = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
			local node2 = minetest.get_node({x = pos.x, y = pos.y - 2, z = pos.z})
			if node1.name == "trees:trunk_willow" and node2.name == "trees:trunk_willow" then
				for _,v in ipairs({
					{x = pos.x, y = pos.y, z = pos.z + 1},
					{x = pos.x + 1, y = pos.y, z = pos.z},
					{x = pos.x, y = pos.y, z = pos.z - 1},
					{x = pos.x - 1, y = pos.y, z = pos.z}
				}) do
					if minetest.get_node(v).name == "trees:leaves_willow" then
						minetest.remove_node(v)
					end
					local under = {x = v.x, y = v.y - 1, z = v.z}
					if minetest.get_node(under).name == "trees:leaves_willow" then
						minetest.remove_node(under)
					end
				end
				minetest.place_schematic({x = pos.x - 2, y = pos.y - 2, z = pos.z - 2}, modpath.."/schematics/willow_tree_sapling_2.mts", "0", nil, false)
			else
				minetest.swap_node(pos, {name = "trees:leaves_willow", param2 = 0})
			end
		end
	end
})

local find_apple_trunk = function(pos)
	local node = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})
	if node.name == "trees:trunk_apple" then
		return {x = pos.x, y = pos.y, z = pos.z + 1}
	end
	local node = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z})
	if node.name == "trees:trunk_apple" then
		return {x = pos.x + 1, y = pos.y, z = pos.z}
	end
	local node = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})
	if node.name == "trees:trunk_apple" then
		return {x = pos.x, y = pos.y, z = pos.z - 1}
	end
	local node = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z})
	if node.name == "trees:trunk_apple" then
		return {x = pos.x - 1, y = pos.y, z = pos.z}
	end
	return false
end

minetest.register_abm({
	nodenames = {"trees:trunk_apple"},
	interval = 10,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		if node.param2 == 22 then
			local leaf_pos = minetest.find_node_near(pos, 1, "trees:leaves_apple")
			if leaf_pos and minetest.get_node_light(leaf_pos) > 10 then
				local trunk_pos = find_apple_trunk(pos)
				if trunk_pos then
					local node1 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 1, z = trunk_pos.z})
					local node2 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 2, z = trunk_pos.z})
					local node3 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 3, z = trunk_pos.z})
					local node4 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 4, z = trunk_pos.z})
					if node1.name == "trees:trunk_apple" and node2.name == "trees:trunk_apple" and
							(minetest.get_item_group(node3.name, "soil") > 0 or (node3.name == "trees:trunk_apple" and minetest.get_item_group(node4.name, "soil"))) then
						local apple_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
						local apple_node = minetest.get_node(apple_pos)
						if apple_node.name == "air" then
							minetest.set_node(apple_pos, {name = "trees:apple_unripe", param2 = 0})
						end
					else
						minetest.swap_node(pos, {name = "trees:trunk_apple", param2 = 0})
					end
				else
					minetest.swap_node(pos, {name = "trees:trunk_apple", param2 = 0})
				end
			elseif not leaf_pos then
				minetest.swap_node(pos, {name = "trees:trunk_apple", param2 = 0})
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"trees:apple_unripe"},
	interval = 10,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		if node.param2 == 0 then
			local branch_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
			local branch_node = minetest.get_node(branch_pos)
			local leaf_pos = minetest.find_node_near(branch_pos, 1, "trees:leaves_apple")
			if leaf_pos and minetest.get_node_light(leaf_pos) > 10 and branch_node.name == "trees:trunk_apple" then
				local trunk_pos = find_apple_trunk(branch_pos)
				if trunk_pos then
					local node1 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 1, z = trunk_pos.z})
					local node2 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 2, z = trunk_pos.z})
					local node3 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 3, z = trunk_pos.z})
					local node4 = minetest.get_node({x = trunk_pos.x, y = trunk_pos.y - 4, z = trunk_pos.z})
					if node1.name == "trees:trunk_apple" and node2.name == "trees:trunk_apple" and
							(minetest.get_item_group(node3.name, "soil") > 0 or (node3.name == "trees:trunk_apple" and minetest.get_item_group(node4.name, "soil"))) then
						minetest.swap_node(pos, {name = "trees:apple", param2 = 0})
					end
				end
			end
		end
	end
})
