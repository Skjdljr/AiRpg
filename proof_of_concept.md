# Roguelike ARPG - Proof of Concept
## Solo Developer Scope

---

## Overview

A minimal viable prototype that proves the core manual/auto-farm gameplay loop is fun. Strip away everything non-essential and focus on the unique hook: beat a floor manually, then let it farm while you're AFK.

**Target:** Playable prototype in 2-4 months as a solo dev.

---

## Core Features Only

### 1. Basic Real-Time Combat

**Movement:**
- Top-down view (like old Zelda or Binding of Isaac)
- WASD or arrow key movement
- Simple collision detection

**Combat:**
- **Auto-attack:** Click/hold button, character attacks nearest enemy
- **One Active Skill:** Single cooldown ability (example: AOE damage burst)
- **One Defensive Skill:** Escape/survival tool (example: dash or shield)
- Health bar, simple damage numbers

**Enemy AI:**
- Enemies chase player
- Simple melee attack when in range
- 2-3 enemy types maximum (different HP/damage values)

**No Need For:**
- Complex animations (stick figures or simple sprites work)
- Hit reactions/knockback
- Status effects
- Fancy VFX (colored circles for abilities is fine)

### 2. Minimal Character System

**Stats - Pick ONE Primary Stat:**
- **Attack Build:** High damage, low health
- **Tank Build:** Low damage, high health
- **Balanced Build:** Middle ground

That's it. No STR/DEX/INT/WIS/CHA. Just three presets to test if builds feel different.

**Skills:**
- Each build gets the same 2 skills (damage burst + dash/shield)
- Skills just scale with the build choice
- No skill tree, no customization yet

**Progression:**
- No leveling during a run
- Character is static after creation
- Focus on equipment, not XP

### 3. Death Saves (Simplified)

**Three Hearts: ♥ ♥ ♥**

**Death Penalties:**
- First death: Lose unequipped loot from that run
- Second death: Lose unequipped loot from that run
- Third death: Character deleted (permadeath)

**Restoration:**
- Restore all hearts when you manually beat a new floor

That's the entire system. No complexity needed for proof of concept.

### 4. Floor Structure (10 Floors Total)

**Keep It Small:**
- Floors 1-3: Easy (tutorial difficulty)
- Floors 4-7: Medium
- Floors 8-10: Hard

Each floor:
- Single rectangular room (no complex layouts)
- Spawn waves of enemies (Wave 1: 5 enemies, Wave 2: 8 enemies, Wave 3: Boss)
- Kill all enemies to complete floor
- 3-5 minutes per floor

**No procedural generation yet.** Fixed layouts are fine. Focus on the core loop.

### 5. Basic Loot System

**Three Rarity Tiers:**
- **Common (white):** +5-10 stats
- **Rare (blue):** +15-25 stats  
- **Legendary (gold):** +30-50 stats + maybe one special effect

**Gear Slots (Keep Minimal):**
- Weapon (affects damage)
- Armor (affects health)
- Accessory (affects cooldown reduction or movement speed)

**Drops:**
- Enemies drop loot on death (simple % chance)
- Click to pick up
- Auto-equip if better (or manual equip from inventory screen)

**No crafting, no socketing, no set bonuses.** Just basic "+damage" and "+health" items.

### 6. Auto-Farm System (The Core Innovation)

**Unlock Condition:**
- Beat a floor manually → that floor is now farmable

**Configuration (Keep Simple):**
- **Loot Filter:** "Pick up Rare or better" (just two options: "All" or "Rare+")
- **Behavior:** "Aggressive" or "Defensive" (just changes how close AI gets to enemies)

**AI During Auto-Farm:**
- Use damage skill on cooldown when enemies are grouped
- Use defensive skill when health < 30%
- Attack nearest enemy
- Pick up loot based on filter

**Bot Controls:**
- Start button
- Stop button
- That's it

**Results Screen (Post-Farm):**
- "Completed 12 runs"
- "Collected 8 items" (list them)
- "Died on run 13" (if applicable)

---

## What's CUT from Full Vision

**NOT in Proof of Concept:**
- ❌ Full DND stat system (STR/DEX/CON/etc.)
- ❌ Skill trees and feat selection
- ❌ Multiple character classes
- ❌ Advanced AI scripting (conditionals, priority lists)
- ❌ Leaderboards
- ❌ Seasonal content
- ❌ 30+ floors
- ❌ Complex legendary effects
- ❌ Heart Container legendary
- ❌ Procedural generation
- ❌ Meta-progression
- ❌ Multiple floor layouts
- ❌ Sound effects and music (can add later)
- ❌ Fancy UI and polish

**Why Cut These:**
Each of these is weeks or months of work. The goal is to prove the core loop is fun, not build the complete game.

---

## Development Phases

### Phase 1: Combat Prototype (Week 1-3)
**Goal:** Can I beat a single floor manually and does it feel okay?

- Player movement
- Basic attack
- One enemy type
- Simple health bars
- Floor completion detection

**Success Metric:** Fighting enemies for 3 minutes doesn't feel boring.

### Phase 2: Three Builds (Week 4)
**Goal:** Do different builds feel different?

- Add "Attack", "Tank", "Balanced" character creation
- Stat differences affect gameplay noticeably
- Test if tank feels tanky and attack feels glass-cannon

**Success Metric:** Playing tank vs attack feels like a different experience.

### Phase 3: Death Saves (Week 5)
**Goal:** Does the death penalty feel fair?

