minetest.register_on_joinplayer(function(player)
	player:set_properties({
		mesh = "player_default.b3d",
		textures = {"player_default.png"},
		visual = "mesh",
		visual_size = {x = 0.625, y = 0.625}
	})
	player:set_local_animation({x = 0, y = 0}, {x = 5, y = 28}, {x = 30, y = 41}, {x = 43, y = 66}, 30)
end)
