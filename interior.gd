extends Node2D
@onready var night_windows = $Nightinteriorwindows
@onready var large_rubble_left = $LargeRubbleLeftArea/LargeRubbleLeft
@onready var large_rubble_left_hover = $LargeRubbleLeftArea/LargeRubblePileLeftHover
@onready var large_rubble_front = $LargeRubbleFrontArea/LargeRubbleFront
@onready var large_rubble_front_hover = $LargeRubbleFrontArea/LargeRubblePileFrontHover
@onready var potting_soil = $PottingSoilArea/PottingSoil
@onready var potting_soil_hover = $PottingSoilArea/PottingSoilHover
@onready var medium_rubble = $MediumRubbleArea/MediumRubblePile
@onready var medium_rubble_hover = $MediumRubbleArea/MediumRubbleHover
@onready var empty_pot = $EmptyPotArea/EmptyUsablePot
@onready var pot_with_soil = $EmptyPotArea/PotWithSoil
@onready var empty_pot_hover = $EmptyPotArea/EmptyPotHover
@onready var tiny_rocks = $TinyRockArea/TinyRockRubble
@onready var tiny_rocks_hover = $TinyRockArea/TinyRockHover
@onready var small_rubble = $SmallRubbleArea/SmallRubble
@onready var small_rubble_hover = $SmallRubbleArea/SmallRubbleHover
@onready var broken_shelf = $BrokenLargeShelfArea/BrokenLargeShelf
@onready var broken_shelf_hover = $BrokenLargeShelfArea/LargeShelfHover
@onready var dialogue_box = $DialogueBox
@onready var dialogue_box_label = $DialogueBox/Label
@onready var large_rubble_front_area = $LargeRubbleFrontArea
@onready var continue_button = $"DialogueBox/Continue Sprite/ContinueButton"
@onready var continue_sprite = $"DialogueBox/Continue Sprite"
@onready var medium_rubble_area = $MediumRubbleArea
@onready var tiny_rock_area = $TinyRockArea
@onready var potting_soil_area = $PottingSoilArea
@onready var large_rubble_left_area = $LargeRubbleLeftArea
@onready var small_rubble_area = $SmallRubbleArea
@onready var broken_large_shelf_area = $BrokenLargeShelfArea
@onready var choice_box = $DialogueBox/ChoiceBox
@onready var choice_1 = $DialogueBox/ChoiceBox/Choice1
@onready var choice_2 = $DialogueBox/ChoiceBox/Choice2
@onready var arrow_button = $ArrowButton
@onready var seed_sprouting= $SeedSprouting
@onready var sprout= $Sprout
var medium_rubble_removed = false
var soil_dialogue_finished = false
var pot_can_be_clicked:=true
func _ready():
	continue_button.pressed.connect(_on_continue_button_pressed)
	arrow_button.visible = false
	choice_box.visible = false
	choice_1.visible = false
	choice_2.visible = false
	if GameData.rubble_cleared["small_rubble"]:
		$SmallRubbleArea.queue_free()
	if GameData.rubble_cleared["potting_soil"]:
		$PottingSoilArea.queue_free()
	if GameData.rubble_cleared["tiny_rock_rubble"]:
		tiny_rock_area.queue_free()		
	if GameData.rubble_cleared["broken_large_shelf"]:
		broken_large_shelf_area.queue_free()
	if GameData.rubble_cleared["medium_rubble"]:
		medium_rubble_area.queue_free()
	if GameData.rubble_cleared["large_rubble_left"]:
		large_rubble_left_area.queue_free()
	if GameData.rubble_cleared["large_rubble_front"]:
		large_rubble_front_area.queue_free()
	if GameData.interior_stage ==2:
		GameData.interior_stage=7
		dialogue_box.visible = false
		continue_button.visible = false
		continue_sprite.visible =false
		arrow_button.visible = true
		pot_with_soil.visible = true
	elif GameData.interior_stage==7:
		dialogue_box.visible = false
		continue_button.visible = false
		continue_sprite.visible =false
		arrow_button.visible = true
		pot_with_soil.visible = true
	if GameData.current_day==3:
		pot_with_soil.visible = true
		sprout.visible=true
		sprout.play("jumping")
		await sprout.animation_finished
		sprout.play("idle")
		pot_can_be_clicked=true
		print(GameData.exterior_stage)
		night_windows.visible = false
		arrow_button.visible=true
	if GameData.current_day ==2:
		night_windows.visible = false
		pot_with_soil.visible = true
		if GameData.dawn_dialogue_done==false:
			GameData.interior_stage=8
			arrow_button.visible=false
			dialogue_box.visible=true
			await show_slow_text("OoOoh. Our back doesn't feel too good
			after that rough sleep on the stone floor.", true)
			GameData.interior_stage=9
		else:
			if GameData.has_nurture_powder==true and GameData.first_sprout==false:
				GameData.interior_stage=13
				pot_can_be_clicked=true
			else:
				GameData.interior_stage=11
				dialogue_box.visible=false
				continue_button.visible=false
				continue_sprite.visible=false
				choice_box.visible=false
				choice_1.visible=false
				choice_2.visible=false
				arrow_button.visible=true
	else:
		start_interior_sequence()
	
func start_interior_sequence():
	if GameData.interior_stage == 0:
		dialogue_box.visible = true
		await show_slow_text("This place is a reck. Looks like
		there's only one good pot left here.
		Luckily, that's all we need for now.", true)
func _on_large_rubble_front_area_mouse_entered() -> void:
	if GameData.interior_stage >= 2:
		large_rubble_front_hover.visible = true
func _on_large_rubble_front_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and GameData.interior_stage >=2 and event.pressed:
		GameData.inventory["wood"] += 1
		GameData.inventory["rocks"] += 2
		print(GameData.inventory)
		GameData.rubble_cleared["large_rubble_front"]=true
		large_rubble_front_area.queue_free()
		GameData.save_game()
func _on_large_rubble_front_area_mouse_exited() -> void:
	large_rubble_front_hover.visible = false
func _on_large_rubble_left_area_mouse_entered() -> void:
	if GameData.interior_stage >= 2:
		large_rubble_left_hover.visible = true
func _on_large_rubble_left_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and GameData.interior_stage >=2 and event.pressed:
		GameData.inventory["wood"] += 2
		GameData.inventory["rocks"] += 1
		print(GameData.inventory)
		GameData.rubble_cleared["large_rubble_left"]=true
		large_rubble_left_area.queue_free()
		GameData.save_game()
func _on_large_rubble_left_area_mouse_exited() -> void:
	large_rubble_left_hover.visible = false
func _on_medium_rubble_area_mouse_entered() -> void:
	if GameData.interior_stage == 2:
		medium_rubble_hover.visible = true
func _on_medium_rubble_area_mouse_exited() -> void:
	medium_rubble_hover.visible = false
func _on_medium_rubble_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if GameData.interior_stage == 2 and event is InputEventMouseButton and event.pressed:
		GameData.inventory["wood"] +=1
		medium_rubble_removed = true
		GameData.rubble_cleared["medium_rubble"]= true
		GameData.interior_stage = 3
		dialogue_box.visible = true
		medium_rubble_area.queue_free()
		await show_slow_text("Look!.. Some soil. That
		should be exactly what we need
		to plant this little seed.", true)
		GameData.save_game()
func _on_empty_pot_area_mouse_entered() -> void:
	if not pot_can_be_clicked:
		return
	if GameData.interior_stage == 1 or GameData.interior_stage ==4 or GameData.interior_stage >=5:
		empty_pot_hover.visible = true
func _on_empty_pot_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if not pot_can_be_clicked:
		return
	pot_can_be_clicked = false
	empty_pot_hover.visible = false
	if GameData.interior_stage ==1:
		dialogue_box.visible = true
		await show_slow_text("It's empty. The seed will be too cold
		against the bare clay. Let's look for
		something to bury it with.", true)
		continue_button.visible = true
		continue_sprite.visible = true
	elif GameData.interior_stage ==4:
		show_fill_soil_choices()
	elif GameData.interior_stage ==5:
		show_plant_seed_choices()
	elif GameData.interior_stage==13 and GameData.has_nurture_powder==true:
		pot_can_be_clicked=false
		dialogue_box.visible=true
		arrow_button.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		await show_slow_text("The seed begins to react as
		you draw near with the powder, it 
		seems quite excited!", false)
		choice_box.visible=true
		choice_1.visible=true
		choice_2.visible=true
		choice_1.text="Use basic nurture powder on seed."
		choice_2.text="Do nothing for now."
	elif GameData.interior_stage==11 and GameData.current_day ==2:
		dialogue_box.visible = true
		arrow_button.visible = false
		continue_button.visible=false
		continue_sprite.visible=false
		if GameData.watering_can_water>=0.5:
			await show_slow_text("Our watering can is ready to 
			water our seed. Good work, Flower
			Keeper " + GameData.player_name + ".", false)
			continue_button.visible=false
			continue_sprite.visible=false
			choice_box.visible = true
			choice_1.visible = true
			choice_2.visible= true
			choice_1.text = "Water your Seed."
			choice_2.text = "Do nothing for now."
			continue_button.hide()
			continue_sprite.hide()
		else:
			await show_slow_text("Your seed is growing strong.
			It'll need water soon though or that
			will change.", true)
			arrow_button.visible = true
	elif GameData.interior_stage>=15:
		sprout.play("jumping")
		await sprout.animation_finished
		sprout.play("idle")
		print(GameData.exterior_stage)
func show_fill_soil_choices():
	dialogue_box.visible = true
	await show_slow_text("What would you like to do with
	the pot?", false)
	choice_box.visible = true
	choice_1.visible = true
	choice_2.visible = true
	choice_1.text = "Fill the pot with soil."
	choice_2.text = "Nothing for now.."
func show_plant_seed_choices():
	dialogue_box.visible = true
	await show_slow_text("The pot is ready. What should we do with
	 our seed?", false)
	choice_box.visible = true
	choice_1.visible = true
	choice_2.visible = true
	choice_1.text = "Plant chosen seed in the cool soil"
	choice_2.text = "Nothing for now.."
		
func _on_empty_pot_area_mouse_exited() -> void:
	empty_pot_hover.visible = false
func _on_small_rubble_area_mouse_entered() -> void:
	if GameData.interior_stage >= 2:
		small_rubble_hover.visible = true
func _on_small_rubble_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and GameData.interior_stage >=2 and event.pressed:
		GameData.inventory["wood"]+= 1
		GameData.inventory["rocks"]+=1
		print(GameData.inventory)
		GameData.rubble_cleared["small_rubble"] = true
		small_rubble_area.queue_free()
		GameData.save_game()
func _on_small_rubble_area_mouse_exited() -> void:
	small_rubble_hover.visible = false
func _on_broken_large_shelf_area_mouse_entered() -> void:
	if GameData.interior_stage >= 2:
		broken_shelf_hover.visible = true
func _on_broken_large_shelf_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and GameData.interior_stage >=2 and event.pressed:
		GameData.inventory["wood"] +=2
		print(GameData.inventory)
		GameData.rubble_cleared["broken_large_shelf"] = true
		broken_large_shelf_area.queue_free()
		GameData.save_game()
func _on_broken_large_shelf_area_mouse_exited() -> void:
	broken_shelf_hover.visible = false
func _on_tiny_rock_area_mouse_entered() -> void:
	if GameData.interior_stage >= 2:
		tiny_rocks_hover.visible = true
func _on_tiny_rock_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and GameData.interior_stage >=2 and event.pressed:
		GameData.inventory["rocks"] += 1
		print(GameData.inventory)
		GameData.rubble_cleared["tiny_rock_rubble"] = true
		tiny_rock_area.queue_free()		
		GameData.save_game()
func _on_tiny_rock_area_mouse_exited() -> void:
	tiny_rocks_hover.visible = false
func _on_potting_soil_area_mouse_entered() -> void:
	if GameData.interior_stage == 3 and medium_rubble_removed and soil_dialogue_finished:
		potting_soil_hover.visible = true
func _on_potting_soil_area_mouse_exited() -> void:
	potting_soil_hover.visible = false
func _on_potting_soil_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and GameData.interior_stage >=3 and soil_dialogue_finished and GameData.rubble_cleared["medium_rubble"] and event.pressed:
		GameData.inventory["soil"] += 1
		print(GameData.inventory)
		GameData.rubble_cleared["potting_soil"]=true
		potting_soil_area.queue_free()
		GameData.interior_stage = 4
		pot_can_be_clicked=true
		GameData.save_game()
func _on_continue_button_pressed() -> void:
	print("the day is:", GameData.current_day)
	print("continue clicked - interior_stage: ", GameData.interior_stage)
	if GameData.interior_stage == 0:
		GameData.interior_stage = 1
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		pot_can_be_clicked=true
	elif GameData.interior_stage == 1:
		GameData.interior_stage = 2
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif GameData.interior_stage == 2:
		GameData.interior_stage = 3
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif GameData.interior_stage == 3:
		soil_dialogue_finished = true
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif GameData.interior_stage == 6 and GameData.campfire_lit == false:
		await show_slow_text("It's going to get cold tonight.
		Let's check that campfire that was outside.", true)
		arrow_button.visible=true
		GameData.interior_stage = 7
	elif GameData.interior_stage ==7:
		dialogue_box.visible = false
		continue_button.visible=false
		continue_sprite.visible = false
		GameData.exterior_stage = 2
		arrow_button.visible= true
	elif GameData.interior_stage ==9:
		await show_slow_text("More importantly for now though,
		lets check on our little friend.", true)
		GameData.interior_stage = 10
	elif GameData.interior_stage==10:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		GameData.interior_stage=11
		pot_can_be_clicked=true
	elif GameData.interior_stage ==11:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		arrow_button.visible=true
		pot_can_be_clicked=true
	elif GameData.interior_stage==12:
		continue_button.visible=false
		continue_sprite.visible=false
		dialogue_box.visible=true
		arrow_button.visible=false
		await show_slow_text("A strange small shadow appears
		from overhead. You glance up and see
		the distorted view of a small purple
		bird.", true)
		GameData.interior_stage=13
	elif GameData.interior_stage==13 and GameData.has_nurture_powder==false:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		arrow_button.visible=true
	elif GameData.interior_stage==14:
		continue_button.visible = false
		continue_sprite.visible = false
		await show_slow_text("It's getting late. We should head
		to bed soon...or more like to
		the corner.. Haha. We'll fix that 
		eventually.", true)
		GameData.interior_stage=15
		GameData.first_sprout_dialogue_seen=true
		GameData.save_game()
		GameData.interior_stage=15
	elif GameData.interior_stage==15:
		pot_can_be_clicked=true
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		arrow_button.visible=true
		GameData.interior_stage=16
		return
func _on_arrow_button_pressed() -> void:
	get_tree().change_scene_to_file("res://destroyed_greenhouse_extreior_intro.tscn")
func _on_choice_1_pressed() -> void:
	if GameData.interior_stage == 4:
		GameData.inventory["soil"] -=1
		empty_pot.visible = false
		pot_with_soil.visible = true
		dialogue_box.visible = false
		choice_box.visible = false
		choice_1.visible =false
		choice_2.visible = false
		GameData.interior_stage = 5
		pot_can_be_clicked=true
		GameData.save_game()
	elif GameData.interior_stage ==5:
		GameData.inventory["seeds"] -=1
		dialogue_box.visible = true
		choice_box.visible = false
		choice_1.visible =false
		choice_2.visible = false
		await show_slow_text("You have planted your seed. It'll
		take a few days to grow.", true)
		GameData.interior_stage=6
		GameData.save_game()
	elif GameData.interior_stage==11 and GameData.current_day ==2 and GameData.watering_can_filled:
		choice_box.visible = false
		choice_1.visible = false
		choice_2.visible = false
		continue_button.visible=false
		continue_button.visible=false
		dialogue_box.visible = true
		GameData.watering_can_water -=0.5
		GameData.interior_stage=12
		await show_slow_text("The soil begins to shift.. What
		a lively reaction to our water gift!", true)
		GameData.seed_watered=true
		GameData.save_game()
	elif GameData.interior_stage==13 and GameData.has_nurture_powder==true:
		choice_box.visible=false
		choice_1.visible=false
		choice_2.visible=false
		dialogue_box.visible=false
		GameData.inventory["basic_nurture_powder"]-=1
		GameData.first_sprout=true
		GameData.save_game()	
		seed_sprouting.visible=true
		sprout.visible=false
		seed_sprouting.play("sprouting")
		await seed_sprouting.animation_finished
		seed_sprouting.stop()
		seed_sprouting.visible = false
		sprout.visible = true
		sprout.play("idle")
		dialogue_box.visible=true
		continue_button.visible=false
		continue_sprite.visible=false
		arrow_button.visible=false
		await show_slow_text(
			"So sweet. Your "+GameData.chosen_seed+" looks very healthy
			and curious. It's too small to do much
			right now, though.", true)
		GameData.interior_stage=14
func _on_choice_2_pressed() -> void:
	if GameData.interior_stage ==4:
		dialogue_box.visible = false
		choice_box.visible = false
		choice_1.visible=false
		choice_2.visible=false
		pot_can_be_clicked=true
	elif GameData.interior_stage==5:
		dialogue_box.visible = false
		choice_box.visible = false	
		choice_1.visible=false
		choice_2.visible=false
		pot_can_be_clicked=true
	elif GameData.interior_stage==11 and GameData.current_day==2:
		choice_box.visible= false
		choice_1.visible = false
		choice_2.visible=false
		dialogue_box.visible = false
		arrow_button.visible= true
		pot_can_be_clicked=true
	elif GameData.interior_stage==13 and GameData.has_nurture_powder==true:
		pot_can_be_clicked=true
		choice_box.visible= false
		choice_1.visible = false
		choice_2.visible=false
		dialogue_box.visible = false
		arrow_button.visible= true
func show_slow_text(new_text, show_continue):
	continue_button.visible = false
	continue_sprite.visible = false
	$DialogueBox/Label.text = new_text
	$DialogueBox/Label.visible = true
	$DialogueBox/Label.visible_ratio = 0.0
	var typed = 0.0
	while typed < 1.0:
		typed+=0.02
		$DialogueBox/Label.visible_ratio = typed
		await get_tree().create_timer(0.05).timeout
	$DialogueBox/Label.visible_ratio = 1.0
	if show_continue == true:
		continue_button.visible = true
		continue_sprite.visible = true
