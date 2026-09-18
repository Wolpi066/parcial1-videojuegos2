extends CharacterBody2D
class_name Jugador

@export var velocidad = 110.0
@export var fuerza_salto = -290.0
@export var gravedad = 900.0
@export var caida_maxima = 420.0

# coyote time: puede saltar un toque despues de caerse del borde
# buffer: si aprieta saltar justo antes de tocar el piso, salta igual
const COYOTE_TIME = 0.1
const BUFFER_SALTO = 0.12

var vida = 3
var monedas = 0
var invulnerable = 0.0
var tiempo_coyote = 0.0
var tiempo_buffer = 0.0
var gano = false

@onready var animacion = $AnimatedSprite2D
@onready var sonido_salto = $SonidoSalto
@onready var hud = $CanvasLayer/HUD


func _physics_process(delta: float) -> void:
	if gano:
		return

	velocity.y += gravedad * delta
	if velocity.y > caida_maxima:
		velocity.y = caida_maxima

	var direccion = Input.get_axis("move_left", "move_right")
	velocity.x = direccion * velocidad

	if is_on_floor():
		tiempo_coyote = COYOTE_TIME
	else:
		tiempo_coyote -= delta

	if Input.is_action_just_pressed("jump"):
		tiempo_buffer = BUFFER_SALTO
	else:
		tiempo_buffer -= delta

	if tiempo_buffer > 0 and tiempo_coyote > 0:
		saltar()

	# medio transparente mientras es invulnerable
	if invulnerable > 0:
		invulnerable -= delta
		animacion.modulate.a = 0.5
	else:
		animacion.modulate.a = 1

	move_and_slide()
	animar(direccion)
	actualizar_hud()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func saltar():
	velocity.y = fuerza_salto
	tiempo_coyote = 0
	tiempo_buffer = 0
	sonido_salto.play()


func animar(direccion):
	if direccion != 0:
		animacion.flip_h = direccion < 0

	if not is_on_floor():
		# si ya esta saltando no la reinicio, que se quede en el ultimo cuadro
		if animacion.animation != "saltar":
			animacion.play("saltar")
	elif direccion != 0:
		animacion.play("correr")
	else:
		animacion.play("quieta")


func recibir_golpe():
	if invulnerable > 0:
		return
	vida -= 1
	invulnerable = 1.0
	velocity.y = -200
	if vida <= 0:
		# si recargo directo tira error, porque esto viene de una señal de fisica
		get_tree().call_deferred("reload_current_scene")


func agarrar_moneda():
	monedas += 1


func ganar():
	gano = true
	animacion.hide()
	hud.text = "¡LLEGASTE AL FONDO! Monedas: %d\nApretá R para jugar de nuevo" % monedas


func actualizar_hud():
	var metros = int(position.y / 16)
	hud.text = "Vida: %d   Monedas: %d   %d m" % [vida, monedas, metros]
