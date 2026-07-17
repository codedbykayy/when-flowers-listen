extends Node2D
@onready var black_overlay = $UI/BlackOverlay
@onready var awakening_text = $UI/AwakeningText
@onready var dialogue_text = $UI/DialogueBox/DialogueText
@onready var name_input = $UI/NameInput
@onready var choice_background = $UI/DialogueBox/ChoiceBackground
@onready var choice1 = $UI/DialogueBox/Choice1
@onready var choice2 = $UI/DialogueBox/Choice2
@onready var choice3 = $UI/DialogueBox/Choice3
@onready var choice4 = $UI/DialogueBox/Choice4
@onready var continue_background = $UI/DialogueBox/ContinueBackground
@onready var continue_button = $UI/DialogueBox/ContinueButton
@onready var seed_choice_background = $UI/DialogueBox/SeedChoiceBackground
@onready var keep_seed_button = $UI/DialogueBox/KeepSeedButton
@onready var return_seed_button = $UI/DialogueBox/ReturnSeedButton
@onready var name_line = $UI/DialogueBox/NameLine
var flower_points = {
	"fern_points" : 0,
	"dandelion_points" : 0,
	"sunflower_points" : 0,
	"bluebell_points" : 0,
	"rose_points" : 0,
	"lily_points" : 0,
	"tulip_points" : 0,
	"poppy_points" : 0,
	"daisy_points" : 0,
	}
var skip_typing := false
var is_typing := false
var full_text = ""

var waiting_for_click := true
var dialogue_step = 0
var player_name = ""
func show_slow_text(new_text):
	$UI/DialogueBox/DialogueText.text = new_text
	$UI/DialogueBox/DialogueText.visible = true
	$UI/DialogueBox/DialogueText.visible_ratio = 0.0
	var typed = 0.0
	while typed < 1.0:
		typed+=0.02
		$UI/DialogueBox/DialogueText.visible_ratio = typed
		await get_tree().create_timer(0.05).timeout
	$UI/DialogueBox/DialogueText.visible_ratio = 1.0
var current_question = 1
var seed_revealed = false
var keep_seed_chosen = false
var ending_text_stage = 0
var returned_seed = false
		
	
	
func _ready() -> void:
	black_overlay.visible = true
	black_overlay.color = Color.BLACK
	black_overlay.position = Vector2.ZERO
	black_overlay.size = Vector2(1152,648)
	black_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	awakening_text.visible = true
	awakening_text.position = Vector2.ZERO
	awakening_text.size = Vector2(1152,648)
	awakening_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/DialogueBox.visible = false
	$UI/DialogueBox/ChoiceBackground.visible = false
	choice1.visible = false
	choice2.visible = false
	choice3.visible = false
	choice4.visible = false
	name_input.text_submitted.connect(_on_name_submitted)
	name_line.visible = false
	choice1.pressed.connect(_on_choice_pressed.bind(1))
	choice2.pressed.connect(_on_choice_pressed.bind(2))
	choice3.pressed.connect(_on_choice_pressed.bind(3))
	choice4.pressed.connect(_on_choice_pressed.bind(4))
	continue_button.text = "Continue..."
	continue_button.hide()
	continue_background.hide()
	continue_button.pressed.connect(_on_continue_button_pressed)
	seed_choice_background.visible = false
	keep_seed_button.visible = false
	return_seed_button.visible = false
	keep_seed_button.pressed.connect(_on_keep_seed_pressed)
	return_seed_button.pressed.connect(_on_return_seed_pressed)
	
	
