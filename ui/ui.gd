extends Control

class_name UI

signal enviar_señal
signal ui_listo

@export var ya: Label
@onready var boton: Button = $Escena/Button


func _ready() -> void:
	ya.visible = false
	ui_listo.emit()
	


func YA_visible_label(booleano):
	ya.visible = booleano


func _cuando_presione_boton() -> void:
	enviar_señal.emit()
	
func desactivar_activar_boton(booleano):
	if boton: #Si hay boton ---> para que no Crashee con su nulo ñiñi
		boton.disabled = booleano


func _cuando_cambie_estado(estado: Variant) -> void:
	#USAR ENUM DEL GAME MANAGER -> CAMBIAR 0, 1, 2
	match estado:
		
		GameManager.Estado_juego.ESPERANDO:
			desactivar_activar_boton(false)
			YA_visible_label(false)
		GameManager.Estado_juego.YA:
			YA_visible_label(true)
		GameManager.Estado_juego.RESULTADO:
			YA_visible_label(false)
		GameManager.Estado_juego.PAUSA:
			desactivar_activar_boton(true)

#region UI

func convertir_enum_en_string(ganador) -> String:
	match ganador:
		GameManager.Ganador.jugador:
			return "jugador"
		GameManager.Ganador.npc:
			return "npc"
	return "ninguna"
	
func convertidor_dificultad_string(dificultad_ahora) -> String:
	match dificultad_ahora:
		
		GameManager.Dificultad.facil:
			return "facil"
		GameManager.Dificultad.media:
			return "media"
		GameManager.Dificultad.alta:
			return "alta"
	return "ninguna"


#endregion
