extends Label

@export var game: GAME

func _process(_delta: float) -> void:
	text = "ganador ronda: " + str(game.convertir_enum_en_string(game.session_game.ganador_ronda))
