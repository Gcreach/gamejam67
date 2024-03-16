extends Node2D

class_name parasite

signal lock_parasite(Parasite: parasite)

var bounds = {
	"min_x": 305,
	"max_x": 780,
	"max_y": 620
}

var rotation_index = 0 
var parasite_data
var is_next_piece
var pieces = []
var other_parasites: Array[parasite] = []

@onready var timer = $Timer
@onready var piece_scene = preload("res://Scenes/piece.tscn")


var parasite_cells
# Called when the node enters the scene tree for the first time.
func _ready():
	parasite_cells = Shared.cells[parasite_data.Parasite_type].duplicate()
	
	for cell in parasite_cells:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(parasite_data.piece_texture)
		piece.position = cell * piece.get_size()
		
		if is_next_piece == false:
			position = parasite_data.spawn_position

func _input(event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("hard_drop"):
		hard_drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_parasite(-1)
	elif  Input.is_action_just_pressed("rotate_right"):
		rotate_parasite(1)

func move(direction: Vector2) -> bool:
	var new_position = calculate_global_position(direction, global_position)
	if new_position:
		global_position = new_position
		return true
	return false
	
func calculate_global_position(direction: Vector2, starting_global_position: Vector2):
	if is_colliding_with_other_parasites(direction, starting_global_position):
		return null
	
	if !is_within_game_bounds(direction, starting_global_position):
		return null
	return starting_global_position + direction * pieces[0].get_size().x
	
func is_within_game_bounds(direction: Vector2, starting_global_position: Vector2):
	for piece in pieces:
		var new_position = piece.position + starting_global_position + direction * piece.get_size()
		if new_position.x < bounds.get("min_x") || new_position.x > bounds.get("max_x") || new_position.y >= bounds.get("max_y"):
			return false
		return true
		
func is_colliding_with_other_parasites(direction: Vector2, starting_global_position: Vector2):
	for Parasite in other_parasites:
		var parasite_pieces = Parasite.get_children().filter(func (c): return c is Piece)
		for parasite_piece in parasite_pieces:
			for piece in pieces:
				if starting_global_position + piece.position + direction * piece.get_size().x == Parasite.global_position + parasite_piece.position:
					return true
	return false 
	
func rotate_parasite(direction: int):
	var original_rotation_index = rotation_index
		
	apply_rotation(direction)
	
	rotation_index = wrap(rotation_index + direction, 0, 4)
	
func apply_rotation(direction: int):
	var rotation_matrix = Shared.clockwise_rotation_matrix if direction == 1 else Shared.counter_clockwise_rotation_matrix
	
	
	for i in parasite_cells.size():
		var cell = parasite_cells[i]
		var coordinates = rotation_matrix[0] * cell.x + rotation_matrix[1] * cell.y
		parasite_cells[i] = coordinates
		
	for i in pieces.size():
		var piece = pieces[i]
		piece.position = parasite_cells[i] * piece.get_size()
		
		
func hard_drop():
	while(move(Vector2.DOWN)):
		continue
	lock()

func lock():
	timer.stop()
	lock_parasite.emit(self)
	set_process_input(false)

func _on_timer_timeout():
	var should_lock = !move(Vector2.DOWN)
	if should_lock:
		lock()
