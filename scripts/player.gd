extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var has_double_jumped = false
@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump + Double Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
			has_double_jumped = false
		elif not has_double_jumped:
			velocity.y = JUMP_VELOCITY
			anim.play("double_jump")
			has_double_jumped = true

	# Movement
	var direction := 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1

	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Animations
	if is_on_floor():
		if direction != 0:
			anim.play("run")
		else:
			anim.play("idle")
	else:
		if velocity.y < 0:
			anim.play("double_jump" if has_double_jumped else "jump")
		else:
			anim.play("fall")
