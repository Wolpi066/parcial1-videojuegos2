extends Area2D

@export var velocidad = 40.0
@export var direccion = 1
# hasta donde llega para cada lado (las paredes estan en x = 32 y x = 288)
@export var limite_izquierdo = 42.0
@export var limite_derecho = 278.0

var aleteo = randf_range(0, 4)

@onready var sprite = $Sprite2D


func _physics_process(delta: float) -> void:
	position.x += velocidad * direccion * delta
	if position.x > limite_derecho:
		direccion = -1
	elif position.x < limite_izquierdo:
		direccion = 1

	# cuadros 16 a 19 de enemigos.png
	aleteo += delta * 10
	sprite.frame = 16 + int(aleteo) % 4


func _on_body_entered(body: Node2D) -> void:
	if body is Jugador:
		body.recibir_golpe()
