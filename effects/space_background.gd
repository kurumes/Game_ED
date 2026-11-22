extends Parallax2D

@onready var space_layer: Parallax2D = $SpaceLayer
@onready var far_stars_layer: Parallax2D = $FarStarsLayer
@onready var close_stars_layer: Parallax2D = $CloseStarsLayer

func _process(delta: float) -> void:
	space_layer.scroll_offset.y += 2 * delta
	far_stars_layer.screen_offset.y += 5 * delta
	close_stars_layer.scroll_offset.y += 20 * delta 
