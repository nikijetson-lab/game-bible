# UI/UX Design Document
## Hazemoor — User Interface Specification

> **Стиль:** Dark Gothic, Minimal, Atmospheric  
> **Референси:** Witcher 3, Disco Elysium, Darkest Dungeon  
> **Дата:** 26.06.2026

---

## 🎨 Design Philosophy

### **Core Principles:**
1. **Immersion First** — UI не заважає атмосфері
2. **Information Clarity** — важлива інформація завжди видима
3. **Gothic Aesthetic** — темні тони, орнаменти, старовинні шрифти
4. **Responsive Feedback** — кожна дія має візуальний відгук

### **Color Palette:**
- **Background:** `#0a0a0a` (майже чорний)
- **Accent:** `#c9a663` (темне золото)
- **Text Primary:** `#e8e8e8` (білий з відтінком)
- **Text Secondary:** `#8a8a8a` (сірий)
- **Health (Red):** `#a82c2c`
- **Stamina (Green):** `#4a7c3e`
- **Magic (Blue):** `#3e5b7c`

### **Typography:**
- **Headers:** Cinzel (Google Fonts) — Victorian serif
- **Body Text:** Philosopher (Google Fonts) — підтримує кирилицю
- **UI Numbers:** Roboto Mono — чіткість

---

## 📱 UI Screens Overview

### **1. Main Menu**
### **2. HUD (In-Game)**
### **3. Pause Menu**
### **4. Inventory**
### **5. Quest Log**
### **6. Dialogue Screen**
### **7. Character Sheet**
### **8. Reputation Screen**
### **9. Map**
### **10. Settings**
### **11. Death Screen**

---

## 1️⃣ Main Menu

### **Layout:**
```
+-------------------------------------------+
|                                           |
|           H A Z E M O O R                 |
|      [Atmospheric Swamp Image]            |
|                                           |
|             [New Game]                    |
|             [Continue]                    |
|             [Load Game]                   |
|             [Settings]                    |
|             [Credits]                     |
|             [Quit]                        |
|                                           |
|      v1.0  |  © 2026 nikijetson-lab       |
+-------------------------------------------+
```

### **Elements:**

**Title Logo:**
- Font: Cinzel, 72pt
- Color: Gold `#c9a663` з легким glow
- Position: Top center

**Background:**
- Animated fog над болотом
- Subtle parallax на scroll
- Ambient sound: вітер + далекі кроки

**Buttons:**
- Width: 300px
- Height: 60px
- Style: Dark frame з золотим border
- Hover: Glow effect + sound
- Font: Philosopher, 24pt

**Continue Button:**
- Disabled якщо немає saves
- Opacity: 0.5 when disabled

---

## 2️⃣ HUD (Heads-Up Display)

### **Layout:**
```
+-------------------------------------------+
| [HP: ████████░░] [Stamina: ██████░░░░]   |
| [Portrait]                      [Compass] |
|                                           |
|                [Quest Tracker]            |
|                                           |
|                                           |
| [Interact: E]                   [Quick    |
|                                  Items]   |
| [1][2][3][4]                              |
+-------------------------------------------+
```

### **Top Left: Health & Stamina**

**Health Bar:**
- Size: 250px × 30px
- Fill color: Red gradient `#a82c2c` → `#6a1f1f`
- Border: Dark gold ornamental frame
- Number overlay: "85/100" (white text)
- Low HP (<30%): Pulsing red + heartbeat sound

**Stamina Bar:**
- Below HP, same size
- Fill color: Green gradient `#4a7c3e` → `#2d4a27`
- Depletes on sprint/dodge/attack
- Regenerates automatically

**Portrait:**
- 80px × 80px круглий frame
- Показує обличчя героя (placeholder спочатку)
- Status icons (poison, buff) навколо портрета

---

### **Top Right: Compass**

**Minimap Compass:**
- Circular, 120px diameter
- North marker (золота стрілка)
- Objective markers (золоті крапки)
- Enemy indicators (червоні крапки) якщо tracking

---

### **Center: Quest Tracker**

**Active Quest Widget:**
```
┌─────────────────────┐
│ Адресат відсутній   │
│ ☐ Talk to Kelm      │
│ ☐ Investigate tavern│
│                     │
│ Distance: 45m →     │
└─────────────────────┘
```

- Position: Right side, 20% from top
- Width: 300px
- Semi-transparent background `rgba(10,10,10,0.7)`
- Auto-hide після 5 секунд idle (fade out)
- Show on objective update

---

### **Bottom Left: Interaction Prompt**

**Format:**
```
┌──────────────┐
│   [E] Talk   │
└──────────────┘
```

