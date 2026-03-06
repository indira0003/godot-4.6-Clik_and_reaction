extends Label

@export var game: GAME

var tiempo_actual #---> (BORRAR) lo usa Label (cuanto vale la dificultad actual)

func _process(_delta: float) -> void:
	text = "tiempo actual: " + str(game.tiempo_actual)
