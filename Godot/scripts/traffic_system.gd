extends Node3D

# Lightweight prototype traffic for the starter street. Vehicles use visual
# motion only (no per-car rigid-body physics) to keep mobile performance stable.
const ROAD_MIN_Z := -25.0
const ROAD_MAX_Z := 40.0
const STOP_LINE_Z := 2.0

var cars: Array[Dictionary] = []
var pedestrians: Array[Dictionary] = []
var phase_time := 0.0
var phase := 0 # 0 green, 1 yellow, 2 red
var red_lamp: MeshInstance3D
var yellow_lamp: MeshInstance3D
var green_lamp: MeshInstance3D

func _ready() -> void:
	_build_sidewalks()
	_build_traffic_light()
	_spawn_vehicles()
	_spawn_pedestrians()
	_update_lights()

func _process(delta: float) -> void:
	phase_time += delta
	var phase_duration := 9.0 if phase == 0 else (2.0 if phase == 1 else 7.0)
	if phase_time >= phase_duration:
		phase_time = 0.0
		phase = (phase + 1) % 3
		_update_lights()
	_move_vehicles(delta)
	_move_pedestrians(delta)

func _build_sidewalks() -> void:
	_add_box("Sidewalk_Left", Vector3(-5.0, 0.08, 7.5), Vector3(2.0, 0.16, 67.0), Color(0.48, 0.47, 0.43))
	_add_box("Sidewalk_Right", Vector3(5.0, 0.08, 7.5), Vector3(2.0, 0.16, 67.0), Color(0.48, 0.47, 0.43))
	for z in range(-22, 39, 8):
		_add_box("Road_Dash_%d" % z, Vector3(0, 0.075, float(z)), Vector3(0.12, 0.025, 3.0), Color(0.88, 0.83, 0.58))

func _build_traffic_light() -> void:
	_add_box("TrafficPole", Vector3(-4.25, 2.0, 2.0), Vector3(0.16, 4.0, 0.16), Color(0.16, 0.17, 0.18))
	_add_box("TrafficSignalHousing", Vector3(-4.25, 3.65, 2.0), Vector3(0.62, 1.55, 0.42), Color(0.045, 0.05, 0.055))
	red_lamp = _add_lamp("RedLamp", Vector3(-4.25, 4.12, 1.76), Color(1.0, 0.035, 0.025))
	yellow_lamp = _add_lamp("YellowLamp", Vector3(-4.25, 3.65, 1.76), Color(1.0, 0.58, 0.025))
	green_lamp = _add_lamp("GreenLamp", Vector3(-4.25, 3.18, 1.76), Color(0.04, 0.95, 0.18))
	_add_box("StopLine", Vector3(0, 0.09, 3.8), Vector3(6.8, 0.035, 0.22), Color(0.92, 0.9, 0.82))
	var sign := Label3D.new()
	sign.text = "ĐÈN GIAO THÔNG"
	sign.position = Vector3(-4.25, 4.75, 1.7)
	sign.font_size = 20
	sign.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(sign)

func _add_lamp(lamp_name: String, at: Vector3, tint: Color) -> MeshInstance3D:
	var lamp := MeshInstance3D.new()
	lamp.name = lamp_name
	var sphere := SphereMesh.new()
	sphere.radius = 0.15
	sphere.height = 0.3
	lamp.mesh = sphere
	lamp.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.emission_enabled = true
	material.emission = tint
	lamp.material_override = material
	add_child(lamp)
	return lamp

func _update_lights() -> void:
	_set_lamp(red_lamp, phase == 2)
	_set_lamp(yellow_lamp, phase == 1)
	_set_lamp(green_lamp, phase == 0)

func _set_lamp(lamp: MeshInstance3D, active: bool) -> void:
	if not is_instance_valid(lamp):
		return
	var material := lamp.material_override as StandardMaterial3D
	if material:
		material.emission_energy_multiplier = 2.2 if active else 0.04
		material.albedo_color.a = 1.0 if active else 0.32

func _spawn_vehicles() -> void:
	var palette := [Color(0.78, 0.08, 0.06), Color(0.12, 0.25, 0.68), Color(0.82, 0.72, 0.12), Color(0.82, 0.82, 0.78)]
	var starts := [-19.0, -34.0, -49.0, -64.0]
	for i in range(4):
		var vehicle := Node3D.new()
		vehicle.name = "TrafficCar_%02d" % i
		vehicle.position = Vector3(-1.35, 0.0, starts[i])
		add_child(vehicle)
		_build_car_model(vehicle, palette[i])
		cars.append({"node": vehicle, "speed": 4.0 + float(i) * 0.55, "stopped": false})

