extends Label
@export var game: GAME

func _process(_delta: float) -> void:
	text = "npc_tiempo: " + str(game.session_game.reaccion_npc)
