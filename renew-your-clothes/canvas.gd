extends Node2D

@export var width : int
@export var x_shift : int
@export var y_shift : int
@export var stroke_length : int
@export var rand_x_shift : int
@export var rand_y_shift : int

@onready var brush = $paintbrush
@onready var patch_tool = $ClothingPatch
var paint_color : Color = Color.ROYAL_BLUE
var current_tool = "paint"
var brush_position
var canvas_position
var in_range_x
var in_range_y

var updated_shirt_texture : Texture2D
var updated_pants_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brush.position = Vector2i.ZERO
	patch_tool.position = Vector2i.ZERO
	current_tool = "patch"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_tool == "paint":
		brush.visible = true
		patch_tool.visible = false
		
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
			#print(canvas_position)
	elif current_tool == "patch":
		brush.visible = false
		patch_tool.visible = true
		
		var new_x
		var new_y
		if (patch_tool.position.x > -50 and patch_tool.position.x < 50):
			in_range_x = true
		else:
			in_range_x = false
	
		if (patch_tool.position.y > -50 and patch_tool.position.y < 50):
			in_range_y = true
		else:
			in_range_y = false
	
		if in_range_x and in_range_y:
			new_x = ((patch_tool.position.x + 50)/ 32) * 10
			new_y = ((patch_tool.position.y + 50)/ 32) * 10
			canvas_position = Vector2i(new_x, new_y)
			#print(canvas_position)
	


func paint_clothes(brush_is_horizontal: bool) -> void:
	var image: Image = $ClothingBench.texture.get_image()
	if !(in_range_x and in_range_y):
		return
	
	var rand_x
	var rand_y
	var start_point
	if brush_is_horizontal:
		rand_y = randi_range(-rand_y_shift, rand_y_shift)
		start_point = canvas_position + Vector2i(0, y_shift)
	else:
		rand_x = randi_range(-rand_x_shift, rand_x_shift)
		start_point = canvas_position + Vector2i(x_shift, 0)
	
	var end_shift_vector
	if brush_is_horizontal:
		end_shift_vector = Vector2i(stroke_length, rand_y)
	else:
		end_shift_vector = Vector2i(rand_x, stroke_length)
	
	var end_point = canvas_position + end_shift_vector
	end_point.x = clampi(end_point.x, 0, 32)
	end_point.y = clampi(end_point.y, 0, 32)
	
	#print("start: " + str(start_point))
	#print("end: " + str(end_point))
	if end_point.x == start_point.x:
		end_point.x = end_point.x + 1
	elif end_point.x < start_point.x:
		end_point.x = start_point.x + 1
	var m = (end_point.y - start_point.y) / (end_point.x - start_point.x)
	var b = start_point.y - m * start_point.x
	
	var array_main = PackedVector2Array([])
	for i in range(start_point.x, end_point.x):
		array_main.append(Vector2i(i, m * i + b))
	
	for vector in array_main:
		#var randnum = 0.0
		var mpa = image.get_pixelv(Vector2i(vector.x, vector.y)).a
		if mpa == 1:
			image.set_pixel(vector.x, vector.y, paint_color)
		for i in range(1, width):
			#randnum = 1.0 / i if i > 3 else 1.0
			#if randf() < randnum:
			var rpa = image.get_pixelv(Vector2i(vector.x + i, vector.y)).a
			var lpa = image.get_pixelv(Vector2i(vector.x - i, vector.y)).a
			
			if rpa == 1:
				image.set_pixel(vector.x + i, vector.y, paint_color)
			if lpa == 1:
				image.set_pixel(vector.x - i, vector.y, paint_color)
	
	$ClothingBench.texture = ImageTexture.create_from_image(image)


func patch_clothes() -> void:
	
	var c_pos = Vector2i(canvas_position.x - 2.5, canvas_position.y - 2.5)
	# Get image from texture on sprite
	var clothes : Image = $ClothingBench.texture.get_image()
	
	# Get image from patch texture on sprite
	var patch_image : Image = patch_tool.texture.get_image()
	#var patch : Image = $ClothingPatch.texture.get_image()
	patch_image.fill(paint_color)
	patch_image.convert(Image.FORMAT_RGBA8)
	
	# Get temp image for patch image mask
	var temp_img : Image = Image.create_empty(5, 5, false, Image.FORMAT_RGBA8)
	var patch_rect = patch_image.get_used_rect()
	
	temp_img.blit_rect(clothes, Rect2i(c_pos.x, c_pos.y, 5, 5), Vector2i(0, 0))
	clothes.blit_rect_mask(patch_image, temp_img, patch_rect, Vector2i(c_pos.x, c_pos.y))
	var new_clothes = ImageTexture.create_from_image(clothes)
	$ClothingBench.texture = new_clothes
