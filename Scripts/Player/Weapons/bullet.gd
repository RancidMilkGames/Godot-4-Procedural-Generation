extends CharacterBody3D

@export var hit_fx_scene: PackedScene
var fx_container: Node3D

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var col = collision.get_collider()
		var hit_fx: CPUParticles3D = hit_fx_scene.instantiate()
		fx_container.add_child(hit_fx)
		hit_fx.global_position = collision.get_position()
		hit_fx.global_rotation = collision.get_normal()
		hit_fx.emitting = true
		
		if col.has_method("hit"):
			col.hit(self)
			
		queue_free()
#		var motion = collision.get_remainder().bounce(collision.get_normal())
#		velocity = velocity.bounce(collision.get_normal())
#		move_and_collide(motion)
