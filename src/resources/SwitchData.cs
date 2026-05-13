using Godot;

public enum ObjectState { ON, OFF  }
public enum ActivatePromptMessage { Включить, Открыть, Вытащить }
public enum DeactivatePromptMessage { Выключить, Закрыть, Убрать }
public enum LockState { LOCKED, UNLOCKED, BROKEN }

[GlobalClass] public partial class SwitchData : Node
{
    [Export] public bool one_time_use { get; set; } = false;
    [Export] public ActivatePromptMessage activate_prompt_message { get; set; } = ActivatePromptMessage.Открыть;
    [Export] public DeactivatePromptMessage deactivate_prompt_message { get; set; } = DeactivatePromptMessage.Закрыть;
    
    [ExportCategory("Настройка замка")]
    [Export] public LockState lock_state { get; set; } = LockState.UNLOCKED;
    [Export] public ItemData item_needed_to_open { get; set; }
    [Export] public int quantity_needed_to_open { get; set; }
}