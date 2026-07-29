extends Node2D
signal hose_untangled
signal water_on
@onready var hose_short=$UnderhoseShort
@onready var hose_long=$UnderhoseLong
@onready var knot_1=$Knot1
@onready var knot_2=$Knot2
@onready var knot_3=$Knot3
@onready var medium_rubble=$mediumrubble
@onready var small_rubble=$smallrubble
@onready var hose_handle=$hosehandle
@onready var handle_flipped=$HoseHandleFlipped
var knots_cleared=0
var rubble_cleared=0
func _ready() -> void:
	small_rubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	medium_rubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hose_handle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hose_short.visible=true
	if rubble_cleared==0:
		knot_1.mouse_filter = Control.MOUSE_FILTER_IGNORE
		knot_2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		knot_3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif rubble_cleared==2:
		knot_1.mouse_filter = Control.MOUSE_FILTER_STOP
		knot_2.mouse_filter = Control.MOUSE_FILTER_STOP
		knot_3.mouse_filter = Control.MOUSE_FILTER_STOP
func _on_knot_1_pressed() -> void:
	knots_cleared+=1
	if knots_cleared>=1:
		hose_short.visible=false
		hose_long.visible=true
	knot_1.queue_free()
	if knots_cleared==3:
		print("jumping frog animation will play here")
		hose_untangled.emit()
func _on_knot_2_pressed() -> void:
	knots_cleared+=1
	if knots_cleared>=1:
		hose_short.visible=false
		hose_long.visible=true
	knot_2.queue_free()
	if knots_cleared==3:
		print("jumping frog animation will play here")
		hose_untangled.emit()
func _on_knot_3_pressed() -> void:
	knots_cleared+=1
	if knots_cleared>=1:
		hose_short.visible=false
		hose_long.visible=true
	knot_3.queue_free()
	if knots_cleared==3:
		print("frog hops")
		hose_untangled.emit()
func _on_mediumrubble_pressed() -> void:
	rubble_cleared+=1
	GameData.inventory["wood"]+=2
	GameData.inventory["rocks"]+=2
	if rubble_cleared==2:
		knot_1.mouse_filter = Control.MOUSE_FILTER_STOP
		knot_2.mouse_filter = Control.MOUSE_FILTER_STOP
		knot_3.mouse_filter = Control.MOUSE_FILTER_STOP
	print(GameData.inventory)
	medium_rubble.queue_free()
func _on_smallrubble_pressed() -> void:
	rubble_cleared+=1
	GameData.inventory["wood"]+=1
	GameData.inventory["rocks"]+=1
	if rubble_cleared==2:
		knot_1.mouse_filter = Control.MOUSE_FILTER_STOP
		knot_2.mouse_filter = Control.MOUSE_FILTER_STOP
		knot_3.mouse_filter = Control.MOUSE_FILTER_STOP
	print(GameData.inventory)
	small_rubble.queue_free()


func _on_hosehandle_pressed() -> void:
	hose_handle.visible=false
	handle_flipped.visible=true
	hose_handle.queue_free()
	water_on.emit()
