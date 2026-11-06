extends BaseCharacter
## Movement-only workshop character; combat and stealth are not implemented yet.

const IDLE = preload("res://assets/characters/miro_idle.png")
const WALK = preload("res://assets/characters/miro_walk.png")
const JUMP = preload("res://assets/characters/miro_jump.png")
var animation_time: float = 0.0
var jump_was_down: bool = false
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	invulnerability_left = maxf(0.0, invulnerability_left - delta)
	var direction: float = float(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)) - float(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT))
	var jump_down: bool = Input.is_physical_key_pressed(KEY_SPACE)
	velocity.x = direction * movement_speed
	if not is_on_floor():
		velocity.y += 900.0 * delta
	elif jump_down and not jump_was_down:
		velocity.y = -330.0
	jump_was_down = jump_down
	move_and_slide()
	animation_time += delta
	sprite.hframes = 1
	sprite.texture = IDLE
	if not is_on_floor():
		sprite.texture = JUMP
	elif direction != 0.0:
		sprite.texture = WALK
		sprite.hframes = 2
		sprite.frame = int(animation_time * 8.0) % 2
	if direction != 0.0:
		sprite.flip_h = direction < 0.0
	if position.y > 400.0 or Input.is_physical_key_pressed(KEY_R):
		position = Vector2(100, 260)
		velocity = Vector2.ZERO
