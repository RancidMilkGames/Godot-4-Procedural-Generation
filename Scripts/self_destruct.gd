extends Timer


func _on_timeout():
	get_parent().queue_free()
