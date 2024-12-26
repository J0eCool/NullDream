extends Node2D

@export var Card = preload("res://BlackjackRPG/Cards/card.gd")
@export var card_scene = preload("res://BlackjackRPG/Cards/card.tscn")

func draw_card() -> void:
	var card: Card = card_scene.instantiate()
	card.suit = randi()%4
	card.val = randi()%13
	card.position = Vector2(100*$Player/Cards.get_child_count(), 0)
	$Player/Cards.add_child(card)

	var hand = hand_value()
	$Player/HandValue.text = str(hand)
	var color = Color.WHITE
	if hand == 21:
		color = Color.YELLOW
	elif hand > 21:
		color = Color.RED
	$Player/HandValue.label_settings.font_color = color


func hand_value() -> int:
	var value = 0
	for card: Card in $Player/Cards.get_children():
		value += card.get_value()
	# second pass if Aces are causing us to go over 21
	# (aces can be either 1 or 11)
	for card: Card in $Player/Cards.get_children():
		if value > 21 and card.val == Card.CardVal.Ace:
			value -= 10
	return value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_hand()


# Called every frame. '_dt' is the elapsed time since the previous frame.
func _process(_dt: float) -> void:
	pass


func new_hand() -> void:
	# clear hand
	for child in $Player/Cards.get_children():
		$Player/Cards.remove_child(child)
		child.queue_free()
	for i in range(2):
		draw_card()


func _on_new_hand_pressed() -> void:
	var damage = hand_value() - 10
	if damage == 11:
		damage = 15
	elif damage > 11:
		damage = -10
	var word = "dealt" if damage > 0 else "took"
	$LogLabel.text = "You {0} {1} damage".format([word, abs(damage)])

	new_hand()


func _on_hit_pressed() -> void:
	draw_card()
