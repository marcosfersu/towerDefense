extends Node3D

@export var tile_end: PackedScene
@export var tile_straight: PackedScene
@export var tile_corner: PackedScene
@export var tile_empty: PackedScene
@export var tile_crossing: PackedScene

@export var map_length: int = 16
@export var map_height: int = 10

@export var loop: bool = true
@export var min_path_size = 50
@export var max_path_size = 70
@export var min_loops = 3
@export var max_loops = 5

var _pg: PathGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()
	
func _complete_grid():
	for x in range(map_length):
		for y in range(map_height):
			if not _pg.get_path().has(Vector2i(x,y)):
				var tile: Node3D = tile_empty.instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
				
func _display_path():
	var iteration_count: int = 1
	_pg.generate_path(true)

	while _pg.get_path().size() < min_path_size or _pg.get_path().size() > max_path_size or _pg.get_loop_count() < min_loops or _pg.get_loop_count() > max_loops:
		iteration_count += 1
		_pg.generate_path(true)

	print("Generated a path of %d tiles after %d iterations" % [_pg.get_path().size(), iteration_count])
	print(_pg.get_path())
	
	
	for i in range(_pg.get_path().size()):
		var tile_score: int = _pg.get_tile_score(i)
		
		var tile: Node3D = tile_empty.instantiate()
		var tile_rotation: Vector3 = Vector3.ZERO
		
		if tile_score == 2:
			tile = tile_end.instantiate()
			tile_rotation = Vector3(0,-90,0)
		elif tile_score == 8:
			tile = tile_end.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 10:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 1 or tile_score == 4 or tile_score == 5:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 6:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,180,0)
		elif tile_score == 12:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 9:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 3:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,270,0)
		elif tile_score == 15:
			tile = tile_crossing.instantiate()
			tile_rotation = Vector3(0,0,0)
			
		add_child(tile)
		tile.global_position = Vector3(_pg.get_path_tile(i).x, 0, _pg.get_path_tile(i).y)
		tile.global_rotation_degrees = tile_rotation
