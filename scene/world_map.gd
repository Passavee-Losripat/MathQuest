extends Node2D


func _ready():
	reset_collisions()
	global.transition_scene = true
	global.current_scene = "world"
	if global.player_position:
		var player = get_node("slimeRPG")  # Adjust path if necessary
		if player:
			player.global_position = global.player_position + Vector2(0, 45)  # Offset Y to avoid instant collision

func reset_collisions():
	# Ensure all collision shapes or areas are enabled after scene change.
	var player = get_node("slimeRPG")  # Adjust the path to the player node
	if player:
		player.set_collision_mask(1)  # Ensure player's collision mask is active (if using collision masks)
		player.set_collision_layer(1) # Reset to an appropriate collision layer
	pass

func _process(delta):
	change_scene()

func _on_mon_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("slimeRPG"):
		global.transition_scene = true
		global.toField1 = true


func _on_mon_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("slimeRPG"):
		global.transition_scene = false
		
		
func change_scene():
	if global.transition_scene == true:
		var player = get_node("slimeRPG")  # Adjust this path if necessary
		if player:
			global.player_position = player.global_position  # Store position before transition
	if global.transition_scene == true:
		if global.current_scene == "world" && global.toField1 :
			get_tree().change_scene_to_file("res://field1.tscn")
			global.finish_changescenes()
		elif global.current_scene == "world" && global.toField2 :
			get_tree().change_scene_to_file("res://field2.tscn")
			global.finish_changescenes()
		elif global.current_scene == "world" && global.toMapBoss:
			get_tree().change_scene_to_file("res://scene/map_boss.tscn")
			global.finish_changescenes()


func _on_mon_2_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("slimeRPG"):
		global.transition_scene = true
		global.toField2 = true


func _on_mon_2_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("slimeRPG"):
		global.transition_scene = false
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("slimeRPG"):
		global.transition_scene = true
		global.toMapBoss = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("slimeRPG"):
		global.transition_scene = false
