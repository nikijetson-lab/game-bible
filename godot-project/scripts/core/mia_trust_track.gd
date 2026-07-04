extends Node
## MiaTrustTrack — невидима шкала довіри Міа (квест ep1-02 «Сім уроків болота»).
## Канон: quests/ep1-02-muri-shlyakh-kriz-boloto.md
## «Немає окремого екрану "довіра Міа = 67%". Шкала — невидима. Але вона рахує.»
##
## Кожен епізод дає +1 / 0 / -1. Підсумок по 7 епізодах визначає зустріч
## у Тихому Шелесті (пороги з квесту: +5..+7 / +2..+4 / -2..+1 / < -2).

signal trust_changed(new_value: int, episode_id: String)

# episode_id -> delta (записуємо кожен епізод один раз)
var _episode_results: Dictionary = {}

func record_episode(episode_id: String, delta: int) -> void:
	"""Записати результат епізоду уроків болота (+1/0/-1). Повторний запис ігнорується."""
	if _episode_results.has(episode_id):
		return
	delta = clampi(delta, -1, 1)
	_episode_results[episode_id] = delta
	trust_changed.emit(get_trust(), episode_id)
	print("MiaTrust: ", episode_id, " -> ", delta, " (total ", get_trust(), ")")

func get_trust() -> int:
	var total := 0
	for v in _episode_results.values():
		total += v
	return total

func episodes_done() -> int:
	return _episode_results.size()

func get_reception_tier() -> String:
	"""Пороги зустрічі в Тихому Шелесті — дослівно з квесту (рядки 170-176)."""
	var t := get_trust()
	if t >= 5:
		return "warm"        # Мурі без ворожості, відкривається навчання магії
	elif t >= 2:
		return "neutral"     # Нейтральне прийняття, Міа тримає дистанцію
	elif t >= -2:
		return "cold"        # Холодно; Міа виконала борг — провела
	else:
		return "distrust"    # Довіру доведеться завойовувати з нуля
