extends "res://scripts/intro_level.gd"
## Playable blockout controller. Milestones stand in for unfinished set pieces.
var definition: Dictionary
var milestones: Dictionary = {}
var pending_milestone: String = ""

func _ready() -> void:
	definition = JSON.parse_string(FileAccess.get_file_as_string(get_meta("blueprint")))
	process_mode = Node.PROCESS_MODE_ALWAYS
	setup_inputs()
	player.level = self
	player.position = $LevelPlan/PlayerSpawn.position
	player.has_supplies = true
	player.c4_count = 1
	door_open = true
	brother_heard = true
	for guard in guards():
		guard.level = self
		guard.illness_started = true
	build_hud()
	start_dialogue([[definition.title.to_upper(), definition.opening], ["BLOCKOUT", "Explore this floor with the existing movement and stealth controls.\n[E] tests story/objective stations. Named placeholders mark unfinished systems."]])

func _process(delta: float) -> void:
	super._process(delta)
	if completed:
		overlay_label.text = "%s\n\nFloor scaffold complete.\n%s\n\n[R] Retry   [Enter] %s" % [definition.title.to_upper(), definition.closing, "Next scaffold" if definition.number < 5 else "Return to Level 1"]

func _unhandled_input(event: InputEvent) -> void:
	if completed and event.is_action_pressed("advance") and not event.is_echo():
		get_viewport().set_input_as_handled()
		get_tree().change_scene_to_file("res://scenes/levels/level_%02d.tscn" % (int(definition.number) + 1) if definition.number < 5 else "res://scenes/intro.tscn")
		return
	super._unhandled_input(event)

func objective() -> String:
	for station in definition.stations:
		if not milestones.has(station.id):
			return "%02d / %s\n%s" % [int(definition.number), definition.title.to_upper(), station.objective]
	return "%s\nReach the stair gate. [E]" % definition.title

func station_nearby() -> Dictionary:
	var nearest: Dictionary = {}
	var distance := 48.0
	for station in definition.stations:
		var node := areas.get_node(NodePath(station.id)) as Node2D
		var candidate := node.global_position.distance_to(player.global_position)
		if candidate < distance:
			nearest = station
			distance = candidate
	return nearest

func context_hint() -> String:
	if controls_locked() or player.is_dead:
		return ""
	var station := station_nearby()
	if not station.is_empty():
		return "Completed: " + station.title if milestones.has(station.id) else "[E] " + station.title
	if nearby("exit", 65):
		return "[E] Exit this scaffold once all objectives are complete"
	if in_cover(player.global_position):
		return "HIDDEN • stay still" if player.is_concealed else "[2] Blanket in shadow"
	if ladder_at(player.global_position):
		return "[W / S] Climb"
	return "A/D Move   Space Jump   C Dodge   1 Shank   2 Blanket   Esc Controls"

func interact() -> void:
	if controls_locked() or player.is_dead:
		return
	var station := station_nearby()
	if not station.is_empty():
		if milestones.has(station.id):
			notify("Already complete: " + station.title)
			return
		for required in station.requires:
			if not milestones.has(required):
				notify("First: " + str(required).replace("_", " "))
				return
		pending_milestone = station.id
		start_dialogue(station.lines, "milestone")
		return
	if nearby("exit", 65):
		if milestones.size() == definition.stations.size() and sigil_placed:
			completed = true
			player.velocity = Vector2.ZERO
		else:
			notify("Complete this floor's story stations and sigil before descending.")

func finish_dialogue() -> void:
	if dialogue_event == "milestone" and not pending_milestone.is_empty():
		milestones[pending_milestone] = true
		var node = areas.get_node(NodePath(pending_milestone))
		node.activated = true
		node.queue_redraw()
		if node.kind == "sigil":
			sigil_placed = true
			player.c4_count = maxi(0, player.c4_count - 1)
			make_noise(node.global_position, 220)
		pending_milestone = ""
	dialogue = []
	dialogue_index = 0
	dialogue_event = ""

func can_melee_reach(from: Vector2, to: Vector2) -> bool:
	return clear_sight(from, to)

func plant_c4() -> void:
	notify("This floor's charge is reserved for its sigil support. [E]")
