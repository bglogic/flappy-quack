extends Node

const SAVE_PATH: String = "user://savegame.bin"
const SAVE_PASS: String = "password"

func get_main_node() -> Node:
  var root_node = $"/root"
  return root_node.get_child(root_node.get_child_count()-1)

func get_digits(number: int) -> Array:
  var str_number: String = str(number)
  var digits    : Array = []
  
  for i in range(str_number.length()):
    digits.append(str_number[i].to_int())
  
  return digits

func get_file(is_write: bool):
  var save_game: File = File.new()
  var password: String = SAVE_PASS
  if OS.get_name() == "Android" or OS.get_name() == "iOS":
    password = OS.get_unique_id()
  
  if is_write:
    save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, password)
  else:
    if not save_game.file_exists(SAVE_PATH):
      return
    save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, password)
  
  return save_game

func save_game() -> void:
  var save_game: File = get_file(true)
  var data: Dictionary = {"score_best": game.score_best}
  save_game.store_line(to_json(data))
  save_game.close()

func load_game() -> void:
  game.is_fresh_launch = false
  var save_game: File = get_file(false)
  if not save_game:
    return

  while not save_game.eof_reached():
    var current_line = parse_json(save_game.get_line())
    if current_line:
      game.score_best = current_line["score_best"]
  save_game.close()