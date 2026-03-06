extends Node2D
class_name GAME

#region VARIABLES
#-------------------------------------------------------------------------------------------
#							Recursos/objetos/nodos
@export var ui: UI
@export var sistema_animaciones: System_Animation
@export var sistema_tiempo: System_timers
@export var reglas: reglas_del_juego
@export var session_game: Game_Session
#-------------------------------------------------------------------------------------------
var tiempo_actual #---> (BORRAR) lo usa Label (cuanto vale la dificultad actual)
#-------------------------------------------------------------------------------------------
#							SIGNAL PERSONALIZADAS
signal estado_cambiado(estado)
signal borrar_ui
#-------------------------------------------------------------------------------------------
#endregion


func _ready() -> void:
	iniciar_configuraciones()
	tiempo_actual = reglas.tiempo_diferente_por_dificultad(session_game.dificultad_actual) #BASURA, BORRAR
	
	
func cambiar_estado(nuevo_estado):
	session_game.estado_actual = nuevo_estado #actualizar estado
	estado_cambiado.emit(session_game.estado_actual) #Ui sabe el estado del jugego y actualiza
	tiempo_actual = reglas.tiempo_diferente_por_dificultad(session_game.dificultad_actual) #BORRAR LUEGO
	
	match session_game.estado_actual:
		
		GameManager.Estado_juego.ESPERANDO:
			hacer_ganar_al_npc_si_pierdes()
			establecer_tiempo_NPC()
			sistema_tiempo.iniciar_timer_contador_ya() #contador YA
			
			
		GameManager.Estado_juego.YA:
			print("estamos en YAAAAAAAAAA")
			sistema_tiempo.parar_todos_los_timers()
			session_game.marcar_inicio_reaccion_jugador()
			sistema_tiempo.iniciar_timer_npc()
			
			
		GameManager.Estado_juego.RESULTADO:
			sistema_tiempo.parar_todos_los_timers()
			session_game.sumar_quien_gana_ronda()
			session_game.decidir_ganador_definitivo(reglas.rondas_para_Win()) #opcional si ganas
			ir_a_estado(GameManager.Estado_juego.ANIMACION)
			
			
		GameManager.Estado_juego.ANIMACION:
			if session_game.ganador_definitivo != GameManager.Ganador.ninguno:
				print("hay una animacion de CARTAS")
				#poner animacion de CARTAS
			elif session_game.ganador_ronda:
				await play_anim(
					session_game.ganador_ronda, 
					sistema_animaciones.animacion_cartas)
			ir_a_estado(GameManager.Estado_juego.PAUSA)
			
			
		GameManager.Estado_juego.PAUSA:
			print("estado: pausa...")
			sistema_tiempo.parar_todos_los_timers()
			await sistema_tiempo.hacer_pausa(reglas.pausa_segundos)
			if session_game.ganador_definitivo != GameManager.Ganador.ninguno: #si hay un ganador del juego
				ir_a_estado(GameManager.Estado_juego.FINAL)
				return
			session_game.limpiar_datos()
			ir_a_estado(GameManager.Estado_juego.ESPERANDO)
			
			
		GameManager.Estado_juego.FINAL:
			print("PANTALLA FINAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL")
			subir_lvl()
			session_game.limpiar_datos()
			session_game.limpiar_rondas()
			#borrar_ui.emit()
			ir_a_estado(GameManager.Estado_juego.ESPERANDO)
			#pasarle por emit el ganador definitivo
			#End Game




func si_jugador_pulso_boton():
#-----------------JUGADOR---------------------

	match session_game.estado_actual:
		
		GameManager.Estado_juego.ESPERANDO:
			ir_a_estado(GameManager.Estado_juego.RESULTADO)
		
		GameManager.Estado_juego.YA:
			session_game.calcular_reaccion_jugador()
			session_game.calcular_reaccion_npc(reglas.mili_Segundos(session_game.dificultad_actual))
			sistema_tiempo.parar_todos_los_timers()
			ir_a_estado(GameManager.Estado_juego.RESULTADO)
			
	
func _cuando_tiempo_npc_termine() -> void:
	#-----------------NPC---------------------
	if session_game.estado_actual != GameManager.Estado_juego.YA:
		return
	
	session_game.hacer_ganar_al_npc_si_pierdes(sistema_tiempo.convertir_tiempo_a_segundos())
	ir_a_estado(GameManager.Estado_juego.RESULTADO)
	
	
func ir_a_estado(estado_nuevo):
	call_deferred("cambiar_estado", estado_nuevo)
	
	
func establecer_tiempo_NPC():
										#region Nota
										
#lo que hace: 
# --> timer_npc.wait_time = segundos <--

#es decir al timer del npc le va a añadir los SEGUNDOS de la dificultad -- >ACTUAL <--

#Facil:
#	segundos = 0.5 (revisa si se ha cambiado)
#Media:
#	segundos = 0.3 (revisa si se ha cambiado)
#Alta:
#	segundos = 0.1 (revisa si se ha cambiado)


										#endregion
	var segundos: float =  reglas.tiempo_diferente_por_dificultad(session_game.dificultad_actual)
	sistema_tiempo.esperar_tiempo_NPC(segundos)
	return segundos

func _cuando_tiempo_YA_termine() -> void:
	ir_a_estado(GameManager.Estado_juego.YA)
	
	
func connectar_señales():
	sistema_tiempo.tiempo_NPC_termino.connect(_cuando_tiempo_npc_termine)
	sistema_tiempo.tiempo_YA_termino.connect(_cuando_tiempo_YA_termine)
	
func iniciar_estado():
	ir_a_estado(GameManager.Estado_juego.ESPERANDO)
	
func iniciar_configuraciones():
	connectar_señales()
	establecer_tiempo_NPC()
	iniciar_estado()

func hacer_ganar_al_npc_si_pierdes():
							#region Nota
#reaccion_npc = su timer * 1000 convertir a mili segundos
#reaccion_jugador = 99999999

#Al empezar le das al jugador 99999999999 un numero alto, por si tú le das
#click al comenzar la partida, ademas al npc le das su segundos de reaccion
									#endregion
	session_game.hacer_ganar_al_npc_si_pierdes(
		sistema_tiempo.convertir_tiempo_a_segundos()
		)

func subir_lvl():
	var new_dificult = reglas.subir_dificultad(
		session_game.dificultad_actual, 
		session_game.ganador_definitivo
		)
	
	session_game.set_dificult(new_dificult)
	
func play_anim(ganador: GameManager.Ganador, animacion: PackedScene):
	await sistema_animaciones.play_animacion(ganador, animacion)
	
	
