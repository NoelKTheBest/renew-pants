extends Node2D

@onready var canvas = $Canvas
@onready var paintbrush = $Canvas/paintbrush
@onready var patch_tool = $Canvas/ClothingPatch
@onready var palette = $palette
@onready var color_indicator = $ColorRect

var shirts = preload("res://dirty_white_shirt.png")
var pants = preload("res://tattered_pants.png")
var is_shirt = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	canvas.paint_color = palette.current_color
	color_indicator.color = palette.current_color
	
	if Input.is_action_just_pressed("change_clothes"):
		print("i was pressed :>")
		if !is_shirt:
			if canvas.updated_shirt_texture:
				$Canvas/ClothingBench.texture = canvas.updated_shirt_texture
			else:
				$Canvas/ClothingBench.texture = shirts
			is_shirt = !(is_shirt)
		elif is_shirt:
			if canvas.updated_pants_texture:
				$Canvas/ClothingBench.texture = canvas.updated_pants_texture
			else:
				$Canvas/ClothingBench.texture = pants
			is_shirt = !(is_shirt)
	
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
	
	if Input.is_action_just_pressed("save"):
		if is_shirt:
			canvas.updated_shirt_texture = $Canvas/ClothingBench.texture
		else:
			canvas.updated_pants_texture = $Canvas/ClothingBench.texture
		
		$RichTextLabel.text = "SAVE"
		$RichTextLabel.visible = true
		$Timer.start()
	
	if Input.is_action_just_pressed("reset_textures"):
		canvas.updated_shirt_texture = null
		canvas.updated_pants_texture = null
		$RichTextLabel.text = "RESET"
		$RichTextLabel.visible = true
		$Timer.start()
	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()


func _on_timer_timeout() -> void:
	$RichTextLabel.visible = false
