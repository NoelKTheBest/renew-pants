extends Node2D


@onready var paintbrush = $paintbrush

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch"):
		paintbrush.is_horizontal = !paintbrush.is_horizontal
	
	if Input.is_action_just_pressed("swipe"):
		paintbrush.swipe()
	
	var y_direction = Input.get_axis("ui_up", "ui_down")
	var x_direction = Input.get_axis("ui_left", "ui_right")
	paintbrush.move_local_y(y_direction * 1.75)
	paintbrush.move_local_x(x_direction * 1.75)
	#print("x: " + str(x_direction) + "; y: " + str(y_direction))
