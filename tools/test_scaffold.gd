extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var level = load("res://scenes/intro.tscn").instantiate()
	# Moving a spawn marker in the editor must affect the real entry position.
	level.get_node("LevelPlan/PlayerSpawn").position = Vector2(155, 235)
	root.add_child(level)
	assert(level.player.position == Vector2(155, 235), "Spawn marker must drive entry")
	assert(level.get_node("LevelPlan").get_child_count() == 11, "Spawn plus ten level beats")
	assert(level.get_node("StoneFloors").tile_set.resource_path == "res://assets/environment/prison_tiles.tres", "Editable shared TileSet must be used by the level")
	for item in ["Bed", "CellLock", "VoiceGate", "QuarantineOrder"]:
		assert(not level.get_node("Interactables/" + item).scene_file_path.is_empty(), "Interactable must be reusable: " + item)
	var shadow = level.get_node("Interactables/CellShadow")
	var other = level.get_node("Interactables/GalleryShadow")
	var old_size: Vector2 = other.get_node("CollisionShape2D").shape.size
	shadow.area_size = Vector2(80, 90)
	assert(shadow.get_node("CollisionShape2D").shape.size == Vector2(80, 90), "Inspector size must update physics")
	assert(other.get_node("CollisionShape2D").shape.size == old_size, "Resizing one instance must not resize others")
	print("SCAFFOLD_RESULT: spawn, beats, shared tiles, reusable scenes and independent collision sizing passed")
	quit()
