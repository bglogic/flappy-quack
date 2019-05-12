extends Area2D
class_name QCoin

func _ready() -> void:
  connect("body_entered", self, "_on_body_entered")

func _on_body_entered(other_body: Node) -> void:
  if other_body.is_in_group(game.GROUP_BIRDS):
    game.score_current += 1