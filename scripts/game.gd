extends Node

const GROUP_PIPES  : String = "pipes"
const GROUP_GROUNDS: String = "grounds"
const GROUP_BIRDS  : String = "birds"

const MEDAL_BRONZE  : int = 10
const MEDAL_SILVER  : int = 20
const MEDAL_GOLD    : int = 30
const MEDAL_PLATINUM: int = 40

var is_fresh_launch: bool = true

var score_best   : int = 0 setget _set_score_best
var score_current: int = 0 setget _set_score_current

signal score_best_changed
signal score_current_changed

func _ready() -> void:
  stage_manager.connect("stage_changed", self, "_on_stage_changed")

func _on_stage_changed() -> void:
  score_current = 0

func _set_score_best(new_value: int) -> void:
  if new_value > score_best:
    score_best = new_value
    if not is_fresh_launch:
      utils.save_game()

    emit_signal("score_best_changed")

func _set_score_current(new_value: int) -> void:
  score_current = new_value 
  emit_signal("score_current_changed")