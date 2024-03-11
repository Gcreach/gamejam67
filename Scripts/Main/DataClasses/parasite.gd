extends Node2D

class_name parasite

var parasite_data
var is_next_piece
var pieces = []
@onready var timer = $Timer
@onready var piece_scene = preload("res://Scenes/piece.tscn")


var parasite_cells
# Called when the node enters the scene tree for the first time.
func _ready():
	parasite_cells = Shared.cells[parasite_data.Parasite_type]
	
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
		pass
	elif Input.is_action_just_pressed("rotate_left"):
		pass
	elif  Input.is_action_just_pressed("rotate_right"):
		pass

func move(direction: Vector2) -> bool:
	var new_position = calculate_global_position(direction, global_position)
	if new_position:
		global_position = new_position
		return true
	return false
	
func calculate_global_position(direction: Vector2, starting_global_position: Vector2):
	#TODO: check for collision with other parasites
	pass
	#TODO: check for collision with game bounds
	return starting_global_position + direction * pieces[0].get_size().x
	
func is_within_game_bounds(direction: Vector2, starting_global_position: Vector2):
	if !is_within_game_bounds(direction, starting_global_position):
		return null


func _on_timer_timeout():
	move(Vector2.DOWN)
