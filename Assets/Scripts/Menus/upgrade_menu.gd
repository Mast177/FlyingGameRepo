extends Control

@export var health : ship_upgrades
@export var damage : ship_upgrades
@export var speed : ship_upgrades
@export var weapon_count : ship_upgrades
@export var shield : ship_upgrades

@onready var player_wallet = $Wallet
@onready var player_payment = $Payment
var buttons : Array[Button]
var prices : Array[Label]
var quantities : Array[Label]

func _ready() -> void:
	await get_tree().process_frame
	buttons = [
		$CenterContainer/VBoxContainer/Health/HBoxContainer/PurchaseButton,
		$CenterContainer/VBoxContainer/Damage/HBoxContainer/PurchaseButton,
		$CenterContainer/VBoxContainer/Speed/HBoxContainer/PurchaseButton,
		$"CenterContainer/VBoxContainer/Weapon Count/HBoxContainer/PurchaseButton",
		$CenterContainer/VBoxContainer/Shield/HBoxContainer/PurchaseButton
	]
	prices = [
		$CenterContainer/VBoxContainer/Health/HBoxContainer/Cost,
		$CenterContainer/VBoxContainer/Damage/HBoxContainer/Cost,
		$CenterContainer/VBoxContainer/Speed/HBoxContainer/Cost,
		$"CenterContainer/VBoxContainer/Weapon Count/HBoxContainer/Cost",
		$CenterContainer/VBoxContainer/Shield/HBoxContainer/Cost
	]
	quantities = [
		$CenterContainer/VBoxContainer/Health/HBoxContainer/Amount,
		$CenterContainer/VBoxContainer/Damage/HBoxContainer/Amount,
		$CenterContainer/VBoxContainer/Speed/HBoxContainer/Amount,
		$"CenterContainer/VBoxContainer/Weapon Count/HBoxContainer/Amount",
		$CenterContainer/VBoxContainer/Shield/HBoxContainer/Amount
	]
	
	disable_upgrade_buttons()
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()
	
	player_payment.text = "+$" + str(PlayerStats.cash_earned)
	#wait for a bit to show total payment before depositing
	$Timer.start(1.0)
	await $Timer.timeout
	#disable using buttons until payment has been deposited
	deposite_payment2()
	

func deposite_payment2():
	PlayerStats.total_cash_earned += PlayerStats.cash_earned
	var pay = PlayerStats.cash_earned
	var wallet = PlayerStats.cash
	var time := 0.1
	#var interval := 0
	$Timer.start(time)
	while pay > 0:
		#print(pay)
		if pay >= 100000:
			wallet += 100000
			pay -= 100000
		elif pay >= 10000:
			wallet += 10000
			pay -= 10000
		elif pay >= 1000:
			wallet += 1000
			pay -= 1000
		elif pay >= 100:
			wallet += 100
			pay -= 100
		elif pay >= 10:
			wallet += 10
			pay -= 10
		else:
			wallet += 1
			pay -= 1
		player_wallet.text = "$" + str(wallet)
		player_payment.text = "+$" + str(pay)
		PlayerStats.cash = wallet
		await $Timer.timeout
		
	$Timer.stop()
	$Payment.visible = false
	toggle_button_availability()

#old payment method, not used
func deposite_payment():
	var pay = PlayerStats.cash_earned
	var wallet = PlayerStats.cash
	var time := 0.1
	#var interval := 0
	$Timer.start(time)
	while pay > 0:
		#print(pay)
		if pay % 100000:
			wallet += 100000
			pay -= 100000
		elif pay % 10000:
			wallet += 10000
			pay -= 10000
		elif pay % 1000:
			wallet += 1000
			pay -= 1000
		elif pay % 100:
			wallet += 100
			pay -= 100
		elif pay % 10:
			wallet += 10
			pay -= 10
		else:
			wallet += 1
			pay -= 1
		player_wallet.text = "$" + str(wallet)
		player_payment.text = "+$" + str(pay)
		await $Timer.timeout
		
	$Timer.stop()
	$Payment.visible = false

#disable all buttons
func disable_upgrade_buttons():
	for button in buttons:
		button.disabled = true

