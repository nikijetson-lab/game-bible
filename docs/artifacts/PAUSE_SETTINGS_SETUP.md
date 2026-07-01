# PauseMenu.tscn & SettingsPanel.tscn Setup 
 
## 1. PauseMenu.tscn — Меню паузи 
 
### Структура 
 
``` 
PauseMenu (CanvasLayer) ← ROOT, скрипт: PauseMenu.gd 
├─ ColorRect (заповнення фону 50% прозоре) 
└─ PanelContainer (центрований, 400x300) 
   └─ MarginContainer 
      └─ VBoxContainer 
         ├─ TitleLabel ("ПАУЗА") 
         ├─ HSeparator 
         ├─ ResumeButton ("Продовжити") 
         ├─ QuestLogButton ("Журнал квестів") 
         ├─ InventoryButton ("Інвентар") 
         ├─ SettingsButton ("Налаштування") 
         ├─ SaveButton ("Зберегти гру") 
         └─ QuitToMenuButton ("Вихід у меню") 
``` 
 
### Функціонал 
 
- Escape key для паузи/відновлення 
- get_tree().paused = true при паузі 
- Кнопки для відкриття інших панелей 
- Save на будь-якому момента 
 
## 2. SettingsPanel.tscn — Налаштування 
 
### Структура 
 
``` 
SettingsPanel (CanvasLayer) ← ROOT, скрипт: SettingsPanel.gd 
├─ PanelContainer 
│  └─ MarginContainer 

│     └─ VBoxContainer 
│        ├─ TitleLabel ("Налаштування") 
│        ├─ HSeparator 
│        ├─ ScrollContainer 
│        │  └─ VBoxContainer 
│        │     ├─ MasterVolumeSection 
│        │     │  ├─ Label ("Гучність:") 
│        │     │  └─ HSlider (0-100) 
│        │     ├─ MusicVolumeSection 
│        │     │  ├─ Label ("Музика:") 
│        │     │  └─ HSlider (0-100) 
│        │     ├─ SFXVolumeSection 
│        │     │  ├─ Label ("Звукові ефекти:") 
│        │     │  └─ HSlider (0-100) 
│        │     ├─ DialogueVolumeSection 
│        │     │  ├─ Label ("Діалоги:") 
│        │     │  └─ HSlider (0-100) 
│        │     └─ GraphicsQualitySection 
│        │        ├─ Label ("Якість графіки:") 
│        │        └─ OptionButton (Low, Medium, High) 
│        └─ CloseButton ("Закрити") 
``` 
 
### Налаштування 
 
- Master volume: 0-100 
- Music volume: 0-100 
- SFX volume: 0-100 
- Dialogue volume: 0-100 
- Graphics quality: Low/Medium/High 
- Save settings to user:// JSON
