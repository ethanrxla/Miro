extends "res://tools/test_ending.gd"

func run() -> void:
	await ending_setup()
	for time in [1.0, 6.5, 9.0, 11.5]:
		level.cinematic.elapsed = time
		await frames(2)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tmp/ending-%s.png" % str(time))
	quit()
