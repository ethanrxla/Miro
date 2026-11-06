extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	var level = load("res://scenes/intro.tscn").instantiate()
	root.add_child(level)
	current_scene = level
	for i in range(15):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tmp/intro-dialogue.png")
	level.finish_dialogue()
	for i in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tmp/intro-cell.png")
	level.player.get_node("Camera2D").enabled = false
	var camera := Camera2D.new()
	camera.position = Vector2(560, 378)
	camera.zoom = Vector2(0.47, 0.47)
	level.add_child(camera)
	level.hud.visible = false
	for i in range(4):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tmp/intro-layout.png")
	camera.queue_free()
	level.player.get_node("Camera2D").enabled = true
	level.player.get_node("Camera2D").position_smoothing_enabled = false
	level.player.position = Vector2(620, 657)
	level.player.has_supplies = true
	level.player.c4_count = 1
	level.player.has_gun = true
	level.player.ammunition = 2
	level.door_open = true
	level.brother_heard = true
	level.hud.visible = true
	level.message_left = 0
	for i in range(5):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tmp/intro-lower.png")
	quit()
