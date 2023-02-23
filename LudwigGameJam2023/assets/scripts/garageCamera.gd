extends Camera2D

var targetPosition = Vector2.ZERO


func _ready():
	_camera_limit()


func _process(delta):
	aquire_target_position()
	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))

func aquire_target_position():
	var players = get_tree().get_nodes_in_group("playerFollow")
	if (players.size() > 0 ):
		var player = players[0]
		targetPosition = player.global_position

func _camera_limit():
	var tilemap_rect = get_node("../TileMap").get_used_rect()
	var tilemap_cell_size = get_node("../TileMap").cell_size
	$".".limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$".".limit_right = tilemap_rect.end.x * tilemap_cell_size.x
#	$".".limit_top = tilemap_rect.position.y * tilemap_cell_size.y 
	$".".limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
