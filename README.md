# FLORIPPLE# MASTER DEVELOPMENT PROMPT
# BLOOM GARDEN — PREMIUM ANDROID CASUAL PUZZLE GAME

**Project Type:** Complete Android Game Development  
**Project Name:** Bloom Garden  
**Genre:** Casual Strategy / Living Garden Puzzle / Endless Score Puzzle  
**Primary Platform:** Android Smartphones  
**Orientation:** Portrait  
**Primary Interaction:** Single-finger touch  
**Visual Quality:** Premium 2.5D Cartoon / Glossy 3D-Look / HDR Glow / Colorful Fantasy Garden  
**Primary Gameplay:** Bloom Pulse + Bloom Echo + Chain Reaction  
**Development Goal:** Fully playable, production-quality Android game—not a prototype, slideshow, static mockup, or UI-only implementation.

---

# 1. PROJECT MISSION

You are acting as a highly experienced game development team consisting of:

- Senior Android Game Developer
- Professional Gameplay Systems Designer
- Game Economy and Balance Designer
- Premium Mobile Game UI/UX Designer
- 2D/2.5D Game Artist
- Shader and Visual Effects Developer
- Animation Designer
- Sound and Haptic Feedback Designer
- Performance Optimization Engineer
- Android Release Engineer
- Software Testing and QA Engineer

Your responsibility is to design, implement, optimize, test, and complete a premium casual Android puzzle game named **Bloom Garden**.

The game must feel like a high-quality commercial mobile game from the first launch.

It must have exceptionally attractive graphics, simple controls, intelligent puzzle mechanics, satisfying flower-growth animations, strategic depth, and strong long-term replayability.

The game must be extremely easy to understand but progressively difficult to master.

The player should be able to learn the fundamental gameplay within approximately 30 seconds.

However, understanding the basic controls must not guarantee mastery.

The player should gradually discover deeper strategies involving plant placement, growth timing, flower matching, water propagation, and chain reactions.

The gameplay must be original in its execution and must not merely reproduce a conventional Match-3 game.

The primary objective is to deliver a relaxing but strategically engaging puzzle experience.

**The most important product principle:**

Every successful player action must create an immediate, visible, satisfying consequence on the garden board.

Never sacrifice gameplay correctness for visual effects.

Never sacrifice visual quality unnecessarily for implementation convenience.

Gameplay logic and visual presentation must work together.

---

# 2. STRICT BRAND IDENTITY

The game must be developed as a completely independent intellectual property.

Official working title:

**BLOOM GARDEN**

Brand identity:

- Flowers
- Gardens
- Growth
- Water
- Blooming
- Nature
- Colorful puzzle gameplay
- Magical garden energy

Strictly prohibited branding and assets:

- No panda.
- No animal mascot.
- No paw symbol.
- No Paws branding.
- No Ludo Paws branding.
- No animal characters.
- No unrelated animated characters.
- No references to any existing game project.
- No animal-based rewards, currencies, or icons.
- No reuse of another game's logo or identity.

Do not create or modify another game's repository.

If an existing Bloom Garden repository is provided, inspect and preserve its architecture where appropriate.

Otherwise, create a clean, independent project.

The garden itself must be the game's visual personality.

The flowers, water, soil, leaves, glowing energy, and beautiful environments must make the game recognizable.

---

# 3. VISUAL REFERENCE — EXTREMELY IMPORTANT

Use the final Bloom Garden gameplay reference image supplied in the conversation as the primary visual-art reference.

The user expects the actual implemented game to closely resemble the visual richness of that reference.

Do not treat the reference image merely as rough inspiration.

Recreate its recognizable artistic qualities using proper independent game assets.

## Required visual characteristics

Create a beautiful garden-themed environment featuring:

- Bright, colorful blue sky.
- Soft white clouds.
- Warm sunlight.
- Beautiful greenery.
- Highly detailed leaves and foliage.
- Small garden flowers.
- A soft-focus cottage or garden structure in the background.
- Richly saturated but carefully balanced colors.
- A premium wooden garden board.
- Deep brown soil cells.
- Soft, rounded tile edges.
- Glossy flower petals.
- Three-dimensional-looking buds.
- High-quality highlights and shadows.
- Soft ambient lighting.
- Convincing material depth.
- Gentle depth-of-field-style background separation.
- Clean and carefully spaced UI components.
- Bright blue magical water energy.
- Golden bloom explosions.
- Attractive particle effects.

The game should look like a professionally illustrated, polished mobile title.

Avoid:

- Flat programmer-style rectangles.
- Plain colored circles representing flowers.
- Emoji as final production artwork.
- Generic unstyled buttons.
- Low-resolution blurry assets.
- Excessive text.
- Randomly placed decorations.
- Artificial-looking clutter.
- A screenshot used as a static full-screen game background.

The final implementation must contain independently controllable graphical layers.

The reference image is a visual target, not a replacement for real gameplay rendering.

All flowers, cells, particles, UI elements, and controls must be separately rendered and interactive.

---

# 4. RECOMMENDED TECHNOLOGY STACK

If no existing game engine has been established, prefer a stable Godot 4.x release with GDScript for this project.

The implementation should prioritize:

- High-quality 2D/2.5D rendering.
- Android compatibility.
- Responsive portrait layouts.
- GPU-accelerated rendering.
- Efficient particle effects.
- Modular gameplay logic.
- Fast application startup.
- Offline operation.
- Android App Bundle export.
- Clean, maintainable source code.

Use a rendering configuration appropriate for Android devices.

Implement scalable lighting and glow quality.

Where practical, use Godot's supported HDR 2D and glow features for capable devices.

Provide optimized alternatives for low-end Android phones.

Do not make heavy HDR post-processing a mandatory requirement for every device.

Do not change an established project engine without a compelling, documented technical reason.

Do not introduce unnecessary online backend services.

The game's essential gameplay must work completely offline.

---

# 5. CORE GAME CONCEPT

Bloom Garden is a strategic living-garden puzzle.

The player plants colored flower seeds into empty soil cells.

Every successful planting action releases a magical water pulse across the corresponding row and column.

Existing plants touched by that pulse advance through their growth cycle.

When three or more fully bloomed flowers of the same species form a continuous horizontal or vertical line, those flowers bloom together and disappear.

The cleared cells become available for new seeds.

The player earns points for blooming flowers, creating combinations, and producing chain reactions.

Cleared locations temporarily retain magical Bloom Echo energy.

Planting on a Bloom Echo location creates an extra growth pulse.

The board evolves continuously.

The player must plan where to plant, which species to plant, when to accelerate particular flowers, and how to prevent the garden from becoming overcrowded.

This is not a traditional swap-based Match-3 game.

The player must never drag flowers to exchange positions.

Instead, the player manipulates the garden's growth timing through strategic seed placement.

**Central gameplay identity:**

Plant a seed. Control growth. Create blooms. Trigger combinations. Keep the garden alive.

---

# 6. EXACT BOARD CONFIGURATION

The standard gameplay board must contain exactly:

**6 columns × 6 rows = 36 cells.**

Use a consistent coordinate system:

- Row indices: 0 through 5.
- Column indices: 0 through 5.
- The top-left cell is (0,0).
- The bottom-right cell is (5,5).

Every cell must have a stable logical coordinate independent of screen dimensions.

A cell can contain:

1. Empty soil.
2. A growing plant.
3. A fully bloomed flower.
4. An obstacle, only in modes supporting obstacles.

Bloom Echo is a temporary ground effect, not a separate blocking occupant.

A cell can be empty while simultaneously having Bloom Echo energy.

The board must be data-driven.

Do not represent gameplay state by checking the rendered sprite color or visual texture.

The gameplay model must be authoritative.

### Visual board requirements

Every cell must have:

- A clearly defined touch area.
- Rounded square styling.
- Premium soil texture.
- Consistent spacing.
- Soft lighting and shadow.
- Clear empty/occupied state.
- Visible growth stage.
- Optional selection effect.
- Optional water pulse overlay.
- Optional Bloom Echo overlay.

Touch input must map accurately to cell coordinates on different Android screen sizes.

No overlapping invisible hitboxes.

No accidental touches outside the board.

---

# 7. PLANT SPECIES SYSTEM

Begin with three standard flower species:

**Green Bloom**

