extends "res://tools/test_intro.gd"

func run() -> void:
	await frames(2)
	var audio = root.get_node("SoundFX")
	for cue in audio.streams:
		check(audio.streams[cue] is AudioStream and audio.streams[cue].get_length() > 0, "Decoded audio: " + cue)
	var original: bool = audio.muted
	audio.muted = true
	var cursor: int = audio.next_voice
	audio.play_sound("step")
	check(audio.next_voice == cursor, "Muted cue does not allocate a voice")
	audio.muted = false
	for index in range(20):
		audio.play_sound("step")
	check(audio.voices.size() == 8, "Repeated cues use bounded voice pool")
	await frames(120)
	audio.muted = original
	AudioServer.set_bus_mute(0, original)
	print("AUDIO_RESULT: ", checks - failures.size(), "/", checks, " passed")
	quit(0 if failures.is_empty() else 1)
