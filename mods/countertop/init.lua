countertop = {}

function countertop.register_pedestal(name, def)
	local pedestal_def = table.copy(def)
	pedestal_def.drawtype = "nodebox"
	pedestal_def.paramtype = "light"
	pedestal_def.node_box = {
		type = "connected",
		fixed = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
		connect_front = {-0.25, -0.5, -0.5, 0.25, 0.5, -0.3125},
		connect_left = {-0.5, -0.5, -0.25, -0.3125, 0.5, 0.25},
		connect_back = {-0.25, -0.5, 0.3125, 0.25, 0.5, 0.5},
		connect_right = {0.3125, -0.5, -0.25, 0.5, 0.5, 0.25},
		disconnected_top = {-0.5, 0.25, -0.5, 0.5, 0.5, 0.5},
		disconnected_bottom = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}
	}
	pedestal_def.collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	if def.groups.pseudo_wall == nil then
		pedestal_def.groups.pseudo_wall = 1
	end
	if not def.connects_to then
		pedestal_def.connects_to = {name}
	end
	pedestal_def.stack_max = def.stack_max or 1024

	minetest.register_node(name, pedestal_def)
end
