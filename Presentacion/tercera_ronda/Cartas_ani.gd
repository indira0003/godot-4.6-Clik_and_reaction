extends Paquete_animaciones
class_name animacion_carta
#-------------------------------------------------------------
#					VARIABLES
@export var jugador_texture: TextureRect
@export var npc_texture: TextureRect

@export var y_arriba = -115.0
@export var y_abajo = 115.0

@onready var tiempo: Timer = $"animacion terminó"

#-------------------------------------------------------------

#================================================================
#					ANIMACION
func animacion_ganador(el_ganador):
	
	var datos: Dictionary = elegir_ganador_o_perdedor(el_ganador) #quien es el ganador o el perdedor
	#ganador: X
	#perdedor: X
	
	var carta_ganadora: TextureRect = datos["ganador"] #guarda al ganador del diccionario
	var carta_perdedora: TextureRect = datos["perdedor"] #guarda al perdedor del diccionario
	
	elegir_posicion_inicial_cartas(carta_ganadora, carta_perdedora) #Ganador.y: Abajo, Perdedor.y: Arriba 
	animar_Tween(carta_ganadora, carta_perdedora) #Anima ambas cartas al final
	
#================================================================


#-------------------------------------------------------------
#					FUNCS PARA USAR
	
func elegir_ganador_o_perdedor(el_ganador: GameManager.Ganador) -> Dictionary:
	if el_ganador == GameManager.Ganador.jugador:
		return {"ganador": jugador_texture, "perdedor": npc_texture}
	elif el_ganador == GameManager.Ganador.npc: #si el NPC GANA
		return {"ganador": npc_texture, "perdedor": jugador_texture}
	else: #Si no es ninguno
		return {} #vacio
#-------------------------------------------------------------
func elegir_posicion_inicial_cartas(carta_ganadora: TextureRect, carta_perdedora: TextureRect) -> void:
	carta_ganadora.position.y = y_abajo
	carta_perdedora.position.y = y_arriba
#-------------------------------------------------------------
func animar_Tween(carta_ganadora: TextureRect, carta_perdedora: TextureRect) -> void:
	#Creacion de Tween, animacion paralela y curva bezier
	var animacion_tween = get_tree().create_tween()
	animacion_tween.set_parallel(true)
	animacion_tween.set_ease(Tween.EASE_IN_OUT)
	animacion_tween.set_trans(Tween.TRANS_QUART)
	
	#Ganador Y: arriba
	animacion_tween.tween_property(carta_ganadora, "position:y", y_arriba, duracion_animacion)
	
	#Perdedor Y: abajo
	animacion_tween.tween_property(carta_perdedora, "position:y", y_abajo, duracion_animacion)
	await animacion_tween.finished
	tiempo.start()
	


func _cuando_tiempo_termine() -> void:
	animacion_termino.emit()
