extends Node2D

@export var width : int
var paint_color = Color.ROYAL_BLUE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Color.NAVY_BLUE
	Color.ORANGE_RED
	Color.DARK_GREEN


func paint_clothes(brush_is_horizontal: bool) -> void:
	var image: Image = $ClothingBench.texture.get_image()
	#randi_range()
	var start_point = Vector2(10,75)
	var end_point = Vector2(120, 25)
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


func patch_clothes() -> void:
	pass
