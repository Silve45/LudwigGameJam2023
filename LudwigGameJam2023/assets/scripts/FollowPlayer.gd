extends KinematicBody2D

var blue = false
var gray = false
var red = false

onready var obj = get_parent().get_parent().get_parent().get_parent().get_node("Player")
onready var label = $Label
onready var despawnTimer = $despawn_timer
#export (PackedScene) var obj: PackedScene = null
export (int) var speed = 125
onready var sprite = $Sprite

#blue pieces
onready var pawnBlue = load("res://assets/sprites/gameSprites/ChessPieces/Blue/PawnBlue.png")
onready var kingBlue = load("res://assets/sprites/gameSprites/ChessPieces/Blue/KingBlue.png")
onready var bishopBlue = load("res://assets/sprites/gameSprites/ChessPieces/Blue/BishopBlue.png")
onready var queenBlue = load("res://assets/sprites/gameSprites/ChessPieces/Blue/QueenBlue.png")
onready var rookBlue = load("res://assets/sprites/gameSprites/ChessPieces/Blue/RookBlue.png")

#gray pieces
onready var pawnGray = load("res://assets/sprites/gameSprites/ChessPieces/Gray/PawnGray.png")
onready var kingGray = load("res://assets/sprites/gameSprites/ChessPieces/Gray/KingGray.png")
onready var bishopGray = load("res://assets/sprites/gameSprites/ChessPieces/Gray/BishopGray.png")
onready var queenGray = load("res://assets/sprites/gameSprites/ChessPieces/Gray/QueenGray.png")
onready var rookGray = load("res://assets/sprites/gameSprites/ChessPieces/Gray/RookGray.png")

#red pieces
onready var pawnRed = load("res://assets/sprites/gameSprites/ChessPieces/Red/PawnRed.png")
onready var kingRed = load("res://assets/sprites/gameSprites/ChessPieces/Red/KingRed.png")
onready var bishopRed = load("res://assets/sprites/gameSprites/ChessPieces/Red/BishopRed.png")
onready var queenRed = load("res://assets/sprites/gameSprites/ChessPieces/Red/QueenRed.png")
onready var rookRed = load("res://assets/sprites/gameSprites/ChessPieces/Red/RookRed.png")

func _ready():
	_choose_piece()

func _choose_color():
	var value
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pickedNumber = rng.randi_range(0, 2)
	match[pickedNumber]:
		[0]:
			blue = true
		[1]:
			gray = true
		[2]:
			red = true

func _choose_piece():
	_choose_color()
	var value
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pickedNumber = rng.randi_range(0, 4)
	if blue == true:
		match [pickedNumber]:
			[0]:
				sprite.set_texture(pawnBlue)
			[1]:
				sprite.set_texture(kingBlue)
			[2]:
				sprite.set_texture(bishopBlue)
			[3]:
				sprite.set_texture(queenBlue)
			[4]:
				sprite.set_texture(rookBlue)
	elif gray == true:
		match [pickedNumber]:
			[0]:
				sprite.set_texture(pawnGray)
			[1]:
				sprite.set_texture(kingGray)
			[2]:
				sprite.set_texture(bishopGray)
			[3]:
				sprite.set_texture(queenGray)
			[4]:
				sprite.set_texture(rookGray)
	elif red == true:
		match [pickedNumber]:
			[0]:
				sprite.set_texture(pawnRed)
			[1]:
				sprite.set_texture(kingRed)
			[2]:
				sprite.set_texture(bishopRed)
			[3]:
				sprite.set_texture(queenRed)
			[4]:
				sprite.set_texture(rookRed)

static func node_exists(node):
	if is_instance_valid(node) and node != null and \
		node is Node and node.is_inside_tree():
		return true
	return false

func _process(delta):
	label.set_text(str(int(despawnTimer.time_left)))

func _physics_process(delta):
	if node_exists(obj) == true:
		var dir = (obj.global_position - global_position).normalized()
#		rotation = dir.angle() #don't need rotation
		move_and_collide(dir * speed * delta)
	if node_exists(obj) == false:
		_success()

func _success():
	#when player is defeated
	pass

func _blow_up():
	#enemy will despawn on impact dealing damage to player
	#future animations will be here
	queue_free()

func _on_collisionBox_area_entered(area):
	_blow_up()


func _on_despawn_timer_timeout():
	_blow_up()
