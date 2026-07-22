# Production Roadmap
## Hazemoor — From Pre-production to Vertical Slice

> **Версія:** 1.1 (термінологію узгоджено з фактичним рушієм — Godot)
> **Дата:** 26.06.2026  
> **Horizon:** 6 місяців до Vertical Slice
> **Рушій:** Godot 4.7, рендерер Mobile (не Forward+/Compatibility — Forward+ занадто важкий для інтегрованих GPU, Compatibility не підтримує FogVolume)

---

## 🎯 Стратегічні цілі

### **Vertical Slice Definition**
Граємий прототип, що доводить:
- ✅ Відчуття руху та камери
- ✅ Одна повна локація (Грейфорд)
- ✅ Один великий квест з виборами ("Адресат відсутній")
- ✅ Працююча репутаційна система
- ✅ Один бойовий енкаунтер
- ✅ Атмосферне освітлення та звук
- ✅ **Playable time: 20-30 хвилин**

### **Success Metrics**
- Playtester каже: "Я відчуваю атмосферу!"
- Quest choices відчуваються важливими
- Combat відчувається responsive
- Performance: stable 60 FPS на target hardware

---

## 📅 Timeline Overview

| Фаза | Тривалість | Мета | Status |
|------|-----------|------|--------|
| **Phase 0: Foundation** | Weeks 1-2 | Setup project, tools, pipeline | 🟡 In Progress |
| **Phase 1: Core Mechanics** | Weeks 3-6 | Player controller, combat basics | ⬜ Not Started |
| **Phase 2: First Location** | Weeks 7-10 | Greyford tavern + hub | ⬜ Not Started |
| **Phase 3: Quest System** | Weeks 11-14 | First quest playable | ⬜ Not Started |
| **Phase 4: Polish** | Weeks 15-20 | Audio, VFX, bug fixing | ⬜ Not Started |
| **Phase 5: Vertical Slice** | Week 21 | Final build + presentation | ⬜ Not Started |

**Total:** ~5 місяців (21 тижнів)

---

## 🛠️ Phase 0: Foundation (Weeks 1-2)

### **Week 1: Project Setup**

**Tech Setup:**
- [x] Створити проєкт Godot 4.7 ("Hazemoor")
  - Рендерер: Mobile (не Forward+ — цільове залізо без дискретної GPU)
- [ ] Налаштувати Git + Git LFS
  - Git LFS для великих бінарних асетів (`.glb`, `.png`, `.wav`)
  - `.gitignore` для `.godot/`, `.import/`, тимчасових export/build/log/cache папок
- [ ] Створити folder structure (див. TDD)
- [ ] Перший commit і push на GitHub

**Documentation:**
- [ ] Review існуючого game-bible
- [ ] Створити Trello/Notion board для task tracking
- [ ] Зібрати reference images (Pinterest board для атмосфери)

**Asset Acquisition:**
- [ ] Download free marketplace assets:
  - Medieval Environment Pack
  - Dynamic Fire System
  - Volumetric Fog Pack
  - Basic NPC models (placeholder)

**Deliverable:** Working Godot project під version control

---

### **Week 2: Foundation Systems**

**Character Setup:**
- [ ] Import/create basic player character model (placeholder)
- [ ] CharacterBody3D player scene
- [ ] Налаштувати Input Map (project.godot)
  - WASD movement
  - Mouse look
  - Sprint (Shift)
  - Interact (E)

**Basic World:**
- [ ] Create TestMap (whitebox arena)
- [ ] Setup basic lighting (directional light + sky sphere)
- [ ] Place простий terrain (flat plane спочатку)

**Core Systems (autoload singletons):**
- [ ] GameManager autoload (для persistent data)
- [ ] Player controller script (CharacterBody3D)
- [ ] Create basic HUD (crosshair/reticle)

**Deliverable:** Player can walk around in test level

---

## ⚙️ Phase 1: Core Mechanics (Weeks 3-6)

### **Week 3: Movement Foundation**

**Movement System:**
- [ ] Implement walk/run/sprint states
- [ ] Add stamina system (simple float)
- [ ] Crouch functionality
- [ ] Jump (if needed for level design)

**Camera System:**
- [ ] Over-shoulder camera offset
- [ ] Camera collision avoidance
- [ ] Smooth camera transitions
- [ ] FOV adjustment on sprint

