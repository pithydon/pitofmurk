mini_blocks = {}

local creative = minetest.setting_getbool("creative_mode")

local tile_mod = function(tiles)
	if tiles then
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
end

local get_stair_param = function(node)
	local stair = minetest.get_item_group(node.name, "stair")
	local param = (node.param2 % 32) % 24
	if stair == 0 or (param > 3 and param < 20) then
		return
	elseif stair == 1 then
		return param
	elseif stair == 2 then
		if param < 12 then
			return param + 4
		else
			return param - 4
		end
	elseif stair == 3 then
		if param < 12 then
			return param + 8
		else
			return param - 8
		end
	end
end

local on_place_stair = function(itemstack, placer, pointed_thing, colored)
	if pointed_thing.type ~= "node" then
		return itemstack
	end
	local under = pointed_thing.under
	local above = pointed_thing.above
	local param2
	local placer_pos = placer:get_pos()
	local x = placer_pos.x - under.x
	local z = placer_pos.z - under.z
	if math.abs(x) > math.abs(z) then
		if placer_pos.x > under.x then
			param2 = 3
		else
			param2 = 1
		end
	else
		if placer_pos.z > under.z then
			param2 = 2
		else
			param2 = 0
		end
	end
	if under.y > above.y or (under.y == above.y and minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1 < 0.5) then
		if param2 == 0 then
			param2 = 20
		elseif param2 == 1 then
			param2 = 23
		elseif param2 == 2 then
			param2 = 22
		else
			param2 = 21
		end
	end
	if colored then
		local meta = itemstack:get_meta()
		local color = meta:get("palette_index")
		if color == nil then
			color = 0
		end
		param2 = param2 + (32 * color)
	end
	return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
end

local after_place_stair = function(pos, outer_stair, inner_stair)
	local node = minetest.get_node(pos)
	local facedir = node.param2 % 32
	local color = node.param2 - facedir
	if facedir == 0 then
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
		if param then
			if param == 3 or param == 7 or param == 8 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 0 and param ~= 4 and param ~= 9) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 0 + color})
					return
				end
			elseif param == 1 or param == 6 or param == 9 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 0 and param ~= 5 and param ~= 8) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 1 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
		if param then
			if param == 1 or param == 5 or param == 10 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 0 and param ~= 4 and param ~= 9) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 1 + color})
					return
				end
			elseif param == 3 or param == 4 or param == 11 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 0 and param ~= 5 and param ~= 8) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 0 + color})
					return
				end
			end
		end
	elseif facedir == 1 then
		local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
		if param then
			if param == 2 or param == 7 or param == 10 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 1 and param ~= 6 and param ~= 9) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 2 + color})
					return
				end
			elseif param == 0 or param == 4 or param == 9 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 1 and param ~= 5 and param ~= 10) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 1 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
		if param then
			if param == 0 or param == 5 or param == 8 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 1 and param ~= 6 and param ~= 9) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 1 + color})
					return
				end
			elseif param == 2 or param == 6 or param == 11 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 1 and param ~= 5 and param ~= 10) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 2 + color})
					return
				end
			end
		end
	elseif facedir == 2 then
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
		if param then
			if param == 1 or param == 6 or param == 9 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 2 and param ~= 7 and param ~= 10) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 2 + color})
					return
				end
			elseif param == 3 or param == 7 or param == 8 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 2 and param ~= 6 and param ~= 11) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 3 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
		if param then
			if param == 3 or param == 4 or param == 11 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 2 and param ~= 7 and param ~= 10) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 3 + color})
					return
				end
			elseif param == 1 or param == 5 or param == 10 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 2 and param ~= 6 and param ~= 11) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 2 + color})
					return
				end
			end
		end
	elseif facedir == 3 then
		local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
		if param then
			if param == 0 or param == 4 or param == 9 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 3 and param ~= 7 and param ~= 8) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 0 + color})
					return
				end
			elseif param == 2 or param == 7 or param == 10 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 3 and param ~= 4 and param ~= 11) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 3 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
		if param then
			if param == 2 or param == 6 or param == 11 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 3 and param ~= 7 and param ~= 8) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 3 + color})
					return
				end
			elseif param == 0 or param == 5 or param == 8 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 3 and param ~= 4 and param ~= 11) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 0 + color})
					return
				end
			end
		end
	elseif facedir == 20 then
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
		if param then
			if param == 21 or param == 18 or param == 13 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 20 and param ~= 17 and param ~= 12) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 21 + color})
					return
				end
			elseif param == 23 or param == 19 or param == 12 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 20 and param ~= 16 and param ~= 13) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 20 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
		if param then
			if param == 23 or param == 16 or param == 15 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 20 and param ~= 17 and param ~= 12) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 20 + color})
					return
				end
			elseif param == 21 or param == 17 or param == 14 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 20 and param ~= 16 and param ~= 13) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 21 + color})
					return
				end
			end
		end
	elseif facedir == 21 then
		local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
		if param then
			if param == 20 or param == 17 or param == 12 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 21 and param ~= 18 and param ~= 13) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 21 + color})
					return
				end
			elseif param == 22 or param == 18 or param == 15 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 21 and param ~= 17 and param ~= 14) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 22 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
		if param then
			if param == 22 or param == 19 or param == 14 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 21 and param ~= 18 and param ~= 13) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 22 + color})
					return
				end
			elseif param == 20 or param == 16 or param == 13 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 21 and param ~= 17 and param ~= 14) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 21 + color})
					return
				end
			end
		end
	elseif facedir == 22 then
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
		if param then
			if param == 23 or param == 19 or param == 12 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 22 and param ~= 18 and param ~= 15) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 23 + color})
					return
				end
			elseif param == 21 or param == 18 or param == 13 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 22 and param ~= 19 and param ~= 14) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 22 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
		if param then
			if param == 21 or param == 17 or param == 14 then
				local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 22 and param ~= 18 and param ~= 15) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 22 + color})
					return
				end
			elseif param == 23 or param == 16 or param == 15 then
				local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
				if not param or (param ~= 22 and param ~= 19 and param ~= 14) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 23 + color})
					return
				end
			end
		end
	elseif facedir == 23 then
		local param = get_stair_param(minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}))
		if param then
			if param == 22 or param == 18 or param == 15 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 23 and param ~= 19 and param ~= 12) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 23 + color})
					return
				end
			elseif param == 20 or param == 17 or param == 12 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 23 and param ~= 16 and param ~= 15) then
					minetest.swap_node(pos, {name = outer_stair, param2 = 20 + color})
					return
				end
			end
		end
		local param = get_stair_param(minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}))
		if param then
			if param == 20 or param == 16 or param == 13 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}))
				if not param or (param ~= 23 and param ~= 19 and param ~= 12) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 20 + color})
					return
				end
			elseif param == 22 or param == 19 or param == 14 then
				local param = get_stair_param(minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}))
				if not param or (param ~= 23 and param ~= 16 and param ~= 15) then
					minetest.swap_node(pos, {name = inner_stair, param2 = 23 + color})
					return
				end
			end
		end
	end
