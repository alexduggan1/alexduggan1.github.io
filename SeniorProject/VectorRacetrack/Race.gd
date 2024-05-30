extends Control

class_name Race

var rootNode: rootnode
var raceMenu: RaceMenu
var trackInfo: MainMenu.TrackInfo


var currentTurnNum

var currentTurnPlayer
var currentTurnPlayerNum

var roundedMousePos


var remPlayer: Array[rootnode.Player]


var racing: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(racing):
		$Background/RightPart/CurrentTurnLabel.text = "Current Turn #: " + str(currentTurnNum)
		$Background/RightPart/CurrentPlayerTurnLabel.text = "Current Player: " + currentTurnPlayer.playerName
		
		$Background/MainPart/GridOrigin.maxWidth = $Background/MainPart.size.x-360
		$Background/MainPart/GridOrigin.maxHeight = $Background/MainPart.size.y-40
		$Background/MainPart/GridOrigin.trackInfo = trackInfo
		$Background/MainPart/GridOrigin.mode = "race"
		
		var maxPixelsPerDot: float = float(min(float($Background/MainPart/GridOrigin.maxWidth) / float(trackInfo.trackWidth), float($Background/MainPart/GridOrigin.maxHeight) / float(trackInfo.trackHeight)))
		
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
			$Background/MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(1, p, col))
			for i in range(len(p)):
				if(i == len(p)-1):
					$Background/MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[0]], Color.BLACK))
				else:
					$Background/MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[i+1]], Color.BLACK))
		
		$Background/MainPart/GridOrigin.queue_redraw()
		
		
		$Background/TopZone/TrackNameLabel.text = trackInfo.trackName
		
		$Background/RightPart/UndoLastButton.text = "Undo Last"
		
		var gridOriginPos = $Background/MainPart/GridOrigin.global_position
		var offsetMouse = (get_global_mouse_position() - gridOriginPos)
		#print(offsetMouse)
		var mousePos = Vector2(offsetMouse.x, -offsetMouse.y) / float(maxPixelsPerDot)
		roundedMousePos = Vector2(clamp(round(mousePos.x), 0, trackInfo.trackWidth-1), clamp(round(mousePos.y), 0, trackInfo.trackHeight-1))
		
		# clamp to only moveable places
		var centre = Vector2(currentTurnPlayer.points[len(currentTurnPlayer.points)-1])
		roundedMousePos = Vector2(clamp(roundedMousePos.x, centre.x + currentTurnPlayer.momentum.x - 1, centre.x + currentTurnPlayer.momentum.x + 1),
		clamp(roundedMousePos.y, centre.y + currentTurnPlayer.momentum.y - 1, centre.y + currentTurnPlayer.momentum.y + 1))
		
		#print(roundedMousePos)
		$Background/MainPart/GridOrigin.playerMovementHelperPoint = roundedMousePos
		
		var mouse_in_mainpart = (get_global_mouse_position().x >= $Background/MainPart.global_position.x and get_global_mouse_position().x <= $Background/MainPart.global_position.x + $Background/MainPart.size.x
		and get_global_mouse_position().y >= $Background/MainPart.global_position.y and get_global_mouse_position().y <= $Background/MainPart.global_position.y + $Background/MainPart.size.y)
		if(Input.is_action_just_pressed("clickyclick") and mouse_in_mainpart):
			print_debug("clickyclick")
			
			var valid = check_valid(roundedMousePos)
			print_debug(valid)
			if(valid == "raceable"):
				currentTurnPlayer.momentum = roundedMousePos - currentTurnPlayer.points[-1]
				
				currentTurnPlayer.points.append(roundedMousePos)
				end_player_turn()
			if(valid == "endzone"):
				currentTurnPlayer.points.append(roundedMousePos)
				currentTurnPlayer.done = currentTurnNum
				end_player_turn()
	else:
		var highestTurns = 1
		for player in rootNode.players:
			if(player.done > highestTurns):
				highestTurns = player.done
		
		$Background/RightPart/CurrentTurnLabel.text = "Race Over In: " + str(highestTurns) + " Turns"
		$Background/RightPart/CurrentPlayerTurnLabel.text = "Current Player: " + currentTurnPlayer.playerName
		
		$Background/MainPart/GridOrigin.maxWidth = $Background/MainPart.size.x-360
		$Background/MainPart/GridOrigin.maxHeight = $Background/MainPart.size.y-40
		$Background/MainPart/GridOrigin.trackInfo = trackInfo
		$Background/MainPart/GridOrigin.mode = "race"
		
		var maxPixelsPerDot: float = float(min(float($Background/MainPart/GridOrigin.maxWidth) / float(trackInfo.trackWidth), float($Background/MainPart/GridOrigin.maxHeight) / float(trackInfo.trackHeight)))
		
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
			$Background/MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(1, p, col))
			for i in range(len(p)):
				if(i == len(p)-1):
					$Background/MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[0]], Color.BLACK))
				else:
					$Background/MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[i+1]], Color.BLACK))
		
		
		
		$Background/TopZone/TrackNameLabel.text = trackInfo.trackName
		
		$Background/RightPart/UndoLastButton.text = "EXIT"
		
		for playerTracker in $Background/RightPart/ScrollContainer/VBoxContainer.get_children():
			if(playerTracker.mouse_over):
				currentTurnPlayer = playerTracker.player
		
		
		$Background/MainPart/GridOrigin.playerToDraw = currentTurnPlayer
		$Background/MainPart/GridOrigin.playerMovementHelperPoint = Vector2(-4000, -4000)
		
		$Background/MainPart/GridOrigin.queue_redraw()


