function PST:getChangelogList()
    local changelog = {
        "(You can disable this popup on new versions through Mod Config Menu Pure in-game)",
        "",

        "v0.2.36",
        "- Implemented Save Manager for handling savefiles - hopefully prevents cases of save corruption.",
        "- Optimized tree rendering of nodes and node links.",
        "- Optimized amount of data stored in savefile a bit.",
        "- Switching characters mid-run (e.g. through Clicker) now unapplies the previous character's tree, and",
        "applies the new character's tree to the run.",
        "- Limited size increase of bosses with Soul Watcher (ancient jewel).",
        "- Nullstone now spawns nullified enemies opposite to your position in boss rooms.",
        "- Saturnian Luminite now prevents Genesis from showing up.",
        "- \"Status effect cleanse\" jewel modifier no longer affects frozen enemies.",
        "- Cursed Starpiece now replaces trinkets from Baubleseeker with rev stars cards in the treasure room.",
        "- Lilith's \"Heavy Friends\" node now grants -35% speed (from -25%), and -45% damage.",
        "- Fixed rendering of certain Cosmic Realignment blue marks.",
        "- Fixed Opalescent Purity triggering inconsistently when grabbing item pedestals.",
        "- Fixed Challenger's Starpiece not spawning a deadly sin boss after the first challenge room clear.",
        "- Fixed certain jewel effects affecting charmed friendly monsters.",
        "",

        "v0.2.35",
        "- Shop saving nodes now reduce shop item price by 2-3 coins (from 2-4), and have reduced chance to proc.",
        "- Added some missing modifier descriptions to the Active Modifiers list.",
        "",

        "v0.2.34",
        "- XP from blowing up tinted rocks is now affected by xp gain bonuses.",
        "- Reworked how Chronicler Stone (ancient jewel) calculates needed rooms, and should no longer break",
        "when using Death Certificate.",
        "- Crimson Warpstone should now turn newly generated collectibles into cracked keys, in the appropriate",
        "room types (treasure, shop, angel).",
        "- \"Spawn hovering static tears on monster death\" jewel modifier: if the monster is frozen, it'll now only",
        "spawn the tears if destroyed far away from the player.",
        "- Fixed Eden's Chaotic Treasury node being able to remove progression items, not proccing in XL floors, and",
        "removing active item pedestals when swapped.",
        "- Fixed Relearning not triggering on run victory.",
        "",

        "v0.2.33",
        "- Nullstone (ancient jewel) now nullifies the highest hp enemy in each room instead of the first.",
        "- Reworked Crimson Warpstone (ancient jewel).",
        "- Cracked Keys no longer trigger most card-related modifiers.",
        "- Adjusted Chronicler Stone (ancient jewel) debuff and room requirement.",
        "- Monster on-kill effects no longer proc from friendly monster deaths, including xp gain.",
        "- Fixed \"status effects are cleansed from monsters\" jewel modifier turning friendly monsters",
        "into enemies.",
        "",

        "v0.2.32",
        "- Baubleseeker (ancient jewel) now spawns a chest if it replaces an item pedestal in a challenge room.",
        "- Sanguinis (ancient jewel) now prevents black candle from showing up.",
        "- Opalescent Purity (ancient jewel) no longer removes other floor items when grabbing progression items.",
        "- Opalescent Purity should now only trigger when colliding with item pedestals or purchasing items,",
        "instead of any item addition.",
        "- Fixed certain socketed jewels not being unsocketed when pressing respec from the inventory.",
        "- Fixed familiar-related effects triggering multiple times, such as +luck per familiar.",
        "- Fixed cracked/red key creating spiked doors in curse rooms even if the \"Chance to replace spiked",
        "doorways with regular ones.\" modifier was active.",
        "- Fixed Apollyon's Eraser nodes' name and proc condition.",
        "- Fixed error when picking Tainted Lazarus on Cosmic Realignment.",
        "- Fixed certain level/room/curse init effects carrying over to new runs even after deactivating",
        "them from the tree, e.g. unsocketing Sanguinis (ancient jewel) could still apply the curse.",
        "",

        "v0.2.31",
        "- Added a new Ancient Jewel: \"Nullstone\".",
        "",

        "v0.2.30",
        "- Version jump to attempt workshop auto update.",
        "",

        "v0.2.29",
        "- Added global XP and levels, separate from character levels.",
        "    - Global levels are the source of global skill points now, instead of character levels.",
        "- Crimson Warpstone (ancient jewel) now affects items in angel rooms as well.",
        "- Saturnian Luminite (ancient jewel) now has the following modifier:",
        "\"If you don't have flight, grants wings and -15% speed.\"",
        "- Fixed familiar on-hit/kill modifiers affecting inactive/dead enemies and blood puppy.",
        "- Fixed spending skill points/respecs mid-run causing 'on new room' or 'on new level' effects",
        "to stop triggering at all until quitting then continuing the run.",
        ""
    }

    for idx, tmpLine in ipairs(changelog) do
        if tmpLine == PST.modVersion then
            ---@diagnostic disable-next-line: assign-type-mismatch
            changelog[idx] = {tmpLine .. " (Current)", KColor(0.7, 1, 0.9, 1)}
        end
    end
    return changelog
end