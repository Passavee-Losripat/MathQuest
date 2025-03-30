extends Control
func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/map_boss.tscn")
@onready var slime_sprite = $Slime  # Update this path if your slime node is deeper

func _ready():
	slime_sprite.play("default")  # or whatever your looping animation is
