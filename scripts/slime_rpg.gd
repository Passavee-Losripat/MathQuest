extends CharacterBody2D

const speed = 100
var current_dir = "none"

func _ready():
	var anim = $AnimatedSprite2D
	anim.play("front")
	
func slimeRPG():
	pass

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		velocity.x = 0
		velocity.y = 0
		play_anim(0)
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			#$walk.play()
			anim.play("right")
		elif movement == 0:
			anim.play("front")
			
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			#$walk.play()
			anim.play("left")
		elif movement == 0:
			anim.play("front")
			
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			#$walk.play()
			anim.play("back")
		elif movement == 0:
			anim.play("front")
			
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			#$walk.play()
			anim.play("front")
		elif movement == 0:
			anim.play("front")
