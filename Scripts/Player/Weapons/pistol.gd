class_name Gun extends Node3D

@export var anim_player: AnimationPlayer
@export var fire_power: float = 10
@onready var my_player: Player = get_tree().get_first_node_in_group("Player")
var firing: bool = false
@export var bullet_scene: PackedScene
@onready var fx_container: Node3D = get_tree().get_first_node_in_group("Containers").get_node("FX")

func fire():
	anim_player.play("Fire")
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.fx_container = fx_container
	bullet.global_position = my_player.muzzle_marker.global_position
	bullet.velocity = my_player.velocity
	bullet.velocity += -my_player.cam.global_transform.basis.z.normalized() * fire_power
	
