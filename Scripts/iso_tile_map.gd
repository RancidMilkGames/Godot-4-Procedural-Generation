extends TileMap

var noise_text: NoiseTexture2D = NoiseTexture2D.new()
var water_noise_text: NoiseTexture2D = NoiseTexture2D.new()

var width = 170.0 / 4
var height = 170.0 / 2

var water_tiles = []
var offset = 0
# Called when the node enters the scene tree for the first time.
func _ready():
#	noise_text.seamless = true
#	noise_text.noise = FastNoiseLite.new()
#	noise_text.noise.seed = randi_range(0, 1000000)
#	await noise_text.changed
	noise_text = get_parent().noise_text
	await get_tree().create_timer(1).timeout
	
	for w in range(-1, width):
		for h in range(-1, height):
			var vec_cell = Vector2i(w, h)
			var ww = w + (position.x / 16)
			var hh = h + (position.y / 4)
			var noise_val = noise_text.noise.get_noise_2d(ww, hh)
			if noise_val > .4:
				if w == -1 or w == width:
					set_cell(0, vec_cell, 1, Vector2i(3, 0))
				else:
					set_cell(0, vec_cell, 0, Vector2i(3, 0))
			elif noise_val > .11:
				if w == -1 or w == width:
					set_cell(0, vec_cell, 1, Vector2i(0, 0))
				else:
					set_cell(0, vec_cell, 0, Vector2i(0, 0))
			elif noise_val > .09:
				if w == -1 or w == width:
					set_cell(0, vec_cell, 1, Vector2i(0, 1))
				else:
					set_cell(0, vec_cell, 0, Vector2i(0, 1))
			elif noise_val > .04:
				if w == -1 or w == width:
					set_cell(0, vec_cell, 1, Vector2i(0, 3))
				else:
					set_cell(0, vec_cell, 0, Vector2i(0, 3))
			else:
				if w == -1 or w == width:
					set_cell(0, vec_cell, 1, Vector2i(0, 5))
				else:
					set_cell(0, vec_cell, 0, Vector2i(0, 5))
				water_tiles.append(vec_cell)

	water_noise_text = get_parent().water_noise_text
	

func _on_timer_timeout():
	for wt in water_tiles:
		#await get_tree().physics_frame
		if water_noise_text.noise.get_noise_3d(wt.x + (position.x / 16), wt.y + (position.y / 4), offset) > .11:
			if wt.x == - 1 or wt.x == width:
				set_cell(0, wt, 1, Vector2i(0, 5))
			else:
				set_cell(0, wt, 0, Vector2i(0, 5)) #  + Vector2i(offset, offset)
		else:
			if wt.x == - 1 or wt.x == width:
				set_cell(0, wt, 1, Vector2i(3, 5))
			else:
				set_cell(0, wt, 0, Vector2i(3, 5)) #  + Vector2i(offset, offset)
			
	offset += 1
#	water_noise_text.noise.offset.z += 1
#	water_noise_text.noise.offset.x += 1
#	water_noise_text.noise.offset.y += 1
