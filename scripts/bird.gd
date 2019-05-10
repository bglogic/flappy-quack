extends RigidBody2D

func _ready():
  pass

func _physics_process(delta):
  if rotation_degrees < -30:
    rotation_degrees = -30
    angular_velocity = 0
  
  if linear_velocity.y > 0:
    angular_velocity = 1.5

func flap():
  linear_velocity.y = -150
  angular_velocity = -3

func _input(event):
  if event.is_action_pressed("flap"):
    flap()