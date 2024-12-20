extends Sprite2D

func _ready():
	position = Vector2(576,537)


func processnumber(num: int):
	var tween = create_tween()
	if (num <= 14):
		tween.tween_property($".", "position", Vector2(689, 401),1)
	if (num >= 15 && num <17):
		tween.tween_property($".", "position", Vector2(689, 401),1)
		tween.tween_property($".", "position", Vector2(578, 297),1)
	if (num == 18):
		tween.tween_property($".", "position", Vector2(689, 401),1)
		tween.tween_property($".", "position", Vector2(578, 297),1)
		tween.tween_property($".", "position", Vector2(461, 401),1)
	if (num > 18):
		tween.tween_property($".", "position", Vector2(689, 401),1)
		tween.tween_property($".", "position", Vector2(578, 297),1)
		tween.tween_property($".", "position", Vector2(461, 401),1)
		tween.tween_property($".", "position", Vector2(567, 537),1)

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
