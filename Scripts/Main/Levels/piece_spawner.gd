extends Node

@onready var board = $"../Board" 

var current_parasite
# Called when the node enters the scene tree for the first time.
func _ready():
	current_parasite = Shared.parasite.values().pick_random()
	board.spawn_parasite(current_parasite, false, null)
	board.parasite_locked.connect(on_parasite_locked)
	
func on_parasite_locked():
	var new_parasite = Shared.parasite.values().pick_random()
	board.spawn_parasite(new_parasite, false, null)
