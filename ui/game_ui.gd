extends Control

const BACKDROP = preload("res://assets/spring.webp")
const PLANTS = preload("res://assets/plants.svg")
const WOOD = preload("res://assets/wood.svg")
const GLOSS = preload("res://assets/gloss.svg")
const TITLE_FONT = preload("res://assets/BreeSerif-Regular.ttf")
const CREAM := Color("#fff2c8")
const GOLD := Color("#ffd477")
const DARK := Color("#173f35")
const GREEN := Color("#22614e")
const MOSS := Color("#497d46")
const WOOD_DARK := Color("#663d2a")
const SPECIES := [Color("#416f34"), Color("#a33968"), Color("#315c9c"), Color("#a66a25")]
const TOOL_NAMES := ["Undo", "Water", "Shovel", "Color Magic"]
const TUTORIAL_TIPS := [
	"Plant here to water the whole row and column.",
	"Water the pink bud again to bloom three flowers.",
	"Plant on glowing soil for a bonus Echo pulse."
]

var profile := Profile.new()
var garden: Garden
var mode := ""
var session_key := ""
var day := ""
var canvas: Control
var page: Control
var overlay: Control
var board: GardenBoard
var sound: GardenSound
var score_label: Label
var best_label: Label
var best_title: Label
var mode_label: Label
var goal_label: Label
var feedback: Label
var undo_button: Button
var tools_button: Button
var seed_buttons: Array[Button] = []
var seed_icons: Array[TextureRect] = []
var locked := false
var active_tool := 0
var new_record := false
var score_tween: Tween
var save_issue := false
var page_name := ""
var hero_tween: Tween

func _ready() -> void:
	var background := TextureRect.new()
	background.texture = BACKDROP
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	canvas = Control.new()
	canvas.size = Vector2(720, 1280)
	canvas.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(canvas)
	resized.connect(_resize_canvas)
	get_window().go_back_requested.connect(_back)
	_resize_canvas()
	profile.load_game()
	sound = GardenSound.new()
	add_child(sound)
	_apply_settings()
	_home()

func _resize_canvas() -> void:
	var area := Rect2(Vector2.ZERO, size)
	if OS.has_feature("android"):
		var window_size := Vector2(DisplayServer.window_get_size())
		var usable := Rect2(DisplayServer.get_display_safe_area())
		if window_size.x > 0 and window_size.y > 0:
			var factor := size / window_size
			var safe := Rect2((usable.position - Vector2(DisplayServer.window_get_position())) * factor, usable.size * factor)
			if safe.has_area() and area.intersects(safe):
				area = area.intersection(safe)
	var factor := minf(area.size.x / 720.0, area.size.y / 1280.0)
	canvas.scale = Vector2.ONE * factor
	canvas.position = area.position + (area.size - canvas.size * factor) * 0.5

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED and is_instance_valid(canvas):
		_save()
	elif what == NOTIFICATION_APPLICATION_RESUMED and is_instance_valid(canvas):
		_resize_canvas()

func _unhandled_key_input(event: InputEvent) -> void:
	if not OS.has_feature("android") and event.is_action_pressed("ui_cancel"):
		_back()
		get_viewport().set_input_as_handled()

func _back() -> void:
	if locked:
		return
	if is_instance_valid(overlay):
		if garden != null and garden.state.status != "playing":
			_home()
		else:
			_close_overlay()
	elif page_name == "game":
		_pause()
	elif page_name != "home":
		_home()

func _save() -> void:
	if profile.save_game() != OK:
		save_issue = true
		push_warning("Could not write the FLORIPPLE save file.")
	else:
		save_issue = false

func _apply_settings() -> void:
	sound.configure(profile.data.settings)
	Engine.max_fps = 30 if profile.data.settings.quality == 0 else 60
	if is_instance_valid(board):
		board.quality = clampi(profile.data.settings.quality, 0, 2)
		board.motion = profile.data.settings.motion
		board.queue_redraw()

func _exit_tree() -> void:
	if hero_tween != null:
		hero_tween.kill()

