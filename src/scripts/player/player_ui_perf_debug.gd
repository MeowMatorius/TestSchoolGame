extends Label


func _process(_delta):
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var process = Performance.get_monitor(Performance.TIME_PROCESS)
	var physics = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)
	var memory = Performance.get_monitor(Performance.MEMORY_STATIC)
	var vmemory = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	text = "Кадры: " + str(fps) + " | Время Кадра: %.2f ms "  % process + " | Физика: %.2f ms" % physics + " | О.Память (MB): " + str(snapped(memory / (1024.0 * 1024.0), 0)) + " | В.Память (MB): " + str(snapped(vmemory / (1024.0 * 1024.0), 0))
