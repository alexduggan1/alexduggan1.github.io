extends Control

var raceMenu: RaceMenu
var player
var rootNode: rootnode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player.playerName = $Background/NameInput.text
	player.trailColor = $Background/ColorPickerButton.color
	
	$Background/CarDisplay.texture = rootNode.carList[player.car]
	$Background/CarDisplay.self_modulate = player.trailColor

func setup(_raceMenu, _player, _rootNode):
	raceMenu = _raceMenu
	player = _player
	rootNode = _rootNode
	
	$Background/NameInput.text = player.playerName
	$Background/ColorPickerButton.color = player.trailColor


func _on_left_button_pressed():
	player.car -= 1
	if(player.car < 0):
		player.car = len(rootNode.carList) - 1

func _on_right_button_pressed():
	player.car += 1
	if(player.car > len(rootNode.carList) - 1):
		player.car = 0
