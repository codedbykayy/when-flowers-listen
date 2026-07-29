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


func _on_load_game_button_pressed() -> void:
	if not FileAccess.file_exists(GameData.save_path):
		print("No Save File Found")
		return
	GameData.load_game()
	if GameData.current_day==1:
		get_tree().change_scene_to_file(
			"res://destroyed_greenhouse_extreior_intro.tscn"
		)
	if GameData.current_day==2:
		get_tree().change_scene_to_file(
			"res://Interior.tscn"
			
		)