end

function mini_blocks.register_slab(name, def)
	local slab_def = table.copy(def)
	slab_def.drawtype = "nodebox"
	slab_def.paramtype = "light"
	slab_def.paramtype2 = def.paramtype2 or "facedir"
	slab_def.groups.slab = 1
	slab_def.tiles = tile_mod(def.tiles)
	slab_def.overlay_tiles = tile_mod(def.overlay_tiles)
	slab_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
	}
	slab_def.on_place = def.on_place or function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local under = pointed_thing.under
		local above = pointed_thing.above
		local face_pos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local param2 = 0
		if under.y > above.y or (under.y == above.y and face_pos.y % 1 < 0.5) then
			param2 = 22
		end
		if placer:get_player_control().sneak then
			if under.x > above.x then
				param2 = 17
			elseif under.x < above.x then
				param2 = 15
			elseif under.z > above.z then
				param2 = 8
			elseif under.z < above.z then
				param2 = 6
			else
				local placer_pos = placer:get_pos()
				local x = placer_pos.x - under.x
				local z = placer_pos.z - under.z
				if math.abs(x) > math.abs(z) then
					if placer_pos.x > under.x then
						if face_pos.x % 1 > 0.5 then
							param2 = 15
						end
					elseif face_pos.x % 1 < 0.5 then
						param2 = 17
					end
				else
					if placer_pos.z > under.z then
						if face_pos.z % 1 > 0.5 then
							param2 = 6
						end
					elseif face_pos.z % 1 < 0.5 then
						param2 = 8
					end
				end
			end
		end
		if slab_def.paramtype2 == "colorfacedir" then
			local meta = itemstack:get_meta()
			local color = meta:get("palette_index")
			if color == nil then
				color = 0
			end
			param2 = param2 + (32 * color)
		end
		return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	end
	slab_def.stack_max = def.stack_max or 2048

	minetest.register_node(name, slab_def)
