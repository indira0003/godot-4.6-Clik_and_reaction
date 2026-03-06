extends Paquete_animaciones
class_name Rondas
@onready var recuadro: TextureRect = $MarginContainer/TextureRect
@onready var foto_personaje: TextureRect = $MarginContainer/TextureRect/TextureRect

func animacion_ganador(el_ganador):
	
	if el_ganador == GameManager.Ganador.jugador:
	
		pass
		
	elif el_ganador == GameManager.Ganador.npc:
	
		pass
	


#te dan ganador y animacion

#si el ganador es jugador
#mostrar imagen de jugador

#si jugador es npc
#mostrar imagen del npc
