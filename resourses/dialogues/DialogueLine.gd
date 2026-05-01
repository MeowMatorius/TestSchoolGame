extends Resource

class_name DialogueLine

@export var character_name: String
@export_multiline var text: String
@export var next_dialogue: DialogueLine # Ссылка на следующую фразу (линейно
@export var choices: Array[String]
@export var choices_branches: Array[DialogueLine] # Массив ссылок, соответствующих кнопкам
