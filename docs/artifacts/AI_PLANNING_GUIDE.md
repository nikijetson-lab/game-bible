# AI Planning Guide для NPC 
 
## Що таке AI Planning? 
 
**AI Planning** — це коли NPC має **власне мислення** й **планує дії** як 
справжній AI агент. 
 
Замість простої послідовності команд, NPC: 
1. **Формулює мету** ("Привітати гравця") 
2. **Аналізує контекст** ("Гравець дружелюбний, я в таверні") 
3. **Планує дії** ("Посміхнутися → Привітати → Запропонувати пиво") 
4. **Виконує план** (крок за кроком) 
5. **Спостерігає результат** ("Гравець посміхнувся") 
6. **Рефлексує** ("Мета досягнута? Так!") 
 
--- 
 
## ReAct Loop (Reasoning + Acting) 
 
**ReAct** — це цикл: 
 

``` 
     ┌─────────────────┐ 
     │   REASONING     │ (Що мені робити?) 
     └────────┬────────┘ 
              │ 
     ┌────────▼────────┐ 
     │    PLANNING     │ (Як я це зроблю?) 
     └────────┬────────┘ 
              │ 
     ┌────────▼────────┐ 
     │     ACTION      │ (Виконаю!) 
     └────────┬────────┘ 
              │ 
     ┌────────▼────────────┐ 
     │   OBSERVATION       │ (Що сталося?) 
     └────────┬────────────┘ 
              │ 
     ┌────────▼──────────┐ 
     │   REFLECTION      │ (Мета досягнута?) 
     └────────┬──────────┘ 
              │ 
         Чи успіх? 
         /        \ 
       ТАК        НІ 
        │          │ 
    Завершимо   Повтор 
``` 
 
--- 
 
## Приклад: Ervan Greets Player 
 
### Сценарій 
 
Гравець входить у таверну. Ervan помічає гравця й хоче його привітати. 
 
### ReAct Loop у дії 
 
``` 
[STEP 0] 
 
[REASONING] Analyzing context... 
  Goal: "greet_player" 
  Reputation: friendly (15) 
  Location: tavern_interior 
  Mood: positive 
  Energy: 1.0 
  → "Гравець дружелюбний, я можу привітати його теплотою" 
 
[PLANNING] Creating plan... 
  Plan A: smile → greet → offer_beer (success: 0.85) 
  Plan B: nod → greet (success: 0.65) 
  Plan C: continue_work (success: 0.3) 
   
  Selected: Plan A (highest score: 0.85) 
  → "Посміхнусь, привітаю, запропоную пиво" 
 
[ACTION] Executing: smile 
  Ervan plays animation "positive_reaction" 
   
[OBSERVATION] Observing result... 
  Player returned the smile 
  Player is receptive 

  → "Гравець відповів позитивно" 
 
[REFLECTION] Checking goal... 
  Goal "greet_player" is approaching completion 
  Player is engaged in conversation 
  → "Мета практично досягнута!" 
 
[STEP 1] 
 
[ACTION] Executing: greet 
  Ervan plays minidialogue "ervan_greeting" 
  Voice: "Добро пожалувати у мою таверню, друже!" 
 
[OBSERVATION] 
  Player nodded 
  Player approached the bar 
  → "Гравець зацікавлений!" 
 
[REFLECTION] 
  ✓ Goal achieved! 
  Success rate: 0.95 
``` 
 
### Результат 
 
Ervan успішно привітав гравця. NPC виглядає розумним, а не просто 
автоматом! 
 
--- 
 
## Архітектура 
 
### 1. AIPlanner.gd (180 рядків) 
 
```gdscript 
class Goal: 
    name: String            # "greet_player" 
    priority: float         # 0.8 (0-1 шкала) 
    description: String     # "Привітати гравця дружелюбно" 
    target_entity: String   # "player" 
 
class Plan: 
    name: String            # "friendly_greeting" 
    steps: Array[String]    # ["smile", "greet", "offer_beer"] 
    estimated_success: float # 0.85 (0-1) 
 
func run_react_loop(goal: Goal) → bool: 
    # Запустити повний цикл ReAct 
    # Повернути true якщо мета досягнута 
``` 
 
### 2. NPCBehavior.gd (192 рядків) 
 
```gdscript 
func execute_behavior(context: String): 
    # greeting: привітання гравця 
    # reaction: реакція на вибір гравця 
    # casual: звичайна діяльність 
 
func analyze_scene_context(scene_id: String) → String: 
    # На основі ID сцени обрати поведінку 
 
func get_highest_priority_goal() → Goal: 

    # Отримати найважливішу мету NPC 
``` 
 
### 3. NPCThoughts.gd (279 рядків) 
 
```gdscript 
# Вже реалізовано раніше! 
# Генерує Tree of Thoughts для реакцій 
``` 
 
--- 
 
## Інтеграція в NPC.gd 
 
