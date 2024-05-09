extends Node3D

@export var functionText: LineEdit
@export var functionText2: LineEdit
@export var dropdown: OptionButton
@export var axisDropdown: OptionButton
@export var generateButton: Button
@export var resolutionSlider: Slider
@export var resolutionInput: SpinBox
@export var lowerBoundInput: SpinBox
@export var upperBoundInput: SpinBox
@export var titleInput: LineEdit
@export var resultText: LineEdit

var typing: bool


@export var camera: Camera3D
var camDist: float
var objCamDist: float
var camOffset: Vector3

@export var washerProto: PackedScene = load("res://washer.tscn")
@export var discProto: PackedScene = load("res://disc.tscn")
@export var shellProto: PackedScene = load("res://shell.tscn")

var integrationMode: int # 1 = disc, 2 = washer
var resolution: int
var axisSelected: int #1 = x, 2 = y

var expression = Expression.new()

@export var objHolder: Node3D

class obj:
	var title: String
	var integrationType: int
	var axis: int
	var lowB: float
	var upB: float
	var resolution: float
	
	var function1: String
	var function2: String
	
	var approxVolume: float
	
	func _init(_title: String, _integrationType: int, _axis: int, _lowB: float, _upB: float, _resolution: float, _f1: String, _f2: String, _approxVolume: float):
		title = _title
		integrationType = _integrationType
		axis = _axis
		lowB = _lowB
		upB = _upB
		resolution = _resolution
		function1 = _f1
		function2 = _f2
		approxVolume = _approxVolume

@export var historyList: ItemList

var history: Array[obj] = []

@export var exportSTLButton: Button
@export var exportSTLButton2: Button

@export var dummy: Node3D

@export var cylinderMat: StandardMaterial3D

@export var testing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("script begin")
	camera.rotate(Vector3.UP, -(PI/4))
	camera.rotate(camera.basis.x, -(PI/4))
	objCamDist = 5.0
	camDist = 5.0
	camOffset = Vector3.ZERO
	typing = false
	history = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	integrationMode = dropdown.selected
	resolution = resolutionSlider.value
	axisSelected = axisDropdown.selected
	
	if (functionText.has_focus() or functionText2.has_focus() or lowerBoundInput.has_focus() or 
	upperBoundInput.has_focus() or titleInput.has_focus() or resolutionInput.has_focus()):
		typing = true
	else:
		typing = false
	
	if (! resolutionInput.has_focus()):
		resolutionInput.value = resolution
	
	# show second function if washer or shell
	if integrationMode == 2 or integrationMode == 3:
		functionText2.show()
	else:
		functionText2.hide()
	# show export button if it's vertical
	if axisSelected == 2 and historyList.is_anything_selected():
		exportSTLButton.show()
		if (integrationMode != 1):
			exportSTLButton2.show()
		else: 
			exportSTLButton2.hide()
	else:
		exportSTLButton.hide()
		exportSTLButton2.hide()
	
	
	if (! typing):
		# yaw
		if Input.is_key_pressed(KEY_A):
			camera.rotate(Vector3.UP, -(PI/2) * delta)
		if Input.is_key_pressed(KEY_D):
			camera.rotate(Vector3.UP, (PI/2) * delta)
		# pitch
		if Input.is_key_pressed(KEY_W):
			if(camera.rotation.x > -(PI/4)):
				camera.rotate(camera.basis.x, -(PI/2) * delta)
		if Input.is_key_pressed(KEY_S):
			if(camera.rotation.x < (PI/4)):
				camera.rotate(camera.basis.x, (PI/2) * delta)
		if Input.is_key_pressed(KEY_F):
			if camDist > 1:
				camDist -= 2 * camDist * delta
		if Input.is_key_pressed(KEY_C):
			camDist += 2 * camDist * delta
		#pan
		if Input.is_key_pressed(KEY_LEFT):
			camOffset += -1.5 * camera.basis.x * camDist * delta
		if Input.is_key_pressed(KEY_RIGHT):
			camOffset += 1.5 * camera.basis.x * camDist * delta
		if Input.is_key_pressed(KEY_UP):
			camOffset += 1.5 * camera.basis.y * camDist * delta
		if Input.is_key_pressed(KEY_DOWN):
			camOffset += -1.5 * camera.basis.y * camDist * delta
		
		if Input.is_key_pressed(KEY_R):
			camera.rotation = Vector3(0,0,0)
			camera.rotate(Vector3.RIGHT, -(PI/4))
			camera.rotate(Vector3.UP, -(PI/4))
			camDist = objCamDist
			camOffset = Vector3.ZERO
	
	camera.position = Vector3.ZERO + (camera.basis.z * camDist) + camOffset
	$Camera3D/OmniLight3D.omni_range = 100*camDist
	$Camera3D/OmniLight3D.light_energy = 1*camDist
	
	
	#size of axes
	$axesHolder/xAxis.scale = Vector3(40*camDist, 0.01*camDist, 0.01*camDist)
	$axesHolder/yAxis.scale = Vector3(0.01*camDist, 40*camDist, 0.01*camDist)
	$axesHolder/zAxis.scale = Vector3(0.01*camDist, 0.01*camDist, 40*camDist)
	$axesHolder/mid.scale = Vector3(0.01*camDist, 0.01*camDist, 0.01*camDist)
	
	
	#labels
	if(integrationMode == 0):
		$LineEdit1.placeholder_text = ""
		$LineEdit1/Label.text = ""
		$LineEdit2.placeholder_text = ""
		$LineEdit2/Label.text = ""
	
	if(integrationMode == 1):
		#disc
		if(axisSelected == 1):
			$LineEdit1.placeholder_text = "write f(x) here"
			$LineEdit1/Label.text = "y = "
			$LineEdit2.placeholder_text = ""
			$LineEdit2/Label.text = ""
		if(axisSelected == 2):
			$LineEdit1.placeholder_text = "write f(y) here"
			$LineEdit1/Label.text = "x = "
			$LineEdit2.placeholder_text = ""
			$LineEdit2/Label.text = ""
	
	if(integrationMode == 2):
		#washer
		if(axisSelected == 1):
			$LineEdit1.placeholder_text = "write f(x) here"
			$LineEdit1/Label.text = "(outer) y = "
			$LineEdit2.placeholder_text = "write g(x) here"
			$LineEdit2/Label.text = "(inner) y = "
		if(axisSelected == 2):
			$LineEdit1.placeholder_text = "write f(y) here"
			$LineEdit1/Label.text = "(outer) x = "
			$LineEdit2.placeholder_text = "write g(y) here"
			$LineEdit2/Label.text = "(inner) x = "
	
	if(integrationMode == 3):
		#shell
		if(axisSelected == 1):
			$LineEdit1.placeholder_text = "write f(y) here"
			$LineEdit1/Label.text = "(upper) x = "
			$LineEdit2.placeholder_text = "write g(y) here"
			$LineEdit2/Label.text = "(lower) x = "
		if(axisSelected == 2):
			$LineEdit1.placeholder_text = "write f(x) here"
			$LineEdit1/Label.text = "(upper) y = "
			$LineEdit2.placeholder_text = "write g(x) here"
			$LineEdit2/Label.text = "(lower) y = "
	

