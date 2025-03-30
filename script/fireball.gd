extends Area2D

@export var speed = 500
var direction = 1

func _physics_process(delta):
	position.x += speed * delta * direction

func _on_body_entered(body):
	if body.is_in_group("boss"):
		body.take_damage(1)
		queue_free()

# Optional: If you added a Timer to auto-destroy
func _on_Timer_timeout():
	queue_free()
