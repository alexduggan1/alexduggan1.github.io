extends Control

class_name GridOrigin

var trackInfo

class PaintRequest:
	var type: int # 0 = line, 1 = polygon
	var points: Array[Vector2]
	var color: Color
	func _init(_type: int, _points: Array[Vector2], _color: Color = Color.BLACK):
		type = _type
		points = _points
		color = _color

var paintRequests: Array[PaintRequest]

@export var maxWidth: int
@export var maxHeight: int

var mode: String

var playerToDraw = rootnode.Player
var playerMovementHelperPoint: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	#print_debug("run draw")
	#maxWidth = get_parent_control().size.x - 120
	#maxHeight = get_parent_control().size.y - 120
	
	var maxPixelsPerDot: float = float(min(float(maxWidth) / float(trackInfo.trackWidth), float(maxHeight) / float(trackInfo.trackHeight)))
	#print(maxPixelsPerDot)
	
	
	# fulfill paint requests
	#print_debug(paintRequests)
	for paintRequest in paintRequests:
		if(paintRequest.type == 0):
			draw_line(paintRequest.points[0], paintRequest.points[1], paintRequest.color, 5*(maxPixelsPerDot/float(28)))
		if(paintRequest.type == 1):
			draw_colored_polygon(PackedVector2Array(paintRequest.points), paintRequest.color)
	paintRequests.clear()
	
	
	# render grid
	#draw_circle(Vector2(50, 50), float(15), Color.DARK_BLUE)
	#print_debug(offset)
	var upscale: float = maxPixelsPerDot
	for x in trackInfo.trackWidth:
		for y in trackInfo.trackHeight:
			if(mode == "editor"):
				if(trackInfo.startingPoints.has(Vector2(x, y))):
					draw_circle((Vector2(x, -y) * upscale), 5*(maxPixelsPerDot/float(28)), Color.RED)
				else:
					draw_circle((Vector2(x, -y) * upscale), 5*(maxPixelsPerDot/float(28)), Color.hex(0x22df65cf))
			elif(mode == "preview"):
				if(trackInfo.startingPoints.has(Vector2(x, y))):
					draw_circle((Vector2(x, -y) * upscale), 5*(maxPixelsPerDot/float(28)), Color.RED)
				else:
					draw_circle((Vector2(x, -y) * upscale), 5*(maxPixelsPerDot/float(28)), Color.hex(0x22df65cf))
			elif(mode == "race"):
				draw_circle((Vector2(x, -y) * upscale), 5*(maxPixelsPerDot/float(28)), Color.hex(0x22df65cf))
		
	
	if(mode == "race"):
		if(playerToDraw != null):
			var flipY = Vector2(1, -1)
			
			if(len(playerToDraw.points) > 1):
				for i in range(len(playerToDraw.points) - 1):
					draw_line(playerToDraw.points[i]*maxPixelsPerDot*flipY, playerToDraw.points[i + 1]*maxPixelsPerDot*flipY, playerToDraw.trailColor, 5*(maxPixelsPerDot/float(28)))
			
			var x = playerToDraw.points[len(playerToDraw.points)-1].x *maxPixelsPerDot
			var y = playerToDraw.points[len(playerToDraw.points)-1].y *maxPixelsPerDot*-1
			
			draw_circle(Vector2(x,y), 8*(maxPixelsPerDot/float(28)), playerToDraw.trailColor)
			draw_circle(Vector2(playerMovementHelperPoint.x*maxPixelsPerDot, playerMovementHelperPoint.y*maxPixelsPerDot*-1), 8*(maxPixelsPerDot/float(28)), playerToDraw.trailColor)
