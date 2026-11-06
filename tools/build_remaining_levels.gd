extends "res://tools/build_intro.gd"
func _initialize() -> void:
	call_deferred("build_remaining")
func build_remaining() -> void:
	build_and_quit = false
	controller_path = "res://scripts/scaffold_level.gd"
	art_path = "res://scripts/scaffold_art.gd"
	DirAccess.make_dir_recursive_absolute("res://scenes/levels")
	for number in range(2, 6):
		blueprint_path = "res://data/levels/level_%02d.json" % number
		output_path = "res://scenes/levels/level_%02d.tscn" % number
		build()
	quit()
