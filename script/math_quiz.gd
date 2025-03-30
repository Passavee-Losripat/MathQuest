extends CanvasLayer
signal answered(correct: bool)

@onready var input = $CanvasModulate/LineEdit
@onready var question_label = $CanvasModulate/Label
@onready var countdown_label = $CanvasModulate/CountdownLabel
@onready var button = $CanvasModulate/Button

var correct_answer = ""
var answered_already = false

var questions = [
	{text = "What is the lowest root of x² - 5x + 6 = 0?", answer = "2"},
	{text = "What is the highest root of x² - 5x + 6 = 0?", answer = "3"},
	{text = "What is the lowest root of x² - 3x + 2 = 0?", answer = "1"},
	{text = "What is the highest root of x² - 3x + 2 = 0?", answer = "2"},
	{text = "What is the lowest root of x² + 4x + 3 = 0?", answer = "-3"},
	{text = "What is the highest root of x² + 4x + 3 = 0?", answer = "-1"},
	{text = "What is the lowest root of x² - 7x + 10 = 0?", answer = "2"},
	{text = "What is the highest root of x² - 7x + 10 = 0?", answer = "5"},
	{text = "What is the lowest root of x² - x - 6 = 0?", answer = "-2"},
	{text = "What is the highest root of x² - x - 6 = 0?", answer = "3"},
	{text = "What is the lowest root of x² + x - 6 = 0?", answer = "-3"},
	{text = "What is the highest root of x² + x - 6 = 0?", answer = "2"},
	{text = "What is the lowest root of x² + 2x - 8 = 0?", answer = "-4"},
	{text = "What is the highest root of x² + 2x - 8 = 0?", answer = "2"},
	{text = "What is the root of x² - 6x + 9 = 0?", answer = "3"},
	{text = "What is the root of x² + 6x + 9 = 0?", answer = "-3"},
	{text = "What is the root of x² - 10x + 25 = 0?", answer = "5"},
	{text = "What is the root of x² - 2x + 1 = 0?", answer = "1"},
	{text = "What is the root of x² + 8x + 16 = 0?", answer = "-4"},
	{text = "What is the root of x² - 4x + 4 = 0?", answer = "2"}
]


func start_quiz():
	randomize()
	var q = questions[randi() % questions.size()]
	correct_answer = str(q.answer).strip_edges()
	question_label.text = q.text
	input.text = ""
	input.grab_focus()
	countdown_label.text = "⏳ 25"
	answered_already = false
	show()
	await countdown(25)
	check_answer()

func _on_Button_pressed():
	check_answer()

func check_answer():
	if answered_already:
		return
	answered_already = true
	var user_input = input.text.strip_edges()
	var is_correct = user_input == correct_answer
	emit_signal("answered", is_correct)

func countdown(seconds):
	for i in range(seconds, 0, -1):
		countdown_label.text = "⏳ " + str(i)
		await get_tree().create_timer(1).timeout
