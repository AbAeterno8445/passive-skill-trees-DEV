function PST:getChangelogList()
    local changelog = {
        "(You can disable this popup on new versions through Mod Config Menu Pure in-game)",
        "",

        "v0.3.9",
        "- Fixed Knife Pieces 1 & 2 not being considered progression items by item re-rolling modifiers.",
        "- Fixed Unusually Small Starstone (ancient jewel) not triggering at all.",
        "",

        "v0.3.8",
        "- Introduced new character skill trees for: Tainted Lost and Tainted Lilith.",
        "- Minimum XP multiplier option is now 0.1 (from 0.3).",
        "- Potential fix for on-kill effects sometimes not triggering if multiple damage-modifying on-hit effects were present.",
        "- Fixed Eden's \"Starblessed\" dropping a second stars card when defeating the boss of the first alt stage.",
        "- Fixed Eden's \"Chaotic Treasury\" triggering in unintended treasure rooms, such as in the mirror world.",
        "- Fixed Eden's \"Chaotic Treasury\" removing other items when colliding with a priced item that you couldn't afford.",
        "- Fixed player on-hit effects potentially not triggering while Cause Converter (ancient jewel)'s boss was active.",
        "- Fixed Unusually Small Starstone (ancient jewel) splitting friendly monsters.",
        "- Fixed Eve's \"Dead bird deals an additional % of your damage per tick\" modifiers not working if you didn't have",
        "Carrion Avian allocated.",
        "- Fixed tree inputs no longer working for re-connected controllers.",
        "",

        "v0.3.7",
        "- Introduced new character skill trees for: Tainted Lazarus and Tainted Eden.",
        "- Tainted Samson's \"Absolute Rage\" now has an additional bonus when obtaining Birthright.",
        "- Deadly Sin minibosses can no longer become champions through jewel effects.",
        "- Potential fix for Cause Converter (ancient jewel) not displaying converted mod boss names.",
        "- Challenger's Starpiece (ancient jewel) now respawns the Stairway item's ladder when first returning to the first room.",
        "- Fixed T. Isaac's \"Chance for items consumed by Black Runes to be gained as innate items\" being guaranteed, regardless of",
        "having the relevant nodes allocated.",
        "- Fixed T. Cain's additional pedestal pickup nodes triggering when standing on shop items, even if you couldn't afford them.",
        "- Fixed Cosmic Realignment + Tainted Lazarus potentially not updating heart banks correctly.",
        "- Fixed monster tear hits not triggering player on-hit effects.",
        "- Fixed fireplaces triggering monster on-hit effects when damaging you.",
        "",

        "v0.3.6",
        "- Introduced new character skill trees for: Tainted Samson and Tainted Azazel.",
        "- Saturnian Luminite no longer prevents shooting during the mineshaft chase sequence.",
        "- Boss jewel drops no longer spawn on top of reward items.",
        "- Fixed jewel effects potentially not taking place while in the mirror dimension.",
        "",

        "v0.3.5",
        "- Adjusted Eden's Chaotic Treasury to be able to trigger if multiple treasure rooms are present, as",
        "well as in greed mode.",
        "- Added missing and fixed tainted tree modifier descriptions for the 'Active Modifiers' list.",
        "- Fix crash when the \"Active Item Reroll\" modifier on certain room types, such as Libraries.",
        "",

        "v0.3.4",
        "- Introduced new character skill trees for: Tainted Blue Baby and Tainted Eve.",
        "- Added a new Ancient Jewel: \"Mightstone\".",
        "- Reworked the \"Eldritch Mapping\" large global node.",
        "- Pin and variants (such as Wormwood) can no longer be converted with Cause Converter (ancient jewel).",
        "- Adjusted certain jewels to have Esau start with their items.",
        "- Martian Ultimatum (ancient jewel) now applies Mars as an innate effect.",
        "- Cause Converter (ancient jewel) should now store the killed boss' variant properly.",
        "- Cain's \"Impromptu Gambler\" node no longer triggers during the Ascent.",
        "- Lilith's \"Daemon Army\" now has Mom award a third Incubus only if you took no damage throughout the run until then.",
        "- Lazarus' \"King's Curse\" now removes Damocles when entering a floor if you have it, and re-adds it if you don't.",
        "- Fixed Tellurian Splinter (ancient jewel) speed buff increasing instead of decreasing when entering a new floor.",
        "- Fixed Unusually Small Starstone splitting certain game-breaking enemies such as Delirium.",
        "- Fixed certain jewel effects happening during the mineshaft puzzle, hindering the player unintentionally.",
        "- Fixed Cain's \"Impromptu Gambler\" node removing items spawned by cranes when using the latter multiple times.",
        "",

		"v0.3.3",
		"- Fixed error when players dealt direct damage to monsters (e.g. melee hits).",
		"",

        "v0.3.2",
        "- Introduced new character skill trees for: Tainted Cain and Tainted Judas.",
        "- Added 4 new Ancient Jewels: \"Cause Converter\" (experimental), \"Glowing Glass Piece\", \"Tellurian Splinter\" and",
        "\"Astral Insignia\".",
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
    }

    for idx, tmpLine in ipairs(changelog) do
        if type(tmpLine) == "string" and tmpLine == PST.modVersion then
            ---@diagnostic disable-next-line: assign-type-mismatch
            changelog[idx] = {tmpLine .. " (Current)", KColor(0.7, 1, 0.9, 1)}
        end
    end
    return changelog
end