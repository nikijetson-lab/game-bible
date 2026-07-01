# Tree of Thoughts для NPC Реакцій 
 
## Що таке Tree of Thoughts? 
 
**Tree of Thoughts** — AI метод, коли агент розглядає кілька варіантів 
рішень одночасно й вибирає найкращий. 
 
Замість того, щоб NPC мати одну задану реакцію, він: 
1. **Генерує** 3+ варіанти реакцій 
2. **Оцінює** кожний варіант 
3. **Вибирає** найкращий на основі контексту 
 
--- 
 
## Як це працює у Hazemoor 
 
### Сценарій 
 
``` 
Гравець говорить Ервану:  
"Ви трактирник? Можна зі мною поговорити?" 
 
Ерван генерує Tree of Thoughts: 
 
                    [Analyze choice] 
                          | 
                ____________________ 
               |         |         | 
          [Positive]  [Neutral]  [Negative] 
             (0.75)    (0.60)      (0.3) 
               |         |         | 
            ___|___   ____|____  __|__ 
           |   |   | |    |    ||    | 
         [A1][A2][A3][B1][B2][C1][C2] 
        0.85 0.80 0.75 0.65 0.60 0.35 0.30 
 
Reputation modifier: friendly (+15% bonus) 
Final scores: 
  A1 (Smile): 0.85 * 1.15 = 0.98 ← BEST! 
  A2 (Compliment): 0.80 * 1.15 = 0.92 
  ... 
  C2 (Scold): 0.30 * 1.15 = 0.35 
 
Result: Ерван посміхається теплотою ✓ 
``` 
 
--- 
 
## Структура Кода 
 
### 1. NPCThoughts.gd (279 рядків) 
 
```gdscript 
class Thought: 
    text: String               # "Smile warmly at player" 
    score: float              # 0.98 (0-1 шкала) 
    children: Array[Thought]  # Дочірні варіанти 
    is_leaf: bool             # Це фінальна реакція? 
    action_type: String       # "gesture", "dialogue", "animation" 
``` 
 
### 2. Процес генерування 
 

```gdscript 
generate_reaction_tree(choice: String, quest_id: String) → Thought 
 
Кроки: 
1. Аналізуємо sentiment (positive/neutral/negative) 
2. Генеруємо 3 основні thought'и 
3. Розширюємо дерево (додаємо дітей) 
4. Оцінюємо все дерево (з modifiers) 
5. Вибираємо найкращий листовий вузол 
``` 
 
### 3. Модифікатори Оцінки 
 
```gdscript 
reputation_modifier = { 
    "trusted": 1.3        # +30% бонус для позитивних реакцій 
    "friendly": 1.15      # +15% 
    "neutral": 1.0        # Без змін 
    "unfriendly": 0.85    # -15% 
    "hostile": 0.5        # -50% 
} 
 
sentiment_bonus = { 
    "Smile": +0.1         # Додаємо до score 
    "Compliment": +0.1 
    "Scold": -0.1 
} 
``` 
 
--- 
 
## Приклади використання 
 
### Приклад 1: Позитивний вибір гравця + high reputation 
 
``` 
Гравець: "Ви трактирник? Можна зі мною поговорити?" 
Reputation: friendly (15) 
 
Tree: 
  Positive (0.75) × 1.15 modifier = 0.86 
    ├─ Smile (0.85) × 1.15 = 0.98 ✓ BEST 
    ├─ Compliment (0.80) × 1.15 = 0.92 
    └─ Nod (0.75) × 1.15 = 0.86 
 
Result: Ерван посміхається теплотою 
Dialogue: "Звичайно, друже! Що тебе цікавить?" 
``` 
 
### Приклад 2: Грубий вибір гравця + low reputation 
 
``` 
Гравець: "Слухай, живе сюди всякі рідкісні типи. Виганяй їх!" 
Reputation: hostile (-35) 
 
Tree: 
  Negative (0.3) × 0.5 modifier = 0.15 
    ├─ Frown (0.35) × 0.5 = 0.18 ✓ BEST 
    └─ Scold (0.30) × 0.5 = 0.15 
 
Result: Ерван сердито нахмурюється 
Dialogue: "Уважай язик, невіжа!" 
``` 

 
### Приклад 3: Нейтральний вибір 
 
``` 
Гравець: "Твій пивовар робить вдумку. Де ти його нанять?" 
Reputation: neutral (0) 
 
Tree: 
  Neutral (0.6) × 1.0 = 0.6 
    ├─ Respond (0.65) × 1.0 = 0.65 ✓ BEST 
    └─ Listen (0.60) × 1.0 = 0.60 
 
Result: Ерван спокійно відповідає 
Dialogue: "Це мій брат. Робить добре пиво, так?" 
``` 
 
--- 
 
## Інтеграція з NPC.gd 
 
```gdscript 
# У NPC.gd додали: 
 
func generate_reaction_to_choice(choice: String, quest_id: String) → 
NPCThoughts.Thought: 
    var reaction = _thoughts_engine.generate_reaction_tree(choice, 
quest_id) 
    return reaction 
 
func _execute_reaction(reaction: NPCThoughts.Thought) → void: 
    match reaction.action_type: 
        "gesture": 
            _play_gesture_animation(reaction.text) 
        "dialogue": 
            _play_dialogue_reaction(reaction.text) 
        "animation": 
            _play_animation(reaction.text) 
``` 
 
--- 
 
## Як розширити для своїх NPC 
 
### 1. Додати нові типи thought'ів 
 
```gdscript 
func _expand_thought_tree(thought: Thought) → void: 
    match thought.text: 
        "Custom thought": 
            var custom_reaction = Thought.new("Do custom action") 
            custom_reaction.score = 0.7 
            custom_reaction.is_leaf = true 
            custom_reaction.action_type = "custom" 
            thought.children.append(custom_reaction) 
``` 
 
### 2. Додати нові модифікатори 
 
```gdscript 
func _get_custom_modifier(factor: String) → float: 
    # Наприклад, залежно від часу доби 
    match factor: 
        "morning": 

            return 1.2  # NPC більш веселий з ранку 
        "night": 
            return 0.8  # Втомлений вночі 
``` 
 
### 3. Тестувати 
 
```gdscript 
# Запустити TestTreeOfThoughts.tscn 
# Натисни: 
#  - 1 для позитивного вибору 
#  - 2 для нейтрального 
#  - 3 для негативного 
 
# Дивись LogPanel для вивода Tree of Thoughts 
``` 
 
--- 
 
## Переваги цього підходу 
 
  **Реалізм** — NPC реагує динамічно, не задані вперед реакції   
  **Контекст** — Репутація гравця впливає на реакцію   
  **Розширюваність** — Легко додати нові варіанти реакцій   
  **Дебагованність** — Можна бачити всі варіанти в логу   
 
--- 
 
## Наступні кроки 
 
- [7] Backtracking система (повернення на попередню сцену) 
- [Advanced] AI Planning для NPC поведінки