- Appears near player when near interactable
- Icon changes: Talk / Open / Pick Up / Examine
- Animated pulse effect

---

### **Bottom Center: Quick Items**

**Slots:**
```
[1: Bread] [2: Potion] [3: ___] [4: ___]
```

- 4 slots for hotbar items
- Keybind numbers shown (1-4)
- Item icon + quantity
- Cooldown overlay (circular)
- Drag & drop from inventory

---

## 3️⃣ Pause Menu

### **Layout:**
```
+-------------------------------------------+
|                                           |
|              P A U S E D                  |
|                                           |
|              [Resume]                     |
|              [Quests]                     |
|              [Inventory]                  |
|              [Character]                  |
|              [Map]                        |
|              [Settings]                   |
|              [Save Game]                  |
|              [Main Menu]                  |
|                                           |
+-------------------------------------------+
```

**Background:**
- Blurred game world (Gaussian blur)
- Dark overlay `rgba(0,0,0,0.8)`
- Vignette effect

**Buttons:**
- Same style as Main Menu
- Keyboard shortcuts shown: [J] Quests, [I] Inventory, etc.

---

## 4️⃣ Inventory Screen

### **Layout:**
```
+-------------------------------------------+
| [Character]    I N V E N T O R Y   [Stats]|
|                                           |
| ┌─────────┬─────────────────────────────┐|
| │ WEAPONS │ Grid of Items (8x6)         │|
| │ ARMOR   │ [Icon][Icon][Icon][Icon]    │|
| │ CONSUMAB│ [Icon][Icon][...]           │|
| │ MATERIAL│                             │|
| │ QUEST   │ Selected Item:              │|
| │         │ ┌─────────────────────┐     │|
| │         │ │ [Icon] Bread        │     │|
| │         │ │ Restores 15 HP      │     │|
| │         │ │ Stack: 5            │     │|
| │         │ │ Weight: 0.1         │     │|
| │         │ │ Value: 3 coins      │     │|
| │         │ │ [Use] [Drop]        │     │|
| │         │ └─────────────────────┘     │|
| └─────────┴─────────────────────────────┘|
| Weight: 45/100      Gold: 325            |
+-------------------------------------------+
```

### **Left Panel: Categories**
- Вертикальні tabs
- Icons + text
- Active category highlighted

### **Center Panel: Item Grid**
- 8 columns × 6 rows (48 slots)
- Each slot: 64px × 64px
- Item icon + quantity badge
- Rarity border color:
  - Common: Grey
  - Uncommon: Green
  - Rare: Blue
  - Epic: Purple
  - Legendary: Gold

### **Right Panel: Item Details**
- Large icon (128px)
- Name (title font)
- Description (body font)
- Stats (numerical)
- Actions buttons

### **Bottom Bar:**
- Current / Max weight
- Gold количество
- Sort/Filter buttons

### **Interactions:**
- **Left Click:** Select item
- **Right Click:** Quick use/equip
- **Drag & Drop:** Move items
- **Shift + Click:** Quick transfer (to chest)

---

## 5️⃣ Quest Log

### **Layout:**
```
+-------------------------------------------+
|           Q U E S T   L O G               |
|                                           |
| ┌──────────┬────────────────────────────┐|
| │ ACTIVE   │  Адресат відсутній         │|
| │ (3)      │  Episode 1: Greyford        │|
| │          │                             │|
| │ COMPLETE │  Руфін зник у болоті. Келм │|
| │ (5)      │  з Адміністрації просить    │|
| │          │  знайти його.               │|
| │ FAILED   │                             │|
| │ (0)      │  Objectives:                │|
| │          │  ☑ Talk to Kelm             │|
| │          │  ☐ Investigate tavern       │|
| │          │  ☐ Choose next step         │|
| │          │                             │|
| │          │  Rewards:                   │|
| │          │  • 50 Gold                  │|
| │          │  • +10 Greyford Rep         │|
| │          │                             │|
| │          │  [Track] [Abandon]          │|
| └──────────┴────────────────────────────┘|
+-------------------------------------------+
```

### **Left Panel: Quest List**
- Categories: Active / Completed / Failed
- Quest count badges
- Scroll list
- Click to select

### **Right Panel: Quest Details**
- Title (large, ornamental)
- Episode tag
- Description (lore text)
- Objectives checklist (☑/☐)
- Rewards preview
- Action buttons

### **Track Button:**
- Sets quest as active on HUD
- Only one quest tracked at time

---

## 6️⃣ Dialogue Screen