func generate(integrationMethod: int):
	# with the input
	#print_debug("generateFunctionStarted")
	
	var axis = axisSelected
	
	var lowerBound = lowerBoundInput.value
	var upperBound = upperBoundInput.value
	var meters = upperBound - lowerBound
	#print_debug(resolution)
	var cylinderCount = meters * resolution
	
	#print_debug(cylinderCount)
	var largestCylinderRad: float = 3
	
	var approxVol: float = 0
	
	if(integrationMethod == 1):
		# disc method
		if meters > 0 and (functionText.text != ""):
			var fV = "x"
			if(axis == 2): fV = "y"
			
			for cylinder in range(cylinderCount):
				#print("number = ")
				#print(cylinder)
				var cylinderHeight = float(meters) / float(cylinderCount)
				var x = lowerBound + (float(cylinder) / float(resolution) + (cylinderHeight / 2))
				#print("x = ")
				#print(x)
				var cylinderRadius = calculateRadius(x, functionText.text, fV)
				#print_debug(cylinderRadius)
				if(cylinderRadius != null):
					if(cylinderRadius > largestCylinderRad):
						largestCylinderRad = cylinderRadius
				if(cylinderRadius == NAN):
					cylinderRadius = 0
				
				if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
				#print("cylinder now")
				#print(cylinderRadius)
				#print(cylinderHeight)
				if(cylinderRadius != null):
					if(cylinderRadius > 0):
						#print("createCylinder")
						var cylinderProto = discProto.instantiate()
						objHolder.add_child(cylinderProto)
						cylinderProto.setup(cylinderHeight, cylinderRadius, x, axis)
						approxVol += PI * pow(cylinderRadius, 2) * cylinderHeight
	
	if (integrationMethod == 2):
		# washer method
		if meters > 0  and (functionText.text != "" and functionText2.text != ""):
			var fV = "x"
			if(axis == 2): fV = "y"
			
			for cylinder in range(cylinderCount):
				#print("number = ")
				#print(cylinder)
				var cylinderHeight = float(meters) / float(cylinderCount)
				var x = lowerBound + (float(cylinder) / float(resolution) + (cylinderHeight / 2))
				#print("x = ")
				#print(x)
				var cylinderRadius = calculateRadius(x, functionText.text, fV)
				var innerRadius = calculateRadius(x, functionText2.text, fV)
				
				if(cylinderRadius != null):
					if(cylinderRadius > largestCylinderRad):
						largestCylinderRad = cylinderRadius
				if(innerRadius != null):
					if(innerRadius < 0): innerRadius = 0
				else: innerRadius = 0
				if(cylinderRadius == NAN):
					cylinderRadius = 0
				if(innerRadius == NAN):
					innerRadius = 0
				
				if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
				#print("cylinder now")
				#print(cylinderRadius)
				#print(cylinderHeight)
				if(cylinderRadius != null and innerRadius != null):
					if(cylinderRadius > 0 and cylinderRadius > innerRadius):
						#print("createCylinder")
						var cylinderProto = washerProto.instantiate()
						objHolder.add_child(cylinderProto)
						cylinderProto.setup(cylinderHeight, cylinderRadius, innerRadius, x, axis)
						approxVol += PI * (pow(cylinderRadius, 2) - pow(innerRadius, 2)) * cylinderHeight
	
	if (integrationMethod == 3):
		# shell method
		if meters > 0 and (functionText.text != "" and functionText2.text != ""):
			var fV = "y"
			if(axis == 2): fV = "x"
			
			var cylinderThickness = float(meters) / float(cylinderCount)
			
			for cylinder in range(cylinderCount):
				
				var x = lowerBound + (cylinder * cylinderThickness) + (cylinderThickness / 2)
				var cylinderRadius = x + (cylinderThickness / 2)
				var innerRadius = x - (cylinderThickness / 2)
				
				# calculate height
				# function1 is top of cylinder
				# function2 is bottom of cylinder
				
				var cylinderTop = calculateHeight(x, functionText.text, fV)
				var cylinderBottom = calculateHeight(x, functionText2.text, fV)
				
				#print_debug(cylinderTop)
				#print_debug(cylinderBottom)
				
				if (cylinderTop != null and cylinderBottom != null):
					if (cylinderTop > cylinderBottom):
						#print("createCylinder")
						var cylinderProto = shellProto.instantiate()
						objHolder.add_child(cylinderProto)
						cylinderProto.setup(cylinderTop, cylinderBottom, cylinderRadius, innerRadius, x, axis)
						approxVol += 2 * PI * (cylinderTop - cylinderBottom) * cylinderThickness
	
	
	objCamDist = largestCylinderRad + 2
	camDist = objCamDist
	#objHolder.position = Vector3(-lowerBound - (meters/2), 0, 0)
	
	# save to history
	var savingObj: obj
	
	#print("axis")
	#print(axis)
	savingObj = obj.new(titleInput.text, integrationMethod, axis, lowerBound, upperBound, resolution, functionText.text, functionText2.text, approxVol)
	resultText.text = str(approxVol)
	$ResultText/Label.text = "volume"
	
	if(titleInput.text != ""):	
		history.append(savingObj)
		historyList.add_item(savingObj.title)


