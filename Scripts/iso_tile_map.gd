class_name ProcTile extends TileMap

var noise_text: NoiseTexture2D = NoiseTexture2D.new()
var water_noise_text: NoiseTexture2D = NoiseTexture2D.new()

var width = 40 #170.0 / 4
var height = 80 #170.0 / 2

var water_tiles = []
var offset = 0

var row
var column

var surround_maps_resource = SurroundingMaps.new()
var surrounding_maps: Array[ProcTile] = []

var enabled: bool = true:
	set(e):
		enabled = e
		enabled_set()
		

@onready var level: Level = get_tree().get_first_node_in_group("TiledISO")
@export var timer: Timer
var my_rect: Rect2 = Rect2()
var tiled_map_scene: PackedScene = preload("res://Scenes/tiled_tile_map.tscn")
var world_height = 320
var world_width = 640


func start():
	noise_text = level.noise_text
	my_rect.size = Vector2(world_width, world_height)
	my_rect.position = global_position
	
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

	water_noise_text = level.water_noise_text
	
	get_surrounding_tmaps()
	

func _on_timer_timeout():
	for wt in water_tiles:
		if water_noise_text.noise.get_noise_3d(wt.x + (position.x / 16), wt.y + (position.y / 4), offset) > .11:
			if wt.x == - 1 or wt.x == width:
				set_cell(0, wt, 1, Vector2i(0, 5))
			else:
				set_cell(0, wt, 0, Vector2i(0, 5))
		else:
			if wt.x == - 1 or wt.x == width:
				set_cell(0, wt, 1, Vector2i(3, 5))
			else:
				set_cell(0, wt, 0, Vector2i(3, 5))
			
	offset += 1


func enabled_set():
	visible = enabled
	if enabled:
		timer.start()
	else:
		timer.stop()
		
func get_surrounding_tmaps():
	for t_map in level.tilemaps:
		if t_map.global_position.x == global_position.x - world_width:
			if t_map.global_position.y == global_position.y - world_height:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.UL = t_map
			elif t_map.global_position.y == global_position.y:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.L = t_map
			elif t_map.global_position.y == global_position.y + world_height:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.DL = t_map
		elif t_map.global_position.x == global_position.x:
			if t_map.global_position.y == global_position.y - world_height:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.U = t_map
			elif t_map.global_position.y == global_position.y + world_height:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.D = t_map
		elif t_map.global_position.x == global_position.x + world_width:
			if t_map.global_position.y == global_position.y - world_height:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.UR = t_map
			elif t_map.global_position.y == global_position.y:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.R = t_map
			elif t_map.global_position.y == global_position.y + world_height:
				if not t_map in surrounding_maps:
					surrounding_maps.append(t_map)
				surround_maps_resource.DR = t_map
				
				
func cam_centered():
	if surrounding_maps.size() < 8:
		get_surrounding_tmaps()
		for i in surround_maps_resource.tmaps.size():
			if not surround_maps_resource.tmaps[i]:
				var new_tmap: ProcTile = tiled_map_scene.instantiate()
				get_parent().add_child(new_tmap)
				var vec: Vector2
				match i:
					0:
						vec = Vector2(0, -world_height)
					1:
						vec = Vector2(world_width, -world_height)
					2:
						vec = Vector2(world_width, 0)
					3:
						vec = Vector2(world_width, world_height)
					4:
						vec = Vector2(0, world_height)
					5:
						vec = Vector2(-world_width, world_height)
					6:
						vec = Vector2(-world_width, 0)
					7:
						vec = Vector2(-world_width, -world_height)
				
				new_tmap.global_position = global_position + vec
				surrounding_maps.append(new_tmap)
				level.tilemaps.append(new_tmap)
				new_tmap.start()
		get_surrounding_tmaps()
	for t_map in level.tilemaps:
		t_map.enabled = t_map in surrounding_maps or t_map == self