func _build_car_model(root: Node3D, tint: Color) -> void:
	_add_child_box(root, "CarBody", Vector3(0, 0.62, 0), Vector3(1.45, 0.62, 2.65), tint)
	_add_child_box(root, "CarCabin", Vector3(0, 1.08, -0.12), Vector3(1.18, 0.55, 1.28), Color(0.16, 0.22, 0.27))
	_add_child_box(root, "FrontGlass", Vector3(0, 1.12, -0.79), Vector3(1.08, 0.38, 0.06), Color(0.3, 0.48, 0.58))
	_add_child_box(root, "RearGlass", Vector3(0, 1.12, 0.55), Vector3(1.08, 0.38, 0.06), Color(0.3, 0.48, 0.58))
	_add_child_box(root, "FrontBumper", Vector3(0, 0.38, -1.34), Vector3(1.42, 0.18, 0.12), Color(0.12, 0.12, 0.13))
	_add_child_box(root, "RearBumper", Vector3(0, 0.38, 1.34), Vector3(1.42, 0.18, 0.12), Color(0.12, 0.12, 0.13))
	for side in [-1.0, 1.0]:
		for z in [-0.88, 0.88]:
			var wheel := MeshInstance3D.new()
			var cylinder := CylinderMesh.new()
			cylinder.top_radius = 0.27
			cylinder.bottom_radius = 0.27
			cylinder.height = 0.14
			wheel.mesh = cylinder
			wheel.rotation.z = PI * 0.5
			wheel.position = Vector3(side * 0.75, 0.32, z)
			var rubber := StandardMaterial3D.new()
			rubber.albedo_color = Color(0.025, 0.025, 0.028)
			wheel.material_override = rubber
			root.add_child(wheel)

func _move_vehicles(delta: float) -> void:
	for entry in cars:
		var vehicle := entry["node"] as Node3D
		if not is_instance_valid(vehicle):
			continue
		var speed := float(entry["speed"])
		var next_z := vehicle.position.z + speed * delta
		var should_stop := phase == 2 and vehicle.position.z < STOP_LINE_Z and next_z >= STOP_LINE_Z
		if phase == 2 and vehicle.position.z >= STOP_LINE_Z - 1.2 and vehicle.position.z < STOP_LINE_Z + 0.2:
			should_stop = true
		if should_stop:
			vehicle.position.z = minf(vehicle.position.z, STOP_LINE_Z - 1.2)
			continue
		if phase == 2 and vehicle.position.z >= STOP_LINE_Z - 1.2 and vehicle.position.z < STOP_LINE_Z:
			continue
		vehicle.position.z = next_z
		if vehicle.position.z > ROAD_MAX_Z:
			vehicle.position.z = ROAD_MIN_Z - 2.0

func _spawn_pedestrians() -> void:
	var specs := [
		{"x": -5.15, "z": -14.0, "speed": 0.8, "direction": 1.0, "shirt": Color(0.72, 0.22, 0.12)},
		{"x": 5.15, "z": 18.0, "speed": 0.65, "direction": -1.0, "shirt": Color(0.12, 0.38, 0.68)},
		{"x": 5.15, "z": -8.0, "speed": 0.72, "direction": 1.0, "shirt": Color(0.18, 0.52, 0.3)}
	]
	for i in range(specs.size()):
		var spec: Dictionary = specs[i]
		var person := Node3D.new()
		person.name = "SidewalkPedestrian_%02d" % i
		person.position = Vector3(float(spec["x"]), 0.0, float(spec["z"]))
		add_child(person)
		_build_pedestrian_model(person, spec["shirt"])
		pedestrians.append({"node": person, "speed": float(spec["speed"]), "direction": float(spec["direction"])})

func _build_pedestrian_model(root: Node3D, shirt_color: Color) -> void:
	_add_child_box(root, "Body", Vector3(0, 0.98, 0), Vector3(0.38, 0.62, 0.22), shirt_color)
	_add_child_box(root, "Head", Vector3(0, 1.48, 0), Vector3(0.3, 0.32, 0.3), Color(0.72, 0.53, 0.39))
	_add_child_box(root, "LeftLeg", Vector3(-0.11, 0.48, 0), Vector3(0.13, 0.48, 0.15), Color(0.12, 0.13, 0.16))
	_add_child_box(root, "RightLeg", Vector3(0.11, 0.48, 0), Vector3(0.13, 0.48, 0.15), Color(0.12, 0.13, 0.16))

func _move_pedestrians(delta: float) -> void:
	for entry in pedestrians:
		var person := entry["node"] as Node3D
		if not is_instance_valid(person):
			continue
		var direction := float(entry["direction"])
		person.position.z += float(entry["speed"]) * direction * delta
		if person.position.z > ROAD_MAX_Z - 2.0:
			entry["direction"] = -1.0
			person.rotation.y = PI
		elif person.position.z < ROAD_MIN_Z + 2.0:
			entry["direction"] = 1.0
			person.rotation.y = 0.0

func _add_box(object_name: String, at: Vector3, dimensions: Vector3, tint: Color) -> void:
	var mesh := MeshInstance3D.new()
	mesh.name = object_name
	var box := BoxMesh.new()
	box.size = dimensions
	mesh.mesh = box
	mesh.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	mesh.material_override = material
	add_child(mesh)

func _add_child_box(parent: Node3D, object_name: String, at: Vector3, dimensions: Vector3, tint: Color) -> void:
	var mesh := MeshInstance3D.new()
	mesh.name = object_name
	var box := BoxMesh.new()
	box.size = dimensions
	mesh.mesh = box
	mesh.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	mesh.material_override = material
	parent.add_child(mesh)
