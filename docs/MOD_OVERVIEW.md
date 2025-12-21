# The Infection - Mod Overview

## Concept

"The Infection" is a total conversion mod for Project Zomboid that reimagines the survival experience as a timed, base-defense focused gameplay loop. Instead of immediately facing a zombie apocalypse, players begin in a seemingly normal world and must prepare for an inevitable catastrophic event.

## Gameplay Phases

### Phase 1: The Calm Before the Storm
**Duration**: Configurable (default: 7 in-game days)

During this phase:
- **No zombies spawn anywhere on the map**
- Players have free reign to explore cities and rural areas
- All loot is accessible without zombie interference
- Time is spent gathering resources, tools, and building materials
- Players establish their base location and begin fortification
- NPCs (if enabled) remain neutral or friendly

**Player Objectives**:
- Find an ideal base location
- Gather construction materials (wood, nails, tools)
- Collect food, water, and medical supplies
- Build walls, barricades, and defensive structures
- Stockpile ammunition and weapons
- Prepare for the siege

### Phase 2: The Infection Event
**Trigger**: After the countdown timer expires

When the Infection Event occurs:
- A dramatic in-game notification appears
- All friendly NPCs outside player walls become hostile
- Zombie spawning system activates globally
- Background music/sound changes to reflect the new threat
- Weather may change (optional: blood rain, fog)

### Phase 3: Survival Under Siege
**Duration**: Indefinite

Post-infection gameplay:
- **Hostile entities spawn continuously outside safe zones**
- Zombies and hostile NPCs actively seek player structures
- Entities bash against walls, doors, and barricades
- Players must repair and reinforce defenses
- Resource scarcity becomes critical
- Excursions outside walls are extremely dangerous
- Base defense becomes the primary gameplay focus

## Core Mechanics

### 1. Zombie Removal System

The mod completely disables vanilla zombie spawning until the Infection Event:

**Implementation Requirements**:
- Override PopulationMultiplier to 0 during Phase 1
- Disable ZombieRespawn mechanisms
- Remove any existing zombies from the map on mod initialization
- Create custom spawn controller that remains dormant until triggered

**Technical Approach**:
- Use Lua event hooks (`OnGameStart`, `OnZombieUpdate`)
- Implement a global flag tracking the Infection Event status
- Monitor and remove any zombies that spawn during Phase 1

### 2. Infection Event Timer

A countdown system that tracks time until the catastrophe:

**Features**:
- Configurable duration (hours, days, or weeks)
- UI element displaying time remaining (optional)
- Warning notifications at key intervals (3 days, 1 day, 6 hours, 1 hour)
- Persistent across save/load cycles
- Server-synchronized in multiplayer

**Technical Approach**:
- Use `Events.EveryTenMinutes` or `Events.EveryHours` for time tracking
- Store timer state in player ModData
- Create UI overlay using ISUIElement
- Broadcast timer state to all clients in multiplayer

### 3. Wall Defense System

Hostile entities actively target and attack player-built structures:

**Behavior Requirements**:
- Zombies and NPCs detect nearby player-built walls
- Entities path toward the nearest wall section
- Continuous bashing attacks on barricades, doors, and walls
- Progressive damage to structures based on entity count
- Alert system when walls are under attack

**Technical Approach**:
- Override or extend zombie AI pathfinding
- Implement proximity detection for player structures
- Create custom damage events for wall bashing
- Use sound and visual effects for attacks
- Track wall health and send player notifications

### 4. Safe Zone Definition

Areas within player walls remain protected:

**Mechanics**:
- Player-built walls define safe zone boundaries
- Entities cannot spawn within enclosed spaces
- Players must fully enclose their base for protection
- Gaps in walls allow entity penetration
- Multiple safe zones can be established

**Technical Approach**:
- Implement wall detection algorithm (ray casting or grid-based)
- Create polygon or bounding box system for enclosed areas
- Check spawn coordinates against safe zone boundaries
- Validate wall integrity (no gaps or breaks)

### 5. Hostile Entity Spawning

Mass spawning system activated during the Infection Event:

**Spawn Behavior**:
- Entities spawn in waves around player bases
- Spawn rate increases over time
- Different entity types (zombies, hostile NPCs) with varying abilities
- Spawn density based on difficulty settings
- No spawning within safe zones

**Technical Approach**:
- Use `getCell():spawnZombie(x, y, z)` for zombie creation
- Implement wave scheduling system
- Calculate spawn points around player structures
- Balance spawn rates for performance
- Create special infected variants for variety

## Configuration Options

### Mod Settings (Sandbox Options)

Players should be able to configure:

1. **Infection Timer Duration**
   - Preset options: 3 days, 7 days, 14 days, 30 days
   - Custom option: Set specific number of hours

2. **Pre-Infection Difficulty**
   - Resource availability
   - NPC hostility level
   - Building material abundance

3. **Post-Infection Difficulty**
   - Spawn rate multiplier
   - Entity aggression level
   - Wall damage multiplier
   - Wave intensity

4. **Safe Zone Rules**
   - Minimum wall height for protection
   - Wall material requirements
   - Gap tolerance (how large a gap before zone breaks)

