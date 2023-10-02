extends Node

@export var player_scene : PackedScene
@export var ball_scene : PackedScene


var round_mode = "not started"

var p1Score = 0
var p2Score = 0

var p1
var p2

var ball

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.show()

func pressed_start():
	$StartButton.hide()
	new_game()

func new_game():
	p1Score = 0
	p2Score = 0
	
	p1 = player_scene.instantiate()
	add_child(p1)
	p2 = player_scene.instantiate()
	add_child(p2)
	
	p1.start(Vector2(-350, 0), 1)
	p2.start(Vector2(350, 0), 2)
	
	$RoundTimer.start(3)
	round_mode = "countdown"

func game_over(winner):
	round_mode = "ended"
	p1.queue_free()
	p2.queue_free()
	
	$StartButton.show()

func start_round():
	ball = ball_scene.instantiate()
	add_child(ball)
	round_mode = "going"

func someone_score(who):
	if(who == 1): p1Score += 1
	if(who == 2): p2Score += 1
	ball.queue_free()
	
	if p1Score >= 5:
		game_over(2)
	elif p2Score >= 5:
		game_over(2)
	else:
		$RoundTimer.start(3)
		round_mode = "countdown"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/ScoreLabel.text = str(p1Score) + "   -   " + str(p2Score)
	if round_mode == "countdown":
		$HUD/TimerLabel.text = str(ceili($RoundTimer.time_left))
	else:
		$HUD/TimerLabel.text = " "
	
	if round_mode == "going":
		ball = get_node("Ball")
		var did_score = ball.checkForGoal()
		if did_score == 1:
			someone_score(1)
		elif did_score == 2:
			someone_score(2)

func _on_round_timer_timeout():
	start_round()
