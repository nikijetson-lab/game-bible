# Backtracking System Guide 
 
## Що таке Backtracking? 
 
**Backtracking** — це можливість гравця повернутися на крок назад й 
вибрати іншу дорогу. 
 
Замість що гра будує на одному шляху, гравець може: 
1. **Переглянути** всю історію сцен 
2. **Повернутися** на N кроків назад 
3. **Вибрати** альтернативний вибір 
4. **Продовжити** з новим шляхом 
 
--- 
 
## Як це працює у Hazemoor 
 
### Сценарій 
 
``` 
Гравець грає квест: 
[Arriving] → [Ervan Greeting] → [Ervan Reaction] 
 
Потім говорить: "Чекай, я хочу іншу дорогу!" 
 
Натискає: 
  Pause Menu → Backtrack 
 
BacktrackingPanel показує: 
  [0] Arriving ← SELECT 
  [1] Ervan Greeting 
  [2] Ervan Reaction ← CURRENT 
 
Гравець вибирає [1] (Ervan Greeting) 
Натискає "Backtrack" 
 
Гра повертається на сцену [1] 
Гравець робить новий вибір 
Історія оновлюється з новим шляхом 
``` 
 
--- 
 
## Структура Код 
 
### 1. BacktrackingManager.gd (280 рядків) 
 
```gdscript 
class SceneSnapshot: 
    scene_id: String         # "arriving" 
    scene_title: String      # "Постоялий двір Грейфорда" 
    scene_text: String       # Перші 100 символів 
    available_choices: Array # ["Вибір 1", "Вибір 2", ...] 
    selected_choice: int     # Який вибір було зроблено 
    timestamp: int           # Коли це сталося 
``` 
 
### 2. Основні методи 

 
```gdscript 
record_scene(scene_id, scene_data) 
    └─ Додати нову сцену в історію 
 
record_choice(choice_index) 
    └─ Записати вибір гравця 
 
get_backtrack_steps_available() → int 
    └─ Скільки кроків назад можна повернутися? 
    └─ Max 10 кроків 
 
backtrack(steps) → bool 
    └─ Повернутися на N кроків назад 
    └─ Повертає користувача на цю сцену 
 
get_history() → Array[SceneSnapshot] 
    └─ Отримати всю історію 
 
get_current_path() → Array 
    └─ Отримати шлях що пройшов гравець 
``` 
 
--- 
 
## Приклад 1: Простий Backtrack 
 
``` 
Гравець: 
  [Scene 0] Arriving 
    └─ Вибір: "Talk to Ervan" ✓ 
  [Scene 1] Ervan Greeting 
    └─ Вибір: "You're the bartender?" ✓ 
  [Scene 2] Ervan Reaction 
    └─ Думка: "Ой, цей вибір зробив Ервана сердитим!" 
 
Гравець натискає Backtrack: 
  BacktrackingPanel: 
    [0] Arriving 
    [1] Ervan Greeting ← SELECT 
    [2] Ervan Reaction ← CURRENT 
   
  Гравець вибирає [1] 
  Натискає "Backtrack" (1 крок назад) 
 
Результат: 
  Гра повертається на Scene 1 
  Гравець може вибрати новий вибір 
  (наприклад, "I have questions...") 
``` 
 
--- 
 
## Приклад 2: Глибокий Backtrack 
 
``` 
Гравець пройшов 8 сцен і зрозумів, що зробив помилку 3 сцени тому: 
 
[Scene 0] Arriving 
[Scene 1] Ervan Greeting 
[Scene 2] Guard Confrontation ← ПОМИЛКА БУЛА ТУТТ! 
[Scene 3] Guard Angry 
[Scene 4] Reputation Damage 

[Scene 5] Cannot Enter City 
[Scene 6] Forest Detour 
[Scene 7] Lost in Swamp ← CURRENT (тупик!) 
 
Гравець натискає Backtrack: 
  get_backtrack_steps_available() → 7 кроків (max 10) 
   
  BacktrackingPanel: 
    [0] Arriving 
    [1] Ervan Greeting 
    [2] Guard Confrontation ← SELECT 
    [3] Guard Angry 
    [4] Reputation Damage 
    [5] Cannot Enter City 
    [6] Forest Detour 
    [7] Lost in Swamp ← CURRENT 
 
  Гравець вибирає [2] 
  Натискає "Backtrack" (5 кроків назад) 
 
Результат: 
  Гра повертається на сцену [2] Guard Confrontation 
  Гравець робить новий вибір (бути ввічливим) 
  Дерево гри перебудовується від цієї точки 
``` 
 
--- 
 
## Обмеження 
 
### 1. Max 10 кроків назад 
 
```gdscript 
const MAX_BACKTRACK_STEPS: int = 10 
 
// Гравець не може повернутися далі ніж 10 сцен 
// Це робить гру реалістичною й запобігає "trial-and-error" 
``` 
 
