using Godot;
using Godot.Collections;

[GlobalClass]
public partial class EventData : Resource
{
    [Export] 
    public string EventId { get; set; } = "0001";

    [Export] 
    public string EventName { get; set; } = "EventName";

    [Export] 
    public bool Triggered { get; set; } = false;

    [Export] 
    public bool EventStart { get; set; } = false;

    [Export] 
    public bool EventOver { get; set; } = false;

    [Export] 
    public QuestData QuestData { get; set; }

    [Export] 
    public EventData NextEventData { get; set; }

    [Export] 
    public Array<NpcData> Npc { get; set; } = new();
}