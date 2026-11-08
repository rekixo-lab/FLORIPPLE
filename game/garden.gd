class_name Garden
extends RefCounted

const SIDE := 6
const COUNT := SIDE * SIDE
const VERSION := 1
const EMPTY := -1
const ROCK := -2
const DIRECTIONS := [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]

var state: Dictionary
var previous: Dictionary = {}
var events: Array[Dictionary] = []
var collect_events := true

func _init(seed_value: int = 1, puzzle: Dictionary = {}) -> void:
	var board := []
	var echo := []
	board.resize(COUNT)
	board.fill(EMPTY)
	echo.resize(COUNT)
	echo.fill(0)
	state = {
		"version": VERSION, "seed": seed_value, "rng": posmod(seed_value, 2147483646) + 1,
		"board": board, "echo": echo, "tray": [], "last_batch": [], "slot": 0,
		"score": 0, "moves": 0, "cleared": [0, 0, 0, 0], "echoes": 0,
		"combo": 0, "chains": 0, "status": "playing", "puzzle": puzzle.duplicate(true),
		"boosts": [1, 1, 1, 1 if puzzle.get("species", 3) == 4 else 0]
	}
	for entry: Array in puzzle.get("plants", []):
		board[entry[0]] = plant(entry[1], entry[2])
	for cell: int in puzzle.get("rocks", []):
		board[cell] = ROCK
	_refill()
	if puzzle.has("tray"):
		state.tray = puzzle.tray.duplicate()
		state.last_batch = state.tray.duplicate()

static func plant(species: int, stage: int) -> int:
	return species * 3 + stage

static func species(value: int) -> int:
	@warning_ignore("integer_division")
	return value / 3

