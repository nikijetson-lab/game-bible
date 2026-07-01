# QuestLog.tscn Setup Guide 
 
## Журнал активних квестів 
 
> Показує список усіх активних квестів з прогресом і нагородами 
 
### Структура вузлів 
 
``` 
QuestLog (CanvasLayer) ← ROOT, скрипт: QuestLogUI.gd 
├─ PanelContainer 
│  ├─ StyleBox (背景색) 
│  └─ MarginContainer 
│     └─ VBoxContainer 
│        ├─ TitleLabel ("Журнал квестів") 

│        ├─ HSeparator 
│        ├─ ScrollContainer 
│        │  └─ VBoxContainer (QuestListContainer) 
│        │     └─ [QuestItem.tscn × N] (динамічно) 
│        └─ CloseButton (X) 
 
QuestItem.tscn (instanciable scene) 
├─ PanelContainer 
│  └─ MarginContainer 
│     └─ VBoxContainer 
│        ├─ QuestTitleLabel 
│        ├─ ProgressBar 
│        ├─ QuestDescriptionLabel 
│        └─ RewardLabel 
``` 
 
### Розміри й позиція 
 
- **Anchor:** left=0.7, top=0.1, right=0.98, bottom=0.6 
- **PanelContainer size:** 400x600 
- **Font size:** Title 24, Description 16 
 
### Цвета 
 
- **Background:** #1a1a1a (темне сіро) 
- **Text:** #e0e0e0 (світле сіро) 
- **Progress bar:** #4CAF50 (зелене) 
- **Reward text:** #FFD700 (золоте) 
 
### Функціонал 
 
- Список активних квестів з QuestManager 
- ProgressBar для кожного квесту 
- Нагорода за квест 
- Scroll якщо багато квестів 
- Close button (X) для закриття панелі
