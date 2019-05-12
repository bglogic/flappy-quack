extends StaticBody2D
class_name QGround

onready var bottom_right: Position2D = $bottom_right
onready var camera      : QCamera    = utils.get_main_node().get_node("camera")

func _ready() -> void:
  add_to_group(game.GROUP_GROUNDS)

func _process(delta: float) -> void:
  if camera == null: return
  if bottom_right.global_position.x <= camera.get_total_position().x:
    queue_free()