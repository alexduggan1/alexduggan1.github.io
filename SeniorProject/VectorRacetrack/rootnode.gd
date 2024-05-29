extends Node

class_name rootnode

class Player:
	var playerName: String
	var trailColor: Color
	var momentum: Vector2
	var points: Array[Vector2]
	var done: int
	
	func _init(_playerName: String, _trailColor: Color):
		playerName = _playerName
		trailColor = _trailColor

var players: Array[Player]

# Called when the node enters the scene tree for the first time.
func _ready():
	players = [Player.new("P1", Color.BLUE), Player.new("P2", Color.RED)]
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload_track_list():
	$MainMenu.reload_track_list()

func create_file_text_for_saving(trackInfo: MainMenu.TrackInfo):
	var content = "{"
	content = content + "\"track_name\":\"" + trackInfo.trackName + "\","
	content = content + "\"track_width\":" + str(trackInfo.trackWidth) + ","
	content = content + "\"track_height\":" + str(trackInfo.trackHeight) + ","
	
	content = content + "\"walls\":["
	
	for wall in trackInfo.walls:
		var wallPart = "{"
		
		wallPart = wallPart + "\"points\":["
		for point in wall.points:
			var pointPart = "{\"x\":" + str(point.x) + ",\"y\":" + str(point.y) + "}"
			wallPart = wallPart + pointPart
			if(! (point == wall.points[len(wall.points)-1])):
				wallPart = wallPart + ","
		wallPart = wallPart + "],"
		wallPart = wallPart + "\"raceable\":" + str(wall.raceable) + ","
		wallPart = wallPart + "\"layer\":" + str(wall.layer) + ","
		wallPart = wallPart + "\"endzone\":" + str(wall.endzone)
		
		wallPart = wallPart + "}"
		content = content + wallPart
		if(! (wall == trackInfo.walls[len(trackInfo.walls)-1])):
			content = content + ","
	
	content = content + "],"
	
	content = content + "\"starting_points\":["
	for startingPoint in trackInfo.startingPoints:
		var startingPointPart = "{\"x\":" + str(startingPoint.x) + ",\"y\":" + str(startingPoint.y) + "}"
		content = content + startingPointPart
		if(! (startingPoint == trackInfo.startingPoints[len(trackInfo.startingPoints)-1])):
			content = content + ","
	
	content = content + "]"
	
	content = content + "}"
	return(content)
