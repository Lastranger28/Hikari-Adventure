extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hikari: Sprite2D = $Hikari_Sprite

var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
		# Add the gravity.
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	read_input()
	walking()
	rotate_sprite()
	play_run_idle_animation()
	to_jump(delta)
	move_and_slide()
	attack(delta)

			
func play_run_idle_animation() -> void:
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation.play("walking")
			else:
				animation.play("idle")

func rotate_sprite():
		
	if Input.is_action_just_pressed("mover_direita"):
		hikari.flip_h = false
	elif Input.is_action_just_pressed("mover_esquerda"):
		hikari.flip_h = true

func read_input ():
	var direction = Input.get_axis("mover_esquerda", "mover_direita")
	if direction and not is_attacking:
		velocity.x = direction * SPEED
		animation.play("walking")
		was_running = true
	else:
		velocity.x = 0
		
func to_jump(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		animation.play("jump")
		
	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func walking():
	var moviment = Input.get_axis("mover_direita", "mover_esquerda")
	
	if moviment:
		is_running = true
	else:
		is_running = false

func attack(delta):
	var attacking = Input.is_action_just_pressed("atacar")
	
		
	if attacking:
		animation.play("attack_1")
		attack_cooldown = 0.6
		is_attacking = true
		
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation.play("idle")
	








func to_jump(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if not is_attacking:
			$AnimationPlayer.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func attack(delta):
	var attacking = Input.is_action_just_pressed("atacar")
	
	if attacking and not is_attacking:
		$AnimationPlayer.play("attack_1")
		attack_cooldown = 0.6
		is_attacking = true
	
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			if is_on_floor():
				$AnimationPlayer.play("idle")

func apply_movement(delta):
	move_and_slide()
	if is_on_floor() and not is_attacking:
		if abs(velocity.x) > 0:
			$AnimationPlayer.play("run")
		else:
			$AnimationPlayer.play("idle")