func generateObj(objToGen: obj):
	# without the input
	#print_debug("generateObjFunctionStarted")
	
	var axis = objToGen.axis
	#print(axis)
	
	var lowerBound = objToGen.lowB
	var upperBound = objToGen.upB
	var meters = upperBound - lowerBound
	var res = objToGen.resolution
	var cylinderCount = meters * res
	
	#print_debug(cylinderCount)
	var largestCylinderRad: float = 3
	
	if(objToGen.integrationType == 1):
		# disc method
		if meters > 0:
			var fV = "x"
			if(axis == 2): fV = "y"
			
			for cylinder in range(cylinderCount):
				#print("number = ")
				#print(cylinder)
				var cylinderHeight = float(meters) / float(cylinderCount)
				var x = lowerBound + (float(cylinder) / float(res) + (cylinderHeight / 2))
				#print("x = ")
				#print(x)
				var cylinderRadius = calculateRadius(x, objToGen.function1, fV)
				
				if(cylinderRadius != null):
					if(cylinderRadius > largestCylinderRad):
						largestCylinderRad = cylinderRadius
				
				if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
				#print("cylinder now")
				#print(cylinderRadius)
				#print(cylinderHeight)
				if(cylinderRadius != null):
					if(cylinderRadius > 0):
						#print("createCylinder")
						var cylinderProto = discProto.instantiate()
						objHolder.add_child(cylinderProto)
						cylinderProto.setup(cylinderHeight, cylinderRadius, x, axis)
	
	if (objToGen.integrationType == 2):
		# washer method
		if meters > 0:
			var fV = "x"
			if(axis == 2): fV = "y"
			
			for cylinder in range(cylinderCount):
				#print("number = ")
				#print(cylinder)
				var cylinderHeight = float(meters) / float(cylinderCount)
				var x = lowerBound + (float(cylinder) / float(res) + (cylinderHeight / 2))
				#print("x = ")
				#print(x)
				var cylinderRadius = calculateRadius(x, objToGen.function1, fV)
				var innerRadius = calculateRadius(x, objToGen.function2, fV)
				
				if(cylinderRadius != null):
					if(cylinderRadius > largestCylinderRad):
						largestCylinderRad = cylinderRadius
				
				if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
				#print("cylinder now")
				#print(cylinderRadius)
				#print(cylinderHeight)
				if(cylinderRadius != null and innerRadius != null):
					if(cylinderRadius > 0 and cylinderRadius > innerRadius):
						#print("createCylinder")
						var cylinderProto = washerProto.instantiate()
						objHolder.add_child(cylinderProto)
						cylinderProto.setup(cylinderHeight, cylinderRadius, innerRadius, x, axis)
	
	if (objToGen.integrationType == 3):
		# shell method
		var fV = "y"
		if(axis == 2): fV = "x"
		
		var cylinderThickness = float(meters) / float(cylinderCount)
		
		for cylinder in range(cylinderCount):
			
			var x = lowerBound + (cylinder * cylinderThickness) + (cylinderThickness / 2)
			var cylinderRadius = x + (cylinderThickness / 2)
			var innerRadius = x - (cylinderThickness / 2)
			
			# calculate height
			# function1 is top of cylinder
			# function2 is bottom of cylinder
			
			var cylinderTop = calculateHeight(x, objToGen.function1, fV)
			var cylinderBottom = calculateHeight(x, objToGen.function2, fV)
			
			#print_debug(cylinderTop)
			#print_debug(cylinderBottom)
			
			if (cylinderTop != null and cylinderBottom != null):
				if (cylinderTop > cylinderBottom):
					#print("createCylinder")
					var cylinderProto = shellProto.instantiate()
					objHolder.add_child(cylinderProto)
					cylinderProto.setup(cylinderTop, cylinderBottom, cylinderRadius, innerRadius, x, axis)
	
	
	objCamDist = largestCylinderRad + 2
	camDist = objCamDist
	
	resultText.text = str(objToGen.approxVolume)
	$ResultText/Label.text = "volume"


