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