- Green-themed seed icon.
- Fresh green growth visuals.
- Lime-green mature flower.
- Soft green particle accents.

**Pink Bloom**

- Pink-themed seed icon.
- Pink-colored bud.
- Beautiful mature pink flower.
- Pink petals and golden highlights.

**Blue Bloom**

- Blue-themed seed icon.
- Blue-colored bud.
- Beautiful mature blue flower.
- Cyan and blue particle effects.

An additional Golden Bloom species may be introduced later in advanced levels or advanced game modes.

Do not introduce Golden Bloom into the basic tutorial.

Do not show a flower species on a board unless that species is supported by the active mode and seed generation configuration.

### Species consistency

Each plant must retain its species throughout its entire lifecycle.

Example:

Pink seed → Pink bud → Pink flower.

Never allow a blue seed to turn into a pink flower due to an animation or state-management error.

At the seedling stage, where many plants naturally appear green, include a subtle species-colored base, rim, or visual accent.

The player must always be able to distinguish the plant species without guessing.

---

# 8. EXACT PLANT GROWTH LOGIC

Each plant has exactly three core growth stages.

**Stage 0 — Seedling**

Visual representation:

- Tiny green sprout.
- Two small leaves.
- A little mound of soil.
- Species-colored identification detail.

**Stage 1 — Bud**

Visual representation:

- Larger plant.
- Colored closed flower bud.
- More developed leaves.
- Subtle growth glow.

**Stage 2 — Mature Flower**

Visual representation:

- Fully bloomed flower.
- Bright, glossy petals.
- Species-specific colors.
- Soft idle animation.
- Ready to participate in matching.

The state progression is:

`SEEDLING → BUD → BLOOM`

A growth event advances a plant by one stage.

Stage 0 becomes Stage 1.

Stage 1 becomes Stage 2.

Stage 2 remains Stage 2 unless removed by matching.

Do not advance a plant through multiple stages during one ordinary growth pulse.

Multiple distinct pulse or chain-growth events within one successful move may advance it further, according to the rules below.

Do not randomly accelerate or delay individual plants.

Growth must be deterministic and based on valid gameplay events.

---

# 9. SEED TRAY AND INPUT SYSTEM

The player receives a visible tray containing three seed choices.

In the standard game:

- Seed slot 1.
- Seed slot 2.
- Seed slot 3.

Each slot contains one available seed card.

Each card identifies its species clearly.

The player may select any available card.

After selecting a seed, the player taps an empty soil cell to plant it.

The selected card must have a bright, premium selection glow.

Initially, one card should be automatically selected to reduce unnecessary taps.

The player must be able to change the selection at any time before placement.

### Seed card rules

A planted card is consumed.

Do not immediately refill an individual slot.

When all three cards in the current batch have been used, generate the next three-card batch.

This creates meaningful planning decisions.

A batch may contain repeated species, but generation must obey configurable balancing constraints.

For the standard three-species mode:

- Every new batch should contain at least two distinct species.
- Do not generate endless identical batches.
- Use a deterministic seeded random generator.
- Never secretly alter the seed batch after the player has seen it.

The actual color of the seed card must match the plant that will be planted.

The tray must never display a fake seed icon that produces a different species.

### Invalid actions

Tapping an occupied cell must not consume a seed.

Tapping outside the board must not consume a seed.

Tapping while the game is paused must not consume a seed.

Tapping during a locked move-resolution sequence must not cause duplicate placements.

Invalid actions must not decrement the remaining moves in Level Mode.

---

# 10. EXACT BLOOM PULSE MECHANIC

Bloom Pulse is the most important gameplay mechanic.

Whenever the player successfully plants a seed, a water-energy pulse is emitted from the planted cell.

The water spreads across:

- The entire corresponding row.
- The entire corresponding column.

On a standard 6×6 board without obstacles, the pulse covers 11 unique cells, including its origin.

The pulse must not affect any cell twice simply because it belongs to both the row and the column.

### Example

If the player plants at:

`row = 3, column = 2`

The pulse affects:

- Every cell where row = 3.
- Every cell where column = 2.

The pulse appears as a luminous blue cross.

### Growth effect

All existing immature plants touched by the pulse grow by one stage.

Fully bloomed flowers remain mature.

The newly planted seedling does not grow from the ordinary pulse it created.

This exclusion applies only to the primary pulse of that planting action.

Therefore, planting a seed normally results in a Stage 0 seedling.

The player must use future pulses, special growth effects, or Bloom Echo to accelerate it.

### Visual behavior

Upon placement:

1. The seed appears in the selected tile.
2. A soft planting glow occurs.
3. A beautiful blue pulse expands across the row and column.
4. Affected plants rise or gently bounce.
5. Their growth stage visibly changes.
6. Newly completed flowers open their petals.
7. Matching detection begins.

The water pulse should travel visually from the origin rather than simply turning the entire cross blue at once.

The wave is a visual presentation of a deterministic logical event.

It must never miss a valid cell because an animation finished early.

---

# 11. EXACT MATCHING RULES

The player creates a Bloom Match when at least three fully mature flowers of the same species form a continuous line.

Valid directions:

- Horizontal.
- Vertical.

Invalid:

- Diagonal.
- Disconnected.
- Different species.
- Groups containing immature buds or seedlings.

A mature flower does not match with an immature plant simply because they belong to the same species.

### Examples

`PINK PINK PINK`

Valid Bloom Match.

`BLUE BLUE BLUE BLUE`

Valid Bloom Match.

`PINK BUD(PINK) PINK`

Not a match.

`BLUE EMPTY BLUE BLUE`

Not a match.

### Matching algorithm

After a growth phase is complete:

1. Scan every row for maximal continuous runs of mature flowers of the same species.
2. Scan every column using the same rules.
3. Identify all runs containing three or more flowers.
4. Combine overlapping matched cells into a unique set.
5. Remove every matched cell simultaneously.
6. Award points.
7. Create visual Bloom Blast effects.
8. Create Bloom Echo energy on the cleared ground.
9. Continue with the chain-resolution rules.

If a flower is part of both a horizontal and a vertical match, remove it only once.

Do not award the basic flower score twice for the same removed cell.

A five-flower line must count as a single maximal run, not multiple overlapping three-flower runs.

---

# 12. BLOOM BLAST AND CHAIN REACTION

Bloom Blast must be visually satisfying.

When a valid match occurs:

- The matched flowers brighten.
- Their petals open dramatically.
- A warm golden halo appears.
- The flowers release magical petals.
- Sparkles radiate outward.
- The matched cells clear.
- The score increases.
- Neighboring plants receive a limited growth boost.

### Neighboring growth rule

After matched flowers are removed, identify the four orthogonally adjacent neighbors of every cleared cell.

For each chain-resolution wave:

- Combine the neighboring coordinates into one unique set.
- Ignore empty cells.
- Ignore obstacles.
- Ignore already-cleared cells.
- Advance each remaining immature neighboring plant by exactly one stage.

A plant adjacent to several cleared flowers still receives only one growth advancement in that particular wave.

After the growth update, scan for new matches.

If new matches are created, another chain-reaction wave begins.

Continue until no new match exists.

Because successful chain waves remove at least three plants and the board is finite, the sequence must terminate.

Implement a defensive chain-wave safety limit and state validation, without prematurely stopping legitimate chain reactions.

### Important distinction

A Bloom Pulse grows plants in a row and column.

A Bloom Blast grows immediate neighbors of cleared flowers.

These are separate effects.

Do not confuse them.

### Animation

Each chain wave should feel progressively more exciting.

First match:

`BLOOM!`

Second wave:

`COMBO ×2`

Third wave:

`COMBO ×3`

Later waves may produce a stronger visual presentation, but avoid covering the entire board with unreadable effects.

---

# 13. BLOOM ECHO — SECONDARY SIGNATURE MECHANIC

Bloom Echo creates strategic opportunities using recently cleared locations.

Whenever flowers are cleared, the empty soil underneath them becomes temporarily energized.

That ground is called Bloom Echo soil.

### Bloom Echo appearance

The affected cell has:

- A subtle pink or golden soil glow.
- Small floating light particles.
- A faint magical ring.
- A clearly recognizable temporary energy state.

Bloom Echo must not obscure whether a tile is empty.

### Duration

A newly created Bloom Echo lasts for the next two successful planting moves.

