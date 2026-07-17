extends Node2D
@onready var fade_overlay = $UI/FadeOverlay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_new_game_button_pressed() -> void:
	print("The Ancient Tree is Awakening..")
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 2.0)
	await tween.finished
	get_tree().change_scene_to_file("res://ancient_tree.tscn")
