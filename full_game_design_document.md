# Roguelike ARPG with Auto-Farm System
## Game Design Document

---

## High-Level Concept

A real-time action RPG roguelike that combines deep DND-style character building with automated farming mechanics inspired by Diablo 2 bot farming. Players manually conquer floors to unlock auto-farm capabilities, creating a hybrid active/idle gameplay loop.

### Core Inspiration
- **DND Character Building:** Deep stats, feats, and build possibilities
- **Diablo 2 Mephisto Farming:** The satisfaction of setting up a bot and returning to collected loot
- **Roguelike Progression:** Permanent death (with safeguards), increasing difficulty, risk/reward decisions

---

## Gameplay Loop

### The Hybrid Active/Idle Loop

**Phase 1: Manual Conquest**
1. Create/customize character with stats, skills, and equipment
2. Manually fight through a floor in real-time ARPG combat (3-5 minutes)
3. Defeat the floor/boss to "unlock" that floor for auto-farming
4. Death Saves restore to full upon successful completion

**Phase 2: Auto-Farm Configuration**
1. Configure loot filters ("Only pick up Epic+ items", "Prioritize DEX gear")
2. Set up AI behavior scripts (health thresholds, skill usage, combat stance)
3. Select which unlocked floor(s) to farm
4. Start the bot and walk away

**Phase 3: Return & Optimize**
1. Come back to see collected loot and run statistics
2. Equip upgrades, sell junk, assess build performance
3. Analyze what worked/what didn't based on bot performance
4. Decide: farm more for better gear, or push to the next floor?

**Phase 4: Push Deeper**
1. Use newly acquired gear to tackle the next challenging floor
2. Manually prove you can beat it
3. Unlock it for farming and repeat the cycle

### The Core Decision
At every stage: **Farm current floors for optimization, or risk pushing deeper for better loot?**

---

## Progression Structure

### Floor System

**Depth Tiers:**
- Floors 1-10: Easy (Tutorial/early game)
- Floors 11-20: Medium difficulty
- Floors 21-30: Hard
- Floors 31+: Expert/Endgame

Each tier introduces:
- Stronger enemies
- New enemy types
- Better loot (tier-exclusive items)
- Higher risk but higher reward

**Floor Duration:** 3-5 minutes per manual clear (adjustable based on playtesting)

**Depth-Gated Loot:**
- Certain legendary items only drop at specific depth ranges
- Creates incentive to push deeper vs. farming safe floors
- Example: Heart Container legendary only drops floors 20+

### Manual vs Auto-Farm

**Manual Play (Active):**
- Real-time ARPG combat
- Full player control
- Required to unlock each floor
- Restores Death Saves on completion
- Higher engagement, skill-based

**Auto-Farm (Idle/AFK):**
- AI-controlled combat using configured behavior scripts
- Only available on previously beaten floors
- Runs while player is away (at school, work, sleeping)
- Loot collection based on configured filters
- Progression without active play

---

## Death Saves System

### Core Concept
A tiered penalty system that provides meaningful consequences for death without the harshness of immediate permadeath. Players receive three chances before permanent character loss.

## Mechanic Overview

### Three Strike System
Players begin each character with **3 Death Saves** (represented as hearts: ♥ ♥ ♥)

**Strike 1 (First Death):**
- Lose all unequipped loot from current run
- Lose all gold from current run
- Character survives with 2 hearts remaining: ♥ ♥ 🖤

**Strike 2 (Second Death):**
- Lose all unequipped loot from current run
- Lose all gold from current run
- Lose experience points (level regression)
- Character survives with 1 heart remaining: ♥ 🖤 🖤

**Strike 3 (Third Death):**
- **Permadeath** - Character is permanently lost
- Must start a new character from scratch

### Restoration Mechanic
Death Saves are **restored to full (3 hearts)** when you:
- Manually complete a new floor for the first time
- Represents your character "proving themselves" to fate
- Rewards progression and skillful play