Every successful player placement counts as one move for Echo expiration.

Invalid taps do not count.

### Activation

If a player plants a seed directly onto an active Bloom Echo cell:

1. Plant the seed normally.
2. Trigger the normal Bloom Pulse.
3. Resolve matches and ordinary chain reactions.
4. Trigger one additional Bloom Echo Pulse from the planted location.
5. Resolve any new matches and chain reactions.
6. Consume that location's previous Bloom Echo charge.

The additional Echo Pulse affects the same row and column as the primary pulse.

Unlike the primary pulse, the additional Echo Pulse may grow the newly planted seedling, if it is still present and immature.

### Strict restrictions

- Only one Bloom Echo bonus pulse can be triggered by a player move.
- Secondary pulse effects must not recursively trigger other Bloom Echo cells.
- Merely passing a water pulse through Echo soil does not activate it.
- Only directly planting onto an active Echo cell activates it.
- Echo is not activated by nearby flower explosions.
- Echo energy does not independently create additional seeds.

### Echo expiration algorithm

At the beginning of a move, capture the active Echo state.

Resolve the placement and all associated effects.

After move resolution:

- Remove the activated old Echo charge, if any.
- Decrement the remaining duration of other existing Echo charges.
- Remove expired charges.
- Add newly generated Echo charges with a full duration of two future successful moves.

If a new match clears a location already holding Echo energy, the newly generated charge replaces the older charge.

This ordering must remain consistent.

---

# 14. COMPLETE TURN RESOLUTION PIPELINE

This section is mandatory.

Implement the complete gameplay turn using a single authoritative state-transition system.

The precise order must be:

**Step 1 — Input validation**

Check:

- Game is active.
- Board accepts input.
- Selected seed exists.
- Target is within board bounds.
- Target cell is legally empty.
- The current mode allows placement.

**Step 2 — Snapshot**

Capture the pre-move game state, including:

- Board.
- Current seed tray.
- Seed generator state.
- Score.
- Move counters.
- Echo charges.
- Objective progress.

This enables deterministic undo and debugging.

**Step 3 — Echo detection**

Check whether the target location had active Bloom Echo energy before planting.

Save this result.

**Step 4 — Placement**

Consume the selected seed card.

Create a Stage 0 plant at the selected cell.

**Step 5 — Primary Bloom Pulse**

Advance existing immature plants in the target's row and column by one stage.

Exclude the newly planted cell during this primary pulse.

**Step 6 — First match resolution**

Detect all valid horizontal and vertical mature-flower matches.

Clear them simultaneously.

Award score.

Create Echo energy.

Apply neighboring growth and resolve chain reactions until stable.

**Step 7 — Optional Echo Pulse**

If the player planted on an active Echo location, execute exactly one additional pulse.

Allow the newly planted cell to advance in this pulse.

Resolve resulting matches and chain reactions.

**Step 8 — Final Echo update**

Expire or refresh Echo charges using the documented rules.

**Step 9 — Score and objectives**

Apply the final score.

Update objective progress.

Update level-specific move counts.

Update combo statistics.

**Step 10 — Seed tray**

Finalize the consumed seed card.

Generate the next seed batch when the current batch is exhausted.

**Step 11 — Game-state evaluation**

Check for:

- Level completion.
- No legal placements.
- Remaining move limits.
- Game over.
- New records.
- Unlocks.

**Step 12 — Save**

Persist the complete stable game state.

**Step 13 — Unlock input**

Accept the next move only when the previous move has been logically resolved and the animation state allows interaction.

### Engineering constraint

Gameplay calculations must not depend on particle effects, frame rate, animation duration, or animation callbacks firing successfully.

Calculate authoritative results first.

Generate animation events from those results.

Never mutate the underlying board inconsistently in multiple animation scripts.

---

# 15. SCORING SYSTEM

The scoring system must reward both simple matches and intelligent planning.

Start with this configurable scoring model.

### Base score

Every cleared mature flower:

**100 points**

Every distinct qualifying maximal match run:

**50 bonus points**

Example:

Three mature flowers in one valid line:

`3 × 100 + 50 = 350 points`

### Chain multiplier

Use a chain-wave multiplier:

- First wave: ×1.0
- Second wave: ×1.5
- Third wave: ×2.0
- Fourth wave: ×2.5
- Fifth and later waves: ×3.0 maximum

Calculate the multiplier on that wave's base score.

Round resulting scores to whole numbers consistently.

An intersecting flower receives its base flower score once.

Run bonuses follow the exact number of distinct maximal qualifying runs.

### Score feedback

The UI must display:

- Immediate points earned.
- Current total score.
- Best score.
- Combo multiplier.
- New high-score celebration.

Do not create fake score increments disconnected from resolved gameplay.

Do not award points simply for planting a seed.

Plant placement is an investment; successful blooming earns the reward.

---

# 16. GAME MODES

The finished game must support three distinct game modes.

## MODE A — ENDLESS

This is the primary long-term gameplay mode.

The objective is to survive and achieve the highest possible score.

Rules:

- Standard 6×6 grid.
- No countdown timer.
- No fixed move limit.
- No mandatory internet.
- Three standard flower species.
- Three-card seed tray.
- Bloom Pulse always enabled.
- Bloom Echo enabled after the introductory explanation.
- Chain reactions enabled.
- Score saved locally.
- Best score persistently stored.

The session continues until there are no legal seed placements and all move-resolution effects have finished.

A full board must not immediately trigger game over before pending matches and reactions resolve.

The display may show "Moves Played," but that number must not function as a move limit.

Avoid unfair sudden obstacles in classic Endless Mode.

Introduce a separate Advanced Endless option later if additional species or obstacles are desired.

The classic rules must remain stable, allowing meaningful high-score comparison.

## MODE B — LEVELS

Create a structured progression system.

Begin with at least 100 level definitions or a reliable framework capable of supporting 100 properly validated levels.

Each level has:

- Level identifier.
- Initial board configuration.
- Available species.
- Seed-generation configuration.
- Goal definition.
- Move limit.
- Optional obstacle rules.
- Reward configuration.
- Star thresholds.
- Difficulty metadata.

A level must have an explicit, achievable objective.

Possible objectives:

- Clear a specified number of Pink flowers.
- Clear a specified number of Blue flowers.
- Reach a target score.
- Trigger a specified number of Bloom Echo actions.
- Complete a specified number of chain reactions.
- Clear special blocked cells in advanced levels.

Do not introduce every objective type immediately.

Levels should teach one new mechanic at a time.

### Level display

For example:

`LEVEL 28`

`GOAL: 0 / 12 Pink Flowers`

`MOVES LEFT: 18`

This must be tied to the actual level state.

Do not show arbitrary mock values.

## MODE C — DAILY CHALLENGE

Create one daily puzzle that is reproducible for players using the same rules version.

The daily challenge should use:

- A deterministic daily seed.
- A fixed initial board.
- A fixed seed-generation algorithm.
- A clearly defined goal.
- A fixed difficulty configuration.

Use a documented UTC calendar date identifier for challenge generation.

The game must be playable offline.

Do not claim that offline local scores are cheat-proof.

Any future public leaderboard will require suitable server validation.

Daily challenges should encourage natural returning play without punishing players for missing a day.

---

# 17. DIFFICULTY AND GAME BALANCE

Difficulty must develop gradually through strategic complexity, not random unfairness.

The player should feel that losses are understandable.

A skilled player must consistently perform better than an inexperienced player over many runs.

Avoid artificial systems secretly designed to force losses.

### Level difficulty plan

**Levels 1–5: Tutorial / Very Easy**

- Simple board patterns.
- Few plants.
- Clear opportunities to match.
- Generous move limits.
- One mechanic introduced at a time.
- No obstacles.
- No fourth flower species.

**Levels 6–15: Easy**

- More active plants.
- Basic planning required.
- Multiple possible match opportunities.
- Occasional two-step growth decisions.
- Basic Bloom Echo opportunities.

**Levels 16–30: Moderate**

- More strategically arranged boards.
- Tighter but fair move limits.
- More importance placed on chain reactions.
- The Golden Bloom species may be introduced from Level 21 onward in specifically designed levels.
- No unavoidable dead ends.

**Levels 31–50: Medium-Hard**

