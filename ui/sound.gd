class_name GardenSound
extends Node

const CLIPS := {
	"tap": preload("res://assets/audio/tap.ogg"),
	"plant": preload("res://assets/audio/plant.ogg"),
	"pulse": preload("res://assets/audio/pulse.ogg"),
	"growth": preload("res://assets/audio/growth.ogg"),
	"match": preload("res://assets/audio/match.ogg"),
	"blast": preload("res://assets/audio/blast.ogg"),
	"combo": preload("res://assets/audio/combo.ogg"),
	"echo": preload("res://assets/audio/echo.ogg"),
	"shovel": preload("res://assets/audio/shovel.ogg"),
	"won": preload("res://assets/audio/won.ogg"),
	"lost": preload("res://assets/audio/lost.ogg")
}
const MUSIC = preload("res://assets/audio/garden.ogg")

var players: Array[AudioStreamPlayer] = []
var music: AudioStreamPlayer
var cursor := 0
var enabled := true

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	for i in 4:
		var player := AudioStreamPlayer.new()
		player.volume_db = -13
		add_child(player)
		players.append(player)
	music = AudioStreamPlayer.new()
	music.stream = MUSIC.duplicate()
	music.stream.loop = true
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
	if not enabled or players.is_empty() or not CLIPS.has(kind):
		return
	var player := players[cursor]
	player.stream = CLIPS[kind]
	player.play()
	cursor = (cursor + 1) % players.size()
