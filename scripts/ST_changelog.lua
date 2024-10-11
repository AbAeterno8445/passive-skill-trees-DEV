function PST:getChangelogList()
    local changelog = {
        "(You can disable this popup on new versions through Mod Config Menu Pure in-game)",
        "",

        "v0.3.23",
        "- Refactored the entirety of the tree rendering code, in preparation for future features.",
        "It should all work the same as before, but reporting any issues you find would be of great help.",
        "- Reworked the help screen (opened with H / Select) to provide additional info about the mod's",
        "features. More info will be added to this screen as new features emerge.",
        "",

        "v0.3.22",
        "- Fixed Ancient Starcursed Jewel completion rewards not being granted.",
        "",

        "v0.3.21",
        "- Optimized savefile size.",
        "- Introduced a savefile backup system. If data loss is detected and backups are present, a prompt will appear when",
        "opening the tree that will allow you to pick one of the existing backups to try and load. Activating this system",
        "requires downloading a DLL from the mod's workshop page.",
        "- Fixed Coalescing Soul (from tainted char trees) dropping random soul stones for the Siren character.",
        "- Fixed potential error when triggering Coalescing Soul.",
        "- Fixed cursed room door sprite in secret rooms when blowing up the adjacent wall.",
        "",

        "v0.3.20",
        "- Fixed stack overflow error on run start when the Epiphany mod was enabled.",
        "- Fixed Blue Baby's \"Blue Gambit\" affecting non-cards (such as runes) before they got spawned.",
        "",

        "v0.3.19",
        "- Adjusted player cache update on run init to avoid potential issues.",
        "",

        "v0.3.18",
        "- Fixed T. Siren's \"Soul of the Siren\" node not being allocatable.",
        "",

        "v0.3.17",
        "- Introduced new character skill trees for: Tainted Siren.",
        "- Tainted Siren's tree includes a node that allows unlocking a new Soul Stone, Soul of the Siren.",
        "- Added an option to have T. Siren sing when using Manifest Melody.",
        "- Embered Azurite (ancient jewel) should now affect active item pedestals or shop items.",
        "- Fixed double red heart pickups not triggering red heart on-pickup effects.",
        "",

        "v0.3.16",
        "- Birthright now spawns the alternate Dark Esau while \"Reaper Wraiths\" is allocated (for T. Jacob).",
        "- Fixed T. Jacob's \"Reaper Wraiths\" allowing Dark Esau's flames to damage you.",
        "- Fixed T. Jacob's Anima Sola repeats being able to keep chaining after all mobs in the room were affected.",
        "- Fixed error with T. Jacob's \"Wrathful Chains\" when damaging chained enemies near other chained enemies.",
        "",

        "v0.3.15",
        "- Introduced new character skill trees for: Tainted Jacob.",
        "- Victory laps now apply an XP gain penalty, starting at -60% on the first, increasing by 10% on further laps, up to",
        "a maximum -95%.",
        "- T. Lost's \"Death's Trial\" nodes should no longer trigger when secondary players die, such as when using Soul of",
        "the Forgotten.",
        "- Fixed Blue Baby's \"Blue Gambit\" being able to damage you when using non-card pocket consumables. Additionally,",
        "it now no longer damages you when using reverse cards.",
        "- Fixed T. Lost's \"Spin-down\" removing Spindown dice if re-obtained.",
        "",

        "v0.3.14",
        "- Fixed T. Bethany's \"Resilient Flickers\" reducing birthright wisps' HP and size on proc.",
        "",

        "v0.3.13",
        "- Optimized overall saving frequency throughout the mod, which should improve performance.",
        "",

        "v0.3.12",
        "- Introduced new character skill trees for: Tainted Forgotten and Tainted Bethany.",
        "- Tellurian Splinter (ancient jewel) no longer reduces the speed buff during the Ascent.",
        "- Heart pickup related modifiers now trigger when purchasing hearts from a shop.",
        "- Magdalene's \"Crystal Heart\" now has a 7% chance to turn a red heart into a bone heart (from 4%).",
        "- Samson's boss-related luck nodes have been significantly toned down.",
        "- The Lost's \"Heartseeker Phantasm\" now gives 0.1 luck when collecting a soul/black heart (from 0.2),",
        "up to a total +3, and has its +% all stats capped to a total of +20%",
        "- Apollyon's \"Harbinger Locusts\" no longer has a chance to convert all trinkets to locusts. It now",
        "instead grants a 2% chance for champion monsters to drop a random locust trinket on death, once per floor.",
        "- Modifiers that spawn poop-related items can now only spawn Hallowed Ground once the other options are gone.",
        "- Spiked curse room doors that are removed by the appropriate modifier now visually have their spikes removed,",
        "instead of becoming regular doorways.",
        "- Fixed item pedestals triggering on-pickup effects constantly while the character is 'holding' an item, such",
        "as Bag of Crafting.",
        "- Fixed error when dealing damage with Dark Arts.",
        "",

        "v0.3.11",
        "- Crystallized Anamnesis (ancient jewel) now restores the purity aura immediately after clearing a room",
        "if it was gone.",
        "- Fixed Embered Azurite (ancient jewel) affecting active item pedestals.",
        "- Fixed T. Lost's quality upgrade nodes being able to affect progression items.",
        "",

        "v0.3.10",
        "- Introduced new character skill trees for: Tainted Keeper and Tainted Apollyon.",
        "- Added 2 new Ancient Jewels: \"Crystallized Anamnesis\" (experimental) and \"Embered Azurite\".",
        "- Fixed modifiers requiring a boss room to be cleared without taking damage potentially not triggering.",
        "- Fixed T. Lost's \"Minimum luck is -1\" modifier applying globally regardless of allocation.",
        "- Fixed T. Isaac's \"Consuming Void\" being able to remove progression items, such as knife pieces.",
        "- Fixed Apollyon's \"Harbinger Locusts\" occasionally spawning golden locusts.",
        "- Fixed locust trinket familiars being considered blue flies for relevant effects.",
        "- Fixed certain on-kill effects not triggering.",
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
    }

    for idx, tmpLine in ipairs(changelog) do
        if type(tmpLine) == "string" and tmpLine == PST.modVersion then
            ---@diagnostic disable-next-line: assign-type-mismatch
            changelog[idx] = {tmpLine .. " (Current)", KColor(0.7, 1, 0.9, 1)}
        end
    end
    return changelog
end