- Increased strategic depth.
- Multiple color combinations.
- More complex goals.
- Carefully introduced special cells.
- Fewer wasted moves tolerated.

**Levels 51–75: Hard**

- Complex growth sequencing.
- Multiple interacting objectives.
- Occasional obstacles.
- More deliberate Echo planning.
- Stronger emphasis on efficient moves.

**Levels 76–100: Expert**

- Advanced puzzle arrangements.
- Significant planning required.
- Carefully verified solvability.
- Challenging but understandable goals.
- No arbitrary luck-dependent impossible scenarios.

### Difficulty calibration targets

Use these as playtesting goals, not guaranteed statistics:

- Early tutorial levels: approximately 90–98% completion.
- Early normal levels: approximately 80–90%.
- Moderate levels: approximately 65–80%.
- Hard levels: approximately 45–65%.
- Expert levels: approximately 30–50%.

These values must be validated through playtesting and appropriately interpreted.

Do not automatically rig a level after failures.

Offer useful hints rather than secretly changing core rules.

### Session length

Design for:

- Quick gameplay sessions: around 2–4 minutes.
- Normal sessions: around 5–8 minutes.
- Longer Endless sessions: 10 minutes or more for engaged players.

Do not enforce these durations.

The player must be free to continue playing when the board supports it.

---

# 18. FAIRNESS AND SOLVABILITY

Fairness is mandatory.

The game must not manipulate seed colors secretly based on whether the player has purchased anything, watched advertisements, or recently lost.

Seed batches must be deterministic from the session seed and rule configuration.

### For Levels

Before releasing a puzzle:

- Validate that it has at least one winning solution.
- Confirm the solution respects its move limit.
- Confirm the seed tray sequence is achievable.
- Confirm obstacles do not create impossible conditions.
- Verify the goal counters match actual clear events.

Use a solver or automated search where practical.

Handcrafted introductory levels may be used, provided they are validated using the real gameplay rules.

### For Endless

A loss may occur because of player choices.

However:

- Avoid pathological seed generation.
- Avoid impossible opening states.
- Keep initial boards spacious.
- Ensure legal opening moves.
- Use sensible seed distribution.
- Do not make near-loss states artificially worse.

The first several moves of the player's first tutorial experience may be scripted to demonstrate mechanics.

That tutorial scripting must not be confused with ordinary Endless randomness.

### Reproducibility

Given:

- The same initial seed.
- The same initial board.
- The same sequence of seed selections.
- The same placement coordinates.
- The same game-rules version.

The resulting game state must always be identical.

---

# 19. GAME OVER AND RETRY SYSTEM

In Endless Mode, game over occurs only when:

- All move-related effects are resolved.
- The player has no legal cell for seed placement.
- No remaining automatic resolution can create space.

Do not declare game over while an animation still represents a pending match.

### Game Over screen

Show:

- Final score.
- Best score.
- New record indication if appropriate.
- Flowers cleared.
- Maximum combo.
- Moves played.
- Play Again.
- Home.

Use a beautiful garden-themed result screen.

The restart interaction must be immediate and reliable.

Do not require an advertisement to restart.

### Level failure

If all allowed moves have been used and the goal is incomplete:

- Show clear failure feedback.
- Explain progress toward the objective.
- Offer Restart.
- Optionally offer a permitted booster.
- Do not misrepresent a failed level as completed.

---

# 20. UNDO AND BOOSTERS

The base game must be fully playable without boosters.

Boosters should improve convenience, not replace core strategic skill.

### Booster 1 — Undo

Undo the last fully completed move.

Restore:

- Previous board.
- Previous seed tray.
- Previous RNG state.
- Previous score.
- Previous Echo state.
- Previous objective counters.
- Previous move counters.

Do not restore only the visual board.

Undo must preserve the complete authoritative previous state.

Do not allow Undo after a completed result has already been finalized outside its supported context.

### Booster 2 — Water Boost

Choose an occupied immature plant.

Grow it by one stage.

Consume one booster charge.

Do not trigger an entire ordinary Bloom Pulse unless explicitly defined as a separate booster.

Resolve any resulting matches using the same matching engine.

### Booster 3 — Garden Shovel

Remove one selected plant.

Do not award points merely for removing it.

Do not create Bloom Echo unless the booster explicitly carries that behavior.

### Booster 4 — Color Magic

In advanced play, transform one eligible plant into another species.

Validate the action before committing it.

Do not make this available during basic tutorial levels.

### UI requirements

Do not overcrowd the default gameplay screen with four giant booster buttons.

Keep frequently used controls visible and advanced boosters accessible through a compact panel.

The visual reference's small watering can and utility buttons can be retained as carefully sized controls.

---

# 21. COMPLETE GAMEPLAY UI LAYOUT

The gameplay UI must closely follow the supplied Bloom Garden reference.

The final design must have only the actual game screen.

Do not add a permanent tutorial column or promotional information panel to the main gameplay view.

Use a full-screen portrait presentation.

### Top decorative region

A wooden garden sign with the title:

**BLOOM GARDEN**

Requirements:

- Bright golden-yellow "Bloom".
- Rich glossy green "Garden".
- Layered 3D-looking text.
- Rounded wooden sign.
- Decorative leaves and pink flowers.
- Attractive highlights.
- Premium shadows.

The logo should be beautiful but compact enough to leave sufficient space for the board.

### Top-left

Pause button.

- Rounded glossy button.
- Soft highlight.
- Accessible touch area.
- Correct pause behavior.

### Top-right

Settings button or a settings entry through Pause.

Do not duplicate settings controls unnecessarily.

### HUD

Show the appropriate information for the active mode.

For Level Mode:

- Current level.
- Goal progress.
- Moves remaining.
- Score.
- Best score or level record.

For Endless:

- Current score.
- Best score.
- Moves played.
- Optional small progress or combo indicator.

For Daily Challenge:

- Daily challenge identification.
- Objective.
- Moves remaining if applicable.
- Score.

Do not show a "Level 28" counter in Endless Mode.

Do not show "18 moves left" in a mode with unlimited moves.

### HUD styling

Use:

- Deep emerald-green score panels.
- Warm brown or gold borders.
- Large readable numbers.
- Golden highlights.
- Carefully controlled shadows.
- Glossy surfaces without excessive glare.

Numeric text must be clearly readable while animations are running.

### Main gameplay board

Position the board centrally.

It must be the main focus of the screen.

Use:

- Golden wooden outer frame.
- Warm brown soil cells.
- Rounded cell edges.
- Fine bevel effects.
- Small but consistent tile gaps.
- Soft inner shadows.
- Individually rendered flowers.

The board should occupy as much useful screen space as practical without clipping controls.

### Bottom seed tray

Use a polished wooden toolbar.

Include:

- One compact utility button at the left.
- Three prominent seed cards.
- One compact booster button at the right.

Seed cards must have:

- Green, pink, and blue species styling where those species are currently available.
- Correct icons for the displayed species.
- Rounded glossy surfaces.
- Strong selected-state glow.
- Depth and bevel.
- Clear available/consumed state.

When Golden Bloom is available, its card should use the appropriate golden appearance.

### Responsive layout

Support:

- Common 19.5:9 phone screens.
- 20:9 phone screens.
- Taller Android phone displays.
- Narrow devices.
- Foldable displays in portrait.
- Tablets when supported.

Use Android safe areas.

Do not allow notches, camera cutouts, gesture bars, or display corners to cover important controls.

The 6×6 board must always remain square.

Never stretch individual board cells into distorted rectangles.

Decorations may scale or reposition, but the core board geometry must remain consistent.

---

# 22. EXACT VISUAL QUALITY REQUIREMENTS

This is a critical acceptance requirement.

The final Android gameplay should closely resemble the supplied reference image's:

- Color vibrancy.
- Premium cartoon depth.
- Glossy UI materials.
- Environmental richness.
- Strong yet controlled lighting.
- Bright magical energy.
- High-quality wooden textures.
- Vivid flowers.
- Beautiful water effects.
- Smooth visual transitions.

### Soil tiles

Use soft, warm brown earth textures with subtle material variation.

Each tile should have:

- A visible edge.
- Rounded inner corners.
- Light catching the upper edges.
- A soft darkening near the bottom.
- Gentle contact shadows beneath plants.

### Leaves

Leaves should have:

