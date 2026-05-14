using Godot;

namespace SchoolGame.resources;


public enum Type { Key, Collectable, Money, QuestItem }


[GlobalClass] public partial class ItemData : Resource
{
    [Export] public bool Unique { get; set; }
    [Export] public Type Type { get; set; }
    [Export] public string Name { get; set; } = "item";
    [Export] public int Quantity { get; set; } = 1;
    [Export] public Texture2D Icon { get; set; }
}