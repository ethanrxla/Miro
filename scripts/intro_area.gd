@tool
class_name IntroArea
extends Area2D

@export_enum("bed", "door", "cover", "ladder", "sigil", "exit", "brother", "note") var kind: String = "cover"
@export var area_size := Vector2(60, 60)
var activated: bool = false

func contains(point: Vector2) -> bool:
	return Rect2(global_position - area_size / 2, area_size).has_point(point)

func _draw() -> void:
	var pale := Color("f2d3ab")
	var pink := Color("c69fa5")
	var purple := Color("8b6d9c")
	var dark := Color("272744")
	match kind:
		"bed":
			draw_rect(Rect2(-25, -8, 50, 8), purple)
			draw_rect(Rect2(-22, -14, 12, 6), pale)
			draw_rect(Rect2(-9, -13, 31, 7), Color("494d7e"))
			for x in [-24, 20]:
				draw_rect(Rect2(x, -4, 4, 17), pink)
			if not activated:
				draw_rect(Rect2(-9, 3, 16, 7), dark)
				draw_line(Vector2(-5, 5), Vector2(3, 5), pale, 1)
		"door":
			if not activated:
				for x in [-5, 4]:
					draw_rect(Rect2(x, -area_size.y / 2, 3, area_size.y), purple)
				draw_rect(Rect2(-7, -2, 15, 9), pale)
				draw_circle(Vector2(1, 2), 2, dark)
		"cover":
			draw_rect(Rect2(-area_size / 2, area_size), Color(0.08, 0.08, 0.15, 0.65))
			draw_arc(Vector2(0, -area_size.y / 2 + 13), 5, 0, PI * 1.7, 12, purple, 1)
			draw_line(Vector2(-area_size.x / 2, area_size.y / 2), Vector2(area_size.x / 2, area_size.y / 2), purple, 1)
		"ladder":
			for x in [-9, 9]:
				draw_rect(Rect2(x, -area_size.y / 2, 2, area_size.y), purple)
			for y in range(int(-area_size.y / 2), int(area_size.y / 2), 10):
				draw_line(Vector2(-8, y), Vector2(9, y), pink, 2)
		"sigil":
			draw_rect(Rect2(-13, -20, 26, 42), dark)
			draw_rect(Rect2(-11, -18, 22, 38), purple, false, 2)
			var color := pale if activated else pink
			draw_polyline(PackedVector2Array([Vector2(-7, 6), Vector2(0, -9), Vector2(7, 6), Vector2(-7, 6)]), color, 2)
			draw_line(Vector2(0, -12), Vector2(0, 13), color, 2)
		"exit", "brother":
			draw_rect(Rect2(-22, -50, 44, 76), dark)
			draw_rect(Rect2(-25, -53, 50, 79), purple, false, 3)
			for x in range(-16, 20, 8):
				draw_line(Vector2(x, -49), Vector2(x, 24), pink, 2)
			if kind == "exit":
				draw_polyline(PackedVector2Array([Vector2(-8, -12), Vector2(0, -4), Vector2(8, -12)]), pale, 2)
		"note":
			draw_rect(Rect2(-7, -9, 14, 18), pale)
			for y in [-5, 0, 5]:
				draw_line(Vector2(-4, y), Vector2(4, y), purple, 1)
