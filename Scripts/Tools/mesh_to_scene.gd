@tool
extends EditorScript

var source_path = "res://Assets/Meshes/"
var destination_path = "res://Scenes/Environment/Trees/"

var snap = preload("res://Scenes/snap_to_floor.tscn")

func _run():
	var files = DirAccess.get_files_at(source_path)
	for f in files:
		# Create the objects.
		var base = Node3D.new()
		base.name = f.replace(".res", "")

		var mesh_inst = MeshInstance3D.new()
		mesh_inst.name = "MeshInstance3D"
		base.add_child(mesh_inst)
		mesh_inst.owner = base
		mesh_inst.mesh = load(source_path + f)
#		var body = StaticBody3D.new()
#		var collision = CollisionShape3D.new()
		mesh_inst.create_convex_collision()
		var static_body = mesh_inst.get_child(0)
		static_body.name = "StaticBody3D"
		static_body.owner = base
		static_body.get_child(0).owner = base
		
		mesh_inst.scale = Vector3(100, 100, 100)
		mesh_inst.rotation.x = -90
		
		var snap_node = snap.instantiate()
		base.add_child(snap_node)
		snap_node.owner = base

		# Create the object hierarchy.
#		body.add_child(collision)
#		mesh_inst.add_child(body)

		# Change owner of `body`, but not of `collision`.
#		body.owner = mesh_inst
		var scene = PackedScene.new()

		# Only `mesh_inst` and `body` are now packed.
		var result = scene.pack(base)
		if result == OK:
			var error = ResourceSaver.save(scene, destination_path + f.replace(".res", "") + ".tscn")  # Or "user://..."
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")

