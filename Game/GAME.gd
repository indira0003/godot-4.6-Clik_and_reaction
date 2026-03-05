extends Node2D
class_name GAME

#region VARIABLES
#-------------------------------------------------------------------------------------------
#							Estado Actual
@export var estado_actual: GameManager.Estado_juego = GameManager.Estado_juego.ESPERANDO
#@export var dificultad_actual: GameManager.Dificultad = GameManager.Dificultad.facil

#							Recursos/objetos/nodos
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
	tiempo_actual = reglas.tiempo_diferente_por_dificultad(session_game.dificultad_actual)
	
	
func cambiar_estado(nuevo_estado):
	
	estado_actual = nuevo_estado
	estado_cambiado.emit(estado_actual) #Ui sabe el estado del jugego y actualiza
	tiempo_actual = reglas.tiempo_diferente_por_dificultad(session_game.dificultad_actual)
	
	match estado_actual:
		
		GameManager.Estado_juego.ESPERANDO:
			session_game.hacer_ganar_al_npc_si_pierdes(sistema_tiempo.convertir_tiempo_a_segundos())
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
				pass
				#he
				
			elif session_game.ganador_ronda:
				await sistema_animaciones.play_animacion(session_game.ganador_ronda, sistema_animaciones.animacion_cartas)
			
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
			session_game.actualizar_dificultad(reglas.siguiente_dificultad(session_game.dificultad_actual, session_game.ganador_definitivo))
			
			print(session_game.dificultad_actual)
			session_game.limpiar_rondas()
			
			#borrar_ui.emit()
			ir_a_estado(GameManager.Estado_juego.ESPERANDO)
			#pasarle por emit el ganador definitivo
			#End Game
			pass



func si_jugador_pulso_boton():
#-----------------JUGADOR---------------------

	match estado_actual:
		
		GameManager.Estado_juego.ESPERANDO:
			ir_a_estado(GameManager.Estado_juego.RESULTADO)
		
		GameManager.Estado_juego.YA:
			session_game.calcular_reaccion_jugador()
			session_game.calcular_reaccion_npc(reglas.mili_Segundos(session_game.dificultad_actual))
			sistema_tiempo.parar_todos_los_timers()
			ir_a_estado(GameManager.Estado_juego.RESULTADO)
			
	
func _cuando_tiempo_npc_termine() -> void:
	#-----------------NPC---------------------
	if estado_actual != GameManager.Estado_juego.YA:
		return
	session_game.hacer_ganar_al_npc_si_pierdes(sistema_tiempo.convertir_tiempo_a_segundos())
	ir_a_estado(GameManager.Estado_juego.RESULTADO)
	
func ir_a_estado(estado_nuevo):
	call_deferred("cambiar_estado", estado_nuevo)
	
	
func establecer_tiempo_NPC():
	var segundos: float =  reglas.tiempo_diferente_por_dificultad(session_game.dificultad_actual)
	return segundos
	sistema_tiempo.esperar_tiempo_NPC(segundos)

func _cuando_tiempo_YA_termine() -> void:
	#MUEVE EL TIEMPO A ''YA''
	ir_a_estado(GameManager.Estado_juego.YA)
	
	
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

func pausar_el_tiempo():
	await get_tree().create_timer(reglas.pausa_segundos).timeout

func connectar_señales():
	sistema_tiempo.tiempo_NPC_termino.connect(_cuando_tiempo_npc_termine)
	sistema_tiempo.tiempo_YA_termino.connect(_cuando_tiempo_YA_termine)
	
func iniciar_estado():
	ir_a_estado(GameManager.Estado_juego.ESPERANDO)
	
func iniciar_configuraciones():
	connectar_señales()
	establecer_tiempo_NPC()
	iniciar_estado()
