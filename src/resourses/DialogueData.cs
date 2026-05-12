using Godot;
using Godot.Collections;

[GlobalClass]
public partial class DialogueData : Resource
{
    public enum AnswerType
    {
        Positive,
        Negative
    }

    [Export] 
    public string CharacterName { get; set; }

    [Export(PropertyHint.MultilineText)] 
    public string Text { get; set; }

    [Export] 
    public DialogueData NextDialogue { get; set; }

    [Export] 
    public Array<DialogueData> Choices { get; set; } = new();

    [Export] 
    public Array<ConditionData> Condition { get; set; } = new();

    [Export] 
    public Array<QuestData> Quest { get; set; } = new();

    [Export] 
    public AnswerType Answer { get; set; } = AnswerType.Positive;