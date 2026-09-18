extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Jugador:
		$Sprite2D.frame = 1
		$Particulas.emitting = true
		body.ganar()
