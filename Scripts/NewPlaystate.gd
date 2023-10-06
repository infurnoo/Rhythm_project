extends Node2D



var CurrentSong : Song
@onready var Camera : Camera2D = $Camera
@onready var Playfield = $Playfield
@onready var NewConductor = Conductor.new()


const SpawnTime = 2000

var NoteObject = preload("res://NOTE.tscn")

var UnspawnedNotes = []
var SpawnedNotes = []

var IsSongStarted = false

var Combo := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize conductor
	add_child(NewConductor)
	NewConductor.INIT(GameHandler.SongToPlay)
	GameHandler.CurrentConductor = NewConductor
	GameHandler.LanePressed.connect(OnLanePress)
	# create notes
	for NoteInfo in GameHandler.SongToPlay.NOTES:
		var NEW_NOTE : Note = NoteObject.instantiate()
		NEW_NOTE.StrumTime = NoteInfo[0]
		
		NEW_NOTE.NoteData = NoteInfo[1]
		NEW_NOTE.play("%s_incoming" % NoteInfo[1])
		UnspawnedNotes.append(NEW_NOTE)
		
	print("%s notes created" % UnspawnedNotes.size())
	await $StartButton.pressed
	IsSongStarted = true
	NewConductor.StartSong()

func _process(delta):
	if IsSongStarted:
		# spawn note onto screen when it is time
		if UnspawnedNotes.size() > 0 and UnspawnedNotes[0].StrumTime < NewConductor.songPosition+SpawnTime:
			var NoteToSpawn : Note = UnspawnedNotes[0]
			SpawnedNotes.append(NoteToSpawn)
			UnspawnedNotes.remove_at(0)
			Playfield.add_child(NoteToSpawn)
		# do stuff to the notes on screen
		$NUMBERSPAWNED.text = str(Combo)
		for NOTE in SpawnedNotes:
			var Target = Playfield.Receptors[NOTE.NoteData]
			var NoteTime = NOTE.StrumTime
			if NewConductor.songPosition - 100 < NoteTime and NoteTime < NewConductor.songPosition + 100:
				NOTE.CanBeHit = true
				# basic note input system
			else:
				if NewConductor.songPosition > NoteTime + 150 and Combo != 0:
					NOTE.queue_free()
					SpawnedNotes.erase(NOTE)
					Combo = 0
				NOTE.CanBeHit = false
		#	NOTE.NoteSpeed = -(NewConductor.songPosition - NoteTime) * .001
			# move notes to strumline
			NOTE.position = Target.position + Vector2(0 ,(NewConductor.songPosition-NoteTime)*.25 * NOTE.NoteSpeed)
			
func OnLanePress(Lane_Data):
	for NOTE in SpawnedNotes:
		# basic input stuff 
		# TODO : Change later 
		if NOTE.NoteData == Lane_Data and NOTE.CanBeHit:
			NOTE.queue_free()
			SpawnedNotes.erase(NOTE)
			Combo += 1