func calculateRadius(x: float, function: String, funcVar: String):
	var textToEvaluate: String = function
	
	#print("function")
	#print_debug(function)
	if funcVar == "x":
		textToEvaluate = textToEvaluate.replace("exp", "EXP")
		textToEvaluate = textToEvaluate.replace("x", "(float(" + str(x) + "))")
		textToEvaluate = textToEvaluate.replace("EXP", "exp")
	if funcVar == "y":
		textToEvaluate = textToEvaluate.replace("y", "(float(" + str(x) + "))")
	#print("evaluate this:")
	#print_debug(textToEvaluate)
	
	var result = parseExpression(textToEvaluate)
	return result

func calculateHeight(x: float, function: String, funcVar: String):
	var textToEvaluate: String = function
	
	#print("function")
	#print_debug(function)
	if funcVar == "x":
		textToEvaluate = textToEvaluate.replace("exp", "EXP")
		textToEvaluate = textToEvaluate.replace("x", "(float(" + str(x) + "))")
		textToEvaluate = textToEvaluate.replace("EXP", "exp")
	if funcVar == "y":
		textToEvaluate = textToEvaluate.replace("y", "(float(" + str(x) + "))")
	#print("evaluate this:")
	#print_debug(textToEvaluate)
	
	var result = parseExpression(textToEvaluate)
	return result

func parseExpression(command):
	var error = expression.parse(command)
	if error != OK:
		#print(expression.get_error_text())
		# probably show this on screen TODO
		resultText.text = expression.get_error_text()
		$ResultText/Label.text = "error"
		return
	var result = expression.execute()
	if not expression.has_execute_failed():
		#print("result")
		#print(str(result))
		return result
	else:
		#print("result bad")
		#print(str(result))
		#print(expression.get_error_text())
		resultText.text = expression.get_error_text()
		$ResultText/Label.text = "error"



func removeOldObj():
	var toRemove: Array[Node] = objHolder.get_children()
	for node in toRemove:
		node.queue_free()

func _on_generate_button_button_up():
	#print("generateButtonPressed")
	removeOldObj()
	generate(integrationMode)

func _on_history_list_item_activated(index):
	#print("activated history")
	var objToUse = history[index]
	#print(objToUse.title)
	removeOldObj()
	generateObj(objToUse)
	
	functionText.text = objToUse.function1
	functionText2.text = objToUse.function2
	titleInput.text = objToUse.title
	lowerBoundInput.value = objToUse.lowB
	upperBoundInput.value = objToUse.upB
	resolutionSlider.value = objToUse.resolution
	dropdown.select(objToUse.integrationType)

func _on_clear_history_button_button_up():
	#print_debug("clearing history")
	history = []
	historyList.clear()







# 3D STL STUFF NOW








func _on_export_stl_button_2_button_up():
	#print_debug("pressed export stl button 2")
	export_stl(history[historyList.get_selected_items()[0]], true)



func _on_export_stl_button_button_up():
	#print_debug("pressed export stl button")
	export_stl(history[historyList.get_selected_items()[0]])


func export_stl(objectToExport: obj, advanced: bool = false):
	if(! testing):
		if(! advanced):
			var content = create_stl(objectToExport)
			
			var JSB = JavaScriptBridge
			
			JSB.download_buffer(content.to_utf16_buffer(), objectToExport.title + ".stl")
			
			#var file = FileAccess.open("user://" + objectToExport.title + ".stl", FileAccess.WRITE)
			#file.store_string(content)
		else:
			var path = "user://" + objectToExport.title + ".zip"
			#print_debug(path)
			
			var f = FileAccess.open(path, FileAccess.WRITE)
			f.close()
			
			
			var writer := ZIPPacker.new()
			var err := writer.open(path)
			if err != OK:
				return err
			
			
			var contents = create_stl(objectToExport, advanced)
			var i = 0
			for content in contents:
				writer.start_file(objectToExport.title + "_" + str(i) + ".stl")
				writer.write_file(content.to_utf16_buffer())
				writer.close_file()
				
				#print_debug(content)
				#var file = FileAccess.open("user://" + objectToExport.title + "/" + objectToExport.title + "_" + str(i) + ".stl", FileAccess.WRITE)
				i += 1
				#file.store_string(content)
			
			var JSB = JavaScriptBridge
			
			f = FileAccess.open(path, FileAccess.READ)
			JSB.download_buffer(f.get_buffer(f.get_length()), objectToExport.title + ".zip")
			
			
	else:
		if(! advanced):
			var content = create_stl(objectToExport)
			
			var file = FileAccess.open("user://" + objectToExport.title + ".stl", FileAccess.WRITE)
			file.store_string(content)
		else:
			var path = "user://" + objectToExport.title + "/"
			#print_debug(path)
			var error = DirAccess.make_dir_recursive_absolute(path) 
			#print(error)
			
			var contents = create_stl(objectToExport, advanced)
			var i = 0
			for content in contents:
				#print_debug(content)
				var file = FileAccess.open("user://" + objectToExport.title + "/" + objectToExport.title + "_" + str(i) + ".stl", FileAccess.WRITE)
				i += 1
				file.store_string(content)




