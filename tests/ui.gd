extends SceneTree

const SCENE := preload("res://scenes/main.tscn")
const TEST_SAVE := "user://ui-test.save"
var app: Control
var failures := 0
var checks := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func click_text(text: String, parent: Node) -> void:
	var button := find_button(text, parent)
	check(button != null and not button.disabled, "click %s" % text)
	if button != null and not button.disabled:
		click_at(button.get_global_transform_with_canvas() * (button.size * .5))

func find_button(text: String, parent: Node) -> Button:
	if not is_instance_valid(parent):
		return null
	for child: Node in parent.get_children():
		if child is Button and child.text == text:
			return child
		var found := find_button(text, child)
		if found != null:
			return found
	return null

func click_at(at: Vector2) -> void:
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = at
		event.global_position = at
		event.pressed = down
		event.button_index = MOUSE_BUTTON_LEFT
		root.push_input(event, true)

func tap_board(cell: int) -> void:
	click_at(app.board.get_global_transform_with_canvas() * app.board.center(cell))

func touch_cell(cell: int, index: int, pressed: bool) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.pressed = pressed
	event.position = root.get_stretch_transform() * (app.board.get_global_transform_with_canvas() * app.board.center(cell))
	Input.parse_input_event(event)
	Input.flush_buffered_events()

func settle() -> void:
	var deadline := Time.get_ticks_msec() + 3500
	while app.locked and Time.get_ticks_msec() < deadline:
		await process_frame
	await process_frame
	check(not app.locked, "presentation unlocks")

func capture(name: String) -> void:
	var folder := OS.get_environment("FLORIPPLE_SCREENSHOTS")
	if folder.is_empty() or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	check(root.get_texture().get_image().save_png(folder.path_join(name + ".png")) == OK, "capture %s" % name)

func run() -> void:
	for ext in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute(TEST_SAVE + ext)
	app = SCENE.instantiate()
	app.profile.path = TEST_SAVE
	root.add_child(app)
	await process_frame
	check(app.page_name == "home", "launch home")
	await capture("home")
	click_text("Play", app.page)
	check(app.mode == "tutorial" and app.board.cue == 3, "guided tutorial")
	app.profile.data.settings.fast = true
	app.profile.data.settings.motion = false
	app.profile.data.settings.music = false
	app._apply_settings()
	await capture("tutorial")
	tap_board(4)
	check(app.garden.state.moves == 0, "invalid tutorial cell")
	touch_cell(3, 0, true)
	touch_cell(8, 1, true)
	touch_cell(8, 1, false)
	touch_cell(3, 0, false)
	tap_board(8)
	check(app.garden.state.moves == 1 and app.locked, "multitouch and rapid second input rejected")
	await settle()
	check(app.board.cue == 8, "second tutorial cue")
	tap_board(8)
	await settle()
	await settle()
	check(app.board.cue == 1 and app.garden.state.score == 350, "tutorial bloom")
	await capture("echo")
	tap_board(1)
	await settle()
	check(app.profile.data.tutorial and app.garden.state.status == "won", "tutorial Echo and completion")
	click_text("Free play", app.overlay)
	check(app.mode == "endless", "tutorial to endless")
	var tray_slot := 1
	var card: Button = app.seed_buttons[tray_slot]
	click_at(card.get_global_transform_with_canvas() * (card.size * .5))
	check(app.garden.state.slot == tray_slot, "seed card selects")
	tap_board(0)
	await settle()
	tap_board(0)
	check(app.garden.state.moves == 1, "occupied tap rejected")
	click_text("Ⅱ", app.page)
	tap_board(2)
	check(app.garden.state.moves == 1, "paused board rejects input")
	click_text("Settings", app.overlay)
	click_text("Graphics  ·  High", app.overlay)
	check(app.board.quality == 0, "quality changes")
	click_text("Back", app.overlay)
	click_text("Home", app.overlay)
	check(app.page_name == "home", "pause to home")
	click_text("Continue garden", app.page)
	check(app.garden.state.moves == 1 and app.garden.state.board[0] >= 0, "resume stable garden")
	click_text("Undo", app.page)
	check(app.garden.state.moves == 0 and app.garden.state.board[0] == Garden.EMPTY, "UI undo")
	click_text("Ⅱ", app.page)
	click_text("Home", app.overlay)
	click_text("Levels", app.page)
	await process_frame
	await capture("levels")
	click_text("01  Open", app.page)
	check(app.mode == "level", "level navigation")
	tap_board(3)
	await settle()
	await settle()
	check(app.profile.data.levels.has("1") and app.garden.state.status == "won", "level rewards saved")
	click_text("Next level", app.overlay)
	check(app.garden.state.puzzle.id == 2, "next level")
	click_text("Ⅱ", app.page)
	click_text("Home", app.overlay)
	click_text("Daily Challenge", app.page)
	click_text("Play today's puzzle", app.overlay)
	check(app.mode == "daily" and app.garden.state.puzzle.date == Time.get_date_string_from_system(true), "UTC daily navigation")
	await capture("daily")
	click_text("Ⅱ", app.page)
	click_text("Home", app.overlay)
	click_text("Progress", app.page)
	check(app.page_name == "progress", "achievement journal navigation")
	click_text("Home", app.page)
	click_text("Endless", app.page)
	var state: Dictionary = app.garden.state
	for cell in 35:
		state.board[cell] = Garden.plant((cell + Garden.coord(cell).y) % 3, 2)
	app.board.show_state(state)
	tap_board(35)
	await settle()
	check(app.garden.state.status == "lost", "game over after stable turn")
	await capture("result")
	click_text("Play again", app.overlay)
	check(app.garden.state.moves == 0 and app.garden.state.board.count(Garden.EMPTY) == 36, "retry clears board")
	var loaded := Profile.new()
	loaded.path = TEST_SAVE
	loaded.load_game()
	check(loaded.data.tutorial and loaded.data.levels.has("1") and loaded.restore("endless").state.moves == 0, "progress survives reload")
	if DisplayServer.get_name() != "headless":
		await create_timer(.65).timeout
	app.free()
	await process_frame
	for ext in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute(TEST_SAVE + ext)
	print("%d UI checks, %d failures" % [checks, failures])
	quit(int(failures > 0))
