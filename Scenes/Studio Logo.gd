extends Node2D


func _ready():
	
	await get_tree().create_timer(1) 
	$AnimationPlayer.play("Fade")
	await get_tree().create_timer(5) 
	$AnimationPlayer.play_backwards("fade")
	await get_tree().create_timer(3) 
	get_tree().change_scene_to_file("res://Scenes/Godot Intro.tscn")
	pass
 
