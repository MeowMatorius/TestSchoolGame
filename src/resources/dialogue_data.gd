extends Resource
class_name DialogueData

#enum Answer { positive, negative } 
#@export var answer: Answer = Answer.positive

@export var character_name: String
@export_multiline var text: String

@export var next_dialogue: DialogueData # Ссылка на следующую фразу (линейный диалог)
@export var choices: Array[DialogueData]
@export var condition: Array[ConditionData]

@export var commands: Array[CommandData]
