extends Node2D

@export var Card = preload("res://BlackjackRPG/Cards/card.gd")
@export var card_scene = preload("res://BlackjackRPG/Cards/card.tscn")

func draw_card() -> void:
	var card: Card = card_scene.instantiate()
	card.suit = randi()%4
	card.val = randi()%13
	card.position = Vector2(100*$Cards.get_child_count(), 0)
	$Cards.add_child(card)

	var hand = hand_value()
	$HandValue.text = str(hand)
	var color = Color.WHITE
	if hand == 21:
		color = Color.YELLOW
	elif hand > 21:
		color = Color.RED
	$HandValue.label_settings.font_color = color


func hand_value() -> int:
	var value = 0
	for card: Card in $Cards.get_children():
		value += card.get_value()
	# second pass if Aces are causing us to go over 21
	# (aces can be either 1 or 11)
	for card: Card in $Cards.get_children():
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
	for child in $Cards.get_children():
		$Cards.remove_child(child)
		child.queue_free()
	for i in range(2):
		draw_card()


func _on_new_hand_pressed() -> void:
	new_hand()


func _on_hit_pressed() -> void:
	draw_card()
