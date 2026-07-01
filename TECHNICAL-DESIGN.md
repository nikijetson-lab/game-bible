# Technical Design Document (TDD)
## Hazemoor — Dark Gothic Fantasy RPG

> **Версія:** 1.0  
> **Дата:** 26.06.2026  
> **Статус:** Pre-production  
> **Движок:** Unreal Engine 5.4+

---

## 🎯 Технічна філософія

**Core Pillars:**
1. **Атмосфера понад складністю** — пріоритет атмосферного освітлення, туману, звуку
2. **Narrative-driven systems** — всі системи підтримують storytelling
3. **Modular design** — можливість ітеративної розробки
4. **Performance as feature** — стабільні 60 FPS на mid-tier PC

---

## 🏗️ Технічний стек

### **Engine & Core**
- **Unreal Engine 5.4+** (Blueprints + C++)
- **Lumen** — динамічне глобальне освітлення (критично для атмосфери болота)
- **Nanite** — high-poly геометрія без performance penalty
- **World Partition** — streaming великих відкритих локацій
- **MetaSounds** — динамічна аудіосистема

### **Source Control**
- **Git** (GitHub) — основний репозиторій
- **Git LFS** — для великих бінарних файлів (.uasset, текстури, аудіо)
- Branch structure:
  - `main` — production-ready builds
  - `develop` — active development
  - `feature/*` — нові фічі
  - `prototype/*` — експерименти

### **Asset Pipeline**
- **3D Modeling:** Blender 4.0+
- **Texturing:** Substance Painter / Designer
- **Concept Art:** Photoshop / Krita
- **Audio:** FMOD / MetaSounds
- **Version Control:** Perforce (опціонально для великих team)

---

## 🎮 Core Systems Architecture

### **1. Character Controller**
```
├── Player Character (Third-Person)
│   ├── Movement System
│   │   ├── Walk / Run / Sprint
│   │   ├── Crouch / Dodge Roll
│   │   ├── Swim (болотна вода)
│   │   └── Climbing (обмежене)
│   ├── Camera System
│   │   ├── Over-shoulder cam (Witcher 3 style)
│   │   ├── Dynamic FOV на sprint
│   │   └── Collision avoidance
│   └── Animation State Machine
│       ├── Locomotion blend space
│       ├── Combat animations
│       └── Interaction poses
```

**Tech notes:**
- Enhanced Input System (UE5 native)
- IK для ніг на нерівному болотному терені
- Cloth simulation для плаща

---

### **2. Quest System**
```
├── Quest Manager (Singleton)
│   ├── Quest Database (DataTables)
│   ├── Quest State Machine
│   │   ├── Not Started
│   │   ├── Active
│   │   ├── Completed
│   │   └── Failed
│   ├── Objective Tracking
│   └── Branching Logic (Choices)
```

**Implementation:**
- Blueprint-based quest scripting
- JSON для quest data (легко editити письменникам)
- Event-driven architecture (QuestEvents)

**Example Quest Structure:**
```json
{
  "quest_id": "greyford_01_missing_recipient",
  "title": "Адресат відсутній",
  "objectives": [
    {
      "id": "talk_to_kelm",
      "type": "dialogue",
      "target": "npc_kelm"
    },
    {
      "id": "investigate_tavern",
      "type": "area_trigger",
      "location": "greyford_tavern"
    }
  ],
  "choices": [
    {
      "id": "choice_rufin_fate",
      "options": ["investigate", "report_order", "help_muri"],
      "consequences": {
        "investigate": {"reputation": {"greyford": +5}},
        "report_order": {"reputation": {"knives": +10}},
        "help_muri": {"reputation": {"muri": +15}}
      }
    }
  ]
}
```

---

### **3. Dialogue System**
```
├── Dialogue Manager
│   ├── Branching Dialogue Trees
│   ├── Speaker Camera Framing
│   ├── Subtitle System
│   └── Voice Acting Support (опціонально)
```

**Features:**
- **Dynamic dialogue** базується на reputation/choices
- **Timed responses** (деякі вибори під тайм-прес)
- **Память NPC** — вони пам'ятають твої вчинки

**Potential Plugins:**
- Dialogue Plugin (Community)
- Yarn Spinner (якщо потрібна гнучкість)

---

