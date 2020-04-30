for _,v in ipairs({{"Coal", "coal"}, {"Gold", "gold"}, {"Iron", "iron"}, {"Silver", "silver"}}) do
	minetest.register_node("ores:"..v[2].."_in_stone", {
		description = v[1].." in Stone",
		tiles = {"murk_stone.png^ores_"..v[2].."_ore.png"},
		groups = {pick = 2},
		drop = "ores:"..v[2].."_lump",
		stack_max = 32
	})

	minetest.register_craftitem("ores:"..v[2].."_lump", {
		description = v[1].." Lump",
		inventory_image = "ores_"..v[2].."_lump.png",
		wield_image = "ores_"..v[2].."_lump.png",
		stack_max = 64
	})
end

for _,v in ipairs({{"Gold", "gold"}, {"Iron", "iron"}, {"Silver", "silver"}}) do
	minetest.register_craftitem("ores:"..v[2].."_ingot", {
		description = v[1].." Ingot",
		inventory_image = "ores_"..v[2].."_ingot.png",
		wield_image = "ores_"..v[2].."_ingot.png",
		stack_max = 64
	})
end

minetest.register_node("ores:coal_block", {
	description = "Coal Block",
	tiles = {"ores_coal_block.png"},
	groups = {pick = 2, hand = 3},
	stack_max = 64
})

minetest.register_node("ores:iron_block", {
	description = "Iron Block",
	tiles = {"ores_iron_block.png"},
	groups = {pick = 4},
	stack_max = 32
})

slabs.register_slab_and_stair("ores:iron_block", {
	description = "Iron",
	tiles = {"ores_iron_block.png"},
	groups = {pick = 4},
	stack_max = 32
})

doors.register_door("ores:iron_door", {
	description = "Iron Door",
	tiles = {"ores_iron_door.png"},
	inventory_image = "ores_iron_door_inv.png",
	mesh = "metal",
	groups = {pick = 4},
	stack_max = 32
})

minetest.register_node("ores:gold_block", {
	description = "Gold Block",
	tiles = {"ores_gold_block.png"},
	groups = {pick = 3},
	stack_max = 32
})

slabs.register_slab_and_stair("ores:gold_block", {
	description = "Gold",
	tiles = {"ores_gold_block.png"},
	groups = {pick = 3},
	stack_max = 32
})

panes.register_pane("ores:iron_bar", {
	description = "Iron Bars",
	tiles = {{name = "ores_iron_bar_top.png", align_style = "user"}, {name = "ores_iron_bar_top.png", align_style = "user"}, "ores_iron_bar_side.png"},
	inventory_image = "ores_iron_bar_side.png",
	node_box = panes.boxes.bars,
	collision_box = panes.boxes.fat,
	selection_box = panes.boxes.fat,
	groups = {pick = 3},
	stack_max = 64
})

panes.register_pane("ores:gold_bar", {
	description = "Gold Bars",
	tiles = {{name = "ores_gold_bar_top.png", align_style = "user"}, {name = "ores_gold_bar_top.png", align_style = "user"}, "ores_gold_bar_side.png"},
	inventory_image = "ores_gold_bar_side.png",
	node_box = panes.boxes.bars,
	collision_box = panes.boxes.fat,
	selection_box = panes.boxes.fat,
	groups = {pick = 2},
	stack_max = 64
})