- A smooth organic shape.
- Subtle internal shading.
- A visible center vein where suitable.
- Attractive highlights.
- A slight depth effect.

### Flower buds

Buds should be glossy and sculptural.

Use:

- Curved petals.
- Gradual color transitions.
- Bright edge highlights.
- Green leaf bases.
- Gentle shadows.

### Mature flowers

Flowers should appear lush, colorful, and dimensional.

Use:

- Layered petals.
- Slightly different petal rotations.
- Soft gradients.
- Bright edges.
- Attractive golden or contrasting centers.
- Gentle idle movement.

### Lighting

Use multiple coordinated lighting treatments:

1. Soft environment lighting.
2. Warm sunlight on UI surfaces.
3. Mild ambient shadowing.
4. Bloom-pulse emissive effects.
5. Golden flower-combination flashes.
6. Subtle particle glow.

The game must look vibrant during ordinary idle gameplay, not only during special effects.

Do not make the whole board permanently washed out by glow.

Text must remain readable against bright effects.

---

# 23. BLOOM PULSE VISUAL EFFECTS

Bloom Pulse must be visually spectacular but performance-conscious.

### Primary pulse appearance

Color:

Bright cyan / magical blue.

Components:

- Luminous water-energy line.
- Bright traveling core.
- Soft outer glow.
- Animated directional chevrons.
- Tiny blue particles.
- Faint water shimmer.
- A soft illumination on nearby cells.

The pulse moves outward horizontally and vertically from the planted cell.

### Timing

Suggested starting timings:

- Initial touch response: immediate.
- Plant appearance: approximately 100–150 ms.
- Pulse travel: approximately 250–400 ms.
- Growth animation: approximately 200–300 ms.
- Match flash: approximately 150–250 ms.
- Flower clearing: approximately 250–350 ms.

These values should be tuned using real device testing.

The exact duration is a presentation setting, not a gameplay rule.

Avoid very long forced animations after every small move.

Allow a configurable Faster Animations option.

### Echo pulse

Bloom Echo should feel more energetic than an ordinary pulse.

Use:

- Pink-golden initial spark.
- Cyan pulse body.
- Slightly stronger trailing glow.
- Short Echo indicator.
- A distinctive but subtle sound.

Do not use full-screen white flashes.

---

# 24. BLOOM BLAST VISUAL EFFECTS

Whenever flowers match:

- Bright golden outlines appear.
- Flower petals separate naturally.
- A burst of small petals moves outward.
- Soft golden light expands briefly.
- Glitter particles scatter.
- The matched flowers dissolve cleanly.
- The soil becomes empty.
- Echo energy appears where appropriate.

The effects must look premium.

Use additive or appropriate light blending for magical effects.

Avoid:

- Excessive particle density.
- Constant full-screen flashes.
- Motion that hides the puzzle board.
- Random colors unrelated to the flower species.
- Large text covering multiple board rows.

### Chain reactions

Each subsequent chain wave should increase the sense of reward.

Example sequence:

`BLOOM!`

`DOUBLE BLOOM!`

`COMBO ×3`

`SUPER BLOOM!`

Use increasingly rich but bounded effects.

The player should always understand what caused the chain reaction.

---

# 25. ANIMATION SYSTEM

Implement reusable, modular animation components.

Required animation categories:

**Planting**

- Seed drop.
- Soil puff.
- Small leaf bounce.
- Placement glow.

**Growth**

- Gentle upward stretch.
- Leaf opening.
- Bud formation.
- Flower petal opening.

**Pulse**

- Horizontal energy travel.
- Vertical energy travel.
- Directional lighting.
- Pulse fade.

**Match**

- Match highlight.
- Pre-bloom anticipation.
- Petal explosion.
- Cell clearance.

**Echo**

- Echo ground glow.
- Echo activation burst.
- Secondary pulse.

**UI**

- Button press.
- Seed selection.
- Score update.
- Combo badge.
- Goal progress.
- Level complete.
- Game over.

Use consistent animation curves.

Favor smooth easing instead of harsh abrupt movements.

Animation speed should remain adjustable independently from logical update speed.

Do not create hundreds of unnecessary independently ticking animations when one batched system would be more efficient.

---

# 26. AUDIO DESIGN

Create a cohesive, relaxing garden soundscape.

Required sound effects:

- Soft UI tap.
- Seed placement.
- Gentle soil interaction.
- Water pulse.
- Growth transition.
- Bud opening.
- Flower bloom.
- Matching explosion.
- Combo increase.
- Bloom Echo activation.
- Level completion.
- Game over.
- Reward collection.

### Music

Use original or properly licensed background music.

Suggested mood:

- Calm.
- Cheerful.
- Light.
- Nature-inspired.
- Pleasant during repeated play.
- Not overly dramatic.

The music must not become annoying during long Endless sessions.

### Audio controls

Provide separate settings for:

- Music.
- Sound effects.
- Vibration.

Remember the player's choices.

Respect system audio behavior.

### Haptics

Use short, subtle haptic feedback for:

- Plant placement.
- Bloom completion.
- Important combo.
- Level success.

Do not vibrate repeatedly throughout every particle animation.

Offer a clear vibration toggle.

---

# 27. PLAYER HABIT AND RETENTION DESIGN

The game should naturally encourage repeat play because its decisions are enjoyable.

Do not rely on manipulative pressure.

### Core engagement loop

The intended loop is:

**Plant → Grow → Anticipate → Bloom → Score → Create Space → Plan Again**

Each successful action should:

- Change the board visibly.
- Give immediate feedback.
- Create at least one new consideration.
- Move the player toward an objective.
- Make the next decision understandable.

The main source of engagement must be satisfying strategy, not artificial waiting.

### Short-term motivation

Give players:

- Visible match opportunities.
- Clear growth progression.
- Immediate score feedback.
- Satisfying animation.
- Small achievable goals.

### Medium-term motivation

Give players:

- Higher scores.
- More efficient strategies.
- Combo discoveries.
- New levels.
- Unlockable themes.
- Daily challenges.

### Long-term motivation

Give players:

- Endless high-score improvement.
- More difficult puzzle levels.
- Cosmetic theme collections.
- Advanced challenge modes.
- Personal gameplay achievements.
- Optional competitive features later.

### Do not implement

- Forced waiting timers.
- Artificial energy limits preventing play.
- Punishment for not opening the app.
- Fake scarcity.
- Hidden probability manipulation.
- Mandatory advertisements between every attempt.
- Deceptive reward systems.

### Daily rewards

A modest daily cosmetic reward can be added.

Missing a day must not erase purchased items or previously earned permanent progress.

Do not build the core game around attendance pressure.

---

# 28. FIRST-TIME USER EXPERIENCE

The first launch must be extremely simple.

The player should not see a long instructional manual.

Use a guided playable tutorial powered by the real game engine.

### Tutorial Step 1 — Planting

Highlight one empty cell.

Show:

`Tap to Plant`

Automatically select the intended tutorial seed.

The player taps the highlighted cell.

The seed appears.

### Tutorial Step 2 — Water Pulse

Allow the player to see the blue pulse.

Explain briefly:

`Each seed sends water across its row and column.`

Use a short visual explanation, not a large paragraph.

### Tutorial Step 3 — Growth

Show an existing plant advancing from Seedling to Bud.

Then demonstrate another growth event leading to a mature flower.

Explain:

`Water helps your plants grow.`

### Tutorial Step 4 — Bloom Match

Create a validated tutorial situation where three mature flowers of the same color form a match.

Show:

`Match 3 Flowers to Bloom!`

The flowers clear.

The player earns points.

### Tutorial Step 5 — Echo

Demonstrate glowing empty soil left by a match.

Explain:

`Plant here for an extra water pulse!`

Allow the player to trigger a Bloom Echo.

### Tutorial Step 6 — Free Play

Remove tutorial overlays.

Enable normal controls.

Let the player continue a short introductory session.

Do not interrupt every subsequent move with explanations.

The tutorial must use genuine gameplay functions.

No fake decorative match animations that cannot happen through the real rules.

Provide a replay tutorial option in Settings.

---

# 29. HOME SCREEN

Create a premium home screen consistent with the main gameplay art.

The home screen must include:

- Bloom Garden logo.
- Beautiful garden background.
- Subtle animated flowers.
- Primary Play button.
- Endless Mode entry.
- Levels entry.
- Daily Challenge entry.
- Settings.
- Optional theme access.

