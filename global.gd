extends Node

var current_scene = "world" #world map
var transition_scene = false

var player_exit_mon_fight_posx = 0
var player_exit_mon_fight_posy = 0
var player_start_posx = 0
var player_start_posy = 0

var player_position = Vector2(0, 0)

var mon1_is_alive = true
var mon2_is_alive = true

var toField1 = false
var toField2 = false
var toMapBoss = false

func finish_changescenes():
	if transition_scene == true:
		transition_scene == false
		if current_scene == "world" && toField1:
			global.toField1 = false
			current_scene = "field1"
		elif current_scene == "world" && toField2:
			global.toField2 = false
			current_scene = "field2"
		elif current_scene =="field1":
			global.toMapBoss = false
			mon1_is_alive = false
			current_scene = "world"
