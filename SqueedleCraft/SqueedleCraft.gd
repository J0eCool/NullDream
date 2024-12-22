extends Control

# let's just be a game real quick

var player = {
	level = 1,
	max_hp = 10,
}
var enemy = {
	level = 1,
	max_hp = 10,
}


var hp_fmt = ""
var attack_time = 0.0
var xp = 0

var damage_labels = []


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_fmt = $Player/HP.text
	player.hp = player.max_hp
	enemy.hp = enemy.max_hp
	update_labels()


# Called every frame. 'dt' is the elapsed time since the previous frame.
func _process(dt):
	attack_time += dt
	if attack_time > 1.0:
		attack_time -= 1.0
		do_attack()
	$Player/AttackBar/Fill.size.x = $Player/AttackBar.size.x * attack_time

	var to_rem = []
	for i in range(damage_labels.size()):
		var dam = damage_labels[i]
		dam.t -= dt
		if dam.t <= 0:
			to_rem.append(i)
			dam.label.queue_free()
		dam.v.y += 1500*dt
		dam.label.position += dam.v*dt
	for i in to_rem:
		damage_labels.remove_at(i)


func _on_button_pressed():
	do_attack()


func do_attack():
	var damage = randi_range(1, 3)
	enemy.hp -= damage
	# better code health is to use preload().instantiate(), but this is simpler
	var label = $Damage/Template.duplicate()
	label.text = "{0}".format([damage])
	label.position = $Enemy/HP.global_position
	label.visible = true
	$Damage.add_child(label)
	var dam = {
		label = label,
		t = 1.0,
		v = Vector2(
			randf_range(-200.0, 200.0),
			randf_range(-250.0, -500.0),
		)
	}
	damage_labels.append(dam)

	if enemy.hp <= 0:
		enemy.hp = enemy.max_hp
		xp += 1
	update_labels()


func update_labels():
	$Player/HP.text = hp_fmt.format({"hp": player.hp, "max": player.max_hp})
	$Enemy/HP.text = hp_fmt.format({"hp": enemy.hp, "max": enemy.max_hp})
	$XP.text = "XP: {0}".format([xp])
