# Asset Production List
## Hazemoor — Vertical Slice Assets

> **Scope:** Тільки для Vertical Slice (Greyford + First Quest)  
> **Філософія:** Lean on Marketplace → Replace custom пізніше  
> **Дата:** 26.06.2026

---

## 🎨 3D Models

### **Characters**

#### **Player Character (Protagonist)**
- **Type:** Customizable human male/female (eventually)
- **For Vertical Slice:** Generic medieval warrior (Marketplace)
- **Needed:**
  - Body mesh (with armor)
  - Face (basic, hood може ховати)
  - Weapon (sword + shield або dual-wield)
  - Cloak (cloth sim)

**Marketplace Options:**
- *Medieval Character Pack* (Epic Marketplace)
- *RPG Character Pack* (Unreal Marketplace)
- **Fallback:** Mannequin + medieval outfit від starter content

**Custom Requirements (later):**
- Specific "Warden" look (tall, worn armor)
- Unique silhouette

---

#### **Key NPCs (for Vertical Slice)**

**Total Needed:** 3 unique + 5 generic

| NPC | Role | Priority | Asset Approach |
|-----|------|----------|---------------|
| **Ervan** | Tavern owner | HIGH | Marketplace NPC + custom texturing |
| **Kelm** | Clerk | HIGH | Marketplace bureaucrat type |
| **Guard** | Gate guard | MEDIUM | Marketplace guard armor |
| **Generic Townsfolk** (x5) | Background | LOW | Marketplace crowd pack |

**Specifications:**
- Low poly (10k-20k tris) для NPCs
- Modular armor system (reuse pieces)
- LODs (3 levels)

**Marketplace Options:**
- *Medieval NPC Pack*
- *Villagers Pack*
- *Town Guard Characters*

---

#### **Enemies (for Combat Encounter)**

**Needed:** 1 enemy type (x3 instances)

| Enemy | Description | Priority |
|-------|-------------|----------|
| **Bandit** | Generic human enemy | HIGH |

**Specs:**
- Reuse player skeleton для animations
- Different armor/clothes від player
- Weapon: Axe OR Sword

**Marketplace:** Generic enemy packs

---

### **Environment — Greyford Tavern Interior**

**Props Required:**

| Asset | Quantity | Notes |
|-------|----------|-------|
| **Tables** (wood) | 4-5 | Medieval style, worn |
| **Chairs** | 12-15 | Mix benches та stools |
| **Bar counter** | 1 | Long wooden bar |
| **Barrels** | 5-8 | Ale kegs |
| **Bottles/Mugs** | 20+ | Small props, clustered |
| **Fireplace** | 1 | Stone, large |
| **Candles** | 10+ | On tables, holder variants |
| **Wooden beams** | Modular | Ceiling support |
| **Stone walls** | Modular | Tileable textures |
| **Stairs** | 1 set | To upper floor |
| **Doors** | 2 | Front + Back exit |
| **Windows** | 2-3 | Small, dirty glass |

**Marketplace Packs:**
- *Medieval Tavern Environment*
- *Stylized Medieval Village*
- *Medieval Props Mega Pack*

---

### **Environment — Greyford Exterior (Hub)**

**Tileset Needed:**

| Asset | Type | Quantity |
|-------|------|----------|
| **Cobblestone Street** | Modular tiles | 10 variants |
| **Building Facades** | Modular walls | 5 types |
| **Roofs** | Modular pieces | 3 styles |
| **Doors** | Static meshes | 4 variants |
| **Windows** | With frames | 3 variants |
| **Fences/Walls** | Barriers | Tileable |
| **Market Stalls** | Props | 3-4 types |
| **Lamps/Torches** | Light sources | 5+ |
| **Garbage/Clutter** | Decals + meshes | Hay, barrels, crates |

**Reference Style:**
- Witcher 3 Novigrad
- Kingdom Come: Deliverance

**Marketplace:**
- *Medieval Environment Pack* (Epic)
- *European Medieval City Builder*

---

### **Foliage & Nature**

| Asset | Usage | Priority |
|-------|-------|----------|
| **Trees** (dead/dying) | Roadsides, distance | MEDIUM |
| **Grass** (dark, wet) | Ground coverage | LOW |
| **Shrubs/Bushes** | Detail | LOW |
| **Rocks** | Scatter | LOW |

**Approach:** UE5 Mega Scans (free, high quality)

---

## 🎨 Textures & Materials

### **Core Materials**

| Material | Usage | Notes |
|----------|-------|-------|
| **Wet Cobblestone** | Streets | PBR, puddles |
| **Aged Wood** | Buildings, props | Tileable, 2K |
| **Moss Stone** | Walls | Gothic feel |
| **Dirty Glass** | Windows | Translucent |
| **Metal (Iron)** | Weapons, armor | Worn, rusty |
| **Fabric (Wool/Linen)** | Clothes | Worn, patched |

