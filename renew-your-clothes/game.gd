extends Node2D

@onready var canvas = $Canvas
@onready var paintbrush = $Canvas/paintbrush
@onready var patch_tool = $Canvas/ClothingPatch
@onready var palette = $palette
@onready var color_indicator = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	canvas.paint_color = palette.current_color
	color_indicator.color = palette.current_color
	
	if Input.is_action_just_pressed("change_tool"):
		if canvas.current_tool == "paint": canvas.current_tool = "patch"
		elif canvas.current_tool == "patch": canvas.current_tool = "paint"
		print(canvas.current_tool)
	
	if canvas.current_tool == "paint":
		if Input.is_action_just_pressed("switch"):
			paintbrush.is_horizontal = !paintbrush.is_horizontal
		
		if Input.is_action_just_pressed("tool_action"):
			paintbrush.swipe()
			canvas.paint_clothes(paintbrush.is_horizontal)
		
		var y_direction = Input.get_axis("ui_up", "ui_down")
		var x_direction = Input.get_axis("ui_left", "ui_right")
		paintbrush.move_local_y(y_direction * 1.75)
		paintbrush.move_local_x(x_direction * 1.75)
	elif canvas.current_tool == "patch":
		if Input.is_action_just_pressed("tool_action"):
			canvas.patch_clothes()
		
		var y_direction = Input.get_axis("ui_up", "ui_down")
		var x_direction = Input.get_axis("ui_left", "ui_right")
		patch_tool.move_local_y(y_direction * 1.75)
		patch_tool.move_local_x(x_direction * 1.75)
	
	#print("x: " + str(x_direction) + "; y: " + str(y_direction))
