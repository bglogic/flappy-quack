extends RigidBody2D
class_name QBird

onready var state setget set_state, get_state

var speed = 50

const STATE_FLYING   = 0
const STATE_FLAPPING = 1
const STATE_HIT      = 2
const STATE_GROUNDED = 3

signal state_changed

func _ready() -> void:
  state = FlyingState.new(self)
  add_to_group(game.GROUP_BIRDS)
  connect("body_entered", self, "_on_body_entered")

func _physics_process(delta: float) -> void:
  state.update(delta)

func _input(event: InputEvent) -> void:
  state.input(event)

func _unhandled_input(event: InputEvent) -> void:
  state.unhandled_input(event)

func _on_body_entered(other_body: Node) -> void:
  state.on_body_entered(other_body)

func set_state(new_state: int) -> void:
  state.exit()
  if   new_state == STATE_FLYING  : state = FlyingState.new(self)
  elif new_state == STATE_FLAPPING: state = FlappingState.new(self)
  elif new_state == STATE_HIT     : state = HitState.new(self)
  elif new_state == STATE_GROUNDED: state = GroundedState.new(self)
  
  emit_signal("state_changed", self)

func get_state() -> int:
  if   state is FlyingState  : return STATE_FLYING
  elif state is FlappingState: return STATE_FLAPPING
  elif state is HitState     : return STATE_HIT
  elif state is GroundedState: return STATE_GROUNDED
  
  return -1

class BirdState:
  var bird
  
  func _init(bird: QBird) -> void:
    self.bird = bird
  
  func update(delta: float) -> void:
    pass

  func input(event: InputEvent) -> void:
    pass

  func unhandled_input(event: InputEvent) -> void:
    pass
  
  func on_body_entered(other_body: Node):
    pass
  
  func exit() -> void:
    pass

class FlyingState extends BirdState:
  var prev_gravity_scale
  
  func _init(bird: QBird).(bird) -> void:
    bird.get_node("anim").play("flying")
    bird.linear_velocity.x = bird.speed
    prev_gravity_scale = bird.gravity_scale
    bird.gravity_scale = 0
  
  func exit() -> void:
    bird.gravity_scale = prev_gravity_scale
    bird.get_node("anim").stop()
    bird.get_node("anim_sprite").position = Vector2(0, 0)

class FlappingState extends BirdState:
  func _init(bird: QBird).(bird) -> void:
    bird.linear_velocity.x = bird.speed
    flap()
  
  func update(delta: float) -> void:
    if bird.rotation_degrees < -30:
      bird.rotation_degrees = -30
      bird.angular_velocity = 0
    
    if bird.linear_velocity.y > 0:
      bird.angular_velocity = 1.5
  
  func input(event: InputEvent) -> void:
    if event.is_action_pressed("flap"):
      flap()

  func unhandled_input(event: InputEvent) -> void:
    print(event.as_text())
    if (not event is InputEventMouseButton) or !event.pressed or event.is_echo():
      return
    
    if event.button_index == BUTTON_LEFT:
      flap()
  
  func on_body_entered(other_body: Node):
    if   other_body.is_in_group(game.GROUP_PIPES)  : bird.state = bird.STATE_HIT
    elif other_body.is_in_group(game.GROUP_GROUNDS): bird.state = bird.STATE_GROUNDED
  
  func flap() -> void:
    bird.linear_velocity.y = -150
    bird.angular_velocity = -3
    bird.get_node("anim").play("flap")

class HitState extends BirdState:
  func _init(bird: QBird).(bird) -> void:
    bird.linear_velocity = Vector2(0,0)
    bird.angular_velocity = 2
    
    var other_body = bird.get_colliding_bodies()[0]
    bird.add_collision_exception_with(other_body)
  
  func on_body_entered(other_body: Node):
    if other_body.is_in_group(game.GROUP_GROUNDS):
      bird.state = bird.STATE_GROUNDED

class GroundedState extends BirdState:
  func _init(bird: QBird).(bird) -> void:
    bird.linear_velocity = Vector2(0,0)
    bird.angular_velocity = 0