extends Control
class_name System_Animation 
#-------------------------------------------------------------
#					VARIABLES
var animacion_actual: Paquete_animaciones

@export var animacion_rondas: PackedScene
@export var animacion_cartas: PackedScene
@export var animacion_ganador_definitivo: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
#================================================================
#						ANIMACION

func play_animacion(ganador: GameManager.Ganador, animacion: PackedScene):
	#primero instancia, luego te da el paquete de animaciones tipado
	var paquete_animacion: Paquete_animaciones = instanciar_escena(animacion)
	conectar_señales(paquete_animacion) #se conecta a señal de terminar animacion
	
	await paquete_animacion.animacion_ganador(ganador)

#================================================================
	
func instanciar_escena(paquete_animacion: PackedScene) -> Paquete_animaciones:
	var animacion = paquete_animacion.instantiate()
	add_child(animacion)
	animacion_actual = animacion
	return animacion

func conectar_señales(señal: Paquete_animaciones):
	señal.animacion_termino.connect(_cuando_animacion_termine)

func eliminar_animacion():
	if animacion_actual: #si hay una animacion
		print("ELIMINAR ANIMACIOOOOON")
		animacion_actual.queue_free()
	
#-------------------------------------------------------------
#				ANIMATION fINISH
func _cuando_animacion_termine(): 
	eliminar_animacion()
