# TEST_SCENES Guide 
 
## Тестові сцени для дебагування 
 
### Призначення 
 
Кожна тестова сцена дозволяє окремо тестувати один компонент без 
завантаження всієї гри. 
 
--- 
 
## 1. TestQuestManager.tscn 
 
**Призначення:** Тест системи квестів і JSON loading 
 
**Структура:** 
``` 
TestQuestManager (Node) 

├─ QuestDisplayPanel (CanvasLayer) 
│  └─ Label (показує поточну сцену) 
├─ InputHandler (Node) 
└─ LogPanel (TextEdit для логу) 
``` 
 
**Функціонал:** 
- Кнопка "Load Episode" → завантажити квест з JSON 
- Кнопка "Next Scene" → перейти на наступну сцену 
- Кнопка "Choice 0/1/2/3" → вибрати варіант 
- Log панель показує що сталося 
 
**Як запустити:** 
1. Відкрий TestQuestManager.tscn 
2. Натисни F5 
3. Натисни "Load Episode" → вибери "грейфорд_та" 
4. Натисни Choice кнопки, спостерігай лог 
 
--- 
 
## 2. TestDialogue.tscn 
 
**Призначення:** Тест UI діалогів і DialogueManager 
 
**Структура:** 
``` 
TestDialogue (Node) 
├─ DialoguePanel.tscn (інстанс) 
├─ NPCSimulator (Node, виконує як NPC) 
└─ AudioTestPlayer 
``` 
 
**Функціонал:** 
- Симуляція NPC діалогу 
- Тест voice acting (MP3 файли) 
- Тест анімацій choices 
- Display різних сцен 
 
**Як запустити:** 
1. Відкрий TestDialogue.tscn 
2. Натисни F5 
3. Побачиш DialoguePanel з текстом 
4. Натисни на choice кнопку 
 
--- 
 
## 3. TestPlayerController.tscn 
 
**Призначення:** Тест руху, камери, введення 
 
**Структура:** 
``` 
TestPlayerController (Node3D) 
├─ Player (CharacterBody3D, скрипт: PlayerController.gd) 
├─ SimpleLevel (Node3D, проста геометрія) 
│  ├─ Plane (підлога) 
│  ├─ Cube (перешкода) 
│  └─ Cube (вибір висоти) 
└─ DebugPanel (Label, показує speed, position) 
``` 
 
**Функціонал:** 
- WASD для руху 

- Mouse для камери 
- Shift для спринту 
- Space для dodge roll 
- Debug панель показує FPS, position, velocity 
 
**Як запустити:** 
1. Відкрий TestPlayerController.tscn 
2. Натисни F5 
3. Грай з рухом, камерою, додж rolle 
4. Спостерігай Debug панель 
 
--- 
 
## 4. TestInventory.tscn 
 
**Призначення:** Тест інвентаря й обладнання 
 
**Структура:** 
``` 
TestInventory (Node) 
├─ InventoryPanel.tscn (інстанс) 
├─ ItemSpawner (Node, генерує предмети) 
├─ ConsolePanel (TextEdit для команд) 
└─ DebugInfo (Label, показує inventory state) 
``` 
 
**Функціонал:** 
- Показує інвентар з усіма предметами 
- Можна додавати/видаляти предмети через консоль 
- Тест перетягування (drag & drop) 
- Тест одягання обладнання 
- Debug інформація про вагу 
 
**Як запустити:** 
1. Відкрий TestInventory.tscn 
2. Натисни F5 
3. Відкрий Inventory (I key) 
4. Використовуй консоль для додавання предметів 
 
**Консольні команди:** 
``` 
/add health_potion 5 
/add sword_01 1 
/equip sword_01 weapon 
/remove health_potion 2 
/list 
/weight 
``` 
 
--- 
 
## Загальні поради для тестування 
 
1. **Console Output:** Все логується в Output terminal 
2. **PlayerState:** Поточний стан можна перевірити через Debug panels 
3. **Performance:** Спостерігай FPS у corner 
4. **Errors:** Дивись Console для помилок
