function PST:getChangelogList()
    local changelog = {
        "(You can disable this popup on new versions through Mod Config Menu Pure in-game)",
        "",

        "v0.2.34",
        "- XP from blowing up tinted rocks is now affected by xp gain bonuses.",
        "- Reworked how Chronicler Stone (ancient jewel) calculates needed rooms, and should no longer break",
        "when using Death Certificate.",
        "- Crimson Warpstone should now turn newly generated collectibles into cracked keys, in the appropriate",
        "room types (treasure, shop, angel).",
        "- \"Spawn hovering static tears on monster death\" jewel modifier: if the monster is frozen, it'll now only",
        "spawn the tears if destroyed far away from the player.",
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
        "",

        "v0.2.28",
        "- Crimson Warpstone: chance to drop Cracked Keys on room clear now gains a bonus from the",
        "Womb and onwards. Bonus doesn't apply while in the ascent or in red rooms themselves.",
        "- Adjusted modifiers that turn monsters into champions:",
        "    - Global tree champion modifiers can only affect monsters that regularly become champions.",
        "    - Jewel champion modifiers can affect all normal monsters, but only bosses with regular variants.",
        "- Fixed Cursed Starpiece (ancient jewel) converting progression items such as key pieces, polaroid, etc.",
        "- Fixed shop restocked items becoming cracked keys, even without Crimson Warpstone.",
        "",

        "v0.2.27",
        "- Added changelog list & popup to tree screen.",
        "- Crimson Warpstone no longer converts progression items.",
        "- Shop restocks while using Crimson Warpstone now properly replace new items with cracked keys.",
        "- Cracked keys in shops can no longer be affected by \"shop saving\" nodes.",
        "- Old jewel regen mods should no longer work on Gideon.",
        "- Gideon is now excluded from all mob on-damage checks.",
        "",

        "v0.2.26",
        "- Added a new Ancient Jewel: \"Saturnian Luminite\".",
        "- Fixed Glace (ancient jewel) sprite frame.",
        "",

        "v0.2.25",
        "- Added a new Ancient Jewel: \"Crimson Warpstone\".",
        "",

        "v0.2.24",
        "- Rebalanced jewel drop rates.",
        "- Optimized calls to player, room and level fetching, and random procs. Might help performance a bit.",
        "- Blood Puppy no longer triggers monster on-death effects.",
        "- Fixed certain gamebreaking effects still affecting Gideon, such as more HP or Soul Eater.",
        "- Fixed jewels dropping multiple times in challenge rooms when using Challenger's Starpiece.",
        "",

        "v0.2.23",
        "- Added a new large node to the tree: \"Spider Mod!\".",
        "- The \"Chance to reroll active items into random passive items, if you're holding an active item.\"",
        "modifier should now correctly affect shop items.",
        "- Adjusted door-opening modifiers (such as challenge room and curse room ones), these",
        "should no longer turn doors in different rooms to normal doors.",
        "- Fixed active shop/devil deal items getting rerolled and becoming free.",
    }

    for idx, tmpLine in ipairs(changelog) do
        if tmpLine == PST.modVersion then
            ---@diagnostic disable-next-line: assign-type-mismatch
            changelog[idx] = {tmpLine .. " (Current)", KColor(0.7, 1, 0.9, 1)}
        end
    end
    return changelog
end