func sort_ascending(a, b):
	if a.layer < b.layer:
		return true
	return false

func check_valid(pos):
	var sortedWalls: Array[MainMenu.TrackInfo.Wall] = trackInfo.walls.duplicate()
	sortedWalls.sort_custom(sort_ascending)
	
	var wallsInside: Array[MainMenu.TrackInfo.Wall] = []
	
	var result = "unraceable"
	
	for wall in sortedWalls:
		if(Geometry2D.is_point_in_polygon(pos, wall.points)):
			print_debug("point in polygon")
			print_debug(wall.layer)
			
			wallsInside.append(wall)
	
	
	if(len(wallsInside) > 0):
		var wally = wallsInside[len(wallsInside)-1]
		var on_a_line = false
		var lines_on: Array[PackedVector2Array]
		for i in range(len(wally.points)):
			var p1 = wally.points[i]
			var p2
			if(i + 1 == len(wally.points)):
				p2 = wally.points[0]
			else:
				p2 = wally.points[i + 1]
			
			print_debug(Geometry2D.get_closest_point_to_segment(pos, p1, p2))
			if(Geometry2D.get_closest_point_to_segment(pos, p1, p2) == pos):
				print_debug("on line")
				on_a_line = true
				
				lines_on.append(PackedVector2Array([p1, p2]))
				
		
		if(on_a_line):
			print_debug(len(lines_on))
			if(len(lines_on) == 1):
				print_debug("line")
				
				# check all the way around
				var currentPoint = Vector2(0, 0.3)
				
				var all_around = "raceable"
				
				for i in range(360):
					currentPoint = currentPoint.rotated(deg_to_rad(1))
					var res = "unraceable"
					for w in sortedWalls:
						if(Geometry2D.is_point_in_polygon(pos + currentPoint, w.points)):
							#print(w.raceable)
							if(w.raceable):
								res = "raceable"
							else:
								res = "unraceable"
					#print(res)
					if(res == "unraceable"):
						all_around = "unraceable"
				
				return all_around
				
				
			if(len(lines_on) == 2):
				print_debug("corner")
				
				# check all the way around
				var currentPoint = Vector2(0, 0.3)
				
				var all_around = "raceable"
				
				for i in range(360):
					currentPoint = currentPoint.rotated(deg_to_rad(1))
					var res = "unraceable"
					for w in sortedWalls:
						if(Geometry2D.is_point_in_polygon(pos + currentPoint, w.points)):
							#print(w.raceable)
							if(w.raceable):
								res = "raceable"
							else:
								res = "unraceable"
					#print(res)
					if(res == "unraceable"):
						all_around = "unraceable"
				
				return all_around
		
		
		if(! on_a_line):
			if(wally.raceable):
				result = "raceable"
				if(wally.endzone):
					result = "endzone"
	
	return(result)

func setup(_rootNode, _raceMenu, _trackInfo):
	rootNode = _rootNode
	raceMenu = _raceMenu
	trackInfo = _trackInfo
	
	$Background/MainPart/GridOrigin.trackInfo = trackInfo
	$Background/MainPart/GridOrigin.rootNode = rootNode
	
	racing = true
	
	for player in rootNode.players:
		player.points.clear()
		player.points.append(trackInfo.startingPoints[randi_range(0, len(trackInfo.startingPoints)-1)])
		player.momentum = Vector2.ZERO
		player.done = 0
		print(player.points[0])
	
	currentTurnNum = 0
	
	for playerTracker in $Background/RightPart/ScrollContainer/VBoxContainer.get_children():
		playerTracker.queue_free()
	
	for player in rootNode.players:
		var playerTracker = load("res://player_tracker.tscn").instantiate()
		playerTracker.setup(self, player)
		$Background/RightPart/ScrollContainer/VBoxContainer.add_child(playerTracker)
	
	start_turn()

func start_turn():
	currentTurnNum += 1
	
	remPlayer.clear()
	for player in rootNode.players:
		if(player.done == 0):
			remPlayer.append(player)
	
	if(len(remPlayer) > 0):
		player_turn(remPlayer[0])
	else:
		print_debug("everyone's done")
		racing = false
	

func player_turn(player: rootnode.Player):
	currentTurnPlayer = player
	currentTurnPlayerNum = remPlayer.find(currentTurnPlayer)
	
	$Background/MainPart/GridOrigin.playerToDraw = currentTurnPlayer

func end_player_turn():
	if((currentTurnPlayerNum + 1) > len(remPlayer) - 1):
		start_turn()
	else:
		player_turn(remPlayer[currentTurnPlayerNum + 1])


func _on_undo_last_button_pressed():
	if(racing):
		if(len(currentTurnPlayer.points) > 0):
			currentTurnPlayer.points.remove_at(len(currentTurnPlayer.points)-1)
			currentTurnPlayer.momentum = currentTurnPlayer.points[-1] - currentTurnPlayer.points[-2]
		end_player_turn()
	else:
		# becomes exit button
		raceMenu.queue_free()
		self.queue_free()