## Visual Representation
- **Full Health:** ♥ ♥ ♥
- **One Strike:** ♥ ♥ 🖤
- **Two Strikes:** ♥ 🖤 🖤
- **Final Chance:** ♥ (flashing/glowing to indicate danger)

Hearts displayed prominently in UI, similar to classic Zelda games for instant readability.

## Legendary Item: Extra Life

### Heart Container (working name)
- **Rarity:** Extremely rare legendary drop
- **Effect:** Permanently adds +1 maximum Death Save to character
- **Acquisition:** Only ONE can ever be equipped/active per character
- **Drop Location:** Only available on deeper floors (exact depth TBD)
- **Drop Rate:** Very low (~1-2% from elite/boss enemies)

### With Heart Container
- Starting hearts: ♥ ♥ ♥ ♥ (4 total)
- Provides extra safety for risky deep floor farming
- One of the most sought-after items in the game
- Non-stackable - finding additional copies has no effect

## Design Philosophy

### Why This System Works

**Forgiveness Without Trivialization:**
- First death is a warning shot - lose potential gains but keep your character
- Second death has real consequences (XP loss = regression)
- Third death is final - maintains tension and stakes

**Rewards Active Play:**
- Manual floor completion restores hearts
- Encourages players to push deeper rather than farm forever
- Creates rhythm: push → restore → farm → push again

**Strategic Depth:**
- Players must evaluate: "Can I safely auto-farm this floor with 1 heart left?"
- Heart Container becomes build-enabling: "Now I can farm floor 30 overnight"
- Risk/reward decisions at every stage

**Clear Communication:**
- Visual hearts = instant understanding of danger level
- No hidden mechanics or confusion
- Players always know exactly where they stand

## Integration with Auto-Farm

### Bot Behavior on Death
When auto-farming and character dies:
1. Bot immediately stops
2. All loot collected during that specific run is lost
3. Character retains all equipped gear
4. Death Save is consumed (heart turns black)
5. Player must manually restart bot or push to new floor

### Safety Configurations (Potential)
Players might configure bot settings:
- "Stop auto-farm if hearts ≤ 1" (safety mode)
- "Use health potion when HP < X%"
- Aggressive vs Defensive combat stances

## Future Considerations

### Possible Expansions
- Shrine events that restore 1 Death Save (rare, random encounter)
- Hardcore mode: 1 Death Save only, for ultimate challenge
- Daily/weekly challenges with modified Death Save rules
- Achievement for completing game without losing any Death Saves

### Items to Avoid
- No items that restore Death Saves on death (removes consequences)
- No stackable extra life items (would trivialize system)
- Heart Container remains unique and special

## Summary
The Death Saves system creates a perfect balance between the roguelike tradition of meaningful death and the reality that auto-farming with pure permadeath would be frustrating. It rewards skillful manual play, creates strategic decisions, and makes the rare Heart Container legendary one of the most exciting drops in the game.

---

## Character Building System

### DND-Inspired Depth
Character creation and progression honors the complexity and possibilities of DND character building.

**Core Stats (DND Style):**
- Strength (STR)
- Dexterity (DEX)
- Constitution (CON)
- Intelligence (INT)
- Wisdom (WIS)
- Charisma (CHA)

**Character Creation:**
- Allocate stat points at creation
- Choose starting class/archetype
- Select initial skills/abilities
- Initial feat selection

**Progression:**
- Gain experience and level up
- Unlock new skills and feats
- Discover build synergies
- Equipment further defines playstyle

### Build Diversity
No two runs should feel identical. Different combinations of stats, skills, feats, and equipment create vastly different playstyles:
- Tank builds (high CON, defensive skills)
- Glass cannon (high damage, low survivability)
- Caster builds (INT/WIS focused, mana management)
- Hybrid builds with unique synergies

---

## Combat System

### Real-Time ARPG Combat
Fast-paced action combat similar to Diablo, Path of Exile, or Torchlight.

**Manual Combat (Player-Controlled):**
- Real-time movement and positioning
- Basic auto-attack
- 2-4 active skills on cooldowns
- Resource management (mana/energy for skills)
- Dodge/movement abilities
- Potion usage

