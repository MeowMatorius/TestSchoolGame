using System.Collections.Generic;
using Godot;

namespace SchoolGame.resources;


[GlobalClass] public partial class ConditionData : Resource
{
    [Signal] public delegate void ChangedStatusEventHandler(ConditionData condition);
    
    private bool _completed;
    [Export] public bool Completed
    {
        get => _completed;
        set
        {
            _completed = value;
            GD.Print($"completed изменено на: {_completed}");
            EmitChanged();
            EmitSignal(global::ConditionData.SignalName.ChangedStatusEventHandler, this);
        }
    }
    
    [Export] public Resource ItemData { get; set; }
    [Export] public int ItemQuantity { get; set; }
    [Export] public Resource ItemDataGiven { get; set; }
    [Export] public Resource DialogueLine { get; set; }  // вместо DialogueLine
    
    
    public bool IsMet()
    {
        var itemCondition = new List<bool>();
        GD.Print(InventoryManager.InventoryItems);

        // Приводим к ItemData при использовании (GDScript-класс доступен как GodotObject)
        var itemData = ItemData as GodotObject;
        var itemName = itemData?.Get("name").AsString();  // получаем свойство через Get()

        if (InventoryManager.InventoryItems.ContainsKey(itemName))
        {
            if (InventoryManager.InventoryItems[itemName].Quantity < ItemQuantity)
            {
                GD.Print($"{InventoryManager.InventoryItems[itemName].Quantity} < {ItemQuantity}");
                itemCondition.Add(false);
            }
            else
            {
                itemCondition.Add(true);
            }
        }
        else
        {
            itemCondition.Add(false);
        }

        if (itemCondition.Contains(false))
            return false;
        
        Completed = true;
        return true;
    }
}