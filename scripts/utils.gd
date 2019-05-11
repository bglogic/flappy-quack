extends Node

func _ready() -> void:
  pass

func get_main_node() -> Node:
  var root_node = $"/root"
  return root_node.get_child(root_node.get_child_count()-1)
