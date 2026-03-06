extends Resource
class_name reglas_del_juego

#-------------------------------------------------------------------------------------------
#								VARIABLES
#-------------------------------------------------------------------------------------------
@export var rondas_para_ganar: int = 3 #Conseguir 3 rondas -> ganas
@export var pausa_segundos: float = 5.0 #---> en el estado pausa ESPERAR X segundos

@export var facil_dificultad: float = 0.5
@export var media_dificultad: float = 0.3
@export var alta_dificultad: float = 0.1
#-------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------
#								FUNCIONES PARA USAR
#-------------------------------------------------------------------------------------------
								#region Nota
								
#Esta funcion te cambia las dificultades del juego en Floats, usando las variables de
#este Script, si ganas 3 rondas seguidas, esta funcion se activa:
#Necesita un ENUM como parámetro para funcionar

#te puede dar esta 3 configuraciones:
#	1.-@export var facil_dificultad: float = 0.5
#	2.-@export var media_dificultad: float = 0.3
#	3.-@export var alta_dificultad: float = 0.1

								#endregion
func tiempo_diferente_por_dificultad(dificultad: GameManager.Dificultad) -> float:
	match dificultad:
		GameManager.Dificultad.facil: return facil_dificultad
		GameManager.Dificultad.media: return media_dificultad
		GameManager.Dificultad.alta: return alta_dificultad
	return facil_dificultad
#-------------------------------------------------------------------------------------------
								#region Nota
#Esta funcion tiene un límite para la dificultad máxima/minima a la
#que puedes llegar, esto evite numeros negativos o se sobrepase del máximo
								#endregion
func clamp_dificultad(valor: int) -> int:
	var min_dificultad = 0
	var max_dificultad = GameManager.Dificultad.size() - 1
	return clampi(valor, min_dificultad, max_dificultad)
#-------------------------------------------------------------------------------------------
									#region Nota
#Sube un nivel en la dificultad cuando ganas las 3 rondas
									#endregion
func subir_dificultad(dificultad_actual: int, ganador: GameManager.Ganador) -> int:
	if ganador == GameManager.Ganador.jugador:
		dificultad_actual += 1
	elif ganador == GameManager.Ganador.npc:
		dificultad_actual -= 1
	
	return clampi(dificultad_actual, 0, GameManager.Dificultad.size() - 1)
#-------------------------------------------------------------------------------------------
									#region Nota
#Convierte el timer del npc(reaccion) en mili segundos para poder darselo a
#Game y lo usa en el estado de "YA"
									#endregion
func mili_Segundos(dificultad: GameManager.Dificultad):
	var segundos = tiempo_diferente_por_dificultad(dificultad) * 1000 #<--- REGLAS DEL JUEGO 
	return segundos
	
func rondas_para_Win():
	return rondas_para_ganar
