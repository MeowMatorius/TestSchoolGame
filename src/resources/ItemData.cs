using Godot;

public enum Type { Key, Collectable, Money, QuestItem }

[GlobalClass] public partial class ItemData : Resource
{
    [Export] public bool unique { get; set; } = false;
    [Export] public Type type { get; set; }
    [Export] public string name { get; set; } = "item";
    [Export] public int quantity { get; set; } = 1;
    [Export] public Texture2D icon { get; set; }
}
