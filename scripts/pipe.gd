extends StaticBody2D
class_name QPipe

onready var right: Position2D = $right
onready var camera: QCamera = utils.get_main_node().get_node("camera")

func _process(delta: float) -> void:
  if camera == null: return
  if right.global_position.x <= camera.get_total_position().x:
    queue_free()