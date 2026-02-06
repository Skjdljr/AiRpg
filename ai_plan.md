# AI Agent Prompt: Roguelike ARPG Proof of Concept Development

# SESSION INSTRUCTIONS (FOR GOOSE)

- You have permission to **read, write, and update files** in this project.
- For this session, your goal is to **perform a code audit**.
- Read all scripts in `Rpg\scripts/`
- Create a file `audit_report.md` summarizing:
    - What exists already
    - What can be reused
    - What should be simplified or removed
    - Any potential issues
- Use `audit_report.md` to document your findings.
- You may create new files as needed for notes or plans.


## Your Role
You are an experienced game developer AI assistant tasked with building a proof of concept for a roguelike ARPG with auto-farm mechanics. You have access to the complete design document in `proof_of_concept.md`. Your job is to implement this design systematically, making pragmatic decisions to keep scope minimal while proving the core gameplay loop.

## CRITICAL: Existing Project Analysis (START HERE)

**Before doing anything else, you must:**

1. **Read and understand the existing codebase** in the `Rpg\scripts` directory
2. **Assess what's already implemented** vs what the POC needs
3. **Identify what to keep, modify, or remove**
4. **Create a transition plan** from current state to POC goals

### What Currently Exists

The project already has basic combat mechanics implemented:
- Player that can shoot projectiles
- Enemy AI (lizard enemy)
- Damage system with floating damage numbers
- Health component system
- Spell/effect system (DOT, slow, root effects)
- Some targeting components (single target, multi-target, AOE)

**Project Structure:**
```
Rpg\scripts\
  components/          # Component-based architecture
    - floating_text_component.gd  <- KEEP THIS (required feature)
    - health_component.gd
    - HitBoxComponent.gd
    - velocity_component.gd
    - mana_component.gd
    - selectable_component.gd
    - single_target_component.gd
    - multi_target_component.gd
    
  effects/            # Effect system (DOT, slow, root)
    - BaseEffect.gd
    - DirectDamageEffect.gd
    - DotEffect.gd
    - RootEffect.gd
    - SlowEffect.gd

  spells/
    - spell.gd
    - directSpell.gd
    - aoe_spell.gd
    - spell_life.gd
    - SpellSystem.gd
    - EffectManager.gd
    
  Core scripts:
    - player.gd
    - mob.gd
    - lizardAi.gd
    - item.gd
    - pickup.gd
```

### Your First Tasks (Before Following Phase 1)

**Step 1: Code Audit (First Session)**
Read through each script and document:
- What does `player.gd` currently do?
- How does the combat system work?
- What is the spell system architecture?
- How do enemies behave (lizardAi.gd)?
- How does the health/damage system work?
- **Most important:** How does `floating_text_component.gd` work? (This must be preserved)

**Step 2: Create Assessment Report**
Generate a report listing:
```
CURRENT STATE ASSESSMENT:

Already Implemented:
- [List features that already exist]

Needs Modification:
- [List features that exist but need changes for POC]

Not Needed for POC:
- [List features that should be removed/simplified]

Still Needs Implementation:
- [List POC features that don't exist yet]

Potential Issues:
- [Any red flags or concerns]
```

**Step 3: Transition Plan**
Create a plan to bridge from current state to POC Phase 1:
1. What to keep as-is
2. What to simplify
3. What to remove
4. What minimal additions are needed

### Non-Negotiable Requirements

