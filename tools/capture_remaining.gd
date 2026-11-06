extends SceneTree

func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	DirAccess.make_dir_recursive_absolute("res://tmp")
	for number in range(2, 6):
		var level = load("res://scenes/levels/level_%02d.tscn" % number).instantiate()
		root.add_child(level)
		current_scene = level
		for frame in range(10):
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tmp/level-%02d-dialogue.png" % number)
		level.finish_dialogue()
		level.player.get_node("Camera2D").enabled = false
		var camera := Camera2D.new()
		camera.position = Vector2(560, 378)
		camera.zoom = Vector2(0.47, 0.47)
		level.add_child(camera)
		level.hud.visible = false
		for frame in range(4):
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tmp/level-%02d-layout.png" % number)
		if number == 5:
			camera.queue_free()
			level.player.get_node("Camera2D").enabled = true
			level.player.get_node("Camera2D").position_smoothing_enabled = false
			level.player.position = Vector2(650, 432)
			level.milestones["FinalSigil"] = true
			level.milestones["FinalOffer"] = true
			level.hud.visible = true
			level.interact()
			for frame in range(10):
				await process_frame
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://tmp/brother-telegraph.png")
		level.queue_free()
		await process_frame
	quit()
