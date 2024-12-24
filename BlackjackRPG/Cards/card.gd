extends Sprite2D
class_name Card

enum Suit {SPADE, CLUB, DIAMOND, HEART}
@export var suit: Suit
enum CardVal {Ace, C2, C3, C4, C5, C6, C7, C8, C9, C10, Jack, Queen, King}
@export var val: CardVal

static var card_text = [
	"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K",
]
static var suit_anim = [
	"spade", "club", "diamond", "heart",
]


func get_value() -> int:
	if val in [CardVal.Jack, CardVal.Queen, CardVal.King]:
		return 10
	elif val == CardVal.Ace:
		return 11
	else:
		return int(val)+1


func update_visuals() -> void:
	$Suit_UL.animation = suit_anim[suit]
	$Suit_BR.animation = suit_anim[suit]
	$Label.text = card_text[val]

	var is_black = suit in [Suit.SPADE, Suit.CLUB]
	var color = Color.BLACK if is_black else Color.RED
	var border = 2 if is_black else 8
	$Label.add_theme_color_override("font_color", color)
	$Label.add_theme_constant_override("outline_size", border)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_visuals()
