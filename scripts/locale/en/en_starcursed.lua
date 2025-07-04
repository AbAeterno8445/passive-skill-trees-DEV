return {
    ---- STARCURSED ----
    -- CRIMSON JEWELS --
    ["jewel_mobHP"] = "Normal monsters have an additional %d HP.",
    ["jewel_bossHP"] = "Boss monsters have an additional %d HP.",
    ["jewel_mobHPPerc"] = "Normal monsters have %d%% increased HP.",
    ["jewel_champHPPerc"] = "Champion monsters have %d%% increased HP.",
    ["jewel_bossHPPerc"] = "Boss monsters have %d%% increased HP.",
    ["jewel_mobDmgReduction"] = "Monsters have %d%% damage reduction.",
    ["jewel_statusCleanse"] = "Every %d seconds in a room, status effects are cleansed from monsters.",
    ["jewel_mobBlock"] = "%d%% chance for monsters to block incoming damage.",
    ["jewel_mobRegen"] = "Normal monsters regenerate %d HP every %d seconds.",
    ["jewel_bossRegen"] = "Boss monsters regenerate %d HP every %d seconds.",
    ["jewel_championHealers"] = "Champion monsters heal 15%% of nearby non-champion monsters' HP every %d seconds.",
    ["jewel_mobOneShotProt"] = "Monsters have one-shot protection.",
    ["jewel_mobExplosionDR"] = "Monsters receive %d%% less damage from explosions.",
    ["jewel_mobFirstBlock"] = "Monsters block the first %d hits they receive.",
    ["jewel_mobPeriodicShield"] = "Monsters receive no damage for 2 seconds every 10 seconds.",

    -- AZURE JEWELS --
    ["jewel_mobTurnChampion"] = "Normal monsters have a %d%% chance to become champions when entering a room.",
    ["jewel_mobExtraHitDmg"] = "Normal non-champion monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting.",
    ["jewel_champExtraHitDmg"] = "Champion monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting.",
    ["jewel_bossExtraHitDmg"] = "Boss monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting.",
    ["jewel_soulHeartsOnHit"] = "Monsters have a %d%% chance to remove 1/2 soul/black hearts when hitting players.",
    ["jewel_hoveringTearsOnDeath"] = "Non-boss monsters spawn %d static hovering tear(s) on death that last %d seconds.",
    ["jewel_tearExplosionOnDeath"] = "Monsters have a %d%% chance to release %d tears on death.",
    ["jewel_mobDuplicate"] = "Non-boss monsters have a %d%% chance of being duplicated when entering a room.",
    ["jewel_mobSlowOnHit"] = "Monsters have a %d%% chance to slow you on hit for 2 seconds.",
    ["jewel_mobReduceDmgOnHit"] = "Monsters have a %d%% chance on hit to reduce your damage by 20%% for 3 seconds.",
    ["jewel_roomMobExtraDmgOnHit"] = "When you get hit by a monster, the next %d hits in the room will deal an additional 1/2 heart damage.",

    -- VIRIDIAN JEWELS --
    ["jewel_floorCurse"] = "%d%% additional chance to receive a random curse when entering a floor.",
    ["jewel_trollBombOnClear"] = "%d%% chance to spawn an additional troll bomb at the center of the room on clear.",
    ["jewel_loseCoinsOnSpend"] = "Whenever you lose or spend coins, %d%% chance to lose an additional %d coin(s).",
    ["jewel_lessDevilRoomChance"] = "-%d%% additional chance to find the devil/angel room.",
    ["jewel_lessSpeed"] = "-%.2f speed.",
    ["jewel_lessDamage"] = "-%.2f damage.",
    ["jewel_lessLuck"] = "-%.2f luck.",
    ["jewel_pickupsVanish"] = "%d%% chance for coins, keys or bombs to vanish on pickup.",
    ["jewel_pickupScarcity"] = "%d%% coin, key and bomb scarcity.",
    ["jewel_heartsVanish"] = "%d%% chance for heart pickups to vanish when collected.",
    ["jewel_heartScarcity"] = "%d%% heart pickup scarcity.",
    ["jewel_shopExpensive"] = "Shop items cost %d more coins. Doesn't affect pickups.",
    ["jewel_itemPoolRemoval"] = "When starting a run, remove %d random item(s) of quality %d from all item pools.",
    ["jewel_shopExpensivePickups"] = "Shop items cost %d more coins. Affects pickups.",

    ["jewel_xpgain"] = "+%d%% xp gain while equipped.",
    ["jewel_halveXPFirstFloor"] = "XP bonus from this jewel is halved on the first floor.",
    ["jewel_deliriumRewards"] = "Gain %d global SP and %d respecs when defeating Delirium with this jewel equipped.",
    ["jewel_beastRewards"] = "Gain %d global SP and %d respecs when defeating The Beast with this jewel equipped.",

    ["jewel_noGreedWarn"] = "This jewel can't be used in Greed Mode.",
    ["jewel_unidPrompt"] = "Unidentified. Press Allocate to identify and reveal modifiers.",

    ["jewel_fadedStarpiece_desc"] = "This jewel's energy has almost faded out...",

    -- ANCIENT JEWELS --
    ["jewel_Faded Starpiece"] = "Faded Starpiece",

    ["jewel_Circadian Destructor"] = "Circadian Destructor",
    ["jewel_Circadian Destructor_desc"] = {
        "Every 48 seconds, trigger XVI - The Tower's effect if you're in a room with monsters.",
        "Whenever XVI - The Tower's effect is triggered, monsters become immune to explosions for 4 seconds."
    },

    ["jewel_Umbra"] = "Umbra",
    ["jewel_Umbra_desc"] = {
        "Guarantees Curse of Darkness if applicable.",
        "Black Candle can no longer show up.",
        "While Curse of Darkness is active, -2% all stats when first entering a room, up to -20%",
        "16% chance to spawn a Night Light when clearing a room, once per floor.",
        "Remove Night Light when entering a new floor."
    },

    ["jewel_Gaze Averter"] = "Gaze Averter",
    ["jewel_Gaze Averter_desc"] = {
        "Start with Tiny Planet and My Reflection.",
        "-2 damage and -10 range.",
        "Deal 75% less damage to enemies located in the side of the room you're currently facing."
    },

    ["jewel_Cursed Starpiece"] = "Cursed Starpiece",
    ["jewel_Cursed Starpiece_desc"] = {
        "Starting from the second floor, all treasure rooms contain a Reversed Stars card",
        "instead of item pedestals.",
        "Starting from the second floor, -12% all stats for the current floor while you",
        "haven't used Reversed Stars. Apply -6% instead if the floor doesn't have a treasure room.",
        "Reversed Stars has a 100% chance to remove an additional item. If used in a treasure",
        "room, lower this chance to 35%."
    },

    ["jewel_Opalescent Purity"] = "Opalescent Purity",
    ["jewel_Opalescent Purity_desc"] = {
        "Once you pick up or purchase a collectible item, remove all other items in the floor,",
        "including those spawned by effects."
    },

    ["jewel_Iridescent Purity"] = "Iridescent Purity",
    ["jewel_Iridescent Purity_name"] = {
        "Each passive item you pick up has a 15% chance to be removed when entering the next floor.",
        "Chance increases by 15% individually for each item picked in the current floor."
    },

    ["jewel_Challenger Starpiece"] = "Challenger's Starpiece",
    ["jewel_Challenger Starpiece_desc"] = {
        "When entering a floor, teleport to the challenge room.",
        "When first entering a challenge room, drops a key if there are only locked chests, or a bomb if only stone chests.",
        "Your damage is halved while outside the challenge room if the latter isn't cleared.",
        "A random deadly sin miniboss spawns after clearing the final round in challenge rooms.",
        "From the 7th floor onwards, spawn a random super deadly sin instead."
    },

    ["jewel_Soul Watcher"] = "Soul Watcher",
    ["jewel_Soul Watcher_desc"] = {
        "When you enter a room with monsters, a random monster becomes a Soul Eater.",
        "Non-boss Soul Eater monsters have 20% increased HP.",
        "Soul Eater monsters gain 4 HP, 4% HP and 2% speed when a nearby monster dies, up to 20 times.",
        "Bosses are Soul Eaters, and spawn an attack fly every 10 seconds."
    },

    ["jewel_Luminescent Die"] = "Luminescent Die",
    ["jewel_Luminescent Die_desc"] = {
        "After clearing the floor's boss room, spawn a Reversed Wheel of Fortune card.",
        "Entering the next floor without using a Reversed Wheel of Fortune card grants -10% all stats,",
        "up to -40%.",
        "Active debuff gets halved when using a Reversed Wheel of Fortune card."
    },

    ["jewel_Baubleseeker"] = "Baubleseeker",
    ["jewel_Baubleseeker_desc"] = {
        "All collectible items are replaced with a random trinket. Shop trinkets cost 3 more coins than usual.",
        "10% chance for treasure rooms to contain Mom's Box if you don't currently",
        "have it, protected from trinket replacement.",
        "Smelt trinkets on pickup.",
        "+1% all stats per smelted trinket, up to 15%."
    },

    ["jewel_Chronicler Stone"] = "Chronicler Stone",
    ["jewel_Chronicler Stone_desc"] = {
        "Every floor, a certain amount of rooms must be explored.",
        "When entering the next floor, if you've explored less than the ordained amount, receive -4% all stats",
        "per unexplored room, up to a total -50%.",
        "Grabbing book items for the first time halves your current debuff from this effect, if present."
    },

    ["jewel_Sanguinis"] = "Sanguinis",
    ["jewel_Sanguinis_desc"] = {
        "Start with an additional broken heart.",
        "When entering a floor, gain a broken heart if you have less than 4 broken hearts.",
        "Taking damage has a 40% chance of granting a broken heart, once per floor. Halve this chance",
        "during the Ascent.",
        "Defeating the floor's boss without taking damage removes a broken heart."
    },

    ["jewel_Martian Ultimatum"] = "Martian Ultimatum",
    ["jewel_Martian Ultimatum_desc"] = {
        "Start with Mars as an innate effect.",
        "Every 4 to 8 seconds while in a room with monsters, spawn a pattern of static harmless tears around you.",
        "After 2 seconds, the tears fire towards your direction, dealing contact damage.",
        "-0.05 speed when hit, up to -0.25. Resets every room."
    },

    ["jewel_Crimson Warpstone"] = "Crimson Warpstone",
    ["jewel_Crimson Warpstone_desc"] = {
        "Replace treasure room, shop and angel room items with Cracked Keys.",
        "Allows Cracked Keys to stack by picking more up while having one.",
        "35% base chance to drop a Cracked Key when clearing a room, which increases every floor.",
        "-15% chance to drop a Cracked Key for the current room when you get hit.",
        "-30% all stats. Entering a red room reduces this debuff by 2.5%. Resets every floor.",
        "Entering an ultra secret room halves the current debuff."
    },

    ["jewel_Glace"] = "Glace",
    ["jewel_Glace_desc"] = {
        "Start with Uranus and a smelted Ice Cube.",
        "-50% speed and tears. Destroying a frozen enemy reduces this debuff by 0.5%. Resets every floor."
    },

    ["jewel_Saturnian Luminite"] = "Saturnian Luminite",
    ["jewel_Saturnian Luminite_desc"] = {
        "Start with Saturnus and Spear of Destiny.",
        "Cannot shoot tears, and base damage is set to 0.25.",
        "If you don't have flight, grants wings and -15% speed.",
        "Every 4 seconds while in a room with monsters, reset Saturnus' ring of tears."
    },

    ["jewel_Nullstone"] = "Nullstone",
    ["jewel_Nullstone_desc"] = {
        "The enemy with the highest HP you kill in each room gets temporally nullified.",
        "When entering the boss room, spawn the first enemy you nullified.",
        "When killing a nullified enemy in the boss room, spawn the next one in the sequence."
    },

    ["jewel_Nightmare Projector"] = "Nightmare Projector",
    ["jewel_Nightmare Projector_desc"] = {
        "When first entering a room with monsters, trigger the Reverse High Priestess card effect.",
        "Once first triggered, card effect triggers again every 2 minutes."
    },

    ["jewel_Twisted Emperor's Heirloom"] = "Twisted Emperor's Heirloom",
    ["jewel_Twisted Emperor's Heirloom_desc"] = {
        "Starting from the second floor, spawn a Reverse Emperor card in the first room.",
        "Entering the next floor without defeating the Reverse Emperor boss grants -12% all stats, up to -48%.",
        "Reverse Emperor boss item rewards are replaced with locked chests before the Womb.",
        "After the Womb, Reverse Emperor bosses reward no items."
    },

    ["jewel_Cursed Auric Shard"] = "Cursed Auric Shard",
    ["jewel_Cursed Auric Shard_desc"] = {
        "Start with Card Reading as an innate effect.",
        "When clearing a room, 90% chance to trigger Teleport 2.0's effect.",
        "Teleport effect doesn't trigger in certain rooms, such as boss, devil/angel, or curse rooms.",
        "After defeating the floor's boss, your minimum speed becomes 1.6 in cleared rooms and the teleport",
        "effect stops triggering."
    },

    ["jewel_Unusually Small Starstone"] = "Unusually Small Starstone",
    ["jewel_Unusually Small Starstone_desc"] = {
        "Start with Pluto as an innate effect.",
        "-30% damage and -0.7 tears.",
        "When entering a room, split all monsters in two if possible."
    },

    ["jewel_Primordial Kaleidoscope"] = "Primordial Kaleidoscope",
    ["jewel_Primordial Kaleidoscope_desc"] = {
        "Start with Playdough Cookie and Fruit Cake as innate effects.",
        "Start with a smelted Rainbow Worm.",
        "-3 luck.",
        "Deal half as much damage to enemies that aren't affected by status effects.",
        "Hitting bosses reduces their status effect cooldown by 0.5 seconds."
    },

    ["jewel_Teprucord Tenican Eljwe"] = "Teprucord Tenican Eljwe",
    ["jewel_Teprucord Tenican Eljwe_desc"] = {
        "%@%#%5)$@!TMTRAINER%$#9^(_@MISSINGNO.$%#36_#()$",
        "%((ROOM).ENTER)^$@^%[..40%]$&DATAMINER%$@^&EFFECT%$#^_&"
    },

    ["jewel_Cause Converter"] = "Cause Converter",
    ["jewel_Cause Converter_desc"] = {
        "Jewel status: Seeking",
        "While the jewel is equipped and in Seeking status, defeating a boss will convert it to your cause.",
        "Unequip the jewel to stop converting further bosses.",
        "Starting a run with a converted boss switches the jewel status to Converted, revealing its modifiers.",
        "Certain bosses are excluded from conversion, and successful conversions are shown with a text",
        "indicator in-game.",
        "Can be equipped mid-run to start/continue converting bosses."
    },
    ["jewel_Cause Converter_descConv"] = {
        "Jewel status: Converted",
        "Spawn a friendly version of the converted boss when entering a room.",
        "-80% tears.",
        "If the converted boss dies, it respawns after 10 seconds.",
        "Converted boss inherits 10% of your damage, which increases every floor.",
        "Press the Respec input while in the inventory to reset the jewel status back to Seeking."
    },

    ["jewel_Glowing Glass Piece"] = "Glowing Glass Piece",
    ["jewel_Glowing Glass Piece_desc"] = {
        "When entering a previously cleared room, trigger D7's effect. Can only happen once per room.",
        "Respawned monsters gain 5 HP, then +5% HP. These values increase by 2 each floor.",
        "Respawned monsters grant no xp.",
        "When entering a floor, -6% all stats if the above effect hasn't triggered 3 or more times in",
        "the previous floor, up to -30%."
    },

    ["jewel_Tellurian Splinter"] = "Tellurian Splinter",
    ["jewel_Tellurian Splinter_desc"] = {
        "Start with Terra.",
        "-1.5 damage and -50% speed.",
        "Gain +1% speed when destroying bomb rocks, up to 35%.",
        "Halve your current speed buff when entering a new floor.",
        "Rocks in rooms have a 20% chance of being replaced with bomb rocks."
    },

    ["jewel_Astral Insignia"] = "Astral Insignia",
    ["jewel_Astral Insignia_desc"] = {
        "Guarantee a Planetarium every 2 floors, starting from the second one you enter.",
        "When grabbing a Planetarium item, remove your old Planetarium item if you have one.",
        "-2% all stats when first entering a normal room, up to -60%.",
        "Debuff stops applying during the Ascent.",
        "Entering a Planetarium halves your current debuff."
    },

    ["jewel_Mightstone"] = "Mightstone",
    ["jewel_Mightstone_desc"] = {
        "Start with Champion's Belt.",
        "+50% chance for monsters to become champions.",
        "Champion monsters have 15% increased HP.",
        "When killing a champion monster, buff all other champion monsters in the room, increasing",
        "their HP by 10% and speed by 5%, and increasing their size, up to 5 times per room."
    },

    ["jewel_Crystallized Anamnesis"] = "Crystallized Anamnesis",
    ["jewel_Crystallized Anamnesis_desc"] = {
        "Start with Purity. -50% effectiveness of Purity aura stat ups.",
        "Start with Chaos as an innate effect.",
        "Collected passive pedestal items are stored into each Purity aura based on their source item pool.",
        "Items that aren't included in the current Purity aura color's pool are removed.",
        "Collecting an item switches Purity to its corresponding item pool aura.",
        "Collecting a Devil item grants you a random Angel item, and vice versa.",
        "While Purity's aura is inactive, disable all items.",
        "Once lost, Purity's aura is restored after 7 seconds as a random color."
    },

    ["jewel_Embered Azurite"] = "Embered Azurite",
    ["jewel_Embered Azurite_desc"] = {
        "Item pedestals switch between a red pool and a blue pool item.",
        "-8% all stats per difference between total collected blue and red passive items, up to -64%."
    },

    ["jewel_Glittering Starstone"] = "Glittering Starstone",
    ["jewel_Glittering Starstone_desc"] = {
        "Start with Soy Milk and Head of the Keeper.",
        "-50% damage, +1% damage per coin you have.",
        "Your max coin count is now 50.",
        "Purchasing an item increases this cap by half of the item's price for the current floor.",
        "Shop items cost twice as much."
    },

    ["jewel_Shiftstone"] = "Shiftstone",
    ["jewel_Shiftstone_desc"] = {
        "Speed everything up while on the left side of a room.",
        "Slow everything down while on the right side of a room."
    },

    ["jewel_Phantasm Prism"] = "Phantasm Prism",
    ["jewel_Phantasm Prism_desc"] = {
        "When killing a non-boss living enemy, 20% chance to summon a random undead enemy with",
        "a similar base HP value, up to 12 times per room.",
        "This effect does not apply to living enemies spawned after entering the room.",
        "Whenever you get hit by an undead enemy, increase this chance by 4%, up to 50%."
    },

    ["jewel_Arachnite"] = "Arachnite",
    ["jewel_Arachnite_desc"] = {
        "Killing enemies has a 40% chance to spawn 1-5 swarm spiders, up to 12 times per room.",
        "Chance increases by 8% per floor, up to 90%.",
        "Bursting Sack can no longer show up."
    },

    ["jewel_Mistlestone"] = "Mistlestone",
    ["jewel_Mistlestone_desc"] = {
        "Treasure room and Planetarium items are replaced with Mystery Gifts.",
        "Mystery gifts can only be used in boss, angel or devil rooms.",
        "8% chance for Krampus to show up after clearing the boss room per used mystery gift.",
        "+25% chance to find an angel/devil room.",
        "-5% chance to find an angel/devil room whenever you get hit."
    },

    ["jewel_Blazing Carnelian"] = "Blazing Carnelian",
    ["jewel_Blazing Carnelian_desc"] = {
        "Orange fireplaces are replaced with red fireplaces.",
        "Blue fireplaces are replaced with purple fireplaces.",
        "Rocks have a 15% chance to be replaced with a red fireplace when first entering a room.",
        "Hot Bombs and Pyromaniac can no longer show up."
    },

    ["jewel_Cat's-Eye Prism"] = "Cat's-Eye Prism",
    ["jewel_Cat's-Eye Prism_desc"] = {
        "Start with 2 smelted Kid's Drawings and Guppy's Eye.",
        "-50% damage.",
        "Monsters take 90% reduced damage from sources other than blue flies."
    },

    ["jewel_Labyrinth Stone"] = "Labyrinth Stone",
    ["jewel_Labyrinth Stone_desc"] = {
        "Guarantee Curse of the Labyrinth on every floor if possible, along with its natural curses."
    },
}