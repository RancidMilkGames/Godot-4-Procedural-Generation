extends Camera3D

@export var speed: float = 2.0
@export var lookaround_speed: float = .01

@onready var compass = $Compass

var rot_x = 0
var rot_y = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	process_mode = Node.PROCESS_MODE_ALWAYS



func _physics_process(_delta):
	
	compass.global_rotation = Vector3.ZERO

	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")

	if input_dir.y != 0:
		global_position += global_transform.basis.z * (speed * input_dir.y)
	if input_dir.x != 0:
		global_position += global_transform.basis.x * (speed * input_dir.x)


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rot_x += event.relative.x * lookaround_speed
		rot_y += event.relative.y * lookaround_speed
		if rot_y > 1.5:
			rot_y = 1.5
		if rot_y < -1.5:
			rot_y = -1.5
		
		transform.basis = Basis()
		rotate_object_local(Vector3(0, -1, 0), rot_x)
		rotate_object_local(Vector3(-1, 0, 0), rot_y)

	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