#disable/enable buttons depending on if there is an upgrade available for purchase
func toggle_button_availability():
	for button in buttons:
		if button.is_in_group("health"):
			if health.upgrade_list.size() <= PlayerStats.health_upgrade_amount:
				button.disabled = true
				continue
			var upgrade = health.upgrade_list[PlayerStats.health_upgrade_amount + 1]
			if upgrade.cost > PlayerStats.cash:
				button.disabled = true
			else:
				button.disabled = false
		elif button.is_in_group("speed"):
			if speed.upgrade_list.size() <= PlayerStats.speed_upgrade_amount:
				button.disabled = true
				continue
			var upgrade = speed.upgrade_list[PlayerStats.speed_upgrade_amount + 1]
			if upgrade.cost > PlayerStats.cash:
				button.disabled = true
			else:
				button.disabled = false
		elif button.is_in_group("damage"):
			if damage.upgrade_list.size() <= PlayerStats.damage_upgrade_amount:
				button.disabled = true
				continue
			var upgrade = damage.upgrade_list[PlayerStats.damage_upgrade_amount + 1]
			if upgrade.cost > PlayerStats.cash:
				button.disabled = true
			else:
				button.disabled = false
		elif button.is_in_group("weapon count"):
			if weapon_count.upgrade_list.size() <= PlayerStats.weapon_count_upgrade_amount:
				button.disabled = true
				continue
			var upgrade = weapon_count.upgrade_list[PlayerStats.weapon_count_upgrade_amount + 1]
			if upgrade.cost > PlayerStats.cash:
				button.disabled = true
			else:
				button.disabled = false
		elif button.is_in_group("shield"):
			if shield.upgrade_list.size() <= PlayerStats.shield_upgrade_amount:
				button.disabled = true
				continue
			var upgrade = shield.upgrade_list[PlayerStats.shield_upgrade_amount + 1]
			if upgrade.cost > PlayerStats.cash:
				button.disabled = true
			else:
				button.disabled = false

#update cost labels with the price of their respective upgrade. $0 will display if all upgrades purchased
func update_upgrade_prices():
	for label in prices:
		if label.is_in_group("health"):
			if health.upgrade_list.size() <= PlayerStats.health_upgrade_amount:
				label.text = "$0"
			else:
				label.text = "$" + str(health.upgrade_list[PlayerStats.health_upgrade_amount + 1].cost)
		if label.is_in_group("speed"):
			if speed.upgrade_list.size() <= PlayerStats.speed_upgrade_amount:
				label.text = "$0"
			else:
				label.text = "$" + str(speed.upgrade_list[PlayerStats.speed_upgrade_amount + 1].cost)
		if label.is_in_group("damage"):
			if damage.upgrade_list.size() <= PlayerStats.damage_upgrade_amount:
				label.text = "$0"
			else:
				label.text = "$" + str(damage.upgrade_list[PlayerStats.damage_upgrade_amount + 1].cost)
		if label.is_in_group("weapon count"):
			if weapon_count.upgrade_list.size() <= PlayerStats.weapon_count_upgrade_amount:
				label.text = "$0"
			else:
				label.text = "$" + str(weapon_count.upgrade_list[PlayerStats.weapon_count_upgrade_amount + 1].cost)
		if label.is_in_group("shield"):
			if shield.upgrade_list.size() <= PlayerStats.shield_upgrade_amount:
				label.text = "$0"
			else:
				label.text = "$" + str(shield.upgrade_list[PlayerStats.shield_upgrade_amount + 1].cost)

#update amount labels with the amount of their respective upgrade. +0 will display if all upgrades pruchased
func update_upgrade_quanities():
	for label in quantities:
		if label.is_in_group("health"):
			if health.upgrade_list.size() <= PlayerStats.health_upgrade_amount:
				label.text = "+0"
			else:
				label.text = "+" + str(health.upgrade_list[PlayerStats.health_upgrade_amount + 1].amount)
		if label.is_in_group("speed"):
			if speed.upgrade_list.size() <= PlayerStats.speed_upgrade_amount:
				label.text = "+0"
			else:
				label.text = "+" + str(speed.upgrade_list[PlayerStats.speed_upgrade_amount + 1].amount)
		if label.is_in_group("damage"):
			if damage.upgrade_list.size() <= PlayerStats.damage_upgrade_amount:
				label.text = "+0"
			else:
				label.text = "+" + str(damage.upgrade_list[PlayerStats.damage_upgrade_amount + 1].amount)
		if label.is_in_group("weapon count"):
			if weapon_count.upgrade_list.size() <= PlayerStats.weapon_count_upgrade_amount:
				label.text = "+0"
			else:
				label.text = "+" + str(weapon_count.upgrade_list[PlayerStats.weapon_count_upgrade_amount + 1].amount)
		if label.is_in_group("shield"):
			if shield.upgrade_list.size() <= PlayerStats.shield_upgrade_amount:
				label.text = "+0"
			else:
				label.text = "+" + str(shield.upgrade_list[PlayerStats.shield_upgrade_amount + 1].amount)

