extends SceneTree

var failures := 0
var checks := 0

func check(condition: bool, description: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(description)

func _initialize() -> void:
	var g := Garden.new(9)
	check(g.state.board.size() == 36, "36 cells")
	check(Garden.index_at(Garden.coord(35)) == 35, "coordinate round trip")
	g.state.board[7] = Garden.plant(0, 0)
	g.state.board[13] = Garden.plant(1, 1)
	g.state.board[14] = Garden.plant(1, 1)
	check(g.place(1), "legal placement")
	check(g.state.board[1] % 3 == 0, "new plant excluded")
	check(g.state.board[7] % 3 == 1 and g.state.board[13] % 3 == 2 and g.state.board[14] % 3 == 1, "exact cross growth")
	check(g.events[1].cells.size() == 11, "11 unique pulse cells")
	var stable := g.state.duplicate(true)
	check(not g.place(1) and not g.place(-1) and not g.place(36) and g.state == stable, "invalid input is inert")
	check(g.undo() and g.state.moves == 0 and g.state.board[1] == Garden.EMPTY and g.state.boosts[0] == 0, "undo restores state")

	for entry in [
		[[0, 1, 2], 1], [[0, 6, 12], 1], [[0, 1, 2, 3], 1],
		[[0, 6, 12, 18, 24], 1], [[0, 1, 2, 7, 13], 2],
		[[0, 7, 14], 0], [[0, 2, 3], 0]
	]:
		g = Garden.new()
		for cell: int in entry[0]:
			g.state.board[cell] = 2
		check(g.matches().runs == entry[1], "maximal runs %s" % [entry])
	g = Garden.new()
	g.state.board[0] = 2
	g.state.board[1] = 1
	g.state.board[2] = 5
	check(g.matches().cells.is_empty(), "buds and mixed colors do not match")

	g = Garden.new(17, {"plants": [[0, 0, 2], [1, 0, 2], [2, 0, 1], [6, 1, 1], [7, 1, 1], [8, 1, 1]]})
	g.place(3)
	check(g.state.score == 875 and g.state.combo == 2 and g.state.chains == 1, "chain multipliers and growth")
	check(g.state.echo[0] == 2 and g.state.echo[7] == 2, "fresh Echo lasts two moves")
	g.place(1)
	check(g.state.echoes == 1 and g.state.echo[1] == 0 and g.state.board[1] % 3 == 1, "direct Echo activation grows origin")
	check(g.state.echo[0] == 1, "passing over Echo only ages it")
	g.place(29)
	check(g.state.echo[0] == 0, "Echo expires on second move")
	g = Garden.new(7, {"plants": [[0, 0, 2], [1, 0, 2], [2, 0, 2], [7, 0, 2], [13, 0, 2], [6, 1, 0]]})
	g.state.echo[1] = 1
	g.place(35)
	check(g.state.score == 600 and g.state.cleared[0] == 5 and g.state.board[6] % 3 == 1, "intersection score and unique neighbor growth")
	check(g.state.echo[1] == 2, "new Echo supersedes old charge")
	g = Garden.new(3, {"rocks": [1], "plants": [[2, 0, 0]]})
	g.place(0)
	check(g.state.board[2] == 0, "rock blocks water")

	g = Garden.new(5, {"limit": 1, "target": 350, "plants": [[0, 0, 2], [1, 0, 2], [2, 0, 1]]})
	g.place(3)
	check(g.state.status == "won" and g.remaining() == 0, "goal wins on final move")
	g = Garden.new(5, {"limit": 1, "target": 350})
	g.place(3)
	check(g.state.status == "lost", "move limit failure")
	g = Garden.new()
	for cell in 35:
		g.state.board[cell] = Garden.plant((cell + Garden.coord(cell).y) % 3, 2)
	g.place(35)
	check(g.state.status == "lost", "full board fails")

	g = Garden.new(11, {"plants": [[0, 0, 2], [1, 0, 2], [2, 0, 1], [9, 1, 0], [15, 1, 2], [21, 1, 2]]})
	g.state.echo[3] = 2
	g.place(3)
	check(g.state.score == 875 and g.state.combo == 2 and g.state.echoes == 1, "Echo cascades continue the turn multiplier")
	check(g.events.filter(func(event: Dictionary) -> bool: return event.kind == "echo").size() == 1, "one Echo pulse per placement")

	g = Garden.new(4, {"plants": [[0, 0, 2], [1, 0, 2], [2, 0, 1], [35, 1, 2]]})
	check(not g.boost(35, 1) and g.state.boosts[1] == 1, "water rejects mature plants without consuming charge")
	check(g.boost(2, 1) and g.state.score == 350 and g.state.moves == 0 and g.state.boosts[1] == 0, "water uses shared match resolver")
	check(g.boost(35, 2) and g.state.board[35] == Garden.EMPTY and g.state.echo[35] == 0 and g.state.score == 350, "shovel removal has no score or Echo")
	g = Garden.new(4, {"species": 4, "plants": [[0, 2, 1]]})
	check(g.boost(0, 3) and g.state.board[0] == Garden.plant(3, 1), "Color Magic preserves growth stage")

	g = Garden.new()
	for cell in 36:
		g.state.board[cell] = Garden.plant((cell + Garden.coord(cell).y) % 3, 2)
	g.state.board[0] = 2
	g.state.board[1] = 2
	g.state.board[2] = 1
	g.state.board[3] = Garden.EMPTY
	g.place(3)
	check(g.state.status == "playing" and g.state.score >= 350, "last space can resolve into new space")

	var puzzle := Puzzles.tutorial()
	verify_solution(puzzle, "tutorial")
	for level in range(1, Puzzles.LEVEL_COUNT + 1):
		verify_solution(Puzzles.level(level), "level %d" % level)
	for day in range(1, 29):
		var date := "2026-11-%02d" % day
		verify_solution(Puzzles.daily(date), date)
		check(Puzzles.daily(date) == Puzzles.daily(date), "daily reproducible")
	var copy := Garden.new(36)
	g = Garden.new(36)
	for cell in 35:
		g.place(cell)
		copy.place(cell)
		check(g.state == copy.state and g.state.last_batch.count(g.state.last_batch[0]) < 3, "deterministic replay and tray diversity")

	var profile := Profile.new()
	profile.path = "user://rules-test.save"
	for ext in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute(profile.path + ext)
	profile.store("endless", g)
	check(profile.save_game() == OK, "save writes")
	profile.data.best = 1234
	check(profile.save_game() == OK, "second save writes")
	var restored := Profile.new()
	restored.path = profile.path
	restored.load_game()
	check(restored.data.best == 1234 and restored.restore("endless").state == g.state, "complete stable restore")
	var corrupt := FileAccess.open(profile.path, FileAccess.WRITE)
	corrupt.store_string("corrupt save")
	corrupt.close()
	restored = Profile.new()
	restored.path = profile.path
	restored.load_game()
	check(restored.data.best == 0 and restored.restore("endless").state == g.state, "backup recovers corrupt primary")
	for ext in ["", ".bak", ".tmp"]:
		DirAccess.remove_absolute(profile.path + ext)
	print("%d checks, %d failures" % [checks, failures])
	quit(int(failures > 0))

func verify_solution(puzzle: Dictionary, description: String) -> void:
	var g := Garden.new(puzzle.seed, puzzle)
	for action: Array in puzzle.guide:
		check(g.place(action[0], action[1]), "%s solution move" % description)
	check(g.state.status == "won", "%s solvable" % description)
