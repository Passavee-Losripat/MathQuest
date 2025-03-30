extends CharacterBody2D
@onready var animation_player = $Sprite2D
var speed: float = 100

signal next_round



func _ready():
	input_pickable = true
	velocity = _random_up_direction() * speed
	
func _random_up_direction():
	var x = deg_to_rad(randf_range(0, 180))
	return Vector2(cos(x), sin(x)).normalized()
	
func _physics_process(delta):
	var col = move_and_collide(velocity * delta)
	
	if col:
		velocity = velocity.bounce(col.get_normal())
		
	#_check_direction()
	#
#func _check_direction():
	#if velocity.x < 0:
		#sprite.flip_h = true
	#else:
		#sprite.flip_h = false
		
func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("shoot"):
		var field = get_tree().current_scene  # Ensure correct reference
		if field.has_method("_default_display") and field.bullet_count >= 0:
			_death()
		else:
			print("No bullets left!")  # Debug message
		
func _death():
	velocity = Vector2.ZERO
	$die.play()
	animation_player.play("death")
	await wait(0.7)
	next_round.emit()


	queue_free()
func wait(seconds: float) -> void:
	await Engine.get_main_loop().create_timer(seconds).timeout

func _on_screen_exited() -> void:
	next_round.emit()
	queue_free()
	
	
	
	
