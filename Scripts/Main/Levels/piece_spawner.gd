extends Node

@onready var board = $"../Board" 
var next_parasite

var current_parasite
# Called when the node enters the scene tree for the first time.
func _ready():
	current_parasite = Shared.parasite.values().pick_random()
	next_parasite = Shared.parasite.values().pick_random()
	board.spawn_parasite(current_parasite, false, null)
	board.spawn_parasite(next_parasite, true, Vector2(100,50))
	board.parasite_locked.connect(on_parasite_locked)
	
func on_parasite_locked():
	
	current_parasite = next_parasite
	next_parasite = Shared.parasite.values().pick_random()
	var new_parasite = Shared.parasite.values().pick_random()
	board.spawn_parasite(new_parasite, false, null)
	board.spawn_parasite(next_parasite, true, Vector2(100,50))
