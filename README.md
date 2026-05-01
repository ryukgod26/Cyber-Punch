# Cyber Punch

A fast-paced beat-em-up game built with Godot Engine 4.5. Master your combat skills, defeat waves of enemies, and progress through multiple levels filled with action and challenges.

## Features

- **Diverse Combat System**
  - Multiple attack combos (Punch, Punch Alt, Kick, Round Kick)
  - Jump and jump kick mechanics
  - Throwable weapons (knives)
  - Knockback and knockdown effects
  - Combo-based attack progression

- **Enemy Variety**
  - Different enemy types: Goons, Punks, Thugs, Knife wielders, Gun users, and Boss encounters
  - AI-driven enemy behavior
  - Enemy slot management for tactical positioning

- **Multiple Stages**
  - Bar environment with doors and entrance areas
  - Street combat scenarios
  - Rail and background hazards
  - Progressive difficulty scaling

- **Polish & Immersion**
  - Retro pixel art graphics
  - Dynamic sound effects and music
  - Particle effects (sparks on impact)
  - Character shadows and depth
  - UI elements for score and health

## Controls

| Action | Key |
|--------|-----|
| Move Left | A / ← |
| Move Right | D / → |
| Move Up | W / ↑ |
| Move Down | S / ↓ |
| Attack | LMB / Action Button |
| Jump | Jump Button |

## Game Mechanics

### Character System
- **Health**: Each character has a health pool
- **Damage**: Attacks deal varying damage based on attack type
- **Knockback/Knockdown**: Strong attacks can knock enemies back or down
- **States**: Characters cycle through states (Idle, Walk, Attack, Jump, Hurt, Fall, etc.)
- **Animation**: State-driven animation system with combat combos

### Combat
- **Attack Combos**: String together different attacks for increased damage
- **Air Combat**: Jump attacks and aerial kicks for tactical positioning
- **Weapon System**: Collect and throw knives at enemies
- **Collision Detection**: Precise damage hitboxes for fair combat

### Enemy AI
- **Slot System**: Enemies are assigned to player-relative slots for organized encounters
- **Behavior**: Different enemy types with varied attack patterns
- **Difficulty**: Boss encounters with enhanced mechanics


## Technical Details

- **Engine**: Godot 4.5
- **Language**: GDScript
- **Graphics**: 2D Sprite-based (100x64 viewport, scaled 10x to 1000x640)
- **Physics**: CharacterBody2D with custom gravity and movement
- **Audio**: Integrated background music and sound effects