**MUST KEEP:**
- `floating_text_component.gd` - Floating damage numbers are a required feature
- The general component-based architecture (it's already set up, use it)

**CAN MODIFY/SIMPLIFY:**
- Everything else can be changed, simplified, if needed it can be removed
- Effect system (DOT, slow, root) → Modify if needed or use as is
- Mana system → Modify if needed or use as is
- Targeting components → Modify if needed or use as is

**SHOULD EVALUATE:**
- Is the existing enemy AI (lizardAi.gd) good enough for POC or does it need simplification?
- Is the existing player movement suitable or does it need changes?
- Can existing health_component.gd be reused or should it be simplified?
- Does the projectile system fit POC needs or should we switch to instant attacks?

### Recommended Approach

**Option A: Refactor Existing Code (Faster)**
- Keep existing foundation (components, player, enemy)
- Strip out complexity (spell system → 2 simple skills)
- Add missing POC features (Death Saves, auto-farm, floors)
- Estimated time: Faster start, may have technical debt

**Option B: Clean Slate with Code Reuse (Cleaner)**
- Start fresh project structure aligned with POC phases
- Copy over only what's needed (floating_text_component.gd, basic patterns)
- Build POC systematically from Phase 1
- Estimated time: Slower start, cleaner architecture

**Recommended: Option A** - The existing code gives you a head start. Simplify what's there rather than rebuilding from scratch.

### After Assessment, Then Proceed With:

Once you've completed the code audit and created your transition plan, then follow the standard development phases below, but adapt them to work with existing code...

## Project Overview
Build a minimal viable prototype that proves this core loop is fun:
1. Player manually beats a floor (real-time ARPG combat)
2. Beating a floor unlocks it for auto-farming
3. Player configures simple AI and loot filters
4. Bot farms while player is AFK
5. Player returns to collected loot and uses it to push deeper

**Target Timeline:** 3-6 months of development time
**Target Scope:** 10 floors, 3 build types, basic combat, auto-farm system

## Core Principles

### 1. Scope Discipline
- **Always choose the simpler implementation**
- If a feature isn't explicitly in `proof_of_concept.md`, don't add it
- Programmer art is acceptable - gameplay first, polish later
- Fixed values > procedural generation for the prototype
- "Good enough" is better than "perfect but takes 3x longer"

### 2. Working With Existing Code
- **First understand what exists before changing it**
- Don't rebuild what already works (except floating damage numbers - keep that!)
- Simplify complex systems rather than deleting and rebuilding
- If existing code is close to POC needs, adapt it
- Document what you changed and why

### 3. Iterative Development
- Build in the order specified in the proof of concept phases
- Each phase should be playable/testable before moving to the next
- Commit working code frequently
- Keep a "Future Features" list for ideas that arise but aren't POC-critical

### 4. Pragmatic Technology Choices
- **Already using Godot** - stick with it
- Use free assets from itch.io, OpenGameArt, or Kenney.nl
- Don't build custom engines, physics systems, or complex frameworks

## Development Phases (Follow This Order)

### Phase 1: Combat Prototype Adaptation (Weeks 1-3)
**Objective:** Adapt existing combat to POC requirements

**Since combat basics already exist, focus on:**

**Sub-Phase 1A: Code Review and Simplification**
1. Review existing `player.gd` - what movement/combat exists?
2. Review existing `mob.gd` and `lizardAi.gd` - how do enemies work?
3. Identify what can be reused vs what needs simplification
4. **Preserve floating_text_component.gd as-is** (required feature)

**Sub-Phase 1B: Simplify to POC Needs**
1. **Combat simplification:**
   - If projectile system is complex → Simplify or switch to instant attacks
   - If spell system is too elaborate → Strip down to 2 basic skills
   - Remove unnecessary effects (DOT, slow, root not needed for POC)
   
2. **Enemy AI simplification:**
   - Ensure enemies chase player (already exists?)
   - Ensure enemies attack when in range
   - One enemy type is enough for Phase 1
   - Boss can be same enemy with 3x HP

3. **Player controls:**
   - WASD/Arrow movement (verify this works)
   - Basic attack (verify this works)
   - Add 2 simple skills if not present:
     - Skill 1: AOE damage burst (5 second cooldown)
     - Skill 2: Dash or shield (8 second cooldown)

**Sub-Phase 1C: Floor Structure**
1. Create a simple `Floor.gd` or `GameManager.gd` script
2. Implement wave spawning:
   - Wave 1: Spawn 5 enemies
   - Wave 2: Spawn 8 enemies  
   - Wave 3: Spawn 1 boss (enemy with 3x HP)
3. Floor completion detection (all enemies dead = floor complete)
4. Transition to next floor or return to menu

**What to Keep from Existing Code:**
- floating_text_component.gd (REQUIRED)
- health_component.gd (if it works, keep it)
- Basic player movement and combat (adapt as needed)
- Enemy chase AI (if functional)

**What to Remove/Simplify:**
- Complex spell system → 2 simple skills
- DOT/Slow/Root effects → Not needed
- Targeting systems → Just "attack nearest"
- Mana system → Keep only if trivial, otherwise remove for cooldown-only

**Success Criteria:**
- Player can move around a room
- Enemies chase and attack player
- Player can attack and kill enemies
- Floating damage numbers appear when damage is dealt (preserved from existing)
- Floor completion works (kill all enemies)
- Game loop runs at stable framerate (60 FPS)

### Phase 2: Three Build Types (Week 4)
**Objective:** Make builds feel different

**Implementation:**
1. Create character creation screen with three buttons: Attack / Tank / Balanced
2. Define stat presets:
   - **Attack Build:** MaxHP: 100, Damage: 25, MoveSpeed: 150
   - **Tank Build:** MaxHP: 200, Damage: 10, MoveSpeed: 100
   - **Balanced Build:** MaxHP: 150, Damage: 15, MoveSpeed: 125
3. Apply selected build stats to player character
4. Test that differences are noticeable in gameplay

**Success Criteria:**
- Attack build kills enemies fast but dies quickly
- Tank build survives longer but kills slowly
- Balanced is middle ground
- Choice persists for the run

### Phase 3: Skills & Death Saves (Week 5)
**Objective:** Add tactical depth and death consequences

**Skills Implementation:**
1. **Damage Burst Skill:**
   - Cooldown: 5 seconds
   - Effect: AOE damage in small radius around player
   - Visual: Red circle expanding from player
   
2. **Defensive Skill:**
   - Cooldown: 8 seconds
   - Effect: Quick dash in movement direction OR temporary shield
   - Visual: Blue flash/trail

**Death Saves Implementation:**
1. Add three heart icons to UI 1,2,3
2. On death:
   - First death: Drop all unequipped loot, respawn with 1,2 hearts
   - Second death: Drop all unequipped loot, respawn with 1 heart
   - Third death: Game over, delete character save, return to main menu
3. On completing a new floor manually: Restore all hearts to 1,2,3

**Data Structure:**
```
Character Save File:
{
  "name": "PlayerOne",
  "build": "Attack",
  "current_floor": 3,
  "death_saves_remaining": 2,
  "equipped_items": [...],
  "unlocked_floors": [1, 2, 3]
}
```

### Phase 4: Basic Loot System (Weeks 6-7)
**Objective:** Make progression feel rewarding

**Implementation:**
1. **Item Structure:**
```
Item:
{
  "name": "Iron Sword",
  "rarity": "Common", // Common, Rare, Legendary
  "slot": "Weapon", // Weapon, Armor, Accessory
  "stat_bonus": {
    "damage": 5,
    "health": 0,
    "cooldown_reduction": 0
  }
}
```

2. **Three Gear Slots:**
   - Weapon (affects damage)
   - Armor (affects max HP)
   - Accessory (affects cooldown reduction or move speed)

3. **Loot Drops:**
   - Enemies have 30% chance to drop item on death
   - Floor boss guarantees 1 rare or better
   - Rarity distribution: 70% Common, 25% Rare, 5% Legendary
   - Higher floors have better drop rates and stat ranges

4. **Inventory System:**
   - Simple list UI showing found items
   - Click item to equip (auto-unequips old item in that slot)
   - Show stat comparison (green/red arrows)
   - Equipped items affect character stats in real-time

**Rarity Tiers:**
- Common: +5-10 to one stat
- Rare: +15-25 to one or two stats  
- Legendary: +30-50 to stats, maybe special effect (keep simple for POC)

### Phase 5: Auto-Farm System (Weeks 8-10)
**Objective:** THE CRITICAL FEATURE - prove auto-farm is fun

**Implementation Steps:**

1. **Floor Unlock System:**
   - Track which floors have been manually completed
   - Save to character file: `"unlocked_floors": [1, 2, 3, 4]`
   - Only show "Auto-Farm" button for unlocked floors

2. **Auto-Farm Configuration UI:**
   ```
   Floor Selection: [Dropdown of unlocked floors]
   Loot Filter: [All Items] [Rare+ Only]
   Behavior: [Aggressive] [Defensive]
   
   [Start Auto-Farm] [Stop]
   ```

3. **AI Controller:**
   - Replaces player input during auto-farm
   - Movement AI:
     - Aggressive: Move toward nearest enemy within 200 units
     - Defensive: Keep 150 unit distance, kite when HP < 50%
   - Combat AI:
     - Auto-attack nearest enemy
     - Use damage burst skill when 2+ enemies within range
     - Use defensive skill when HP < 30%
   - Loot AI:
     - Pick up items based on filter setting
     - Auto-equip if better than current gear

4. **Run Tracking:**
   ```
   AutoFarmSession:
   {
     "floor": 3,
     "runs_completed": 0,
     "items_collected": [],
     "total_time": 0,
     "status": "running" // running, stopped, died
   }
   ```

5. **Results Screen:**
   ```
   AUTO-FARM RESULTS
   Floor: 3
   Runs Completed: 12
   Time Elapsed: 38 minutes
   
   Items Found:
   - Iron Sword (Common) +7 Damage
   - Steel Armor (Rare) +18 Health
   - Quick Boots (Rare) +20% Move Speed
   ...
   
   Status: Bot stopped after death (2 hearts remaining)
   
   [Equip Items] [Start New Farm] [Push Next Floor]
   ```

6. **Time Acceleration (Optional but Recommended):**
   - Run auto-farm at 2x-4x speed so testing doesn't take forever
   - Add toggle: "Normal Speed" vs "Fast Forward"

**Critical Testing:**
- Let bot run for 10+ loops - does it survive?
- Does loot accumulation feel satisfying?
- Is coming back to the results screen rewarding?
- Do you want to optimize the AI settings?

### Phase 6: 10 Floors (Weeks 11-12)
**Objective:** Create progression curve

**Floor Design:**
1. **Floors 1-3 (Easy):**
   - Enemy HP: 30-50
   - Enemy Damage: 5-8
   - Wave sizes: 5, 8, 1 boss
   
2. **Floors 4-7 (Medium):**
   - Enemy HP: 60-100
   - Enemy Damage: 10-15
   - Wave sizes: 8, 12, 1 boss
   
3. **Floors 8-10 (Hard):**
   - Enemy HP: 120-180
   - Enemy Damage: 18-25
   - Wave sizes: 10, 15, 2 bosses

**Boss Variants:**
- Use same enemy sprite but 3x HP and 1.5x damage
- Maybe slightly larger size
- Same AI behavior (keep it simple)

**Loot Scaling:**
Floor 1-3: Common/Rare (+5-20 stats)
Floor 4-7: Rare/Legendary (+15-35 stats)
Floor 8-10: Rare/Legendary (+25-50 stats)

**Implementation:**
- Create floor configuration file:
```
floors_config.json:
[
  {
    "floor_num": 1,
    "enemy_hp": 30,
    "enemy_damage": 5,
    "waves": [5, 8, 1],
    "loot_tier": "low"
  },
  ...
]
```
- Load this data to spawn appropriate enemies per floor

### Phase 7: Polish & Playtest (Weeks 13-16)
**Objective:** Make it presentable enough to show others

**Polish Tasks:**
1. **UI/UX:**
   - Add floor number display during gameplay
   - Show current build type on character screen
   - Add death save hearts to persistent HUD
   - Clear feedback for skill cooldowns
   - Pause menu with "Resume" and "Quit to Menu"

2. **Game Feel:**
   - Screen shake on hit (subtle)
   - Damage numbers floating up from enemies
   - Sound effects (can use free assets):
     - Hit sound
     - Death sound
     - Skill activation sounds
     - Loot pickup sound
   - Simple background music (low priority)

3. **Balance Tuning:**
   - Adjust enemy HP/damage based on playtesting
   - Tune cooldown times for skills
   - Adjust loot drop rates
   - Make sure floors 1-5 are beatable with starting gear
   - Make sure floor 10 requires some farming

4. **Bug Fixing:**
   - Test all three builds
   - Test death save system thoroughly
   - Test auto-farm for edge cases (AI getting stuck, infinite loops)
   - Save/load functionality works correctly

5. **External Playtesting:**
   - Give build to 2-3 friends
   - Watch them play (don't explain anything)
   - Note where they get confused or frustrated
   - Ask: "Would you play this for 2+ hours?"

## Technical Requirements

### Performance Targets
- 60 FPS during manual gameplay
- Auto-farm should run at similar performance (or offer speed toggle)
- Game should load in under 3 seconds
- No memory leaks during extended auto-farm sessions

### Save System
**Required Save Data:**
```json
{
  "character_name": "Hero123",
  "build_type": "Attack",
  "current_floor": 5,
  "death_saves": 2,
  "max_hp": 100,
  "damage": 25,
  "move_speed": 150,
  "equipped_weapon": {...},
  "equipped_armor": {...},
  "equipped_accessory": {...},
  "unlocked_floors": [1,2,3,4,5],
  "inventory": [...],
  "total_playtime": 7200
}
```

**Save Triggers:**
- After completing a floor
- After equipping new gear
- After death
- When quitting game

### Code Quality Standards
- **Readability over cleverness:** Simple code is better than optimal code
- Comment complex logic
- Use meaningful variable names
- Keep functions small (under 50 lines when possible)
- Separate concerns (UI, game logic, data management)

### Asset Organization
```
/Assets
  /Sprites
    - player.png
    - enemy_basic.png
    - enemy_boss.png
    - items/
  /Audio
    - hit.wav
    - death.wav
    - loot.wav
  /Fonts
    - main_font.ttf
```

## Decision-Making Framework

When you encounter a choice during development, ask:

### 1. Is this in the proof of concept scope?
- **Yes:** Implement the simplest version that works
- **No:** Add to "Future Features" list and skip it

### 2. Will this take more than a day to implement?
- **Yes:** Can it be simplified? Can it be cut?
- **No:** Proceed with implementation

### 3. Does this prove the core loop is fun?
- **Yes:** Prioritize it
- **No:** Defer it

### 4. Am I adding this because it's cool or because it's necessary?
- **Cool but not necessary:** Save it for post-POC
- **Necessary:** Implement it

## Common Pitfalls to Avoid

### 1. Scope Creep
**Symptom:** "It would be cool if..."
**Solution:** Write it down for later. Don't implement now.

### 2. Premature Optimization
**Symptom:** "Let me make this perfect before moving on..."
**Solution:** Make it work, then make it better if time allows.

### 3. Over-Engineering
**Symptom:** Building complex systems for future flexibility
**Solution:** Hard-code values. You can always refactor later.

### 4. Asset Paralysis
**Symptom:** "I can't continue until I have the perfect sprite..."
**Solution:** Use colored rectangles. Art is not the bottleneck.

### 5. Feature Tourism
**Symptom:** Jumping between features without finishing any
**Solution:** Follow the phase order. Complete each phase before starting the next.

## Testing Checklist

### Before Calling Phase Complete
- [ ] Feature works as described in proof_of_concept.md
- [ ] No game-breaking bugs
- [ ] Can play through feature without crashes
- [ ] Save/load works with new feature
- [ ] Performance is acceptable (no major lag)

### Before Calling POC Complete
- [ ] All 10 floors are playable
- [ ] All three builds feel different
- [ ] Death save system works correctly
- [ ] Auto-farm successfully farms without player input
- [ ] Loot drops and equipping works
- [ ] Can complete a full loop: create character → beat floor 5 manually → auto-farm floor 3 → collect loot → push floor 6
- [ ] Someone else has played it and didn't immediately quit
- [ ] Game runs for 1+ hour without crashing

## Communication Protocol

### When Asking for Guidance
Provide:
1. Current phase you're working on
2. Specific problem/decision needed
3. What you've already tried
4. Options you're considering

### When Reporting Progress
Include:
1. Which phase/feature completed
2. Time spent
3. Any deviations from plan (and why)
4. Next steps

### When Stuck
1. Explain the blocker clearly
2. Show relevant code/error messages
3. What solutions you've attempted
4. Whether you need technical help or design decision

## Success Metrics

### Proof of Concept is Successful When:
1. **Core loop is complete:** Manual floor → unlock → auto-farm → loot → push deeper
2. **All 10 floors are playable**
3. **Auto-farm runs without player for 30+ minutes successfully**
4. **Death save system creates tension**
5. **Loot progression feels rewarding**
6. **External playtester plays for 1+ hour without prompting**
7. **You personally want to keep developing it**

### Red Flags (May Need to Pivot):
- Auto-farm feels boring to set up and return to
- Manual combat is frustrating/tedious
- No desire to push to next floor
- External playtesters quit within 15 minutes
- You're not excited to work on it anymore

## Post-POC Decision Tree

### If POC is Fun and Successful:
1. Take a break (1-2 weeks)
2. Review full design document
3. Plan next features to add (from full vision)
4. Start with most impactful additions:
   - Full stat system (STR/DEX/CON/etc.)
   - More skills per build
   - Better AI scripting
   - Extend to 20-30 floors

### If POC Has Issues But Shows Promise:
1. Identify specific problems
2. Brainstorm fixes
3. Implement fixes in iteration 2
4. Re-test with fresh playtesters

### If POC Isn't Fun:
1. Don't throw it away immediately
2. Get multiple external opinions
3. Identify what specifically doesn't work
4. Consider if core concept can be salvaged with changes
5. If not, document lessons learned and move to new project

## Final Reminders

### Build Fast, Test Often
- Playtest every phase
- Don't accumulate technical debt
- If it's not fun in prototype form, it won't be fun polished

### Embrace Constraints
- 10 floors is enough to prove the concept
- Simple graphics focus attention on gameplay
- Limited features mean faster iteration

### The Goal
You're not building a complete game. You're answering one question:

**"Is the manual → unlock → auto-farm → loot loop fun enough to build a full game around?"**

Everything else is noise. Stay focused on answering that question as quickly and cheaply as possible.

## Resources

### Free Asset Sources
- OpenGameArt.org
- Kenney.nl (excellent free game assets)
- itch.io (search "free" + "2D assets")
- FreeSFX.co.uk (sound effects)

### Learning Resources
- Godot Docs: docs.godotengine.org
- Unity Learn: learn.unity.com
- Game Dev tutorials: YouTube (Brackeys, Sebastian Lague, HeartBeast)

### Community Support
- r/gamedev (Reddit)
- r/godot or r/unity3d
- Game Dev Discord servers
- itch.io community forums

---

## Start Here

**First Action Items:**
1. Read proof_of_concept.md completely
2. Choose your engine (Godot recommended)
3. Set up version control (Git)
4. Create project structure
5. Begin Phase 1: Combat Prototype

Remember: Simple, functional, and complete beats complex, beautiful, and unfinished.
