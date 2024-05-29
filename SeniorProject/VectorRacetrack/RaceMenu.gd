extends Control

class_name RaceMenu

var trackInfo: MainMenu.TrackInfo
var rootNode: rootnode



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(_trackInfo, _rootNode):
	trackInfo = _trackInfo
	rootNode = _rootNode
	
	$Background/TopZone/TrackPreview/GridOrigin.maxWidth = $Background/TopZone/TrackPreview.size.x-360
	$Background/TopZone/TrackPreview/GridOrigin.maxHeight = $Background/TopZone/TrackPreview.size.y-40
	$Background/TopZone/TrackPreview/GridOrigin.trackInfo = trackInfo
	$Background/TopZone/TrackPreview/GridOrigin.mode = "preview"
	
	var maxPixelsPerDot = min($Background/TopZone/TrackPreview/GridOrigin.maxWidth / trackInfo.trackWidth, $Background/TopZone/TrackPreview/GridOrigin.maxHeight / trackInfo.trackHeight)
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
		$Background/TopZone/TrackPreview/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(1, p, col))
		for i in range(len(p)):
			if(i == len(p)-1):
				$Background/TopZone/TrackPreview/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[0]], Color.BLACK))
			else:
				$Background/TopZone/TrackPreview/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[i+1]], Color.BLACK))
	
	$Background/TopZone/TrackPreview/GridOrigin.queue_redraw()
	
	
	$Background/TopZone/TrackNameLabel.text = trackInfo.trackName
	
	$Background/BottomZone/PlayerCountInput.value = len(rootNode.players)
	
	update_player_list()

func sort_ascending(a, b):
	if a.layer < b.layer:
		return true
	return false


func update_player_list():
	for playerEditor in $Background/BottomZone/ScrollContainer/HBoxContainer.get_children():
		playerEditor.queue_free()
	
	for player in rootNode.players:
		var playerEditor = load("res://player_editor.tscn").instantiate()
		playerEditor.setup(self, player)
		$Background/BottomZone/ScrollContainer/HBoxContainer.add_child(playerEditor)

func _on_go_button_pressed():
	# start the race
	var race = load("res://race.tscn").instantiate()
	race.setup(rootNode, self, trackInfo)
	rootNode.add_child(race)


func _on_player_count_input_value_changed(value):
	if(value < len(rootNode.players)):
		# remove the players
		var newPlayers: Array[rootnode.Player]
		
		for i in range(value):
			newPlayers.append(rootNode.players[i])
		rootNode.players = newPlayers.duplicate()
	elif(value > len(rootNode.players)):
		var amountToAdd = value - len(rootNode.players)
		
		var randomColors = [Color.DARK_GOLDENROD, Color.DARK_OLIVE_GREEN, Color.DARK_MAGENTA, Color.DEEP_PINK, Color.GREEN, Color.INDIGO, Color.LIGHT_SEA_GREEN,
		Color.BLUE, Color.RED, Color.DARK_SLATE_GRAY, Color.MIDNIGHT_BLUE, Color.CADET_BLUE, Color.AZURE, Color.PLUM, Color.YELLOW, Color.TEAL, Color.THISTLE, 
		Color.TOMATO, Color.VIOLET, Color.ROYAL_BLUE, Color.ROSY_BROWN, Color.SADDLE_BROWN, Color.LAVENDER_BLUSH, Color.LAWN_GREEN, Color.STEEL_BLUE]
		
		for i in range(amountToAdd):
			var newName = "P" + str(len(rootNode.players) + i + 1)
			var newColor = randomColors[randi_range(0, len(randomColors) - 1)]
			var newPlayer = rootnode.Player.new(newName, newColor)
			
			rootNode.players.append(newPlayer)
	
	update_player_list()