func _new_page(name: String) -> void:
	if hero_tween != null:
		hero_tween.kill()
		hero_tween = null
	_close_overlay()
	if is_instance_valid(page):
		canvas.remove_child(page)
		page.queue_free()
	page = Control.new()
	page.name = name
	page_name = name
	page.size = canvas.size
	page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(page)

func _position(node: Control, area: Rect2, parent: Control) -> void:
	node.position = area.position
	node.size = area.size
	parent.add_child(node)

func _style(color: Color, border: Color, radius: int = 22, shadow: int = 5) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_corner_radius_all(radius)
	style.set_border_width_all(3)
	style.border_width_top = 4
	style.border_width_bottom = 6
	style.shadow_color = Color(0.08, 0.10, 0.07, 0.46)
	style.shadow_offset = Vector2(0, 5)
	style.shadow_size = shadow
	return style

func _panel(parent: Control, area: Rect2, color: Color = DARK, trim: Color = GOLD) -> Panel:
	var panel := Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _style(color, trim))
	_position(panel, area, parent)
	_gloss(panel)
	return panel

func _label(parent: Control, words: String, area: Rect2, point_size: int = 27, color: Color = CREAM) -> Label:
	var label := Label.new()
	label.text = words
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", point_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.12, 0.15, 0.09, 0.8))
	label.add_theme_constant_override("shadow_offset_y", 2)
	_position(label, area, parent)
	return label

func _button(parent: Control, words: String, area: Rect2, action: Callable, color: Color = GREEN, point_size: int = 28) -> Button:
	var button := Button.new()
	button.text = words
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", point_size)
	button.add_theme_color_override("font_color", CREAM)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color("#b5ae92"))
	button.add_theme_stylebox_override("normal", _style(color, GOLD.darkened(.27)))
	button.add_theme_stylebox_override("hover", _style(color.lightened(.13), GOLD))
	button.add_theme_stylebox_override("pressed", _style(color.lightened(.21), Color("#fff6b6"), 22, 1))
	button.add_theme_stylebox_override("disabled", _style(Color("#424d43"), Color("#7f7960"), 22, 2))
	var focus := _style(Color.TRANSPARENT, Color("#fff8b7"), 22, 0)
	focus.draw_center = false
	button.add_theme_stylebox_override("focus", focus)
	button.pressed.connect(func() -> void:
		sound.play("tap")
		action.call()
	)
	_position(button, area, parent)
	_gloss(button)
	return button

func _gloss(parent: Control) -> void:
	var sheen := TextureRect.new()
	sheen.texture = GLOSS
	sheen.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sheen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sheen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parent.add_child(sheen)

func _flower(parent: Control, area: Rect2, value: int) -> TextureRect:
	var texture := AtlasTexture.new()
	texture.atlas = PLANTS
	texture.region = GardenBoard.sprite_region(value)
	texture.filter_clip = true
	var sprite := TextureRect.new()
	sprite.texture = texture
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_position(sprite, area, parent)
	return sprite

func _logo(top: float, compact: bool = false) -> void:
	var width := 470 if compact else 590
	var height := 113 if compact else 163
	var left := (720.0 - width) * 0.5
	var sign := _panel(page, Rect2(left, top, width, height), WOOD_DARK, GOLD)
	var grain := TextureRect.new()
	grain.texture = WOOD
	grain.modulate = Color(1, 1, 1, .24)
	grain.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	grain.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_position(grain, Rect2(8, 5, width - 16, height - 10), sign)
	var title := _label(sign, "FLORIPPLE", Rect2(0, 0, width, height - (14 if compact else 40)), 57 if compact else 78, GOLD)
	title.add_theme_font_override("font", TITLE_FONT)
	title.add_theme_color_override("font_outline_color", Color("#50311e"))
	title.add_theme_constant_override("outline_size", 10)
	title.add_theme_constant_override("shadow_offset_y", 6)
	if not compact:
		_label(sign, "P L A N T   ·   P U L S E   ·   B L O O M", Rect2(0, 110, width, 42), 24)
	_flower(sign, Rect2(-31, height - 66, 90, 90), Garden.plant(1, 2))
	_flower(sign, Rect2(width - 54, -25, 85, 85), Garden.plant(0, 2))

