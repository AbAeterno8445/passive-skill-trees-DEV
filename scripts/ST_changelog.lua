function PST:getChangelogList()
    local changelog = {
        "(You can disable this popup on new versions through Mod Config Menu Pure in-game)",
        "v0.2.28",
        "- Fixed Cursed Starpiece (ancient jewel) converting progression items such as key pieces, polaroid, etc.",
        "- Adjusted modifiers that turn monsters into champions:",
        "    - Global tree champion modifiers can only affect monsters that regularly become champions.",
        "    - Jewel champion modifiers can affect all normal monsters, but only bosses with regular variants.",
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