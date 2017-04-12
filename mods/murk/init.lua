local modpath = minetest.get_modpath("murk")

---[[ test code
minetest.register_node("murk:schemtest", {
	description = "Schematic Tester",
	tiles = {"unknown_node.png"},
	groups = {dig_immediate = 2},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minetest.place_schematic({x = pos.x - 2, y = pos.y, z = pos.z - 2}, modpath.."/schematics/willow_tree.mts", "0", nil, false)
	end
})

minetest.register_craftitem("murk:node_info", {
	description = "Get node info",
	inventory_image = "unknown_node.png",
	wield_image = "unknown_node.png",
	on_use = function(itemstack, user, pointed_thing)
		local node = minetest.get_node(pointed_thing.under)
		local above_light = minetest.get_node_light({x = pointed_thing.under.x, y = pointed_thing.under.y + 1, z = pointed_thing.under.z})
		local above_light_day = minetest.get_node_light({x = pointed_thing.under.x, y = pointed_thing.under.y + 1, z = pointed_thing.under.z}, 0.5)
		minetest.chat_send_player(user:get_player_name(), "name = \""..node.name.."\", param1 = "..node.param1..", param2 = "..node.param2..
				", above light  = "..above_light..", above light day = "..above_light_day)
	end
})
--]]

dofile(modpath.."/items_and_crafts.lua")
dofile(modpath.."/block_modifiers.lua")