The hierarchy must be very clear.

The primary Play button should stand out.

Avoid overwhelming the player with too many panels.

Do not introduce unrelated animals or mascots.

A beautiful animated flower can be the visual focal point.

Keep animations light enough for mobile performance.

---

# 30. LEVEL SELECTION SCREEN

Create a visually attractive progression map.

Suggested style:

- Winding garden path.
- Beautiful flower beds.
- Small bridges.
- Garden gates.
- Charming seasonal backgrounds.
- Circular numbered level buttons.
- Clear completed and locked states.

Show:

- Current level.
- Completed level stars.
- Locked levels.
- Available rewards.
- Theme progression.

The progression map must scroll smoothly.

Loading distant decorative sections should not cause gameplay lag.

Do not generate hundreds of active animations simultaneously.

---

# 31. THEMES AND ENVIRONMENTS

Begin with one fully polished theme.

**Theme 1 — Spring Garden**

Characteristics:

- Bright blue sky.
- Lush greenery.
- Pink flowers.
- Wooden board.
- Warm sunlight.
- Rich green borders.

Only after this theme is complete should additional themes be developed.

Potential future themes:

**Autumn Garden**

Golden leaves, warm amber lighting, orange foliage.

**Winter Garden**

Snow, icy highlights, pale blue lighting, frosted soil borders.

**Moonlight Garden**

Dark blue night sky, gentle moonlight, luminous flowers.

**Tropical Garden**

Bright exotic plants, colorful foliage, vivid sunlight.

**Magical Garden**

Floating sparkles, enchanted flowers, luminous vegetation.

Theme changes must not affect the actual logical behavior of normal seeds, matches, or pulses.

Themes are primarily cosmetic.

They must not create unfair gameplay advantages.

---

# 32. RESPONSIVENESS AND TOUCH UX

This game is designed primarily for portrait Android devices.

The gameplay interface must be comfortable with one hand.

Requirements:

- Large touch targets.
- No tiny mandatory text.
- No horizontal scrolling during gameplay.
- No controls outside the screen.
- No overlapping HUD and board.
- No accidental presses near Android gesture areas.
- Clear feedback for the currently selected seed.

Use a minimum practical touch target of approximately 48 density-independent pixels for primary controls wherever screen constraints permit.

Maintain responsive scaling.

The board must be centered and must never be visually distorted.

### Different screen sizes

On shorter phones:

- Reduce logo height.
- Tighten HUD spacing.
- Reduce decorative margins.
- Preserve the board size as much as possible.

On taller phones:

- Increase decorative breathing room.
- Maintain balanced vertical proportions.
- Do not create a huge unused blank area.

On tablets:

- Center the play area.
- Scale carefully.
- Use side decorations when appropriate.
- Avoid stretching gameplay elements unnaturally.

On foldable devices:

- Respect actual viewport dimensions.
- Adapt after screen resizing.
- Preserve state across layout changes.

---

# 33. ACCESSIBILITY

Make the game usable by a broad range of players.

Implement:

- Color-blind-friendly species distinction.
- Unique species silhouettes or recognizable shapes.
- Optional reduced-motion mode.
- Optional reduced-glow mode.
- Adjustable sound.
- Adjustable vibration.
- Readable text.
- High-contrast UI labels.
- Clear button states.

Do not rely entirely on flower color to explain species differences.

The game should remain understandable with reduced effects.

Avoid rapid full-screen flashes.

Reduced Motion should significantly reduce bouncing, camera movement, and particle bursts without changing gameplay rules.

---

# 34. PERFORMANCE REQUIREMENTS

Target smooth performance across a practical range of Android devices.

### Frame-rate goals

- 60 FPS target on capable devices.
- Stable 30 FPS option on weaker devices.
- Consistent frame pacing.
- Smooth touch response.
- No severe stutter during large chain reactions.

### Rendering optimization

Use:

- Texture atlases.
- Efficient sprite batching.
- Controlled particle counts.
- Cached materials.
- Reusable animation components.
- Object pooling where beneficial.
- Reduced overdraw.
- Reasonable render resolution.
- Efficient shaders.

Do not create a new expensive material instance for every particle unless necessary.

Do not use full-resolution blur effects over the entire screen when a localized shader or glow texture can achieve the same appearance.

### Graphics presets

Provide:

**High**

Full-quality glow, rich particles, premium effects.

**Balanced**

Reduced particles, carefully optimized glow.

**Low**

Minimal post-processing, fewer particles, simplified lighting.

The visual identity must remain recognizable in all presets.

### Device behavior

Handle:

- Application backgrounding.
- Incoming calls.
- Screen locking.
- App resume.
- Low-memory interruptions.
- Orientation constraints.
- Thermal performance reduction.

The game must remain stable after repeated resume cycles.

Never allow the simulation to continue consuming excessive resources while the game is suspended.

---

# 35. SAVE SYSTEM

The game must support reliable offline save data.

Persist:

- Current Endless board.
- Current score.
- Best score.
- Seed tray.
- Random generator state.
- Echo charges.
- Move count.
- Level progress.
- Completed levels.
- Stars earned.
- Settings.
- Unlocked themes.
- Booster inventory, if enabled.
- Tutorial completion.
- Daily challenge state.

Use a versioned save-data format.

Use safe writes, preferably through temporary-file replacement or an equivalent reliable mechanism.

Do not corrupt an existing save when the app closes during an animation.

Only save stable authoritative game states.

On restart, restore the last confirmed stable state.

### Save recovery

If data is corrupted:

- Detect corruption.
- Avoid crashing.
- Attempt recovery from a valid backup.
- Preserve long-term progress where possible.
- Never silently overwrite all progress without a recoverability policy.

Store game logic versions so older saves can be migrated when rules evolve.

---

# 36. SOUND, VFX, AND LOGIC SYNCHRONIZATION

Logical correctness must always be independent of audiovisual timing.

For every player action:

1. Validate input.
2. Calculate logical result.
3. Generate a sequence of game events.
4. Animate the events.
5. Play associated sounds.
6. Update visible counters.
7. Enable the next interaction.

Use an event system.

Example events:

- `SeedPlanted`
- `PulseStarted`
- `PlantGrew`
- `FlowerBloomed`
- `MatchDetected`
- `FlowersCleared`
- `ChainTriggered`
- `EchoActivated`
- `ScoreAwarded`
- `GoalUpdated`
- `MoveCompleted`
- `GameEnded`

Events must correspond to real state changes.

Avoid duplicated event emission.

Animation interruption must not create missing or repeated scoring events.

---

# 37. GAME LOGIC ARCHITECTURE

Keep presentation and rules separate.

Suggested structure:

`GameManager`

Controls overall game lifecycle and mode transitions.

`BoardModel`

Maintains the authoritative grid.

`CellModel`

Represents individual cell data.

`PlantModel`

Stores species and growth stage.

`SeedTrayManager`

Controls available seed cards and deterministic generation.

`BloomPulseSystem`

Calculates affected rows and columns.

`GrowthSystem`

Advances valid plants.

`MatchDetector`

Detects qualifying lines.

`ChainResolver`

Resolves match-clearing cascades.

`BloomEchoSystem`

Handles temporary echo energy.

`ScoreSystem`

Calculates scores and multipliers.

`LevelManager`

Loads level definitions and objectives.

`DifficultyManager`

Loads predefined configuration and supports balancing analysis.

`SaveManager`

Persists authoritative state.

`AnimationDirector`

Converts gameplay events into visual sequences.

`AudioManager`

Handles sound and music.

`SettingsManager`

Handles preferences.

`AndroidPlatformManager`

Handles device-specific platform behavior.

`UIToolkit`

Contains shared buttons, panels, text, icons, and responsive layout utilities.

Use clear names and consistent coding conventions.

Avoid massive scripts containing unrelated responsibilities.

---

# 38. GAME STATE DATA MODEL

Define explicit gameplay data structures.

Suggested logical representation:

```text
GameState
  rulesVersion
  gameMode
  sessionSeed
  rngState
  board[6][6]
  seedTray[3]
  selectedSeedSlot
  score
  bestScore
  movesPlayed
  movesRemaining
  objectiveState
  activeEchoEffects
  chainStatistics
  gameStatus
```

