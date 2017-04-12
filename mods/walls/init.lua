walls = {}

function walls.register_wall(name, def, recipeitem)
	local wall_def = table.copy(def)
	wall_def.drawtype = "nodebox"
	wall_def.paramtype = "light"
	wall_def.node_box = {
		type = "connected",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 0.25, -0.25},
		connect_left = {-0.5, -0.5, -0.25, -0.25, 0.25, 0.25},
		connect_back = {-0.25, -0.5, 0.25, 0.25, 0.25, 0.5},
		connect_right = {0.25, -0.5, -0.25, 0.5, 0.25, 0.25}
	}
	wall_def.collision_box = {
		type = "connected",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 0.5, -0.25},
		connect_left = {-0.5, -0.5, -0.25, -0.25, 0.5, 0.25},
		connect_back = {-0.25, -0.5, 0.25, 0.25, 0.5, 0.5},
		connect_right = {0.25, -0.5, -0.25, 0.5, 0.5, 0.25}
	}
	if def.groups.wall == nil then
		wall_def.groups.wall = 1
	end
	if not def.connects_to then
		wall_def.connects_to = {"group:wall", "group:pseudo_wall"}
	end

	minetest.register_node(name, wall_def)

	if recipeitem then
		minetest.register_craft({
			output = name.." 4",
			recipe = {
				{"", recipeitem, ""},
				{recipeitem, recipeitem, recipeitem}
			}
		})
	end
end

function walls.register_fence(name, def, recipeitem)
	local fence_def = table.copy(def)
	fence_def.drawtype = "nodebox"
	fence_def.paramtype = "light"
	fence_def.node_box = {
		type = "connected",
		fixed = {-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		connect_front = {{-0.125, 0.125, -0.5, 0.125, 0.375, -0.125}, {-0.125, -0.375, -0.5, 0.125, -0.125, -0.125}},
		connect_left = {{-0.5, 0.125, -0.125, -0.125, 0.375, 0.125}, {-0.5, -0.375, -0.125, -0.125, -0.125, 0.125}},
		connect_back = {{-0.125, 0.125, 0.125, 0.125, 0.375, 0.5}, {-0.125, -0.375, 0.125, 0.125, -0.125, 0.5}},
		connect_right = {{0.125, 0.125, -0.125, 0.5, 0.375, 0.125}, {0.125, -0.375, -0.125, 0.5, -0.125, 0.125}}
	}
	fence_def.collision_box = {
		type = "connected",
		fixed = {-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		connect_front = {-0.125, -0.5, -0.5, 0.125, 0.5, -0.125},
		connect_left = {-0.5, -0.5, -0.125, -0.125, 0.5, 0.125},
		connect_back = {-0.125, -0.5, 0.125, 0.125, 0.5, 0.5},
		connect_right = {0.125, -0.5, -0.125, 0.5, 0.5, 0.125}
	}
	if def.groups.fence == nil then
		fence_def.groups.fence = 1
	end
	if not def.connects_to then
		fence_def.connects_to = {"group:fence", "group:pseudo_fence"}
	end

	minetest.register_node(name, fence_def)

	if recipeitem then
		minetest.register_craft({
			output = name.." 2",
			recipe = {{"tools:stick", recipeitem, "tools:stick"}}
		})
	end
end

function walls.register_pedestal(name, def, recipebase, recipetop)
	local pedestal_def = table.copy(def)
	pedestal_def.drawtype = "nodebox"
	pedestal_def.paramtype = "light"
	pedestal_def.node_box = {
		type = "connected",
		fixed = {{-0.5, 0.25, -0.5, 0.5, 0.5, 0.5}, {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 0.25, -0.25},
		connect_left = {-0.5, -0.5, -0.25, -0.25, 0.25, 0.25},
		connect_back = {-0.25, -0.5, 0.25, 0.25, 0.25, 0.5},
		connect_right = {0.25, -0.5, -0.25, 0.5, 0.25, 0.25}
	}
	pedestal_def.collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	if def.groups.pseudo_wall == nil then
		pedestal_def.groups.pseudo_wall = 1
	end
	if not def.connects_to then
		if recipebase then
			pedestal_def.connects_to = {recipebase, name}
		else
			pedestal_def.connects_to = {name}
		end
	end

	minetest.register_node(name, pedestal_def)

	if recipebase and recipetop then
		minetest.register_craft({
			output = name,
			recipe = {
				{recipetop},
				{recipebase}
			}
		})
	end
end
