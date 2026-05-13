using Godot;
using Godot.Collections;
using System.Linq;

[GlobalClass]
public partial class QuestData : Resource
{
    private string _id;
    private bool _completed;
    private bool _failed;

    [Export]
    public string Id
    {
        get => string.IsNullOrEmpty(_id) ? GetId() : _id;
        set => _id = value;
    }

    [Export] 
    public string Name { get; set; } = "Квест 1";

    [Export(PropertyHint.MultilineText)] 
    public string Description { get; set; } = "Описание";

    [Export] 
    public Array<ConditionData> Condition { get; set; } = new();

    [Export]
    public bool Completed
    {
        get => _completed;
        set
        {
            _completed = value;
            GD.Print($"completed изменено на: {_completed}");
            EmitChanged();
            
            // Предполагается, что SignalBus — это глобальный синглтон (Autoload)
            SignalBus.Instance.EmitSignal(SignalBus.SignalName.QuestCompleted, this);
        }
    }

    [Export]
    public bool Failed
    {
        get => _failed;
        set
        {
            _failed = value;
            GD.Print($"failed изменено на: {_failed}");
            EmitChanged();
            
            // В Godot 4 C# сигналы обычно отправляются через глобальную шину
            SignalBus.Instance.EmitSignal(SignalBus.SignalName.QuestCompleted, this);
        }
    }

    public string GetId()
    {
        return ResourcePath.GetFile().GetBaseName();
    }

    public bool IsComplete()
    {
        // Используем LINQ All для проверки всех условий
        return Condition.All(cond => cond != null && cond.Completed);
    }
}