Each cell contains:

```text
CellState
  row
  column
  occupantType
  plantSpecies
  growthStage
  echoTurnsRemaining
  obstacleType
```

Represent empty occupancy explicitly.

Use enums or equivalent strongly defined constants.

Prevent impossible states such as:

- Empty cell with active plant growth stage.
- Mature flower without a species.
- Occupied obstacle cell also containing a normal plant.
- Negative Echo duration.
- More than one plant occupying the same cell.
- Out-of-range coordinates.

Score values should use an integer representation with sufficient range for long Endless sessions.

---

# 39. AUTOMATED GAMEPLAY TESTS

Implement thorough testing.

### Board tests

- Exactly 36 cells.
- Correct coordinate mapping.
- Correct placement validation.
- Correct empty-cell detection.
- Correct occupied-cell rejection.

### Growth tests

- Stage 0 to Stage 1.
- Stage 1 to Stage 2.
- Stage 2 remains Stage 2.
- New seed excluded from primary pulse.
- Existing cross-row plants advance exactly once.
- Existing cross-column plants advance exactly once.

### Match tests

- Horizontal three.
- Vertical three.
- Horizontal four.
- Vertical five.
- Horizontal and vertical intersections.
- Diagonal non-match.
- Different species non-match.
- Bud non-match.
- Broken-line non-match.

### Echo tests

- Echo created after clearing.
- Correct two-future-move duration.
- Echo activation only by direct planting.
- One bonus pulse per move.
- New seed eligibility for secondary pulse.
- No recursive Echo activation.
- Correct expiration.
- Correct replacement of overlapping old and new charges.

### Chain tests

- Single match.
- Multiple simultaneous matches.
- Growth from neighboring clear.
- No duplicated growth of a shared neighbor during one chain wave.
- Multiple chain waves.
- Correct termination.
- Correct scoring.

### Input tests

- Rapid double tap.
- Multi-touch.
- Tap during pause.
- Tap during animation.
- Tap on invalid coordinate.
- Tap on occupied cell.
- Change seed before placement.

### Save tests

- Save after a completed move.
- Restore current board.
- Restore seed tray.
- Restore RNG state.
- Restore Echo duration.
- Restore score.
- Restore level counters.
- Recover after forced interruption.

### Game-over tests

- Board completely occupied.
- Pending match before game-over evaluation.
- Level goal reached on final move.
- Level goal not reached on final move.
- Correct retry behavior.

### Determinism tests

Replay recorded sequences of actions and verify identical final states.

Do not rely only on manual clicking tests.

---

# 40. DIFFICULTY SIMULATION AND BALANCING

Create a gameplay simulation tool.

The simulation must use the exact production gameplay engine.

It must not implement a simplified alternate ruleset that differs from the game.

Simulate automated sessions using several strategies:

- Random legal placement.
- Greedy immediate-score strategy.
- Space-preserving strategy.
- Growth-planning strategy.
- Stronger look-ahead strategy.

Record:

- Survival length.
- Average score.
- Highest score.
- Average combo size.
- Frequency of Bloom Echo activation.
- Board occupancy over time.
- Number of available placements.
- Failure reasons.
- Level completion percentage.

Use the results to tune configurations.

Ensure stronger strategies generally have measurable benefits over random placement.

If random play consistently performs nearly as well as skillful play, reconsider the mechanics.

If most sessions end before players experience a satisfying Bloom combination, adjust the opening balance.

If normal Endless sessions continue indefinitely with little possibility of failure, identify the source of excessive ease.

Do not apply hidden in-session difficulty manipulation.

Difficulty settings must be explicit and testable.

---

# 41. SPECIAL CELLS FOR ADVANCED LEVELS

Do not introduce special cells in the initial tutorial.

Advanced levels may use carefully designed obstacles.

### Rock Cell

A rock blocks planting.

For advanced obstacle levels, define rocks as water barriers.

A Bloom Pulse travels outward from its origin and stops in a direction when it reaches a rock.

The rock itself does not grow and does not clear through ordinary flower matching.

Implement directional ray propagation for these levels.

Do not simply apply the standard entire-row effect through obstacles.

### Fertile Soil

An advanced special soil type may provide one extra growth stage to an immature plant placed on it.

Its behavior must be explicitly configured.

Avoid interactions that create unintended unlimited growth.

### Frozen Soil

A special tile may require a defined number of nearby Bloom Blasts to become usable.

Clearly communicate remaining unlock requirements.

### Release policy

Advanced mechanics should be optional extensions.

The first release must prioritize a polished version of the core game.

Do not reduce the quality of the main game to implement too many special tiles.

---

# 42. ACHIEVEMENTS AND REWARDS

Implement simple, meaningful achievements.

Examples:

- First Bloom.
- First Combo.
- Five Chain Reactions.
- Clear 100 Flowers.
- Clear 1,000 Flowers.
- Score 10,000.
- Score 50,000.
- Complete 10 Levels.
- Complete 50 Levels.
- Complete 100 Levels.
- Finish a Daily Challenge.

Achievements should unlock:

- Cosmetic badges.
- New garden decoration options.
- Visual themes.
- Non-essential rewards.

Do not provide an unfair score advantage merely because a player purchased a cosmetic item.

Rewards must correspond to actual achievement data.

---

# 43. GAME ECONOMY

If an in-game currency is introduced, keep it simple.

Suggested name:

**Garden Coins**

Coins may be earned through:

- Level completion.
- Achievements.
- Optional daily rewards.
- Carefully balanced gameplay milestones.

Coins may be used for:

- Cosmetic themes.
- Garden decorations.
- Optional convenience boosters.

Do not add several confusing currencies.

Do not make the game impossible to enjoy without spending money.

The first release may omit the coin system entirely if it would delay core gameplay polish.

---

# 44. OPTIONAL MONETIZATION

Monetization must not interfere with the core puzzle experience.

Implement it only after the base game has been proven stable and satisfying.

Potential future options:

- Rewarded ads for optional boosters.
- Cosmetic theme purchases.
- Optional remove-ads purchase.
- Carefully limited advertisements between completed sessions.

Never interrupt a water pulse or chain reaction with an advertisement.

Never show advertisements over the gameplay board.

Never mislead players into believing a purchase is required for a normally achievable puzzle.

Ensure any advertisement integration follows current Google Play policies and applicable privacy requirements.

Avoid unnecessary SDKs in the initial offline prototype.

Do not request permissions unrelated to actual implemented features.

---

# 45. ANDROID RELEASE REQUIREMENTS

The game must be buildable and playable as a native Android application.

Requirements:

- Correct Android package configuration.
- Portrait orientation.
- Adaptive launcher icon.
- Splash screen.
- Appropriate Android SDK versions.
- Stable application lifecycle handling.
- Proper release signing support.
- Google Play-compatible AAB export.
- Debug APK for local testing.
- No committed signing secrets.
- No hardcoded passwords or private keys.

For Google Play submissions under November 2026 requirements, target Android 16 / API level 36 or higher, and reverify requirements before release.

Use the appropriate currently supported Android build tools for the chosen game engine.

If a signing configuration is not supplied, generate an unsigned or debug artifact as appropriate and document the exact release-signing steps.

Do not invent a real production signing key or claim a release AAB is production-signed when it is not.

The basic game should run without account registration.

Do not require SMS verification.

Do not require mandatory email registration.

Do not require network connectivity.

---

# 46. FIRST RELEASE SCOPE

Prioritize quality over unnecessary feature count.

The first complete release should contain:

1. Fully implemented 6×6 board.
2. Three flower species.
3. Complete growth lifecycle.
4. Deterministic Bloom Pulse.
5. Correct Match-3 line detection.
6. Bloom Blast.
7. Chain reactions.
8. Bloom Echo.
9. Three-card seed tray.
10. Endless Mode.
11. A properly tested introductory level set.
12. Expandable level progression framework.
13. Daily Challenge framework.
14. High-quality main gameplay UI.
15. Full visual effects.
16. Sound effects and music controls.
17. Save and resume.
18. Settings.
19. Game-over and retry screens.
20. Android export support.

Complete these core systems before developing complex optional features.

---

# 47. DEVELOPMENT WORKFLOW

Follow this development order.

## Phase 1 — Project inspection

Inspect the existing project, if provided.

Determine:

