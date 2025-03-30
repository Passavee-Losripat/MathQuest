extends Area2D

@export var fall_speed = 400

func _physics_process(delta):
	position.y += fall_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
