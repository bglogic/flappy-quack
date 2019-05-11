extends Camera2D
class_name QCamera

onready var bird: QBird = utils.get_main_node().get_node("bird")

func _physics_process(delta: float) -> void:
  position.x = bird.position.x

func get_total_position() -> Vector2:
  return position + offset