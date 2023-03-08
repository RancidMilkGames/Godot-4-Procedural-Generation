class_name Player extends Camera2D

var current_level: Level
var holding = false
var cam_pos
var zoom_bounds: Vector2 = Vector2(1, 4)
var current_zoom: Vector2 = Vector2(1, 1)
var use_input = true
@export var zoom_speed: float = 7.5

var zooming = 0
var zoom_count_running = false

func _ready():
	pass
	#set_process(false)
#	Global.scene_loader.scene_change_start.connect(on_scene_change_request)
#	Global.scene_loader.scene_change_end.connect(on_new_scene_connected)


func on_scene_change_request():
	set_process(false)
	use_input = false
	current_zoom = Vector2(1, 1)
	
func on_new_scene_connected(scene: String):
	if not scene.to_lower().contains("main") and not scene.to_lower().contains("empty"):
		set_process(true)
		use_input = true


func _process(delta):
	zoom = lerp(zoom, current_zoom, (delta * zoom_speed) / Engine.time_scale)


func _input(event):
	if not use_input:
		return
	
	
	if event.is_action_pressed("ZoomIn"):
		if current_zoom.x < zoom_bounds.y:
			
			if zooming <= 0:
				global_position = get_global_mouse_position()
				
			zooming += 1
			current_zoom += Vector2(.1, .1)
			zoom_count()
			
			

	elif event.is_action_pressed("ZoomOut"):
		if current_zoom.x > zoom_bounds.x:
			
			if zooming <= 0:
				global_position = get_global_mouse_position()
			zooming += 1
			#zoom -= Vector2(.1, .1)
			current_zoom -= Vector2(.1, .1)
			zoom_count()
			
	if holding and event is InputEventMouseMotion:
		global_position = cam_pos - (Vector2(DisplayServer.mouse_get_position()) - holding)

	if event.is_action_pressed("Click"):
		holding = Vector2(DisplayServer.mouse_get_position())
		cam_pos = position
	elif event.is_action_released("Click"):
		holding = false


func zoom_count(from_self: bool = false):
	if zoom_count_running and not from_self:
		return
	zoom_count_running = true
	await get_tree().create_timer(.1).timeout
	zooming -= 1
	if zooming > 0:
		zoom_count(true)
	else:
		zoom_count_running = false

	