- Implement three hearts
- Death penalties (lose loot, then permadeath)
- Test emotional response to losing hearts

**Success Metric:** Losing a heart feels meaningful but not rage-inducing.

### Phase 4: Basic Loot (Week 6-7)
**Goal:** Is finding loot exciting?

- Three rarity tiers
- Enemies drop items
- Equip better gear
- Stats visibly improve

**Success Metric:** Getting a legendary drop feels good.

### Phase 5: Auto-Farm System (Week 8-10)
**Goal:** THE BIG TEST - Is the auto-farm loop fun?

- Unlock floors after manual completion
- Basic AI (attack nearest, use skills, survive)
- Loot filter (pick up rare+)
- Results screen

**Success Metric:** Setting bot to farm and coming back to loot feels satisfying.

### Phase 6: 10 Floors (Week 11-12)
**Goal:** Does progression across floors work?

- Create 10 floors with scaling difficulty
- Tune difficulty curve
- Balance loot drops

**Success Metric:** Reaching floor 10 feels like an achievement.

### Phase 7: Polish & Playtest (Week 13-16)
**Goal:** Is this fun enough to show people?

- Bug fixes
- Basic UI improvements
- Balance tuning
- Get feedback from friends

**Success Metric:** Someone plays for 2+ hours without you forcing them.

---

## Technical Simplifications

### Engine Choice
**Recommendation:** Use a beginner-friendly engine with good 2D support:
- **Godot:** Free, lightweight, great 2D tools, GDScript is easy
- **Unity:** More complex but tons of tutorials
- **GameMaker:** Specifically designed for 2D games

**Avoid:** Building your own engine. Use existing tools.

### Art Style
**Programmer Art is FINE for proof of concept:**
- Colored squares for characters
- Simple shapes for enemies
- Solid color backgrounds
- Free asset packs from itch.io

**Don't spend weeks on art.** Prove gameplay first.

### No Networking
**Everything runs locally:**
- No servers
- No online leaderboards
- No multiplayer
- Save data to local file

This cuts months of complexity.

---

## Success Criteria

### Proof of Concept is Successful If:

1. **The loop is addictive:** "Just one more floor before bed"
2. **Auto-farm works:** Coming back to loot feels rewarding
3. **Builds feel different:** Tank vs Attack plays noticeably different
4. **Death has stakes:** Losing hearts creates tension
5. **Someone else wants to play it:** External validation

### If Any of These Fail:
The full vision won't work either. Better to learn this in 3 months than 2 years.

---

## What Comes AFTER Proof of Concept

**If the prototype is fun, THEN expand:**
1. Add full stat system (STR/DEX/CON/etc.)
2. More skills and build variety
3. Advanced AI scripting for auto-farm
4. 30+ floors
5. Complex legendary items
6. Leaderboards
7. Polish and juice

**Don't expand until the core is proven fun.**

---

## Development Tips for Solo Dev

### Time Management
- **Work in short sprints:** 1-2 hour sessions
- **One feature at a time:** Don't parallelize
- **Playtest constantly:** Does this feel good right now?

### Scope Creep Prevention
- **Make a "Later" list:** Write down ideas but don't implement yet
- **Ask "Does this prove the concept?"** If no, it's not for the prototype
- **Embrace jank:** It doesn't need to be pretty

### Motivation Maintenance
- **Show progress weekly:** Tweet screenshots, tell friends
- **Celebrate milestones:** First enemy killed = huge win
- **Don't compare:** Your prototype vs a finished game isn't fair

### When to Pivot
If after Phase 5 (auto-farm system), it's not fun:
- **Don't give up immediately:** Try tweaking
- **Get external feedback:** Maybe you're wrong about it being unfun
- **Be willing to change direction:** Maybe manual-only is better?

---

## Minimum Viable Feature Set

To call this a "proof of concept," you need:

✅ Real-time combat with 2 skills
✅ Three character build options
✅ Death Saves system (3 hearts)
✅ 10 floors with difficulty scaling
✅ Basic loot (3 rarities)
✅ Manual floor completion unlocks auto-farm
✅ Auto-farm with simple AI
✅ Loot filter (basic)
✅ Results screen showing collected items

**That's it.** If you have these 9 things working, you've proven the concept.

---

## Proof of Concept Timeline

**Optimistic (Full-time work):** 3 months
**Realistic (Part-time, 10-15 hours/week):** 4-6 months
**Pessimistic (Life happens):** 6-12 months

**All timelines are valid.** Solo game dev takes longer than you think.

---

## Budget Estimate

**If you do everything yourself:**
- **Cost:** $0 (free engine, free assets, no contractors)
- **Time:** 200-300 hours of work

**If you buy some assets/tools:**
- **Cost:** $50-200 (asset packs, sound effects, tools)
- **Time:** 150-250 hours (less time making art)

---

## The Real Question

**After building this proof of concept, ask yourself:**

"Did I have fun making this?"
"Would I play this for 10+ hours?"
"Do other people want to play it?"

If yes to all three → expand to full game.
If no to any → either pivot or move on to a different project.

**The prototype's job is to answer these questions cheaply and quickly.**

---

## Final Thoughts

The full design document is the dream. This proof of concept is reality.

Build small, test the core loop, prove it's fun. Everything else is polish and expansion.

Most game projects fail because they try to build everything at once. Build the smallest possible version that tests your unique idea (manual → unlock → auto-farm loop) and iterate from there.

**You're not building a game yet. You're answering the question: "Is this idea fun?"**

Good luck! 🎮
