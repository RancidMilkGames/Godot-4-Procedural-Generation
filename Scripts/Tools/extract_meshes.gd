@tool
extends EditorScenePostImport

var output_path = "res://Assets/Meshes/"

func _post_import(scene: Node) -> Object:
	find_mesh(scene)
	return scene

func find_mesh(obj):
	if obj is MeshInstance3D:
		ResourceSaver.save(obj.mesh, output_path + obj.name + ".res")
	else:
		for child in obj.get_children():
			find_mesh(child)
