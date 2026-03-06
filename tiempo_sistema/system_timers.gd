extends Node2D

class_name System_timers

@onready var contador_ya: Timer = $contador_YA
@onready var timer_jugador: Timer = $Timer_jugador
@onready var timer_npc: Timer = $Timer_npc

signal tiempo_YA_termino
signal tiempo_NPC_termino

func parar_timer(tiempo: Timer):
	print("se ha parado el timer")
	tiempo.stop()

func parar_todos_los_timers():
	timer_npc.stop()
	contador_ya.stop()
	
func iniciar_timer_contador_ya():
	contador_ya.start()

func iniciar_timer_npc():
	timer_npc.start()

func hacer_pausa(tiempo: float):
	await get_tree().create_timer(tiempo).timeout
	
func cuando_contador_YA_termine() -> void:
	tiempo_YA_termino.emit()

func cuando_contador_npc_termine() -> void:
	tiempo_NPC_termino.emit()
	
func esperar_tiempo_NPC(segundos: float):
	timer_npc.wait_time = segundos
	
func convertir_tiempo_npc_a_ms() -> float:
	var tiempo_a_segundos = timer_npc.wait_time * 1000
	return tiempo_a_segundos
	
func esperar_npc_timer():
	var segundos = convertir_tiempo_npc_a_ms()
	esperar_tiempo_NPC(segundos)