func _home() -> void:
	garden = null
	active_tool = 0
	_new_page("home")
	_logo(108)
	var hero := _flower(page, Rect2(197, 265, 326, 326), Garden.plant(1, 2))
	if profile.data.settings.motion:
		hero_tween = hero.create_tween().set_loops().set_trans(Tween.TRANS_SINE)
		hero_tween.tween_property(hero, "position:y", 278, 1.55)
		hero_tween.tween_property(hero, "position:y", 265, 1.55)
	_panel(page, Rect2(69, 588, 582, 570), Color(0.075, 0.22, 0.17, .94))
	var saved := profile.restore("endless")
	var play_text := "Continue garden" if saved != null and saved.state.status == "playing" else "Play"
	_button(page, play_text, Rect2(106, 624, 508, 86), func() -> void:
		_start("endless" if profile.data.tutorial else "tutorial")
	, MOSS, 39)
	_button(page, "Endless", Rect2(106, 728, 245, 77), _start.bind("endless"))
	_button(page, "Levels", Rect2(369, 728, 245, 77), _levels)
	_button(page, "Daily Challenge", Rect2(106, 823, 508, 77), _daily)
	_button(page, "Progress", Rect2(106, 918, 245, 75), _progress)
	_button(page, "Settings", Rect2(369, 918, 245, 75), _settings)
	_label(page, "ENDLESS BEST     %s" % profile.data.best, Rect2(106, 1030, 508, 59), 28, GOLD)
	_label(page, "SPRING GARDEN  /  OFFLINE PLAY", Rect2(105, 1091, 510, 38), 20)

func _levels() -> void:
	_new_page("levels")
	_logo(95, true)
	_panel(page, Rect2(52, 263, 616, 830))
	_label(page, "Garden Path", Rect2(64, 278, 592, 71), 43, GOLD)
	_label(page, "%d of %d gardens completed" % [profile.data.levels.size(), Puzzles.LEVEL_COUNT], Rect2(67, 346, 586, 44), 25)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_position(scroll, Rect2(89, 414, 550, 605), page)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 14)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	for band in 4:
		var heading := Label.new()
		heading.text = ["First Blooms", "Echo Garden", "Chain Grove", "Rock Terrace"][band]
		heading.add_theme_font_size_override("font_size", 27)
		heading.add_theme_color_override("font_color", GOLD)
		list.add_child(heading)
		for row in 2:
			var group := HBoxContainer.new()
			group.add_theme_constant_override("separation", 12)
			list.add_child(group)
			for column in 3:
				var id := band * 6 + row * 3 + column + 1
				var stars: int = profile.data.levels.get(str(id), {}).get("stars", 0)
				var available: bool = id == 1 or profile.data.levels.has(str(id - 1))
				var detail := "Locked"
				if available:
					detail = "Open" if stars == 0 else "★".repeat(stars)
				var button := _button(group, "%02d  %s" % [id, detail], Rect2(0, 0, 168, 60), _start.bind("level", id), GREEN, 22)
				button.custom_minimum_size = Vector2(168, 60)
				button.disabled = not available
	_button(page, "Home", Rect2(223, 1115, 274, 76), _home)

func _daily() -> void:
	day = Time.get_date_string_from_system(true)
	var completed: Dictionary = profile.data.daily.get(day, {})
	var content := "A new offline puzzle every UTC day.\n%s  ·  %s" % [day, "Ready to play" if completed.is_empty() else "Best %s" % completed.score]
	var dialog := _dialog("Daily Challenge", content, 455)
	_button(dialog, "Play today's puzzle", Rect2(42, 259, 516, 74), _start.bind("daily"), MOSS)
	_button(dialog, "Back", Rect2(42, 352, 516, 67), _close_overlay)

func _progress() -> void:
	_new_page("progress")
	_logo(95, true)
	_panel(page, Rect2(62, 267, 596, 810))
	_label(page, "Garden Journal", Rect2(77, 277, 566, 77), 42, GOLD)
	_label(page, "%d flowers  ·  %d chains  ·  %d daily wins" % [profile.data.flowers, profile.data.chains, profile.data.daily.size()], Rect2(77, 352, 566, 52), 23)
	var y := 423
	var badges := profile.badges()
	for badge: String in badges:
		var earned: bool = badges[badge]
		_panel(page, Rect2(94, y, 532, 57), GREEN if earned else DARK, GOLD if earned else Color("#698267"))
		_label(page, ("✦  " if earned else "◇  ") + badge, Rect2(100, y, 520, 56), 25, GOLD if earned else CREAM)
		y += 65
	_button(page, "Home", Rect2(223, 1111, 274, 76), _home)

