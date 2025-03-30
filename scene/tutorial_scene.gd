extends Node2D

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	anim_player.play("Intro")
	anim_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished(anim_name: String) -> void:
	print(anim_name + " finished!")
	get_tree().change_scene_to_file("res://scene/world_map.tscn")
