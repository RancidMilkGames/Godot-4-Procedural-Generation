extends CanvasLayer

@export var controls: Control

func _ready():
	controls.visible = true
	Global.overlay.menu.visibility_changed.connect(func():
		controls.visible = Global.overlay.menu.visible
		)
	
	await get_tree().create_timer(3).timeout
	controls.visible = false