**Skill System:**
- **Cooldown-based skills:** Tactical timing, can't spam
- **Resource-based skills:** Mana/energy costs, requires management
- Both systems combined for depth

### Auto-Combat AI System

When auto-farming, the AI controls your character based on configured behavior scripts.

**Behavior Scripts (Conditional Logic):**
Players configure rules for the AI:
- "When HP < 30%, use Health Potion"
- "When HP < 40%, use Defensive Cooldown"
- "When mana > 80%, use [expensive AOE skill]"
- "When surrounded by 3+ enemies, use [AOE ability]"
- "When elite enemy appears, use [damage burst combo]"
- "Only use resurrection token if legendary item dropped this run"

**Combat Stance Settings:**
- **Aggressive:** Push into enemy packs, use AOE liberally, prioritize damage, take risks
- **Defensive:** Kite when hurt, save cooldowns for emergencies, focus single targets, play safe

**Advanced Scripting (Optional Complexity):**
- Priority system: numbered IF/THEN rules executed in order
- Target priority settings (elites > ranged enemies > nearest)
- Skill rotation builders
- Resource thresholds

**Why This Matters:**
Your character might have perfect stats and legendary gear but terrible AI configuration and die on floors they should easily farm. Optimizing the AI becomes part of the build theory-crafting.

**AI Debug Mode:**
Players can watch auto-combat in real-time (possibly 2x-4x speed) to identify AI mistakes and optimize scripts.

---

## Loot System

### ARPG-Style Itemization

**Item Rarity Tiers:**
- Common (white)
- Magic (blue)
- Rare (yellow)
- Epic (purple)
- Legendary (orange/gold)

**Loot Filters (Essential for Auto-Farm):**
Players configure what the bot picks up:
- "Only pick up Rare or better"
- "Ignore items below level 20"
- "Prioritize DEX gear for my build"
- "Auto-sell Common and Magic items"
- "Stop farming and alert me if Legendary drops"

**Depth-Gated Loot:**
Certain items only drop at specific floor ranges:
- Creates reason to push deeper
- Prevents early-game farming from getting endgame gear
- Example: Tier 3 legendaries only drop floors 25+

### Legendary Items

**Build-Defining Effects:**
Legendaries should dramatically change how you play, not just add stats:
- "Every 10th attack is a guaranteed critical strike"
- "Skills cost HP instead of mana" (life-tap builds)
- "Gain +5% damage per floor deeper, lose all stacks when hit"
- "Auto-revive once per floor at 1 HP (doesn't consume Death Save)"
- **Heart Container:** +1 maximum Death Save (unique, only one equippable)

**Legendary Chase:**
- Very rare drop rates (1-5% depending on legendary)
- Specific legendaries only drop in certain floor ranges
- Creates long-term goals and excitement
- Finding the "perfect" legendary for your build is endgame

---

## Risk/Reward Decisions

The game constantly presents meaningful choices:

### Farm vs Push
- **Farm:** Stay on safe floor, optimize gear, minimal risk
- **Push:** Tackle next floor, unlock new farming spot, risk Death Save

### Manual vs Auto
- **Manual:** Full control, safer, time investment required
- **Auto:** Hands-off, riskier (AI might fail), progress while AFK

### Aggressive vs Defensive AI
- **Aggressive:** Farm faster, more loot per hour, higher death risk
- **Defensive:** Slower farming, safer, preserve Death Saves

### Loot Filter Strictness
- **Strict (Legendary only):** Might farm all night and get nothing
- **Loose (Rare+):** Guaranteed loot, but mostly incremental upgrades

### Which Floors to Farm
- **Easy floors (10-15):** Safe, consistent, lower-tier loot
- **Hard floors (25-30):** Risky, better loot, might lose Death Save

---

## Technical Specifications

### Target Playstyle
- **Active sessions:** 30-60 minutes of manual floor pushing
- **AFK sessions:** Hours or overnight farming (4-12 hours)
- **Daily loop:** Push new floors actively, set up overnight farm, return to loot

### Development Scope

