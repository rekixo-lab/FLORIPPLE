class_name Profile
extends RefCounted

var path := "user://floripple.save"
var data := {
	"version": 1, "sessions": {}, "levels": {}, "daily": {}, "best": 0,
	"tutorial": false, "flowers": 0, "chains": 0, "badges": {},
	"settings": {"music": true, "sound": true, "haptics": true, "motion": true, "quality": 2, "fast": false}
}

func load_game() -> void:
	for file in [path, path + ".bak"]:
		var decoded := _read(file)
		if decoded.is_empty():
			continue
		data.merge(decoded, true)
		return

func _read(file: String) -> Dictionary:
	if not FileAccess.file_exists(file):
		return {}
	var bytes := FileAccess.get_file_as_bytes(file)
	if bytes.size() < 33 or bytes.size() > 4_000_000:
		return {}
	var payload := bytes.slice(32)
	if bytes.slice(0, 32) != _checksum(payload):
		return {}
	var decoded: Variant = bytes_to_var(payload)
	if not decoded is Dictionary or decoded.get("version") != data.version:
		return {}
	for key: String in data:
		if not decoded.has(key) or typeof(decoded[key]) != typeof(data[key]):
			return {}
	for key: String in data.settings:
		if not decoded.settings.has(key) or typeof(decoded.settings[key]) != typeof(data.settings[key]):
			return {}
	for key: Variant in decoded.sessions:
		var session: Variant = decoded.sessions[key]
		if not session is Dictionary or not Garden.valid(session.get("state")):
			decoded.sessions.erase(key)
		elif not session.get("previous") is Dictionary or (not session.previous.is_empty() and not Garden.valid(session.previous)):
			session.previous = {}
	return decoded

func _checksum(payload: PackedByteArray) -> PackedByteArray:
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(payload)
	return context.finish()

func save_game() -> Error:
	var temporary := FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if temporary == null:
		return FileAccess.get_open_error()
	var bytes := var_to_bytes(data)
	temporary.store_buffer(_checksum(bytes))
	temporary.store_buffer(bytes)
	temporary.flush()
	var result := temporary.get_error()
	temporary.close()
	if result != OK:
		return result
	if not _read(path).is_empty():
		result = DirAccess.copy_absolute(path, path + ".bak")
		if result != OK:
			return result
	return DirAccess.rename_absolute(path + ".tmp", path)

func restore(key: String) -> Garden:
	if not data.sessions.has(key):
		return null
	var record: Dictionary = data.sessions[key]
	var garden := Garden.new()
	garden.state = record.state.duplicate(true)
	garden.previous = record.previous.duplicate(true)
	return garden

func store(key: String, garden: Garden) -> void:
	data.sessions[key] = {"state": garden.state.duplicate(true), "previous": garden.previous.duplicate(true)}

func badges() -> Dictionary:
	var best: int = data.best
	var levels: int = data.levels.size()
	return {
		"First Bloom": data.flowers >= 3, "First Combo": data.chains >= 1,
		"Five Chains": data.chains >= 5, "Hundred Petals": data.flowers >= 100,
		"Thousand Petals": data.flowers >= 1000, "10,000 Points": best >= 10000,
		"50,000 Points": best >= 50000, "Ten Gardens": levels >= 10,
		"Daily Gardener": not data.daily.is_empty()
	}
