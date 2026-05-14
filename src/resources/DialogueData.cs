using Godot;
using Godot.Collections;

namespace SchoolGame.resources;


public enum AnswerType { Positive, Negative }


[GlobalClass] public partial class DialogueData : Resource
{
    [Export] public AnswerType AnswerType = AnswerType.Positive;
    [Export] public string Name { get; set; }
    [Export(PropertyHint.MultilineText)] public string Text { get; set; }
    [Export] public DialogueData NextDialogue { get; set; }
    [Export] public Array<DialogueData> Choices { get; set; } = new();
    [Export] public Array<ConditionData> Conditions { get; set; } = new();
    [Export] public Array<QuestData> Quests { get; set; } = new();
}