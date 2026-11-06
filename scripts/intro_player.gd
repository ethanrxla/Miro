class_name IntroPlayer
extends BaseCharacter

var level: Node2D
var facing: float = 1.0
var is_concealed: bool = false
var casualty_count: int = 0
var detection_state: String = "unseen"
var has_supplies: bool = false
var has_key: bool = false
var has_gun: bool = false
var ammunition: int = 0
var c4_count: int = 0
var attack_cooldown: float = 0.0
var dodge_left: float = 0.0
var dodge_cooldown: float = 0.0
var animation_time: float = 0.0
var climbing: bool = false
var attack_flash: float = 0.0
const IDLE = preload("res://assets/characters/miro_idle.png")
const WALK = preload("res://assets/characters/miro_walk.png")
const JUMP = preload("res://assets/characters/miro_jump.png")
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")
	movement_speed = 115.0

func _physics_process(delta: float) -> void:
	if not is_instance_valid(level):
		return
	invulnerability_left = maxf(0.0, invulnerability_left - delta)
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	dodge_cooldown = maxf(0.0, dodge_cooldown - delta)
	dodge_left = maxf(0.0, dodge_left - delta)
	attack_flash = maxf(0.0, attack_flash - delta)
	if level.controls_locked() or is_dead:
		velocity = Vector2.ZERO
		update_visual(delta)
		return
	var direction := Input.get_axis("move_left", "move_right")
	var vertical := Input.get_axis("climb_up", "climb_down")
	var ladder = level.ladder_at(global_position)
	if ladder == null:
		climbing = false
	elif vertical != 0.0:
		climbing = true
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or climbing:
			velocity.y = -290.0
			climbing = false
		is_concealed = false
	if direction != 0.0 or vertical != 0.0:
		is_concealed = false
	if direction != 0.0:
		facing = direction
	if Input.is_action_just_pressed("dodge") and dodge_cooldown <= 0.0:
		dodge_left = 0.22
		dodge_cooldown = 0.85
		is_concealed = false
	velocity.x = direction * movement_speed
	if dodge_left > 0.0:
		velocity.x = facing * 245.0
	if climbing:
		velocity.y = vertical * 85.0
		if direction == 0.0:
			global_position.x = move_toward(global_position.x, ladder.global_position.x, delta * 120.0)
	else:
		velocity.y += 850.0 * delta
	move_and_slide()
	if is_concealed and not level.in_cover(global_position):
		is_concealed = false
	if Input.is_action_just_pressed("cloak"):
		toggle_stealth()
	if Input.is_action_just_pressed("attack"):
		shank()
	if Input.is_action_just_pressed("explosive"):
		level.plant_c4()
	if Input.is_action_just_pressed("fire"):
		fire_gun()
	if global_position.y > 800:
		die()
	update_visual(delta)

func toggle_stealth() -> void:
	if not has_supplies:
		level.notify("Your blanket is on the bed. Search it with E.")
	elif level.in_cover(global_position) and is_on_floor():
		is_concealed = not is_concealed
		level.notify("Still. Let the shadows swallow you." if is_concealed else "You leave concealment.")
	else:
		level.notify("Find a marked shadow alcove, stand still, then press 2.")

func shank() -> void:
	if not has_supplies:
		level.notify("Search beneath the bed first. [E]")
		return
	if attack_cooldown > 0.0:
		return
	is_concealed = false
	attack_cooldown = 0.5
	attack_flash = 0.16
	for guard in level.guards():
		var difference: Vector2 = guard.global_position - global_position
		if not guard.is_dead and absf(difference.y) < 24 and absf(difference.x) <= 46 and difference.x * facing >= -5:
			if level.can_melee_reach(global_position, guard.global_position):
				guard.receive_shank()
				break

func fire_gun() -> void:
	if not has_gun or ammunition <= 0:
		level.notify("No loaded weapon. A fallen Keeper may carry one.")
		return
	if attack_cooldown > 0:
		return
	ammunition -= 1
	attack_cooldown = 0.65
	attack_flash = 0.2
	is_concealed = false
	level.make_noise(global_position, 600.0)
	for guard in level.guards():
		var difference: Vector2 = guard.global_position - global_position
		if not guard.is_dead and absf(difference.y) < 22 and difference.x * facing > 0 and difference.length() < 320 and level.clear_sight(global_position, guard.global_position):
			if guard.has_method("begin_recovery"):
				guard.take_damage(1)
			else:
				guard.health = 0
				guard.die()
			break

func take_damage(amount: int) -> void:
	if dodge_left > 0:
		return
	super.take_damage(amount)
	is_concealed = false

func die() -> void:
	if is_dead:
		return
	super.die()
	level.notify("The tower keeps its prisoners. Press R to retry.", 20.0)

func update_visual(delta: float) -> void:
	animation_time += delta
	sprite.hframes = 1
	sprite.texture = IDLE
	if not is_on_floor() and not climbing:
		sprite.texture = JUMP
	elif absf(velocity.x) > 1:
		sprite.texture = WALK
		sprite.hframes = 2
		sprite.frame = int(animation_time * 8) % 2
	sprite.flip_h = facing < 0
	sprite.modulate = Color("8b6d9c") if is_concealed else Color.WHITE
	sprite.modulate.a = 0.42 if is_concealed else (0.5 if invulnerability_left > 0 and int(animation_time * 20) % 2 == 0 else 1.0)
	sprite.rotation = PI / 2 if is_dead else 0.0
	queue_redraw()

func _draw() -> void:
	if attack_flash > 0:
		draw_line(Vector2(facing * 9, -2), Vector2(facing * 35, -7), Color("fbf5ef"), 2)
	if is_concealed:
		draw_arc(Vector2(0, -20), 5, 0, PI, 8, Color("c69fa5"), 1)
