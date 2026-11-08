class_name GardenSound
extends Node

const RATE := 22050
const TUNES := {
	"tap": [74], "plant": [53, 65], "pulse": [65, 69, 74],
	"growth": [76, 79], "match": [77, 81], "blast": [60, 72, 77, 81],
	"echo": [74, 81, 86], "shovel": [50, 55], "won": [72, 76, 79, 84, 88],
	"lost": [69, 65, 60]
}
var clips := {}
var players: Array[AudioStreamPlayer] = []
var music: AudioStreamPlayer
var cursor := 0
var enabled := true

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	for key: String in TUNES:
		clips[key] = _render(TUNES[key], 0.065, 0.22)
	for i in 4:
		var player := AudioStreamPlayer.new()
		player.volume_db = -13
		add_child(player)
		players.append(player)
	music = AudioStreamPlayer.new()
	music.stream = _render([
		60, 67, 76, 72, 67, 72, 76, 79, 57, 64, 76, 72, 64, 69, 76, 72,
		53, 60, 69, 72, 60, 65, 69, 72, 55, 62, 71, 74, 62, 67, 71, 0
	], 0.39, 0.85, true)
	music.volume_db = -22
	add_child(music)

func configure(settings: Dictionary) -> void:
	enabled = settings.sound
	if music == null:
		return
	if settings.music and not music.playing:
		music.play()
	elif not settings.music:
		music.stop()

func play(kind: String) -> void:
	if not enabled or not clips.has(kind):
		return
	var player := players[cursor]
	player.stream = clips[kind]
	player.play()
	cursor = (cursor + 1) % players.size()

func _render(notes: Array, step: float, release: float, loop: bool = false) -> AudioStreamWAV:
	var samples := int(RATE * (step * notes.size() + (0.0 if loop else release)))
	var pcm := PackedByteArray()
	pcm.resize(samples * 2)
	var step_samples := int(RATE * step)
	for i in samples:
		var value := 0.0
		@warning_ignore("integer_division")
		var last := mini(notes.size() - 1, i / step_samples)
		for n in range(maxi(0, last - ceili(release / step)), last + 1):
			var age := float(i - n * step_samples) / RATE
			if age >= release or notes[n] == 0:
				continue
			var frequency := 440.0 * pow(2.0, (notes[n] - 69.0) / 12.0)
			var wave := sin(TAU * frequency * age) + 0.23 * sin(TAU * 2.01 * frequency * age)
			var envelope := minf(1.0, age * 115.0) * pow(1.0 - age / release, 2.8)
			value += wave * envelope * 0.23
		if loop:
			value *= minf(1.0, float(samples - i) / 4000.0)
		pcm.encode_s16(i * 2, int(clampf(value, -1.0, 1.0) * 32767))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = RATE
	stream.data = pcm
	if loop:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_end = samples
	return stream
