extends JSON
class_name Song

class Section:
	var Notes := {}
	var sectionBeats := 4


var SongName = "SONG"
	

var bpm := 144.0
var SongData := []

var NOTES = [[0,0],[4,3],[6,2],[10,1],[14,2],[16,3],[20,0],[20,2],[22,3],[32,1],[36,0],[38,3],[42,2],[46,3],[48,0],[52,1],[54,3]]
var SongFile := preload("res://Music/cool_rhythm_song.mp3")

