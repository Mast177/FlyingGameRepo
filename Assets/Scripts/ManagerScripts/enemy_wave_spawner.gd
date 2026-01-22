extends Node2D

@export var level_number := 1

@export var waves : Array[Wave]
@export_group("Wave Timing")
@export var wave_cooldown : float = 10.0	## time between waves
@export var spawn_interval : float = 1.0	## time between each enemy spawning

@export_group("Wave Parameters")
@export_enum("Spawn One", "Spawn In Line", "Random Spawn", "Left To Right",\
"Right To Left", "Spawn In Arrow Down", "Test") var SPAWN_BEHAVIOR: String = "Random Spawn"
@export var spawn_index := 0	##The specific spawn index which you want to start spawning at
@export var enemy_index := 0	##The index of an enemy in enemy array ("used for Spawn One")

@onready var main = get_tree().get_first_node_in_group("main")
@onready var spawn_points : Array[Node2D] = []

var current_wave_num := 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	##
	## set game_manager current level
	##
	GameManager.current_level = level_number
	
	
	##
	## add all spawnpoints to the array of spawnpoints
	##
	await get_tree().process_frame #wait for container to update global position of children
	for child in $Control/SpawnLine.get_children():
		if child.get_child(0).is_in_group("spawn_point"):
			spawn_points.append(child.get_child(0))
	
	##
	##set spawn behavior from first wave resource
	##
	if waves:
		SPAWN_BEHAVIOR = waves[current_wave_num].WAVE_SPAWN_BEHAVIOR
		spawn_index = waves[current_wave_num].spawn_index
		enemy_index = waves[current_wave_num].enemy_index
	
		spawn_interval = waves[current_wave_num].spawn_interval
		wave_cooldown = waves[current_wave_num].wave_cooldown
	
	##
	##begin spawning in enemies
	##
	$EnemySpawnTimer.start(spawn_interval)
	$WaveCooldownTimer.start(wave_cooldown)
	
	if waves:
		start_spawn_behavior()

func start_spawn_behavior():
	match SPAWN_BEHAVIOR:
		"Spawn One":
			spawn_one(spawn_index, enemy_index)
		"Spawn In Line":
			spawn_in_line(spawn_index)
		"Random Spawn":
			spawn_random_position()
		"Left To Right":
			spawn_left_to_right(spawn_index)
		"Right To Left":
			spawn_right_to_left(spawn_index)
		"Spawn In Arrow Down":
			spawn_arrow_down(spawn_index)
		"Test":
			pass
			test_spawn(spawn_index)

func test_spawn(index : int = 0):
	for scene in waves[current_wave_num].enemy_wave:
		if scene:
			var instance = scene.instantiate()
			var spawnpoint = get_spawnpoint(index).global_position
			instance.spawnPos = spawnpoint
			instance.add_to_group("enemy")
			main.add_child.call_deferred(instance)
		await $EnemySpawnTimer.timeout


#spawns one enemy at index from the current_element(th) point in enemy array
#WARNING: make sure that current_element >= the size of the provided array of enemies
func spawn_one(index : int = 0, current_element : int = 0):
	var wave_size := waves[current_wave_num].enemy_wave.size()
	if current_element >= wave_size:
		print("error: current_element: " + str(current_element) + " exceeds or meets wave array size: " + str(wave_size))
		return
	else:
		var scene = waves[current_wave_num].enemy_wave[current_element]
		if scene:
			var instance = scene.instantiate()
			var spawnpoint = get_spawnpoint(index).global_position
			instance.spawnPos = spawnpoint
			instance.add_to_group("enemy")
			main.add_child.call_deferred(instance)

#spawns enemies in a vertical line at index
func spawn_in_line(index : int = 0):
	for scene in waves[current_wave_num].enemy_wave:
		if scene:
			var instance = scene.instantiate()
			var spawnpoint = get_spawnpoint(index).global_position
			instance.spawnPos = spawnpoint
			instance.add_to_group("enemy")
			main.add_child.call_deferred(instance)
		await $EnemySpawnTimer.timeout

