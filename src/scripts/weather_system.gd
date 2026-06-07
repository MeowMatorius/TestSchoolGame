extends Node

@export var weather_timer: Timer
@export var fade_duration: float = 2.0 

var weather_nodes: Array[GPUParticles3D] = []
var fade_tweens: Array[Tween] = []
var current_weathers: Array[GPUParticles3D] = [] 


func _ready() -> void:
	weather_nodes.assign(find_children("*", "GPUParticles3D", true, false))
	
	if weather_timer:
		weather_timer.timeout.connect(_on_timer_timeout)
		weather_timer.start()
	else:
		push_error("WeatherTimer не назначен в инспекторе!")
		
	change_weather()


#func _process(_delta: float) -> void:
	#if weather_timer:
		#print(weather_timer.time_left)


func _on_timer_timeout() -> void:
	change_weather()
	
	
func change_weather() -> void:
	if weather_nodes.is_empty():
		return

	for t in fade_tweens:
		if t and t.is_valid():
			t.kill()
	fade_tweens.clear()
	
	var new_weathers: Array[GPUParticles3D] = get_random_weathers()
		
	for node in weather_nodes:
		if node in new_weathers:
			continue
			
		node.emitting = false
		var audio_nodes: Array[Node] = node.find_children("*", "AudioStreamPlayer3D", true, false)
		if not audio_nodes.is_empty():
			var weather_audio: AudioStreamPlayer3D = audio_nodes[0]
			if weather_audio.playing:
				fade_out_audio(weather_audio)
	
	current_weathers = new_weathers
	
	for active_weather in current_weathers:
		if active_weather.emitting:
			continue
			
		active_weather.emitting = true
		
		var active_audio_nodes: Array[Node] = active_weather.find_children("*", "AudioStreamPlayer3D", true, false)
		if not active_audio_nodes.is_empty():
			var active_audio: AudioStreamPlayer3D = active_audio_nodes[0]
			fade_in_audio(active_audio)


func get_random_weathers() -> Array[GPUParticles3D]:
	var result: Array[GPUParticles3D] = []
	
	if weather_nodes.is_empty():
		return result
		
	var available_nodes: Array = weather_nodes.duplicate()
	
	var count: int = randi_range(1, clampi(2, 1, available_nodes.size()))
	
	for i in range(count):
		var picked = available_nodes.pick_random()
		result.append(picked)
		available_nodes.erase(picked)
		
	return result


func fade_out_audio(audio: AudioStreamPlayer3D) -> void:
	var tween: Tween = create_tween()
	fade_tweens.append(tween)
	
	tween.tween_property(audio, "volume_db", -80.0, fade_duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN)
	
	tween.tween_callback(audio.stop)


func fade_in_audio(audio: AudioStreamPlayer3D) -> void:
	var tween: Tween = create_tween()
	fade_tweens.append(tween)
	
	audio.volume_db = -80.0
	audio.play()
	
	tween.tween_property(audio, "volume_db", 0.0, fade_duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_OUT)