### **Layout:**
```
+-------------------------------------------+
|                                           |
|  [NPC Portrait]                           |
|  СЕРІТ КЕЛМ                               |
|  Secretary of Greyford Administration     |
|                                           |
| ┌─────────────────────────────────────┐  |
| │ "Вартовий? Ви прийшли щодо Руфіна?" │  |
| │                                     │  |
| │ [Reputation: Neutral 0/40]          │  |
| └─────────────────────────────────────┘  |
|                                           |
| ┌─ Player Choices ───────────────────┐   |
| │ 1. Так, де він востаннє був?       │   |
| │    [Judge] Це офіційне розслідув...│   |
| │ 2. Руфін мій друг. Що трапилось?   │   |
| │    [Mediator] Я тут щоб допомогти  │   |
| │ 3. [Skip chitchat] Де він?         │   |
| └────────────────────────────────────┘   |
+-------------------------------------------+
```

### **Top Section: NPC Info**
- Portrait (256px круглий frame)
- Name (large gold text)
- Title/роль (smaller grey)
- Reputation indicator (optional)

### **Middle: Dialogue Text Box**
- Semi-transparent dark background
- Text з typewriter effect (optional)
- Speaker name prefix якщо multiple speakers
- Icon indicators (quest update, репутація зміна)

### **Bottom: Player Choices**
- List of 2-4 options
- Numbered (1-4 або Q/E/R/F keys)
- Doctrine tags shown `[Judge]`, `[Tracker]`
- Consequences preview (reputation icon)
- Greyed out якщо requirements не виконано

### **Special Choice Types:**
```
[Judge] Intimidate him          (+Judge exp)
[Tracker] Notice the bloodstain (skill check)
[Reputation Required: 20]       (locked if <20)
[Item: Bribe 50 gold]           (consumes item)
```

### **Animations:**
- Fade in/out on dialogue switch
- Choice hover effect (glow)
- Text scroll якщо довгий текст

---

## 7️⃣ Character Sheet

### **Layout:**
```
+-------------------------------------------+
|        C H A R A C T E R                  |
|                                           |
| ┌───────────┬─────────────────────────┐  |
| │ [3D Model]│  The Warden             │  |
| │           │  Level 5 • Doctrine:    │  |
| │           │  Lantern Bearer         │  |
| │           │                         │  |
| │  Equipment│  Stats:                 │  |
| │  [Head]   │  ❤ Health:     100/100 │  |
| │  [Chest]  │  ⚡Stamina:     80/80   │  |
| │  [Weapon] │  ⚔ Damage:      25      │  |
| │  [Shield] │  🛡 Defense:     15      │  |
| │  [Ring x2]│  🎯 Crit Chance: 10%   │  |
| │           │                         │  |
| │           │  Active Effects:        │  |
| │           │  • Lantern's Blessing   │  |
| │           │    +10% Magic Resist    │  |
| └───────────┴─────────────────────────┘  |
| [Skills] [Doctrines] [Progression]       |
+-------------------------------------------+
```

### **Left: 3D Character Preview**
- Interactive rotate (mouse drag)
- Shows equipped gear
- Zoom in/out

### **Equipment Slots:**
- Visual slots з paperdoll layout
- Drag & drop equip/unequip
- Empty slots shown as outline

### **Right: Character Info**
- Name (editable?)
- Level & Doctrine
- Core stats (HP, Stamina, Damage, Defense)
- Derived stats (Crit, Speed, Resist)
- Active buffs/debuffs list

### **Bottom Tabs:**
- **Skills:** Unlocked abilities tree
- **Doctrines:** Progress в Lantern/Judge/Mediator/Tracker
- **Progression:** XP bar, talent points

---

## 8️⃣ Reputation Screen

### **Layout:**
```
+-------------------------------------------+
|          R E P U T A T I O N              |
|                                           |
| ┌─────────────────────────────────────┐  |
| │ GREYFORD ADMINISTRATION              │  |
| │ [████████████░░░░░░░░░] Friendly +15 │  |
| │ • NPCs greet you warmly              │  |
| │ • Prices: -10%                       │  |
| │ • Quest: "Trust of the People" unlck │  |
| └─────────────────────────────────────┘  |
|                                           |
| ┌─────────────────────────────────────┐  |
| │ ORDER OF SEVEN DAGGERS               │  |
| │ [░░░░░░░░░░] Neutral 0               │  |
| │ • Unknown to the Order               │  |
| └─────────────────────────────────────┘  |
|                                           |
| ┌─────────────────────────────────────┐  |
| │ MURI (Swamp Folk)                    │  |
| │ [████████████████████░] Revered +35  │  |
| │ • Muri see you as ally               │  |
| │ • Access to sacred locations         │  |
| │ • Trading: Rare herbs available      │  |
| └─────────────────────────────────────┘  |
|                                           |
+-------------------------------------------+
```