func _start(next_mode: String, id: int = 0, restart: bool = false) -> void:
	mode = next_mode
	var puzzle := {}
	match mode:
		"level":
			puzzle = Puzzles.level(id)
			session_key = "level-%d" % id
		"daily":
			puzzle = Puzzles.daily(day)
			session_key = "daily-" + day
		"tutorial":
			puzzle = Puzzles.tutorial()
			session_key = "tutorial"
		_:
			session_key = "endless"
	garden = null if restart else profile.restore(session_key)
	if garden == null or (garden.state.status != "playing" and mode != "tutorial"):
		garden = Garden.new(puzzle.get("seed", randi()), puzzle)
	if garden.state.status != "playing":
		garden = Garden.new(puzzle.seed, puzzle)
	active_tool = 0
	new_record = false
	locked = false
	profile.store(session_key, garden)
	_save()
	_game()

func _game() -> void:
	_new_page("game")
	_logo(40, true)
	_button(page, "Ⅱ", Rect2(26, 58, 80, 80), _pause, GREEN, 38)
	_panel(page, Rect2(42, 188, 636, 137))
	_label(page, "S C O R E", Rect2(50, 200, 304, 37), 23, GOLD)
	best_title = _label(page, "", Rect2(366, 200, 304, 37), 23, GOLD)
	score_label = _label(page, "0", Rect2(51, 237, 304, 70), 54)
	best_label = _label(page, "0", Rect2(365, 237, 304, 70), 54)
	var separator := ColorRect.new()
	separator.color = Color(GOLD, .45)
	separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_position(separator, Rect2(359, 209, 2, 95), page)
	_panel(page, Rect2(42, 345, 636, 93), Color("#285744"), GOLD.darkened(.16))
	mode_label = _label(page, "", Rect2(51, 351, 618, 36), 25, GOLD)
	goal_label = _label(page, "", Rect2(48, 389, 624, 41), 25)
	board = GardenBoard.new()
	board.cell_pressed.connect(_cell_pressed)
	_position(board, Rect2(41, 462, 638, 638), page)
	feedback = _label(page, "", Rect2(51, 434, 618, 33), 25, GOLD)
	_panel(page, Rect2(36, 1117, 648, 127), WOOD_DARK)
	undo_button = _button(page, "Undo", Rect2(48, 1154, 91, 62), _undo, GREEN, 22)
	tools_button = _button(page, "Tools", Rect2(580, 1154, 91, 62), _boosters, GREEN, 22)
	seed_buttons.clear()
	seed_icons.clear()
	for i in 3:
		var card := _button(page, "", Rect2(150 + i * 142, 1126, 135, 108), _select.bind(i), GREEN, 23)
		seed_buttons.append(card)
		seed_icons.append(_flower(card, Rect2(34, 1, 67, 67), Garden.plant(0, 2)))
		_label(card, "", Rect2(3, 64, 129, 34), 23).name = "Species"
	_apply_settings()
	board.show_state(garden.state)
	_refresh()