**Core MVP Features:**
- Real-time ARPG combat (basic implementation)
- 30+ floors with scaling difficulty
- Character stats and skill system
- Death Saves system
- Auto-farm with basic AI scripting
- Loot system with rarity tiers
- Loot filters

**Polish/Expansion Features:**
- Advanced AI scripting
- Dozens of unique legendary items
- Multiple character classes
- Detailed combat statistics/logs
- Meta-progression (unlockables between runs)
- Hardcore mode (1 Death Save only)

### Combat Feel (3-5 Minutes Per Floor)
- Quick enough for "one more floor" engagement
- Long enough to feel accomplished
- Matches Diablo 2 Mephisto run pacing
- Easy to estimate farming time (20 runs = ~1 hour)

---

## Player Experience Goals

### What Makes This Fun

**For Theory-Crafters:**
- Deep build customization
- Optimizing AI scripts for efficiency
- Finding gear synergies
- Pushing build limits

**For Idle Game Fans:**
- "Numbers go up" satisfaction
- Come back to piles of loot
- Progression while AFK
- Optimize and forget

**For ARPG Players:**
- Satisfying real-time combat
- Loot hunt and chase items
- Risk/reward floor pushing
- Build diversity and experimentation

**For Roguelike Fans:**
- Permanent death stakes (with Death Saves safety net)
- Procedural challenge
- Each run feels different
- Mastery through repeated attempts

### Emotional Beats

**Triumph:** Finally beating floor 25 manually after three attempts
**Excitement:** Coming back to find a legendary in your loot stash
**Relief:** Death Save triggers instead of permadeath
**Tension:** Pushing floor 30 with only 1 Death Save remaining
**Satisfaction:** Optimizing AI script and watching clear speed improve
**Loss:** Third death, character gone, time to theory-craft a new build

---

## Future Expansion Ideas

