class_name Puzzles
extends RefCounted

const LEVEL_COUNT := 24
const NAMES := ["Green", "Pink", "Blue", "Golden"]

static func tutorial() -> Dictionary:
	return {
		"id": 0, "seed": 17, "goal": "echo", "target": 1, "limit": 7, "tray": [1, 0, 2],
		"plants": [[0, 1, 2], [1, 1, 1], [2, 1, 0]],
		"guide": [[3, 0], [8, 1], [1, 2]]
	}

static func level(id: int) -> Dictionary:
	@warning_ignore("integer_division")
	var band := mini(3, (id - 1) / 6)
	var color := (id - 1) % 3
	var next := (color + 1) % 3
	var third := (color + 2) % 3
	var puzzle := {
		"id": id, "seed": id * 671 + 7, "goal": "flowers", "color": color, "target": 3,
		"limit": 7 - band, "tray": [next, third, color], "species": 3,
		"plants": [[0, color, 2], [1, color, 2], [2, color, 1]],
		"guide": [[3, 0]]
	}
	if band >= 1:
		puzzle.plants[2][2] = 0
		puzzle.guide.append([4, 1])
	if band == 1:
		puzzle.goal = "echo"
		puzzle.target = 1
		puzzle.guide.append([1, 2])
	if band >= 2:
		puzzle.goal = "chain"
		puzzle.target = 1
		puzzle.plants.append_array([[6, next, 1], [7, next, 1], [8, next, 1]])
	if band == 3:
		puzzle.goal = "score"
		puzzle.target = 875
		puzzle.rocks = [10, 15, 22, 24, 31]
		puzzle.plants.append_array([[12, third, 1], [13, color, 0], [17, next, 0], [26, third, 2]])
		if id >= 21:
			puzzle.species = 4
			puzzle.plants[3][1] = 3
			puzzle.plants[4][1] = 3
			puzzle.plants[5][1] = 3
	# Change board geometry without changing the verified solution.
	var variant := (id - 1) % 6
	for entry: Array in puzzle.plants:
		entry[0] = _transform(entry[0], variant)
	for entry: Array in puzzle.guide:
		entry[0] = _transform(entry[0], variant)
	if puzzle.has("rocks"):
		for i in puzzle.rocks.size():
			puzzle.rocks[i] = _transform(puzzle.rocks[i], variant)
	return puzzle

static func _transform(index: int, variant: int) -> int:
	var point := Garden.coord(index)
	if variant >= 4:
		point = Vector2i(point.y, point.x)
	if variant % 2 == 1:
		point.x = 5 - point.x
	if variant in [2, 3, 5]:
		point.y = 5 - point.y
	return Garden.index_at(point)

static func daily(date: String) -> Dictionary:
	var serial := int(date.replace("-", ""))
	var puzzle := level(13 + serial % 12)
	puzzle.seed = serial + 375109
	puzzle.date = date
	puzzle.limit += 2
	return puzzle

static func description(puzzle: Dictionary) -> String:
	match puzzle.get("goal", ""):
		"flowers":
			return "%s flowers" % NAMES[puzzle.color]
		"echo":
			return "Echo activations"
		"chain":
			return "Chain reactions"
	return "Points"
