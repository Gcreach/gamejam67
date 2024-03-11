extends Node2D

var blue = preload("res://Prefabs/Characters/Parasites/BlueParasite_PFB.tscn")
var red = preload("res://Prefabs/Characters/Parasites/RedParasite_PFB.tscn")
var yellow = preload("res://Prefabs/Characters/Parasites/YellowParasite_PFB.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var parasites = [blue, red, yellow]
	var types = parasites[randi()% parasites.size()]
	var parasite = types.instance()
	parasite.position = Vector2(randf_range(0,500), randf_range(500,0))
	add_child(parasite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
