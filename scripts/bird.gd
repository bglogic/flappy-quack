extends RigidBody2D
class_name QBird

func _ready() -> void:
  linear_velocity.x = 50

func _physics_process(delta: float) -> void:
  if rotation_degrees < -30:
    rotation_degrees = -30
    angular_velocity = 0
  
  if linear_velocity.y > 0:
    angular_velocity = 1.5

func flap() -> void:
  linear_velocity.y = -150
  angular_velocity = -3

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("flap"):
    flap()