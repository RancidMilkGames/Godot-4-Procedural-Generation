extends Node3D

enum MODES { NORMAL, TRANSPARENCY }

@export var noise: FastNoiseLite
@export var current_mode: MODES = MODES.NORMAL
@export var multi_mesh_inst: MultiMeshInstance3D
@onready var multi_mesh = multi_mesh_inst.multimesh
@export var mesh_size: float = 1
@export var rows: int = 75
@export var columns: int = 75
@export var height: int = 75
@export var separation: float = 3
@export var min_noise_value: float = .15

@export var cycle: bool = false


var seperated
var noise_offset: Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	Global.overlay.loading_screen.visible = false
	if cycle:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 5
		timer.start()
		timer.timeout.connect(setup)
		
func setup():
	
	multi_mesh.mesh.size = Vector3(mesh_size, mesh_size, mesh_size)
	seperated = mesh_size * separation
	if not noise:
		noise = FastNoiseLite.new()
	noise.seed = randi_range(0, 1000000)
	set_mode(current_mode)
	var dict_array = use_mode(current_mode)
	multi_mesh.instance_count = dict_array.size()
	for i in dict_array.size():
		multi_mesh.set_instance_color(i, dict_array[i].color)
		multi_mesh.set_instance_transform(i, dict_array[i].trans)
		



func set_mode(mode):
	match mode:
		MODES.NORMAL:
			pass
		MODES.TRANSPARENCY:
			multi_mesh.mesh.surface_get_material(0).transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			
func use_mode(mode):
	match mode:
		MODES.NORMAL:
			var dict_array = []
			var count = 0
			for i in height:
				for ii in rows:
					for iii in columns:
						var n = noise.get_noise_3d(ii + noise_offset.x, i + noise_offset.y, iii + noise_offset.z)
						if n > min_noise_value:
							var dict = Dictionary()
							dict["trans"] = Transform3D(Basis.IDENTITY, Vector3(ii * seperated, i * seperated, iii * seperated))
							if n > .5:
								dict["color"] = Color.DEEP_SKY_BLUE
							elif n > .4:
								dict["color"] = Color.ORANGE
							elif n > .3:
								dict["color"] = Color.HOT_PINK
							else:
								dict["color"] = Color.GREEN_YELLOW
							dict_array.append(dict)
			return dict_array
		MODES.TRANSPARENCY:
			var dict_array = []
			var count = 0
			for i in height:
				for ii in rows:
					for iii in columns:
						var dict = Dictionary()
						dict["trans"] = Transform3D(Basis.IDENTITY, Vector3(ii * seperated, i * seperated, iii * seperated))
						dict["color"] = Color(1, 1, 1, noise.get_noise_3d(ii, i, iii))
						dict_array.append(dict)
			return dict_array
			
			

