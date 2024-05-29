extends Control

class_name MainMenu

class TrackInfo:
	var trackName: String
	var trackWidth: int
	var trackHeight: int
	var startingPoints: Array[Vector2]
	
	
	# keep track of walls
	class Wall:
		var points: PackedVector2Array
		var raceable: bool
		var layer: int
		var endzone: bool
		
		#Geometry2D.is_point_in_polygon()
		
		func _init(_points: PackedVector2Array, _raceable: bool, _layer: int, _endzone: bool = false):
			points = _points
			raceable = _raceable
			layer = _layer
			endzone = _endzone
	
	var walls: Array[Wall]
	
	
	func _init(_trackName: String, _trackWidth: int, _trackHeight: int, _walls: Array[Wall], _startingPoints: Array[Vector2]):
		trackName = _trackName
		trackWidth = _trackWidth
		trackHeight = _trackHeight
		walls = _walls
		startingPoints = _startingPoints

var trackInfos: Array[TrackInfo]

var trackPaths: Array[String] = ["res://SampleTracks/", "user://"]

@export var rootNode: rootnode


var fileLoadCallback: JavaScriptObject


# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("start program")
	
	reload_track_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reload_track_list():
	print_debug("reload track list")
	trackInfos.clear()
	
	for ultimatePath in trackPaths:
		#print(ultimatePath)
		#print(len(DirAccess.get_files_at(ultimatePath)))
		for file in DirAccess.get_files_at(ultimatePath):
			#print("a file")
			if(file.get_extension() == "json"):
				#print(file)
				var file2 = FileAccess.open(ultimatePath + file, FileAccess.READ)
				#print(file2.get_as_text())
				var trackData = JSON.parse_string(file2.get_as_text())
				
				var trackN: String = trackData["track_name"]
				var trackW: int = trackData["track_width"]
				var trackH: int = trackData["track_height"]
				
				var trackWalls: Array[TrackInfo.Wall]
				
				for wallData in trackData["walls"]:
					var wallPoints: Array[Vector2]
					for pointData in wallData["points"]:
						var wallPoi: Vector2
						wallPoi.x = pointData["x"]
						wallPoi.y = pointData["y"]
						wallPoints.append(wallPoi)
					var wallRa = wallData["raceable"]
					var wallLay = wallData["layer"]
					var wallEnd = false
					if(wallData.has("endzone")):
						wallEnd = wallData["endzone"]
					var trackWall = TrackInfo.Wall.new(PackedVector2Array(wallPoints), wallRa, wallLay, wallEnd)
					trackWalls.append(trackWall)
				
				var trackStarts: Array[Vector2]
				for startPoint in trackData["starting_points"]:
					trackStarts.append(Vector2(startPoint["x"], startPoint["y"]))
				
				var newTrack = TrackInfo.new(trackN, trackW, trackH, trackWalls, trackStarts)
				trackInfos.append(newTrack)
	
	
	
	for button in $MenuButtonHolder/LeftSide/TrackHolderHolder/TrackHolder.get_children():
		button.queue_free()
	
	
	var i = 0
	for trackInfo in trackInfos:
		#print_debug("track name: " + trackInfo.trackName)
		var trackButton = load("res://track_button.tscn").instantiate()
		trackButton.setup(self, i, trackInfo)
		$MenuButtonHolder/LeftSide/TrackHolderHolder/TrackHolder.add_child(trackButton)
		
		i += 1


func open_track_menu(info: TrackInfo, new: bool = false):
	print(info)
	
	var trackMenu = load("res://track_menu.tscn").instantiate()
	trackMenu.setup(info, rootNode, new)
	$MenuButtonHolder.add_child(trackMenu)


func _on_import_button_pressed():
	print_debug("import button pressed")
	#var window = JavaScriptBridge.get_interface("window")
	#window.input.click()
	
	var my_callback = JavaScriptBridge.create_callback(_on_my_callback)
	
	JavaScriptBridge.eval("""
var coolThing = "aaaaaaaaaaaaaaaaaaaaaaaaaaa";

console.log("HELP");
var godotBridge = {
	callback: null,
	setCallback: (cb) => {console.log(cb); this.callback = cb; godotBridge.callback = cb},
	test: (data) => {console.log(this.callback); console.log(data); this.callback(data)},
};

if(document.getElementById('selectFiles') == null){
	g = document.createElement('input');
	g.setAttribute("id", "selectFiles");
	g.setAttribute("type", "file");
	g.setAttribute("value", "Import");
	document.body.append(g)
	console.log(g.getAttribute("id"))
	console.log(g.getAttribute("type"))
	console.log(g.getAttribute("value"))
}

if(document.getElementById('import') == null){
	g = document.createElement('button');
	g.setAttribute("id", "import");
	g.textContent = "Import";
	document.body.append(g)
	console.log(g.getAttribute("id"))
}

document.getElementById('import').onclick = function() {
	var files = document.getElementById('selectFiles').files;
  console.log(files);
  if (files.length <= 0) {
	return false;
  }

  var fr = new FileReader();

  fr.onload = function(e) { 
  console.log(e);
	var result = e.target.result;
		console.log(result);
		godotBridge.test("heya");
		coolThing = result;
		console.log(coolThing)
  }

  fr.readAsText(files.item(0));
};

document.getElementById('selectFiles').click();

	""", true)
	var godot_bridge = JavaScriptBridge.get_interface("godotBridge")
	godot_bridge.setCallback(my_callback)
	godot_bridge.test("hiiii")
	
	
	#var result = JSON.parse(e.target.result);
	#var formatted = JSON.stringify(result, null, 2);
	
	$MenuButtonHolder/RightSide/ImportSelectButton/ConfirmationDialog.show()

func _on_my_callback(args) -> void:
	print_debug("callback happened")
	print_debug('this is coming from js', args)

func FileParser(args):
	print(args[0])
	var content = args[0]
	var json = JSON.parse_string(content)
	print(json)
	
	var file = FileAccess.open("user://" + json["track_name"], FileAccess.WRITE)
	file.store_string(content)
	
func _on_confirmation_dialog_confirmed():
	print_debug("confirm button")
	JavaScriptBridge.eval("""
console.log("confirming");

console.log("cool thing");
console.log(coolThing);
	""", true)
	JavaScriptBridge.eval("""
document.getElementById('import').click();
	""", true)
	print_debug("iasuehflikusdh")
	JavaScriptBridge.eval("""
console.log("confirming");

console.log("cool thing");
console.log(coolThing);
	""", true)
	
	$MenuButtonHolder/RightSide/ImportSelectButton/Timer.start(1.5)
	


func _on_timer_timeout():
	var coolThing = JavaScriptBridge.eval("coolThing", true)
	
	print("bbbbbbbbbbb")
	print_debug(coolThing)
	
	var content = coolThing;
	print(content)
	var json = JSON.parse_string(content)
	var pth = "user://" + json["track_name"] + ".json"
	print(pth)
	
	var file = FileAccess.open(pth, FileAccess.WRITE)
	file.store_string(content)
	file.close()
	
	reload_track_list()


func _on_create_button_pressed():
	var newWalls = [Vector2(0, 0), Vector2(19, 0), Vector2(19, 19), Vector2(0, 19)]
	var newTrackInfo = TrackInfo.new("New Track", 20, 20, [TrackInfo.Wall.new(PackedVector2Array(newWalls), false, 0)], [])
	
	open_track_menu(newTrackInfo, true)


func _on_reload_tracks_button_pressed():
	reload_track_list()
