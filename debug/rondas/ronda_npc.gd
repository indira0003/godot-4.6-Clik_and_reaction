extends Label

@export var game: GAME

func _process(_delta: float) -> void:
	text = "Ronda npc: " + str(game.session_game.ronda_npc_score)
