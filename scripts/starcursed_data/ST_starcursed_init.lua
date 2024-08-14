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
        mobTurnChampion = { -- TODO
            weight = 100,
            rolls = {{15, 25}},
            mightyRolls = {{35, 50}},
            starmightCalc = function(roll) return 10 + (roll - 10) end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Normal monsters have a %d%% chance to become champions when entering a room."
        },
        mobExtraHitDmg = { -- TODO
            weight = 100,
            rolls = {{5, 9}},
            mightyRolls = {{12, 18}},
            starmightCalc = function(roll) return 9 + roll * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Normal non-champion monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting."
        },
        champExtraHitDmg = { -- TODO
            weight = 100,
            rolls = {{8, 12}},
            mightyRolls = {{15, 18}},
            starmightCalc = function(roll) return 10 + roll end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Champion monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting."
        },
        bossExtraHitDmg = { -- TODO
            weight = 100,
            rolls = {{10, 15}},
            mightyRolls = {{20, 25}},
            starmightCalc = function(roll) return 15 + roll * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Boss monsters have a %d%% chance to deal an additional 1/2 heart damage when hitting."
        },
        soulHeartsOnHit = { -- TODO
            weight = 100,
            rolls = {{7, 12}},
            mightyRolls = {{15, 20}},
            starmightCalc = function(roll) return 8 + (roll - 5) * 1.3 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance to remove 1/2 soul hearts when hitting players."
        },
        blackHeartsOnHit = { -- TODO
            weight = 100,
            rolls = {{7, 12}},
            mightyRolls = {{15, 20}},
            starmightCalc = function(roll) return 10 + (roll - 5) * 1.3 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance to remove 1/2 black hearts when hitting players."
        },
        hoveringTearsOnDeath = { -- TODO - test that rolls without ranges (single numbers) work
            weight = 100,
            rolls = {1, {3, 4}},
            mightyRolls = {3, 7},
            starmightCalc = function (roll, roll2) return 7 + roll * 3 + roll2 * 2 end,
            onConflict = {conflictFuncs.highest, conflictFuncs.simpleSum},
            description = "Non-boss monsters spawn %d static hovering tear(s) on death that last %d seconds."
        },
        mobDuplicate = { -- TODO
            weight = 100,
            rolls = {{4, 8}},
            mightyRolls = {{12, 16}},
            starmightCalc = function(roll) return 10 + (roll - 3) * 2.5 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Non-boss monsters have a %d%% chance of being duplicated when entering a room."
        },
        mobSlowOnHit = { -- TODO
            weight = 100,
            rolls = {{10, 15}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 9 + (roll - 8) * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance to slow you on hit for 2 seconds."
        },
        mobReduceDmgOnHit = { -- TODO
            weight = 100,
            rolls = {{10, 15}},
            mightyRolls = {{20, 30}},
            starmightCalc = function(roll) return 10 + (roll - 8) * 1.2 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "Monsters have a %d%% chance on hit to reduce your damage by 20% for 3 seconds."
        },
        roomMobExtraDmgOnHit = { -- TODO
            weight = 100,
            rolls = {{1, 2}},
            mightyOnly = true,
            starmightCalc = function(roll) return 30 + roll * 8 end,
            onConflict = {conflictFuncs.simpleSum},
            description = "When you get hit by a monster, the next %d hits in the room will deal an additional 1/2 heart damage."
        }
    }
}