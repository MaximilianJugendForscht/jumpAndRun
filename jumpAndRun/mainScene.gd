extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
#tiles preloading
var grassTileGreen = preload("greenGrass_item.tscn");
var grassTileGreen1 = preload ("greenGrass_item1.tscn");
var grassTileGreen2 = preload ("greenGrass_item3.tscn")

var fallingAnim1 = preload ("falling0000.png")
var fallingAnim2 = preload ("falling0001.png")
var fallingAnim3 = preload ("falling0002.png")

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
	get_node("Camera2D").make_current()
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



func addTile ():
	positionOnMap += 16
	var tileHeight = randi ()% 4 +4
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








#########################################################################
#########################################################################
#########################################################################
#########################################################################









var right = true

func _process(delta):
	if (get_node ("AnimationPlayer").is_playing() != true):
		playerPosition = get_node ("KinematicBody2D").get_pos().x
		get_node ("Camera2D").set_pos(Vector2(round(get_node("KinematicBody2D").get_pos().x), 80))
		moveCharacter(delta)
		goToGround (delta)
		if (playerPosition + 240 > positionOnMap):
			addTile()
		jump()
	else:
		goToGround(delta)
		jump()
		if (right == true):
			if (Input.is_key_pressed(KEY_LEFT)  && !(Input.is_key_pressed(KEY_RIGHT))):
				right = false
				get_node("KinematicBody2D").set_scale(Vector2(-1, 1))
				get_node ("AnimationPlayer").play("walkingAnimation")
			get_node ("KinematicBody2D").move (Vector2(50 * delta, 0))
			
		elif (right == false):
			if (Input.is_key_pressed(KEY_RIGHT) && !(Input.is_key_pressed(KEY_LEFT))):
				right = true
				get_node("KinematicBody2D").set_scale(Vector2(1, 1))
				get_node ("AnimationPlayer").play("walkingAnimation")
			get_node ("KinematicBody2D").move (Vector2(-50*delta, 0))

func goToGround (var delta):
	get_node("KinematicBody2D").move(Vector2(0, delta * 80))

func moveCharacter (var delta):
	print (get_node ("KinematicBody2D/right").get_collider())
	if (Input.is_key_pressed(KEY_RIGHT)):
		right = true
		get_node("KinematicBody2D").set_scale(Vector2(1, 1))
		if ((get_node("KinematicBody2D/right").is_colliding() == false)):
			get_node ("AnimationPlayer").play("walkingAnimation")

	if (Input.is_key_pressed(KEY_LEFT)):
		right = false
		get_node("KinematicBody2D").set_scale(Vector2(-1, 1))
		if ((get_node("KinematicBody2D/right").is_colliding() == false)):
			get_node ("AnimationPlayer").play("walkingAnimation")

func jump ():
	if (Input.is_action_pressed("ui_up")):
		if (get_node ("KinematicBody2D/RayCast2D").is_colliding()):
			get_node ("KinematicBody2D").move (Vector2(0, -45))