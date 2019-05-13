extends Node

const GROUP_PIPES  : String = "pipes"
const GROUP_GROUNDS: String = "grounds"
const GROUP_BIRDS  : String = "birds"

var score_best   : int = 0 setget _set_score_best
var score_current: int = 0 setget _set_score_current

signal score_best_changed
signal score_current_changed

func _ready() -> void:
  stage_manager.connect("stage_changed", self, "_on_stage_changed")

func _on_stage_changed() -> void:
  score_current = 0

func _set_score_best(new_value: int) -> void:
  score_best = new_value
  emit_signal("score_best_changed")

func _set_score_current(new_value: int) -> void:
  score_current = new_value 
  emit_signal("score_current_changed")