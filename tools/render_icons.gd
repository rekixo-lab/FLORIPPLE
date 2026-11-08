extends SceneTree
func _initialize() -> void:
	for pair: Array in [["icon", "splash", 2.0], ["icon", "launcher", 1.5], ["launcher_flower", "adaptive_foreground", 3.375]]:
		var image := Image.new()
		image.load_svg_from_string(FileAccess.get_file_as_string("res://assets/%s.svg" % pair[0]), pair[2])
		image.save_png("res://assets/%s.png" % pair[1])
	var background := Image.create_empty(432, 432, false, Image.FORMAT_RGBA8)
	background.fill(Color("#164a3a"))
	background.save_png("res://assets/adaptive_background.png")
	quit()
