extends Node2D

@onready var newConductor = Conductor.new()
@onready var NewSong = Song.new()


var SPRITE_DEFAULT = preload("res://Scripts/SPRITE.tscn")
var size = .5

@onready var Arrows : Array[Sprite2D] = [$left,$down,$up,$right]

var NoteObjects = []

func CreateNoteObject(noteTime,target):
	var Obj = {
		NoteTime = noteTime,
		Target = target,
		Sprite = SPRITE_DEFAULT.instantiate()
	}
	add_child(Obj["Sprite"])
	return Obj

func _ready():
	self.set_process(false)
	NewSong.bpm = 144
	add_child(newConductor)
	newConductor.INIT(NewSong)
	newConductor.StartSong()
	newConductor.step_hit.connect(StepHit)
	for Note in NewSong.NOTES:
		var OBJECT = CreateNoteObject(Note[0],Note[1])
		NoteObjects.append(OBJECT)
	self.set_process(true)

func StepHit(step):
	pass

func _process(delta):
	size = lerpf(.5,size,1 - delta * 3.125 * 4)
	
	for Arrow in Arrows:
		Arrow.scale = Arrow.scale.lerp(Vector2(0.5,0.5),delta*3.125)
	
	for Note in NoteObjects:
		var SpriteN : Sprite2D = Note["Sprite"]
		var NoteTime = Note["NoteTime"]
		var Tg :Sprite2D = Arrows[Note["Target"]]
		SpriteN.rotation = Tg.rotation
		SpriteN.position = Tg.position + Vector2(0,(newConductor.curDecStep-NoteTime)*100)
		if NoteTime < newConductor.curDecStep:
			size = .75
			Tg.scale += Vector2(0.25,0.25)
			SpriteN.queue_free()
			NoteObjects.erase(Note)
	#if NewSong.NOTES[0] >= newConductor.curDecStep:
	#	size = 250
	#	NewSong.NOTES.remove_at(0)
