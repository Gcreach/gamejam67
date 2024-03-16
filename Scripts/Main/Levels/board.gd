extends Node

class_name Board

signal parasite_locked
@onready var panel_container = $"../PanelContainer"

var next_parasite
const ROW_COUNT = 15
const COLUMN_COUNT = 10

var parasites: Array[parasite] = []

@export var parasite_scene: PackedScene

func spawn_parasite(type: Shared.parasite, is_next_piece, spawn_position):
	var parasite_data = Shared.data[type]
	var Parasite = parasite_scene.instantiate() as parasite
	
	Parasite.parasite_data = parasite_data
	Parasite.is_next_piece = is_next_piece
	
	if is_next_piece == false:
		var other_pieces = get
		Parasite.position = parasite_data.spawn_position
		Parasite.other_parasites = parasites
		Parasite.lock_parasite.connect(on_parasite_locked)
		add_child(Parasite)
	else: 
		Parasite.scale = Vector2(0.5, 0.5)
		#TODO: Fix bug below
		panel_container.add_child(Parasite)
		Parasite.set_position(spawn_position)
		next_parasite = Parasite
		
		
func on_parasite_locked(Parasite: parasite):
	next_parasite.queue_free()
	parasites.append(Parasite)
	parasite_locked.emit()
	clear_lines()
	
func clear_lines():
	var board_pieces = fill_board_pieces()
	clear_board_pieces(board_pieces)
	
func fill_board_pieces():
	var board_pieces = []
	
	for i in ROW_COUNT:
		board_pieces.append([])
		
	for Parasite in parasites:
		var parasite_pieces = Parasite.get_children().filter(func (c): return c is Piece)
		for piece in parasite_pieces:
			
			var row = (piece.global_position.y + piece.get_size().y / 2) / piece.get_size().y + ROW_COUNT / 2
			#TODO: Fix bug below
			board_pieces[row - 1].append(piece)
	return board_pieces
	
func clear_board_pieces(board_pieces):
	var i = ROW_COUNT
		
	while i > 0:
		var row_to_anaylze = board_pieces[i - 1]
			
		if row_to_anaylze.size() == COLUMN_COUNT:
			clear_row(row_to_anaylze)
			board_pieces[i - 1].clear()
			move_all_row_pieces_down(board_pieces, i)
		i -= 1
			
func clear_row(row):
	for piece in row:
		piece.queue_free()
		
func move_all_row_pieces_down(board_pieces, cleared_row_number):
	for i in range(cleared_row_number -1, 1, -1):
		var row_to_move = board_pieces[i -1]
		if row_to_move.size() == 0:
			return false
			
		for piece in row_to_move:
			piece.position.y += piece.get_size().y
			board_pieces[cleared_row_number - 1].append(piece)
		board_pieces[i -1].clear()
				

