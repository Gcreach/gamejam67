extends Node

class_name Board

signal parasite_locked
signal game_over

var next_parasite
const ROW_COUNT = 15
const COLUMN_COUNT = 10

var parasites: Array[parasite] = []

@onready var line_scene = preload("res://Scenes/line.tscn")

@export var parasite_scene: PackedScene

func spawn_parasite(type: Shared.parasite, is_next_piece, spawn_position):
	var parasite_data = Shared.data[type]
	var Parasite = parasite_scene.instantiate() as parasite
	
	Parasite.parasite_data = parasite_data
	Parasite.is_next_piece = is_next_piece
	
	if is_next_piece == false:
		
		Parasite.position = parasite_data.spawn_position
		Parasite.other_parasites = parasites
		Parasite.lock_parasite.connect(on_parasite_locked)
		add_child(Parasite)		
		
func on_parasite_locked(Parasite: parasite):
	next_parasite.queue_free()
	parasites.append(Parasite)
	add_parasite_to_line(Parasite)
	remove_full_lines()
	parasite_locked.emit()
	check_game_over()
	
	
	
func check_game_over():
		for piece in get_all_pieces():
			var y_location = piece.global_position.y
			if y_location == -456:
				game_over.emit()

func add_parasite_to_line(Parasite: parasite):
	var parasite_pieces = Parasite.get_children().filter(func (c): return c is Piece)
	
	for piece in parasite_pieces:
		var y_position = piece.global_position.y
		var does_line_for_piece_exists = false
		
		for line in get_lines():
			
			if line.global_position.y == y_position:
				piece.reparent(line)
				does_line_for_piece_exists = true
		
		if !does_line_for_piece_exists:
			var piece_line = line_scene.instantiate() as Line
			piece_line.global_position = Vector2(0, y_position)
			add_child(piece_line)
			piece.reparent(piece_line)

func get_lines():
	return get_children().filter(func (c): return c is Line)

func remove_full_lines():
	for line in get_lines():
		if line.is_line_full(COLUMN_COUNT):
			move_lines_down(line.global_position.y)
			line.free()

func move_lines_down(y_position):
	for line in get_lines():
		if line.global_position.y < y_position:
			line.global_position.y += 48

func get_all_pieces():
	var pieces = []
	for line in get_lines():
		pieces.append_array(line.get_children())
	return pieces