func start_questionnaire(player_name):
	await show_slow_text("Now " +player_name+ ", which of these scenes 
	calls to your roots?")
	dialogue_text.visible_ratio = 1.0
	choice1.text = "A Lush, Lively Forest"
	choice2.text = "A Quiet Mountain Peak"
	choice3.text = "A Warm, Sunlit Beach"
	choice4.text = "A Large Bussling City"
	choice_background.visible = true
	choice1.visible = true
	choice2.visible = true
	choice3.visible = true
	choice4.visible = true
		
	
func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_typing:
			dialogue_text.visible_ratio = 1.0
			is_typing = false
			return
	if waiting_for_click and event is InputEventMouseButton and event.pressed:
		if ending_text_stage == 1:
			awakening_text.text = "The sun has begun to set. 
			Let's continue on our journey..."
			ending_text_stage = 2
			return
		if ending_text_stage ==2:
			get_tree().change_scene_to_file("res://destroyed_greenhouse_extreior_intro.tscn")
			return
		waiting_for_click = false
		awakening_text.visible = false
		black_overlay.color = Color.WHITE
		var tween = create_tween()
		tween.tween_property(black_overlay, "color:a", 0.0, 2.0)
		await tween.finished
		$UI/DialogueBox.visible = true
		await show_slow_text ("Ahh..Though my strength is depleted 
		and these eyes are weary.. The seeds 
		were jittery for your arrival and would
		 not let me rest.")
		dialogue_step = 1
		continue_background.show()
		continue_button.show()
	
	elif dialogue_step == 2 and event is InputEventMouseButton and event.pressed:
		continue_button.hide()
		continue_background.hide()
		await show_slow_text ("First..Lets get to know your name.")
		name_input.visible = true
		name_line.visible = true
		name_input.grab_focus()
		dialogue_step =3
func _on_name_submitted(new_text: String) -> void:
	if dialogue_step != 3:
		return
	player_name = new_text.strip_edges()
	GameData.player_name = player_name
	if player_name == "":
		return
	print ("Player name saved:", player_name)
	name_input.visible = false
	name_line.visible = false
	dialogue_text.text = "Ahh..." + player_name + ". A name with lineage."
	start_questionnaire(player_name)
	var typed:= 0.0
	while typed < 1.0:
		typed += 0.02
		dialogue_text.visible_ratio = typed
		await get_tree().create_timer(0.05).timeout
	dialogue_text.visible_ratio = 1.0

func _on_choice_pressed(choice_number):
	if current_question == 1: 
		if choice_number == 1:
			flower_points["fern_points"] += 4
			flower_points["dandelion_points"] += 3
			flower_points["bluebell_points"] +=2
			flower_points["sunflower_points"] +=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree senses a soul at peace 
			amongst the surrounding trees.")
		elif choice_number == 2:
			flower_points["poppy_points"] += 4
			flower_points["sunflower_points"] += 3
			flower_points["dandelion_points"] +=2
			flower_points["fern_points"] +=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree hears the quiet of 
			distant peaks within you.")
		elif choice_number == 3:
			flower_points["tulip_points"] += 4
			flower_points["lily_points"] += 3
			flower_points["daisy_points"] +=2
			flower_points["poppy_points"] +=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree warms beneath your 
			love of endless sunlight.")
		elif choice_number == 4:
			flower_points["rose_points"] += 4
			flower_points["poppy_points"] += 3
			flower_points["lily_points"] +=2
			flower_points["tulip_points"] +=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree senses a heart
			that blooms best amongst many.")
		continue_background.show()
		continue_button.show()
	elif current_question == 2:
		if choice_number ==1:
			flower_points["fern_points"] +=4
			flower_points["daisy_points"] +=3
			flower_points["dandelion_points"] +=2
			flower_points["rose_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree senses a connection 
			with the Earth's vitality.")
		elif choice_number ==2:
			flower_points["bluebell_points"] +=4
			flower_points["lily_points"] +=3
			flower_points["tulip_points"] +=2
			flower_points["daisy_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree hopes you 
			find the comfort you seek.")
		elif choice_number ==3:
			flower_points["sunflower_points"] +=4
			flower_points["dandelion_points"] +=3
			flower_points["daisy_points"] +=2
			flower_points["lily_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree feels the 
			warmth of your optimistic nature.")
		elif choice_number ==4:
			flower_points["rose_points"] +=4
			flower_points["poppy_points"] +=3
			flower_points["tulip_points"] +=2
			flower_points["lily_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree senses the 
			intensity of your passionate heart.")	
		continue_background.show()
		continue_button.show()
	elif current_question == 3:
		if choice_number ==1:
			flower_points["bluebell_points"] +=4
			flower_points["poppy_points"] +=3
			flower_points["fern_points"] +=2
			flower_points["lily_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree senses a peaceful,
			but lonely soul.")
		elif choice_number ==2:
			flower_points["tulip_points"] +=4
			flower_points["lily_points"] +=3
			flower_points["daisy_points"] +=2
			flower_points["fern_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree also delights
			in the comfort of a trusted companion.")
		elif choice_number ==3:
			flower_points["dandelion_points"] +=4
			flower_points["poppy_points"] +=3
			flower_points["sunflower_points"] +=2
			flower_points["daisy_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree likes that you
			thrive with kindred spirits.")
		elif choice_number ==4:
			flower_points["sunflower_points"] +=4
			flower_points["rose_points"] +=3
			flower_points["dandelion_points"] +=2
			flower_points["lily_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree celebrates
			your vibrant, social spirit.")	
	elif current_question == 4:
		if choice_number ==1:
			flower_points["daisy_points"] +=4
			flower_points["dandelion_points"] +=3
			flower_points["sunflower_points"] +=2
			flower_points["fern_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree hopes there are
			no cats nearby.")
		elif choice_number ==2:
			flower_points["fern_points"] +=4
			flower_points["bluebell_points"] +=3
			flower_points["daisy_points"] +=2
			flower_points["tulip_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree enjoys your 
			mindful reflections.")
		elif choice_number ==3:
			flower_points["rose_points"] +=4
			flower_points["sunflower_points"] +=3
			flower_points["dandelion_points"] +=2
			flower_points["poppy_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree perks up slightly 
			from your bursting enthusiam.")
		elif choice_number ==4:
			flower_points["tulip_points"] +=4
			flower_points["lily_points"] +=3
			flower_points["poppy_points"] +=2
			flower_points["rose_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree looks forward
			to what you can create here.")
	elif current_question == 5:
		if choice_number ==1:
			flower_points["daisy_points"] +=4
			flower_points["rose_points"] +=3
			flower_points["poppy_points"] +=2
			flower_points["dandelion_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree cheers for
			your new beginnings.")
		elif choice_number ==2:
			flower_points["poppy_points"] +=4
			flower_points["sunflower_points"] +=3
			flower_points["tulip_points"] +=2
			flower_points["rose_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree hopes to 
			see you bask with the flowers.")
		elif choice_number ==3:
			flower_points["lily_points"] +=4
			flower_points["bluebell_points"] +=3
			flower_points["fern_points"] +=2
			flower_points["daisy_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree appreciates
			your ability to find beauty
			in the changing leaves.")
		elif choice_number ==4:
			flower_points["bluebell_points"] +=4
			flower_points["lily_points"] +=3
			flower_points["daisy_points"] +=2
			flower_points["rose_points"]+=1
			$UI/DialogueBox/ChoiceBackground.visible = false
			choice1.visible = false
			choice2.visible = false
			choice3.visible = false
			choice4.visible = false
			await show_slow_text("The Ancient Tree values the 
			strength of your resilience.")
	continue_background.show()
	continue_button.show()
					
func start_questionnaire_2():
	current_question = 2
	await show_slow_text("What petal color calls to you most?")
	dialogue_text.visible_ratio = 1.0
	choice_background.visible = true
	choice1.visible = true
	choice2.visible = true
	choice3.visible = true
	choice4.visible = true
	choice1.text = "Deep Green"
	choice2.text = "Soothing Blue"
	choice3.text = "Radiant Yellow"
	choice4.text = "Passionate Pink"
	continue_button.hide()
	continue_background.hide()
func start_questionnaire_3():
	current_question = 3
	await show_slow_text("Where does your spirit bloom the most 
	freely?")
	dialogue_text.visible_ratio = 1.0
	choice_background.visible = true
	choice1.visible = true
	choice2.visible = true
	choice3.visible = true
	choice4.visible = true
	choice1.text = "In Peaceful Solitude."
	choice2.text = "Beside One Trusted Companion."
	choice3.text = "Amongst a Small Circle of Friends"
	choice4.text = "In the Center of a Lively Gathering."
	continue_button.hide()
	continue_background.hide()
func start_questionnaire_4():
	current_question = 4
	await show_slow_text("Which describes you best?")
	dialogue_text.visible_ratio = 1.0
	choice_background.visible = true
	choice1.visible = true
	choice2.visible = true
	choice3.visible = true
	choice4.visible = true
	choice1.text = "Curious and Observant."
	choice2.text = "Quiet and Thoughtful."
	choice3.text = "Happy and Outgoing"
	choice4.text = "Ambitious and Creative."
	continue_button.hide()
	continue_background.hide()
func start_questionnaire_5():
	current_question = 5
	await show_slow_text("Which season brings your heart to bloom?")
	dialogue_text.visible_ratio = 1.0
	choice_background.visible = true
	choice1.visible = true
	choice2.visible = true
	choice3.visible = true
	choice4.visible = true
	choice1.text = "Spring."
	choice2.text = "Summer."
	choice3.text = "Autumn"
	choice4.text = "Winter."
	continue_button.hide()
	continue_background.hide()
	
		
func _on_continue_button_pressed():
	print("Continue Clicked. Current Question is: ", current_question)
	if returned_seed:
		returned_seed = false
		continue_background.visible = false
		continue_button.visible = false
		current_question = 1
		for flower in flower_points:
			flower_points[flower] = 0
		start_questionnaire(player_name)
		return
	if keep_seed_chosen:
		keep_seed_chosen = false
		continue_background.visible = false
		continue_button.visible = false
		$UI/DialogueBox.visible = false
		black_overlay.color = Color.BLACK
		black_overlay.visible = true
		var tween = create_tween()
		tween.tween_property(black_overlay, "color:a", 1.0, 2.0)
		await tween.finished
		
		awakening_text.text = "After talking a long while, the Ancient Tree
		grows still. It's clear speaking no longer has a
		purpose here.."
		awakening_text.visible = true
		ending_text_stage = 1
		waiting_for_click = true
		return
	if seed_revealed:
		seed_revealed = false
		continue_background.visible = false
		continue_button.visible = false
		await show_slow_text("What will you do with your seed
		blessing, Flower Keeper " +player_name+ "?" )
		seed_choice_background.visible = true
		keep_seed_button.visible = true
		return_seed_button.visible = true
		return
	if dialogue_step ==1:
		continue_background.hide()
		continue_button.hide()
		await show_slow_text("Oh Yes.. This will be exciting..
		But before I can entrust one of my 
		children to you, we must first figure 
		out what kind of flower keeper you are.")
		continue_background.show()
		continue_button.show()
		dialogue_step = 2
	elif dialogue_step == 2:
		continue_button.hide()
		continue_background.hide()
		
	elif current_question == 1:
		continue_background.hide()
		continue_button.hide()
		current_question =2
		start_questionnaire_2()
	elif current_question == 2:
		continue_background.hide()
		continue_button.hide()
		current_question =3
		start_questionnaire_3()
	elif current_question == 3:
		continue_background.hide()
		continue_button.hide()
		current_question =4
		start_questionnaire_4()
	elif current_question == 4:
		continue_background.hide()
		continue_button.hide()
		current_question = 5
		start_questionnaire_5()
	elif current_question == 5:
		continue_background.hide()
		continue_button.hide()
		var winning_seed = get_winning_seed()
		GameData.chosen_seed = winning_seed
		await show_slow_text ("I've grown to learn your heart 
		well flower keeper...\n" +"The seed I bestow 
		upon you is: " + winning_seed.capitalize())
		seed_revealed = true
		continue_background.visible = true
		continue_button.visible = true
func get_winning_seed():
	print(flower_points)
	var tied_seeds = []
	var highest_points =-1
	for flower in flower_points:
		if flower_points[flower] > highest_points:
			highest_points = flower_points[flower]
			tied_seeds = [flower.trim_suffix("_points")]
	return tied_seeds.pick_random()	
func _on_keep_seed_pressed():
	seed_choice_background.visible = false
	keep_seed_button.visible = false
	return_seed_button.visible = false
	await show_slow_text("Hmm good.. I'm glad nature's spirits have 
	aligned with yours. Now then, lets chat a 
	little longer..It's sure been a while.")
	keep_seed_chosen = true
	continue_background.visible = true
	continue_button.visible	= true	
func _on_return_seed_pressed():
	returned_seed = false
	seed_choice_background.visible = false
	keep_seed_button.visible = false
	return_seed_button.visible = false
	await show_slow_text("You've returned your seed to the Earth...
	perhaps the Ancient Tree's senses were 
	off this time.")
	returned_seed = true
	continue_background.visible = true
	continue_button.visible = true
