local creative = minetest.setting_getbool("creative_mode")

if creative then
	minetest.register_item(":", {
		type = "none",
		wield_image = "tools_hand.png",
		wield_scale = {x = 1, y = 1, z = 2.5},
		tool_capabilities = {
			full_punch_interval = 1,
			max_drop_level = 0,
			groupcaps = {
				shovel = {times = {0.5, 0.5, 0.5, 0.5}, uses = 0, maxlevel = 3},
				pick = {times = {0.5, 0.5, 0.5, 0.5}, uses = 0, maxlevel = 3},
				sword = {times = {0.5, 0.5, 0.5, 0.5}, uses = 0, maxlevel = 3},
				axe = {times = {0.5, 0.5, 0.5, 0.5}, uses = 0, maxlevel = 3},
				hand = {times = {0.5, 0.5, 0.5, 0.5}, uses = 0, maxlevel = 3}
			}
		}
	})
else
	minetest.register_item(":", {
		type = "none",
		wield_image = "tools_hand.png",
		wield_scale = {x = 1, y = 1, z = 2.5},
		tool_capabilities = {
			full_punch_interval = 1,
			max_drop_level = 0,
			groupcaps = {
				hand = {times = {1.4, 2.2, 4, 7}, uses = 0, maxlevel = 3}
			}
		}
	})
end

minetest.register_craftitem("tools:stick", {
	description = "Stick",
	inventory_image = "tools_stick.png",
	wield_image = "tools_stick.png"
})

minetest.register_craft({
	output = "tools:stick 4",
	recipe = {{"group:plank"}}
})
