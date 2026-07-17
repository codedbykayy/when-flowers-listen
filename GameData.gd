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
	"full_watering_can": 0
}
var player_name = ""
var chosen_seed = ""
var exterior_stage = 1
var interior_stage = 1
var pond_stage =0
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
var watering_can_filled = false
var campfire_lit = false
var dawn_dialogue_done= false
func show_slow_text(label, new_text:String):
	label.text = ""
	for letter in new_text:
		label.text += letter
		await get_tree().create_timer(0.04).timeout
func _ready() -> void:
	pass # Replace with function body.
