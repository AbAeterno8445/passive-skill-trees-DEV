# Passive Skill Trees - Binding of Isaac: Repentance mod

XP, leveling, skill points and skill trees. Global passive skill tree + a personal skill tree for each vanilla character. These apply modifiers that can modify your run, from simple stat ups to gameplay-changing alterations.

## General Overview:

- XP and leveling system, each character has their own level progress.
- Monsters grant XP based on their HP (XP is granted on room clear).
- Gain less XP if not playing in hard mode.
- Leveling up with any character grants a skill point.
- Global passive skill tree with nodes you can allocate using skill points, which grant modifiers to the next run. Accessed from the character select menu.
- Character-specific skill trees with nodes more correlated to their gameplay.
- Respec points which allow you to refund allocated nodes. Clearing a floor has a base 30% chance to award one. Can increase this chance through certain tree nodes.
- Can toggle tree effects on/off before a run.

Generally the small nodes are not very impactful on their own, granting small bonuses like +0.02 damage or +2% xp gain, medium nodes will tend to grant slightly more significant boosts, and large nodes can present an upside vs downside effect or significant boosts under the right conditions, which can affect your run's choices.

You can access the tree screen from the character select menu by pressing V (LT or LB on controller). Within the tree screen you can press H (or Select on controller) to get the control layout. The tree menu should have controller support but I've only tested on an old PS controller.

## Debugging and Config

The mod comes with a few debug settings which make testing its features easier. In the mod directory, main.lua file, at the top you can find a PST.debugOptions table with some variables you can set to 'true', such as:

- **infSP**: No longer spend or require skill points for nodes
- **infRespec**: No longer spend or require respec points for nodes
- **allAvailable**: Makes all nodes available at all times, regardless of connections

There's also the PST_config.lua file, where you can also find some extra settings such as whether to draw the xp bar, floating texts, and char info in character select, as well as re-configuring the keybinds used in the tree screen, in case of conflicts.
