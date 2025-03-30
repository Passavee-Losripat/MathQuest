extends Node2D

@export var rock_scene: PackedScene = preload("res://scene/rock.tscn")
@export var drop_area_left := 0
@export var drop_area_right := 800

@export var drop_height: float = -50
@export var num_rocks_per_throw = 9
@export var turns_before_quiz = 2

var quiz_result: bool = false
var quiz_active: bool = false
var turn_count: int = 0
var hp = 7
@onready var anim = $AnimatedSprite2D

func _ready():
	$bomb.visible = false
	anim.play("default")
	# 🔁 Start the loop as a coroutine
	boss_loop()

func boss_loop() -> void:
	await get_tree().create_timer(2.0).timeout  # Initial delay if needed

	while true:
		# ⏸️ Pause logic during quiz
		while quiz_active:
			await get_tree().process_frame

		anim.play("default")
		$roar.play()

		for i in range(num_rocks_per_throw):
			_throw_random_rock()
			await wait(0.8)

		anim.play("default")
		await wait(2.0)

		# ⏱️ Track turns until quiz
		turn_count += 1
		if turn_count >= turns_before_quiz:
			await show_math_quiz()
			turn_count = 0

func _throw_random_rock():
	var rock = rock_scene.instantiate()
	get_tree().current_scene.add_child(rock)

	var drop_x = randf_range(drop_area_left, drop_area_right)
	rock.global_position = Vector2(drop_x, drop_height)

func wait(seconds: float) -> void:
	await Engine.get_main_loop().create_timer(seconds).timeout

func show_math_quiz() -> void:
	quiz_active = true

	var quiz = preload("res://scene/MathQuiz.tscn").instantiate()
	get_tree().current_scene.add_child(quiz)

	quiz.answered.connect(_on_quiz_answered)
	quiz.start_quiz()

	await quiz.answered
	quiz.queue_free()

	quiz_active = false

	var player = get_tree().get_first_node_in_group("player")
	if player:
		if quiz_result:
			player.gain_special_move()
		else:
			player.take_damage(1)

func _on_quiz_answered(correct: bool) -> void:
	quiz_result = correct
func flash_damage():
	var sprite = $AnimatedSprite2D  # 👈 Change to match your actual sprite node!
	for i in range(4):
		sprite.modulate.a = 0.2
		await get_tree().create_timer(0.1).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout

func take_damage(amount):
	hp -= amount
	$hit.play()
	await flash_damage()
	if hp <= 0:
		die()

func die():
	flash_damage()
	$bomb.visible = true
	$bomb.play("default")
	await wait(2)
	flash_damage()
	get_tree().change_scene_to_file("res://scene/transition.tscn")
