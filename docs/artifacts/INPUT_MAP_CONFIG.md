# Input Map Configuration для Hazemoor 
 
## Як налаштувати Input Actions у project.godot 
 
### Спосіб 1: Через Godot Editor (GUI) 
 
1. Відкрий Godot Editor 
2. Project → Project Settings → вкладка **Input Map** 
3. У полі "Action" введи назву action та натисни "Add" 
4. Для кожної action додай Device (клавіша) 
 
### Спосіб 2: Редагування project.godot напряму (рекомендовано) 
 
Відкрий **res://project.godot** у текстовому редакторі та знайди секцію 
`[input]` або додай нову в кінець файлу. 
 
--- 
 
## Список всіх Input Actions 
 
Додай ці рядки до `[input]` секції в project.godot: 
 
```ini 
[input] 
 
# 
=========================================================================
=== 
# MOVEMENT 
# 
=========================================================================
=== 
 
move_forward={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":87,"physical_keycode
":0,"key_label":0,"unicode":119,"echo":false,"script":null) 
] 
} 
 
move_backward={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":83,"physical_keycode
":0,"key_label":0,"unicode":115,"echo":false,"script":null) 
] 

} 
 
move_left={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode
":0,"key_label":0,"unicode":97,"echo":false,"script":null) 
] 
} 
 
move_right={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":68,"physical_keycode
":0,"key_label":0,"unicode":100,"echo":false,"script":null) 
] 
} 
 
# 
=========================================================================
=== 
# COMBAT & ACTIONS 
# 
=========================================================================
=== 
 
sprint={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":true,"ctrl_pressed":f
alse,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode"
:0,"key_label":0,"unicode":0,"echo":false,"script":null) 
] 
} 
 
dodge={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":32,"physical_keycode
":0,"key_label":0,"unicode":32,"echo":false,"script":null) 
] 
} 
 
interact={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":69,"physical_keycode
":0,"key_label":0,"unicode":101,"echo":false,"script":null) 
] 

} 
 
attack_light={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_n
ame":"","device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"button_mask":1,"position":Vector2(0, 
0),"global_position":Vector2(0, 
0),"factor":1.0,"clicks":1,"pressure":0.0,"script":null) 
] 
} 
 
attack_heavy={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_n
ame":"","device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"button_mask":2,"position":Vector2(0, 
0),"global_position":Vector2(0, 
0),"factor":1.0,"clicks":1,"pressure":0.0,"script":null) 
] 
} 
 
# 
=========================================================================
=== 
# UI / MENU 
# 
=========================================================================
=== 
 
pause={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":4194305,"physical_ke
ycode":0,"key_label":0,"unicode":0,"echo":false,"script":null) 
] 
} 
 
quest_log={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":
false,"meta_pressed":false,"pressed":false,"keycode":74,"physical_keycode
":0,"key_label":0,"unicode":106,"echo":false,"script":null) 
] 
} 
 
inventory={ 
"deadzone": 0.5, 
"events": 
[Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"",
"device":-
1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":

false,"meta_pressed":false,"pressed":false,"keycode":73,"physical_keycode
":0,"key_label":0,"unicode":105,"echo":false,"script":null) 
] 
} 
``` 
 
--- 
 
## Клавіатурна розкладка 
 
| Дія | Клавіша | Нотатки | 
|-----|---------|--------| 
| **Рух вперед** | W | move_forward | 
| **Рух назад** | S | move_backward | 
| **Рух вліво** | A | move_left | 
| **Рух вправо** | D | move_right | 
| **Спринт** | Shift (утримувати) | sprint — витрачає витримку | 
| **Додьджинг (roll)** | Spacebar | dodge — коротка анімація, витрачає 
витримку | 
| **Взаємодія** | E | interact — для діалогів, дверей, предметів | 
| **Легкий удар** | ЛКМ (ліва кнопка миші) | attack_light | 
| **Важкий удар** | ПКМ (права кнопка миші) | attack_heavy | 
| **Пауза** | Esc | pause — відкрити меню паузи | 
| **Журнал квестів** | J | quest_log — показати активні квести | 
| **Інвентар** | I | inventory — показати сумку предметів | 
| **Закрити діалог** | Esc | ui_cancel — для закриття UI панелей | 
 
--- 
 
## Godot Keycodes (для ручного редагування) 
 
Якщо редагуєш project.godot вручну, використовуй ці коди: 
 
