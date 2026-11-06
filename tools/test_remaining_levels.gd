extends "res://tools/test_intro.gd"

func run() -> void:
	for number in range(2, 6):
		if is_instance_valid(level):
			level.queue_free()
			await frames(2)
		level = load("res://scenes/levels/level_%02d.tscn" % number).instantiate()
		root.add_child(level)
		current_scene = level
		await frames(3)
		level.finish_dialogue()
		var definition: Dictionary = level.definition
		check(definition.sources.size() >= 5, "Level %d has per-document references" % number)
		for source in definition.sources:
			check(FileAccess.file_exists("res://" + source.path), "Source exists: " + source.path)
		for station in definition.stations:
			var point := Vector2(station.position[0], station.position[1])
			if point.y > 300 and level.player.position.y < 300:
				var ladder = level.get_node("Interactables/FirstLadder")
				check(await move_to(ladder.position.x, 800, true), "Level %d reaches first ladder" % number)
				Input.action_press("climb_down")
				await frames(170)
				Input.action_release("climb_down")
				check(level.player.position.y > 410, "Level %d descends first tier" % number)
			if point.y > 600 and level.player.position.y < 600:
				check(await move_to(308, 800, true), "Level %d reaches second ladder" % number)
				Input.action_press("climb_down")
				await frames(190)
				Input.action_release("climb_down")
				check(level.player.position.y > 640, "Level %d reaches lower tier" % number)
			check(await move_to(point.x, 800, true), "Reach " + station.id)
			await frames(10)
			level.interact()
			check(not level.dialogue.is_empty(), "Open " + station.id)
			level.finish_dialogue()
			check(level.milestones.has(station.id), "Complete/skip " + station.id)
			var charges: int = level.player.c4_count
			level.interact()
			check(level.dialogue.is_empty() and level.player.c4_count == charges, "No duplicate " + station.id)
		check(level.sigil_placed, "Level %d requires its own sigil" % number)
		check(await move_to(1030, 800, true), "Level %d reaches exit" % number)
		level.interact()
		check(level.completed and not level.player.is_dead, "Level %d scaffold traversed alive" % number)
	print("REMAINING_LEVELS_RESULT: ", checks - failures.size(), "/", checks, " passed")
	quit(0 if failures.is_empty() else 1)
