extends Node
var inventory = {
	"wood": 0,
	"rocks": 0,
	"soil": 0,
	"nurture_powder": 0,
	"basic_pots": 0,
	"seeds": 0,
	"potting_soil": 0,
	"empty_watering_can": 0,
	"full_watering_can": 0,
	"basic_nurture_powder": 0
}
var player_name = ""
var chosen_seed = ""
var exterior_stage = 1
var interior_stage = 0
var pond_stage =0
var frog_watered=false
var rubble_cleared = {
	small_rubble = false,
	medium_rubble = false,
	large_rubble_front = false,
	large_rubble_left = false,
	tiny_rock_rubble = false,
	potting_soil = false,
	broken_large_shelf = false }
var current_day =1	
var has_watering_can = false
var watering_can_filled= false
var watering_can_water = 0.0
var campfire_lit = false
var dawn_dialogue_done= false
var seed_watered = false
var bird_event_seen = false
var has_nurture_powder= false
var first_sprout=false
var first_sprout_dialogue_seen=false
var save_path = "user://savegame.json"
func _ready() -> void:
	load_game()
func save_game():
	var data = {
		"player_name": player_name,
		"chosen_seed": chosen_seed,
		"inventory": inventory,
		"rubble_cleared": rubble_cleared,
		"current_day": current_day,
		"interior_stage": interior_stage,
		"exterior_stage": exterior_stage,
		"pond_stage": pond_stage,
		"campfire_lit": campfire_lit,
		"dawn_dialogue_done": dawn_dialogue_done,
		"has_watering_can": has_watering_can,
		"watering_can_water": watering_can_water,
		"seed_watered": seed_watered,
		"bird_event_seen":bird_event_seen,
		"has_nurture_powder": has_nurture_powder,
		"first_sprout":first_sprout,
		"first_sprout_dialogue_seen":first_sprout_dialogue_seen,
		"frog_watered":frog_watered
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
func load_game():
	if not FileAccess.file_exists(save_path):
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if data==null:
		return
	player_name	=data.get("player_name", player_name)
	chosen_seed	=data.get("chosen_seed", chosen_seed)
	inventory=	data.get("inventory", inventory)
	rubble_cleared=	data.get("rubble_cleared", rubble_cleared)
	current_day= data.get("current_day", current_day)
	interior_stage= data.get("interior_stage", interior_stage)
	exterior_stage=	 data.get("exterior_stage", exterior_stage)
	pond_stage = data.get("pond_stage", pond_stage)
	campfire_lit=	 data.get("campfire_lit", campfire_lit)
	dawn_dialogue_done=data.get	("dawn_dialogue_done", dawn_dialogue_done)
	has_watering_can=data.get	("has_watering_can", has_watering_can)
	watering_can_water=data.get	("watering_can_water", watering_can_water)
	seed_watered=data.get	("seed_watered", seed_watered)
	bird_event_seen=data.get	("bird_event_seen",bird_event_seen)
	has_nurture_powder=data.get	("has_nurture_powder", has_nurture_powder)
	frog_watered=data.get("frog_watered",frog_watered)
func show_slow_text(label, new_text:String):
	label.text = ""
	for letter in new_text:
		if not is_instance_valid(label):
			return
		label.text += letter
		await get_tree().create_timer(0.04).timeout
		
