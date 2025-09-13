extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter"):
		get_tree().change_scene_to_file("res://Scenes/first_level.tscn")
		
