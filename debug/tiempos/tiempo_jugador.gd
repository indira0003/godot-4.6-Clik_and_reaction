extends Label
@export var game: GAME

func _process(_delta: float) -> void:
	text = "jugador_tiempo " + str(game.session_game.reaccion_jugador)
	pass
