extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -1000.0
const GRAVITY = 2000

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hikari: Sprite2D = $Hikari_Sprite

var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.






func _physics_process(delta):
	read_input()
	rotate_sprite()
	play_run_idle_animation()
	to_jump(delta)
	
	attack(delta)
	
	
	move_and_slide()

func play_run_idle_animation():
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
		was_running = true
	else:
		velocity.x = 0
	

func to_jump(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if not is_attacking:
			animation.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func attack(delta):
	var attacking = Input.is_action_just_pressed("atacar")
	
	if attacking and not is_attacking:
		animation.play("attack_1")
		attack_cooldown = 0.6
		is_attacking = true
	
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			if is_on_floor():
				animation.play("idle")
