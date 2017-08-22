extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
#tiles preloading
var grassTileGreen = preload("greenGrass_item.tscn");
var grassTileGreen1 = preload ("greenGrass_item1.tscn");
var grassTileGreen2 = preload ("greenGrass_item3.tscn")


var earthTile1 = preload ("dirt_item1.tscn")
var earthTile2 = preload ("dirt_item_2.tscn")

var positionOnMap = 0 #the position of the last tile.
var camPos = 0
var playerPosition = 120
var coinCounter = 0
var lives = 3

var lastSprite = 0

func _ready():
	createGround()
	get_node("KinematicBody2D/Camera2D").make_current()
	set_process(true)
	get_node ("KinematicBody2D").set_pos(Vector2(120, 80))

func createGround():
	while (positionOnMap < 240):
		randomize()
		var randomSprite = randi ()%3
		if (randomSprite == 0):
			lastSprite = grassTileGreen.instance()
		elif (randomSprite == 1):
			lastSprite = grassTileGreen1.instance()
		else:
			lastSprite = grassTileGreen2.instance()
		add_child (lastSprite)
		lastSprite.set_pos(Vector2(positionOnMap, 108))
		addEarthBeneath (108+16)
		positionOnMap += 16
	positionOnMap -= 16


func _process(delta):
	playerPosition = get_node ("KinematicBody2D").get_pos().x
	moveCharacter(delta)
	goToGround (delta)
	if (playerPosition + 240 > positionOnMap):
		addTile()

func addTile ():
	positionOnMap += 16
	var tileHeight = randi ()% 7
	randomize()
	var randomSprite = randi ()%3
	if (randomSprite == 0):
		lastSprite = grassTileGreen.instance()
	elif (randomSprite == 1):
		lastSprite = grassTileGreen1.instance()
	else:
		lastSprite = grassTileGreen2.instance()
	add_child (lastSprite)
	lastSprite.set_pos(Vector2(positionOnMap, tileHeight * 16))
	addEarthBeneath ((tileHeight +1) * 16)

func addEarthBeneath (var tileHeight):
	while (tileHeight < 240):
		randomize()
		var randomSprite = randi ()%2
		if (randomSprite == 0):
			lastSprite = earthTile2.instance()
		elif (randomSprite == 1):
			lastSprite = earthTile1.instance()
		add_child (lastSprite)
		lastSprite.set_pos (Vector2(positionOnMap, tileHeight))
		tileHeight += 16

func goToGround (var delta):
	get_node("KinematicBody2D").move(Vector2(0, delta * 80))

func moveCharacter (var delta):
	if (Input.is_key_pressed(KEY_UP) && get_node("KinematicBody2D/RayCast2D").is_colliding()):
		for c in range (16):
			get_node("KinematicBody2D").move (Vector2(0, -1))
	if (Input.is_key_pressed(KEY_RIGHT)):
		get_node("KinematicBody2D").move(Vector2(delta * 30, 0))
		get_node("KinematicBody2D/Image70000").set_flip_h(false)
	if (Input.is_key_pressed(KEY_LEFT)):
		get_node("KinematicBody2D").move(Vector2(delta * -30, 0))
		get_node("KinematicBody2D/Image70000").set_flip_h(true)
