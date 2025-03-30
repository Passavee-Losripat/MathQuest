extends CharacterBody2D
class_name Slime  # <-- inside slime.gd
const SPEED = 650
const JUMP_VELOCITY = -700
const GRAVITY = 900
var current_dir
var hp = 3
@onready var normal_sprite = $Normal
@onready var special_sprite = $Special

var special_move_count = 0
var can_use_special = false
var fireball_scene: PackedScene = preload("res://scene/fireball.tscn")



func reset_to_normal():
	can_use_special = false
	special_move_count = 0
	special_sprite.visible = false
	normal_sprite.visible = true

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	# Horizontal movement
	if Input.is_action_pressed("ui_right"):
		play_anim(1)
		current_dir = "right"
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		play_anim(1)
		current_dir = "left"
		input_vector.x -= 1

	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# Jump
		if Input.is_action_just_pressed("ui_accept"):
			$jump.play()  # default is spacebar or Z
			current_dir = "jump"
			velocity.y = JUMP_VELOCITY
	if can_use_special and special_move_count > 0 and Input.is_action_just_pressed("s"):
		shoot_fireball()
		$shoot.play()
		special_move_count -= 1
		if special_move_count <= 0:
			reset_to_normal()
	# Apply horizontal velocity
	velocity.x = input_vector.x * SPEED
	move_and_slide()
func play_anim(movement):
	var dir = current_dir
	var anim
	if can_use_special:
		anim = $Special
	else:
		anim = $Normal


	if dir == "right":
		anim.flip_h = false
		if movement == 1 and can_use_special:
			anim.play("special_side")
		elif movement == 1:
			anim.play("side")
		elif movement == 0 and can_use_special:
			anim.play("special_idle")
		else:
			anim.play("idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1 and can_use_special:
			anim.play("special_side")
		if movement == 1:
			anim.play("side")
		elif movement == 0 and can_use_special:
			anim.play("special_idle")
		else:
			anim.play("idle")
	if dir == "jump":
		anim.flip_h = false
		if movement == 1 and can_use_special:
			anim.play("special_jump")
		if movement == 1:
			anim.play("jump")
		elif movement == 0:
			anim.play("idle")
func take_damage(amount):
	hp -= amount
	$hit.play()
	update_hearts(hp)
	await flash_damage()
	#print("🔥 Player took damage! HP left:", hp)
	if hp <= 0:
		game_over()# or trigger a game over scene
func gain_special_move():
	$upgrade.play()
	normal_sprite.visible = false
	special_sprite.visible = true
	special_move_count = 2
	can_use_special = true
func shoot_fireball():
	var fireball = fireball_scene.instantiate()
	get_tree().current_scene.add_child(fireball)

	var fire_point = get_node("FirePoint")  # 👈 adjust if nested deeper
	fireball.global_position = fire_point.global_position

	if current_dir == "left":
		fireball.direction = -1
	else:
		fireball.direction = 1
func flash_damage():
	var sprite
	if can_use_special:
		sprite = special_sprite
	else:
		sprite = normal_sprite
	for i in range(4):  # flash 4 times
		sprite.modulate.a = 0.2  # make mostly transparent
		await get_tree().create_timer(0.1).timeout
		sprite.modulate.a = 1.0  # back to visible
		await get_tree().create_timer(0.1).timeout


func update_hearts(hp):
	var heart1 = get_node_or_null("../heart1")
	var heart2 = get_node_or_null("../heart2")
	var heart3 = get_node_or_null("../heart3")

	if heart1: heart1.visible = hp >= 1
	if heart2: heart2.visible = hp >= 2
	if heart3: heart3.visible = hp >= 3
func game_over():
	await get_tree().create_timer(0.1).timeout  # optional delay
	get_tree().change_scene_to_file("res://scene/game_over.tscn") 
