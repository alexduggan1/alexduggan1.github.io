extends RigidBody2D

var color
var screen_size
var speed = 150
var speed_default = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.scale = Vector2(0.375 * (screen_size.x / 1152), 0.375 * (screen_size.x / 1152))
	$CollisionShape2D.scale = Vector2(5 * 0.375 * (screen_size.x / 1152), 5 * 0.375 * (screen_size.x / 1152))
	speed = speed_default * (screen_size.x / 1152)
	position = get_viewport_rect().size / 2
	if(randi_range(0, 1) == 0):
		color = "red"
		linear_velocity = Vector2(speed, randf_range(-0.6, 0.6) * speed)
	else:
		color = "blue"
		linear_velocity = Vector2(-speed, randf_range(-0.6, 0.6) * speed)
	
	$AnimatedSprite2D.animation = color
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.animation = color

func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		print("collide")
		print(collision_info.get_collider().has_method("start"))
		if collision_info.get_collider().has_method("start"):
			print(collision_info.get_collider().player_num)
			if collision_info.get_collider().player_num == 1:
				color = "red"
			elif collision_info.get_collider().player_num == 2:
				color = "blue"



func checkForGoal():
	if position.x > screen_size.x:
		return 1
	if position.x < 0:
		return 2
	return 0
	pass


func _on_body_entered(body):
	if body.has_method("start"):
		if body.player_num == 1:
			color = "red"
		elif body.player_num == 2:
			color = "blue"
