extends Label
@export var game: GAME

func _process(_delta: float) -> void:
	text = "tiempo_YA: " + str(game.sistema_tiempo.contador_ya.time_left)
	pass
