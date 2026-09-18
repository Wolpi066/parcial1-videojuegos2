extends Area2D

@export var velocidad = 35.0
# cuanto camina para cada lado desde donde lo puse
@export var distancia = 32.0

var inicio_x = 0.0
var direccion = 1
var anim = 0.0

@onready var sprite = $Sprite2D


func _ready() -> void:
	inicio_x = position.x


func _physics_process(delta: float) -> void:
	position.x += velocidad * direccion * delta
	if position.x > inicio_x + distancia:
		direccion = -1
	elif position.x < inicio_x - distancia:
		direccion = 1

	# los cuadros 10 y 11 miran a la derecha, para la izquierda lo doy vuelta
	anim += delta * 4
	sprite.frame = 10 + int(anim) % 2
	sprite.flip_h = direccion < 0


func _on_body_entered(body: Node2D) -> void:
	if body is Jugador:
		body.recibir_golpe()
