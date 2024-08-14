-- 'Conflict functions' run when a modifier is present on more than 1 equipped jewel, and determine what to do for the total value for each roll when considering all equipped jewels
local conflictFuncs = {
    simpleSum = function(roll1, targetRoll1)
        return roll1 + targetRoll1
    end,
    lowest = function(roll1, targetRoll1)
        return math.min(roll1, targetRoll1)
    end
}

PST.SCMods = {
    -- Crimson Starcursed Jewel modifiers
    Crimson = {
        mobHP = {
            weight = 100,
            rolls = {{3, 10}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 5 + roll / 2 end,
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
            starmightCalc = function() return 20 end,
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
    }
}