"
Recurso:
datos de la partida que cambian constantemente
"

extends Resource
class_name Game_Session

#region VARIABLES
#-------------------------------------------------------------------------------------------
var estado_actual: GameManager.Estado_juego = GameManager.Estado_juego.ESPERANDO

var dificultad_actual: GameManager.Dificultad = GameManager.Dificultad.facil
var ganador_del_juego: GameManager.Ganador = GameManager.Ganador.ninguno # ---> Variable para TERMINAR el juego
var ganador_definitivo: GameManager.Ganador = GameManager.Ganador.ninguno #---> Aumenta dificultad
var ganador_ronda: GameManager.Ganador = GameManager.Ganador.ninguno #---> quien gana la ronda (quien ataca en animación)

var reaccion_jugador: float
var reaccion_npc: float
var inicio_miliSegundos_ya: int #---> Cuanto ha tardado el jugador en hacer Click
var ronda_jugador_score: int = 0
var ronda_npc_score: int = 0
#-------------------------------------------------------------------------------------------
#endregion

							#FUNCIONES PARA USAR

func decidir_ganador_definitivo(rondas: int):
	if ronda_jugador_score >= rondas:
		ganador_definitivo = GameManager.Ganador.jugador
	elif ronda_npc_score >= rondas:
		ganador_definitivo = GameManager.Ganador.npc

func sumar_quien_gana_ronda(reglas: int):
	
	if reaccion_jugador < reaccion_npc:
		ganador_ronda = GameManager.Ganador.jugador
		aumentar_score_jugador(reglas)
	else:
		ganador_ronda = GameManager.Ganador.npc
		aumentar_score_npc(reglas)

func set_dificult(dificultad: GameManager.Dificultad):
						#region Nota

#Solo setea la dificultad


				#endregion
	
	if ganador_definitivo == GameManager.Ganador.ninguno:
		return
	dificultad_actual = dificultad

func limpiar_rondas():
	ronda_jugador_score = 0
	ronda_npc_score = 0

func limpiar_datos():
	ganador_ronda = GameManager.Ganador.ninguno
	ganador_definitivo = GameManager.Ganador.ninguno
	reaccion_jugador = 0
	reaccion_npc = 0	
	
func hacer_ganar_al_npc_si_pierdes(segundos: float):
	reaccion_npc = segundos #convertir el tiempo del npc en miliSegundos
	reaccion_jugador = 99999999
	
func aumentar_score_jugador(reglas: int):
	if ronda_jugador_score >=reglas:
		return
	ronda_jugador_score += 1
	
func aumentar_score_npc(reglas: int):
	if ronda_npc_score >=reglas:
		return
	ronda_npc_score += 1
	
func marcar_inicio_reaccion_jugador():
				#region Nota

#Guarda el tiempo actual en milisegundos
#para empezar a contar el tiempo del jugador en el inicio

				#endregion
	inicio_miliSegundos_ya = Time.get_ticks_msec()
	
func calcular_reaccion_jugador():
				#region Nota

#Calcula el tiempo de reacción del jugador
#Resta el tiempo actual con el tiempo inicial guardado
#Así sabremos cuanto tardó el jugador en reaccionar

				#endregion
	reaccion_jugador = Time.get_ticks_msec() - inicio_miliSegundos_ya
	
func calcular_reaccion_npc(segundos: float):
				#region Nota

#a diferencia del jugador: 
#--> el NPC no se calcula por tiempo <--
#solo convertimos su timer en mili segundos

				#endregion
	reaccion_npc = segundos
	
