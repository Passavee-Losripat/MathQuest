extends Node2D
@onready var bullet_node = $CanvasLayer/bullet
@onready var round_node =$CanvasLayer/round

@onready var button = $Sign1/Button


var bullet_count = 0:
	set(value):
		if value>=0:
			bullet_count = value
			bullet_node.text = str(value)

var round_count = 1:
	set(value):
		round_count = value
		round_node.text = str(value)




@export var bird_node : PackedScene
var bird
#var bird

func _spawn():
	bird = bird_node.instantiate()
	bird.global_position = Vector2(randi()%1000 , randi()%600)
	bird.speed = round_count * 50
	bird.next_round.connect(_on_next_round)
	add_child(bird)

func _on_next_round():
	round_count += 1
	if round_count == 5 && global.transition_scene == true:
		get_tree().change_scene_to_file("res://scene/world_map.tscn")
		global.finish_changescenes()
	_spawn()

func _input(event):
	if event.is_action_pressed("shoot"):
		bullet_count -= 1

func _ready():
	global.transition_scene = true
	button.modulate.a = 0
	bullet_count = 0
	_spawn()
	start_quiz()
	_default_display()
	
func _default_display():
	bullet_node.text = str(bullet_count)
	round_node.text = str(round_count)




@onready var input = $Sign4/LineEdit
@onready var question_label = $Sign/Label
#@onready var countdown_label = $CanvasModulate/CountdownLabel



var correct_answer = ""
var answered_already = false


var questions = [
	{text = "2x + 1 = 3,\n then x = ?", answer = "1"},
	{text = "5x - 4 = 11,\n then x = ?", answer = "3"},
	{text = "3x + 2 = 14,\n then x = ?", answer = "4"},
	{text = "7x - 5 = 16,\n then x = ?", answer = "3"},
	{text = "4x + 6 = 18,\n then x = ?", answer = "3"},
	{text = "9x - 2 = 7,\n then x = ?", answer = "1"},
	{text = "6x + 3 = 15,\n then x = ?", answer = "2"},
	{text = "2x - 8 = 10,\n then x = ?", answer = "9"},
	{text = "x / 2 + 3 = 7,\n then x = ?", answer = "8"},
	{text = "5x / 2 = 10,\n then x = ?", answer = "4"},
	{text = "3(x - 2) = 9,\n then x = ?", answer = "5"},
	{text = "4(x + 1) = 16,\n then x = ?", answer = "3"},
	{text = "(x + 2) / 3 = 4,\n then x = ?", answer = "10"},
	{text = "2(x - 3) = 8,\n then x = ?", answer = "7"},
	{text = "10x - 5 = 25,\n then x = ?", answer = "3"},
	{text = "8x + 4 = 20,\n then x = ?", answer = "2"},
	{text = "7x - 2 = 26,\n then x = ?", answer = "4"},
	{text = "12x + 6 = 30,\n then x = ?", answer = "2"},
	{text = "3x - 5 = 7,\n then x = ?", answer = "4"},
	{text = "15x + 10 = 40,\n then x = ?", answer = "2"}
];


func start_quiz():
	randomize()
	var q = questions[randi() % questions.size()]
	correct_answer = str(q.answer).strip_edges()
	question_label.text = q.text
	input.text = ""
	input.grab_focus()
	#countdown_label.text = "⏳ 25"
	answered_already = false
	show()
	#await countdown(25)
	check_answer()

func check_answer():
	if answered_already:
		return
	answered_already = false
	var user_input = input.text.strip_edges()
	var is_correct = user_input == correct_answer
	if is_correct:
		$correct.play()
		start_quiz()
		bullet_count += 1

#func countdown(seconds):
	#for i in range(seconds, 0, -1):
		#countdown_label.text = "⏳ " + str(i)
		#await get_tree().create_timer(1).timeout


func _on_button_pressed() -> void:
	check_answer()


func _on_line_edit_text_submitted(new_text: String) -> void:
	_on_button_pressed()
