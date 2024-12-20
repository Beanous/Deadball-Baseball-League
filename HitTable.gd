extends Node2D

func _on_button_pressed_():
	var num =  randi_range(1,20)
	$Label.text = str(num)
