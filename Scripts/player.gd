class_name Player extends CharacterBody3D

signal on_health_changed(new_health)
signal on_stamina_changed

@export var gun: Gun
@export var cam: Camera3D
@export var max_health: float = 15.0
@export var health: float = 15.0:
	set(h):
		health = h
		on_health_changed.emit(health)
@export var max_stamina: float = 15.0
@export var stamina: float = 15.0:
	set(s):
		stamina = s
		on_stamina_changed.emit()
@export var UI: CanvasLayer
@export var dash_speed: float = 2
@export var muzzle_marker: Marker3D
var speed_mult = 1

const SPEED = 10.0
const JUMP_VELOCITY = 3

var can_use_boost = true
var in_boost = false
var launched = false
var can_dash = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rot_x = 0
var rot_y = 0
var LOOKAROUND_SPEED = .01


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if speed_mult > 1:
		stamina -= (speed_mult - 1.0) / 20.0
		if stamina <= 0:
			speed_mult = 1
	else:
		if stamina < max_stamina:
			stamina += 0.05
	var input_dir
	# *** Web has a bug where pressing shift will also trigger "S". 
	# *** This is a workaround
	if OS.get_name() == "Web":
		var down = 0
		if Input.is_key_pressed(83):
			down = 1
		input_dir = Vector2(Input.get_action_strength("MoveRight")\
		- Input.get_action_strength("MoveLeft"),\
		down - Input.get_action_strength("MoveForward"))
	else:
		input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not in_boost:
		if direction:
			velocity.x = direction.x * SPEED * speed_mult
			velocity.z = direction.z * SPEED * speed_mult

		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		if velocity.length() < 5 or (not launched and is_on_floor()):
			in_boost = false

	move_and_slide()




func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rot_x += event.relative.x * LOOKAROUND_SPEED
		rot_y += event.relative.y * LOOKAROUND_SPEED
		if rot_y > 1.5:
			rot_y = 1.5
		if rot_y < -1.5:
			rot_y = -1.5
		
		cam.transform.basis = Basis()
		transform.basis = Basis()
		rotate_object_local(Vector3(0, -1, 0), rot_x)
		cam.rotate_object_local(Vector3(-1, 0, 0), rot_y)
		
	if event.is_action_pressed("Fire"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		gun.firing = true
		gun.fire()
	elif event.is_action_released("Fire"):
		gun.firing = false
		
	if (event.is_action_pressed("Quick"))\
	or (can_dash and event.is_pressed() and event is InputEventKey and event.keycode == 4194325):
		speed_mult = dash_speed
		if can_use_boost:
			if Input.is_action_pressed("MoveForward"):
				velocity = -cam.global_transform.basis.z * 100
			elif Input.is_action_pressed("MoveBack"):
				velocity = cam.global_transform.basis.z * 100
			elif Input.is_action_pressed("MoveRight"):
				velocity = cam.global_transform.basis.x * 100
			elif Input.is_action_pressed("MoveLeft"):
				velocity = -cam.global_transform.basis.x * 100
			else:
				velocity = transform.basis.y * 100

			in_boost = true
			can_use_boost = false
			launched = true
			await get_tree().create_timer(.2).timeout
			launched = false
		can_dash = false
		can_use_boost = true
		await get_tree().create_timer(.5).timeout
		can_use_boost = false
	elif event.is_action_released("Quick")\
	or (not event.is_pressed() and event is InputEventKey and event.keycode == 4194325):
		speed_mult = 1
		can_dash = true
		
	if event.is_action_pressed("Help"):
		UI.controls.visible = not UI.controls.visible
		
		
func Damage(amount):
	health -= amount
	if health <= 0:
		Death()

func Death():
	queue_free()
	
func pickup(item):
	pass


func _notification(what):
	if what == 16 or what == 2000:
		return

	if what == 1003:
		Global.overlay.menu.visible = true