func _refresh() -> void:
	var state := garden.state
	if score_tween != null and score_tween.is_running():
		score_tween.kill()
	score_label.text = str(state.score)
	best_title.text = "E N D L E S S   B E S T"
	best_label.text = str(profile.data.best)
	match mode:
		"endless":
			mode_label.text = "E N D L E S S"
			var moves_text := "%d %s" % [state.moves, "move" if state.moves == 1 else "moves"]
			goal_label.text = "%s  ·  %d flowers cleared" % [moves_text, _flower_count(state)]
		"tutorial":
			mode_label.text = "L E A R N   T O   P L A Y"
			goal_label.text = TUTORIAL_TIPS[mini(state.moves, TUTORIAL_TIPS.size() - 1)]
		_:
			if mode == "daily":
				mode_label.text = "DAILY  /  %s" % day
				best_title.text = "D A I L Y   B E S T"
				best_label.text = str(profile.data.daily.get(day, {}).get("score", 0))
			else:
				mode_label.text = "L E V E L   %02d" % state.puzzle.id
				best_title.text = "L E V E L   B E S T"
				best_label.text = str(profile.data.levels.get(str(state.puzzle.id), {}).get("score", 0))
			goal_label.text = "%s  %d/%d   ·   %d moves left" % [Puzzles.description(state.puzzle), garden.objective(), state.puzzle.target, garden.remaining()]
	var guide_slot := -1
	board.cue = -1
	if mode == "tutorial" and state.moves < state.puzzle.guide.size():
		var guide: Array = state.puzzle.guide[state.moves]
		board.cue = guide[0]
		guide_slot = guide[1]
		garden.select(guide_slot)
	for i in 3:
		var card := seed_buttons[i]
		var species: int = state.tray[i]
		var selected: bool = i == state.slot and active_tool == 0
		card.disabled = species < 0 or (guide_slot >= 0 and i != guide_slot)
		var trim := Color("#fff5a4") if selected else GOLD.darkened(.34)
		if species >= 0:
			var base: Color = SPECIES[species]
			card.add_theme_stylebox_override("normal", _style(base.lightened(.17) if selected else base, trim))
			card.add_theme_stylebox_override("hover", _style(base.lightened(.23), GOLD))
			var atlas: AtlasTexture = seed_icons[i].texture
			atlas.region = GardenBoard.sprite_region(Garden.plant(species, 1))
		seed_icons[i].visible = species >= 0
		card.get_node("Species").text = Puzzles.NAMES[species] if species >= 0 else "Spent"
	undo_button.disabled = mode == "tutorial" or state.boosts[0] <= 0 or garden.previous.is_empty()
	tools_button.disabled = mode == "tutorial"
	tools_button.text = ("Magic" if active_tool == 3 else TOOL_NAMES[active_tool]) if active_tool > 0 else "Tools"
	board.queue_redraw()

func _flower_count(state: Dictionary) -> int:
	var total := 0
	for count: int in state.cleared:
		total += count
	return total

func _select(slot: int) -> void:
	if locked or is_instance_valid(overlay):
		return
	if garden.select(slot):
		active_tool = 0
		feedback.text = ""
		_refresh()
		profile.store(session_key, garden)
		_save()

func _cell_pressed(cell: int) -> void:
	if locked or is_instance_valid(overlay):
		return
	if mode == "tutorial" and board.cue >= 0 and cell != board.cue:
		return
	var accepted := garden.boost(cell, active_tool) if active_tool > 0 else garden.place(cell)
	if not accepted:
		return
	locked = true
	active_tool = 0
	_commit_turn()
	_present_turn()

func _commit_turn() -> void:
	var state := garden.state
	if mode != "tutorial":
		profile.data.flowers += _flower_count(state) - _flower_count(garden.previous)
		profile.data.chains += state.chains - garden.previous.chains
	if mode == "endless" and state.score > profile.data.best:
		profile.data.best = state.score
		new_record = true
	if state.status == "won":
		if mode == "tutorial":
			profile.data.tutorial = true
		elif mode == "level":
			var id := str(state.puzzle.id)
			var former: Dictionary = profile.data.levels.get(id, {})
			var stars := 0
			for threshold: int in state.puzzle.stars:
				stars += int(garden.remaining() >= threshold)
			profile.data.levels[id] = {"stars": maxi(stars, former.get("stars", 0)), "score": maxi(state.score, former.get("score", 0))}
		elif mode == "daily":
			var former: Dictionary = profile.data.daily.get(day, {})
			profile.data.daily[day] = {"score": maxi(state.score, former.get("score", 0))}
	profile.data.badges = profile.badges()
	profile.store(session_key, garden)
	_save()

