extends SceneTree

const DEFAULT_RUNS := 12
const DEFAULT_CAP := 100
const STRATEGIES := ["random", "greedy", "space", "growth", "lookahead"]

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 3 or (args.size() >= 1 and not args[0].is_valid_int()) or (args.size() >= 2 and not args[1].is_valid_int()):
		_usage_error()
		return
	var runs := int(args[0]) if args.size() >= 1 else DEFAULT_RUNS
	var cap := int(args[1]) if args.size() >= 2 else DEFAULT_CAP
	var strategy_filter := args[2] if args.size() == 3 else ""
	if runs < 1 or cap < 1 or (not strategy_filter.is_empty() and strategy_filter not in STRATEGIES):
		_usage_error()
		return
	print("Endless simulation: %d seeds, maximum %d moves per seed" % [runs, cap])
	for strategy: String in STRATEGIES:
		if not strategy_filter.is_empty() and strategy != strategy_filter:
			continue
		var totals := [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
		var highest := 0
		var capped := 0
		var wins := 0
		var rng := RandomNumberGenerator.new()
		rng.seed = 401
		for i in runs:
			var garden := Garden.new(137 * i + 13)
			garden.collect_events = false
			while garden.state.status == "playing" and garden.state.moves < cap:
				var moves := legal(garden)
				var action := choose(garden, moves, strategy, rng)
				garden.place(action.x, action.y)
				totals[4] += 36 - garden.state.board.count(Garden.EMPTY)
				totals[5] += moves.size()
			totals[0] += garden.state.moves
			totals[1] += garden.state.score
			totals[2] += garden.state.combo
			totals[3] += garden.state.echoes
			highest = maxi(highest, garden.state.score)
			capped += int(garden.state.status == "playing")
		for id in range(1, Puzzles.LEVEL_COUNT + 1):
			var puzzle := Puzzles.level(id)
			var garden := Garden.new(puzzle.seed, puzzle)
			garden.collect_events = false
			while garden.state.status == "playing":
				var action := choose(garden, legal(garden), strategy, rng)
				garden.place(action.x, action.y)
			wins += int(garden.state.status == "won")
		print("%s | moves %.1f | score %.0f | best %d | max chain avg %.2f | Echo %.2f | occupied %.1f | legal %.1f | full %d | capped %d | levels %d/%d" % [
			strategy, totals[0] / runs, totals[1] / runs, highest, totals[2] / runs, totals[3] / runs,
			totals[4] / totals[0], totals[5] / totals[0], runs - capped, capped, wins, Puzzles.LEVEL_COUNT
		])
	quit()

func _usage_error() -> void:
	push_error("Usage: godot --headless -s tests/balance.gd -- [runs] [move_cap] [strategy]")
	quit(2)

func legal(garden: Garden) -> Array[Vector2i]:
	var actions: Array[Vector2i] = []
	var seen := {}
	for slot in 3:
		var kind: int = garden.state.tray[slot]
		if kind < 0 or seen.has(kind):
			continue
		seen[kind] = true
		for cell in Garden.COUNT:
			if garden.can_place(cell, slot):
				actions.append(Vector2i(cell, slot))
	return actions

func trial(garden: Garden, move: Vector2i) -> Garden:
	var branch := Garden.new()
	branch.collect_events = false
	branch.state = garden.state.duplicate(true)
	branch.place(move.x, move.y)
	return branch

func choose(garden: Garden, actions: Array[Vector2i], strategy: String, rng: RandomNumberGenerator) -> Vector2i:
	if strategy == "random":
		return actions[rng.randi_range(0, actions.size() - 1)]
	var ranked: Array[Dictionary] = []
	for action: Vector2i in actions:
		var branch := trial(garden, action)
		var merit := evaluate(branch, strategy) + rng.randf() * .001
		ranked.append({"merit": merit, "action": action, "branch": branch})
	ranked.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.merit > b.merit)
	if strategy != "lookahead":
		return ranked[0].action
	var strongest: Vector2i = ranked[0].action
	var best := -INF
	for candidate: Dictionary in ranked.slice(0, 3):
		var branch: Garden = candidate.branch
		var value: float = candidate.merit
		for action: Vector2i in legal(branch):
			value = maxf(value, evaluate(trial(branch, action), strategy))
		if value > best:
			best = value
			strongest = candidate.action
	return strongest

func evaluate(garden: Garden, strategy: String) -> float:
	var state := garden.state
	var score: float = state.score
	if state.status == "won":
		return score + 1000000.0
	if state.status == "lost":
		return score - 1000000.0
	if strategy == "greedy":
		return score
	score += 95.0 * state.board.count(Garden.EMPTY)
	if strategy == "space":
		for row in Garden.SIDE:
			var row_open := 0
			var column_open := 0
			for column in Garden.SIDE:
				row_open += int(state.board[Garden.index_at(Vector2i(column, row))] == Garden.EMPTY)
				column_open += int(state.board[Garden.index_at(Vector2i(row, column))] == Garden.EMPTY)
			score -= (row_open * row_open + column_open * column_open) * 2.0
		return score
	score += garden.objective() * (3.0 if state.puzzle.get("goal", "score") == "score" else 1000.0)
	for cell in Garden.COUNT:
		var value: int = state.board[cell]
		if value < 0:
			continue
		score += float(value % 3) * 1.5
		for direction in [Vector2i.RIGHT, Vector2i.DOWN]:
			var next: Vector2i = Garden.coord(cell) + direction
			if not Garden.inside(next):
				continue
			var neighbor: int = state.board[Garden.index_at(next)]
			if neighbor >= 0 and Garden.species(value) == Garden.species(neighbor):
				score += 18.0 + 4.0 * (value % 3 + neighbor % 3)
				next += direction
				if Garden.inside(next):
					var third: int = state.board[Garden.index_at(next)]
					if third == Garden.EMPTY or (third >= 0 and Garden.species(third) == Garden.species(value)):
						score += 12.0
	return score
