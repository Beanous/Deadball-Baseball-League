extends Node2D

signal _on_button_pressed

func DeclaredHit():
	var num =  randi_range(1,20)
	$Label.text = str(num)
	emit_signal("_on_button_pressed", DeclaredHit)
