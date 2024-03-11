extends Node

class_name Board

@export var parasite_scene: PackedScene

func spawn_parasite(type: Shared.parasite, is_next_piece, spawn_position):
	var parasite_data = Shared.data[type]
	var Parasite = parasite_scene.instantiate() as parasite
	
	Parasite.parasite_data = parasite_data
	Parasite.is_next_piece = is_next_piece
	
	if is_next_piece == false:
		Parasite.position = parasite_data.spawn_position
		add_child(Parasite)
