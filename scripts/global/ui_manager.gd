extends Node

@onready var ui_group: Array[Node] = get_tree().get_nodes_in_group('ui')
var dialogue_menu: Control
var pause_menu: Control
var interact_prompt: Control
var player_reticle: Control
var item_use_menu: Control
var items_tooltip: Control
var active_quests: Control
var read_container: Control

var _tweens: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.game_paused.connect(show_pause_menu)
	
	show_pause_menu(false)
	show_dialogue_menu(false)
	
	dialogue_menu = ArrayUtilities.find_in_group(ui_group, 'DialoguesUI')
	pause_menu = ArrayUtilities.find_in_group(ui_group, 'PauseUI')
	interact_prompt = ArrayUtilities.find_in_group(ui_group, 'InteractPrompt')
	player_reticle = ArrayUtilities.find_in_group(ui_group, 'PlayerReticle')
	item_use_menu = ArrayUtilities.find_in_group(ui_group, 'ItemUseMenu')
	items_tooltip = ArrayUtilities.find_in_group(ui_group, 'ItemsTooltip')
	active_quests = ArrayUtilities.find_in_group(ui_group, 'ActiveQuests')
	read_container = ArrayUtilities.find_in_group(ui_group, 'ReadContainer')


func show_pause_menu(flag: bool):
	if flag:
		fade_in_panel(pause_menu)
	else:
		fade_out_panel(pause_menu)


func show_dialogue_menu(flag: bool):
	if flag:
		fade_in_panel(dialogue_menu)
		show_reticle(false)
		show_prompt(false)
	else:
		fade_out_panel(dialogue_menu)
		show_reticle(true)
		show_prompt(true)


func show_prompt(flag: bool):
	if flag:
		fade_in_panel(interact_prompt)
	else:
		fade_out_panel(interact_prompt)


func show_item_use_menu(flag: bool):
	if flag:
		fade_in_panel(item_use_menu)
		show_reticle(false)
		show_prompt(false)
	else:
		fade_out_panel(item_use_menu)
		show_reticle(true)
		show_prompt(true)


func show_items_tooltip(flag: bool):
	if flag:
		fade_in_panel(items_tooltip)
	else:
		fade_out_panel(items_tooltip)


func show_active_quests(flag: bool):
	if flag:
		fade_in_panel(active_quests)
	else:
		fade_out_panel(active_quests)


func show_reticle(flag: bool):
	if flag:
		fade_in_panel(player_reticle)
	else:
		fade_out_panel(player_reticle)


func show_read_container(flag: bool):
	if flag:
		fade_in_panel(read_container)
		show_reticle(false)
		show_prompt(false)
	else:
		fade_out_panel(read_container)
		show_reticle(true)
		show_prompt(true)


func _fade(panel: Control, target_alpha: float, hide_at_end: bool) -> void:
	if not is_instance_valid(panel):
		return
	if _tweens.has(panel) and _tweens[panel].is_valid():
		_tweens[panel].kill()

	panel.visible = true
	var tween := create_tween()
	_tweens[panel] = tween
	tween.tween_property(panel, "modulate:a", target_alpha, 0.1)
	if hide_at_end:
		tween.tween_callback(func(): panel.visible = false)


func fade_in_panel(panel: Control) -> void:
	_fade(panel, 1.0, false)


func fade_out_panel(panel: Control) -> void:
	_fade(panel, 0.0, true)
