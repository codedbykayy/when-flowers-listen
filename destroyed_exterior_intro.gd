extends Node2D
@onready var dialogue_box = $DialogueBoxNight
@onready var front_door = $FrontDoor
@onready var continue_button = $ContinueButton
@onready var dialogue_text = $DialogueLabel
@onready var continue_sprite = $"Continue(dark)"
@onready var door_hover =$DoorHover
@onready var campfire_area = $CampfireArea
@onready var campfire_hover = $CampfireArea/CampfireHoverfinal
@onready var exterior_stage = GameData.exterior_stage
@onready var fire_lit =$FireLit
@onready var choice_box=$ChoiceBox
@onready var choice_1 = $ChoiceBox/Choice1
@onready var choice_2 = $ChoiceBox/Choice2
@onready var day_time=$DayTime
@onready var night_time=$DeadDarkExterior
@onready var day_with_can=$Day1WWateringCan
@onready var dialogue_box_day = $DialogueBoxDay
@onready var continue_sprite_day = $ContinueDay
@onready var watering_can_area = $Day1WWateringCan/WaterCanArea
@onready var watering_can_hover=$Day1WWateringCan/WaterCanArea/WateringCanHover
@onready var pond_arrow = $PondArrow
var dialogue_line = 0
var has_campfire_materials = false
var door_can_be_clicked = false
func _ready() -> void:
	watering_can_area.visible= false
	day_with_can.visible = false
	day_time.visible = false
	night_time.visible = true
	dialogue_box_day.visible=false
	continue_sprite_day.visible = false
	continue_button.pressed.connect(_on_continue_button_pressed)
	choice_1.pressed.connect(_on_choice_1_pressed)
	choice_2.pressed.connect(_on_choice_2_pressed)
	if GameData.current_day>=1 and GameData.campfire_lit == true:
		fire_lit.visible = true
	if GameData.watering_can_filled==true:
		dialogue_box_day.visible = false
		dialogue_text.visible=false
		continue_button.visible = false
		continue_sprite_day.visible= false
	if GameData.dawn_dialogue_done==true:
		dialogue_box_day.visible = false
		dialogue_text.visible=false
		continue_button.visible = false
		continue_sprite_day.visible= false
	if GameData.current_day==2 and GameData.exterior_stage>=5:
		day_with_can.visible = true
		watering_can_area.visible = true
		day_time.visible=true
		night_time.visible =false
		dialogue_box_day.visible = true
		dialogue_box.visible = false
		dialogue_text.visible = true
		continue_button.disabled = false
		await show_slow_text("The new dawns bright sunlight 
		reveals a path the darkness 
		previously hid from tired eyes.", true)
		continue_button.visible = true
		continue_sprite_day.visible = true
		pond_arrow.visible = true
		GameData.exterior_stage=6
		GameData.dawn_dialogue_done = true
	elif GameData.exterior_stage ==1:
		if dialogue_line == 0:
			fire_lit.visible = false
			await show_slow_text("Looks like its been ages since
			somebody was here.", true)
			dialogue_line = 1
	elif GameData.exterior_stage ==2:
		dialogue_box.visible = false
		dialogue_text.visible = false
		continue_button.visible = false
		continue_sprite.visible = false
		door_can_be_clicked = true
		has_campfire_materials = (
		GameData.inventory["wood"]>=5 and GameData.inventory["rocks"]>=3)
	elif GameData.exterior_stage==3:
		fire_lit.visible = true
		continue_button.visible = false
		dialogue_box.visible=false
		choice_box.visible=false
		choice_1.visible=false
		choice_2.visible = false
	elif GameData.exterior_stage ==5:
		dialogue_box_day.visible = true
		dialogue_box.visible = false
		dialogue_text.visible = true
		continue_sprite_day.visible = true
		continue_button.visible = true
	elif GameData.exterior_stage>=6:
		dialogue_box_day.visible=false
		dialogue_box.visible = false
		dialogue_text.visible = false
		continue_sprite_day.visible =false
		continue_button.visible = false	
		pond_arrow.visible = true
func show_slow_text(new_text, show_continue):
	dialogue_text.text = new_text
	continue_button.visible = false
	continue_sprite.visible = false
	$DialogueLabel.text = new_text
	$DialogueLabel.visible = true
	$DialogueLabel.visible_ratio = 0.0
	var typed = 0.0
	while typed < 1.0:
		typed+=0.02
		$DialogueLabel.visible_ratio = typed
		await get_tree().create_timer(0.05).timeout
	$DialogueLabel.visible_ratio = 1.0
	if show_continue == true:
		continue_button.visible = true
		continue_sprite.visible = true
	elif show_continue == false:
		continue_button.visible = false
		continue_sprite.visible = false
func _on_continue_button_pressed():
	print("Continue button pressed")
	if GameData.exterior_stage ==2:
		dialogue_box.visible = false
		dialogue_text.visible = false
		continue_button.visible = false
		continue_sprite.visible = false
		door_can_be_clicked = true
		return
	if dialogue_line==1:
		dialogue_line += 1
		continue_button.disabled = false
		await show_slow_text("We should head inside. Perhaps 
		there's something to help us with 
		our new seed.", true)
		door_can_be_clicked = true
		dialogue_line =2
	elif dialogue_line ==2:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
		continue_button.disabled = true
	if dialogue_line == 3:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
		continue_button.disabled = true
	elif dialogue_line==4:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
		continue_button.disabled = true
	elif GameData.exterior_stage ==4:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
		continue_button.disabled = true
	elif GameData.exterior_stage==5:
		continue_button.visible = false
		continue_sprite_day.visible = false
		dialogue_box_day.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
	elif GameData.exterior_stage==6:
		continue_button.visible = false
		continue_sprite_day.visible = false
		dialogue_box_day.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
	elif GameData.exterior_stage==7:
		continue_button.visible = false
		continue_sprite_day.visible = false
		dialogue_box_day.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
func _on_front_door_mouse_entered() -> void:
	if door_can_be_clicked:
		door_hover.visible = true
func _on_front_door_mouse_exited() -> void:
	door_hover.visible = false
func _on_front_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if door_can_be_clicked and event is InputEventMouseButton and event.pressed:
		enter_front_door()		
func enter_front_door():
	get_tree().change_scene_to_file("res://Interior.tscn")
func _on_campfire_area_mouse_entered() -> void:
	if GameData.exterior_stage >=2:
		campfire_hover.visible = true
func _on_campfire_area_mouse_exited() -> void:
	campfire_hover.visible = false
func _on_campfire_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and GameData.exterior_stage==2:
		print("campfire clicked")
		repair_campfire()
	if event is InputEventMouseButton and event.pressed and GameData.exterior_stage>=3:
		print("the lights are on")
		dialogue_box.visible = true
		dialogue_text.visible = true
		choice_box.visible = false
		choice_1.visible= false
		choice_2.visible = false
		await show_slow_text("Toasty already! Why don't we take 
		a seat and prepare for the new day.",false)
		choice_1.text= ("Sit by the fire and end the night.")
		choice_2.text= ("Stay up a little longer.")
		dialogue_box.visible = true
		choice_box.visible = true
		choice_1.visible= true
		choice_2.visible = true
		GameData.exterior_stage = 4
func repair_campfire():
	if int(GameData.inventory["wood"]>=5) and int(GameData.inventory["rocks"]>=3):
		print("enough materials")
		dialogue_box.visible = true
		await show_slow_text("We have enough materials
		to repair it. Glad all that junk came 
		in handy for something. Use 5 wood
		& 3 stones to repair the campfire?", false)
		choice_1.text = "Use materials and repair the fire"
		choice_2.text = "I dont want to yet."
		choice_1.visible=true
		choice_2.visible=true
		choice_box.visible=true
	else:
		dialogue_line = 2
		continue_button.disabled = false
		continue_button.mouse_filter = Control.MOUSE_FILTER_STOP
		show_slow_text("Looks pretty beat up. 
		We need more materials to repair
		it. Maybe cleaning the rubble 
		inside will help.", true)
		dialogue_box.visible = true
func _on_choice_1_pressed() -> void:
	if GameData.exterior_stage ==2:
		GameData.inventory["wood"] -=5
		GameData.inventory["rocks"] -=3
		fire_lit.visible =true
		GameData.campfire_lit= true
		GameData.exterior_stage = 3
		dialogue_box.visible = false
		dialogue_text.visible = false
		choice_box.visible = false
		choice_1.visible = false
		choice_2.visible = false
	elif GameData.exterior_stage ==4:
		print("CLICKEDDD")
		get_tree().change_scene_to_file("res://campfire_scene.tscn")
func _on_choice_2_pressed() -> void:	
	if GameData.exterior_stage==2:
		dialogue_box.visible = false
		dialogue_text.visible = false
		choice_box.visible = false
		choice_1.visible = false
		choice_2.visible = false
		pass	
	elif GameData.exterior_stage==3:
		dialogue_box.visible = false
		dialogue_text.visible = false
		choice_box.visible = false
		choice_1.visible = false
		choice_2.visible = false
		pass
func _on_water_can_area_mouse_entered() -> void:
	if GameData.current_day==2:
		watering_can_hover.visible = true
func _on_water_can_area_mouse_exited() -> void:
	watering_can_hover.visible =true
func _on_water_can_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and GameData.current_day==2:
		GameData.inventory["empty_watering_can"]+=1
		GameData.has_watering_can = true
		dialogue_box_day.visible = true
		await show_slow_text("Heyy! Its empty..but somebody took 
		good enough care of it that we 
		can use it to hold water still!", true)
		continue_button.visible = true
		continue_sprite_day.visible = true
		GameData.exterior_stage = 7
		watering_can_area.queue_free()
		day_with_can.visible=false
		day_time.visible = true
func _on_pond_arrow_pressed() -> void:		
	get_tree().change_scene_to_file("res://pondscene.tscn")
