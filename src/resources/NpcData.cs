using Godot;
using Godot.Collections;

namespace SchoolGame.resources;


[GlobalClass] public partial class NpcData : Resource
{
    [Export] public string Id { get; set; } = "0001";

    [Export] public string Name { get; set; } = "NPC";

    // Указываем базовый тип Resource, но через Hint задаем путь к вашему скрипту DialogueLine.gd
    [Export(PropertyHint.ResourceType, "DialogueLine")] 
    public Resource DialogueLine { get; set; }

    // Для массива делаем аналогично: базовый тип Resource + ограничение по типу в Hint
    [Export(PropertyHint.ResourceType, "DialogueLine")] 
    public Array<Resource> EventDialogues { get; set; } = new();
}