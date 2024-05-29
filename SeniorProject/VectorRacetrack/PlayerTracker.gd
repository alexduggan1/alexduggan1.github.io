extends Control

class_name PlayerTracker

var race: Race
var player: rootnode.Player
var mouse_over: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(player.done != 0):
		$Background/PlayerNameLabel.text = player.playerName + " (done in " + str(player.done) + ")"
	else:
		$Background/PlayerNameLabel.text = player.playerName

func setup(_race: Race, _player: rootnode.Player):
	race = _race
	player = _player
	
	$Background.self_modulate = player.trailColor
	$Background/PlayerNameLabel.text = player.playerName



func _on_background_mouse_entered():
	mouse_over = true

func _on_background_mouse_exited():
	mouse_over = false