func _present_turn() -> void:
	var timings := {"plant": .13, "pulse": .30, "echo": .34, "growth": .20, "match": .16, "blast": .34, "shovel": .17}
	var speed := 0.58 if profile.data.settings.fast else 1.0
	if not profile.data.settings.motion:
		speed *= 0.55
	board.cue = -1
	feedback.text = ""
	for event: Dictionary in garden.events:
		var kind: String = event.kind
		var seconds: float = timings[kind] * speed
		board.animate(event, seconds)
		sound.play("combo" if kind == "blast" and event.wave > 1 else kind)
		if kind == "echo":
			feedback.text = "BLOOM ECHO"
		if kind == "blast":
			var label := "BLOOM" if event.wave == 1 else "CHAIN %d  ·  ×%.1f" % [event.wave, event.multiplier]
			feedback.text = "%s  +%d" % [label, event.points]
			animate_score(event.score, seconds)
		if profile.data.settings.haptics and kind in ["plant", "blast"]:
			Input.vibrate_handheld(14 if kind == "plant" else 28)
		await get_tree().create_timer(seconds).timeout
	board.finish(garden.state)
	_refresh()
	if save_issue:
		feedback.text = "Save unavailable"
	elif new_record and mode == "endless" and garden.state.score == profile.data.best and garden.previous.score != garden.state.score:
		feedback.text = "NEW BEST  ·  %d" % garden.state.score
	locked = false
	if garden.state.status != "playing":
		_result()

func animate_score(target: int, seconds: float) -> void:
	score_tween = create_tween()
	score_tween.tween_method(func(value: float) -> void: score_label.text = str(roundi(value)), float(score_label.text), float(target), seconds)

func _undo() -> void:
	if locked or is_instance_valid(overlay) or mode == "tutorial":
		return
	var prior := garden.state
	if garden.undo():
		profile.data.flowers = maxi(0, profile.data.flowers - _flower_count(prior) + _flower_count(garden.state))
		profile.data.chains = maxi(0, profile.data.chains - prior.chains + garden.state.chains)
		profile.data.badges = profile.badges()
		profile.store(session_key, garden)
		_save()
		active_tool = 0
		board.show_state(garden.state)
		_refresh()
		feedback.text = "MOVE RESTORED"

func _dialog(title: String, message: String, height: float) -> Panel:
	_close_overlay()
	var focused := get_viewport().gui_get_focus_owner()
	if focused != null:
		focused.release_focus()
	var shade := ColorRect.new()
	shade.color = Color(0.055, 0.11, 0.10, .79)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_position(shade, Rect2(Vector2.ZERO, size), self)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	move_child(shade, canvas.get_index())
	# Canvas receives only the modal while the full-viewport shade blocks background taps.
	overlay = Control.new()
	overlay.size = canvas.size
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.set_meta("shade", shade)
	canvas.add_child(overlay)
	var dialog := _panel(overlay, Rect2(60, (1280.0 - height) * 0.5, 600, height))
	var heading := _label(dialog, title, Rect2(15, 26, 570, 72), 46, GOLD)
	heading.add_theme_font_override("font", TITLE_FONT)
	var detail := _label(dialog, message, Rect2(36, 106, 528, 134), 27)
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if profile.data.settings.motion:
		dialog.pivot_offset = dialog.size * .5
		dialog.scale = Vector2.ONE * .94
		dialog.create_tween().tween_property(dialog, "scale", Vector2.ONE, .21).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	return dialog

func _close_overlay() -> void:
	if is_instance_valid(overlay):
		var shade: Control = overlay.get_meta("shade")
		remove_child(shade)
		shade.queue_free()
		canvas.remove_child(overlay)
		overlay.queue_free()
		overlay = null

func _pause() -> void:
	if locked:
		return
	var dialog := _dialog("Garden Paused", "Your garden is saved between moves.", 590)
	_button(dialog, "Resume", Rect2(45, 222, 510, 73), _close_overlay, MOSS)
	_button(dialog, "Settings", Rect2(45, 311, 510, 73), _settings)
	_button(dialog, "Restart", Rect2(45, 400, 246, 73), _confirm_restart)
	_button(dialog, "Home", Rect2(309, 400, 246, 73), _home)
	_label(dialog, "PLANT   ·   PULSE   ·   BLOOM", Rect2(45, 503, 510, 43), 21, GOLD)

