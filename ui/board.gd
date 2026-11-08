class_name GardenBoard
extends Control

signal cell_released(cell: int)
signal preview_changed(cell: int)

const WOOD = preload("res://assets/wood.svg")
const SOIL = preload("res://assets/soil.svg")
const PLANTS = preload("res://assets/plants.svg")
const BLOOM_OPENING = preload("res://assets/bloom_opening.svg")
const BORDER := 19.0
const STEP := 100.0
const TILE := 96.0
const INK := Color("#fff4bc")
const WATER := Color("#4ee9ff")
const GOLD := Color("#ffc86b")

var board: Array = []
var echo: Array = []
var cue := -1
var choices: Array = []
var preview: Dictionary = {}
var tracking := false
var accepting_moves := true
var pointed_cell := -1
var seed_flash := Color.TRANSPARENT
var seed_flash_end := 0.0
var preview_styles := {}
var halo: GradientTexture2D
var quality := 2
var motion := true
var effect: Dictionary = {}
var previous_board: Array = []
var revealed_echo := {}
var elapsed := 0.0
var duration := 1.0
var clock := 0.0

func _ready() -> void:
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([Color.WHITE, Color(1, 1, 1, 0)])
	halo = GradientTexture2D.new()
	halo.gradient = gradient
	halo.fill = GradientTexture2D.FILL_RADIAL
	halo.fill_from = Vector2(.5, .5)
	halo.fill_to = Vector2(1, .5)
	halo.width = 96
	halo.height = 96
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if accepting_moves and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		tracking = true
		_point_at(hit_cell(event.position))
		accept_event()

func _input(event: InputEvent) -> void:
	if not tracking:
		return
	if event is InputEventMouseMotion:
		_point_at(hit_cell(make_input_local(event).position))
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		var cell := hit_cell(make_input_local(event).position) if not event.is_canceled() else -1
		cancel_preview()
		if cell >= 0:
			cell_released.emit(cell)
		get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		cancel_preview()

func _point_at(cell: int) -> void:
	if pointed_cell == cell:
		return
	pointed_cell = cell
	preview_changed.emit(cell)

func set_preview(result: Dictionary) -> void:
	preview = result
	queue_redraw()

func cancel_preview() -> void:
	tracking = false
	_point_at(-1)

func flash_seed(tint: Color) -> void:
	if motion:
		seed_flash = tint
		seed_flash_end = clock + .5
		queue_redraw()

func hit_cell(position: Vector2) -> int:
	var point := position - Vector2.ONE * BORDER
	var grid := Vector2i(floori(point.x / STEP), floori(point.y / STEP))
	if not Garden.inside(grid) or point.x - grid.x * STEP >= TILE or point.y - grid.y * STEP >= TILE:
		return -1
	return Garden.index_at(grid)

func show_state(snapshot: Dictionary) -> void:
	board = snapshot.board
	echo = snapshot.echo
	queue_redraw()

func animate(event: Dictionary, seconds: float) -> void:
	previous_board = board
	effect = event
	if event.kind == "blast":
		for cell: int in event.cells:
			revealed_echo[cell] = true
	duration = maxf(seconds, 0.001)
	elapsed = 0.0
	show_state(event)

func finish(snapshot: Dictionary) -> void:
	effect = {}
	previous_board = []
	revealed_echo.clear()
	show_state(snapshot)

func _process(delta: float) -> void:
	clock += delta
	elapsed += delta
	if visible and (not effect.is_empty() or motion):
		queue_redraw()

func origin(cell: int) -> Vector2:
	return Vector2(Garden.coord(cell)) * STEP + Vector2.ONE * BORDER

func center(cell: int) -> Vector2:
	return origin(cell) + Vector2.ONE * TILE * 0.5

static func sprite_region(value: int) -> Rect2:
	return Rect2(Vector2(value % 3, Garden.species(value)) * 128, Vector2.ONE * 128)

