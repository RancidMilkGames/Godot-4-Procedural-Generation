extends Control

@export var simple_iso_scene: PackedScene
@export var infinite_iso_scene: PackedScene
@export var square_tile_scene: PackedScene
@export var terrain_3d: PackedScene
@export var grid_3d_scene: PackedScene

@export var focus_button: Button
@export var quit_button: Button
@export var about: PopupPanel

func _ready():
	focus_button.grab_focus()
	about.visible = false
	if OS.get_name() == "Web":
		quit_button.visible = false

func _on_visibility_changed():
	if visible and focus_button.is_inside_tree():
		focus_button.grab_focus()


func _on_simple_iso_pressed():
	Global.change_scene(simple_iso_scene)


func _on_tiled_iso_pressed():
	Global.change_scene(infinite_iso_scene)


func _on_square_tiles_pressed():
	Global.change_scene(square_tile_scene)


func _on_quit_pressed():
	get_tree().quit()


func _on_about_pressed():
	about.popup_centered()


func _on_3d_terrain_pressed():
	Global.change_scene(terrain_3d)


func _on_3d_grid_pressed():
	Global.change_scene(grid_3d_scene)
