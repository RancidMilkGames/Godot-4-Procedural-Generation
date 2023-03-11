extends Node

@export var overlay: CanvasLayer
@onready var scene_root: Node = get_tree().root.get_child(-1)
@onready var current_scene = scene_root.get_child(0)

func change_scene(new_scene):
	overlay.loading_screen.visible = true
	await get_tree().process_frame
	current_scene.queue_free()
	await get_tree().process_frame
	var ns = new_scene.instantiate()
	scene_root.add_child(ns)
	current_scene = ns
	overlay.menu.visible = false

func _input(event):
	if event.is_action_pressed("Escape"):
		overlay.menu.visible = not overlay.menu.visible

