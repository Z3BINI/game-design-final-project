extends AudioStreamPlayer3D

@export var audio : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
