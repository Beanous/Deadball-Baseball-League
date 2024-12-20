extends Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Button.pressed.connect(DeclaredHit())

func DeclaredHit():
	var num =  randi_range(1,20)
	$Label.text = str(num)
	emit_signal("_on_button_pressed", DeclaredHit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
