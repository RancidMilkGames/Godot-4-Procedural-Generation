extends TileMap

var noise_text: NoiseTexture2D = NoiseTexture2D.new()
var water_noise_text: NoiseTexture2D = NoiseTexture2D.new()

var width = 170
var height = 170 * 2

var water_tiles = []
var offset = 0


func _ready():
	noise_text = get_tree().get_first_node_in_group("SimpleISO").noise_text
	await get_tree().create_timer(1).timeout
	
	for w in width:
		for h in height:
			var vec_cell = Vector2i(w, h)
			var ww = w + (position.x / 18)
			var hh = h + (position.y / 20)
			var noise_val = noise_text.noise.get_noise_2d(ww, hh)
			if noise_val > .4:
				set_cell(0, vec_cell, 0, Vector2i(3, 0))
			elif noise_val > .11:
				set_cell(0, vec_cell, 0, Vector2i(0, 0))
			elif noise_val > .09:
				set_cell(0, vec_cell, 0, Vector2i(0, 1))
			elif noise_val > .04:
				set_cell(0, vec_cell, 0, Vector2i(0, 3))
			else:
				set_cell(0, vec_cell, 0, Vector2i(0, 5))
				water_tiles.append(vec_cell)

	water_noise_text.seamless = true
	water_noise_text.noise = FastNoiseLite.new()
	water_noise_text.noise.seed = randi_range(0, 1000000)
	water_noise_text.in_3d_space = true
	Global.overlay.loading_screen.visible = false
	

func _on_timer_timeout():
	for wt in water_tiles:
		#await get_tree().physics_frame
		if water_noise_text.noise.get_noise_3d(wt.x, wt.y, offset) > .11:
			set_cell(0, wt, 0, Vector2i(0, 5))
		else:
			set_cell(0, wt, 0, Vector2i(3, 5))

	offset += 1
