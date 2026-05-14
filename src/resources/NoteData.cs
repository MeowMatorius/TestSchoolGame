using Godot;

namespace SchoolGame.resources;


[GlobalClass] public partial class NoteData : Resource
{
    [Export] public string Name { get; set; } = "Note";
}