### **Faction Blocks:**
Each faction має:
- Name (header)
- Progress bar (-40 to +40)
- Current status label (Hated/Hostile/Neutral/Friendly/Revered)
- Benefits list (bullet points)
- Colored bar:
  - Red: Negative rep
  - Yellow: Neutral
  - Green: Positive rep

### **Thresholds Marked:**
```
Hated  Hostile  Neutral  Friendly  Revered
  |      |        |         |         |
-40    -15       0        +15       +30
```

---

## 9️⃣ Map Screen

### **Layout:**
```
+-------------------------------------------+
|              M A P                        |
|  [World] [Greyford] [Hazemoor] [Valkorn] |
|                                           |
| ┌─────────────────────────────────────┐  |
| │                                     │  |
| │     [Hand-drawn style map]          │  |
| │                                     │  |
| │  ⊕ Player Location                  │  |
| │  ◆ Quest Marker (Kelm)              │  |
| │  ⚔ Enemy Camp                       │  |
| │  🏠 Important Location               │  |
| │  🌫 Unexplored (fog of war)         │  |
| │                                     │  |
| └─────────────────────────────────────┘  |
|                                           |
| Legend: [+] Zoom In [-] Zoom Out [Pan]   |
+-------------------------------------------+
```

### **Style:**
- Hand-drawn parchment aesthetic
- Fog of war на неоткрытих областях
- Icons для POIs (Points of Interest)
- Tooltip на hover: location name

### **Tabs:**
- World (full map)
- Region tabs (Greyford, Hazemoor, etc.)

### **Interactions:**
- Click marker → show info tooltip
- Right-click → set custom waypoint
- Scroll → zoom
- Drag → pan

---

## 🔟 Settings Screen

### **Sections:**

**Graphics:**
- Resolution dropdown
- Fullscreen toggle
- VSync on/off
- Quality preset (Low/Medium/High/Ultra)
- Advanced: Shadows, AA, Post-processing

**Audio:**
- Master volume slider
- Music volume
- SFX volume
- Dialogue volume
- Mute all checkbox

**Controls:**
- Keybind list (rebindable)
- Mouse sensitivity slider
- Invert Y-axis checkbox
- Gamepad support toggle

**Gameplay:**
- Subtitles on/off
- Difficulty (Story/Normal/Hard)
- Tutorials/hints toggle
- Auto-save frequency

**Language:**
- Українська (default)
- English
- ...

---

## 1️⃣1️⃣ Death Screen

### **Layout:**
```
+-------------------------------------------+
|                                           |
|                                           |
|          Y O U   D I E D                  |
|                                           |
|      "The swamp claims another..."        |
|                                           |
|           [Load Last Save]                |
|           [Load Checkpoint]               |
|           [Main Menu]                     |
|                                           |
|                                           |
+-------------------------------------------+
```

### **Style:**
- Full black screen
- Red text (血紅色)
- Eerie ambient sound
- Slow fade in (2 seconds)
- Quote від Ілії або Моура (random)

---

## 🎨 UI Assets Checklist

### **Icons (64x64px):**
- [ ] Health potion
- [ ] Stamina potion
- [ ] Gold coin
- [ ] Quest marker
- [ ] Weapon icons (sword, axe, dagger, staff, spear)
- [ ] Shield icons
- [ ] Material icons (iron, copper, silver, reed)
- [ ] Status effect icons (poison, burn, bleed, buff)

### **Frames:**
- [ ] Button frame (normal/hover/pressed)
- [ ] Window border (ornamental)
- [ ] Bar backgrounds (HP/Stamina)
- [ ] Inventory slot

### **Cursor:**
- [ ] Default pointer
- [ ] Interaction hand
- [ ] Combat reticle

---

## 📐 Layout Grid System

**Base Resolution:** 1920x1080 (16:9)

**Safe Zone:** 5% margin from edges (96px horizontal, 54px vertical)

**Grid:** 12-column grid для responsive layout

---

## ✅ Implementation Priority

**Phase 1 (Prototype):**
1. HUD (HP/Stamina bars)
2. Interaction prompt
3. Pause menu
4. Dialogue screen (basic)

**Phase 2 (Vertical Slice):**
5. Inventory
6. Quest log
7. Character sheet

**Phase 3 (Full Game):**
8. Reputation screen
9. Map
10. Settings (full)
11. Death screen polish

---

**Document Owner:** nikijetson-lab  
**Last Updated:** 26.06.2026

**Status:** 📝 Design complete, ready for mockups!