**Master Materials:**
- Create 1 master material з параметрами:
  - Base Color
  - Roughness
  - Normal
  - AO
  - Wetness Blend

**Sources:**
- Quixel Megascans (free з UE5)
- Substance Source (if budget)
- Texture Haven (free)

---

## 🎵 Audio Assets

### **Music**

| Track | Location | Source |
|-------|----------|--------|
| **"Folk Round"** | Tavern interior | Kevin MacLeod (CC) |
| **"The Path of the Goblin King"** | Greyford streets | Kevin MacLeod (CC) |
| **"The Descent"** | Combat encounter | Kevin MacLeod (CC) |

**Implementation:**
- Download MP3/WAV від incompetech.com
- Convert to UE5 Sound Cue
- Loop seamlessly

---

### **Sound Effects**

**Needed SFX:**

| Category | Sounds | Quantity |
|----------|--------|----------|
| **Ambience** | Rain, wind, fire crackle, tavern chatter | 4-5 loops |
| **Footsteps** | Wood, stone, dirt, grass | 4 sets (each 8-12 variants) |
| **Weapon** | Sword swings, hits, parries | 10-15 |
| **UI** | Button click, hover, quest update | 5-8 |
| **Dialogue** | Conversation blips (optional) | 2-3 |
| **Combat** | Grunts, death sounds | 6-10 |

**Sources:**
- Freesound.org (CC0 license)
- Sonniss Game Audio GDC Packs (free yearly)
- BBC Sound Effects Library (free)

**Format:** WAV, 48kHz, 16-bit

---

### **Voice Acting (Optional)**

**If budget allows:**
- Record key lines для Ervan, Kelm
- Ukrainian voice actors (Fiverr, local talent)
- Min 50-100 lines для vertical slice

**Fallback:**
- Text-only dialogue (many RPGs do this)
- Quality TTS (ElevenLabs для placeholder)

---

## ✨ VFX (Visual Effects)

### **Needed Effects (Niagara)**

| Effect | Usage | Priority |
|--------|-------|----------|
| **Rain** | Weather system | HIGH |
| **Torch Fire** | Light sources | HIGH |
| **Candle Flame** | Tavern ambience | MEDIUM |
| **Hit Sparks** | Combat feedback | HIGH |
| **Blood Splatter** | Combat (subtle) | MEDIUM |
| **Dust Motes** | Indoor air | LOW |
| **Magical Glow** | Lantern (if present) | MEDIUM |

**Approach:**
- Use UE5 Niagara templates
- Modify parameters (color, size, spawn rate)
- Marketplace VFX packs для inspiration

**Marketplace:**
- *Realistic Starter VFX Pack*
- *Medieval Magic VFX*

---

## 🖼️ UI/UX Assets

### **Graphic Elements**

| Asset | Usage | Format |
|-------|-------|--------|
| **Health bar frame** | HUD | PNG (transparent) |
| **Stamina bar fill** | HUD | Gradient texture |
| **Quest marker icon** | HUD | SVG → PNG |
| **Interact prompt** | "[E] Talk" | Text + icon |
| **Dialogue frame** | Dialogue UI | Ornate border |
| **Button styles** | Menus | Normal/Hover/Pressed states |
| **Icons** (Inventory) | Items | 128x128 px |
| **Fonts** | UI text | Medieval serif (free) |

**Font Recommendations:**
- *Cinzel* (Google Fonts) — headers
- *Philosopher* (Google Fonts) — body text, Ukrainian support

**Tools:**
- Figma — UI mockups
- GIMP/Photoshop — icon creation

---

### **UI Screens Needed**

1. **Main HUD:**
   - Health bar (top-left)
   - Stamina bar (below health)
   - Quick slots (bottom-center)
   - Quest tracker (right-side)
   - Interact prompt (center-bottom)

2. **Pause Menu:**
   - Resume
   - Quests
   - Reputation
   - Settings
   - Quit

3. **Dialogue Screen:**
   - Speaker portrait (left)
   - Text box (bottom)
   - Choice buttons (stacked)

4. **Quest Log:**
   - Quest list (left panel)
   - Details (right panel)
   - Objectives checklist

---

## 🎬 Animation Assets

### **Player Animations**

**Required:**

| Animation | Type | Priority |
|----------|------|----------|
| **Idle** | Loop | HIGH |
| **Walk** | Loop | HIGH |
| **Run** | Loop | HIGH |
| **Sprint** | Loop | HIGH |
| **Jump** | One-shot | MEDIUM |
| **Crouch Idle/Walk** | Loop | MEDIUM |
| **Dodge Roll** | One-shot | HIGH |
| **Light Attack x3** | Combo | HIGH |
| **Heavy Attack** | One-shot | HIGH |
| **Block Idle** | Loop | HIGH |
| **Hit Reaction** | One-shot | HIGH |
| **Death** | One-shot | MEDIUM |

