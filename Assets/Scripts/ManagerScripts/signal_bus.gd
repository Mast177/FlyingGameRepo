extends Node

@warning_ignore("unused_signal")
signal waves_finished(level_number : int)

@warning_ignore("unused_signal")
signal level_complete(level_number : int)

@warning_ignore("unused_signal")
signal player_died()

@warning_ignore("unused_signal")
signal update_player_stats(health : int, damage : int, speed : float, weapon_count : int, shield : int)

@warning_ignore("unused_signal")
signal enter_level()
