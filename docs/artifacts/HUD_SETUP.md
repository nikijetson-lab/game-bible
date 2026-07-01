# HUD.tscn Setup Guide 
 
## Головний інтерфейс (Health, Stamina, Minimap) 
 
### Структура вузлів 
 
``` 
HUD (CanvasLayer) ← ROOT, скрипт: HUD.gd 
├─ HealthContainer (MarginContainer) 
│  └─ VBoxContainer 
│     ├─ HealthLabel ("100 / 100 HP") 
│     └─ ProgressBar (HealthBar) 
│ 
├─ StaminaContainer (MarginContainer) 
│  └─ VBoxContainer 
│     ├─ StaminaLabel ("50 / 50") 
│     └─ ProgressBar (StaminaBar) 
│ 
├─ LevelXPContainer (MarginContainer) 
│  └─ VBoxContainer 
│     ├─ LevelLabel ("Level: 1") 
│     └─ ProgressBar (XPBar) 
│ 
├─ EquipmentContainer (MarginContainer) 
│  ├─ WeaponSlotLabel + TextureRect (equipped weapon icon) 
│  └─ ArmorSlotLabel + TextureRect (equipped armor icon) 
│ 
├─ MinimapContainer (MarginContainer) 
│  └─ TextureRect (Minimap) або SubViewport 
│ 
└─ InteractionHintLabel ("Press E to...") 
``` 
 
### Розміщення 
 
- **Health:** top-left, anchors (0, 0, 0.15, 0.15) 
- **Stamina:** top-left below health 
- **Level/XP:** top-left below stamina 
- **Equipment:** top-right, anchors (0.85, 0, 1, 0.2) 
- **Minimap:** bottom-right, 150x150, anchors (0.85, 0.85, 1, 1) 
- **Interaction hint:** bottom-center, anchors (0.35, 0.95, 0.65, 1) 
 
### Цвета 
 
- **Health bar:** #FF6B6B (红色) 
- **Stamina bar:** #4ECDC4 (бирюзовое) 
- **XP bar:** #FFD700 (золоте) 
- **Text:** #FFFFFF 
 
### Динаміка 
 

- Health bar: обновляется кожен кадр з PlayerState.hp 
- Stamina bar: обновляется з PlayerState.stamina 
- XP bar: обновляется з PlayerState.experience 
- Interaction hint: показується коли гравець біля NPC або об'єкту
