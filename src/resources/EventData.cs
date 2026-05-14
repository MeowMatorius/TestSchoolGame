using Godot;
using Godot.Collections;

namespace SchoolGame.resources;


[GlobalClass] public partial class EventData : Resource
{
    [Export] public string Id { get; set; } = "0001";
    [Export] public string Name { get; set; } = "EventName";
    [Export] public bool Triggered { get; set; }
    [Export] public bool Status { get; set; }
    [Export] public QuestData Quest { get; set; }
    [Export] public EventData NextEvent { get; set; }
    [Export] public Array<NpcData> Npc { get; set; } = new();
}