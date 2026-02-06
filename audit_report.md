# Code Audit Report - Roguelike ARPG Project

**Audit Date:** February 6, 2026
**Scope:** Complete review of `scripts/` directory for POC compatibility
**Target:** Proof of Concept Phase 1 (Combat Prototype)

---

## Executive Summary

The project has **solid foundational work** with working movement, combat, and a component system already in place. The floating damage numbers system (critical feature) is implemented and functional. However, the spell system is over-engineered for POC needs, and several systems need either simplification or replacement.

**Recommendation:** Use Option A (Refactor Existing Code) - the foundation is good enough to build on. Focus on simplifying complexity rather than rebuilding from scratch.

---

## I. WHAT EXISTS ALREADY

### ✅ Core Gameplay Mechanics (Working)

| Feature | File | Status | Details |
|---------|------|--------|---------|
| **Player Movement** | `player.gd` | ✅ Working | WASD/arrows work, CharacterBody2D, collision-ready |
| **Health System** | `health_component.gd` | ✅ Solid | Tracks HP, emits damage signal, handles death |
| **Damage Numbers** | `floating_text_component.gd` | ✅ CRITICAL | Shows damage text above enemies, pre-configured |
| **Enemy AI (Basic)** | `mob.gd` | ✅ Functional | State machine (IDLE→CHASING→ATTACKING→RETURN), chases player |
| **Enemy AI (Advanced)** | `lizardAi.gd` | ⚠️ Has Issues | More complex state management, but velocity bugs |
| **Projectile System** | `directSpell.gd` | ✅ Works | Shoots projectiles that track and damage enemies |
| **Hit Detection** | `HitBoxComponent.gd` | ✅ Works | Area2D-based damage integration with health component |
| **Target Selection** | `globals.gd` | ✅ Functional | Can select/highlight nearest enemy with shader |
| **Loot Pickup** | `pickup.gd` | ✅ Basic | Items can be picked up from scene |

### ✅ Component System

Already using component-based architecture:
- `health_component.gd` - Health/damage
- `HitBoxComponent.gd` - Collision detection
- `floating_text_component.gd` - Damage display
- `mana_component.gd` - Mana tracking
- `velocity_component.gd` - Velocity handling (incomplete)
- `single_target_component.gd` - Single target (stub)
- `multi_target_component.gd` - Multiple targets (stub)
- `selectable_component.gd` - Selection highlighting (incomplete)

### ✅ Effect/Spell Framework

- `BaseEffect.gd` - Effect base class
- `DirectDamageEffect.gd` - Direct damage effect (skeleton)
- `DotEffect.gd` - Damage over time (skeleton)
- `SlowEffect.gd` - Slow effect (skeleton)
- `RootEffect.gd` - Root effect (skeleton)
- `EffectManager.gd` - Effect application manager (skeleton)

### ✅ Data Structures

- `Item.gd` - Item resource system with icons and scenes
- Basic pickup system for loot

---

## II. WHAT CAN BE REUSED

### 🟢 MUST KEEP (Already Required by POC)

| Component | Why | Effort |
|-----------|-----|--------|
| `floating_text_component.gd` | **Required feature** - damage numbers are core to feedback | Keep as-is |
| `health_component.gd` | Already works, no need to rebuild | Keep as-is |
| `HitBoxComponent.gd` | Simple, functional collision detection | Keep as-is |
| `Item.gd` resource system | Foundation for loot system | Keep, extend with stats |

### 🟡 SHOULD REUSE (With Possible Tweaks)

| Component | Current State | POC Usage |
|-----------|---------------|-----------|
| `player.gd` | Basic movement works | Use as-is for Phase 1 |
| `mob.gd` | State machine functional | Simplify slightly, use for basic enemies |
| `directSpell.gd` | Projectile tracking works | Convert to skill-based cooldown system |
| Target selection | Works with shader outline | Use for "current enemy" feedback |
| `pickup.gd` | Basic pickup works | Extend with auto-equip logic |

### 🟡 COULD REUSE (With Modifications)

| Component | Issue | MOD Required |
|-----------|-------|---------|
| `lizardAi.gd` | More complex, has velocity bugs | Simplify or use `mob.gd` instead |
| `mana_component.gd` | exists but not needed | Remove in favor of cooldown system |
| Effect system | Skeletons, not implemented | Will need actual implementation |

---

## III. WHAT SHOULD BE SIMPLIFIED OR REMOVED

### 🔴 Too Complex for POC, Can Be Simplified

| System | Current | Problem | Simplification |
|--------|---------|---------|-----------------|
| **Spell System** | `spell.gd`, `directSpell.gd`, `aoe_spell.gd` | Over-engineered, multiple classes | Replace with 2 simple skills with cooldowns |
| **Effect System** | `BaseEffect.gd` + 5 effect types | Only skeletons, never fully implemented | Implement only DirectDamage, skip DoT/Slow/Root for POC |
| **Targeting** | `single_target_component.gd`, `multi_target_component.gd` | Not used, just stubs | Remove these; use simple "attack nearest" |
| **Mana System** | `mana_component.gd` complete | Not needed for POC | Remove, replace with cooldown-only system |
| **Velocity Component** | `velocity_component.gd` | Incomplete/unused | Remove; Godot's CharacterBody2D handles velocity |

