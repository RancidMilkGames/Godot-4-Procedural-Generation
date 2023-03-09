extends TileMap

var noise_text: NoiseTexture2D = NoiseTexture2D.new()
var noise: Noise
@export var min_land_tiles = 5000
@export var width: Vector2i = Vector2i(-10, 100)
@export var height: Vector2i = Vector2i(-10, 100)
@export var edge_cells: Array[Vector2i]
var open_cells = []


func _ready():
	generate.call()
	
var generate = func gen_map():
	noise_text.seamless = true
	noise_text.noise = FastNoiseLite.new()
	noise_text.noise.seed = randi_range(0, 1000000)
	await noise_text.changed
	
	var to_connect = []
	var water_connect = []
	var decor_connect = []
	var tree_decor_connect = []
	
	for i in range(width.x, width.y):
		for j in range(height.x, height.y):
			var vec_cell = Vector2i(i, j)
			if .4 < noise_text.noise.get_noise_2d(i, j) and \
			.5 > noise_text.noise.get_noise_2d(i, j):
				tree_decor_connect.append(Vector2(i, j))
			elif .3 < noise_text.noise.get_noise_2d(i, j):
				decor_connect.append(Vector2(i, j))
			elif noise_text.noise.get_noise_2d(i, j) > .09:
				to_connect.append(vec_cell)
			else:
				water_connect.append(vec_cell)

	if to_connect.size() + decor_connect.size() + tree_decor_connect.size() < min_land_tiles:
		try_again()
	else:
		set_cells_terrain_connect(1, to_connect, 0, 0, false)
		set_cells_terrain_connect(2, decor_connect, 0, 3, false)
		set_cells_terrain_connect(2, tree_decor_connect, 0, 4, false)
		set_cells_terrain_connect(0, water_connect, 0, 2, false)
	
		Global.overlay.loading_screen.visible = false


func try_again():
	await get_tree().create_timer(.1).timeout
	generate.call()