5. **Victory Conditions**
   - Survive X days after infection
   - Defeat X waves of enemies
   - Escape to a rescue point
   - No victory condition (survival mode)

## Gameplay Balance

### Resource Management

**Pre-Infection**:
- Abundant resources encourage exploration
- Players must prioritize what to gather
- Weight management becomes crucial
- Multiple trips are necessary

**Post-Infection**:
- No new resources can be safely gathered
- Players survive on stockpiled supplies
- Rationing becomes critical
- Risk vs. reward for dangerous supply runs

### Base Building Strategy

**Location Considerations**:
- Proximity to resource-rich areas
- Defensible terrain (hills, narrow passages)
- Multiple exit routes vs. single chokepoint
- Access to water sources

**Construction Priorities**:
- Outer walls (primary defense)
- Barricaded windows and doors (backup defense)
- Storage areas for supplies
- Medical/workshop areas
- Escape routes

### Difficulty Curve

**Easy Mode**:
- 14+ day preparation time
- Slower spawn rates post-infection
- Weaker enemy attacks
- Longer wall durability

**Normal Mode**:
- 7 day preparation time
- Balanced spawn and attack rates
- Standard wall durability

**Hard Mode**:
- 3-5 day preparation time
- Rapid spawn rates
- Aggressive enemy behavior
- Reduced wall durability
- Special infected types

**Nightmare Mode**:
- 1-2 day preparation time
- Overwhelming spawn rates
- Extremely aggressive enemies
- Walls degrade quickly
- Multiple special infected
- No safe zone guarantees

## Multiplayer Considerations

### Cooperative Play

**Shared Responsibilities**:
- Divide gathering and building tasks
- Rotating guard duty during siege
- Specialized roles (builder, fighter, medic)
- Combined safe zones or separate bases

**Server Configuration**:
- Synchronized Infection Event timer
- Shared or individual safe zones
- PvP enabled/disabled during phases
- Resource sharing vs. competition

### PvP Elements (Optional)

**Pre-Infection PvP**:
- Competition for resources
- Sabotage of rival bases
- Territorial disputes

**Post-Infection PvP**:
- Raids on weakened bases
- Resource theft during repairs
- Temporary alliances against waves

## Technical Requirements

### Mod Dependencies

1. **Core Lua API**: Built-in Project Zomboid Lua support
2. **Events Plus API** (optional): For enhanced event handling
3. **Sandbox Options API**: For configuration interface

### Compatibility Considerations

**Compatible With**:
- Map mods (custom locations)
- Item/weapon mods
- Building/crafting mods
- UI enhancement mods

**Potential Conflicts**:
- Other zombie spawn override mods
- NPC behavior mods that conflict with infection mechanics
- Map mods that rely on zombie spawns for progression
- Total conversion mods with different gameplay loops

### Performance Optimization

**Considerations**:
- Limit maximum spawned entities at once
- Use spawn pooling/recycling
- Optimize wall detection algorithms
- Reduce check frequency for safe zones
- Efficient entity pathfinding

## Narrative Elements (Optional)

### Lore Integration

**Story Hook**:
- Radio broadcasts warning of "contamination"
- Military announcements about quarantine
- News reports of strange illness
- Evacuation warnings

**Environmental Storytelling**:
- Pre-placed notes about the infection
- Medical reports in hospitals
- Research documents in labs
- Government memos about containment failure

### Dynamic Events

**Pre-Infection Events**:
- Military helicopter patrols
- Emergency broadcasts
- NPC evacuation attempts
- Supply drops

**Post-Infection Events**:
- Rescue helicopter (false hope)
- Military airstrikes on infected zones
- Rival survivor groups seeking shelter
- Special infected boss encounters

## Future Expansion Ideas

1. **Rescue Missions**: Venture out to save NPCs and bring them to your base
2. **Research System**: Find cure components to delay or weaken the infection
3. **Faction System**: Allied survivor groups with trade and support
4. **Base Upgrades**: Advanced defenses (traps, automated turrets)
5. **Mutation System**: Infection evolves, creating new enemy types
6. **Evacuation Endgame**: Race to reach extraction point after X days
7. **Seasonal Events**: Different infection behaviors based on season
8. **Horde Mechanics**: Massive coordinated attacks at intervals

## Testing and Balancing

### Key Metrics to Monitor

1. **Survival Rate**: Percentage of players surviving to various time milestones
2. **Build Time**: How long players spend building vs. gathering
3. **Wall Durability**: How long defenses last against attacks
4. **Resource Consumption**: Rate of supply depletion
5. **Player Feedback**: Enjoyment, frustration points, difficulty perception

### Iterative Development

1. Start with basic infection timer and zombie removal
2. Add simple wall attacking behavior
3. Implement safe zones
4. Add wave spawning mechanics
5. Balance based on testing
6. Add polish and optional features

## Conclusion

"The Infection" transforms Project Zomboid from an open-world zombie survival game into a focused, timed base-defense experience. The two-phase gameplay loop creates natural tension and progression, while the wall-bashing mechanics provide a clear goal and challenge. With proper implementation and balancing, this mod offers a fresh take on the survival genre.