### 🔴 Can Be Removed Entirely

| File | Reason |
|------|--------|
| `single_target_component.gd` | Just a stub, not used |
| `multi_target_component.gd` | Just a stub, not used |
| `selectable_component.gd` | Incomplete, can use globals.gd selection instead |
| `velocity_component.gd` | Incomplete, built-in velocity works better |
| `mana_component.gd` | Not needed if using cooldown system |
| `EffectManager.gd` | Can inline effect logic into spells |
| `DotEffect.gd`, `SlowEffect.gd`, `RootEffect.gd` | Push to Phase 2+, POC doesn't need these |

---

## IV. CURRENT ISSUES & RED FLAGS

### 🔴 Critical Issues

| Issue | Severity | Location | Impact |
|-------|----------|----------|--------|
| **lizardAi.gd movement broken** | HIGH | `pursue_target()`, `return_to_spawn()` | Enemies don't move properly - velocity set but `move_and_slide()` called with no velocity assignment |
| **No floor management** | HIGH | N/A | No way to spawn waves, track completion, scale difficulty |
| **No character creation** | HIGH | N/A | No way to select Attack/Tank/Balanced builds |
| **No death saves system** | HIGH | N/A | No permadeath mechanics or heart tracking |
| **No loot equipping** | HIGH | N/A | Items drop but no stat application system |
| **No auto-farm AI** | HIGH | N/A | Core feature missing entirely |
| **No save/load system** | HIGH | N/A | No persistence for runs or character data |

### 🟡 Medium Issues

| Issue | Severity | Location | Impact |
|-------|----------|----------|--------|
| **Spell casting incomplete** | MEDIUM | `SpellSystem.gd` | Can shoot projectiles but no cooldown/mana integration |
| **Effect system skeleton** | MEDIUM | `effects/` | Only DirectDamage has partial implementation |
| **No damage scaling** | MEDIUM | Various | Damage is hardcoded, no stat interaction |
| **Attack animation missing** | MEDIUM | `player.gd` | Only has movement animations |

### 🟢 Minor Issues

| Issue | Severity | Location | Impact |
|-------|----------|----------|--------|
| Shader material loading path | LOW | `globals.gd` | Works but could be cleaner |
| Some debug prints left in code | LOW | Multiple files | Won't break anything, just clutter |
| Incomplete method implementations | LOW | Several effects | Won't affect POC Phase 1 |

---

## V. TRANSITION PLAN: CURRENT → POC PHASE 1

### Step 1: Code Cleanup (Day 1)

**Remove these files entirely:**
```
scripts/components/
  ❌ single_target_component.gd
  ❌ multi_target_component.gd  
  ❌ selectable_component.gd
  ❌ velocity_component.gd

scripts/effects/
  ❌ DotEffect.gd
  ❌ SlowEffect.gd
  ❌ RootEffect.gd

scripts/spells/
  ❌ aoe_spell.gd
  ❌ spell_life.gd
  ❌ EffectManager.gd

scripts/
  ❌ mana_component.gd
```

**Keep but don't use yet:**
```
scripts/effects/
  ⏸️ DirectDamageEffect.gd (will use later when needed)
```

### Step 2: Fix lizardAi.gd (Day 1)

**Issue:** Movement doesn't work. The `pursue_target()` and `return_to_spawn()` functions set `direction` but don't assign it to `velocity`.

**Fix:** Either
- **Option A:** Fix the bugs (5 min)
- **Option B:** Delete it and use `mob.gd` instead (simpler, already works)

**Recommendation:** Option B - `mob.gd` is simpler and functional.

### Step 3: Simplify Spell System (Days 2-3)

**Current:** 3 spell classes with incomplete effects system  
**Target:** 2 hardcoded skills with cooldowns

**DO NOT REBUILD** - just adapt existing:
1. Keep `directSpell.gd` projectile for now
2. Create simple `SkillManager.gd` or add to `player.gd`:
   - Skill 1: 5-second cooldown AOE damage
   - Skill 2: 8-second cooldown dash/shield
3. Remove `spell.gd` base class
4. Remove complex spell interactions
5. Hardcode damage values

### Step 4: Create Missing Systems (Days 4-7)

Required for Phase 1:

**New file: `FloorManager.gd`**
- Spawn enemy waves
- Track completion
- Difficulty scaling

**New file: `CharacterStats.gd`**
- Attack/Tank/Balanced presets
- Applies stat modifiers to player

**Modify `health_component.gd`**
- Already works, just ensure enemy health scales by floor

**Update `player.gd`**
- Add skill cooldown tracking
- Add skill input handling (Q, E keys)

---

## VI. SOURCE CODE QUALITY ASSESSMENT

### Code Organization: 3/5
- ✅ Component-based architecture is solid
- ❌ Too many half-baked systems (effects, targeting, spells)
- ❌ No clear separation between game logic and UI

