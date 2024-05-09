extends CSGCylinder3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(aHeight: float, aRadius: float, pos: float, axis: int):
	print_debug("received setup")
	print("height")
	print(aHeight)
	print("radius")
	print(aRadius)
	
	print("position")
	print(pos + (aHeight/2))
	print_debug(axis)
	print()
	if axis == 1:
		position = Vector3(pos + (aHeight/2), 0, 0)
	if axis == 2:
		position = Vector3(0, pos + (aHeight/2), 0)
	scale = Vector3(aRadius, aHeight, aRadius)
	
	if axis == 1:
		rotate(Vector3.FORWARD, PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
