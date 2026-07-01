# MainMenu.tscn Setup Guide 
 
## Стартовий екран 
 
### Структура вузлів 
 
``` 
MainMenu (Node) ← ROOT, скрипт: MainMenu.gd 
├─ CanvasLayer 
│  └─ BackgroundPanel (PanelContainer) 
│     └─ BackgroundTextureRect (texture: dark fantasy art) 
│ 
├─ CanvasLayer 
│  └─ VBoxContainer (ContentContainer) 
│     ├─ TitleLabel ("HAZEMOOR") 
│     ├─ SubtitleLabel ("Dark Fantasy RPG") 
│     ├─ VSpacer 
│     ├─ ButtonsContainer (VBoxContainer, centered) 
│     │  ├─ NewGameButton ("Нова гра") 

│     │  ├─ LoadGameButton ("Завантажити") 
│     │  ├─ SettingsButton ("Налаштування") 
│     │  └─ QuitButton ("Вихід") 
│     ├─ VSpacer 
│     └─ VersionLabel ("v1.0") 
``` 
 
### Розміри й позиція 
 
- **Title:** font_size=72, color=#FFD700 (золоте) 
- **Subtitle:** font_size=24, color=#AAAAAA 
- **Buttons:** width=200, height=50, font_size=24 
- **Button spacing:** 20 px 
 
### Функціонал 
 
- **New Game:** Запустити TavernInterior.tscn 
- **Load Game:** Показати SaveSlots панель 
- **Settings:** Показати SettingsPanel 
- **Quit:** Вихід з гри
