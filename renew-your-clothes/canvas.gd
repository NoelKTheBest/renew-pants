extends Node2D

@export var width : int
@export var x_shift : int
@export var y_shift : int
@export var stroke_length : int
@export var rand_x_shift : int
@export var rand_y_shift : int

@onready var brush = $paintbrush
var paint_color = Color.ROYAL_BLUE
var brush_position
var canvas_position
var in_range_x
var in_range_y
var x_pos : int = 0
var y_pos : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brush.position = Vector2i.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_x
	var new_y
	if (brush.position.x > -50 and brush.position.x < 50):
		in_range_x = true
	else:
		in_range_x = false
	
	if (brush.position.y > -50 and brush.position.y < 50):
		in_range_y = true
	else:
		in_range_y = false
	
	if in_range_x and in_range_y:
		new_x = ((brush.position.x + 50)/ 32) * 10
		new_y = ((brush.position.y + 50)/ 32) * 10
		canvas_position = Vector2i(new_x, new_y)
	
	# Get numbers from input
	# Define new axis using is_button_just_pressed()
	#	Add results from up and down buttons for a new x axis
	#	Add results from left and right buttons for a new y axis
	
	var x_axis = Input.get_axis("ui_up", "ui_down")
	var y_axis = Input.get_axis("ui_left", "ui_right")
	x_pos = x_pos + x_axis
	y_pos = y_pos + y_axis
	print(x_pos, y_pos)


func paint_clothes(brush_is_horizontal: bool) -> void:
	var image: Image = $ClothingBench.texture.get_image()
	if !(in_range_x and in_range_y):
		return
	
	var rand_x
	var rand_y
	if brush_is_horizontal:
		rand_y = randi_range(-rand_y_shift, rand_y_shift)
	else:
		rand_x = randi_range(-rand_x_shift, rand_x_shift)
	
	var start_point = canvas_position + Vector2i(x_shift, y_shift)
	var end_shift_vector
	if brush_is_horizontal:
		end_shift_vector = Vector2i(stroke_length, rand_y)
	else:
		end_shift_vector = Vector2i(rand_x, stroke_length)
	
	var end_point = canvas_position + end_shift_vector
	end_point.x = clampi(end_point.x, 0, 32)
	end_point.y = clampi(end_point.y, 0, 32)
	
	print("start: " + str(start_point))
	print("end: " + str(end_point))
	var m = (end_point.y - start_point.y) / (end_point.x - start_point.x)
	var b = start_point.y - m * start_point.x
	
	var array_main = PackedVector2Array([])
	for i in range(start_point.x, end_point.x):
		array_main.append(Vector2i(i, m * i + b))
	
	for vector in array_main:
		var randnum = 0.0
		image.set_pixel(vector.x, vector.y, Color.ORANGE)
		for i in range(1, width):
			randnum = 1.0 / i if i > 3 else 1.0
			if randf() < randnum:
				if image.get_pixelv(Vector2i(vector.x + i, vector.y)).a == 1:
					image.set_pixel(vector.x + i, vector.y, Color.ORANGE)
				if image.get_pixelv(Vector2i(vector.x - i, vector.y)).a == 1:
					image.set_pixel(vector.x - i, vector.y, Color.ORANGE)
	
	$ClothingBench.texture = ImageTexture.create_from_image(image)


func patch_clothes() -> void:
	
	# Get numbers from input
	var x_axis = Input.get_axis("ui_up", "ui_down")
	var y_axis = Input.get_axis("ui_left", "ui_right")
	x_pos = x_pos + x_axis
	y_pos = y_pos + y_axis
	print(x_pos, y_pos)
	
	# Get image from texture on sprite
	var clothes : Image = $ClothingBench.texture.get_image()
	
	# Get image from patch texture on sprite
	var patch : Image = $ClothingPatch.texture.get_image()
	patch.convert(Image.FORMAT_RGBA8)
	
	# Get temp image for patch image mask
	var temp_img : Image = Image.create_empty(5, 5, false, Image.FORMAT_RGBA8)
	var patch_rect = patch.get_used_rect()
	
	temp_img.blit_rect(clothes, Rect2i(5, 15, 5, 5), Vector2i(0, 0))
	clothes.blit_rect_mask(patch, temp_img, patch_rect, Vector2i(5, 15))
	var new_clothes = ImageTexture.create_from_image(clothes)
	$TatteredPants.texture = new_clothes
	$Sprite2D2.texture = ImageTexture.create_from_image(temp_img)
