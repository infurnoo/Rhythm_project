class_name Conductor
extends AudioStreamPlayer

var song = null

signal step_hit(step : int)
signal beat_hit(beat : int)
signal section_hit(section : int)

var bpm := 100.0
var crochet := (60/bpm) * 1000
var stepCrochet := crochet/4
var songPosition := 0.0
var Offset := 0.0

var inCountdown := false

class BPMChangeEvent:
	var songTime : float
	var eventBpm : float
	var stepTime : int
	var stepCrochet : float

var bpmChangeMap : Array[BPMChangeEvent] 

var curSection := 0
var stepsToDo := 0

var curStep := -1
var curDecStep := -1.0
var curBeat := -1
var curDecBeat := -1.0

func _init():
	self.set_process(false)
	
func INIT(newSong : Song):
	self.song = newSong
	self.bpm = newSong.bpm
	self.bpmChangeMap.clear()
	
	self.stream = newSong.SongFile

	var curBPM = newSong.bpm
	var totalSteps:= 0
	var totalPos := 0

	for section in newSong.SongData:
		if section.changeBPM and section.bpm != curBPM:
			curBPM = section.bpm
			var newEvent = BPMChangeEvent.new()
			newEvent.songTime = totalPos
			newEvent.eventBpm = section.bpm
			newEvent.stepTime = totalSteps
			newEvent.stepCrochet = ((60/section.bpm) * 1000) / 4
			self.bpmChangeMap.append(newEvent)
		var deltaSteps = round(section.sectionBeats * 4 or 16)
		totalSteps += deltaSteps
		totalPos += ((60/curBPM) * 1000 / 4) * deltaSteps

func setBPM(newBPM):
	self.bpm = newBPM
	self.crochet = (60/newBPM) * 1000
	self.stepCrochet = self.crochet/4

func StartSong():
	self.songPosition = -self.crochet * 4
	self.inCountdown = true
	self.set_process(true)

func getLastBPMChange() -> BPMChangeEvent:
	var lastChange = BPMChangeEvent.new()
	lastChange.eventBpm = self.bpm
	lastChange.songTime = 0.0
	lastChange.stepTime = 0.0
	lastChange.stepCrochet = (60/self.bpm) * 1000 /4

	
	for event in self.bpmChangeMap:
		if self.songPosition >= event.songTime:
			lastChange = self.bpmChangeMap 
	return lastChange
	

func getBeatsOnSection()->int:
	var beats = 4
	return beats

func _process(elapsed):
	var oldStep := self.curStep
	
	if not self.inCountdown:
		self.songPosition = self.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		self.songPosition *= 1000
	else:
		self.songPosition += elapsed*1000
	
	if self.inCountdown and self.songPosition >= 0:
		self.inCountdown = false
		self.play(0)

	var lastChange = getLastBPMChange()
	var added = (self.songPosition - lastChange.songTime) / lastChange.stepCrochet
	
	if self.bpm != lastChange.eventBpm:
		self.setBPM(lastChange.eventBpm)
		print_rich("[color=green] new bpm change [/color]")
	
	self.curDecStep = lastChange.stepTime + added
	self.curStep = lastChange.stepTime + floorf(added)
	
	self.curDecBeat = self.curDecStep / 4
	self.curBeat = floor(self.curStep / 4)
	
	if oldStep != self.curStep:
		self.stepHit(self.curStep)
		if oldStep < self.curStep:
			if self.stepsToDo < 1:
				# // work on get beats on section after make song class
				self.stepsToDo = round(self.getBeatsOnSection() * 4)
			while self.curStep >= stepsToDo:
				curSection+=1
				var beats = self.getBeatsOnSection()
				self.stepsToDo += beats*4
				self.sectionHit(self.curSection)

func stepHit(step):
	step_hit.emit(step)
	if step % 4 == 0:
		beatHit(step/4)
func beatHit(beat):
	beat_hit.emit(beat)
func sectionHit(section):
	section_hit.emit(section)