### 2. Max 50 сцен в історії 
 
```gdscript 
const MAX_HISTORY_SIZE: int = 50 
 
// Якщо гравець пройшов 50+ сцен, найстарші видаляються 
// Запобігає memory leak 
``` 
 
### 3. Один раз за сцену 
 
``` 
// Гравець не може робити backtrack посередині сцени 
// Тільки коли сцена завершена й показані choices 
``` 
 
--- 
 
## Інтеграція з іншими системами 
 
### SaveManager 
 
```gdscript 
// Коли гравець робить backtrack: 

// 1. BacktrackingManager.backtrack() 
// 2. QuestManager.display_scene() (показує нову сцену) 
// 3. SaveManager.auto_save() (зберігає новий стан) 
 
// Старий збережений файл не видаляється, 
// але новий стан записується поверх 
``` 
 
### ReputationManager 
 
```gdscript 
// Якщо гравець зробив backtrack: 
// 1. Повідомляємо ReputationManager про "undo" 
// 2. Репутація повертається до стану сцени що backtrack'ли 
// 3. Перелічуємо бонуси/штрафи для нового шляху 
``` 
 
### DialogueManager 
 
```gdscript 
// Mініділоги не повторюються автоматично 
// Гравець переглядає сцену по-новому (без voice) 
// Але може натиснути "Repeat" для voice acting 
``` 
 
--- 
 
## UI Flow 
 
### PauseMenu Button 
 
``` 
PauseMenu 
  ├─ Resume 
  ├─ Backtrack ← NEW! 
  ├─ Inventory 
  ├─ Quest Log 
  ├─ Settings 
  └─ Quit 
``` 
 
### BacktrackingPanel 
 
``` 
BacktrackingPanel 
  ├─ HistoryList (ItemList) 
  │  ├─ [0] Arriving 
  │  ├─ [1] Ervan Greeting 
  │  └─ [2] Ervan Reaction ← CURRENT (yellow) 
  ├─ InfoLabel ("Available: 7 steps") 
  ├─ BacktrackButton ("Backtrack to selected scene") 
  └─ CloseButton (X) 
 
Гравець: 
  1. Вибирає сцену з HistoryList 
  2. Натискає BacktrackButton 
  3. Гра повертається на цю сцену 
``` 
 
--- 
 
## Debug Info 
 

```gdscript 
BacktrackingManager.print_history_info() 
 
Output: 
═══════════════════════════════ 
BACKTRACKING HISTORY 
═══════════════════════════════ 
Total scenes: 8 / 50 
Current step: 7 
Backtrack available: 7 steps 
 
Path taken: 
→ [0] arriving [choice: 0] 
  [1] ervan_greeting [choice: 1] 
  [2] ervan_reaction [choice: -1]  // choice not made yet 
  [3] guard_confrontation [choice: 0] 
  [4] guard_angry [choice: 1] 
  ... 
  [7] lost_in_swamp ← CURRENT 
 
═══════════════════════════════ 
``` 
 
--- 
 
## Розширення для своїх квестів 
 
### 1. Додати custom state при backtrack 
 
```gdscript 
# У BacktrackingManager 
func backtrack(steps: int) -> bool: 
    # ... backtrack код ... 
     
    # Гаджик: очистити custom state 
    if CustomSystem: 
        CustomSystem.reset_to_step(_current_step) 
     
    return true 
``` 
 
### 2. Запретити backtrack у критичних моментах 
 
```gdscript 
# У BacktrackingManager 
var _backtrack_enabled: bool = true 
 
func set_backtrack_enabled(enabled: bool) -> void: 
    _backtrack_enabled = enabled 
     
# У критичній сцені: 
BacktrackingManager.set_backtrack_enabled(false) 
``` 
 
### 3. Логування для аналітики 
 
```gdscript 
# Записати в лог коли гравець робить backtrack 
func backtrack(steps: int) -> bool: 
    # ... код ... 
     
    # Аналітика 
    var current_time = Time.get_ticks_msec() 

    var time_in_branch = current_time - _history[_current_step].timestamp 
     
    _log_analytics({ 
        "event": "backtrack", 
        "steps": steps, 
        "time_in_branch_ms": time_in_branch 
    }) 
``` 
 
--- 
 
## Переваги Backtracking 
 
  **Свобода** — Гравець не "впійдений" в один шлях   
  **Реальність** — Можна переосмислити вибір   
  **Без Save/Load** — Швидко й просто   
  **Аналітика** — Можна дивитися які сцени найбільш "розгалужені"   
  **Розширюваність** — Легко додати custom logic   
 
--- 
 
## Наступні кроки 
 
- [Advanced] AI Planning для NPC поведінки 
- Інтеграція обох систем разом
