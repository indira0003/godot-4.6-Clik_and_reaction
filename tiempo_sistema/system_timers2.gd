extends Node2D

#class_name System_timers
#ESTE SCRIPT NO SE USA, ES EL VIEJO

@onready var contador_ya: Timer = $contador_YA
@onready var timer_jugador: Timer = $Timer_jugador
@onready var timer_npc: Timer = $Timer_npc
var inicio_miliSegundos_ya: int #---> Cuanto ha tardado el jugador en hacer Click

var tiempo_npc
var tiempo_jugador

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
	
func cuando_contador_YA_termine() -> void:
	tiempo_YA_termino.emit()

func cuando_contador_npc_termine() -> void:
	tiempo_NPC_termino.emit()
	
func esperar_tiempo_NPC(segundos):
	timer_npc.wait_time = segundos
	
func convertir_a_segundos():
	var segundo = 1000
	timer_npc.wait_time * segundo

func convertir_a_segundos_npc():
	var segundo = 1000
	tiempo_npc = timer_npc.wait_time * segundo #convertir el tiempo del npc en miliSegundos
	
func convertir_segundos_jugador():
	#tiempo_jugador = Time.get_ticks_msec() - inicio_miliSegundos_ya
	tiempo_jugador = Time.get_ticks_msec() - inicio_miliSegundos_ya
	
func añadir_tiempo_milisegundos():
	inicio_miliSegundos_ya = Time.get_ticks_msec()
	
func hacer_ganar_al_npc_si_pierdes():
	convertir_a_segundos_npc()
	tiempo_jugador = 99999999
	
func limpiar_tiempo():
	tiempo_npc = 0
	tiempo_jugador = 0	
