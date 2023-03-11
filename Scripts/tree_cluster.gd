extends Node3D

@export var tree_scenes: Array[PackedScene]
var trees = []


func spawn_trees():
	for c in get_children():
		if randi_range(0, 1) == 1:
			var t = tree_scenes.pick_random().instantiate()
			c.add_child(t) #get_parent().
			t.global_position = c.global_position
			t.rotate_object_local(Vector3(0, -1, 0), randf_range(0, 3))
			var r = randf_range(5, 10)
			t.scale = (Vector3(r, r, r))
