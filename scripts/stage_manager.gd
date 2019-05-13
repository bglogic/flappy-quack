extends CanvasLayer

const STAGE_GAME: String = "res://stages/game_stage.tscn"
const STAGE_MENU: String = "res://stages/menu_stage.tscn"

var is_changing: bool = false

signal stage_changed

func _get_is_changing() -> bool:
  return is_changing

func change_stage(stage_path: String) -> void:
  if is_changing: return
  
  layer = 5
  is_changing = true
  get_tree().get_root().set_disable_input(true)
  
  get_node("anim").play("fade_in")
  yield(get_node("anim"), "animation_finished")
  
  get_tree().change_scene(stage_path)
  emit_signal("stage_changed")
  
  get_node("anim").play("fade_out")
  yield(get_node("anim"), "animation_finished")
  
  layer = 1
  is_changing = false
  get_tree().get_root().set_disable_input(false)