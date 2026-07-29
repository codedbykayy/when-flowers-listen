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
@onready var nurture_powder_button =$NurturePowderButton
@onready var bird_button= $BirdButton
@onready var bird_flying: AnimatedSprite2D = $BirdFlying
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
	choice_box.visible=false
	choice_1.visible=false
	choice_2.visible=false
	continue_button.pressed.connect(_on_continue_button_pressed)
	choice_1.pressed.connect(_on_choice_1_pressed)
	choice_2.pressed.connect(_on_choice_2_pressed)
	fire_lit.visible = GameData.campfire_lit
	bird_button.visible=false
	bird_button.disabled=true
	bird_flying.visible=false
	nurture_powder_button.visible=false
	nurture_powder_button.disabled=true
	if GameData.current_day==3:
		watering_can_area.visible =false
		day_with_can.visible=false
		day_time.visible=true
		night_time.visible=false
		nurture_powder_button.visible=false
		pond_arrow.visible=true
		campfire_area.visible=false
		door_can_be_clicked=true
	if GameData.current_day==2:
		if GameData.first_sprout_dialogue_seen:
			watering_can_area.visible =false
			day_with_can.visible=false
			day_time.visible=false
			night_time.visible=true
			nurture_powder_button.visible=false
			pond_arrow.visible=false
			dialogue_box_day.visible=false
			dialogue_box.visible=false
			dialogue_text.visible=false
			continue_button.visible=false
			continue_sprite.visible=false
			continue_sprite_day.visible=false
			campfire_area.visible=true
			fire_lit.visible=true
			return
		elif GameData.dawn_dialogue_done==false:
			dialogue_box_day.visible = true
			dialogue_text.visible = true
			continue_button.visible=false
			continue_sprite_day.visible=false
			pond_arrow.visible=false
			day_with_can.visible=true
			day_time.visible=false
			night_time.visible=false
			await show_slow_text("The new dawns bright sunlight 
			reveals a path the darkness 
			previously hid from tired eyes.", true)
			continue_button.visible = true
			continue_sprite_day.visible = true
			GameData.save_game()
		else:
			dialogue_box_day.visible=false
			dialogue_text.visible=false
			dialogue_text.visible = false
			continue_button.visible=false
			continue_sprite_day.visible=false
			door_can_be_clicked=true
			pond_arrow.visible=true
		if GameData.has_watering_can==false:
			day_time.visible=false
			day_with_can.visible = true
			watering_can_area.visible = true
		else: 
			day_with_can.visible=false
			day_time.visible=true
			watering_can_area.visible=false
		if GameData.watering_can_filled==true:
			watering_can_area=false
			day_with_can.visible=false
			day_time.visible=true
			door_can_be_clicked=true
		if GameData.seed_watered== true and GameData.bird_event_seen==false:
			pond_arrow.visible=false
			bird_button.visible=true
			bird_button.disabled=false
			nurture_powder_button.visible=true
			nurture_powder_button.disabled=false
			nurture_powder_button.mouse_filter=Control.MOUSE_FILTER_IGNORE
		elif GameData.bird_event_seen==true and GameData.has_nurture_powder==false:
			bird_button.visible=false
			bird_button.disabled=true
			nurture_powder_button.visible=true
			nurture_powder_button.disabled=false
		elif GameData.has_nurture_powder==true:
			bird_button.visible=false
			bird_button.disabled=true
			nurture_powder_button.visible=false
			nurture_powder_button.disabled=true
	if GameData.exterior_stage ==1:
		dialogue_box.visible=true
		dialogue_text.visible=true
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
		fire_lit.visible = GameData.campfire_lit
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible=false
		dialogue_text.visible=false
		choice_box.visible=false
		choice_1.visible=false
		choice_2.visible = false
	
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
	if GameData.current_day==2 and GameData.dawn_dialogue_done==false:
		GameData.dawn_dialogue_done=true
		dialogue_box_day.visible=false
		dialogue_text.visible=false
		continue_button.visible = false
		continue_sprite_day.visible =false
		pond_arrow.visible=true
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
	elif dialogue_line==5:
		continue_button.visible = false
		continue_sprite_day.visible = false
		dialogue_box_day.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
		nurture_powder_button.disabled=false
		nurture_powder_button.mouse_filter= Control.MOUSE_FILTER_STOP
		GameData.bird_event_seen = true
		GameData.save_game()
	elif dialogue_line==6:
		continue_button.visible = false
		continue_sprite_day.visible = false
		await show_slow_text("I think I remember that the 
		flower's really rely on this stuff
		though. Let's show it to ours.", true)
		continue_sprite_day.visible=true
		dialogue_line=7
	elif dialogue_line==7:
		continue_button.visible = false
		continue_sprite_day.visible = false
		dialogue_box_day.visible = false
		dialogue_text.visible = false
		door_can_be_clicked = true
		GameData.exterior_stage=8
		GameData.save_game()
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
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed and( GameData.exterior_stage==3 or (GameData.current_day==2 and GameData.first_sprout_dialogue_seen)):
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
		GameData.save_game()
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
		GameData.save_game()
	elif GameData.exterior_stage ==4:
		print("CLICKEDDD")
		get_tree().change_scene_to_file("res://campfire_scene.tscn")
		GameData.save_game()
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
	elif GameData.exterior_stage==4:
		dialogue_box.visible = false
		dialogue_text.visible = false
		choice_box.visible = false
		choice_1.visible = false
		choice_2.visible = false
		GameData.exterior_stage=3
		pass
func _on_water_can_area_mouse_entered() -> void:
	if GameData.current_day==2:
		watering_can_hover.visible = true
func _on_water_can_area_mouse_exited() -> void:
	watering_can_hover.visible =false
func _on_water_can_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed and not GameData.has_watering_can:
		$Day1WWateringCan/WaterCanArea.input_pickable= false
		$Day1WWateringCan/WaterCanArea.monitoring=false
		GameData.inventory["empty_watering_can"]+=1
		GameData.has_watering_can = true
		GameData.watering_can_water=0.0
		$Day1WWateringCan/WaterCanArea.hide()
		dialogue_box_day.visible = true
		await show_slow_text("Heyy! Its empty..but somebody took 
		good enough care of it that we 
		can use it to hold water still!", true)
		continue_button.visible = true
		continue_sprite_day.visible = true
		GameData.exterior_stage = 7
		watering_can_area.queue_free()
		GameData.save_game()
		day_with_can.visible=false
		day_time.visible = true
func _on_pond_arrow_pressed() -> void:		
	get_tree().change_scene_to_file("res://pondscene.tscn")
func bird_fly_away():
	bird_flying.visible=true
	bird_flying.play("fly")
	var bird_tween= create_tween()
	bird_tween.tween_property(
		bird_flying,
		"position:x",
		-150.0,
		2.0
		)
	await bird_tween.finished
	bird_flying.stop()
	bird_flying.visible=false


func _on_bird_button_pressed() -> void:
	bird_button.disabled=true
	bird_button.visible=false
	await bird_fly_away()
	dialogue_box_day.visible=true
	dialogue_text.visible=true
	await show_slow_text("Seems we've scared the little guy 
	off. Though it appears it's left 
	something behind..dirt?", true)
	continue_sprite_day.visible=true
	dialogue_line = 5
func _on_nurture_powder_button_pressed() -> void:
	GameData.inventory["basic_nurture_powder"]+=1
	GameData.has_nurture_powder=true
	$NurturePowderButton.visible=false
	$NurturePowderButton.disabled=true
	GameData.save_game()
	dialogue_box_day.visible=true
	dialogue_text.visible=true
	await show_slow_text("Ahh..This isn't dirt. This 
	is basic nurture powder. There's
	something written about this
	in the journal.", true)
	continue_sprite_day.visible=true
	dialogue_line=6
