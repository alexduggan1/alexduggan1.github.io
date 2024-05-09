extends CSGCylinder3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(top: float, bottom: float, aRadius: float, inner: float, pos: float, axis: int):
	print_debug("received setup")
	print("top")
	print(top)
	print("bottom")
	print(bottom)
	print("radius")
	print(aRadius)
	print("inner")
	print(inner)
	
	var aHeight = top - bottom
	var center = bottom + (aHeight / 2)
	
	print("center")
	print(center)
	if axis == 1:
		position = Vector3(center, 0, 0)
	if axis == 2:
		position = Vector3(0, center, 0)
	scale = Vector3(aRadius, aHeight, aRadius)
	$Inside.radius = 1 * inner * (float(1) / aRadius)
	
	if axis == 1:
		rotate(Vector3.FORWARD, PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
