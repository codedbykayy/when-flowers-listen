extends Node2D
@onready var dry_pond_scene = $DryPondScene
@onready var gone_pond_scene = $GonePondScene
@onready var full_pond_scene=$FullPondScene
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
@onready var frog_dying: AnimatedSprite2D =$FrogDying
@onready var frog_dying_area=$FrogDying/FrogDyingArea
@onready var frog_hop_away: AnimatedSprite2D =$FrogHopAway
@onready var frog_bush: AnimatedSprite2D =$FrogBush
@onready var frog_bush_area = $FrogBush/FrogBushArea
@onready var day_3_pond_intro_active:=false
@onready var frog_bush_target: Marker2D= $FrogBushTarget
@onready var frog_green:AnimatedSprite2D=$FrogGreen
@onready var hose_event=$HoseEvent
@onready var ui_box=$UiBoxMorningDaisy
@onready var close_arrow:Button=$UiBoxMorningDaisy/CloseArrow
@onready var hose_start: Marker2D=$HoseStart
@onready var hose_head_area:Area2D=$HoseHeadArea
@onready var hose_drop=$hosedrop
@onready var hose_line=$HoseHeadArea/Hoseline
@onready var small_rubble:Button=$HoseEvent/smallrubble
@onready var medium_rubble:Button=$HoseEvent/mediumrubble
@onready var hose_handle: Button = $HoseEvent/hosehandle
var hose_drag_offset:=Vector2.ZERO
var hose_placed:=false
var dragging_hose:=false
var bush_hint_dialogue_active:=false
var hose_intro_dialogue_active:=false
var hose_untangled_dialogue_active:=false
var hose_intro_seen:=false
var hose_drop_dialogue_active=false
var hose_drop_dialogue_seen:=false
var water_on:=false
func _ready() -> void:
	full_pond_scene.visible=false
	hose_line.visible=false
	hose_start.visible=false
	hose_head_area.visible=false
	frog_dying.visible=false
	frog_dying_area.visible=false
	frog_hop_away.visible=false
	frog_bush.visible=false
	frog_bush_area.visible=false
	if GameData.current_day==3 and GameData.frog_watered==false:
		frog_green.visible=false
		frog_dying.visible=true
		frog_dying.play("idle")
		frog_dying_area.input_pickable=false
		frog_dying_area.visible=true
		frog_hop_away.visible=false
		frog_bush.visible=false
		frog_bush_area.visible=false
		pond_area.visible=false
		home_button.visible = false
		gone_pond_scene.visible= true
		dry_pond_scene.visible = false
		day_3_pond_intro_active=true
		dialogue_box.visible=true
		await show_slow_text("Oh no! We must've drained the last 
		bit of water the little guy was using.",true)
		continue_sprite.visible=true
		continue_button.visible=true
		return
	elif GameData.current_day==3 and GameData.frog_watered==true:
		frog_dying.visible	=false
		home_button.visible=false
		day_3_pond_intro_active=false
		frog_dying_area.visible=false
		frog_hop_away.visible=false
		frog_bush.visible=true
		frog_bush.play("idle")
		frog_bush_area.input_pickable=true
		frog_bush_area.visible=true
		frog_green.visible=false
		return
	GameData.dawn_dialogue_done=true
	GameData.exterior_stage=6
	if GameData.pond_stage ==0:
		pond_area.visible=true
		home_button.visible = true
		gone_pond_scene.visible= false
		dry_pond_scene.visible = true
		return
	GameData.exterior_stage=5
	if GameData.pond_stage==3:
		dry_pond_scene.visible = false
		gone_pond_scene.visible= true
		return
	
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
	if bush_hint_dialogue_active:
		bush_hint_dialogue_active=false
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		frog_bush_area.input_pickable=true
	if hose_intro_dialogue_active:
		hose_intro_dialogue_active=false
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		close_arrow.mouse_filter = Control.MOUSE_FILTER_STOP
		small_rubble.mouse_filter = Control.MOUSE_FILTER_STOP
		medium_rubble.mouse_filter = Control.MOUSE_FILTER_STOP
		return
	if hose_untangled_dialogue_active:
		close_arrow.mouse_filter = Control.MOUSE_FILTER_STOP
		hose_untangled_dialogue_active=false
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		return
	if hose_drop_dialogue_active:
		hose_drop_dialogue_active=false
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		hose_handle.mouse_filter=Control.MOUSE_FILTER_STOP
		frog_bush_area.input_pickable=true
		return
	if water_on:
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		home_button.visible=true
		
	if GameData.current_day==3 and day_3_pond_intro_active:
		day_3_pond_intro_active=false
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		frog_dying_area.input_pickable=true
		return
	if GameData.pond_stage ==1:
		dialogue_box.visible = false
		continue_button.visible = false
		continue_sprite.visible=false
		dry_pond_scene.visible=true
		GameData.pond_stage=0
		return
	elif GameData.pond_stage==2:
		continue_button.visible=false
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
	elif GameData.pond_stage==5:
		day_3_pond_intro_active=false
		dialogue_box.visible=false
		continue_button.visible=false
		continue_sprite.visible=false
		frog_dying_area.input_pickable=true
	elif GameData.pond_stage==6:
		frog_dying_area.input_pickable = false
		dialogue_box.visible=true
		await show_slow_text("Would you like to use the last 
		bit of water from our can?",false)
		choice_box.visible=true
		choice_1.visible=true
		choice_2.visible=true
		choice_1.text="Pour water on the frog."
		choice_2.text="Do nothing."	
func _on_choice_1_pressed() -> void:
	if GameData.pond_stage==3:
		choice_box.visible = false
		dry_pond_scene.visible=false
		gone_pond_scene.visible=true
		continue_button.visible=false
		continue_sprite.visible=false
		GameData.inventory["empty_watering_can"]-=1
		GameData.inventory["full_watering_can"]+=1
		await show_slow_text("Your watering can is full now!
		The pond doesnt seem to be doing
		good.. But let's make sure our 
		seed is.", true)
		GameData.watering_can_water =1.0
		GameData.watering_can_filled= true
		continue_sprite.visible=true
		continue_button.visible=true
		pond_area.visible=false
		GameData.pond_stage = 4
		GameData.save_game()
	elif GameData.pond_stage==6:
		choice_box.visible=false
		choice_1.visible=false
		choice_2.visible=false
		dialogue_box.visible=false
		dialogue_text.visible=false
		frog_dying.play("flipping")
		await frog_dying.animation_finished
		frog_hop_away.global_position=frog_dying.global_position
		frog_dying.visible=false
		frog_hop_away.visible=true
		frog_hop_away.play("hopaway")
		var frog_tween:= create_tween()
		frog_tween.tween_property(
			frog_hop_away,
			"global_position",
			frog_bush_target.global_position,
			5.0
			)
		await frog_tween.finished
		frog_hop_away.stop()
		frog_hop_away.visible=false
		frog_green.visible=true
		frog_green.play("green")
		await frog_green.animation_finished
		frog_green.visible=false
		await get_tree().create_timer(2.0).timeout
		frog_bush.visible=true
		frog_bush.play("idle")
		frog_bush_area.visible=true
		frog_bush_area.input_pickable=false
		GameData.frog_watered=true
		await get_tree().create_timer(2.0).timeout
		GameData.pond_stage=7
		GameData.save_game()
		bush_hint_dialogue_active=true
		dialogue_box.visible=true
		await show_slow_text("Hmm, seems he's trying
		to show us something.", true)
		continue_sprite.visible=true
		continue_button.visible=true
		
		return


func _on_frog_dying_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		frog_dying_area.input_pickable = false
		dialogue_box.visible=true
		await show_slow_text("R..Rib...Can't..reach..water.....",true)
		continue_sprite.visible=true
		continue_button.visible=true
		GameData.pond_stage=6


func _on_frog_bush_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index== MOUSE_BUTTON_LEFT and event.pressed:
		ui_box.visible=true
		hose_event.visible=true
		if not hose_intro_seen:
			hose_intro_seen=true
			hose_intro_dialogue_active=true
			dialogue_box.visible=true
			close_arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
			await show_slow_text("Aww, he's showing us the hose.
			It seems a bit tangled and buried though.", true)
			continue_sprite.visible = true
			continue_button.visible=true
func _on_close_arrow_pressed() -> void:
	ui_box.visible=false
	hose_event.visible=false
	if water_on:
		gone_pond_scene.visible=false
		dry_pond_scene.visible=true
		full_pond_scene.visible=false
		await get_tree().create_timer(2.0).timeout
		dry_pond_scene.visible=false
		full_pond_scene.visible=true
		dialogue_box.visible=true
		await show_slow_text("WOW! that should surely be
		enough water for us all to share.", true)
		continue_button.visible=true
		continue_sprite.visible=true
		
func _on_hose_head_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging_hose=true
			hose_drag_offset=(
				hose_head_area.global_position
				- get_global_mouse_position()
			)
		else:
			dragging_hose=false
func _process(delta:float):
	if dragging_hose and not hose_placed:
		hose_head_area.global_position=(
			get_global_mouse_position() + hose_drag_offset)
		var start := hose_start.global_position
		var end:=hose_head_area.global_position
		var direction:= end-start
		var distance := direction.length()
		hose_line.global_position=(start+end)/2.0
		hose_line.rotation=direction.angle()-PI/2.0
		hose_line.scale.y=distance/hose_line.texture.get_height()


func _on_hose_event_hose_untangled() -> void:
	hose_head_area.visible=true
	hose_line.visible=true
	hose_untangled_dialogue_active=true
	dialogue_box.visible=true
	close_arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await show_slow_text("Good work, " + GameData.player_name + "! It look's to
	still be in good condition. Let's see
	if it'll reach the pond.", true)
	continue_sprite.visible=true
	continue_button.visible=true
func _unhandled_input(event:InputEvent):
	if event is InputEventMouseButton\
	and not event.pressed:
		if not hose_placed and hose_head_area.overlaps_area(hose_drop):
			hose_placed=true
			hose_head_area.global_position=hose_drop.global_position
			hose_drop_dialogue_active=true
			dialogue_box.visible=true
			frog_bush_area.input_pickable=false
			await show_slow_text("We need to get the water on
			now, hopefully the hose handle 
			still works.", true)
			continue_button.visible=true
			continue_sprite.visible=true
		dragging_hose=false


func _on_hose_event_water_on() -> void:
	water_on=true
