extends Camera3D

@export var acceleration = 50.0
@export var moveSpeed = 8.0

@export var mouseSpeed = 300.0

var velocity = Vector3.ZERO
var lookAngles = Vector2.ZERO

var focus = false

func _process(delta):
    if focus:
        lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
        set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))
        
        var dir = updateDirection()
        
        if dir.length_squared() > 0:
            velocity += dir * acceleration * delta
        else:
            velocity += velocity.direction_to(Vector3.ZERO) * acceleration * delta
            
        
        if velocity.length() < 0.0005:
            velocity = Vector3.ZERO
            
        if velocity.length() > moveSpeed:
            velocity = velocity.normalized() * moveSpeed
            
        translate(velocity * delta)
        
        if Input.is_action_just_pressed("ui_cancel"):
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
            focus = false
    
    
func updateDirection():
    # Get the direction to move the camera from the input.
    var dir = Vector3.ZERO
    if Input.is_action_pressed("Forward"):
        dir += Vector3.FORWARD
    if Input.is_action_pressed("Backward"):
        dir += Vector3.BACK
    if Input.is_action_pressed("Left"):
        dir += Vector3.LEFT
    if Input.is_action_pressed("Right"):
        dir += Vector3.RIGHT
    if Input.is_action_pressed("Up"):
        dir += Vector3.UP
    if Input.is_action_pressed("Down"):
        dir += Vector3.DOWN

    return dir.normalized()

func _input(event):
  
    if event is InputEventMouseMotion and focus:
        lookAngles -= event.relative / mouseSpeed
    pass
    
    if event is InputEventMouseButton:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        focus = true

