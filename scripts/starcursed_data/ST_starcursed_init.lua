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
            starmightCalc = function(roll) return 10 + math.ceil(roll * 1.2) end,
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
            starmightCalc = function(roll) return 7 + (11 - roll) * 4 end,
            onConflict = {conflictFuncs.simpleSum},
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
            description = "Normal monsters regenerate %d HP every %d seconds."
        },
        bossRegen = {
            weight = 100,
            rolls = {{10, 18}, {10, 14}},
            mightyRolls = {{30, 40}, {6, 7}},
            starmightCalc = function(roll, roll2) return 12 + roll / 5 + (16 - roll2) * 2 end,
            onConflict = {conflictFuncs.simpleSum, conflictFuncs.lowest},
            description = "Boss monsters regenerate %d HP every %d seconds."
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
            starmightCalc = function() return 18 end,
            description = "Monsters have one-shot protection."
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
            starmightCalc = function() return 40 end,
            description = "Monsters receive no damage for 3 seconds every 10 seconds."
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
            description = "%d%% chance for coins, keys or bombs to vanish on pickup."
        },
        heartsVanish = {
            weight = 100,
            rolls = {{3, 7}},
            mightyRolls = {{10, 15}},
            starmightCalc = function(roll) return 12 + roll * 2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "%d%% chance for heart pickups to vanish when collected."
        },
        shopExpensive = {
            weight = 100,
            rolls = {{2, 5}},
            mightyRolls = {{8, 12}},
            starmightCalc = function(roll) return 7 + roll * 3 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Shop items cost %d more coins."
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
        version = 1,
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
    umbra = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 1,
        name = "Umbra",
        description = {
            "Guarantees Curse of Darkness if applicable.",
            "Black Candle can no longer show up.",
            "While Curse of Darkness is active, -2% all stats when first entering a room, up to -20%",
            "12% chance to spawn a Night Light when clearing a room, once per floor.",
            "Remove Night Light when entering a new floor."
        },
        rewards = {
            xpgain = 70,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    gazeAverter = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 2,
        name = "Gaze Averter",
        description = {
            "Start with Tiny Planet and My Reflection.",
            "-2 damage, shot speed and tears.",
            "Deal 75% less damage to enemies located in the side of the room you're currently facing."
        },
        rewards = {
            xpgain = 60,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    cursedStarpiece = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 3,
        name = "Cursed Starpiece",
        description = {
            "Starting from the second floor, all treasure rooms contain a Reversed Stars card instead of item pedestals.",
            "Starting from the second floor, -8% all stats for the current floor while you haven't used Reversed Stars."
        },
        rewards = {
            xpgain = 60,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    opalescentPurity = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 4,
        name = "Opalescent Purity",
        description = {
            "Once you pick up or purchase a passive item, remove all other passive items in the floor, including",
            "those spawned by effects."
        },
        rewards = {
            xpgain = 100,
            halveXPFirstFloor = true,
            deliriumRewards = {2, 6},
            beastRewards = {2, 6}
        }
    },
    iridescentPurity = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 5,
        name = "Iridescent Purity",
        description = {
            "Each passive item you pick up has a 10% chance to be removed when entering the next floor.",
            "Chance increases by 10% individually for each item picked in the current floor.",
            "Items you keep when entering a floor can't be removed by this effect."
        },
        rewards = {
            xpgain = 80,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 5},
            beastRewards = {1, 5}
        }
    },
    challengerStarpiece = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 6,
        name = "Challenger's Starpiece",
        description = {
            "Spawn a random deadly sin miniboss when clearing a challenge room round.",
            "After beating Mom, super deadly sin counterparts will tag along the regular ones when clearing",
            "a challenge room round.",
            "If the current room has access to a challenge room, -3% all stats when leaving the room and when",
            "entering rooms that aren't the challenge room, up to -15%.",
            "Debuff resets upon clearing a challenge room round."
        },
        rewards = {
            xpgain = 40,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 3},
            beastRewards = {1, 3}
        }
    },
    soulWatcher = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 7,
        name = "Soul Watcher",
        description = {
            "Spawn a random Soul Stone at the beginning of the floor.",
            "Soul Watcher's Curse: -40% damage and speed while not holding a Soul Stone.",
            "Every floor, a random room is designated. When entering it, the Soul Stone will pulse, and",
            "using it there will remove Soul Watcher's Curse until next floor.",
            "Leaving the designated room without using the Soul Stone triggers Soul Watcher's Curse,",
            "regardless of holding one."
        },
        rewards = {
            xpgain = 40,
            deliriumRewards = {1, 3},
            beastRewards = {1, 3}
        }
    },
    luminescentDie = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 8,
        name = "Luminescent Die",
        description = {
            "After clearing the floor's boss room, spawn a Reversed Wheel of Fortune card.",
            "Entering the next floor without using a Reversed Wheel of Fortune card grants -8% all stats,",
            "up to -20%.",
            "Active debuff gets halved when using a Reversed Wheel of Fortune card."
        },
        rewards = {
            xpgain = 50,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    },
    baubleseeker = { -- TODO
        weight = 100,
        version = 1,
        spriteFrame = 9,
        name = "Baubleseeker",
        description = {
            "All item pedestals are replaced with a random trinket.",
            "10% chance for treasure rooms to contain Mom's Box if you don't currently",
            "have it, protected from trinket replacement.",
            "Smelt trinkets on pickup.",
            "+2% all stats per smelted trinket, up to 50%."
        },
        rewards = {
            xpgain = 60,
            halveXPFirstFloor = true,
            deliriumRewards = {1, 4},
            beastRewards = {1, 4}
        }
    }
}