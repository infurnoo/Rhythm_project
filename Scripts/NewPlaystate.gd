extends Node2D



var CurrentSong : Song
@onready var Camera : Camera2D = $Camera

var UnspawnedNotes = []
var SpawnedNotes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var time_passed = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Camera.zoom = Camera.zoom.lerp(Vector2(1,1),delta*3.125)
	time_passed += delta
	if time_passed >= 1:
		time_passed = 0
		Camera.zoom = Vector2(1.03,1.03)
