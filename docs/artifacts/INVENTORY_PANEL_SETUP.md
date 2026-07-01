# InventoryPanel.tscn Setup Guide 
 
## Панель інвентаря й обладнання 
 
### Структура вузлів 
 
``` 
InventoryPanel (CanvasLayer) ← ROOT, скрипт: InventoryPanel.gd 
├─ MainContainer (PanelContainer) 
│  └─ MarginContainer 
│     └─ HBoxContainer 
│        ├─ LeftPanel (VBoxContainer) — Equipment 
│        │  ├─ TitleLabel ("Обладнання") 
│        │  ├─ HSeparator 

│        │  ├─ EquipmentSlots (VBoxContainer) 
│        │  │  ├─ WeaponSlot (HBoxContainer) 
│        │  │  │  ├─ Label ("Зброя:") 
│        │  │  │  └─ ItemDisplay (VBoxContainer) 
│        │  │  ├─ ArmorHeadSlot 
│        │  │  ├─ ArmorChestSlot 
│        │  │  └─ ArmorLegsSlot 
│        │  └─ CharacterPreview (TextureRect) — 3D превью персонажа 
│        │ 
│        └─ RightPanel (VBoxContainer) — Inventory 
│           ├─ HeaderContainer (HBoxContainer) 
│           │  ├─ TitleLabel ("Інвентар") 
│           │  └─ WeightLabel ("45 / 50 kg") 
│           ├─ HSeparator 
│           ├─ ScrollContainer 
│           │  └─ GridContainer (InventoryGrid) 
│           │     └─ [InventorySlot.tscn × 30] 
│           └─ SelectedItemInfo (VBoxContainer) 
│              ├─ ItemNameLabel 
│              ├─ ItemDescriptionLabel 
│              └─ UseButton / EquipButton 
``` 
 
### Розміри й позиція 
 
- **MainContainer:** anchors (0, 0, 1, 1), full screen with margin 
- **LeftPanel width:** 30% (equipment) 
- **RightPanel width:** 70% (inventory grid 5x6) 
- **Equipment slot:** 100x100 px 
- **Inventory slot:** 50x50 px 
 
### Функціонал 
 
- Перетягування предметів між слотами (Drag & Drop) 
- Double-click для використання/одягання 
- Right-click для контекстного меню 
- Weight tracking внизу 
- Item preview на праву сторону