func create_stl(object: obj, advanced: bool = false):
	# create the stl here
	var result
	if(! advanced):
		result = ""
		result = result + "solid " + object.title.replace(" ", "") + "\n\n"
	else:
		result = []
	
	
	var lowerBound = object.lowB
	var upperBound = object.upB
	var meters = upperBound - lowerBound
	var res = object.resolution
	var cylinderCount = meters * res
	
	for cylinder in range(cylinderCount):
		# generate triangles for cylinder
		
		if(advanced):
			result.append("solid " + object.title.replace(" ", "") + "\n\n")
		
		var cylinderResult: String = ""
		
		var segmentCount = 60.0
		
		var cylinderRadius = 1.0
		var innerRadius = 0.5
		var cylinderHeight = 1.0
		var x
		
		if(object.integrationType == 1):
			# disc method
			var fV = "x"
			if(object.axis == 2): fV = "y"
			
			#print("number = ")
			#print(cylinder)
			cylinderHeight = float(meters) / float(cylinderCount)
			x = lowerBound + (float(cylinder) / float(res) + (cylinderHeight / 2))
			#print("x = ")
			#print(x)
			cylinderRadius = calculateRadius(x, object.function1, fV)
			
			if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
			if(cylinderRadius == null): cylinderRadius = 1
			if(cylinderRadius == NAN): cylinderRadius = 0
			if(cylinderRadius < 0): cylinderRadius = 0
			
			
			var cylinderSegmentPositionsTop: Array[Vector3] = []
			var cylinderSegmentPositionsBottom: Array[Vector3] = []
			
			# outside walls
			for segment in range(segmentCount):
				var radians = (segment) * ((2 * PI) / segmentCount)
				var radians2 = (segment + 0.5) * ((2 * PI) / segmentCount)
				var radians3 = (segment + 1) * ((2 * PI) / segmentCount)
				#print_debug(radians)
				
				
				var circumference = 2 * PI * cylinderRadius
				var segmentWidth = circumference / segmentCount
				var segmentHeight = cylinderHeight
				
				
				dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
				
				
				dummy.rotation = Vector3.ZERO
				dummy.rotate(Vector3.UP, radians2)
				var triNormal: Vector3 = -dummy.basis.z
				
				
				dummy.rotation = Vector3.ZERO
				dummy.rotate(Vector3.UP, radians)
				dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
				dummy.position += -dummy.basis.z * cylinderRadius
				
				var v1: Vector3
				var v2: Vector3
				var v3: Vector3
				var v4: Vector3
				
				v1 = dummy.position
				v4 = dummy.position + dummy.basis.y * segmentHeight
				if(len(cylinderSegmentPositionsBottom) > 0):
					v1 = cylinderSegmentPositionsBottom[len(cylinderSegmentPositionsBottom)-1]
					v4 = cylinderSegmentPositionsTop[len(cylinderSegmentPositionsTop)-1]
					dummy.look_at(Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2))))
				
				dummy.rotation = Vector3.ZERO
				dummy.rotate(Vector3.UP, radians3)
				dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
				dummy.position += -dummy.basis.z * cylinderRadius
				
				v2 = dummy.position
				v3 = dummy.position + dummy.basis.y * segmentHeight
				if(segment == segmentCount - 1):
					v2 = cylinderSegmentPositionsBottom[0]
					v3 = cylinderSegmentPositionsTop[0]
				
				var segmentResult = generate_a_triangle(triNormal, [v1, v2, v3])
				
				
				segmentResult = segmentResult + generate_a_triangle(triNormal, [v1, v3, v4])
				
				
				cylinderSegmentPositionsTop.append(v4)
				cylinderSegmentPositionsTop.append(v3)
				cylinderSegmentPositionsBottom.append(v1)
				cylinderSegmentPositionsBottom.append(v2)
				
				cylinderResult = cylinderResult + segmentResult
			
			
			#print_debug(cylinderSegmentPositionsTop)
			#print_debug(cylinderSegmentPositionsBottom)
			
			
			cylinderSegmentPositionsBottom.reverse()
			
	
			var flatSectionResult: String = ""
			
			dummy.position = Vector3.ZERO + (Vector3.UP * (x + (cylinderHeight / 2)))
			for i in range(len(cylinderSegmentPositionsTop) / 2):
				flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [dummy.position, cylinderSegmentPositionsTop[i*2], cylinderSegmentPositionsTop[(i*2)+1]])
			
			cylinderResult = cylinderResult + flatSectionResult
			
			
			dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
			for i in range(len(cylinderSegmentPositionsBottom) / 2):
				flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [dummy.position, cylinderSegmentPositionsBottom[i*2], cylinderSegmentPositionsBottom[(i*2)+1]])
			
			cylinderResult = cylinderResult + flatSectionResult
			
			
			
			# add the triangles from this cylinder to the final result
			result = result + cylinderResult
		if (object.integrationType == 2):
			# washer
			var fV = "x"
			if(object.axis == 2): fV = "y"
			
			#print("number = ")
			#print(cylinder)
			cylinderHeight = float(meters) / float(cylinderCount)
			x = lowerBound + (float(cylinder) / float(res) + (cylinderHeight / 2))
			#print("x = ")
			#print(x)
			cylinderRadius = calculateRadius(x, object.function1, fV)
			innerRadius = calculateRadius(x, object.function2, fV)
			
			if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
			if(str(innerRadius) == "inf"): innerRadius = 10000
			if(cylinderRadius == null): cylinderRadius = 1
			if(innerRadius == null): innerRadius = 0
			if(innerRadius < 0): innerRadius = 0
			if(cylinderRadius == NAN): cylinderRadius = 0
			if(innerRadius == NAN): innerRadius = 0
			if(cylinderRadius < 0): cylinderRadius = 0
			
			
			if(cylinderRadius > innerRadius):
				#print_debug("can proceed")
			
				var cylinderSegmentPositionsTopOuter: Array[Vector3] = []
				var cylinderSegmentPositionsBottomOuter: Array[Vector3] = []
				
				# outside walls
				for segment in range(segmentCount):
					var radians = (segment) * ((2 * PI) / segmentCount)
					var radians2 = (segment + 0.5) * ((2 * PI) / segmentCount)
					var radians3 = (segment + 1) * ((2 * PI) / segmentCount)
					#print_debug(radians)
					
					
					var circumference = 2 * PI * cylinderRadius
					var segmentWidth = circumference / segmentCount
					var segmentHeight = cylinderHeight
					
					
					dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians2)
					var triNormal: Vector3 = -dummy.basis.z
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians)
					dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
					dummy.position += -dummy.basis.z * cylinderRadius
					
					var v1: Vector3
					var v2: Vector3
					var v3: Vector3
					var v4: Vector3
					
					v1 = dummy.position
					v4 = dummy.position + dummy.basis.y * segmentHeight
					if(len(cylinderSegmentPositionsBottomOuter) > 0):
						v1 = cylinderSegmentPositionsBottomOuter[len(cylinderSegmentPositionsBottomOuter)-1]
						v4 = cylinderSegmentPositionsTopOuter[len(cylinderSegmentPositionsTopOuter)-1]
						dummy.look_at(Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2))))
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians3)
					dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
					dummy.position += -dummy.basis.z * cylinderRadius
					
					v2 = dummy.position
					v3 = dummy.position + dummy.basis.y * segmentHeight
					if(segment == segmentCount - 1):
						v2 = cylinderSegmentPositionsBottomOuter[0]
						v3 = cylinderSegmentPositionsTopOuter[0]
					
					var segmentResult = generate_a_triangle(triNormal, [v1, v2, v3])
					
					
					segmentResult = segmentResult + generate_a_triangle(triNormal, [v1, v3, v4])
					
					
					cylinderSegmentPositionsTopOuter.append(v4)
					cylinderSegmentPositionsTopOuter.append(v3)
					cylinderSegmentPositionsBottomOuter.append(v1)
					cylinderSegmentPositionsBottomOuter.append(v2)
					
					cylinderResult = cylinderResult + segmentResult
				
				cylinderSegmentPositionsBottomOuter.reverse()
				
				
				var cylinderSegmentPositionsTopInner: Array[Vector3] = []
				var cylinderSegmentPositionsBottomInner: Array[Vector3] = []
				
				# inside walls
				for segment in range(segmentCount):
					var radians = (segment) * ((2 * PI) / segmentCount)
					var radians2 = (segment + 0.5) * ((2 * PI) / segmentCount)
					var radians3 = (segment + 1) * ((2 * PI) / segmentCount)
					#print_debug(radians)
					
					
					var circumference = 2 * PI * innerRadius
					var segmentWidth = circumference / segmentCount
					var segmentHeight = cylinderHeight
					
					
					dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians2)
					var triNormal: Vector3 = dummy.basis.z
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians)
					dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
					dummy.position += -dummy.basis.z * innerRadius
					
					var v1: Vector3
					var v2: Vector3
					var v3: Vector3
					var v4: Vector3
					
					v1 = dummy.position
					v4 = dummy.position + dummy.basis.y * segmentHeight
					if(len(cylinderSegmentPositionsBottomInner) > 0):
						v1 = cylinderSegmentPositionsBottomInner[len(cylinderSegmentPositionsBottomInner)-1]
						v4 = cylinderSegmentPositionsTopInner[len(cylinderSegmentPositionsTopInner)-1]
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians3)
					dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
					dummy.position += -dummy.basis.z * innerRadius
					
					v2 = dummy.position
					v3 = dummy.position + dummy.basis.y * segmentHeight
					if(segment == segmentCount - 1):
						v2 = cylinderSegmentPositionsBottomInner[0]
						v3 = cylinderSegmentPositionsTopInner[0]
					
					var segmentResult = generate_a_triangle(triNormal, [v1, v2, v3])
					
					
					segmentResult = segmentResult + generate_a_triangle(triNormal, [v1, v3, v4])
					
					
					cylinderSegmentPositionsTopInner.append(v4)
					cylinderSegmentPositionsTopInner.append(v3)
					cylinderSegmentPositionsBottomInner.append(v1)
					cylinderSegmentPositionsBottomInner.append(v2)
					
					cylinderResult = cylinderResult + segmentResult
					
					
				
				
				cylinderSegmentPositionsBottomInner.reverse()
				
				
				var flatSectionResult: String = ""
				
				dummy.position = Vector3.ZERO + (Vector3.UP * (x + (cylinderHeight / 2)))
				for i in range(len(cylinderSegmentPositionsTopOuter) / 2):
					var v1: Vector3 = cylinderSegmentPositionsTopOuter[i*2]
					var v2: Vector3 = cylinderSegmentPositionsTopOuter[(i*2)+1]
					var v3: Vector3 = cylinderSegmentPositionsTopInner[(i*2)+1]
					var v4: Vector3 = cylinderSegmentPositionsTopInner[i*2]
					if(innerRadius > 0):
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [v1, v2, v3])
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [v1, v3, v4])
					else:
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [v1, v2, dummy.position])
				
				cylinderResult = cylinderResult + flatSectionResult
				
				dummy.position = Vector3.ZERO + (Vector3.UP * (x - (cylinderHeight / 2)))
				for i in range(len(cylinderSegmentPositionsBottomOuter) / 2):
					var v1: Vector3 = cylinderSegmentPositionsBottomOuter[i*2]
					var v2: Vector3 = cylinderSegmentPositionsBottomOuter[(i*2)+1]
					var v3: Vector3 = cylinderSegmentPositionsBottomInner[(i*2)+1]
					var v4: Vector3 = cylinderSegmentPositionsBottomInner[i*2]
					if(innerRadius > 0):
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [v1, v2, v3])
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [v1, v3, v4])
					else:
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [v1, v2, dummy.position])
						
				
				cylinderResult = cylinderResult + flatSectionResult
				
				
				
				# add the triangles from this cylinder to the final result
				if(! advanced):
					result = result + cylinderResult
				else:
					result[len(result) - 1] = result[len(result) - 1] + cylinderResult + "\nendsolid"
		
		
		if (object.integrationType == 3):
			# shell
			var fV = "y"
			if(object.axis == 2): fV = "x"
		
			var cylinderThickness = float(meters) / float(cylinderCount)
		
			
			x = lowerBound + (cylinder * cylinderThickness) + (cylinderThickness / 2)
			cylinderRadius = x + (cylinderThickness / 2)
			innerRadius = x - (cylinderThickness / 2)
			
			# calculate height
			# function1 is top of cylinder
			# function2 is bottom of cylinder
			
			var cylinderTop = calculateHeight(x, object.function1, fV)
			var cylinderBottom = calculateHeight(x, object.function2, fV)
			cylinderHeight = cylinderTop - cylinderBottom
			
			#print_debug(cylinderTop)
			#print_debug(cylinderBottom)
			
			if(str(cylinderRadius) == "inf"): cylinderRadius = 10000
			if(str(innerRadius) == "inf"): innerRadius = 10000
			if(cylinderRadius == null): cylinderRadius = 1
			if(innerRadius == null): innerRadius = 0
			if(innerRadius < 0): innerRadius = 0
			
			
			if(cylinderTop > cylinderBottom):
				#print_debug("can proceed")
			
				var cylinderSegmentPositionsTopOuter: Array[Vector3] = []
				var cylinderSegmentPositionsBottomOuter: Array[Vector3] = []
				
				# outside walls
				for segment in range(segmentCount):
					var radians = (segment) * ((2 * PI) / segmentCount)
					var radians2 = (segment + 0.5) * ((2 * PI) / segmentCount)
					var radians3 = (segment + 1) * ((2 * PI) / segmentCount)
					#print_debug(radians)
					
					
					var circumference = 2 * PI * cylinderRadius
					var segmentWidth = circumference / segmentCount
					var segmentHeight = cylinderHeight
					
					
					dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians2)
					var triNormal: Vector3 = -dummy.basis.z
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians)
					dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
					dummy.position += -dummy.basis.z * cylinderRadius
					
					var v1: Vector3
					var v2: Vector3
					var v3: Vector3
					var v4: Vector3
					
					v1 = dummy.position
					v4 = dummy.position + dummy.basis.y * segmentHeight
					if(len(cylinderSegmentPositionsBottomOuter) > 0):
						v1 = cylinderSegmentPositionsBottomOuter[len(cylinderSegmentPositionsBottomOuter)-1]
						v4 = cylinderSegmentPositionsTopOuter[len(cylinderSegmentPositionsTopOuter)-1]
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians3)
					dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
					dummy.position += -dummy.basis.z * cylinderRadius
					
					v2 = dummy.position
					v3 = dummy.position + dummy.basis.y * segmentHeight
					if(segment == segmentCount - 1):
						v2 = cylinderSegmentPositionsBottomOuter[0]
						v3 = cylinderSegmentPositionsTopOuter[0]
					
					var segmentResult = generate_a_triangle(triNormal, [v1, v2, v3])
					
					
					segmentResult = segmentResult + generate_a_triangle(triNormal, [v1, v3, v4])
					
					
					cylinderSegmentPositionsTopOuter.append(v4)
					cylinderSegmentPositionsTopOuter.append(v3)
					cylinderSegmentPositionsBottomOuter.append(v1)
					cylinderSegmentPositionsBottomOuter.append(v2)
					
					cylinderResult = cylinderResult + segmentResult
				
				
				cylinderSegmentPositionsBottomOuter.reverse()
				
				
				var cylinderSegmentPositionsTopInner: Array[Vector3] = []
				var cylinderSegmentPositionsBottomInner: Array[Vector3] = []
				
				# inside walls
				for segment in range(segmentCount):
					var radians = (segment) * ((2 * PI) / segmentCount)
					var radians2 = (segment + 0.5) * ((2 * PI) / segmentCount)
					var radians3 = (segment + 1) * ((2 * PI) / segmentCount)
					#print_debug(radians)
					
					
					var circumference = 2 * PI * innerRadius
					var segmentWidth = circumference / segmentCount
					var segmentHeight = cylinderHeight
					
					
					dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians2)
					var triNormal: Vector3 = dummy.basis.z
					
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians)
					dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
					dummy.position += -dummy.basis.z * innerRadius
					
					var v1: Vector3
					var v2: Vector3
					var v3: Vector3
					var v4: Vector3
					
					v1 = dummy.position
					v4 = dummy.position + dummy.basis.y * segmentHeight
					if(len(cylinderSegmentPositionsBottomInner) > 0):
						v1 = cylinderSegmentPositionsBottomInner[len(cylinderSegmentPositionsBottomInner)-1]
						v4 = cylinderSegmentPositionsTopInner[len(cylinderSegmentPositionsTopInner)-1]
					
					dummy.rotation = Vector3.ZERO
					dummy.rotate(Vector3.UP, radians3)
					dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
					dummy.position += -dummy.basis.z * innerRadius
					
					v2 = dummy.position
					v3 = dummy.position + dummy.basis.y * segmentHeight
					if(segment == segmentCount - 1):
						v2 = cylinderSegmentPositionsBottomInner[0]
						v3 = cylinderSegmentPositionsTopInner[0]
					
					var segmentResult = generate_a_triangle(triNormal, [v1, v2, v3])
					
					
					segmentResult = segmentResult + generate_a_triangle(triNormal, [v1, v3, v4])
					
					
					cylinderSegmentPositionsTopInner.append(v4)
					cylinderSegmentPositionsTopInner.append(v3)
					cylinderSegmentPositionsBottomInner.append(v1)
					cylinderSegmentPositionsBottomInner.append(v2)
					
					cylinderResult = cylinderResult + segmentResult
				
				
				cylinderSegmentPositionsBottomInner.reverse()
				
				
				var flatSectionResult: String = ""
				
				dummy.position = Vector3.ZERO + (Vector3.UP * cylinderTop)
				for i in range(len(cylinderSegmentPositionsTopOuter) / 2):
					var v1: Vector3 = cylinderSegmentPositionsTopOuter[i*2]
					var v2: Vector3 = cylinderSegmentPositionsTopOuter[(i*2)+1]
					var v3: Vector3 = cylinderSegmentPositionsTopInner[(i*2)+1]
					var v4: Vector3 = cylinderSegmentPositionsTopInner[i*2]
					if(innerRadius > 0):
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [v1, v2, v3])
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [v1, v3, v4])
					else:
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.UP, [v1, v2, dummy.position])
				
				cylinderResult = cylinderResult + flatSectionResult
				
				dummy.position = Vector3.ZERO + (Vector3.UP * cylinderBottom)
				for i in range(len(cylinderSegmentPositionsBottomOuter) / 2):
					var v1: Vector3 = cylinderSegmentPositionsBottomOuter[i*2]
					var v2: Vector3 = cylinderSegmentPositionsBottomOuter[(i*2)+1]
					var v3: Vector3 = cylinderSegmentPositionsBottomInner[(i*2)+1]
					var v4: Vector3 = cylinderSegmentPositionsBottomInner[i*2]
					if(innerRadius > 0):
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [v1, v2, v3])
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [v1, v3, v4])
					else:
						flatSectionResult = flatSectionResult + generate_a_triangle(Vector3.DOWN, [v1, v2, dummy.position])
				
				cylinderResult = cylinderResult + flatSectionResult
				
				
				
				# add the triangles from this cylinder to the final result
				if(! advanced):
					result = result + cylinderResult
				else:
					result[len(result) - 1] = result[len(result) - 1] + cylinderResult + "\nendsolid"
	
	
	
	if(! advanced):
		result = result + "\nendsolid"
	
	#print_debug("finished making stl")
	
	return result

func generate_a_triangle(normal: Vector3, vertices: Array[Vector3]):
	if(! normal.is_normalized()):
		normal = normal.normalized()
		#print_debug("had to normalize")
	
	
	var triangleText: String
	triangleText = triangleText + "\tfacet normal " + str(normal.x) + " " + str(normal.y) + " " + str(normal.z) + "\n"
	triangleText = triangleText + "\t\touter loop\n"
	
	for vertex in vertices:
		triangleText = triangleText + "\t\t\tvertex " + str(vertex.x) + " " + str(vertex.y) + " " + str(vertex.z) + "\n"
	
	triangleText = triangleText + "\t\tendloop\n"
	triangleText = triangleText + "\tendfacet\n"
	
	return triangleText





func _on_color_picker_button_color_changed(color):
	cylinderMat.albedo_color = color


func _on_resolution_input_value_changed(value):
	resolution = value
	resolutionSlider.value = resolution
