extends Button

var main_menu
var index

var trackInfo: MainMenu.TrackInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = trackInfo.trackName

func setup(_main_menu, _index, info):
	main_menu = _main_menu
	index = _index
	trackInfo = info

func _on_pressed():
	main_menu.open_track_menu(trackInfo)