### Post-Launch Content
- Additional character classes
- More legendary items with unique mechanics
- Special challenge floors (boss rush, survival mode)
- Seasonal resets with special rules
- Co-op auto-farming (friends' bots team up)

### Meta-Progression Considerations
Currently pure roguelike (nothing carries over between characters). Could add:
- Account-wide legendary unlock system
- Starting item options for new characters
- Skill tree that persists across runs
- Achievement-based permanent bonuses

**Trade-off:** Meta-progression increases long-term retention but reduces individual run stakes. Consider carefully.

---

## Leaderboard System (Stretch Goal)

### Inspiration
Based on D2JSP's Ladder Slasher system - competitive rankings that showcase the community's best builds and deepest runs.

### Core Leaderboard Design

**Display Format:**
```
RANK | CHARACTER NAME | CLASS/BUILD | MAX DEPTH | DEATH SAVES | STATUS
-----|----------------|-------------|-----------|-------------|--------
1    | ShadowReaper   | DEX/Rogue   | Floor 47  | ♥♥🖤       | Active
2    | IronWall       | STR/Tank    | Floor 45  | ♥🖤🖤       | Active
3    | ArcaneStorm    | INT/Mage    | Floor 43  | 💀         | Dead
4    | SwiftBlade     | DEX/Fighter | Floor 42  | ♥♥♥♥      | Active
5    | BerserkerKing  | STR/Barb    | Floor 40  | ♥♥♥       | Active
```

**Information Displayed:**
- **Rank:** Position on global ladder
- **Character Name:** Player-chosen character name
- **Class/Build Type:** Shows primary stat focus and archetype
  - Examples: "DEX/Rogue", "STR/Tank", "INT/Mage", "STR/Fighter", "Hybrid"
- **Max Depth Reached:** Highest floor manually conquered
- **Current Death Saves:** Visual hearts showing remaining lives
  - Displays Heart Container bonus if equipped (4 hearts instead of 3)
- **Status:** Active (still alive) or Dead (permadeath)

### Why This System Works

**Build Diversity Showcase:**
- Seeing multiple build types in top 10 proves variety is viable
- "DEX/Fighter at #4 and STR/Tank at #2" shows different paths to success
- Encourages experimentation with different stat distributions

**Memorial to the Fallen:**
- Dead characters remain on leaderboard (grayed out or skull icon)
- Honors achievement even after permadeath
- Shows "this character made it to floor 43 before falling"

**Heart Container Prestige:**
- If someone displays 4 hearts, everyone knows they found the legendary
- Visual proof of rare item acquisition
- Additional bragging rights beyond just depth

**Community Competition:**
- Clear goals: "Can I beat #10's floor 38 record?"
- "Just one more floor" mentality to climb ranks
- Visible progression and achievement

### Additional Leaderboard Categories

**Secondary Rankings:**

1. **Fastest Floor Clear**
   - Speedrun-style competition
   - Shows character name, build, floor number, clear time
   - Encourages aggressive glass cannon builds

2. **Most Efficient Farmer**
   - Legendary items found per hour of auto-farming
   - Rewards optimization over pure depth
   - Shows who has the best loot-finding builds

3. **Longest Survival Streak**
   - Most consecutive floors cleared without losing a Death Save
   - Shows consistency and build reliability
   - Different skill than pure depth pushing

4. **Hardcore Ladder (Separate)**
   - Only for characters playing with 1 Death Save
   - Ultimate challenge mode
   - Elite bragging rights

**Class-Specific Ladders:**
- Top STR-focused builds
- Top DEX-focused builds
- Top INT-focused builds
- Top Hybrid builds
- Encourages trying different playstyles
- "Best in class" achievements

### Build Inspection Feature

**Click any leaderboard entry to view:**
- Complete stat distribution (STR/DEX/CON/INT/WIS/CHA)
- All equipped gear with rarities
- Active skill selections and feat choices
- AI behavior configuration (scripts and settings)
- Combat statistics (damage dealt, damage taken, kill count)
- "Clone this build" option to copy configuration

**Why This Matters:**
- Learning tool for new players
- Transparency shows what works
- Community knowledge sharing
- Validates successful strategies
- Reduces "how did they do that?" frustration

### Seasonal/Weekly Competition

**Ladder Resets:**
- Fresh seasonal starts (every 2-3 months)
- Everyone begins new characters simultaneously
- Race to the top creates excitement
- Old season records preserved in "Hall of Fame"

**Seasonal Modifiers (Optional):**
- "Season of Legends" - 2x legendary drop rate
- "Hardcore Season" - Everyone has 1 Death Save
- "Speed Season" - Bonus points for fast clears
- "Giant Slayer Season" - Bosses have 3x health but drop 3x loot
- Keeps gameplay fresh and rewards adaptation

**Weekly Challenges:**
- "This week: Reach floor 20 with DEX-only build"
- "Challenge: Beat floor 15 without using potions"
- Separate mini-leaderboard for challenge completion
- Rewards experimentation outside comfort zone

### Community Features

**Bragging Rights:**
- "#1 on Ladder" badge/icon next to character name in-game
- "Top 10" badges for ranks 2-10
- Shareable screenshots of leaderboard position
- Social media integration (optional)
- Build codes to share exact configurations

**Ghost Data / Replays (Advanced):**
- Watch recordings of top players' manual floor clears
- "How did ShadowReaper beat floor 47? Let me watch"
- Learn enemy patterns and tactics
- Study positioning and skill usage
- Optional: slow-motion analysis mode

**Build Sharing:**
- Generate shareable build code (text string)
- Import someone else's build instantly
- "Try the #1 ladder build yourself"
- Community theory-crafting forums
- Build guides and discussions

### Technical Implementation

**MVP (Minimum Viable Product):**
- Top 100 characters by max depth reached
- Display: Name, Build Type, Depth, Status (Active/Dead)
- Updates when character completes new floor
- Local leaderboard first (only your characters)

**Full Implementation (Stretch):**
- Server-based global leaderboard
- Real-time updates (or every 5-10 minutes)
- Anti-cheat verification (server-side run validation)
- Multiple leaderboard categories
- Build inspection system
- Seasonal resets
- Ghost data/replays

**Anti-Cheat Considerations:**
- Server validates floor completion
- Timestamp verification for speedruns
- Detect impossible stat combinations
- Report system for suspicious entries
- Manual review for top rankings

**Performance:**
- Cache leaderboard data
- Only fetch updates periodically
- Paginated results (show top 100, load more)
- Separate query for detailed build inspection

### Leaderboard Progression Example

**Week 1 (Early Season):**
```
1. QuickStrike   | DEX/Rogue   | Floor 15 | ♥♥♥  | Active
2. TankMaster    | STR/Tank    | Floor 14 | ♥♥🖤  | Active
3. FireMage      | INT/Mage    | Floor 13 | ♥♥♥  | Active
```

**Week 4 (Mid Season):**
```
1. ShadowReaper  | DEX/Rogue   | Floor 38 | ♥♥🖤  | Active
2. IronWall      | STR/Tank    | Floor 36 | ♥🖤🖤  | Active
3. ArcaneStorm   | INT/Mage    | Floor 34 | 💀   | Dead
```

**Week 12 (End Season):**
```
1. ShadowReaper  | DEX/Rogue   | Floor 47 | ♥♥🖤  | Active
2. LegendSlayer  | STR/Fighter | Floor 46 | ♥♥♥♥ | Active (Heart Container!)
3. VoidWalker    | INT/Mage    | Floor 45 | ♥♥♥  | Active
```

### Player Engagement Benefits

**Competitive Motivation:**
- "I can beat the #10 spot with a better build"
- Clear, measurable goals beyond personal progression
- Community recognition and status

**Build Discovery:**
- "I didn't know DEX/Fighter was viable at high floors"
- Inspecting top builds teaches strategy
- Meta evolves as players discover synergies

**Replayability:**
- New seasonal starts bring everyone back
- Weekly challenges provide short-term goals
- Multiple leaderboard categories = multiple ways to compete

**Community Formation:**
- Discussion around optimal builds
- Sharing strategies and tips
- Friendly rivalry and competition
- Social proof ("100 players are actively competing")

### Integration with Core Game

**Leaderboard Unlocks:**
- Reaches floor 10: Can view leaderboards
- Reaches floor 20: Character appears on leaderboards
- Reaches floor 30: Can inspect other builds
- Prevents spam/junk entries from tutorial players

**In-Game Visibility:**
- Main menu: "Leaderboards" button
- Post-floor completion: "You're now rank #47! (+3 spots)"
- Death screen: "Your character reached rank #23 before falling"
- Motivational messaging tied to ladder position

**No Pay-to-Win:**
- Leaderboards must be purely skill/time-based
- No purchasable advantages
- Integrity is critical for competitive respect

---

### Summary: Why Leaderboards Matter

The leaderboard system transforms the game from a solo experience into a competitive community activity. It provides:
- Long-term goals beyond individual progression
- Build diversity validation and discovery
- Community engagement and discussion
- Seasonal fresh starts for replayability
- Multiple ways to compete (depth, speed, efficiency)
- Learning tools through build inspection

Combined with the core manual/auto-farm loop and Death Saves system, leaderboards create the "just one more floor to climb the ladder" addiction that keeps players engaged long-term.

**Implementation Priority:** This is a stretch goal for good reason - get the core game loop solid first, then add competitive features once the foundation is fun and stable.

---

## Design Pillars

1. **Respect Player Time:** Auto-farm lets you progress while living your life
2. **Meaningful Choices:** Every decision (farm/push, aggressive/defensive, gear) matters
3. **Build Depth:** Honor DND's character-building complexity
4. **Fair Consequences:** Death Saves provide safety net without removing stakes
5. **Satisfying Progression:** Both manual play and AFK farming feel rewarding

---

## Conclusion

This game blends the best elements of DND character building, ARPG loot hunting, roguelike permadeath stakes, and idle game satisfaction. The manual/auto-farm hybrid creates a unique gameplay loop that respects both active and passive playstyles, while the Death Saves system ensures meaningful consequences without frustrating permadeath on every mistake.

The core question driving all design: "Can my build handle the next floor, or should I farm longer?" Everything else supports this central tension.