func _confirm_restart() -> void:
	var dialog := _dialog("Start Again?", "Restart this garden from its opening board.", 424)
	_button(dialog, "Restart", Rect2(44, 241, 248, 82), _start.bind(mode, garden.state.puzzle.get("id", 0), true), MOSS)
	_button(dialog, "Back", Rect2(308, 241, 248, 82), _pause)

func _settings() -> void:
	var dialog := _dialog("Settings", "Make the garden feel right for you.", 827)
	var settings: Dictionary = profile.data.settings
	var y := 221
	for entry: Array in [["music", "Music"], ["sound", "Sound"], ["haptics", "Vibration"], ["motion", "Full Motion"], ["fast", "Fast Effects"]]:
		var key: String = entry[0]
		var title: String = entry[1]
		_button(dialog, "%s  ·  %s" % [title, "On" if settings[key] else "Off"], Rect2(48, y, 504, 62), _toggle.bind(key), GREEN, 26)
		y += 70
	_button(dialog, "Graphics  ·  %s" % ["Low", "Balanced", "High"][clampi(settings.quality, 0, 2)], Rect2(48, y, 504, 62), _toggle.bind("quality"), GREEN, 26)
	_button(dialog, "Replay tutorial", Rect2(48, 649, 504, 62), _start.bind("tutorial", 0, true), MOSS, 26)
	var back_action := _pause if page_name == "game" else _close_overlay
	_button(dialog, "Back", Rect2(48, 728, 504, 64), back_action)

func _toggle(key: String) -> void:
	if key == "quality":
		profile.data.settings[key] = (profile.data.settings[key] + 1) % 3
	else:
		profile.data.settings[key] = not profile.data.settings[key]
	_apply_settings()
	_save()
	_settings()

func _boosters() -> void:
	if locked:
		return
	var dialog := _dialog("Garden Tools", "Choose a tool, then tap a plant.\nEach tool has one charge per garden.", 565)
	for tool in range(1, 4):
		var charges: int = garden.state.boosts[tool]
		var labels := ["", "Water  ·  Grow one stage", "Shovel  ·  Remove a plant", "Color Magic  ·  Change species"]
		var control := _button(dialog, "%s  (%d)" % [labels[tool], charges], Rect2(38, 245 + (tool - 1) * 70, 524, 62), _arm.bind(tool), GREEN, 23)
		control.disabled = charges <= 0
	_button(dialog, "Back", Rect2(38, 465, 524, 62), _arm.bind(0))

func _arm(tool: int) -> void:
	active_tool = tool
	_close_overlay()
	_refresh()
	feedback.text = "TAP A PLANT" if tool > 0 else ""

func _result() -> void:
	var state := garden.state
	var won: bool = state.status == "won"
	var title := "Garden Complete" if won else "Garden Closed"
	if mode == "tutorial":
		title = "You're Ready to Bloom"
	var detail := "%d points  ·  %d flowers\n%d moves  ·  Best chain %d" % [state.score, _flower_count(state), state.moves, state.combo]
	if mode == "endless":
		detail += "\n%s  ·  %d" % ["New best" if new_record else "Endless best", profile.data.best]
	elif mode == "level" and won:
		detail += "\n" + "★".repeat(profile.data.levels[str(state.puzzle.id)].stars)
	elif not won and mode != "endless":
		detail += "\n%s  %d/%d" % [Puzzles.description(state.puzzle), garden.objective(), state.puzzle.target]
	var dialog := _dialog(title, detail, 570)
	sound.play("won" if won else "lost")
	if won and profile.data.settings.haptics:
		Input.vibrate_handheld(38)
	if mode == "tutorial":
		_button(dialog, "Free play", Rect2(41, 263, 518, 81), _start.bind("endless"), MOSS)
	elif mode == "level" and won and state.puzzle.id < Puzzles.LEVEL_COUNT:
		_button(dialog, "Next level", Rect2(41, 263, 518, 81), _start.bind("level", state.puzzle.id + 1), MOSS)
	else:
		_button(dialog, "Play again", Rect2(41, 263, 518, 81), _start.bind(mode, state.puzzle.get("id", 0), true), MOSS)
	_button(dialog, "Home", Rect2(41, 365, 518, 71), _home)
	if mode == "level":
		_button(dialog, "Garden Path", Rect2(41, 455, 518, 71), _levels)