**Testing:**
- [ ] Movement feels responsive
- [ ] No camera clipping issues

---

### **Week 4: Combat Basics**

**Melee Combat:**
- [ ] Light attack (left mouse)
- [ ] Heavy attack (hold left mouse)
- [ ] Block (right mouse hold)
- [ ] Dodge roll (Space)

**Animation:**
- [ ] Import basic combat anim set (безкоштовні: Mixamo → Godot-сумісний формат)
- [ ] Setup AnimationTree
- [ ] BlendSpace2D для locomotion
- [ ] Combat state machine (AnimationTree StateMachine або власний FSM)

**Hitbox System:**
- [ ] Weapon collision detection
- [ ] Damage dealing
- [ ] Hit reactions

---

### **Week 5: Enemy AI Prototype**

**Basic Enemy:**
- [ ] Create простий AI enemy (placeholder mesh)
- [ ] FSM (власний GDScript, або аддон LimboAI):
  - Patrol idle
  - Chase player (sight trigger)
  - Attack (melee range)
  - Death

**AI Perception:**
- [ ] Sight sense
- [ ] Hearing sense (for stealth later)

**Combat Testing:**
- [ ] Place enemy in TestMap
- [ ] Fight feels fair and responsive
- [ ] Hit feedback clear (sound + VFX)

---

### **Week 6: UI Foundation**

**Core UI Elements:**
- [ ] Health bar
- [ ] Stamina bar  
- [ ] Quick item slots (1-4 keys)
- [ ] Interaction prompt ("Press E to talk")

**Pause Menu:**
- [ ] Resume
- [ ] Settings
- [ ] Quit

**Style:**
- [ ] Dark gothic theme
- [ ] Minimalist (не загромаджений екран)

---

## 🏘️ Phase 2: First Location (Weeks 7-10)

### **Week 7: Greyford Tavern — Greybox**

**Level Design:**
- [ ] Whitebox tavern interior layout:
  - Bar area
  - Fireplace + seating
  - 2-3 tables
  - Stairs to rooms upstairs
  - Back door to street

**Blockout:**
- [ ] CSG-ноди (CSGBox3D тощо) OR basic cube meshes
- [ ] Proper scale (test with player character)
- [ ] Basic lighting placement

**Reference:**
- Use Witcher 3 taverns as inspiration
- Cozy but worn-down atmosphere

---

### **Week 8: Greyford Tavern — Art Pass**

**Asset Replacement:**
- [ ] Replace whiteboxes з medieval меш-паками (Kenney/Quaternius — легкі, low-poly під слабке залізо):
  - Wooden beams, stone walls
  - Tables, chairs, bar counter
  - Props (mugs, bottles, candles)

**Lighting:**
- [ ] Fireplace warm glow (orange point lights)
- [ ] Candles on tables
- [ ] Window light (cold blue-grey)
- [ ] Volumetric fog for atmosphere

**Audio:**
- [ ] Ambient fire crackle
- [ ] Distant tavern chatter (loop)
- [ ] Footsteps on wood floor

---

### **Week 9: Greyford Hub — Exterior**

**Streets Layout:**
- [ ] Main street від tavern до administration
- [ ] 2-3 side alleys
- [ ] Small market square
- [ ] City gate (exit to wilderness)

**Modular Building System:**
- [ ] Create 3-5 modular building prefabs
- [ ] Reuse для швидкого населення
- [ ] Different facades для variety

**Population:**
- [ ] 5-8 background NPCs (idle animations)
- [ ] Generic walking paths (AI patrol)

---

### **Week 10: Atmosphere Pass**

**Lighting Final:**
- [ ] Overcast sky (grey, moody)
- [ ] Godrays через хмари (subtle)
- [ ] Adjusted post-process volume:
  - Desaturated color grading
  - Subtle vignette
  - Light film grain

**Weather:**
- [ ] Light rain particles (GPUParticles3D)
- [ ] Puddle reflections (screen space)
- [ ] Wet material instances (roofs, cobblestone)

**Sound Design:**
- [ ] Wind ambience
- [ ] Rain sound
- [ ] Distant church bell (occasional)
- [ ] Background music layer (Kevin MacLeod track)

**Performance Check:**
- [ ] Profile frame rate
- [ ] Optimize draw calls
- [ ] LODs on все static meshes

