extends Node2D
#class_name GAME

#ESTE SCRIPT NO SE USA, ES EL VIEJO

#-------------------------------------------------------------------------------------------
#								VARIABLES
@export var reglas: reglas_del_juego
@export var estado_actual: GameManager.Estado_juego = GameManager.Estado_juego.ESPERANDO
@export var dificultad_actual: GameManager.Dificultad = GameManager.Dificultad.facil
@export var sistema_animaciones: System_Animation

@onready var contador_YA: Timer = $contador_YA
@onready var timer_npc: Timer = $Timer_npc # ---> DIFICULTAD DEL JUEGO

var tiempo_jugador: float
var tiempo_npc: float
var inicio_miliSegundos_ya: int #---> Cuanto ha tardado el jugador en hacer Click

var ganador_del_juego: GameManager.Ganador = GameManager.Ganador.ninguno # ---> Variable para TERMINAR el juego
var ganador_definitivo: GameManager.Ganador = GameManager.Ganador.ninguno #---> Aumenta dificultad
var ganador_ronda: GameManager.Ganador = GameManager.Ganador.ninguno #---> quien gana la ronda (quien ataca en animación)
var ronda_jugador_score: int = 0
var ronda_npc_score: int = 0
var tiempo_actual #---> lo usa Label (cuanto vale la dificultad actual)

#-------------------------------------------------------------------------------------------
#							SIGNAL PERSONALIZADAS
signal estado_cambiado(estado)
signal borrar_ui
#-------------------------------------------------------------------------------------------



func _ready() -> void:
	timer_npc.wait_time = reglas.tiempo_diferente_por_dificultad(dificultad_actual)
	tiempo_actual = timer_npc.wait_time
	ir_a_estado(GameManager.Estado_juego.ESPERANDO)
	
	
func cambiar_estado(nuevo_estado):
	
	estado_actual = nuevo_estado
	estado_cambiado.emit(estado_actual) #Ui sabe el estado del jugego y actualiza
	tiempo_actual = timer_npc.wait_time #Esto es solo un Label para saber el tiempo de la dificultad
	
	match estado_actual:
		
		GameManager.Estado_juego.ESPERANDO:
			hacer_ganar_al_npc_si_pierdes()
			establecer_tiempo_NPC()
			iniciar_timer(contador_YA)
			
			
		GameManager.Estado_juego.YA:
			parar_timer(contador_YA)
			inicio_miliSegundos_ya = Time.get_ticks_msec()
			iniciar_timer(timer_npc)
			

		GameManager.Estado_juego.RESULTADO:
			parar_todos_los_timers()
			sumar_quien_gana_ronda()
			decidir_ganador_definitivo() #opcional si ganas
			actualizar_dificultad() #opcional si ganas
			
			ir_a_estado(GameManager.Estado_juego.ANIMACION)
				
		GameManager.Estado_juego.ANIMACION:
			if ganador_definitivo != GameManager.Ganador.ninguno:
				print("hay una animacion de CARTAS")
				limpiar_rondas()
				#poner animacion de CARTAS
				pass
				
			elif ganador_ronda:
				sistema_animaciones.play_animacion(ganador_ronda, sistema_animaciones.animacion_cartas)
			
			ir_a_estado(GameManager.Estado_juego.PAUSA)
			
			
		GameManager.Estado_juego.PAUSA:
			print("estado: pausa...")
			parar_todos_los_timers()
			await get_tree().create_timer(reglas.pausa_segundos).timeout
			
			if ganador_definitivo != GameManager.Ganador.ninguno: #si hay un ganador del juego
				ir_a_estado(GameManager.Estado_juego.FINAL)
				return
			
			ir_a_estado(GameManager.Estado_juego.ESPERANDO)
			limpiar_datos()
			
		GameManager.Estado_juego.FINAL:
			print("PANTALLA FINAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL")
			borrar_ui.emit()
			#pasarle por emit el ganador definitivo
			#End Game
			pass



func si_jugador_pulso_boton():
#-----------------JUGADOR---------------------

	match estado_actual:
		
		GameManager.Estado_juego.ESPERANDO:
			ir_a_estado(GameManager.Estado_juego.RESULTADO)
		
		GameManager.Estado_juego.YA:
			tiempo_jugador = Time.get_ticks_msec() - inicio_miliSegundos_ya
			tiempo_npc = timer_npc.wait_time * 1000 #convertir el tiempo del npc en miliSegundos
			
			parar_timer(timer_npc)
			ir_a_estado(GameManager.Estado_juego.RESULTADO)
			
	
func _cuando_tiempo_npc_termine() -> void:
	#-----------------NPC---------------------
	if estado_actual != GameManager.Estado_juego.YA:
		return
	hacer_ganar_al_npc_si_pierdes()
	ir_a_estado(GameManager.Estado_juego.RESULTADO)
	
func ir_a_estado(estado_nuevo):
	call_deferred("cambiar_estado", estado_nuevo)
	
func actualizar_dificultad():
	if ganador_definitivo == GameManager.Ganador.ninguno:
		return
	
	var jugador = GameManager.Ganador.jugador
	var npc = GameManager.Ganador.npc
	
	match ganador_definitivo:
		jugador: #subir dificultad
			dificultad_actual = reglas.siguiente_dificultad(dificultad_actual, GameManager.Ganador.jugador)
			print("JUGADOR GANA!")
		npc: #bajar dificultad
			dificultad_actual = reglas.siguiente_dificultad(dificultad_actual, GameManager.Ganador.npc)
			print("NPC GANA!")
			
		
func establecer_tiempo_NPC():
	timer_npc.wait_time = reglas.tiempo_diferente_por_dificultad(dificultad_actual)
	
func decidir_ganador_definitivo():
	if ronda_jugador_score >= reglas.rondas_para_ganar:
		ganador_definitivo = GameManager.Ganador.jugador
	if ronda_npc_score >= reglas.rondas_para_ganar:
		ganador_definitivo = GameManager.Ganador.npc

func sumar_quien_gana_ronda():
	
	if tiempo_jugador < tiempo_npc:
		ganador_ronda = GameManager.Ganador.jugador
		aumentar_score_jugador()
	else:
		ganador_ronda = GameManager.Ganador.npc
		aumentar_score_npc()
	
	

func hacer_ganar_al_npc_si_pierdes():
	tiempo_npc = timer_npc.wait_time * 1000 #convertir el tiempo del npc en miliSegundos
	tiempo_jugador = 99999999

func _cuando_tiempo_YA_termine() -> void:
	#MUEVE EL TIEMPO A ''YA''
	ir_a_estado(GameManager.Estado_juego.YA)
	
func aumentar_score_jugador():
	if ronda_jugador_score >=3:
		return
	ronda_jugador_score += 1
	
func aumentar_score_npc():
	if ronda_npc_score >=3:
		return
	ronda_npc_score += 1

func limpiar_rondas():
	ronda_jugador_score = 0
	ronda_npc_score = 0

func limpiar_datos():
	ganador_ronda = GameManager.Ganador.ninguno
	ganador_definitivo = GameManager.Ganador.ninguno
	tiempo_jugador = 0
	tiempo_npc = 0
	
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

func parar_timer(tiempo: Timer):
	tiempo.stop()

func parar_todos_los_timers():
	timer_npc.stop()
	contador_YA.stop()
	
func iniciar_timer(tiempo: Timer):
	tiempo.start()
	
func pausar_el_tiempo():
	await get_tree().create_timer(reglas.pausa_segundos).timeout
