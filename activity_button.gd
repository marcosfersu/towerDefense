extends Button

@export var activity_button_icon: Texture2D
@export var activity_draggable: PackedScene

var _is_dragging: bool = false
var _draggable: Node
var _cam: Camera3D
var RAYCAST_LENGTH: float = 100

func _ready():
	icon = activity_button_icon
	_draggable = activity_draggable.instantiate()
	add_child(_draggable)
	_draggable.visible = false
	_cam = get_viewport().get_camera_3d()

func _physics_process(_delta):
	if _is_dragging:
		var space_state = _draggable.get_world_3d().direct_space_state
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = _cam.project_ray_origin(mouse_pos)
		var end:Vector3 = origin + _cam.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var rayResult:Dictionary = space_state.intersect_ray(query)
		if rayResult.size() > 0:
			var co:CollisionObject3D = rayResult.get("collider")
			_draggable.visible = true
			_draggable.global_position = Vector3(co.global_position.x, 0.2, co.global_position.z)
		else:
			_draggable.visible = false
		
func _on_button_down():
	print("Button down")
	_is_dragging = true


func _on_button_up():
	_draggable.visible = false
	_is_dragging = false