**Source:**
- Marketplace animation packs:
  - *Sword & Shield Animset Pro*
  - *RPG Character Melee Combo Pack*

**Retargeting:**
- Use UE5 IK Retargeter для share animations

---

### **NPC Animations**

**Needed:**

| Animation | Usage | Quantity |
|-----------|-------|----------|
| **Talking (Gestures)** | Dialogue | 3-5 variants |
| **Idle (Standing)** | Background NPCs | 2-3 |
| **Walking** | Movement | 1 |
| **Working** (sweeping, hammering) | Ambient life | 2-3 |

**Marketplace:** NPC animation packs

---

### **Enemy Animations**

**Bandit:**
- Idle, Walk, Run
- Attack x2
- Block
- Hit Reaction
- Death

**Source:** Reuse player animations (different timing)

---

## 📦 Asset Acquisition Strategy

### **Phase 1: Free Assets (Week 1-2)**
- ✅ Quixel Megascans (textures, props)
- ✅ UE5 Starter Content (basic materials)
- ✅ Free Marketplace assets (every month Epic дає free content)
- ✅ Kevin MacLeod music
- ✅ Freesound SFX

**Cost:** $0

---

### **Phase 2: Budget Marketplace (Week 3-4)**
- Purchase key packs:
  - Medieval Environment ($50-100)
  - Character Pack ($30-50)
  - Animation Set ($30-50)

**Cost:** ~$150-250

---

### **Phase 3: Custom Assets (Week 5+)**
- Commission або створити unique assets:
  - Player character final design
  - Key NPC faces (Ervan, Kelm)
  - Unique props (quest items)

**Cost (if outsourcing):** $300-500

**Total Budget:** ~$500 (manageable для indie)

---

## 📐 Asset Specifications (Technical)

### **3D Models**
- **Poly Count:**
  - Characters: 20k-40k tris (with LODs)
  - Props: 500-5k tris
  - Buildings: 10k-30k tris (modular)
- **Textures:** 2K (2048x2048) PBR
- **LODs:** 3 levels (LOD0, LOD1, LOD2)
- **Collision:** Simple box/capsule colliders

### **Textures**
- **Resolution:** 2K standard, 4K для hero assets
- **Format:** PNG (source) → UE5 compresses
- **Channels:**
  - Base Color (RGB)
  - Normal (RGB)
  - ORM packed (Occlusion/Roughness/Metallic)

### **Audio**
- **Music:** 48kHz, 16-bit WAV (stereo)
- **SFX:** 48kHz, 16-bit WAV (mono для 3D sounds)
- **Compression:** UE5 auto-compresses до Ogg Vorbis

### **VFX**
- **Particle Count:** <500 per emitter (performance)
- **Textures:** 512x512 або 1024x1024
- **Draw Calls:** <10 per effect

---

## ✅ Asset Delivery Checklist

**Before importing до UE5:**
- [ ] All models у correct scale (1 Unreal unit = 1 cm)
- [ ] Proper naming convention (`SM_Tavern_Table_01`)
- [ ] Textures named consistently (`T_Wood_BaseColor`, `T_Wood_Normal`)
- [ ] FBX export settings: Y-up, -Z forward
- [ ] Materials embedded OR separate files

**After import:**
- [ ] Setup collisions
- [ ] Create material instances
- [ ] Generate LODs (UE5 auto-LOD OR manual)
- [ ] Test in test level

---

## 📊 Asset Pipeline Workflow

```
1. Planning (This doc)
   ↓
2. Acquisition (Marketplace/Download/Commission)
   ↓
3. Organization (Folder structure)
   ↓
4. Import to UE5
   ↓
5. Setup (Materials, Collisions, LODs)
   ↓
6. Integration (Place in level, test)
   ↓
7. Optimization (Profile, adjust)
```

---

## 🎯 Success Metrics

**Asset Quality Bar:**
- ✅ Fits gothic medieval aesthetic
- ✅ Performance budget met (60 FPS target)
- ✅ Consistent art style (не mismatched)
- ✅ Functional (collisions work, materials look correct)

**Iteration Philosophy:**
- "Good enough" для vertical slice
- Mark assets для "replace later" (ugly но functional)
- Focus на gameplay feel > visual perfection (на цьому етапі)

---

## 🚀 Next Steps

1. **Create asset spreadsheet** (Google Sheets)
   - Columns: Asset Name, Type, Source, Status, Owner
   - Track progress

2. **Setup shared folder** (Google Drive / Dropbox)
   - For outsourced assets
   - Backup source files

3. **Begin Phase 1** (Free asset hunting)
   - Download asset packs цього тижня
   - Test import до UE5

---

**Document Owner:** nikijetson-lab  
**Last Updated:** 26.06.2026

**Remember:** *Start ugly, iterate beautiful!* 🎨