### **4. Reputation System**
```
├── Reputation Manager
│   ├── Faction Data
│   │   ├── Greyford Administration (-40 to +40)
│   │   ├── Order of Seven Daggers (-40 to +40)
│   │   ├── Keepers (-40 to +40)
│   │   ├── Muri (-40 to +40)
│   │   └── Lightbearers (-40 to +40)
│   └── Dynamic World Reactions
│       ├── NPC attitudes
│       ├── Quest availability
│       └── Prices / Services
```

**Implementation:**
- Blueprint function library для модифікації reputation
- Event dispatcher для world reactions
- Save/Load integration

---

### **5. Combat System**
```
├── Combat Manager
│   ├── Melee Combat
│   │   ├── Light / Heavy Attacks
│   │   ├── Parry / Block
│   │   └── Dodge Roll
│   ├── Magic System (Doctrine-based)
│   │   ├── Lantern Doctrine (Light magic)
│   │   ├── Judge Doctrine (Fear/Intimidate)
│   │   ├── Mediator Doctrine (Charm/Pacify)
│   │   └── Tracker Doctrine (Detection/Traps)
│   └── Enemy AI
│       ├── Behavior Trees
│       ├── Perception System
│       └── Dynamic difficulty scaling
```

**Tech approach:**
- UE5 Gameplay Ability System (GAS) для abilities
- Target Lock System
- Hit reactions та stagger system

---

### **6. Inventory & Crafting**
```
├── Inventory System
│   ├── Item Database (DataAssets)
│   ├── Equipment Slots
│   │   ├── Weapon (Main)
│   │   ├── Off-hand (Shield/Lantern)
│   │   ├── Armor pieces
│   │   └── Trinkets
│   └── Consumables
├── Crafting System
│   ├── Resources (Lead, Copper, Silver)
│   ├── Recipes (unlock через quests)
│   └── Crafting Stations (world-based)
```

---

### **7. Save/Load System**
```
├── Save Game Object
│   ├── Player State
│   │   ├── Position / Rotation
│   │   ├── Stats / HP / Stamina
│   │   └── Inventory
│   ├── World State
│   │   ├── Quest Progress
│   │   ├── NPC States
│   │   ├── Reputation Values
│   │   └── World Changes
│   └── Meta Data
│       ├── Playtime
│       ├── Timestamp
│       └── Version
```

**Features:**
- Auto-save на major quest points
- Manual save в Safe Zones
- Multiple save slots (3-5)

---

## 🌍 World Architecture

### **Level Structure**
```
Hazemoor_World (Persistent Level)
├── Greyford_Hub (Level Instance)
│   ├── Tavern_Interior
│   ├── Administration_Building
│   └── Market_District
├── Hazemoor_Swamp (Open World)
│   ├── Tykhy_Shelest
│   ├── Sunken_Abbey
│   └── Moura_Clearing
├── Valkorn_City (Level Instance)
│   ├── Palace_District
│   ├── Archive_Dungeon
│   └── New_Ghetto
└── Travel_Routes (Connecting paths)
```

**World Partition Settings:**
- Grid size: 512m x 512m
- Loading radius: 2 cells
- Streaming: Distance-based + Priority system

---

### **Lighting & Atmosphere**

