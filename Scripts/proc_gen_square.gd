## World chunk for procedural generation.
##
## The world is created out of several of these.
##

class_name ProcGenSquare extends StaticBody3D

## Our surface array level
var level: SurfaceArrayLevel
## The noise we base generation off of
var world_noise: Noise
@export var collision_shape: CollisionShape3D
@export var mesh_inst: MeshInstance3D
## The material to set the terrain to
@export var terrain_material: Material
var mesh_verts: Array[Vector3] = []
var smooth_index = 2 #-1
var smooth_per_index = true
@export var nav_mesh_region: NavigationRegion3D


func _ready():
	level = get_tree().get_first_node_in_group("SAL") as SurfaceArrayLevel


func generate(square_size: float, int_dis: float, max_height: float, noise_offset: Vector2, detail: float):
	world_noise = level.noise_text.noise
	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	mesh_inst.mesh = ArrayMesh.new()

	var this_row = 0
	var prev_row = 0
	var row = 0
	var column = 0
	var point = 0

	for i in square_size:
		var v = i / square_size
		for j in square_size:
			var u = j / square_size
			var x = column * int_dis
			column += 1
			var z = row * int_dis
			var y = world_noise.get_noise_2d((x + noise_offset.x) * detail, (z + noise_offset.y) * detail) * max_height
			
			var vert = Vector3(x, y, z)
			level.mesh_verts.append(vert + global_position)
			point += 1
#			//st.SetNormal(vert.Normalized())
			st.set_uv(Vector2(u, v))
			st.set_smooth_group(smooth_index)
			st.add_vertex(vert)

			if i > 0 and j > 0:
				if smooth_per_index: 
					st.set_smooth_group(smooth_index)
				st.add_index(prev_row + j - 1)
				if smooth_per_index: 
					st.set_smooth_group(smooth_index)
				st.add_index(prev_row + j)
				if smooth_per_index: 
					st.set_smooth_group(smooth_index)
				st.add_index(this_row + j - 1)
				if smooth_per_index: 
					st.set_smooth_group(smooth_index)
				st.add_index(prev_row + j)
				if smooth_per_index: 
					st.set_smooth_group(smooth_index)
				st.add_index(this_row + j)
				if smooth_per_index: 
					st.set_smooth_group(smooth_index)
				st.add_index(this_row + j - 1)
		prev_row = this_row
		this_row = point
		row += 1
		column = 0
		
	st.index()
	st.optimize_indices_for_cache()
	st.generate_normals()
	st.generate_tangents()
	mesh_inst.mesh = st.commit()

	collision_shape.shape = mesh_inst.mesh.create_trimesh_shape()
	mesh_inst.mesh.surface_set_material(0, terrain_material)


