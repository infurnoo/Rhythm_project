extends JSON
class_name Song

class Section:
	var Notes := {}
	var sectionBeats := 4


var SongName = "SONG"
	

var bpm := 144.0
var SongData := []

# chart
var NOTES = [[0, 0], [416.66666666, 3], [624.99999999, 2], [1041.66666665, 1], [1458.33333331, 2], [1666.66666664, 3], [2083.3333333, 0], [2083.3333333, 2], [2291.66666663, 3], [3333.33333328, 1], [3749.99999994, 0], [3958.33333327, 3], [4374.99999993, 2], [4791.66666659, 3], [4999.99999992, 0], [5416.66666658, 1], [5624.99999991, 3]]


var SongFile := preload("res://Music/cool_rhythm_song.mp3")

