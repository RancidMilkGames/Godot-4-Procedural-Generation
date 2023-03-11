extends RayCast3D

signal on_snap


func _ready():
	await get_tree().create_timer(.2).timeout
	check_if_snap()
	
	
func check_if_snap():
	enabled = true
	if is_colliding():
		get_parent().global_position.y = get_collision_point().y
		var temp_scale = get_parent().scale
		get_parent().transform = align_with_y(get_parent().transform, get_collision_normal())
		get_parent().scale = temp_scale
	enabled = false
	on_snap.emit()

# Code snippet from https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
