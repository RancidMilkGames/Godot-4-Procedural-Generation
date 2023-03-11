## Level for 3D Level procedural generation.
##
## TODO Fill in description.
##

class_name SurfaceArrayLevel extends Node3D

## Total meshes to make. Value should be row * column
var total_size: int = 64
## Rows to generate
@export var rows: int = 8:
	set(r):
		rows = r
		set_total_size()
## Columns to generate
@export var columns: int = 8:
	set(c):
		columns = c
		set_total_size()
## Distance between indices of the mesh
@export var indices_distance = 5
## Max height of the mesh
@export var max_height = 150
## Basically how the noise is scaled to the mesh. Lower number will stretch the noise values.
@export var detail = .2
## Scene containing components for a chunk of the world.
@export var proc_gen_sqr_scene: PackedScene
## Scene of the player
@export var player_scene: PackedScene
@export var tree_cluster_scene: PackedScene
@export var foliage_container: Node3D
@export var generate_trees: bool = false
var proc_gen_squares: Array[ProcGenSquare] = []
var current_square: ProcGenSquare
var player: Player
var square_size: Vector2
var noise_text: NoiseTexture2D = NoiseTexture2D.new()
var mesh_verts: Array[Vector3] = []

func _ready():
	noise_text.seamless = true
	noise_text.as_normal_map = true
	noise_text.normalize = false
	noise_text.noise = FastNoiseLite.new()
	noise_text.noise.noise_type = FastNoiseLite.TYPE_PERLIN
	await noise_text.changed
	Global.overlay.menu.visible = false
	Global.overlay.menu.visibility_changed.connect(menu_visiblity_changed)

	
	square_size = Vector2((total_size - 1) * indices_distance, (total_size - 1) * indices_distance)
	
	for i in rows:
		for j in columns:
			var sqr: ProcGenSquare = proc_gen_sqr_scene.instantiate()
			add_child(sqr)
			var offset = Vector2((total_size - 1) * indices_distance * i, (total_size - 1) * indices_distance * j)
			sqr.global_position += Vector3(offset.x, 0, offset.y)
			sqr.generate(total_size, indices_distance, max_height, offset, detail)
			#sqr.MeshInst.Mesh.SurfaceSetMaterial(0, terrain_material)
			proc_gen_squares.append(sqr)
			
	await get_tree().create_timer(.5).timeout
	post_gen()
	
	current_square = proc_gen_squares[0]
	
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = mesh_verts.pick_random() + Vector3(0, 50, 0)
	Global.overlay.loading_screen.visible = false


func menu_visiblity_changed():
	if Global.overlay.menu.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func set_total_size():
	total_size = rows * columns


func post_gen():
	if generate_trees:
		for v in mesh_verts:
			if randi_range(0, 500) == 0:
				var tree_cluster = tree_cluster_scene.instantiate()
				foliage_container.add_child(tree_cluster)
				tree_cluster.global_position = v
				tree_cluster.spawn_trees()
