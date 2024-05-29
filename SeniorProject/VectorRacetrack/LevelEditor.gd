extends Control

class_name LevelEditor

var trackInfo: MainMenu.TrackInfo
var rootNode: rootnode

var roundedMousePos: Vector2

var placingWall: bool
var placingPoints: Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# do top part things
	trackInfo.trackName = $TopPart/TrackNameInput.text
	
	
	# find mouse pos
	$MainPart/GridOrigin.maxWidth = $MainPart.size.x-120
	$MainPart/GridOrigin.maxHeight = $MainPart.size.y-120
	$MainPart/GridOrigin.mode = "editor"
	var maxPixelsPerDot = min(($MainPart.size.x-120) / trackInfo.trackWidth, ($MainPart.size.y-120) / trackInfo.trackHeight)
	var gridOriginPos = $MainPart/GridOrigin.global_position
	
	var offsetMouse = (get_global_mouse_position() - gridOriginPos)
	#print(offsetMouse)
	var mousePos = Vector2(offsetMouse.x, -offsetMouse.y) / float(maxPixelsPerDot)
	roundedMousePos = Vector2(clamp(round(mousePos.x), 0, trackInfo.trackWidth-1), clamp(round(mousePos.y), 0, trackInfo.trackHeight-1))
	#print(roundedMousePos)
	
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
		$MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(1, p, col))
		for i in range(len(p)):
			if(i == len(p)-1):
				$MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[0]], Color.BLACK))
			else:
				$MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [p[i], p[i+1]], Color.BLACK))
	
	
	
	if(placingWall):
		#print(placingPoints)
		if(len(placingPoints) > 0):
			if(len(placingPoints) > 1):
				for i in range(len(placingPoints)-1):
					$MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [placingPoints[i]*maxPixelsPerDot*flipY, placingPoints[i + 1]*maxPixelsPerDot*flipY]))
			$MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [placingPoints[len(placingPoints)-1]*maxPixelsPerDot*flipY, roundedMousePos*maxPixelsPerDot*flipY]))
		
		if(Input.is_action_just_pressed("escaperoom")):
			placingPoints.clear()
			placingWall = false
		
		# place a point
		if(Input.is_action_just_pressed("clickyclick")):
			# check if any line intersects the one you're trying to make
			if(len(placingPoints) > 1):
				var no_intersect = true
				for i in range(len(placingPoints)-1):
					$MainPart/GridOrigin.paintRequests.append(GridOrigin.PaintRequest.new(0, [placingPoints[i], placingPoints[i + 1]]))
					if(Geometry2D.segment_intersects_segment((placingPoints[len(placingPoints)-1]), (roundedMousePos), (placingPoints[i]), (placingPoints[i + 1])) != null):
						if(! placingPoints.has(Geometry2D.segment_intersects_segment((placingPoints[len(placingPoints)-1]), (roundedMousePos), (placingPoints[i]), (placingPoints[i + 1])))):
							no_intersect = false
				var last_line_dir = placingPoints[len(placingPoints)-1] - placingPoints[len(placingPoints)-2]
				last_line_dir = last_line_dir.normalized()
				var new_line_dir_reversed = placingPoints[len(placingPoints)-1] - roundedMousePos
				new_line_dir_reversed = new_line_dir_reversed.normalized()
				if(last_line_dir == new_line_dir_reversed):
					print_debug("went back on yourself")
					no_intersect = false
				
				if(no_intersect):
					placingPoints.append(roundedMousePos)
					if(placingPoints[len(placingPoints)-1].is_equal_approx(placingPoints[0])):
						placingPoints.remove_at(len(placingPoints)-1)
						# actually add the wall
						# find layer
						var lay = 0
						for existingWall in trackInfo.walls:
							if(existingWall.layer > lay): lay = existingWall.layer
						lay += 1
						var newWall = MainMenu.TrackInfo.Wall.new(placingPoints, true, lay)
						trackInfo.walls.append(newWall)
						placingWall = false
						updateWallList()
			else:
				placingPoints.append(roundedMousePos)
	
	if(Input.is_action_just_pressed("righttheotherone")):
		if(trackInfo.startingPoints.has(roundedMousePos)):
			trackInfo.startingPoints.erase(roundedMousePos)
		else:
			trackInfo.startingPoints.append(roundedMousePos)
	
	# render starting points
	
	$MainPart/GridOrigin.queue_redraw()

func setup(info, _rootNode: rootnode):
	rootNode = _rootNode
	trackInfo = info
	$MainPart/GridOrigin.trackInfo = info
	
	$TopPart/TrackNameInput.text = trackInfo.trackName
	
	$TopPart/WidthInput.value = trackInfo.trackWidth
	$TopPart/HeightInput.value = trackInfo.trackHeight
	
	
	
	placingWall = false
	
	updateWallList()


func sort_ascending(a, b):
	if a.layer < b.layer:
		return true
	return false


func updateWallList():
	for child in $RightPart/WallListHolderHolder/WallListHolder.get_children():
		child.queue_free()
	
	$RightPart/WallsTitle.text = "WALLS: " + str(len(trackInfo.walls))
	
	var i = 0
	for wall in trackInfo.walls:
		var wallPanel = load("res://wall_list_item.tscn").instantiate()
		wallPanel.setup(self, wall, i)
		$RightPart/WallListHolderHolder/WallListHolder.add_child(wallPanel)
		i += 1


func _on_add_wall_button_pressed():
	placingPoints.clear()
	placingWall = true


func _on_save_button_pressed():
	# check if valid
	
	var valid = true
	if(len(trackInfo.startingPoints) == 0):
		valid = false
		$InvalidTrackDialog.show()
	
	if(valid):
		$TopPart/SaveButton/FileDialog.show()
		$TopPart/SaveButton/FileDialog.current_path = trackInfo.trackName.replacen(" ", "").replacen("\t", "")


func _on_file_dialog_confirmed():
	# save the file
	var content = rootNode.create_file_text_for_saving(trackInfo)
	#print(content)
	#print_debug($TopPart/SaveButton/FileDialog.current_path)
	
	var file = FileAccess.open($TopPart/SaveButton/FileDialog.current_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()
	
	# close level editor
	rootNode.reload_track_list()
	self.queue_free()


func _on_width_input_value_changed(value):
	if(value < trackInfo.trackWidth):
		# bad things might happen
		var okay = true
		for wall in trackInfo.walls:
			for point in wall.points:
				if(point.x > value - 1):
					okay = false
		for point in trackInfo.startingPoints:
			if(point.x > value - 1):
				okay = false
		
		if(okay):
			trackInfo.trackWidth = value
		else:
			$TopPart/WidthInput.value = trackInfo.trackWidth
	else:
		trackInfo.trackWidth = value
	

func _on_height_input_value_changed(value):
	if(value < trackInfo.trackHeight):
		# bad things might happen
		var okay = true
		for wall in trackInfo.walls:
			for point in wall.points:
				if(point.y > value - 1):
					okay = false
		for point in trackInfo.startingPoints:
			if(point.y > value - 1):
				okay = false
		
		if(okay):
			trackInfo.trackHeight = value
		else:
			$TopPart/HeightInput.value = trackInfo.trackHeight
	else:
		trackInfo.trackHeight = value


func _on_close_button_pressed():
	$TopPart/CloseButton/ConfirmationDialog.show()

func _on_confirmation_dialog_confirmed():
	self.queue_free()
