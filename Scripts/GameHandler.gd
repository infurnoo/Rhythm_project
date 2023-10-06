extends Node

# used to manage between states and scenes of game 
# work on later

var CurrentConductor : Conductor
var CurrentState = "Intro"


var SongToPlay = Song.new()

signal LanePressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
