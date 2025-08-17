extends Node2D

var current_color : Color



func _on_royalblue_pressed() -> void:
	current_color = Color.ROYAL_BLUE
	$AudioStreamPlayer2D.play()


func _on_orangered_pressed() -> void:
	current_color = Color.ORANGE_RED
	$AudioStreamPlayer2D.play()


func _on_darkgreen_pressed() -> void:
	current_color = Color.DARK_GREEN
	$AudioStreamPlayer2D.play()


func _on_darkred_pressed() -> void:
	current_color = Color.DARK_RED
	$AudioStreamPlayer2D.play()


func _on_gold_pressed() -> void:
	current_color = Color.GOLD
	$AudioStreamPlayer2D.play()


func _on_hotpink_pressed() -> void:
	current_color = Color.HOT_PINK
	$AudioStreamPlayer2D.play()


func _on_indigo_pressed() -> void:
	current_color = Color.INDIGO
	$AudioStreamPlayer2D.play()


func _on_black_pressed() -> void:
	current_color = Color.BLACK
	$AudioStreamPlayer2D.play()