end

function mini_blocks.register_stair(name, def)
	local stair_inner_def = table.copy(def)
	stair_inner_def.drawtype = "nodebox"
	stair_inner_def.paramtype = "light"
	stair_inner_def.paramtype2 = def.paramtype2 or "facedir"
	stair_inner_def.drop = def.drop or name
	stair_inner_def.groups.not_in_creative_inventory = 1
	stair_inner_def.groups.stair = 3
	stair_inner_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
			{-0.5, 0, -0.5, 0, 0.5, 0},
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		}
	}
	stair_inner_def.stack_max = def.stack_max or 1024
	local colored = false
	if def.paramtype2 == "colorfacedir" then
		colored = true
	end
	stair_inner_def.on_place = function(itemstack, placer, pointed_thing)
		return on_place_stair(itemstack, placer, pointed_thing, colored)
	end
	local stair_outer_def = table.copy(stair_inner_def)
	stair_outer_def.groups.stair = 2
	stair_outer_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, 0, 0, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		}
	}
	local stair_def = table.copy(stair_inner_def)
	stair_def.groups.not_in_creative_inventory = 0
	stair_def.groups.stair = 1
	stair_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		}
	}
	stair_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		return after_place_stair(pos, name.."_outer", name.."_inner")
	end
	if def.tiles.stair then
		stair_def.tiles = tile_mod(def.tiles.stair)
		stair_outer_def.tiles = tile_mod(def.tiles.stair_outer)
		stair_inner_def.tiles = tile_mod(def.tiles.stair_inner)
	else
		local tiles = tile_mod(def.tiles)
		stair_def.tiles = tiles
		stair_outer_def.tiles = tiles
		stair_inner_def.tiles = tiles
	end

	minetest.register_node(name, stair_def)
	minetest.register_node(name.."_outer", stair_outer_def)
	minetest.register_node(name.."_inner", stair_inner_def)
end

function mini_blocks.register_step(name, def)
	local step_inner_def = table.copy(def)
	step_inner_def.drawtype = "nodebox"
	step_inner_def.paramtype = "light"
	step_inner_def.paramtype2 = def.paramtype2 or "facedir"
	step_inner_def.drop = def.drop or name
	step_inner_def.groups.not_in_creative_inventory = 1
	step_inner_def.groups.stair = 3
	step_inner_def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0, 0.5},
			{-0.5, -0.5, -0.5, 0, 0, 0}
		}
	}
	step_inner_def.stack_max = def.stack_max or 2048
	local colored = false
	if def.paramtype2 == "colorfacedir" then
		colored = true
	end
	step_inner_def.on_place = function(itemstack, placer, pointed_thing)
		return on_place_stair(itemstack, placer, pointed_thing, colored)
	end
	local step_outer_def = table.copy(step_inner_def)
	step_outer_def.groups.stair = 2
	step_outer_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0, 0, 0.5}
	}
	local step_def = table.copy(step_inner_def)
	step_def.groups.not_in_creative_inventory = 0
	step_def.groups.stair = 1
	step_def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0.5, 0, 0.5}
	}
	step_def.after_place_node = function(pos, placer, itemstack, pointed_thing)
		return after_place_stair(pos, name.."_outer", name.."_inner")
	end
	if def.tiles.step then
		step_def.tiles = tile_mod(def.tiles.step)
		step_outer_def.tiles = tile_mod(def.tiles.step_outer)
		step_inner_def.tiles = tile_mod(def.tiles.step_inner)
	else
		local tiles = tile_mod(def.tiles)
		step_def.tiles = tiles
		step_outer_def.tiles = tiles
		step_inner_def.tiles = tiles
	end

	minetest.register_node(name, step_def)
	minetest.register_node(name.."_outer", step_outer_def)
	minetest.register_node(name.."_inner", step_inner_def)
end

function mini_blocks.register_all(name, def)
	local slab_def = table.copy(def)
	local stair_def = table.copy(def)
	local step_def = table.copy(def)
	slab_def.description = def.description.." Slab"
	stair_def.description = def.description.." Stair"
	step_def.description = def.description.." Step"
	mini_blocks.register_slab(name.."_slab", slab_def)
	mini_blocks.register_stair(name.."_stair", stair_def)
	mini_blocks.register_step(name.."_step", step_def)
end