```gdscript 
# У NPC.gd додаємо: 
 
var _behavior: NPCBehavior = null 
 
func _init_ai_system() -> void: 
    _behavior = NPCBehavior.new(self) 
 
func start_dialogue(quest_id: String) -> void: 
    # Запустити AI поведінку 
    var context = _behavior.analyze_scene_context(quest_id) 
    _behavior.execute_behavior(context) 
``` 
 
--- 
 
## Приклади Целей (Goals) 
 
### Goal 1: Greet Player 
 
```gdscript 
var goal = AIPlanner.Goal.new("greet_player", 0.9) 
 
Plans: 
  A) smile → greet → offer_beer (0.85) 
  B) nod → greet (0.65) 
  C) continue_work (0.3) 
 
Selected: A (warmest greeting) 
``` 
 
### Goal 2: Respond to Insult 
 
```gdscript 
var goal = AIPlanner.Goal.new("respond_to_insult", 0.8) 
 
Plans: 
  A) defend_honor (0.7) — фронт, сердитий 
  B) ignore_insult (0.4) — спокійно, цивилизовано 
  C) complain_to_admin (0.6) — звернутися до влади 
 
Selected: A (если reputation < friendly) 
         B (если reputation ≥ friendly) 
``` 
 
### Goal 3: Continue Work 
 
```gdscript 
var goal = AIPlanner.Goal.new("continue_work", 0.5) 

 
Plans: 
  A) serve_other_customers (0.7) 
  B) clean_tables (0.6) 
  C) rest_behind_bar (0.4) 
 
Selected: A або B (залежно від контексту) 
``` 
 
--- 
 
## Модифікатори й Контекст 
 
### Context Factors 
 
```gdscript 
_analyze_context() returns: 
  - location: "tavern_interior" 
  - npcs_present: ["player", "other_customers"] 
  - time_of_day: "evening" 
  - current_activity: "working" 
``` 
 
### Goal Priority Modifiers 
 
```gdscript 
Base priority = 0.5 
 
Modifiers: 
  + reputation boost: +0.3 (якщо friendly) 
  + energy level: -0.2 (якщо втомлений) 
  + mood: +0.2 (якщо positive) 
   
Final priority = 0.5 + 0.3 - 0.2 + 0.2 = 0.8 
``` 
 
### Plan Success Evaluation 
 
```gdscript 
Base score = 0.85 
 
Modifiers: 
  × reputation: 1.15 (friendly) 
  × energy: 0.9 (slightly tired) 
  × mood: 1.1 (positive) 
   
Final score = 0.85 × 1.15 × 0.9 × 1.1 = 0.95 
``` 
 
--- 
 
## Flow: От Scene до NPC Action 
 
``` 
QuestManager.display_scene("ervan_greeting") 
    ↓ 
NPC.start_dialogue("arrival_quest") 
    ↓ 
NPCBehavior.execute_behavior("greeting") 
    ↓ 
AIPlanner.run_react_loop(Goal) 
    ├─ _reasoning_phase() 
    ├─ _planning_phase() → generate_plans() → evaluate_plan() 

    ├─ _action_phase() → NPC.play_animation("positive_reaction") 
    ├─ _observation_phase() 
    └─ _reflection_phase() → return true (success!) 
    ↓ 
NPCBehavior._execute_dialogue() 
    ↓ 
DialogueManager.play_minidialogue("ervan_greeting") 
    ↓ 
Користувач бачить діалог + слухає voice acting 
``` 
 
--- 
 
## Преваги Цього Підходу 
 
  **Реалізм** — NPC виглядає розумним, а не робот   
  **Адаптивність** — Поведінка залежить від контексту   
  **Розширюваність** — Легко додати нові goals/plans   
  **Дебагованість** — Можна бачити весь процес мислення   
  **Комбінує все** — Tree of Thoughts + ReAct Loop + Backtracking   
 
--- 
 
## Debug Output Приклад 
 
``` 
[AIPlanner Ervan]  
 
============================================================ 
REACT LOOP: greet_player 
============================================================ 
 
[STEP 0] 
 
[REASONING] Analyzing context... 
  Context: tavern_interior | Mood: positive 
 
[PLANNING] Creating plan... 
  Selected plan: friendly_greeting (success rate: 0.85) 
 
[ACTION] Executing: smile 
 
[OBSERVATION] Observing result... 
  Observation: Action completed successfully 
 
[REFLECTION] Checking goal... 
 
[STEP 1] 
 
[ACTION] Executing: greet 
 
[OBSERVATION] Observing result... 
  Observation: Action completed successfully 
 
[REFLECTION] Checking goal... 
✓ Goal achieved! 
 
============================================================ 
``` 
 
--- 
 

## Наступні кроки 
 
- **Інтеграція всіх систем разом** 
- **Комбо: Tree of Thoughts + ReAct Loop + Backtracking** 
- **Тестування в реальній грі**
