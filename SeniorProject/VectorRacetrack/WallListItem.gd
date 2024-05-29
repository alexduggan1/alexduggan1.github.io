extends Panel

class_name WallListItem

var editor: LevelEditor

var info: MainMenu.TrackInfo.Wall

var index: int

var raceable: bool
var layer: int
var endzone: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	info.raceable = $RaceableCheck.button_pressed
	info.endzone = $EndzoneCheck.button_pressed
	if(info.endzone):
		$RaceableCheck.button_pressed = true
		info.raceable = true
	
	info.layer = $LayerInput.value

func setup(_editor: LevelEditor, _info: MainMenu.TrackInfo.Wall, _index: int):
	editor = _editor
	info = _info
	index = _index
	
	
	$PointsList.text = "Points: ["
	#print_debug(info.points)
	
	for point in info.points:
		#print(point)
		$PointsList.text = $PointsList.text + "(" + str(point.x) + "," + str(point.y) + ")"
		if(!(point == info.points[len(info.points) - 1])):
			$PointsList.text = $PointsList.text + ", "
	$PointsList.text = $PointsList.text + "]"
	
	$RaceableCheck.button_pressed = info.raceable
	$EndzoneCheck.button_pressed = info.endzone
	
	$LayerInput.value = info.layer


func _on_delete_button_pressed():
	$DeleteButton/ConfirmationDialog.show()

func _on_confirmation_dialog_confirmed():
	editor.trackInfo.walls.remove_at(index)
	editor.updateWallList()
