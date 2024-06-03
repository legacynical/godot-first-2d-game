extends Area2D
signal hit

@export var speed = 400 # player move speed (pixels/sec)
var screen_size # size of game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


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

	if velocity.x != 0: # if moving left or right
		$AnimatedSprite2D.animation = "walk" # name is cap sensitive!
		$AnimatedSprite2D.flip_v = false # ensures sprite isn't vert flipped
		$AnimatedSprite2D.flip_h = velocity.x < 0 # sprite (facing right) flips only if moving left
	elif velocity.y != 0: # if moving up or down without left/right movement
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # sprite (facing up) flips only if moving down
		

func _on_body_entered(body):
	hide() # player disappears after being hit
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
		# disables collision after hit to prevent multiple hit signal triggers
		# Disabling the area's collision shape can cause an error if it happens in the middle of the
		# engine's collision processing. Using set_deferred() tells Godot to wait to disable the 
		# shape until it's safe to do so.
		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false	
