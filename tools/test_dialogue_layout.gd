extends "res://tools/test_intro.gd"

func run() -> void:
	for number in range(1, 6):
		if is_instance_valid(level):
			level.queue_free()
			await frames(2)
		var path := "res://scenes/intro.tscn" if number == 1 else "res://scenes/levels/level_%02d.tscn" % number
		level = load(path).instantiate()
		root.add_child(level)
		current_scene = level
		await frames(3)
		var lines: Array = level.dialogue.duplicate(true)
		if number > 1:
			for station in level.definition.stations:
				lines.append_array(station.lines)
		var all_fit := true
		for line in lines:
			level.start_dialogue([line])
			await frames(2)
			var label: Label = level.dialogue_label
			var required_height := label.get_line_count() * label.get_line_height()
			var panel: Rect2 = level.dialogue_panel.get_global_rect()
			all_fit = all_fit and required_height <= label.size.y and panel.end.y <= 360
			all_fit = all_fit and label.get_global_rect().end.x <= level.speaker_portrait.get_global_rect().position.x
		check(all_fit, "Floor %d dialogue fits panel and leaves separate speaker column" % number)
	print("DIALOGUE_LAYOUT_RESULT: ", checks - failures.size(), "/", checks, " passed")
	quit(0 if failures.is_empty() else 1)
