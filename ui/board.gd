class_name GardenBoard
extends Control

signal cell_pressed(cell: int)

const WOOD = preload("res://assets/wood.svg")
const SOIL = preload("res://assets/soil.svg")
const PLANTS = preload("res://assets/plants.svg")
const BORDER := 19.0
const STEP := 100.0
const TILE := 96.0
const INK := Color("#fff4bc")
const WATER := Color("#4ee9ff")
const GOLD := Color("#ffc86b")

var board: Array = []
var echo: Array = []
var cue := -1
var quality := 2
var motion := true
var effect: Dictionary = {}
var previous_board: Array = []
var revealed_echo := {}
var elapsed := 0.0
var duration := 1.0
var clock := 0.0

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cell := hit_cell(event.position)
		if cell != -1:
			cell_pressed.emit(cell)
		accept_event()

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
		if i == cue:
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
		draw_texture_rect_region(PLANTS, Rect2(middle + offset - extent * 0.5, extent),
			sprite_region(value), Color(Color.WHITE, opacity))
	if kind == "pulse" or kind == "echo":
		_draw_pulse(t, kind == "echo", changed)
	elif kind == "blast":
		_draw_blast(t, changed)

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
		draw_line(tail, tip, Color(WATER, fade), 5, true)
		var normal := axis.orthogonal() * 11
		draw_polyline(PackedVector2Array([tip - axis * 15 + normal, tip, tip - axis * 15 - normal]), Color(INK, fade), 4, true)

func _draw_blast(t: float, cells: Array) -> void:
	for cell: int in cells:
		var middle := center(cell)
		draw_circle(middle, 36 + 10 * t, Color(GOLD, 0.38 * (1.0 - t)))
		draw_arc(middle, 16 + 28 * t, 0, TAU, 24, Color(INK, 1.0 - t), 3, true)
		if not motion:
			continue
		for i in [4, 8, 14][quality]:
			var direction := Vector2.from_angle(i * 2.4 + cell * 1.6)
			var position: Vector2 = middle + direction * (14.0 + t * (34 + i % 4 * 9)) + Vector2.DOWN * t * t * 22
			draw_circle(position, (2.2 + i % 3) * (1.0 - t * 0.72), Color(GOLD if i % 2 == 0 else Color("#ff8ebc"), 1.0 - t))