func _draw() -> void:
	draw_texture_rect(WOOD, Rect2(Vector2.ZERO, Vector2.ONE * 638), false)
	if board.is_empty():
		return
	var t := clampf(elapsed / duration, 0, 1)
	var kind: String = effect.get("kind", "")
	var changed: Array = effect.get("cells", [])
	for i in Garden.COUNT:
		var corner := origin(i)
		var middle := center(i)
		var value: int = board[i]
		draw_texture_rect(SOIL, Rect2(corner, Vector2.ONE * TILE), false)
		if value == Garden.ROCK:
			draw_colored_polygon(PackedVector2Array([
				middle + Vector2(-35, 19), middle + Vector2(-26, -17), middle + Vector2(8, -30),
				middle + Vector2(33, -9), middle + Vector2(35, 19), middle + Vector2(8, 32)
			]), Color("#536273"))
			draw_colored_polygon(PackedVector2Array([
				middle + Vector2(-26, -17), middle + Vector2(8, -30), middle + Vector2(33, -9),
				middle + Vector2(6, 4), middle + Vector2(-28, 8)
			]), Color("#a4b5b2"))
		if value == Garden.EMPTY and (echo[i] > 0 or revealed_echo.has(i)):
			var shimmer := 0.72 + 0.18 * sin(clock * 5.0 + i) if motion else 0.8
			draw_circle(middle, 28, Color(1, 0.54, 0.30, shimmer * 0.18))
			draw_arc(middle, 29, 0, TAU, 30, Color(GOLD, shimmer), 3, true)
			for spark in range(3):
				var offset := Vector2.from_angle(spark * TAU / 3.0 + (clock if motion else 0.0)) * 28
				draw_circle(middle + offset, 2.4, INK)
		if i == cue or i in choices:
			var box := Rect2(corner + Vector2.ONE * 5, Vector2.ONE * (TILE - 10))
			draw_style_box(_guide_style(), box)
			draw_circle(middle, 6 + (sin(clock * 7) * 2 if motion else 0), GOLD)
		if value < 0:
			continue
		var scale_factor := 1.0
		var offset := Vector2.ZERO
		if motion and value % 3 == 2:
			offset.y = sin(clock * 1.7 + i * .67) * 1.7
		if motion and kind == "growth" and i in changed:
			scale_factor = lerpf(0.67, 1.0, ease(t, -2.3)) + sin(t * PI) * 0.16
			offset.y -= sin(t * PI) * 9
		if kind == "plant" and effect.origin == i:
			scale_factor = lerpf(0.45, 1.0, t) if motion else 1.0
			offset.y -= (1.0 - t) * 30 if motion else 0.0
			draw_circle(middle, 36 * t, Color(GOLD, 0.31 * (1 - t)))
		if kind == "match" and i in changed:
			if quality > 0:
				draw_texture_rect(halo, Rect2(middle - Vector2.ONE * 65, Vector2.ONE * 130), false, Color(GOLD, .62))
			for direction in [Vector2i.RIGHT, Vector2i.DOWN]:
				var next: Vector2i = Garden.coord(i) + direction
				if Garden.inside(next):
					var neighbor := Garden.index_at(next)
					if neighbor in changed and board[neighbor] == value:
						draw_line(middle, center(neighbor), Color(GOLD, .75), 10, true)
			scale_factor += t * 0.13 if motion else 0.0
			draw_circle(middle, 40, Color(GOLD, 0.24 + 0.25 * t))
			draw_arc(middle, 39, 0, TAU, 32, Color(GOLD, 0.88), 3, true)
		var extent := Vector2.ONE * 97.0 * scale_factor
		var opacity := 1.0
		if motion and kind == "growth" and i in changed:
			var prior: int = previous_board[i]
			opacity = smoothstep(0.05, 0.62, t)
			var prior_extent := Vector2.ONE * 97.0
			draw_texture_rect_region(PLANTS, Rect2(middle - prior_extent * .5, prior_extent),
				sprite_region(prior), Color(Color.WHITE, 1.0 - opacity))
		var sprite := PLANTS
		var region := sprite_region(value)
		if motion and kind == "growth" and i in changed and value % 3 == 2:
			sprite = BLOOM_OPENING
			region.position.x = roundi(smoothstep(.05, .92, t) * 5) * 128
		draw_texture_rect_region(sprite, Rect2(middle + offset - extent * 0.5, extent),
			region, Color(Color.WHITE, opacity))
	if clock < seed_flash_end:
		draw_rect(Rect2(11, 11, 616, 616), Color(seed_flash, (seed_flash_end - clock) * 1.6), false, 4)
	if not preview.is_empty():
		_draw_preview()
	if kind == "pulse" or kind == "echo":
		_draw_pulse(t, kind == "echo", changed)
	elif kind == "blast":
		_draw_blast(t, changed)

func _outline(tint: Color) -> StyleBoxFlat:
	if not preview_styles.has(tint):
		var style := StyleBoxFlat.new()
		style.draw_center = false
		style.border_color = tint
		style.set_border_width_all(3)
		style.set_corner_radius_all(14)
		preview_styles[tint] = style
	return preview_styles[tint]

func _draw_preview() -> void:
	for cell: int in preview.watered:
		var tile := Rect2(origin(cell) + Vector2.ONE * 3, Vector2.ONE * (TILE - 6))
		draw_rect(tile.grow(-6), Color(WATER, .13))
		draw_style_box(_outline(Color(WATER, .65)), tile)
	for cell: int in preview.blooms:
		draw_style_box(_outline(GOLD), Rect2(origin(cell) + Vector2.ONE * 5, Vector2.ONE * (TILE - 10)))
	for cell: int in preview.growth:
		var point := center(cell) + Vector2(26, -27)
		draw_circle(point, 12, Color("#274d34"))
		draw_polyline(PackedVector2Array([point + Vector2(-6, 3), point + Vector2(0, -4), point + Vector2(6, 3)]), INK, 3, true)
	var middle := center(preview.cell)
	draw_texture_rect_region(PLANTS, Rect2(middle - Vector2.ONE * 45, Vector2.ONE * 90), sprite_region(preview.seed), Color(1, 1, 1, .67))
	draw_style_box(_outline(GOLD), Rect2(origin(preview.cell) + Vector2.ONE * 3, Vector2.ONE * (TILE - 6)))

