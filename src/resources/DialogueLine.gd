extends Resource

class_name DialogueLine

@export var character_name: String
@export_multiline var text: String
@export var next_dialogue: DialogueLine # Ссылка на следующую фразу (линейно
@export var choices: Array[DialogueLine]
@export var condition: Array[ConditionType]
@export var start_quest: QuestData
@export var end_quest: QuestData
enum Answer { positive, negative } 
@export var answer: Answer = Answer.positive
@export var command_type: DialogueCommandFactory.CommandType = DialogueCommandFactory.CommandType.NONE
