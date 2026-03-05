"
Recurso:
datos de la partida que cambian constantemente
"

extends Resource
class_name Game_Session

var dificultad_actual: GameManager.Dificultad = GameManager.Dificultad.facil
var ganador_del_juego: GameManager.Ganador = GameManager.Ganador.ninguno # ---> Variable para TERMINAR el juego
var ganador_definitivo: GameManager.Ganador = GameManager.Ganador.ninguno #---> Aumenta dificultad
var ganador_ronda: GameManager.Ganador = GameManager.Ganador.ninguno #---> quien gana la ronda (quien ataca en animación)

var reaccion_jugador: float
var reaccion_npc: float
var inicio_miliSegundos_ya: int #---> Cuanto ha tardado el jugador en hacer Click
var ronda_jugador_score: int = 0
var ronda_npc_score: int = 0

func marcar_inicio_reaccion_jugador():
	inicio_miliSegundos_ya = Time.get_ticks_msec()
	
func calcular_reaccion_jugador():
	reaccion_jugador = Time.get_ticks_msec() - inicio_miliSegundos_ya
	
func calcular_reaccion_npc(segundos: float):
	#reaccion_npc = sistema_tiempo.timer_npc.wait_time * 1000
	reaccion_npc = segundos
	
func decidir_ganador_definitivo(rondas: int):
	if ronda_jugador_score >= rondas:
		ganador_definitivo = GameManager.Ganador.jugador
	elif ronda_npc_score >= rondas:
		ganador_definitivo = GameManager.Ganador.npc
		
func hacer_ganar_al_npc_si_pierdes(segundos: float):
	reaccion_npc = segundos #convertir el tiempo del npc en miliSegundos
	#reaccion_npc = sistema_tiempo.timer_npc.wait_time * 1000 #convertir el tiempo del npc en miliSegundos
	reaccion_jugador = 99999999

func sumar_quien_gana_ronda():
	
	if reaccion_jugador < reaccion_npc:
		ganador_ronda = GameManager.Ganador.jugador
		aumentar_score_jugador()
	else:
		ganador_ronda = GameManager.Ganador.npc
		aumentar_score_npc()

func actualizar_dificultad(dificultad):
	if ganador_definitivo == GameManager.Ganador.ninguno:
		return
	
	var jugador = GameManager.Ganador.jugador
	var npc = GameManager.Ganador.npc
	
	match ganador_definitivo:
		jugador: #subir dificultad
			dificultad_actual = dificultad
			print("JUGADOR GANA!")
		npc: #bajar dificultad
			dificultad_actual = dificultad
			print("NPC GANA!")
	
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
	reaccion_jugador = 0
	reaccion_npc = 0