| Клавіша | Keycode | Hex | 
|---------|---------|-----| 
| A | 65 | 0x41 | 
| D | 68 | 0x44 | 
| E | 69 | 0x45 | 
| I | 73 | 0x49 | 
| J | 74 | 0x4A | 
| S | 83 | 0x53 | 
| W | 87 | 0x57 | 
| Space | 32 | 0x20 | 
| Shift (ліва) | 16777248 | 0x1000010 | 
| Escape | 4194305 | 0x1000001 | 
 
--- 
 
## Спосіб додання Input Actions через GDScript (для автоматизації) 
 
Якщо потрібно додати actions програмно: 
 
```gdscript 
# res://scripts/setup/InputMapSetup.gd 
extends Node 
 
func setup_input_map() -> void: 
 
"""Автоматично налаштувати Input Map на старті""" 
 
 
 
# move_forward (W) 
 
if not InputMap.has_action("move_forward"): 
 
 
InputMap.add_action("move_forward") 
 
 
var event = InputEventKey.new() 

 
 
event.keycode = KEY_W 
 
 
InputMap.action_add_event("move_forward", event) 
 
 
 
# move_backward (S) 
 
if not InputMap.has_action("move_backward"): 
 
 
InputMap.add_action("move_backward") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_S 
 
 
InputMap.action_add_event("move_backward", event) 
 
 
 
# move_left (A) 
 
if not InputMap.has_action("move_left"): 
 
 
InputMap.add_action("move_left") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_A 
 
 
InputMap.action_add_event("move_left", event) 
 
 
 
# move_right (D) 
 
if not InputMap.has_action("move_right"): 
 
 
InputMap.add_action("move_right") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_D 
 
 
InputMap.action_add_event("move_right", event) 
 
 
 
# sprint (Shift) 
 
if not InputMap.has_action("sprint"): 
 
 
InputMap.add_action("sprint") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_SHIFT 
 
 
InputMap.action_add_event("sprint", event) 
 
 
 
# dodge (Space) 
 
if not InputMap.has_action("dodge"): 
 
 
InputMap.add_action("dodge") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_SPACE 
 
 
InputMap.action_add_event("dodge", event) 
 
 
 
# interact (E) 
 
if not InputMap.has_action("interact"): 
 
 
InputMap.add_action("interact") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_E 
 
 
InputMap.action_add_event("interact", event) 
 
 
 
# pause (Esc) 
 
if not InputMap.has_action("pause"): 
 
 
InputMap.add_action("pause") 
 
 
var event = InputEventKey.new() 
 
 
event.keycode = KEY_ESCAPE 
 
 
InputMap.action_add_event("pause", event) 
 
 
 
# attack_light (LMB) 
 
if not InputMap.has_action("attack_light"): 
 
 
InputMap.add_action("attack_light") 
 
 
var event = InputEventMouseButton.new() 
 
 
event.button_index = MOUSE_BUTTON_LEFT 
 
 
InputMap.action_add_event("attack_light", event) 
 
 
 
# attack_heavy (RMB) 
 
if not InputMap.has_action("attack_heavy"): 
 
 
InputMap.add_action("attack_heavy") 
 
 
var event = InputEventMouseButton.new() 

 
 
event.button_index = MOUSE_BUTTON_RIGHT 
 
 
InputMap.action_add_event("attack_heavy", event) 
 
 
 
print("[InputMapSetup] All input actions configured") 
 
# Викликати у _ready(): 
# InputMapSetup.setup_input_map() 
``` 
 
--- 
 
## Тестування Input Map 
 
У будь-якому скрипті можеш перевірити: 
 
```gdscript 
func _input(event: InputEvent) -> void: 
 
if event.is_action_pressed("move_forward"): 
 
 
print("W pressed!") 
 
 
 
if event.is_action_pressed("sprint"): 
 
 
print("Shift pressed!") 
 
 
 
if event.is_action_pressed("interact"): 
 
 
print("E pressed!") 
``` 
 
--- 
 
## Примітки 
 
1. **Keycode vs Physical Keycode:** 
   - `keycode` — логічна клавіша (залежить від мови введення) 
   - `physical_keycode` — фізична позиція (рекомендовано для ігор) 
   - Для ігор краще використовувати `keycode` або `physical_keycode` 
 
2. **Джойстик:** 
   - Можна додавати `InputEventJoypadButton` для контролерів 
   - Поки не робимо, але API готова 
 
3. **Конфлікти:** 
   - W + Shift = move_forward + sprint (обидві дії одночасно) 
   - Це нормально для ігор