static func coord(index: int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(index % SIDE, index / SIDE)

static func inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < SIDE and cell.y >= 0 and cell.y < SIDE

static func index_at(cell: Vector2i) -> int:
	return cell.y * SIDE + cell.x

func _random(bound: int) -> int:
	state.rng = (int(state.rng) * 48271) % 2147483647
	return state.rng % bound

func _refill() -> void:
	var count: int = state.puzzle.get("species", 3)
	var batch: Array
	while true:
		batch = [_random(count), _random(count), _random(count)]
		if batch.count(batch[0]) < 3 and batch != state.last_batch:
			break
	state.tray = batch
	state.last_batch = batch.duplicate()

func select(slot: int) -> bool:
	if slot < 0 or slot >= 3 or state.tray[slot] == EMPTY or state.status != "playing":
		return false
	state.slot = slot
	return true

func can_place(cell: int, slot: int) -> bool:
	return state.status == "playing" and cell >= 0 and cell < COUNT and slot >= 0 and slot < 3 and state.board[cell] == EMPTY and state.tray[slot] >= 0

func preview(cell: int, slot: int = -1) -> Dictionary:
	if slot == -1:
		slot = state.slot
	if not can_place(cell, slot):
		return {}
	var trial := Garden.new()
	trial.state = state.duplicate(true)
	trial.place(cell, slot)
	var watered := {}
	var growth := {}
	var blooms := {}
	var waves := 0
	for event: Dictionary in trial.events:
		match event.kind:
			"pulse", "echo":
				for affected: int in event.cells:
					watered[affected] = true
			"growth":
				for affected: int in event.cells:
					growth[affected] = event.board[affected]
			"match":
				waves += 1
				for affected: int in event.cells:
					blooms[affected] = true
	return {
		"cell": cell, "seed": plant(state.tray[slot], 0), "watered": watered,
		"growth": growth, "blooms": blooms, "waves": waves,
		"points": trial.state.score - state.score, "echo": state.echo[cell] > 0
	}

func place(cell: int, slot: int = -1) -> bool:
	if slot == -1:
		slot = state.slot
	if not can_place(cell, slot):
		return false
	_begin()
	var active_echo: bool = state.echo[cell] > 0
	var fresh := {}
	state.board[cell] = plant(state.tray[slot], 0)
	state.tray[slot] = EMPTY
	_record("plant", {"origin": cell})
	_pulse(cell, false)
	var wave := _resolve(fresh, 0)
	if active_echo:
		state.echoes += 1
		_pulse(cell, true)
		_resolve(fresh, wave)
	for i in COUNT:
		state.echo[i] = 0 if i == cell else maxi(0, state.echo[i] - 1)
	for i: int in fresh:
		state.echo[i] = 2
	state.moves += 1
	if state.tray.count(EMPTY) == 3:
		_refill()
	state.slot = slot if state.tray[slot] >= 0 else _first_slot()
	_evaluate()
	return true

func _first_slot() -> int:
	for slot in 3:
		if state.tray[slot] >= 0:
			return slot
	return -1

func _begin() -> void:
	previous = state.duplicate(true)
	events.clear()

func _record(kind: String, details: Dictionary) -> void:
	if not collect_events:
		return
	details.merge({
		"kind": kind, "board": state.board.duplicate(),
		"echo": state.echo.duplicate(), "score": state.score
	})
	events.append(details)

func _pulse(origin: int, echo: bool) -> void:
	var cells := [origin]
	for direction: Vector2i in DIRECTIONS:
		var next := coord(origin) + direction
		while inside(next) and state.board[index_at(next)] != ROCK:
			cells.append(index_at(next))
			next += direction
	var growth := cells.duplicate()
	if not echo:
		growth.erase(origin)
	_record("echo" if echo else "pulse", {"origin": origin, "cells": cells})
	_grow(growth)

func _grow(cells: Array) -> void:
	var changed := []
	for cell: int in cells:
		var value: int = state.board[cell]
		if value >= 0 and value % 3 < 2:
			state.board[cell] += 1
			changed.append(cell)
	if not changed.is_empty():
		_record("growth", {"cells": changed})

func matches() -> Dictionary:
	var found := {}
	var runs := 0
	for direction in [Vector2i.RIGHT, Vector2i.DOWN]:
		for line in SIDE:
			var run := []
			var last := EMPTY
			for offset in range(SIDE + 1):
				var position: Vector2i = Vector2i(0, line) + direction * offset if direction == Vector2i.RIGHT else Vector2i(line, offset)
				var cell := index_at(position)
				var value: int = state.board[cell] if offset < SIDE else EMPTY
				if value < 0 or value % 3 != 2:
					value = EMPTY
				if value != last or value == EMPTY:
					if run.size() >= 3:
						runs += 1
						for member: int in run:
							found[member] = true
					run.clear()
				if value != EMPTY:
					run.append(cell)
				last = value
	return {"cells": found.keys(), "runs": runs}

func _resolve(fresh: Dictionary, wave: int) -> int:
	@warning_ignore("integer_division")
	for _step in range(COUNT / 3):
		var match_result := matches()
		var cells: Array = match_result.cells
		if cells.is_empty():
			break
		wave += 1
		_record("match", {"cells": cells, "wave": wave})
		var neighbors := {}
		for cell: int in cells:
			state.cleared[species(state.board[cell])] += 1
			state.board[cell] = EMPTY
			fresh[cell] = true
			for direction: Vector2i in DIRECTIONS:
				var neighbor := coord(cell) + direction
				if inside(neighbor):
					neighbors[index_at(neighbor)] = true
		var multiplier := minf(3.0, 1.0 + (wave - 1) * 0.5)
		var points := roundi((cells.size() * 100 + match_result.runs * 50) * multiplier)
		state.score += points
		state.combo = maxi(state.combo, wave)
		if wave > 1:
			state.chains += 1
		_record("blast", {"cells": cells, "wave": wave, "points": points, "multiplier": multiplier})
		_grow(neighbors.keys())
	return wave

func objective() -> int:
	match state.puzzle.get("goal", "score"):
		"learn":
			return state.moves
		"flowers":
			return state.cleared[state.puzzle.color]
		"echo":
			return state.echoes
		"chain":
			return state.chains
	return state.score

func remaining() -> int:
	return maxi(0, state.puzzle.get("limit", 0) - state.moves)

func _evaluate() -> void:
	if state.puzzle.has("target") and objective() >= state.puzzle.target:
		state.status = "won"
	elif not state.board.has(EMPTY) or (state.puzzle.has("limit") and remaining() == 0):
		state.status = "lost"

func undo() -> bool:
	if previous.is_empty() or state.status != "playing" or state.boosts[0] <= 0:
		return false
	var charges: int = state.boosts[0] - 1
	state = previous
	state.boosts[0] = charges
	previous = {}
	events.clear()
	return true

func boost(cell: int, tool: int) -> bool:
	if state.status != "playing" or tool < 1 or tool > 3 or state.boosts[tool] <= 0 or cell < 0 or cell >= COUNT:
		return false
	var value: int = state.board[cell]
	if value < 0 or (tool == 1 and value % 3 == 2):
		return false
	_begin()
	state.boosts[tool] -= 1
	match tool:
		1:
			_grow([cell])
		2:
			state.board[cell] = EMPTY
			_record("shovel", {"origin": cell})
		3:
			state.board[cell] = plant((species(value) + 1) % state.puzzle.species, value % 3)
			_record("growth", {"cells": [cell]})
	var fresh := {}
	_resolve(fresh, 0)
	for i: int in fresh:
		state.echo[i] = 2
	_evaluate()
	return true

static func valid(snapshot: Variant) -> bool:
	if not snapshot is Dictionary or snapshot.get("version") != VERSION:
		return false
	var sample := Garden.new()
	for key: String in sample.state:
		if not snapshot.has(key) or typeof(snapshot[key]) != typeof(sample.state[key]):
			return false
	for key in ["board", "echo", "tray", "cleared", "boosts", "last_batch"]:
		if snapshot[key].size() != sample.state[key].size():
			return false
		for value: Variant in snapshot[key]:
			if not value is int:
				return false
	for i in COUNT:
		if snapshot.board[i] < ROCK or snapshot.board[i] > 11 or snapshot.echo[i] < 0 or snapshot.echo[i] > 2:
			return false
	if snapshot.slot < 0 or snapshot.slot >= 3 or snapshot.rng <= 0 or snapshot.rng >= 2147483647:
		return false
	for seed_card: int in snapshot.tray:
		if seed_card < EMPTY or seed_card > 3:
			return false
	return snapshot.status in ["playing", "won", "lost"]