var guide_box: StyleBoxFlat

func _guide_style() -> StyleBoxFlat:
	if guide_box == null:
		guide_box = StyleBoxFlat.new()
		guide_box.bg_color = Color(1, 0.87, 0.35, 0.13)
		guide_box.border_color = GOLD
		guide_box.set_border_width_all(4)
		guide_box.set_corner_radius_all(12)
	return guide_box

func _draw_pulse(t: float, is_echo: bool, cells: Array) -> void:
	var source: int = effect.origin
	var start := center(source)
	var distance := ease(t, 0.65) * 525.0
	var fade := 1.0 - t * 0.8
	var tint := Color("#ffe494") if is_echo else WATER
	draw_arc(start, 13 + 38 * t, 0, TAU, 30, Color(tint, fade), 4, true)
	for direction: Vector2i in Garden.DIRECTIONS:
		var next := Garden.coord(source) + direction
		var length := 0.0
		while Garden.inside(next) and Garden.index_at(next) in cells:
			length += STEP
			next += direction
		if length == 0.0:
			continue
		var axis := Vector2(direction)
		var tip := start + axis * minf(length + 36, distance)
		var tail := start + axis * maxf(0, minf(length, distance - 194))
		if quality > 0:
			draw_line(tail, tip, Color(WATER, fade * .14), 33, true)
			draw_line(tail, tip, Color(WATER, fade * .45), 15, true)
		if motion and quality > 0 and tail.distance_to(tip) > 1:
			var current := PackedVector2Array()
			var length_visible := tail.distance_to(tip)
			for i in 13:
				var fraction := i / 12.0
				var shift := sin(fraction * 14 - t * 17) * 8 * sin(fraction * PI)
				current.append(tail + axis * (fraction * length_visible) + axis.orthogonal() * shift)
			draw_polyline(current, Color(WATER, fade * .48), 13, true)
			draw_polyline(current, Color("#c7fcff", fade), 4, true)
			for i in (6 if quality == 2 else 3):
				var fraction := fposmod(float(i) * .31 + t * 1.7, 1.0)
				var glint := tail.lerp(tip, fraction) + axis.orthogonal() * sin(i * 5.1 + t * 14) * 14
				draw_circle(glint, 2 + i % 2, Color("#d8ffff", fade))
		else:
			draw_line(tail, tip, Color(WATER, fade), 5, true)
		var normal := axis.orthogonal() * 11
		draw_polyline(PackedVector2Array([tip - axis * 15 + normal, tip, tip - axis * 15 - normal]), Color(INK, fade), 4, true)

func _draw_blast(t: float, cells: Array) -> void:
	for cell: int in cells:
		var middle := center(cell)
		var radius := 46.0 + 28.0 * t
		if quality > 0:
			draw_texture_rect(halo, Rect2(middle - Vector2.ONE * radius, Vector2.ONE * (radius * 2)), false, Color(GOLD, .78 * (1.0 - t)))
		draw_circle(middle, 36 + 10 * t, Color(GOLD, 0.38 * (1.0 - t)))
		draw_arc(middle, 16 + 28 * t, 0, TAU, 24, Color(INK, 1.0 - t), 3, true)
		if not motion:
			continue
		for i in [4, 8, 14][quality]:
			var direction := Vector2.from_angle(i * 2.4 + cell * 1.6)
			var position: Vector2 = middle + direction * (14.0 + t * (34 + i % 4 * 9)) + Vector2.DOWN * t * t * 22
			var tint := Color(GOLD if i % 2 == 0 else Color("#ff8ebc"), 1.0 - t)
			if quality > 0 and i % 2 == 1:
				var along := direction.rotated(t * 2.4) * 7 * (1.0 - t * .5)
				var across := along.orthogonal() * .57
				draw_colored_polygon(PackedVector2Array([position - along, position + across, position + along, position - across]), tint)
			else:
				draw_circle(position, (2.2 + i % 3) * (1.0 - t * 0.72), tint)
	if motion and quality > 0 and not cells.is_empty():
		var middle := Vector2.ZERO
		for cell: int in cells:
			middle += center(cell)
		middle /= cells.size()
		var text := "+%d" % effect.points
		var font := ThemeDB.fallback_font
		var text_width := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 34).x
		var position := middle + Vector2(-text_width * .5, -20 - t * 36)
		draw_string_outline(font, position, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 34, 9, Color("#57340c", 1.0 - t))
		draw_string(font, position, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 34, Color(INK, 1.0 - t))