- Engine.
- Existing architecture.
- Current assets.
- Android build setup.
- Code quality.
- Reusable modules.

Do not blindly overwrite existing source code.

## Phase 2 — Technical foundation

Create or update:

- Project configuration.
- Game-state models.
- Board system.
- Seed representation.
- Rule configuration.
- Deterministic RNG.
- Test framework.

## Phase 3 — Gameplay implementation

Implement:

- Placement.
- Growth.
- Bloom Pulse.
- Matching.
- Clearing.
- Chain reactions.
- Bloom Echo.
- Scoring.
- Game-over rules.

Test each system before moving to the next.

## Phase 4 — Playable prototype

Create a functional playable board.

Verify that the game is strategically interesting.

Use temporary visuals only during this development phase.

Do not treat the prototype as the final deliverable.

## Phase 5 — Premium graphics

Recreate the supplied Bloom Garden visual identity.

Implement:

- Background art.
- Wooden UI.
- Premium tile textures.
- Flower sprites.
- Lighting.
- Glow.
- Water effects.
- Particle effects.
- Animation.

## Phase 6 — Complete user experience

Implement:

- Home.
- Tutorial.
- Gameplay.
- Pause.
- Settings.
- Level Complete.
- Game Over.
- Level Selection.
- Daily Challenge.

## Phase 7 — Difficulty balance

Run simulations and actual playtests.

Tune difficulty according to observed behavior.

Document configuration changes.

## Phase 8 — Android optimization

Test multiple Android device profiles.

Measure frame pacing, memory, startup time, and rendering stability.

Reduce expensive effects where needed without losing the reference's artistic identity.

## Phase 9 — Final QA

Run the full gameplay and visual validation checklist.

Correct discovered errors.

Repeat testing after corrections.

## Phase 10 — Android build

Generate and validate the appropriate Android artifacts.

Provide build instructions and release configuration.

---

# 48. VISUAL AND LOGICAL ACCEPTANCE CRITERIA

The game is not complete unless the following requirements are met.

### Gameplay

- The board is exactly 6×6.
- Every cell is correctly interactive.
- Seed placement is reliable.
- Plants grow according to the defined rules.
- Bloom Pulse correctly affects its row and column.
- New seedlings are properly excluded from the primary pulse.
- Three mature same-species flowers match correctly.
- Diagonal matching never occurs accidentally.
- Chain reactions work.
- Bloom Echo works.
- Score calculation is correct.
- No invalid move consumes a seed.
- Game-over detection is correct.
- Save and resume work.
- The game is genuinely playable offline.

### Visuals

- No panda.
- No animal character.
- No Paws branding.
- Bloom Garden branding is consistent.
- Beautiful bright garden background.
- High-quality wood-and-soil board.
- Premium glossy buttons.
- Attractive flower assets.
- Visible growth-stage differences.
- Bright animated water cross.
- Golden bloom effects.
- Rich but controlled glow.
- Smooth animation.
- Responsive portrait layout.
- No clipped UI.
- No unreadable text.

### Android

- Installs successfully on tested Android devices.
- Launches without crashes.
- Supports touch correctly.
- Pauses and resumes.
- Preserves data.
- Uses reasonable memory.
- Supports graphics quality scaling.
- Exports appropriate Android builds.

---

# 49. COMMON FAILURE PREVENTION

Avoid these mistakes.

**Mistake 1:** Creating only a beautiful static gameplay screenshot.

Requirement: Build an actual playable game.

**Mistake 2:** Placing flower images without implementing real growth stages.

Requirement: Use logical growth states connected to rendered animations.

**Mistake 3:** Applying random flower matches.

Requirement: Match only valid contiguous mature flowers.

**Mistake 4:** Growing all plants on the board after every move.

Requirement: Grow plants only in the affected pulse cross or according to a specifically defined secondary effect.

**Mistake 5:** Incorrect Bloom Echo duration.

Requirement: Follow the documented two-future-successful-move expiration rules.

**Mistake 6:** Allowing one player tap to be processed twice.

Requirement: Use input validation and action locking.

**Mistake 7:** Making animation effects control the logical simulation.

Requirement: Use an authoritative game-state system.

**Mistake 8:** Building the UI with stretched screenshots.

Requirement: Create real independent renderable and interactive UI components.

**Mistake 9:** Showing fake score, level, goal, or move counters.

Requirement: Bind every displayed value to actual game state.

**Mistake 10:** Making the game unnecessarily hard in the first few minutes.

Requirement: Provide a smooth learning experience.

**Mistake 11:** Making the game so easy that strategy is irrelevant.

Requirement: Validate meaningful differences between player strategies.

**Mistake 12:** Losing progress after the Android app is closed.

Requirement: Implement reliable state persistence.

**Mistake 13:** Adding too many unnecessary features before finishing the core game.

Requirement: Prioritize gameplay and visual polish.

**Mistake 14:** Reintroducing panda or animal-related branding.

Requirement: Bloom Garden must have a completely independent visual identity.

**Mistake 15:** Claiming completion without actual testing.

Requirement: Run tests and report verified results accurately.

---

# 50. FINAL QUALITY TARGET

The finished Bloom Garden game should feel like a premium, commercially produced Android puzzle game.

A new player should immediately notice:

- Beautiful artwork.
- Rich colors.
- Elegant glossy UI.
- Satisfying water effects.
- Living animated plants.
- Bright, rewarding flower combinations.
- Smooth responsiveness.
- Easy-to-understand controls.

After several minutes, the player should realize:

- Plant placement matters.
- Growth timing matters.
- Flower species selection matters.
- Bloom Echo creates new strategies.
- Chain reactions can be planned.
- Preserving empty space is important.
- Better decisions produce better scores.

The core gameplay must balance relaxation and strategic decision-making.

A player should enjoy simply watching the garden bloom, while an experienced player should be rewarded for planning clever moves.

The game must never feel like a random collection of animations.

Every visual event should represent a real gameplay consequence.

---

# 51. FINAL DELIVERY REQUIREMENTS

Do not stop after creating a project skeleton.

Do not stop after creating only the UI.

Do not stop after implementing the basic board.

Deliver the most complete working implementation possible.

Expected deliverables:

- Complete project source code.
- Organized gameplay modules.
- Editable game assets.
- Working scenes and UI.
- Visual effect implementations.
- Audio integration.
- Game rule configurations.
- Playable game modes.
- Save system.
- Automated gameplay tests.
- Android build configuration.
- Debug APK when the build environment supports it.
- Release-ready AAB when signing requirements are satisfied.
- Build and installation instructions.
- Known limitations, if any.
- Test results.
- Final implementation summary.

For every significant subsystem:

1. Implement it.
2. Review the implementation.
3. Run available tests.
4. Correct failures.
5. Recheck after correction.
6. Continue to the next subsystem.

Finally, run a complete integration review.

If an external tool, Android SDK, signing credential, or asset generator is unavailable, identify the limitation precisely.

Do not falsely claim that an unavailable build or test was completed.

Avoid replacing a premium visual requirement with an unstyled placeholder merely for convenience.

The final deliverable should be a genuine playable Android game with professional graphics, reliable mechanics, and a polished user experience.

---

# 52. MANDATORY FINAL INSTRUCTION

**BUILD BLOOM GARDEN AS A REAL, BEAUTIFUL, COMPLETE, HIGH-QUALITY ANDROID PUZZLE GAME.**

Treat the supplied Bloom Garden gameplay image as the required visual-quality benchmark.

Treat the gameplay rules in this specification as the authoritative functional design.

Do not invent contradictory mechanics.

Do not add unrelated mascots.

Do not introduce another game's branding.

Do not compromise the 6×6 board rules.

Do not deliver static screens in place of interactive functionality.

Do not hide gameplay bugs behind animation.

Implement the project systematically, validate all major systems, and ensure that the game is enjoyable, fair, responsive, visually impressive, and ready for further commercial development.

**Final identity:**

BLOOM GARDEN

**Primary tagline:**

Plant Smart. Grow Together. Bloom Big.

**Primary gameplay loop:**

Plant → Pulse → Grow → Match → Bloom → Echo → Chain → Score → Repeat.

**Ultimate objective:**

Create a visually stunning Android garden puzzle game that players understand quickly, enjoy repeatedly, and continue improving at through genuine strategy and satisfying gameplay.
