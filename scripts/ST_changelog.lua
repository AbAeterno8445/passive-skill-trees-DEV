function PST:getChangelogList()
    local changelog = {
        "(You can disable this popup on new versions through Mod Config Menu Pure in-game)",
        "",

        "v0.3.2",
        "- Introduced new character skill trees for: Tainted Cain and Tainted Judas.",
        "- Added 2 new Ancient Jewels: \"Cause Converter\" (experimental) and \"Glowing Glass Piece\".",
        "- Added a new large node to the Siren's tree: \"Overwhelming Voice\".",
        "- \"Chance to turn troll and super troll bombs into regular bombs\" modifiers now receive a hidden debuff",
        "after certain events, such as bomb bums, anarchist's cookbook, tower card, etc, reducing its proc chance.",
        "- Reduced total chance for global \"Chance to turn troll and super troll bombs into regular bombs\" modifiers.",
        "- Ancient jewel skill point rewards are no longer given to character trees, and instead are global-only.",
        "- Invulnerable enemies can no longer become champions through tree/jewel effects.",
        "- Fixed some old jewel effects still affecting Gideon.",
        "",

        "v0.3.1",
        "- Added a new ancient jewel...?",
        "- Crimson Warpstone should no longer apply its debuff when entering the Death Certificate dimension.",
        "- Fixed error when using rune shards.",
        "",

        "v0.3.0",
        "- Introduced new character skill trees for: Tainted Isaac and Tainted Magdalene.",
        "- New global tree large node: \"Eldritch Mapping\".",
        "- New global node type: \"Troll Bomb Disarm\".",
        "- Added 3 new Ancient Jewels: \"Cursed Auric Shard\", \"Unusually Small Starstone\" and \"Primordial Kaleidoscope\".",
        "- \"Tears on first obtaining a passive item\" node now grants 0.015 tears per item (from 0.03).",
        "- Sources of all stats and % all stats no longer affect luck.",
        "- Rebalanced total luck granted by the global tree.",
        "- Rebalanced luck-related nodes in most if not all character trees.",
        "",
        "- Rebalanced certain character tree nodes:",
        "  > Blue Baby's \"Slipping Essence\": now grants -0.6 luck on proc (from -0.1).",
        "  > Eve's \"Carrion Avian\": permanent bonus from boss kills now has a proc limit of twice per room.",
        "  > Azazel's \"Blood Charge\": now grants +5 range (from +6), and -35% tears (from -30%).",
        "  > Lazarus' \"King's Curse\": now grants -10% all stats while not Lazarus Risen (from -5%), and -1 luck while",
        "not Lazarus Risen.",
        "  > Keeper's \"Keeper's Blessing\": now grants 1 coin on coin heal (from 2).",
        "  > Keeper's \"Avid Shopper\": coin loss should now only trigger on monster hits instead of all damage.",
        "  > Jacob & Esau's \"Statue Pilgrimage\": now grants +12% all stats to Jacob (from +7%).",
        "",
        "- Adjusted jewel modifiers:",
        "  > Viridian jewels' \"Shop items cost more coins\" now doesn't affect pickups.",
        "  > New mighty-only Viridian jewel modifier \"Shop items cost more coins. Affects pickups.\".",
        "  > Monster HP and Boss HP modifiers are now half as effective for Larry Jr.",
        "",
        "- Bishop monsters can no longer be turned into champions from jewel effects.",
        "- Lucky penny conversion modifiers should now affect vanishing coins correctly.",
        "- Lucky penny conversion modifier chances are now reduced by ~67% when playing as Tainted Keeper.",
        "- Blended hearts should now trigger soul and red heart on-pickup effects.",
        "- Fixed Blue Baby's \"Brown Blessing\" being able to proc in the first floor.",
        "",

        "v0.2.44",
        "- Added data check when saving to prevent errors under certain conditions.",
        "",

        "v0.2.43",
        "- \"Natural curse cleanse\" nodes now have a text pop up on proc.",
        "- Fixed game restart when opening the tree in-game while playing in certain non-english languages.",
        "",

        "v0.2.42",
        "- Optimized node links' sprite loading internally.",
        "- Spider Mod node now applies Spider Mod innately, preventing it from being re-rolled or",
        "counting as an inventory item e.g. for Tainted Isaac.",
        "",

        "v0.2.41",
        "- Non-ancient jewel inventories now have a limit, currently set to 90 jewels.",
        "- Sanguinis (ancient jewel) should now only trigger on monster hits.",
        "- Sanguinis' chance to receive a broken heart on hit is now halved during the Ascent.",
        "- Twisted Emperor's Heirloom should now account for random teleports from rev emperor, and grant",
        "no debuffs if this happens.",
        "- Fixed active items triggering \"+stat when first picking up a passive item\" modifiers.",
        "",

        "v0.2.40",
        "- Added further checks to prevent Twisted Emperor's Heirloom from turning unintended items into chests.",
        "- Adjusted spawn position of Eden's Chaotic Treasury items. Their hitbox is now also smaller to prevent",
        "forced pickups in certain room layouts.",
        "",

        "v0.2.39",
        "- Fixed Twisted Emperor's Heirloom (ancient jewel) replacing items with chests in unintended rooms.",
        "- While using Twisted Emperor's Heirloom, bosses from rev emperor now reward no items after entering",
        "the Womb.",
        "",

        "v0.2.38",
        "- Soul Watcher should no longer function on friendly monsters.",
        "- Fixed floating texts' position when playing as Tainted Lazarus.",
        "- Fixed boss rush being able to drop multiple jewels if somehow going past wave 15.",
        "",

        "v0.2.37",
        "- Added 2 new Ancient Jewels: \"Nightmare Projector\" and \"Twisted Emperor's Heirloom\".",
        "- Reworked Sanguinis (ancient jewel).",
        "- Soul Watcher xp gain lowered to 70% (from 85%).",
        "- Dispersed boss challenge room and trinket smelting nodes in global tree.",
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
        ""
    }

    for idx, tmpLine in ipairs(changelog) do
        if type(tmpLine) == "string" and tmpLine == PST.modVersion then
            ---@diagnostic disable-next-line: assign-type-mismatch
            changelog[idx] = {tmpLine .. " (Current)", KColor(0.7, 1, 0.9, 1)}
        end
    end
    return changelog
end