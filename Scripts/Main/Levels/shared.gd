extends Node

enum parasite {
	blue, red, yellow
}

var cells = {
	parasite.blue: [Vector2(1,0), Vector2(2.2,0)],
	parasite.red: [Vector2(1,0), Vector2(2.2,0)],
	parasite.yellow: [Vector2(1,0), Vector2(2.2,0)]
}

var data = {
	parasite.blue: preload("res://Resources/blue_piece_data.tres"),
	parasite.red: preload("res://Resources/red_piece_data.tres"),
	parasite.yellow: preload("res://Resources/yellow_piece_data.tres")
}

var clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1,0)]
var counter_clockwise_rotation_matrix = [Vector2(0,1), Vector2(-1,0)]
