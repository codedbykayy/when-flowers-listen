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
var wood = 0
var rocks = 0
var soil = 0
var interior_stage = 0
var medium_rubble_removed = false
var soil_dialogue_finished = false
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
		interior_stage=7
		dialogue_box.visible = false
		continue_button.visible = false
		continue_sprite.visible =false
		arrow_button.visible = true
		pot_with_soil.visible = true
	if GameData.current_day ==2:
		interior_stage = 8
		night_windows.visible =false
		arrow_button.visible = false
		dialogue_box.visible = true
		continue_button.disabled= false
		continue_button.visible =true
		continue_sprite.visible = true
		await show_slow_text("OoOoh. Our back doesn't feel too good
		after that rough sleep on the stone floor.", true)
		interior_stage=9
	else:
		start_interior_sequence()
	
func start_interior_sequence():
	if interior_stage == 0:
		dialogue_box.visible = true
		await show_slow_text("This place is a reck. Looks like
		there's only one good pot left here.
		Luckily, that's all we need for now.", true)
		continue_sprite.visible=true
		continue_button.visible=true
func _on_large_rubble_front_area_mouse_entered() -> void:
	if interior_stage >= 2:
		large_rubble_front_hover.visible = true
func _on_large_rubble_front_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and interior_stage >=2 and event.pressed:
		GameData.inventory["wood"] += 1
		GameData.inventory["rocks"] += 2
		print(GameData.inventory)
		GameData.rubble_cleared["large_rubble_front"]=true
		large_rubble_front_area.queue_free()
func _on_large_rubble_front_area_mouse_exited() -> void:
	large_rubble_front_hover.visible = false
func _on_large_rubble_left_area_mouse_entered() -> void:
	if interior_stage >= 2:
		large_rubble_left_hover.visible = true
func _on_large_rubble_left_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and interior_stage >=2 and event.pressed:
		GameData.inventory["wood"] += 2
		GameData.inventory["rocks"] += 1
		print(GameData.inventory)
		GameData.rubble_cleared["large_rubble_left"]=true
		large_rubble_left_area.queue_free()
func _on_large_rubble_left_area_mouse_exited() -> void:
	large_rubble_left_hover.visible = false
func _on_medium_rubble_area_mouse_entered() -> void:
	if interior_stage == 2:
		medium_rubble_hover.visible = true
func _on_medium_rubble_area_mouse_exited() -> void:
	medium_rubble_hover.visible = false
func _on_medium_rubble_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if interior_stage == 2 and event is InputEventMouseButton and event.pressed:
		GameData.inventory["wood"] +=1
		medium_rubble_removed = true
		GameData.rubble_cleared["medium_rubble"]= true
		interior_stage = 3
		dialogue_box.visible = true
		medium_rubble_area.queue_free()
		await show_slow_text("Look!.. Some soil. That
		should be exactly what we need
		to plant this little seed.", true)
		continue_button.visible =true
		continue_sprite.visible = true
func _on_empty_pot_area_mouse_entered() -> void:
	if interior_stage == 1 or interior_stage ==4 or interior_stage >=5:
		empty_pot_hover.visible = true
func _on_empty_pot_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed: 
		if interior_stage ==1:
			dialogue_box.visible = true
			await show_slow_text("It's empty. The seed will be too cold
			against the bare clay. Let's look for
			something to bury it with.", true)
			continue_button.visible = true
			continue_sprite.visible = true
		elif interior_stage ==4:
			show_fill_soil_choices()
		elif interior_stage ==5:
			show_plant_seed_choices()
		elif interior_stage==11 and GameData.current_day ==2 and GameData.inventory["full_watering_can"]<=0:
			dialogue_box.visible = true
			await show_slow_text("Your seed is growing strong.
			It'll need water soon though or that
			will change.", true)
			arrow_button.visible = true
			continue_button.visible = true
			continue_sprite.visible = true
			return
			interior_stage=12
			print(GameData.exterior_stage)
		elif interior_stage >= 7 and GameData.campfire_lit == false:
			dialogue_box.visible = true
			continue_button.visible = true
			continue_sprite.visible = true
			await show_slow_text("It's going to get cold tonight.
			Let's check that campfire that was outside.", true)
			return
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
	if interior_stage >= 2:
		small_rubble_hover.visible = true
func _on_small_rubble_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and interior_stage >=2 and event.pressed:
		GameData.inventory["wood"]+= 1
		GameData.inventory["rocks"]+=1
		print(GameData.inventory)
		GameData.rubble_cleared["small_rubble"] = true
		small_rubble_area.queue_free()
func _on_small_rubble_area_mouse_exited() -> void:
	small_rubble_hover.visible = false
func _on_broken_large_shelf_area_mouse_entered() -> void:
	if interior_stage >= 2:
		broken_shelf_hover.visible = true
func _on_broken_large_shelf_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and interior_stage >=2 and event.pressed:
		GameData.inventory["wood"] +=2
		print(GameData.inventory)
		GameData.rubble_cleared["broken_large_shelf"] = true
		broken_large_shelf_area.queue_free()
func _on_broken_large_shelf_area_mouse_exited() -> void:
	broken_shelf_hover.visible = false
func _on_tiny_rock_area_mouse_entered() -> void:
	if interior_stage >= 2:
		tiny_rocks_hover.visible = true
func _on_tiny_rock_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and interior_stage >=2 and event.pressed:
		GameData.inventory["rocks"] += 1
		print(GameData.inventory)
		GameData.rubble_cleared["tiny_rock_rubble"] = true
		tiny_rock_area.queue_free()		
func _on_tiny_rock_area_mouse_exited() -> void:
	tiny_rocks_hover.visible = false
func _on_potting_soil_area_mouse_entered() -> void:
	if interior_stage == 3 and medium_rubble_removed and soil_dialogue_finished:
		potting_soil_hover.visible = true
func _on_potting_soil_area_mouse_exited() -> void:
	potting_soil_hover.visible = false
func _on_potting_soil_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and interior_stage >=3 and soil_dialogue_finished and GameData.rubble_cleared["medium_rubble"] and event.pressed:
		GameData.inventory["soil"] += 1
		print(GameData.inventory)
		GameData.rubble_cleared["potting_soil"]=true
		potting_soil_area.queue_free()
		interior_stage = 4


func _on_continue_button_pressed() -> void:
	print("the day is:", GameData.current_day)
	print("continue clicked - interior_stage: ", interior_stage)
	if interior_stage == 0:
		interior_stage = 1
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif interior_stage == 1:
		interior_stage = 2
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif interior_stage == 2:
		interior_stage = 3
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif interior_stage == 3:
		soil_dialogue_finished = true
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	elif interior_stage == 6 and GameData.campfire_lit == false:
		interior_stage = 7
		GameData.interior_stage =2
		await show_slow_text("It's going to get cold tonight.
		Let's check that campfire that was outside.", true)
	elif interior_stage ==7:
		dialogue_box.visible = false
		continue_button.visible=false
		continue_sprite.visible = false
		GameData.exterior_stage = 2
		arrow_button.visible= true
	elif interior_stage ==9:
		await show_slow_text("More importantly for now though,
		lets check on our little friend.", true)
		interior_stage = 10
	elif interior_stage==10:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		interior_stage=11
	elif interior_stage ==11:
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
		interior_stage=12
	elif interior_stage==12:
		arrow_button.visible = true
		continue_button.visible = false
		continue_sprite.visible = false
		dialogue_box.visible = false
	
func _on_arrow_button_pressed() -> void:
	get_tree().change_scene_to_file("res://destroyed_greenhouse_extreior_intro.tscn")
func _on_choice_1_pressed() -> void:
	if interior_stage == 4:
		GameData.inventory["soil"] -=1
		empty_pot.visible = false
		pot_with_soil.visible = true
		dialogue_box.visible = false
		choice_box.visible = false
		choice_1.visible =false
		choice_2.visible = false
		interior_stage = 5
	elif interior_stage ==5:
		GameData.inventory["seeds"] -=1
		dialogue_box.visible = true
		choice_box.visible = false
		choice_1.visible =false
		choice_2.visible = false
		await show_slow_text("You have planted your seed. It'll
		take a few days to grow.", true)
		interior_stage=6
		
func _on_choice_2_pressed() -> void:
	if interior_stage ==4:
		dialogue_box.visible = false
		choice_box.visible = false
	elif interior_stage==5:
		dialogue_box.visible = false
		choice_box.visible = false	
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
