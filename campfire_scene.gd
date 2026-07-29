extends Node2D
@onready var dialogue_box=$Dialogueboxnight
@onready var dialogue_text=$Dialogueboxnight/DialogueText
@onready var continue_sprite = $"Continue(dark)"
@onready var choice_box = $ChoiceBox
@onready var choice_1 = $ChoiceBox/Choice1
@onready var choice_2= $ChoiceBox/Choice2
@onready var journal = $Journal
@onready var flower_1= $Journal/Flower1
@onready var flower_2=$Journal/Flower2
@onready var back_button=$BackButton
@onready var label_1=$Journal/Label1
@onready var label_2=$Journal/Label2
var leaving_scene:=false
var campfire_stage=0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	campfire_stage = 1
	dialogue_box.visible = true
	choice_box.visible = true
	choice_1.visible = true
	choice_2.visible = true
	back_button.visible=false
	journal.visible = false
	flower_1.visible = false
	flower_2.visible = false
	choice_1.text = "View Flowers"
	choice_2.text = "Go to Bed"
	await GameData.show_slow_text(
		 dialogue_text,
		 "Its pretty late Flower Keeper "
		 + GameData.player_name + ". 
		What would you like to do before bed?")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_choice_1_pressed() -> void:
	if campfire_stage ==1:
		dialogue_box.visible = false
		choice_box.visible=false
		choice_1.visible=false
		choice_2.visible =false
		journal.visible=true
		flower_1.visible=true
		flower_1.text = GameData.chosen_seed
		flower_2.visible=true
		flower_2.text = "wait"
		back_button.visible = true
		pass
func _on_choice_2_pressed() -> void:
	if leaving_scene:
		return
	leaving_scene=true
	dialogue_box.visible=false
	choice_box.visible=false
	choice_1.visible=false
	choice_2.visible=false
	if campfire_stage==1 and GameData.first_sprout_dialogue_seen:
		GameData.current_day=3
		GameData.save_game()
		get_tree().change_scene_to_file("res://Interior.tscn")
	
	elif campfire_stage ==1:
		GameData.current_day=2
		GameData.exterior_stage =5
		GameData.save_game()
		get_tree().change_scene_to_file("res://Interior.tscn")
		


func _on_back_button_pressed() -> void:
	if journal.visible:
		journal.visible=false
		flower_1.visible=false
		flower_2.visible=false
		dialogue_box.visible=true
		choice_box.visible=true
		choice_1.visible=true
		choice_2.visible=true
		back_button.visible= false


func _on_flower_1_pressed() -> void:
	if campfire_stage==1:
		GameData.show_slow_text(
			label_1,
			"This is your first ever seed.
			 Cherish it well."
		)


func _on_flower_2_pressed() -> void:
	if campfire_stage==1:
		GameData.show_slow_text(
			label_2,
			"wait"
		)
