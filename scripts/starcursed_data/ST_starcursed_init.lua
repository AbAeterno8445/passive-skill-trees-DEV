-- 'Conflict functions' run when a modifier is present on more than 1 equipped jewel, and determine what to do for the total value for each roll when considering all equipped jewels
local conflictFuncs = {
    simpleSum = function(roll, targetRoll)
        return roll + targetRoll
    end,
    lowest = function(roll, targetRoll)
        return math.min(roll, targetRoll)
    end,
    highest = function(roll, targetRoll)
        return math.max(roll, targetRoll)
    end
}

PST.SCMods = {
    -- Crimson Starcursed Jewel modifiers
    Crimson = {
        mobHP = {
            weight = 100,
            rolls = {{3, 10}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 8 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Normal monsters have an additional %d HP."
        },
        bossHP = {
            weight = 100,
            rolls = {{30, 60}},
            mightyRolls = {{120, 200}},
            starmightCalc = function(roll) return 10 + math.sqrt(roll) * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Boss monsters have an additional %d HP."
        },
        mobHPPerc = {
            weight = 100,
            rolls = {{5, 12}},
            mightyRolls = {{25, 40}},
            starmightCalc = function(roll) return 8 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Normal monsters have %d%% increased HP."
        },
        champHPPerc = {
            weight = 100,
            rolls = {{7, 11}},
            mightyRolls = {{25, 40}},
            starmightCalc = function(roll) return 9 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Champion monsters have %d%% increased HP."
        },
        bossHPPerc = {
            weight = 100,
            rolls = {{8, 15}},
            mightyRolls = {{25, 40}},
            starmightCalc = function(roll) return 10 + math.ceil(roll * 2) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Boss monsters have %d%% increased HP."
        },
        mobDmgReduction = {
            weight = 100,
            rolls = {{5, 12}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 8 + (roll - 4) * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have %d%% damage reduction."
        },
        statusCleanse = {
            weight = 100,
            rolls = {{8, 10}},
            mightyRolls = {{3, 4}},
            starmightCalc = function(roll) return 7 + (11 - roll) * 2 end,
            onConflict = {conflictFuncs.lowest},
            description = "Every %d seconds in a room, status effects are cleansed from monsters."
        },
        mobBlock = {
            weight = 100,
            rolls = {{1, 4}},
            mightyRolls = {{7, 12}},
            starmightCalc = function(roll) return 10 + roll * 4 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% chance for monsters to block incoming damage."
        },
        mobRegen = {
            weight = 100,
            rolls = {{1, 3}, {8, 10}},
            mightyRolls = {{5, 7}, {6, 7}},
            starmightCalc = function(roll, roll2) return 9 + roll + (12 - roll2) * 2 end,
            onConflict = {conflictFuncs.simpleSum, conflictFuncs.lowest},
            description = "Normal monsters regenerate %d HP every %d seconds.",
            disabled = true
        },
        bossRegen = {
            weight = 100,
            rolls = {{10, 18}, {10, 14}},
            mightyRolls = {{30, 40}, {6, 7}},
            starmightCalc = function(roll, roll2) return 12 + roll / 5 + (16 - roll2) * 2 end,
            onConflict = {conflictFuncs.simpleSum, conflictFuncs.lowest},
            description = "Boss monsters regenerate %d HP every %d seconds.",
            disabled = true
        },
        championHealers = {
            weight = 100,
            rolls = {{9, 10}},
            mightyRolls = {{6, 7}},
            starmightCalc = function(roll) return 15 + (12 - roll) * 3 end,
            onConflict = {conflictFuncs.lowest},
            description = "Champion monsters heal 15%% of nearby non-champion monsters' HP every %d seconds."
        },
        mobOneShotProt = {
            weight = 100,
            rolls = {},
            mightyRolls = {},
            starmightCalc = function() return 16 end,
            description = "Monsters have one-shot protection."
        },
        mobExplosionDR = {
            weight = 100,
            rolls = {{8, 14}},
            mightyRolls = {{16, 22}},
            starmightCalc = function(roll) return 8 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters receive %d%% less damage from explosions."
        },
        mobFirstBlock = {
            weight = 100,
            rolls = {{1, 3}},
            mightyOnly = true,
            starmightCalc = function(roll) return 20 + roll * 8 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters block the first %d hits they receive."
        },
        mobPeriodicShield = {
            weight = 100,
            rolls = {},
            mightyOnly = true,
            starmightCalc = function() return 50 end,
            description = "Monsters receive no damage for 2 seconds every 10 seconds."
        }
    },
    Azure = {
        mobTurnChampion = {
            weight = 100,
            rolls = {{15, 25}},
            mightyRolls = {{35, 50}},
            starmightCalc = function(roll) return 10 + (roll - 10) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Normal monsters have a %d%% chance to become champions when entering a room."
        },
        mobExtraHitDmg = {
            weight = 100,
            rolls = {{5, 9}},
            mightyRolls = {{12, 18}},
            starmightCalc = function(roll) return 9 + roll * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Normal non-champion monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting."
        },
        champExtraHitDmg = {
            weight = 100,
            rolls = {{8, 12}},
            mightyRolls = {{15, 18}},
            starmightCalc = function(roll) return 10 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Champion monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting."
        },
        bossExtraHitDmg = {
            weight = 100,
            rolls = {{10, 15}},
            mightyRolls = {{20, 25}},
            starmightCalc = function(roll) return 15 + roll * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Boss monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting."
        },
        soulHeartsOnHit = {
            weight = 100,
            rolls = {{7, 12}},
            mightyRolls = {{15, 20}},
            starmightCalc = function(roll) return 8 + (roll - 5) * 1.3 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance to remove 1/2 soul/black hearts when hitting players."
        },
        hoveringTearsOnDeath = {
            weight = 100,
            rolls = {1, {3, 4}},
            mightyRolls = {3, {6, 7}},
            starmightCalc = function(roll, roll2) return 7 + roll * 3 + roll2 * 2 end,
            onConflict = {conflictFuncs.highest, conflictFuncs.simpleSum},
            description = "Non-boss monsters spawn %d static hovering tear(s) on death that last %d seconds."
        },
        tearExplosionOnDeath = {
            weight = 100,
            rolls = {{5, 9}, {3, 5}},
            mightyRolls = {{12, 18}, {6, 8}},
            starmightCalc = function(roll, roll2) return 9 + roll + roll2 * 2 end,
            onConflict = {conflictFuncs.simpleSum, conflictFuncs.highest},
            description = "Monsters have a %d%% chance to release %d tears on death."
        },
        mobDuplicate = {
            weight = 100,
            rolls = {{4, 8}},
            mightyRolls = {{12, 16}},
            starmightCalc = function(roll) return 10 + (roll - 3) * 2.5 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Non-boss monsters have a %d%% chance of being duplicated when entering a room."
        },
        mobSlowOnHit = {
            weight = 100,
            rolls = {{10, 15}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 9 + (roll - 8) * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance to slow you on hit for 2 seconds."
        },
        mobReduceDmgOnHit = {
            weight = 100,
            rolls = {{10, 15}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 10 + (roll - 8) * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance on hit to reduce your damage by 20%% for 3 seconds."
        },
        roomMobExtraDmgOnHit = {
            weight = 100,
            rolls = {{1, 2}},
            mightyOnly = true,
            starmightCalc = function(roll) return 30 + roll * 8 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "When you get hit by a monster, the next %d hits in the room will deal an additional 1/2 heart damage."
        }
    },
    Viridian = {
        floorCurse = {
            weight = 100,
            rolls = {{6, 10}},
            mightyRolls = {{15, 25}},
            starmightCalc = function(roll) return 9 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% additional chance to receive a random curse when entering a floor."
        },
        trollBombOnClear = {
            weight = 100,
            rolls = {{8, 15}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 7 + roll / 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% chance to spawn an additional troll bomb at the center of the room on clear."
        },
        loseCoinsOnSpend = {
            weight = 100,
            rolls = {{8, 12}, {1, 3}},
            mightyRolls = {{15, 22}, {4, 6}},
            starmightCalc = function(roll) return 7 + roll / 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Whenever you lose or spend coins, %d%% chance to lose an additional %d coin(s)."
        },
        lessDevilRoomChance = {
            weight = 100,
            rolls = {{5, 10}},
            mightyRolls = {{15, 20}},
            starmightCalc = function(roll) return 10 + math.abs(roll) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "-%d%% additional chance to find the devil/angel room."
        },
        lessSpeed = {
            weight = 100,
            rolls = {{0.05, 0.08}},
            mightyRolls = {{0.1, 0.13}},
            starmightCalc = function(roll) return 8 + math.abs(roll * 200) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "-%.2f speed."
        },
        lessDamage = {
            weight = 100,
            rolls = {{0.08, 0.15}},
            mightyRolls = {{0.3, 0.5}},
            starmightCalc = function(roll) return 9 + math.abs(roll * 50) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "-%.2f damage."
        },
        lessLuck = {
            weight = 100,
            rolls = {{0.3, 0.7}},
            mightyRolls = {{0.9, 1.5}},
            starmightCalc = function(roll) return 8 + math.abs(roll * 15) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "-%.2f luck."
        },
        pickupsVanish = {
            weight = 100,
            rolls = {{3, 7}},
            mightyRolls = {{10, 15}},
            starmightCalc = function(roll) return 8 + roll * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% chance for coins, keys or bombs to vanish on pickup.",
            disabled = true
        },
        pickupScarcity = {
            weight = 100,
            rolls = {{3, 7}},
            mightyRolls = {{10, 15}},
            starmightCalc = function(roll) return 8 + roll * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% coin, key and bomb scarcity."
        },
        heartsVanish = {
            weight = 100,
            rolls = {{3, 7}},
            mightyRolls = {{10, 15}},
            starmightCalc = function(roll) return 12 + roll * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% chance for heart pickups to vanish when collected.",
            disabled = true
        },
        heartScarcity = {
            weight = 100,
            rolls = {{3, 7}},
            mightyRolls = {{10, 15}},
            starmightCalc = function(roll) return 12 + roll * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% heart pickup scarcity.",
            disabled = true
        },
        shopExpensive = {
            weight = 100,
            rolls = {{2, 5}},
            mightyRolls = {{8, 12}},
            starmightCalc = function(roll) return 7 + roll * 3 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Shop items cost %d more coins."
        },
        itemPoolRemoval = {
            weight = 90,
            rolls = {{1, 4}, {3, 4}},
            mightyOnly = true,
            starmightCalc = function(roll, roll2) return 10 + roll * 5 + roll2 * 6 end,
            onConflict = {conflictFuncs.simpleSum, conflictFuncs.highest},
            description = "When starting a run, remove %d random item(s) of quality %d from all item pools."
        }
    },
    xpgain = "+%d%% xp gain while equipped.",
    halveXPFirstFloor = "XP bonus from this jewel is halved on the first floor.",
    deliriumRewards = "Gain %d skill point(s) and %d respecs when defeating Delirium with this jewel equipped.",
    beastRewards = "Gain %d skill point(s) and %d respecs when defeating The Beast with this jewel equipped.",
}

PST.SCAncients = {
    circadianDestructor = {
        weight = 100,
        spriteFrame = 0,
        name = "Circadian Destructor",
        description = {
            "Every 48 seconds, spawn XVI - The Tower if you're in a room with monsters.",
            "Card spawning pauses until you use the card.",
            "Once XVI - The Tower spawns, -1% all stats every second until you use the card, up to -20%.",
            "When you use XVI - The Tower, monsters become immune to explosions for 4 seconds."
        },
        rewards = {
            xpgain = 70,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    umbra = {
        weight = 100,
        spriteFrame = 1,
        name = "Umbra",
        description = {
            "Guarantees Curse of Darkness if applicable.",
            "Black Candle can no longer show up.",
            "While Curse of Darkness is active, -2% all stats when first entering a room, up to -20%",
            "16% chance to spawn a Night Light when clearing a room, once per floor.",
            "Remove Night Light when entering a new floor."
        },
        rewards = {
            xpgain = 70,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    gazeAverter = {
        weight = 100,
        spriteFrame = 2,
        name = "Gaze Averter",
        description = {
            "Start with Tiny Planet and My Reflection.",
            "-2 damage and -10 range.",
            "Deal 75% less damage to enemies located in the side of the room you're currently facing."
        },
        rewards = {
            xpgain = 60,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    cursedStarpiece = {
        weight = 100,
        spriteFrame = 3,
        name = "Cursed Starpiece",
        description = {
            "Starting from the second floor, all treasure rooms contain a Reversed Stars card",
            "instead of item pedestals.",
            "Starting from the second floor, -12% all stats for the current floor while you",
            "haven't used Reversed Stars. Apply -6% instead if the floor doesn't have a treasure room.",
            "Reversed Stars has a 100% chance to remove an additional item. If used in a treasure",
            "room, lower this chance to 35%."
        },
        rewards = {
            xpgain = 70,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    opalescentPurity = {
        weight = 100,
        spriteFrame = 4,
        name = "Opalescent Purity",
        description = {
            "Once you pick up or purchase a collectible item, remove all other items in the floor,",
            "including those spawned by effects."
        },
        rewards = {
            xpgain = 100,
            halveXPFirstFloor = true,
            deliriumRewards = {2, 6},
            beastRewards = {2, 6}
        }
    },
    iridescentPurity = {
        weight = 100,
        spriteFrame = 5,
        name = "Iridescent Purity",
        description = {
            "Each passive item you pick up has a 15% chance to be removed when entering the next floor.",
            "Chance increases by 15% individually for each item picked in the current floor."
        },
        rewards = {
            xpgain = 80,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    challengerStarpiece = {
        weight = 100,
        spriteFrame = 6,
        name = "Challenger's Starpiece",
        description = {
            "When entering a floor, teleport to the challenge room.",
            "When first entering a challenge room, drops a key if there are only locked chests, or a bomb if only stone chests.",
            "Your damage is halved while outside the challenge room if the latter isn't cleared.",
            "A random deadly sin miniboss spawns after clearing the final round in challenge rooms.",
            "From the 7th floor onwards, spawn a random super deadly sin instead."
        },
        rewards = {
            xpgain = 60,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    soulWatcher = {
        weight = 100,
        spriteFrame = 7,
        name = "Soul Watcher",
        description = {
            "When you enter a room with monsters, a random monster becomes a Soul Eater.",
            "Non-boss Soul Eater monsters have 20% increased HP.",
            "Soul Eater monsters gain 4 HP, 4% HP and 2% speed when a nearby monster dies, up to 20 times.",
            "Bosses are Soul Eaters, and spawn an attack fly every 10 seconds."
        },
        rewards = {
            xpgain = 85,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    luminescentDie = {
        weight = 100,
        spriteFrame = 8,
        name = "Luminescent Die",
        description = {
            "After clearing the floor's boss room, spawn a Reversed Wheel of Fortune card.",
            "Entering the next floor without using a Reversed Wheel of Fortune card grants -10% all stats,",
            "up to -40%.",
            "Active debuff gets halved when using a Reversed Wheel of Fortune card."
        },
        rewards = {
            xpgain = 50,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    baubleseeker = {
        weight = 100,
        spriteFrame = 9,
        name = "Baubleseeker",
        description = {
            "All collectible items are replaced with a random trinket. Shop trinkets cost 3 more coins than usual.",
            "10% chance for treasure rooms to contain Mom's Box if you don't currently",
            "have it, protected from trinket replacement.",
            "Smelt trinkets on pickup.",
            "+1% all stats per smelted trinket, up to 15%."
        },
        rewards = {
            xpgain = 75,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    chroniclerStone = {
        weight = 100,
        spriteFrame = 11,
        name = "Chronicler Stone",
        description = {
            "Every floor, a certain amount of rooms must be explored.",
            "When entering the next floor, if you've explored less than the ordained amount, receive -1% all stats",
            "per unexplored room, up to a total -50%.",
            "Grabbing book items for the first time halves your current debuff from this effect, if present."
        },
        rewards = {
            xpgain = 60,
            halveXPFirstFloor = true,
            deliriumRewards = {0, 10},
            beastRewards = {2, 0}
        }
    },
    sanguinis = {
        weight = 100,
        spriteFrame = 12,
        name = "Sanguinis",
        description = {
            "Guarantees Curse of the Cursed, if applicable, turning doorways into spiked doorways.",
            "Start with holy mantle."
        },
        rewards = {
            xpgain = 60,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    martianUltimatum = {
        weight = 100,
        spriteFrame = 14,
        name = "Martian Ultimatum",
        description = {
            "Start with Mars.",
            "Every 4 to 8 seconds while in a room with monsters, spawn a pattern of static harmless tears around you.",
            "After 2 seconds, the tears fire towards your direction, dealing contact damage.",
            "-0.05 speed when hit, up to -0.25. Resets every room."
        },
        rewards = {
            xpgain = 80,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    crimsonWarpstone = {
        weight = 100,
        spriteFrame = 13,
        name = "Crimson Warpstone",
        description = {
            "Replace treasure room and shop items with Cracked Keys.",
            "15% chance to drop a Cracked Key when clearing a room.",
            "Base key drop chance increases every floor, and decreases by 0.5% per second while in an uncleared room.",
            "-30% all stats. Entering a red room reduces this debuff by 2.5%. Resets every floor.",
            "Entering an ultra secret room removes the debuff for the current floor.",
            --"Reduce debuff by 10% if the floor contains no ultra secret rooms."
        },
        rewards = {
            xpgain = 50,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    glace = {
        weight = 100,
        spriteFrame = 15,
        name = "Glace",
        description = {
            "Start with Uranus and a smelted Ice Cube.",
            "-50% speed and tears. Destroying a frozen enemy reduces this debuff by 0.5%. Resets every floor."
        },
        rewards = {
            xpgain = 60,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    saturnianLuminite = {
        weight = 100,
        spriteFrame = 16,
        name = "Saturnian Luminite",
        description = {
            "Start with Saturnus and Spear of Destiny.",
            "Cannot shoot tears, and base damage is set to 0.25.",
            "If you don't have flight, grants wings and -15% speed.",
            "Every 4 seconds while in a room with monsters, reset Saturnus' ring of tears."
        },
        rewards = {
            xpgain = 75,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    }
}

PST.SCDropRates = {
    championKill = function(stage) return { regular = 1.5 + stage / 4, ancient = 1 } end,
    boss = function(stage) return { regular = 9 + stage * 1.5, ancient = 7 } end,
    challenge = function(stage) return { regular = 20 + stage * 2, ancient = 4 } end,
    bossrush = function() return { regular = 85, ancient = 15 } end,
    planetarium = function() return { regular = 33, ancient = 10 } end,
    curseRoom = function(stage)
        if PST:isFirstOrigStage() then return { regular = 0, ancient = 0 } end
        return { regular = 8 + stage / 2, ancient = 2 }
    end,
}

PST.SCStarTreeUnlockLevel = 30