---

## 📜 Phase 3: Quest System (Weeks 11-14)

### **Week 11: Dialogue System**

**Core Dialogue:**
- [ ] Dialogue-структура як `Resource`/JSON (не DataTable — це UE-специфічне)
- [ ] Dialogue UI (Control-сцена):
  - Speaker portrait
  - Text display (typewriter effect)
  - Choice buttons (2-4 options)

**Test Dialogue:**
- [ ] Simple conversation з Ervan (tavern owner)
- [ ] 3-4 dialogue nodes
- [ ] 1 choice з 2 варіантами

**NPC System:**
- [ ] Interactable component for NPCs
- [ ] Camera framing on dialogue start
- [ ] Freeze player movement during talk

---

### **Week 12: Quest Framework**

**Quest Manager:**
- [ ] Quest-структура (JSON або `Resource`)
- [ ] QuestManager autoload singleton
- [ ] Functions:
  - StartQuest(QuestID)
  - CompleteObjective(ObjectiveID)
  - CompleteQuest(QuestID)

**Quest UI:**
- [ ] Quest log screen (Tab key)
- [ ] Active quests list
- [ ] Objective tracking HUD element

**Objective Types:**
- [ ] Talk to NPC
- [ ] Go to location
- [ ] Find item (basic pickup)

---

### **Week 13: First Quest — "Адресат відсутній"**

**NPCs Required:**
- [ ] Kelm (Administration clerk)
- [ ] Ervan (Tavern owner)
- [ ] Guard at gate

**Quest Flow:**
- [ ] Phase 1: Talk to Kelm in Administration
- [ ] Phase 2: Investigate tavern (talk to Ervan)
- [ ] Phase 3: Choice — report to Order або investigate swamp

**Implementation:**
- [ ] Create quest resource/scene
- [ ] Write all dialogue (Ukrainian)
- [ ] Setup objective triggers
- [ ] Implement choice logic

**Reputation Integration:**
- [ ] Choice affects Greyford rep (+5/-5)
- [ ] Display feedback UI ("Greyford trusts you more")

---

### **Week 14: Quest Polish**

**Voice Acting (Optional):**
- [ ] If budget allows — record key lines
- [ ] Else, quality text-to-speech (Ukrainian)

**Quest Markers:**
- [ ] Objective markers на HUD
- [ ] Distance display
- [ ] Disable на quest complete

**Testing:**
- [ ] Full quest playthrough (QA)
- [ ] Test both choice branches
- [ ] Verify reputation changes

---

## 🎨 Phase 4: Polish (Weeks 15-20)

### **Week 15-16: Combat Encounter**

**Enemy Placement:**
- [ ] Create small encounter area (forest path або alley)
- [ ] Place 2-3 enemies (bandits placeholder)
- [ ] Trigger від quest ("Defend yourself!")

**Combat Polish:**
- [ ] Hit stop (frame freeze on hit)
- [ ] Screen shake на heavy attacks
- [ ] Blood VFX (subtle, gothic)
- [ ] Death animations

**Balance:**
- [ ] Enemy damage values
- [ ] Player HP/Stamina tuning
- [ ] Combat feels challenging but fair

---

### **Week 17: Reputation System Integration**

**Visible Consequences:**
- [ ] NPCs react dynamically:
  - High Greyford rep → friendly greetings
  - Low rep → suspicious dialogue
- [ ] Prices affected (if shop exists)

**Reputation UI:**
- [ ] Screen в pause menu з всіма фракціями
- [ ] Visual bars (-40 to +40)

---

### **Week 18: Save/Load System**

**Save Game Object:**
- [ ] Player position/rotation
- [ ] HP/Stamina values
- [ ] Inventory state
- [ ] Quest progress
- [ ] Reputation values
- [ ] World state flags

**Implementation:**
- [ ] Auto-save після major quest points
- [ ] Manual save у tavern (rest at bed)
- [ ] Save slots (3)

**Testing:**
- [ ] Save → Close → Load → Continue seamlessly

---

### **Week 19: Audio Pass**

**Music:**
- [ ] Import Kevin MacLeod tracks:
  - "Folk Round" для tavern
  - "The Path of the Goblin King" для streets
- [ ] Setup music zones (triggers)
- [ ] Crossfade між tracks

