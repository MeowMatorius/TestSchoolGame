extends Label


func _process(_delta):
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var process = Performance.get_monitor(Performance.TIME_PROCESS)
	var memory = Performance.get_monitor(Performance.MEMORY_STATIC)
	var vmemory = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)
	text = "FPS: " + str(fps) + ", Process: " + str(process) + " \n RAM: " + str(memory) + ", VMEM: " + str(vmemory)