#spawns enemies at a random spawnpoint
func spawn_random_position():
	for scene in waves[current_wave_num].enemy_wave:
		if scene:
			var instance = scene.instantiate()
			var spawnpoint = spawn_points.pick_random().global_position
			instance.spawnPos = spawnpoint
			instance.add_to_group("enemy")
			main.add_child.call_deferred(instance)
		await $EnemySpawnTimer.timeout

#spawns enemies at leftmost point (or index) and iterates until rightmost point.
#if the num of spawnpoints is less than enemies, will loop around to leftmost point
func spawn_left_to_right(index : int = 0):
	for scene in waves[current_wave_num].enemy_wave:
		if scene:
			var instance = scene.instantiate()
			var spawnpoint = get_spawnpoint(index).global_position
			instance.spawnPos = spawnpoint
			instance.add_to_group("enemy")
			main.add_child.call_deferred(instance)
			index += 1
		await $EnemySpawnTimer.timeout

#spawns enemies at rightmost point (or index) and decriments until leftmost point.
#if the num of spawnpoints is less than enemies, will loop to rightmost point
func spawn_right_to_left(index : int = 10):
	for scene in waves[current_wave_num].enemy_wave:
		if scene:
			if index < 0:
				index += spawn_points.size()
			var instance = scene.instantiate()
			var spawnpoint = get_spawnpoint(index).global_position
			instance.spawnPos = spawnpoint
			instance.add_to_group("enemy")
			main.add_child.call_deferred(instance)
			index -= 1
		await $EnemySpawnTimer.timeout

#spawns enemies in a downwards arrow formation where the spawnpoint (index) is the front
#	of the formation. does not spawn enemies if they would need to wrap around the spawn zone
func spawn_arrow_down(index : int = 6):
	print("arrow spawn activated")
	var left_index = index - 1
	var right_index = index + 1
	var is_first_spawn := true
	for scene in waves[current_wave_num].enemy_wave:
		if scene:
			if is_first_spawn:
				#spawn just the leading enemy
				var instance = scene.instantiate()
				var spawnpoint = get_spawnpoint(index).global_position
				instance.spawnPos = spawnpoint
				instance.add_to_group("enemy")
				main.add_child.call_deferred(instance)
				is_first_spawn = false
			else:
				#spawn the left and right enemies
				#if the left/right index is out of bounds, don't spawn that enemy
				if left_index > 0:
					var instance = scene.instantiate()
					var spawnpoint = get_spawnpoint(left_index).global_position
					instance.spawnPos = spawnpoint
					instance.add_to_group("enemy")
					main.add_child.call_deferred(instance)
					left_index -= 1
				if right_index < spawn_points.size():
					var instance = scene.instantiate()
					var spawnpoint = get_spawnpoint(right_index).global_position
					instance.spawnPos = spawnpoint
					instance.add_to_group("enemy")
					main.add_child.call_deferred(instance)
					right_index += 1
		await $EnemySpawnTimer.timeout



#gets spawnpoint at index ranging from 0 to spawnpoint.size(). if index > size, then perform modulo
#math to get a spawnpoint as if the array had been looped over
func get_spawnpoint(i : int = 0):
	if i < 0:
		return spawn_points[0]
	if i < spawn_points.size():
		return spawn_points[i]
	else:
		i = i % spawn_points.size()
		return spawn_points[i]



func _on_wave_cooldown_timer_timeout() -> void:
	current_wave_num += 1
	if current_wave_num >= waves.size():
		SignalBus.emit_signal("waves_finished", level_number)
		$WaveCooldownTimer.stop()
	else:
		#set spawning parameters for next wave
		SPAWN_BEHAVIOR = waves[current_wave_num].WAVE_SPAWN_BEHAVIOR
		spawn_index = waves[current_wave_num].spawn_index
		enemy_index = waves[current_wave_num].enemy_index
		spawn_interval = waves[current_wave_num].spawn_interval
		wave_cooldown = waves[current_wave_num].wave_cooldown
		
		$EnemySpawnTimer.start(spawn_interval)
		$WaveCooldownTimer.start(wave_cooldown)
		
		start_spawn_behavior()
