extends Control

var trackInfo: MainMenu.TrackInfo
var rootNode: rootnode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Background/TopZone/NameLabel.text = "TRACK: " + trackInfo.trackName
	$Background/TopZone/WidthHeightLabel.text = "WIDTH: " + str(trackInfo.trackWidth) + "    HEIGHT: " + str(trackInfo.trackHeight)
	$Background/TopZone/WallsLabel.text = "WALLS: " + str(len(trackInfo.walls))

func setup(_info: MainMenu.TrackInfo, _rootNode: rootnode, new: bool = false):
	trackInfo = _info
	rootNode = _rootNode
	
	$Background/MiddleZone/GridOrigin.maxWidth = $Background/MiddleZone.size.x-360
	$Background/MiddleZone/GridOrigin.maxHeight = $Background/MiddleZone.size.y-40
	$Background/MiddleZone/GridOrigin.trackInfo = trackInfo
	$Background/MiddleZone/GridOrigin.mode = "preview"
	
	var maxPixelsPerDot = min($Background/MiddleZone/GridOrigin.maxWidth / trackInfo.trackWidth, $Background/MiddleZone/GridOrigin.maxHeight / trackInfo.trackHeight)
	var flipY = Vector2(1,-1)
	# render existing walls
	var sortedWalls: Array[MainMenu.TrackInfo.Wall] = trackInfo.walls.duplicate()
	sortedWalls.sort_custom(sort_ascending)
	
	for wally in sortedWalls:
		var p: Array[Vector2]
		for v in wally.points:
			p.append(v*maxPixelsPerDot*flipY)
		var col: Color = Color.DIM_GRAY
		if(wally.raceable):
			col = Color.DARK_GRAY
		if(wally.endzone):
			col = Color.DEEP_SKY_BLUE
		$Background/MiddleZone/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(1, p, col))
		for i in range(len(p)):
			if(i == len(p)-1):
				$Background/MiddleZone/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[0]], Color.BLACK))
			else:
				$Background/MiddleZone/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[i+1]], Color.BLACK))
	
	if(new):
		$Background/BottomZone/RaceButton.hide()
		$Background/BottomZone/ExportButton.hide()
	
	$Background/MiddleZone/GridOrigin.queue_redraw()

func sort_ascending(a, b):
	if a.layer < b.layer:
		return true
	return false

func _on_close_button_pressed():
	self.queue_free()



func _on_edit_button_pressed():
	var levelEditor = load("res://level_editor.tscn").instantiate()
	levelEditor.setup(trackInfo, rootNode)
	rootNode.add_child(levelEditor)
	self.queue_free()


func _on_export_button_pressed():
	print_debug("export button pressed")
	var content: String = rootNode.create_file_text_for_saving(trackInfo)
	print_debug(content)
	JavaScriptBridge.download_buffer(content.to_utf8_buffer(), trackInfo.trackName + ".json")



func _on_race_button_pressed():
	var raceMenu = load("res://race_menu.tscn").instantiate()
	raceMenu.setup(trackInfo, rootNode)
	rootNode.add_child(raceMenu)
	self.queue_free()
