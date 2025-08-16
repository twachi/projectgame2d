extends Parallax2D

var color = null
var level :int = -1
func _ready() -> void:
	GameManager.smoke_scene = self
	update_level()

func update_level():
	var v:int = floor(GameManager.smoke_level)
	if v != level:
		level = v
		if (level % 5) == 0 :
			autoscroll.x =  level * -1.0
			($Bg1.texture as NoiseTexture2D).color_ramp.colors[1].a = level / 100.0

func _process(delta: float) -> void:
	if GameManager.fire_count<=0:
		GameManager.add_smoke(delta * -2.0)
	update_level()
