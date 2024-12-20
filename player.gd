extends Node2D

enum handTypes {left=-1,switch=0,right=1}

var playerName : String
var playerNumber : int
var batTarget : int 
var onBaseTarget : int
var playerPosition : String
var pitcher : bool
var handed : int

#rotation variables
var rotFrom := 0
var rotTo := 0
var rotWeight := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#position = Vector2(576,537)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func moveBases(start: int, end: int):
	var tween = create_tween()
	var firstBase = Vector2(689, 401)
	var secondBase = Vector2(578, 297)
	var thirdBase = Vector2(461, 401)
	var homeBase = Vector2(567, 537)
	
	for baseNum in range(start,end+1,1):
		var basePos : Vector2
		print(baseNum)
		match baseNum:
			0:
				basePos = homeBase
			1:
				basePos = firstBase
			2:
				basePos = secondBase
			3:
				basePos = thirdBase
			4:
				basePos = homeBase
			99: 
				basePos = Vector2(792,486)
			_:
				basePos = homeBase
		tween.tween_property($".", "position", basePos,1)
		
		#Rotate Sprite
		rotFrom = rotation
		rotTo = Vector2.UP.angle_to(basePos - position)
		rotWeight = min(rotWeight * 10,1)
		tween.tween_property($".","rotation",rotTo,0.4)
