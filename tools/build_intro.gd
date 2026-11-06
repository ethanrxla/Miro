extends SceneTree
## Run explicitly to regenerate the initial layout. The saved scene is editor-editable.
var level: Node2D
var areas: Node2D
var guards_node: Node2D

func _initialize() -> void:
	call_deferred("build")

func attach(node: Node, parent: Node, node_name: String) -> Node:
	node.name = node_name
	parent.add_child(node)
	node.owner = level
	return node

func solid(node_name: String, position: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = position
	attach(body, level, node_name)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	attach(shape, body, "CollisionShape2D")

func area(node_name: String, kind: String, position: Vector2, size: Vector2) -> void:
	var templates := {"cover": "cover_zone", "ladder": "ladder", "sigil": "sigil_anchor", "exit": "level_exit"}
	var node: Area2D
	if templates.has(kind):
		node = load("res://scenes/%s.tscn" % templates[kind]).instantiate()
	else:
		node = Area2D.new()
		node.set_script(load("res://scripts/intro_area.gd"))
		var collision := CollisionShape2D.new()
		collision.name = "CollisionShape2D"
		node.add_child(collision)
	node.kind = kind
	node.area_size = size
	node.position = position
	node.collision_layer = 0
	node.collision_mask = 2
	attach(node, areas, node_name)
	var rect := RectangleShape2D.new()
	rect.size = size
	node.get_node("CollisionShape2D").shape = rect
	if not templates.has(kind):
		node.get_node("CollisionShape2D").owner = level

func guard(node_name: String, position: Vector2, left: float, right: float, sick: bool = false) -> void:
	var node = load("res://scenes/guard.tscn").instantiate()
	node.position = position
	node.patrol_left = left
	node.patrol_right = right
	node.sick_guard = sick
	attach(node, guards_node, node_name)

func build() -> void:
	level = Node2D.new()
	level.name = "ThePrisoner"
	level.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	level.set_script(load("res://scripts/intro_level.gd"))
	var art := Node2D.new()
	art.set_script(load("res://scripts/prison_art.gd"))
	attach(art, level, "Architecture")
	var tileset := TileSet.new()
	tileset.tile_size = Vector2i(28, 28)
	tileset.add_physics_layer()
	tileset.set_physics_layer_collision_layer(0, 1)
	tileset.set_physics_layer_collision_mask(0, 6)
	var files := ["standard_tile", "cracked_tile", "connector"]
	for i in range(3):
		var atlas := TileSetAtlasSource.new()
		atlas.texture = load("res://assets/environment/%s.png" % files[i])
		atlas.texture_region_size = Vector2i(28, 27)
		atlas.create_tile(Vector2i.ZERO)
		tileset.add_source(atlas, i)
		var data := atlas.get_tile_data(Vector2i.ZERO, 0)
		data.set_collision_polygons_count(0, 1)
		data.set_collision_polygon_points(0, 0, PackedVector2Array([Vector2(-14, -14), Vector2(14, -14), Vector2(14, 14), Vector2(-14, 14)]))
	ResourceSaver.save(tileset, "res://assets/environment/prison_tiles.tres")
	var floor := TileMapLayer.new()
	floor.tile_set = tileset
	attach(floor, level, "StoneFloors")
	for x in range(1, 39):
		if x != 25 and x != 26:
			floor.set_cell(Vector2i(x, 9), 1 if x % 7 == 0 else (2 if x % 11 == 0 else 0), Vector2i.ZERO)
		if x >= 12:
			floor.set_cell(Vector2i(x, 16), 1 if x % 8 == 0 else 0, Vector2i.ZERO)
		floor.set_cell(Vector2i(x, 24), 1 if x % 9 == 0 else 0, Vector2i.ZERO)
	# Optional high shelves and broken stair variations above the patrol paths.
	for cell in [Vector2i(15, 8), Vector2i(16, 8), Vector2i(17, 7), Vector2i(18, 7), Vector2i(19, 7), Vector2i(20, 7), Vector2i(31, 14), Vector2i(32, 14), Vector2i(33, 13), Vector2i(34, 13), Vector2i(15, 22), Vector2i(16, 22), Vector2i(24, 15), Vector2i(23, 15), Vector2i(22, 14), Vector2i(21, 14), Vector2i(20, 14), Vector2i(19, 14), Vector2i(27, 23), Vector2i(26, 23), Vector2i(28, 22), Vector2i(29, 22), Vector2i(30, 22), Vector2i(31, 22)]:
		floor.set_cell(cell, 1 if cell.x % 3 == 0 else 0, Vector2i.ZERO)
	solid("LeftWall", Vector2(14, 378), Vector2(28, 756))
	solid("RightWall", Vector2(1106, 378), Vector2(28, 756))
	solid("CellDoor", Vector2(253, 196), Vector2(8, 112))
	areas = Node2D.new()
	attach(areas, level, "Interactables")
	area("Bed", "bed", Vector2(112, 239), Vector2(54, 30))
	area("CellLock", "door", Vector2(253, 220), Vector2(16, 64))
	area("CellShadow", "cover", Vector2(180, 216), Vector2(65, 72))
	area("FirstRefuge", "cover", Vector2(322, 216), Vector2(52, 72))
	area("GalleryShadow", "cover", Vector2(385, 216), Vector2(60, 72))
	area("StairShadow", "cover", Vector2(660, 216), Vector2(62, 72))
	area("FirstLadder", "ladder", Vector2(728, 335), Vector2(40, 230))
	area("LandingShadow", "cover", Vector2(780, 412), Vector2(65, 72))
	area("PassageShadow", "cover", Vector2(400, 412), Vector2(64, 72))
	area("SecondLadder", "ladder", Vector2(308, 550), Vector2(40, 252))
	area("LowerShadow", "cover", Vector2(740, 636), Vector2(70, 72))
	area("ExitShadow", "cover", Vector2(990, 636), Vector2(62, 72))
	area("SigilAnchor", "sigil", Vector2(620, 647), Vector2(30, 50))
	area("StairGate", "exit", Vector2(1043, 646), Vector2(46, 60))
	area("VoiceGate", "brother", Vector2(680, 226), Vector2(44, 55))
	area("QuarantineOrder", "note", Vector2(870, 425), Vector2(22, 30))
	guards_node = Node2D.new()
	attach(guards_node, level, "Guards")
	guard("CorruptKeeper", Vector2(280, 236), 280, 365, true)
	guard("GalleryKeeper", Vector2(580, 236), 550, 650)
	guard("PassageKeeper", Vector2(600, 432), 470, 680)
	guard("LowerKeeper", Vector2(855, 656), 810, 950)
	var player = load("res://scenes/intro_player.tscn").instantiate()
	player.position = Vector2(140, 236)
	attach(player, level, "Player")
	var packed := PackedScene.new()
	var result := packed.pack(level)
	if result != OK:
		push_error("Could not pack intro: %s" % result)
		quit(1)
		return
	result = ResourceSaver.save(packed, "res://scenes/intro.tscn")
	level.free()
	print("INTRO_BUILD_RESULT=", result)
	quit(0 if result == OK else 1)
