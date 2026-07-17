extends Node2D
@onready var dry_pond_scene = $DryPondScene
@onready var gone_pond_scene = $GonePondScene
@onready var home_button = $HomeButton
@onready var pond_area= $pondarea
@onready var pond_hover = $pondarea/PondHover
@onready var dialogue_box = $DialogueBox
@onready var dialogue_text = $DialogueBox/DialogueLabel
@onready var continue_sprite = $ContinueSprite
@onready var continue_button = $ContinueSprite/ContinueButton
@onready var choice_box = $ChoiceBox
@onready var choice_1 = $ChoiceBox/Choice1
@onready var choice_2 = $ChoiceBox/Choice2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.dawn_dialogue_done=true
	GameData.exterior_stage=6
	if GameData.pond_stage ==0:
		pond_area.visible=true
		home_button.visible = true
		gone_pond_scene.visible= false
		dry_pond_scene.visible = true
	GameData.exterior_stage=5
	if GameData.pond_stage==3:
		dry_pond_scene.visible = false
		gone_pond_scene.visible= true
	
func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://destroyed_greenhouse_extreior_intro.tscn")


func _on_pondarea_mouse_entered() -> void:
	if GameData.pond_stage>=0:
		pond_hover.visible = true
func _on_pondarea_mouse_shape_exited(shape_idx: int) -> void:
	pond_hover.visible = false
func _on_pondarea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and GameData.inventory["empty_watering_can"]==0 and GameData.pond_stage>=0:
		dialogue_box.visible = true
		await show_slow_text("We dont seem to have anything to
		transport this water with..We'd better 
		look around, maybe there's 
		something we can use.", true)
		continue_sprite.visible = true
		continue_button.visible =true
		GameData.pond_stage=1
	elif event is InputEventMouseButton and event.pressed and GameData.inventory["empty_watering_can"]==1:
		dialogue_box.visible = true
		await show_slow_text("Lovely! Our little watering
		can couldn't be more perfect to scoop up
		some of this little puddle.",true)
		continue_sprite.visible = true
		continue_button.visible =true
		GameData.pond_stage=2
		
func show_slow_text(new_text, show_continue):
	dialogue_text.text = new_text
	continue_button.visible = false
	continue_sprite.visible = false
	$DialogueBox/DialogueLabel.text = new_text
	$DialogueBox/DialogueLabel.visible = true
	$DialogueBox/DialogueLabel.visible_ratio = 0.0
	var typed = 0.0
	while typed < 1.0:
		typed+=0.02
		$DialogueBox/DialogueLabel.visible_ratio = typed
		await get_tree().create_timer(0.05).timeout
	$DialogueBox/DialogueLabel.visible_ratio = 1.0


func _on_continue_button_pressed() -> void:
	if GameData.pond_stage ==1:
		dialogue_box.visible = false
		continue_sprite.visible=false
	elif GameData.pond_stage==2:
		continue_sprite.visible=false
		await show_slow_text("Fill your watering can
		with water?", false)
		choice_box.visible=true
		choice_1.visible=true
		choice_1.text=("Yes.")
		choice_2.visible = true
		choice_2.text=("Not right now.")
		GameData.pond_stage = 3
	elif GameData.pond_stage==3:
		gone_pond_scene.visible = true
		dialogue_box.visible = false
		choice_box.visible = false
		continue_sprite.visible = false
	elif GameData.pond_stage==4:
		gone_pond_scene.visible = true
		dialogue_box.visible = false
		choice_box.visible = false
		continue_sprite.visible = false
		
func _on_choice_1_pressed() -> void:
	if GameData.pond_stage==3:
		choice_box.visible = false
		GameData.inventory["empty_watering_can"]-=1
		GameData.inventory["full_watering_can"]+=1
		await show_slow_text("Your watering can is full now!
		The pond doesnt seem to be doing
		good.. But let's make sure our 
		seed is.", true)
		GameData.watering_can_filled=true
		dry_pond_scene.visible=false
		gone_pond_scene.visible=true
		continue_sprite.visible=true
		continue_button.visible=true
		GameData.pond_stage = 4
