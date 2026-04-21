extends Node


@export var items = {
	"keys": []
}


func _ready():
	signal_bus.is_picking.connect(add_item) 


func add_item(object_name):
	items["keys"].append(object_name)
	print(items)
