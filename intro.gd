extends AnimationPlayer

@onready var anim_player = $AnimationPlayer
@onready var blackout = $ColorRect


func _ready() -> void:
	blackout.modulate.a = 0  # Make sure the screen starts clear
	play("Intro")
	connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished(anim_name: String) -> void:
	print(anim_name + " finished!")
	anim_player.play("FadeOut")
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://scripts/tutorial.tscn")
