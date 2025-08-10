extends Node2D

@export var texture : Texture2D:
	set(value):
		texture = value
		queue_redraw()

func _draw():
	draw_texture(texture, Vector2())


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var image: Image = texture.get_image()
	var start_point = Vector2i(5,5)
	var end_point = Vector2i(10, 13)
	var m = (end_point.y - start_point.y) / (end_point.x - start_point.x)
	var b = start_point.y - m * start_point.x
	var range = end_point.x - start_point.x
	
	var array = PackedVector2Array([start_point])
	for i in range(start_point.x, range):
		array.append(Vector2i(i, m * i + b))
	
	for vector in array:
		#var ivector = Vector2i(vector)
		image.set_pixel(vector.x, vector.y, Color.ORANGE)
	
	#image.flip_y()
	var new_texture = ImageTexture.create_from_image(image)
	$Sprite2D.texture = new_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
