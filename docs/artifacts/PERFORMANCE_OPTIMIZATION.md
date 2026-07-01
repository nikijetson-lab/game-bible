# PERFORMANCE_OPTIMIZATION.md 
 
## Оптимізація продуктивності для Hazemoor 
 
> Гайд для підвищення FPS й зменшення lag'у 
 
--- 
 
## 1. LOD (Level of Detail) Strategy 
 
### Mesh LOD 
 
```gdscript 
# Кожен 3D mesh повинен мати кілька LOD версій 
# LOD0: High detail (для близьких дистанцій) 
# LOD1: Medium detail 
# LOD2: Low detail (для далеких дистанцій) 
 
# У Meshy AI експорт FBX з різними LOD'ами: 
player_character_LOD0.fbx  # 50,000 тріанглів 
player_character_LOD1.fbx  # 25,000 тріанглів 
player_character_LOD2.fbx  # 10,000 тріанглів 
``` 
 
### Culling Setup 
 

```gdscript 
# У Godot Editor для кожного MeshInstance3D: 
# Inspector → Visibility → Cull Mask 
# Налаштуй cullable об'єкти 
 
# Приклад: 
# - NPCs: cullable 
# - Props (deco): cullable 
# - Player: NEVER cull 
# - Level geometry: cullable але з більшими LOD'ами 
``` 
 
--- 
 
## 2. Batching & Draw Calls 
 
### MultiMeshInstance3D 
 
```gdscript 
# Для повторюваних об'єктів (torch'і, barrels, etc.): 
 
var multi_mesh = MultiMeshInstance3D.new() 
var mesh_data = preload("res://assets/models/torch.fbx") 
 
var multi_mesh_instance = MultiMesh.new() 
multi_mesh_instance.mesh = mesh_data 
multi_mesh_instance.instance_count = 50  # 50 torch'ей 
 
# Замість 50 draw calls, буде 1 draw call! 
``` 
 
### GroupManager для батчування 
 
```gdscript 
# Групуємо об'єкти по матеріалам: 
# - Всі об'єкти з деревом → один batch 
# - Всі об'єкти з камінням → один batch 
# - Все це значно зменшує draw calls 
``` 
 
--- 
 
## 3. Camera Culling & Frustum 
 
```gdscript 
# PlayerController вже має камеру 
# Налаштовуємо дальність видимості 
 
# У Inspector Player → Camera3D: 
# - Far: 100 (не більше!) 
# - FOV: 75 градусів 
# - Near: 0.1 
 
# Все за Far буде невидимо → не рендериться 
``` 
 
--- 
 
## 4. Physics Optimization 
 
### KinematicBody vs RigidBody 
 
```gdscript 

# Player: CharacterBody3D + KinematicShape ← ПРАВИЛЬНО 
# NPCs: CharacterBody3D ← ПРАВИЛЬНО 
# Static objects: StaticBody3D ← ПРАВИЛЬНО 
 
# НІ: не використовуй RigidBody для NPCs/Player 
# RigidBody дорогий по CPU! 
``` 
 
### Collision Layer/Mask 
 
```gdscript 
# Налаштуй Collision Layers щоб уникнути зайвих перевірок: 
# Layer 0: Player 
# Layer 1: NPCs 
# Layer 2: Interactive Objects 
# Layer 3: Terrain 
# Layer 4: Projectiles (Future) 
 
# Player mask: NPC, Objects, Terrain (не потрібно з Player'ом) 
# NPC mask: Player, Objects, Terrain (не потрібно з NPC'ом) 
``` 
 
--- 
 
## 5. Audio Optimization 
 
```gdscript 
# AudioManager вже оптимізований, але: 
 
# - Не крути больше за 10 SFX одночасно 
# - Уклінь music до 1-2 tracks 
# - Dialogue мають свій AudioBus 
# - Избегай streaming MP3, використовуй OGG 
``` 
 
--- 
 
## 6. Profiler Tips 
 
### Як запустити Profiler 
 
``` 
Godot Editor → Debug → Monitor 
(Праву верхню панель) 
``` 
 
### Що дивитись 
 
- **FPS:** Повинно бути 60+ 
- **Frame time:** Повинно бути < 16ms (для 60 FPS) 
- **Draw calls:** Спробуй тримати < 500 
- **Vertices:** Спробуй тримати < 5M на frame 
 
### Якщо FPS впадає 
 
1. Відкрий Monitor 
2. Подивись "Video" → "Draw calls" 
3. Якщо > 1000 → масштабуй LOD 
4. Якщо < 100 але FPS упадає → дивись CPU time 
5. Якщо CPU high → профіль скрипти (Debug → GDScript Profiler) 
 
--- 
 

## 7. Memory Management 
 
```gdscript 
# Уклінь memory leaks: 
 
# ПРАВИЛЬНО: 
func _ready() -> void: 
    if QuestManager: 
        QuestManager.quest_completed.connect(_on_quest_completed) 
 
func _exit_tree() -> void: 
    if QuestManager: 
        QuestManager.quest_completed.disconnect(_on_quest_completed) 
 
# НЕПРАВИЛЬНО (leak): 
func _ready() -> void: 
    QuestManager.quest_completed.connect(_on_quest_completed) 
    # Ніколи не disconnect → leak! 
``` 
 
--- 
 
## 8. Optimization Checklist 
 
- [ ] LOD setup для всіх mesh'ів 
- [ ] Camera Far = 100 
- [ ] Culling setup у Editor 
- [ ] Collision layers налаштовані 
- [ ] Max SFX одночасно = 10 
- [ ] No memory leaks (всі signals disconnect) 
- [ ] Профіль гра → FPS > 50 
- [ ] Draw calls < 500 
 
--- 
 
## 9. Примітки для майбутнього 
 
- **VR Optimization:** Якщо робимо VR, потрібна дополнительна оптимізація 
(2x FPS для кожного ока) 
- **Mobile Port:** Знизити LOD, скорочити Far до 50, вимкнути деякі 
шейдери 
- **Web Export:** Обмеження WASM → потрібна глибока оптимізація
