extends Sprite2D


const horizontal_sprites = preload("res://paintbrush-Sheet.png")
const vertical_sprites = preload("res://paintbrush-Sheet(Vertical).png")
@onready var animator = $AnimationPlayer

var is_horizontal = true
var frames = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_horizontal:
		texture = vertical_sprites
		hframes = 1
		vframes = frames
	else:
		texture = horizontal_sprites
		hframes = frames
		vframes = 1


func swipe() -> void:
	if !is_horizontal: 
		animator.play("swipe_v")
	else:
		animator.play("swipe_h")