#update player wallet display with the amount of cash they have
func update_wallet_display():
	player_wallet.text = "$" + str(PlayerStats.cash)

func _on_health_purchase_button_pressed() -> void:
	#print("health")
	var upgrade = health.upgrade_list[PlayerStats.health_upgrade_amount + 1]
	if upgrade.cost <= PlayerStats.cash:
		$Audio/Health.play()
		PlayerStats.cash -= upgrade.cost
		PlayerStats.current_health += upgrade.amount
		PlayerStats.health_upgrade_amount += 1
		toggle_button_availability()
	print("New Health: " + str(PlayerStats.current_health))
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()

func _on_damage_purchase_button_pressed() -> void:
	#print("damage")
	var upgrade = damage.upgrade_list[PlayerStats.damage_upgrade_amount + 1]
	if upgrade.cost <= PlayerStats.cash:
		$Audio/Damage.play()
		PlayerStats.cash -= upgrade.cost
		PlayerStats.current_damage += upgrade.amount
		PlayerStats.damage_upgrade_amount += 1
		toggle_button_availability()
	print("New damage: " + str(PlayerStats.current_damage))
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()


func _on_speed_purchase_button_pressed() -> void:
	#print("speed")
	var upgrade = speed.upgrade_list[PlayerStats.speed_upgrade_amount + 1]
	if upgrade.cost <= PlayerStats.cash:
		$Audio/Speed.play()
		PlayerStats.cash -= upgrade.cost
		PlayerStats.current_speed += upgrade.amount
		PlayerStats.speed_upgrade_amount += 1
		toggle_button_availability()
	print("New speed: " + str(PlayerStats.current_speed))
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()


func _on_weapon_count_purchase_button_pressed() -> void:
	#print("weapon count")
	var upgrade = weapon_count.upgrade_list[PlayerStats.weapon_count_upgrade_amount + 1]
	if upgrade.cost <= PlayerStats.cash:
		$Audio/WeaponCount.play()
		PlayerStats.cash -= upgrade.cost
		PlayerStats.current_weapon_count += upgrade.amount
		PlayerStats.weapon_count_upgrade_amount += 1
		toggle_button_availability()
	print("New weapon_count: " + str(PlayerStats.current_weapon_count))
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()


func _on_shield_purchase_button_pressed() -> void:
	#print("shield")
	var upgrade = shield.upgrade_list[PlayerStats.shield_upgrade_amount + 1]
	if upgrade.cost <= PlayerStats.cash:
		$Audio/Shield.play()
		PlayerStats.cash -= upgrade.cost
		PlayerStats.current_shield += upgrade.amount
		PlayerStats.shield_upgrade_amount += 1
		toggle_button_availability()
	print("New shield: " + str(PlayerStats.current_shield))
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()



func _on_next_button_pressed() -> void:
	var next_level = GameManager.next_level
	if next_level > GameManager.levels_path.size():
		#return to level select screen if next level is N/A
		SceneTransitionController.change_scene("res://Scenes/Menus/main_menu_levels_first.tscn", "fade", 1.0)
	else:
		#transition to next level
		var path = GameManager.levels_path[next_level]
		SceneTransitionController.change_scene(path, "pixelate", 1.0)
	


func _on_level_select_button_pressed() -> void:
	SceneTransitionController.change_scene("res://Scenes/Menus/main_menu_levels_first.tscn", "fade", 1.0)


func _on_ship_upgrade_menu_back_button_pressed() -> void:
	get_parent().get_node("AnimationPlayer").play("upgrades to level select")


func _on_reset_upgrades_pressed() -> void:
	#Reset player stats to default
	PlayerStats.reset_stats()
	#reset player wallet display to show total cash earned
	#player_wallet.text = "$" + str(PlayerStats.total_cash_earned)
	toggle_button_availability()
	update_wallet_display()
	update_upgrade_prices()
	update_upgrade_quanities()
