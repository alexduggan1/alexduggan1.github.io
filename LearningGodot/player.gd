extends RigidBody2D


@export var speed = 400
var player_num
var screen_size

var can_attack = true
var attacking = false
var attack_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.scale = Vector2(0.5 * (screen_size.x / 1152), 0.5 * (screen_size.x / 1152))
	$CollisionShape2D.scale = Vector2(5 * 0.5 * (screen_size.x / 1152), 5 * 0.5 * (screen_size.x / 1152))
	speed = speed * (screen_size.x / 1152)
	hide()

func start(pos, num):
	position = (get_viewport_rect().size / 2) + pos
	player_num = num
	can_attack = true
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movedir = Vector2.ZERO
	var attack = false
	if player_num == 1:
		$AnimatedSprite2D.play("red")
		if Input.is_action_pressed("P1MoveRight"):
			movedir.x += 1
		if Input.is_action_pressed("P1MoveLeft"):
			movedir.x -= 1
		if Input.is_action_pressed("P1MoveDown"):
			movedir.y += 1
		if Input.is_action_pressed("P1MoveUp"):
			movedir.y -= 1
		if Input.is_action_pressed("P1Attack"):
			attack = true
	elif player_num == 2:
		$AnimatedSprite2D.play("blue")
		if Input.is_action_pressed("P2MoveRight"):
			movedir.x += 1
		if Input.is_action_pressed("P2MoveLeft"):
			movedir.x -= 1
		if Input.is_action_pressed("P2MoveDown"):
			movedir.y += 1
		if Input.is_action_pressed("P2MoveUp"):
			movedir.y -= 1
		if Input.is_action_pressed("P2Attack"):
			attack = true
	
	if (movedir.length() > 0):
		movedir = movedir.normalized() * speed
	linear_velocity += movedir / 5
	if(linear_velocity.length() > speed):
		linear_velocity = linear_velocity.normalized() * speed
	else:
		linear_velocity *= 0.9
	if (can_attack):
		if (attack):
			attack_pos = position + linear_velocity.normalized() * speed * 0.3
			attacking = true
			can_attack = false
			$AttackCooldown.start(0.75)



func _integrate_forces(state):
	if attacking:
		state.transform.origin = attack_pos
		attacking = false

func _on_attack_cooldown_timeout():
	can_attack = true
