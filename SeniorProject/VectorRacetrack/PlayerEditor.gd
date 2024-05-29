extends Control

var raceMenu: RaceMenu
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player.playerName = $Background/NameInput.text
	player.trailColor = $Background/ColorPickerButton.color

func setup(_raceMenu, _player):
	raceMenu = _raceMenu
	player = _player
	
	$Background/NameInput.text = player.playerName
	$Background/ColorPickerButton.color = player.trailColor
