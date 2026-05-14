using Godot;

namespace SchoolGame.resources;


public enum ObjectState { On, Off  }
public enum ActivatePromptMessage { Включить, Открыть, Вытащить }
public enum DeactivatePromptMessage { Выключить, Закрыть, Убрать }
public enum LockState { Locked, Unlocked, Broken }


[GlobalClass] public partial class SwitchData : Node
{
    [Export] public ObjectState ObjectState { get; set; } = ObjectState.On;
    [Export] public bool OneTimeUse { get; set; }
    [Export] public ActivatePromptMessage ActivatePromptMessage { get; set; } = ActivatePromptMessage.Открыть;
    [Export] public DeactivatePromptMessage DeactivatePromptMessage { get; set; } = DeactivatePromptMessage.Закрыть;
    
    [ExportCategory("Настройка замка")]
    [Export] public LockState LockState { get; set; } = LockState.Unlocked;
    [Export] public ItemData ItemNeededToOpen { get; set; }
    [Export] public int QuantityNeededToOpen { get; set; }
}