**Core Tech:**
- **Lumen** для global illumination
- **Volumetric Fog** — товстий болотний туман
- **Post-Process Stack:**
  - Color grading (desaturated, cold tones)
  - Bloom (м'який glow на lanterns)
  - Vignette (легке затемнення країв)
  - Film grain (subtle cinematic feel)

**Time of Day:**
- Static overcast (не динамічний день/ніч спочатку)
- Scripted lighting transitions в key moments

**Weather System:**
- Rain (Niagara particles)
- Fog density zones
- Dynamic wind (foliage)

---

## 📊 Performance Targets

### **Minimum Specs**
- **CPU:** Intel i5-8400 / AMD Ryzen 5 2600
- **GPU:** NVIDIA GTX 1060 6GB / AMD RX 580
- **RAM:** 16 GB
- **Storage:** 50 GB SSD
- **Target:** 1080p @ 30 FPS (Low settings)

### **Recommended Specs**
- **CPU:** Intel i7-10700K / AMD Ryzen 7 3700X
- **GPU:** NVIDIA RTX 3060 Ti / AMD RX 6700 XT
- **RAM:** 32 GB
- **Storage:** 50 GB NVMe SSD
- **Target:** 1440p @ 60 FPS (High settings)

### **Optimization Strategy**
1. **LOD System** — aggressive LODs (5 levels)
2. **Occlusion Culling** — heavy fog helps з culling
3. **Texture Streaming** — virtual textures
4. **Nanite для static meshes** — дерева, будівлі
5. **Profiling** — регулярні profiling sessions

---

## 🧪 Prototype Milestones

### **Phase 0: Setup (Week 1-2)**
- ✅ Створити UE5 project
- ✅ Налаштувати Git LFS
- ✅ Import базових assets (starter content)
- ✅ Створити folder structure

### **Phase 1: Core Mechanics (Week 3-6)**
- ⬜ Third-person character controller
- ⬜ Basic combat (attack, dodge, block)
- ⬜ Camera system
- ⬜ Movement animations

### **Phase 2: First Location (Week 7-10)**
- ⬜ Greyford Tavern (interior whitebox)
- ⬜ Basic lighting setup
- ⬜ 2-3 interactable NPCs
- ⬜ Simple dialogue system test

### **Phase 3: Quest Prototype (Week 11-14)**
- ⬜ Implement "Адресат відсутній" (first quest)
- ⬜ Quest UI
- ⬜ Objectives tracking
- ⬜ Choice system prototype

### **Phase 4: Polish & Vertical Slice (Week 15-20)**
- ⬜ Full Greyford hub (greybox)
- ⬜ One combat encounter
- ⬜ Reputation system integration
- ⬜ Save/Load system
- ⬜ Audio pass (music + SFX)

---

## 📁 Project Structure

```
HazemoorGame/
├── Content/
│   ├── Core/
│   │   ├── Characters/
│   │   │   ├── Player/
│   │   │   └── NPCs/
│   │   ├── Gameplay/
│   │   │   ├── Quests/
│   │   │   ├── Dialogue/
│   │   │   ├── Combat/
│   │   │   └── Reputation/
│   │   └── UI/
│   ├── Levels/
│   │   ├── Greyford/
│   │   ├── Hazemoor/
│   │   ├── Valkorn/
│   │   └── TestMaps/
│   ├── Art/
│   │   ├── Materials/
│   │   ├── Textures/
│   │   ├── StaticMeshes/
│   │   └── VFX/
│   ├── Audio/
│   │   ├── Music/
│   │   ├── SFX/
│   │   └── Dialogue/
│   └── Data/
│       ├── Quests/
│       ├── Dialogues/
│       ├── Items/
│       └── Characters/
├── Source/ (C++ code)
│   ├── HazemoorGame/
│   │   ├── Core/
│   │   ├── Combat/
│   │   ├── Quest/
│   │   └── Save/
└── Config/
```

---

## 🔧 Development Tools

### **Required**
- Unreal Engine 5.4+
- Visual Studio 2022 (C++ workload)
- Git + Git LFS
- Blender 4.0+

### **Recommended**
- Rider (alternative IDE)
- RenderDoc (graphics debugging)
- Plastic SCM / Perforce (якщо team >3)
- Trello / Jira (task tracking)

### **Documentation**
- Confluence / Notion — живий GDD/TDD
- Miro — flowcharts для quest logic
- Google Sheets — балансування (damage, costs)

---

## 🚨 Technical Risks

| Ризик | Імовірність | Вплив | Mitigation |
|-------|-------------|-------|------------|
| Performance на болотних сценах | Висока | Високий | Aggressive LODs, fog culling |
| Складність branching narratives | Середня | Високий | Tools для quest visualization |
| Save system corruption | Низька | Критичний | Backup saves, versioning |
| Scope creep | Висока | Високий | Strict vertical slice focus |

---

## 📚 Reference Games

**Для вивчення систем:**
- **The Witcher 3** — quest design, dialogue, world structure
- **Disco Elysium** — narrative systems, choice consequences
- **Darkest Dungeon** — atmosphere, gothic tone
- **Bloodborne** — gothic world, environmental storytelling
- **Hellblade: Senua's Sacrifice** — voice mechanic inspiration (Ільї уст)

---

## ✅ Next Actions

1. **Створити UE5 project** (Hazemoor_Game)
2. **Setup Git LFS** для Content/
3. **Import starter content** (Medieval Dungeon, Stylized Forest)
4. **Greybox Tavern Interior** (1 тиждень)
5. **Prototype character controller** (1 тиждень)

---

**Документ підтримує:** nikijetson-lab  
**Останнє оновлення:** 26.06.2026
