extends Node2D

@export var width : int

@export var texture : Texture2D:
	set(value):
		texture = value
		queue_redraw()

func _draw():
	draw_texture(texture, Vector2())


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var image: Image = texture.get_image()
	print(image.get_pixelv(Vector2i(0, 0)).a)
	print(image.get_pixelv(Vector2i(5, 5)).a)
	var start_point = Vector2(10,75)
	var end_point = Vector2(120, 25)
	var m = (end_point.y - start_point.y) / (end_point.x - start_point.x)
	var b = start_point.y - m * start_point.x
	var range = end_point.x - start_point.x
	
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
	
	#image.flip_y()
	var new_texture = ImageTexture.create_from_image(image)
	$Sprite2D.texture = new_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
