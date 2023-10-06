extends Node2D

@onready var Receptors : Array[AnimatedSprite2D] = [$left,$down,$up,$right]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(4):
		var Receptor = Receptors[i]
		Receptor.scale = Receptor.scale.lerp(Vector2(1,1),delta * 7)
		if Input.is_action_just_pressed("Lane_%s_Press" % i):
			GameHandler.LanePressed.emit(i)
			Receptor.scale = Vector2(1.25, 0.8)
	
