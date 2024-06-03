extends Area2D

@export var speed = 400 # player move speed (pixels/sec)
var screen_size # size of game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # player movement vector (direction)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# normalize sets diagonal length consistent to hori/vert movement to prevent faster diagonal speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed 
		$AnimatedSprite2D.play() # $ is shorthand for get_node() [1/3]
	else:
		$AnimatedSprite2D.stop() # get_node("AnimatedSprite2D").stop() [2/3]
	# In GDScript $ returns relative node path from current node or null if not found.
	# Since AnimatedSprite2D is child of current node, we can use $AnimatedSprite2D [3/3]
	
	position += velocity * delta # updates player position
	position = position.clamp(Vector2.ZERO, screen_size) # clamping to prevent player leaving screen