### Code Readability: 3/5
- ✅ Variable names are mostly clear
- ✅ Comments exist where needed
- ❌ Some incomplete methods left in (confusing)
- ❌ Multiple debug print statements

### Architecture: 3/5
- ✅ Component system is the right approach
- ❌ Spell/Effect system is over-engineered
- ❌ No clear data flow for stats/damage

### Test Coverage: 0/5
- ❌ No tests present
- For POC: Not required

---

## VII. FEATURE COMPLETENESS MATRIX

| Feature | Current | POC Needs | Ready? |
|---------|---------|-----------|--------|
| Player movement | ✅ | ✅ | Yes, use as-is |
| Basic attack | ⏸️ Partial | ✅ | Needs cooldown system |
| 2 Skills | ❌ | ✅ | Must create |
| Enemy chase AI | ✅ | ✅ | Yes (`mob.gd` works) |
| Health bars | ⏸️ Partial | ✅ | Already in component |
| Damage numbers | ✅ | ✅ | KEEP THIS |
| Floor waves | ❌ | ✅ | Must create |
| Floor progression | ❌ | ✅ | Must create |
| 3 builds | ❌ | ✅ | Must create |
| Death saves | ❌ | ✅ | Must create |
| Loot drops | ⏸️ Skeleton | ✅ | Item pickup exists, needs equipping |
| Equip system | ❌ | ✅ | Must create |
| Auto-farm AI | ❌ | ✅ | Must create |
| Game save/load | ❌ | ✅ | Must create |

---

## VIII. EFFORT ESTIMATES

### Keep/Reuse (Hours)
- `floating_text_component.gd` - 0h (use as-is)
- `health_component.gd` - 0h (use as-is)
- `player.gd` movement - 0h (use as-is)
- `mob.gd` for enemies - 0h (use as-is)
- Basic pickup system - 1h (minor extension)

### Simplify/Fix (Hours)
- Remove unused components - 0.5h
- Fix/simplify projectile system - 1h
- Create skill cooldown system - 2h

### Must Create (Hours)
- FloorManager (waves, progression) - 3h
- CharacterStats (build system) - 2h
- DeathSaves system - 2h
- Loot equipping UI - 3h
- Auto-farm AI controller - 5h
- Save/load system - 2h

**Total Effort:** ~21.5 hours → ~3 weeks for solo dev (realistic)

---

## IX. RECOMMENDATIONS FOR PHASE 1

### ✅ DO THIS

1. **Keep the foundation:** Player movement, mob AI, health system, floating text all work
2. **Delete unnecessary code:** These stub components are just clutter (remove 8 files)
3. **Simplify spells:** Replace complex system with 2 hardcoded skills with cooldowns
4. **Create FloorManager:** Manage spawning, waves, difficulty progression  
5. **Add build system:** Attack/Tank/Balanced stat presets
6. **Implement core loop:** Manual combat → floor completion → next floor

### ❌ DON'T DO THIS

1. Don't rebuild movement or health system (already works)
2. Don't implement DoT/Slow/Root effects (remove them for POC)
3. Don't build advanced targeting systems (use simple "nearest enemy")
4. Don't implement mana system (use cooldowns instead)
5. Don't overengineer the skill system (hardcode 2 skills)

### ⏸️ DEFER TO PHASE 2+

- Advanced effect system
- Multiple enemy types/variants
- Procedural generation
- Skill trees
- Full DND stat system
- Advanced AI scripting

---

## X. SUMMARY SCORECARD

| Aspect | Score | Notes |
|--------|-------|-------|
| Code Reusability | 6/10 | Good foundation, too much scope creep |
| Architecture | 6/10 | Component system is right, but effects are over-engineered |
| Phase 1 Readiness | 5/10 | 50% of needed features exist, 50% need creation |
| Technical Debt | 6/10 | Some dead code, mostly manageable |
| Complexity | 4/10 | Artifact system is too complex for POC |

---

## XI. ACTION ITEMS - PRIORITIZED

### Priority 1 (Do First)
- [ ] Review this audit report  
- [ ] Decide: Keep/modify lizardAi or use mob.gd?
- [ ] Delete stub components (1 hour)

### Priority 2 (Foundation)
- [ ] Create FloorManager.gd for wave spawning
- [ ] Create CharacterStats.gd for build presets
- [ ] Add skill cooldown system to player.gd

### Priority 3 (Core Systems)
- [ ] Implement loot equipping system
- [ ] Add death saves tracking
- [ ] Create save/load for character data

### Priority 4 (Auto-Farm)
- [ ] Create AutoFarmAI controller
- [ ] Implement configuration UI
- [ ] Results screen

---

## FINAL ASSESSMENT

**Overall:** The project is at **50% readiness for Phase 1**. The foundation is solid but loaded with over-engineered systems that need to be simplified or removed. The good news: none of the core mechanics need to be rebuilt, just refactored.

**Path Forward:** Use Option A (Refactor) - adapt existing code rather than rebuild. Focus on simplification and adding the missing systems. Estimated **3-4 weeks** from this point to Phase 1 completion.

**Risk Level:** LOW - The core systems work. Just need to clean up dead code and add missing features.