**SFX:**
- [ ] Footsteps (wood, stone, dirt)
- [ ] Weapon swings, hits
- [ ] Ambient loops (fire, rain, wind)
- [ ] UI sounds (click, hover)

**Mix:**
- [ ] Balance music vs SFX vs dialogue
- [ ] Ducking music during dialogue

---

### **Week 20: VFX & Final Polish**

**VFX:**
- [ ] Torch flames (GPUParticles3D)
- [ ] Rain droplets
- [ ] Hit sparks (weapon collision)
- [ ] Magical glow (lantern, если є)

**Bug Fixing:**
- [ ] Full playthrough → log bugs
- [ ] Fix critical blockers
- [ ] Known shippable bugs → document

**Performance:**
- [ ] Final optimization pass
- [ ] Target 60 FPS на target specs
- [ ] Profiling report

---

## 🎬 Phase 5: Vertical Slice Build (Week 21)

### **Deliverables:**

**Playable Build:**
- [ ] Standalone .exe (Windows)
- [ ] 20-30 min playtime
- [ ] No critical bugs

**Presentation Materials:**
- [ ] Gameplay trailer (2-3 min)
- [ ] Feature list document
- [ ] Technical overview slides

**Feedback Session:**
- [ ] 5-10 playtesters
- [ ] Collect feedback form
- [ ] Analyze results

---

## 📊 Resource Requirements

### **Team (Ideal)**
- **1 Gameplay Programmer** — systems, GDScript
- **1 Level Designer** — Greyford layout, lighting
- **1 3D Artist** — props, characters (або безкоштовні low-poly паки)
- **1 Writer/Narrative Designer** — dialogue, quest
- **1 Sound Designer** (part-time) — audio integration

**Solo Dev Reality:**
- You'll wear all hats 😅
- Lean heavy на Marketplace assets
- Focus на unique features (narrative, choice system)

### **Budget (if buying assets)**
- Marketplace assets: $200-500
- Audio library: $50-100
- Software licenses: FREE (UE5, Blender, Git)

**Total:** ~$300-600

---

## 🚨 Risk Management

| Ризик | Mitigation |
|-------|-----------|
| **Scope creep** | Strict adherence до vertical slice scope |
| **Technical блокери** | Early prototyping, Reddit/Discord support |
| **Asset бутлнек** | Marketplace, greybox для testing |
| **Перфекціонізм** | "Good enough" для prototype |
| **Burnout** | Set realistic hours, взяти дні off |

---

## ✅ Definition of Done (Vertical Slice)

**Граємо квест від початку до кінця:**
1. ✅ Spawn у tavern
2. ✅ Talk to Ervan (діалог працює)
3. ✅ Walk до Administration (hub traversal)
4. ✅ Quest objective triggers
5. ✅ Combat encounter на шляху
6. ✅ Make choice → see reputation change
7. ✅ Quest completes → feedback UI
8. ✅ Save game → Load → continue

**Atmospheric immersion:**
- ✅ Lighting feels moody and gothic
- ✅ Audio creates tension
- ✅ World feels lived-in (NPCs, props)

**Technical stability:**
- ✅ No crashes в 30-min playthrough
- ✅ 60 FPS sustained
- ✅ Readable UI, clear controls

---

## 📚 Learning Resources

**Godot Tutorials:**
- GDQuest (YouTube) — архітектура, квест-системи
- Офіційна документація Godot — Best Practices, Autoload, FogVolume

**Communities:**
- r/godot
- Godot Discord
- Ukrainian Gamedev Community

**References:**
- Play Witcher 3 (Greyford hub feel)
- Study Disco Elysium (choice UI)

---

## 🎯 Post-Vertical Slice

**If successful → Next Steps:**

**Episode 1 Full Dev:**
- Expand Greyford (5+ quests)
- Hazemoor swamp area
- 3-4 more NPCs
- Deeper combat (abilities)

**Target:** Playable Episode 1 (2-3 hours)

**Funding Options:**
- Kickstarter campaign
- Publisher pitch (with vertical slice)
- Early Access (Steam)

---

**Roadmap Owner:** nikijetson-lab  
**Last Updated:** 26.06.2026  
**Status:** 🟡 Phase 0 in progress

**Let's build something beautiful! 🌿💀**
