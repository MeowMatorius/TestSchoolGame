class_name ArrayUtilities
extends RefCounted


static func find_in_group(array: Array, target_name: String) -> Node:
	for n in array:
		if n.name == target_name:
			return n
	return null