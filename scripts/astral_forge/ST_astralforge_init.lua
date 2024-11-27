---@enum PSTAstralWepType
PSTAstralWepType = {
    LONGSWORD = 0,
    ESTOC = 1,
    DAGGER = 2,
    QUICKBLADE = 3,
    SPEAR = 4,
    TRIDENT = 5,
    SCYTHE = 6,
    AXE = 7,
    GREATAXE = 8,
    SHORTBOW = 9,
    BOW = 10,
    CROSSBOW = 11,
    GAUNTLET = 12
}

---@enum PSTAstralWepRarity
PSTAstralWepRarity = {
    NORMAL = 0,
    MAGIC = 1,
    ANCIENT = 2
}

PST.astralWepBossBaseRate = 12

---@class PSTAstralWepModEntry
---@field name string
---@field rolls table

---@class PSTAstralWeapon
---@field type PSTAstralWepType
---@field rarity PSTAstralWepRarity
---@field tier number
---@field implicitMod? number[]
---@field multiImplicits? table[]
---@field ancientID? integer
---@field ancientUpg? number
-- Weapon mods are stored as tables with {mod name (string), mod rolls (table)}, e.g. {consecFireDmg, {14}}
---@field mods? PSTAstralWepModEntry[]
---@field honing? number
-- Holds the name of the character that currently has this weapon equipped
---@field equipped? string

-- Astral weapon modifiers
-- These get added as "astralwep_" + key name when applied to the run snapshot, e.g. "astralwep_dmgStatus"
PST.astralWepMods = {
    ---- GENERIC MODS ----
    dmgStatus = {
        description = "+{{roll1}}% damage dealt to enemies affected by status effects.",
        color = {145, 203, 196},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 3 + 3 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusSlow = {
        description = "+{{roll1}}% damage dealt to slowed enemies.",
        color = {185, 223, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusCharm = {
        description = "+{{roll1}}% damage dealt to charmed enemies.",
        color = {249, 185, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusPara = {
        description = "+{{roll1}}% damage dealt to paralyzed enemies.",
        color = {72, 77, 92},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 7 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusFear = {
        description = "+{{roll1}}% damage dealt to feared enemies.",
        color = {135, 60, 185},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusBleed = {
        description = "+{{roll1}}% damage dealt to bleeding enemies.",
        color = {185, 60, 93},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusPoison = {
        description = "+{{roll1}}% damage dealt to poisoned enemies.",
        color = {55, 172, 50},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusBurn = {
        description = "+{{roll1}}% damage dealt to burning enemies.",
        color = {255, 137, 20},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },

    consecFireDmg = {
        description = "+{{roll1}}% damage dealt after firing consecutively for 2 seconds. Resets when you stop firing.",
        color = {235, 167, 90},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 5 * rollPerc[1] + math.ceil(wepTier * 1.5)
            }
        end
    },
    consecFireDmg2 = {
        description = {
            "+{{roll1}}% damage dealt after firing consecutively for 3 seconds.",
            "Resets 1 second after you stop firing."
        },
        color = {255, 140, 10},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 10 + 8 * rollPerc[1] + wepTier * 2
            }
        end
    },

    farEnemyDmg = {
        description = "+{{roll1}}% damage dealt to enemies beyond 2 tiles of you.",
        color = {127, 107, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 4 * rollPerc[1] + math.floor(wepTier * 2.5)
            }
        end
    },
    closeEnemyDmg = {
        description = "+{{roll1}}% damage dealt to enemies within 2 tiles of you.",
        color = {255, 107, 107},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + math.ceil(wepTier * 2.5)
            }
        end
    },

    baseDmg = {
        description = "+{{roll1}} base damage.",
        color = {175, 0, 0},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.1 + 0.2 * rollPerc[1] + wepTier * 0.1
            }
        end
    },
    baseDmg2 = {
        description = "+{{roll1}} base damage, removed for {{roll2}} seconds when you get hit.",
        color = {200, 20, 20},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.3 + 0.2 * rollPerc[1] + wepTier * 0.2,
                roll2 = 5 + 5 * rollPerc[2] - (wepTier - 1) * 0.4
            }
        end
    },

    redHealDmg = {
        description = {
            "When healing red hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 red heart recovered,",
            "which stacks up to {{roll2}}%."
        },
        color = {255, 0, 110},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 2.5 * rollPerc[1] + wepTier,
                roll2 = 10 + 4 * rollPerc[2] + wepTier * 2
            }
        end
    },
    soulHealDmg = {
        description = {
            "When gaining soul hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 soul heart gained,",
            "which stacks up to {{roll2}}%."
        },
        color = {105, 160, 215},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 2 + 4 * rollPerc[1] + wepTier,
                roll2 = 12 + 4 * rollPerc[2] + wepTier * 2
            }
        end
    },
    blackHealDmg = {
        description = {
            "When gaining black hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 black heart gained,",
            "which stacks up to {{roll2}}%."
        },
        color = {48, 48, 48},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 2 + 4 * rollPerc[1] + wepTier,
                roll2 = 12 + 4 * rollPerc[2] + wepTier * 2
            }
        end
    },

    purchaseDmg = {
        description = {
            "+{{roll1}}% damage dealt for {{roll2}} seconds after purchasing an item, which stacks",
            "up to {{roll3}}%."
        },
        color = {255, 250, 188},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 3 + 2 * rollPerc[1] + wepTier,
                roll2 = 22 + 8 * rollPerc[2] + wepTier * 4,
                roll3 = 10 + 5 * rollPerc[3] + wepTier * 3
            }
        end
    },

    coinPickupDmg = {
        description = {
            "+{{roll1}}% damage dealt for {{roll2}} seconds after picking up any coin, which stacks",
            "up to {{roll3}}%."
        },
        color = {255, 244, 78},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 1.5 * rollPerc[1] + wepTier / 2,
                roll2 = 3 + 2 * rollPerc[2] + wepTier / 2,
                roll3 = 10 + 5 * rollPerc[3] + wepTier * 2
            }
        end
    },
    coinPermDmg = {
        description = "+{{roll1}}% permanent damage after picking up any coin worth at least 5, up to {{roll2}}%.",
        color = {183, 172, 5},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1 + 1 * rollPerc[1] + math.ceil(wepTier / 2),
                roll2 = 24 + 6 * rollPerc[2] + wepTier * 2
            }
        end
    },

    onHitEnemyDmgTaken = {
        description = "All enemies take {{roll1}}% more damage for {{roll2}} seconds after you get hit.",
        color = {186, 113, 113},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 10 + 8 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 2 * rollPerc[2] + wepTier / 2
            }
        end
    },

    flyGroundDmg = {
        description = {
            "+{{roll1}}% damage dealt to flying enemies if you're on the ground.",
            "+{{roll1}}% damage dealt to ground enemies if you're flying."
        },
        color = {158, 255, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 4 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeFamDmg = {
        description = "+{{roll1}}% damage dealt per active familiar, up to 40%",
        color = {177, 225, 129},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 1.5 * rollPerc[1] + wepTier / 2
            }
        end
    },
    famKillDmg = {
        description = "+{{roll1}}% damage dealt for {{roll2}} seconds after a familiar kills an enemy.",
        color = {182, 255, 108},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 4 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 4 * rollPerc[2] + wepTier / 3
            }
        end
    },

    holyMantleDmg = {
        description = "+{{roll1}}% damage dealt while you have a holy mantle shield.",
        color = {223, 253, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 4 * rollPerc[1] + wepTier * 2
            }
        end
    },

    eternalDmg = {
        description = "+{{roll1}}% damage dealt while you have an eternal heart.",
        color = {255, 255, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeDmg = {
        description = "+{{roll1}}% damage dealt for {{roll2}} seconds after using an active item.",
        color = {0, 213, 192},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 6 + 6 * rollPerc[1] + wepTier * 2,
                roll2 = 4 + 3 * rollPerc[1] + wepTier / 3
            }
        end
    },

    healthyMobDmg = {
        description = "+{{roll1}}% damage dealt to enemies above 90% HP.",
        color = {255, 0, 145},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },
    injuredMobDmg = {
        description = "+{{roll1}}% damage dealt to enemies below 15% HP.",
        color = {150, 0, 85},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },

    creepDmg = {
        description = "+{{roll1}}% damage dealt while standing on creep.",
        color = {150, 200, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 4 * rollPerc[1] + wepTier * 4
            }
        end
    },
    playerCreepDmg = {
        description = "+{{roll1}}% damage dealt by player creep.",
        color = {130, 150, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 8 * rollPerc[1] + wepTier * 3
            }
        end
    },

    laserDmg = {
        description = "+{{roll1}}% damage dealt with lasers.",
        color = {240, 140, 110},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2.5
            }
        end
    },
    explosionDmg = {
        description = "+{{roll1}}% damage dealt with explosions.",
        color = {111, 111, 111},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2.5
            }
        end
    },

    injuredDmg = {
        description = "+{{roll1}}% damage dealt while half or more of your total red heart containers are empty.",
        color = {235, 140, 140},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 10 + 7 * rollPerc[1] + wepTier * 2
            }
        end
    },

    ---- ANCIENT MODS ----
    -- Ancient Longswords
    greyWind = {
        description = {
            "{{roll1}}% chance on hit to slash all enemies within 2 tiles of the target, dealing {{roll2}}%",
            "of the hit's damage. This effect has a 2 second cooldown.",
            "If the slashes target 3 or less enemies, they deal 50% more damage, cause bleeding for 3 seconds,",
            "and the cooldown for that trigger is increased to 5 seconds.",
            "-0.6 base damage."
        },
        ancient = true,
        minRolls = {7, 120},
        maxRolls = {12, 160},
        upgIncrements = {0.5, 4}
    },
    executioner = {
        description = {
            "+{{roll1}}% damage.",
            "{{roll2}}% chance on hit to instantly kill enemies that are left with {{roll3}}% or less HP."
        },
        ancient = true,
        minRolls = {5, 25, 12},
        maxRolls = {8, 35, 16},
        upgIncrements = {0.4, 1, 0.25}
    },
    swordOfSong = {
        description = {
            "{{roll1}}% chance on hit to cause an area pulse at the hit's location that charms nearby enemies for 4 seconds.",
            "+1% damage whenever you kill a charmed monster.",
            "Every {{roll2}} hits against charmed monsters, reset the damage bonus and trigger Isaac's Tears' item effect."
        },
        ancient = true,
        minRolls = {5, 16},
        maxRolls = {8, 8},
        upgIncrements = {0.2, -1}
    },
    redbeak = {
        description = {
            "If half or more of your total red heart containers are empty:",
            "    +{{roll1}}% damage dealt.",
            "    {{roll2}}% chance for hits to inflict bleed on enemies for 4 seconds.",
            "    {{roll3}}% chance for bleeding enemies to drop a 1/2 red heart on kill, which vanishes after 2 seconds."
        },
        ancient = true,
        minRolls = {12, 6, 4},
        maxRolls = {20, 15, 8},
        upgIncrements = {0.5, 0.5, 0.2}
    },
    glowingMoonblade = {
        description = {
            "Start with innate Luna.",
            "-{{roll1}}% damage and tears.",
            "When first entering a secret room, remove these reductions for the current floor.",
            "Entering 2 secret rooms grants +{{roll2}} speed for the current floor, once per floor."
        },
        ancient = true,
        minRolls = {18, 0.06},
        maxRolls = {10, 0.12},
        upgIncrements = {-0.5, 0.005}
    },
    maxwellEngine = {
        description = {
            "+0.5% damage for 3 seconds when hitting an enemy, which stacks up to {{roll1}}%.",
            "While the buff is maxed:",
            "    {{roll2}}% chance for hits to cause burning or slow for 3 seconds on hit.",
            "    15% chance for burning enemies to explode on death, dealing 30 damage to nearby enemies.",
            "    15% chance for slowed enemies to freeze on death."
        },
        ancient = true,
        minRolls = {6, 12},
        maxRolls = {12, 22},
        upgIncrements = {0.5, 1}
    },
    glowingSunblade = {
        description = {
            "Start with innate Sol.",
            "-{{roll1}}% damage and tears.",
            "When first entering the boss room, remove these reductions for the current floor.",
            "When first entering the treasure room, gain +{{roll2}} speed for the current floor."
        },
        ancient = true,
        minRolls = {16, 0.05},
        maxRolls = {8, 0.1},
        upgIncrements = {-0.5, 0.005}
    },
    -- Ancient Estocs
    arcingNeedle = {
        description = {
            "Every 0.5 seconds spent firing, {{roll1}}% chance to gain Jacob's Ladder as an innate effect for {{roll2}} seconds.",
            "Chance goes up in 1% increments as you keep firing, and resets once you stop firing.",
            "Obtaining Jacob's Ladder naturally grants you +15% tears."
        },
        ancient = true,
        minRolls = {2, 2.5},
        maxRolls = {6, 4},
        upgIncrements = {0.25, 0.1}
    },
    auricPersecutor = {
        description = {
            "Half of your coin count now acts as a tears multiplier, up to {{roll1}}%.",
            "+{{roll2}}% damage for the current floor when picking up a coin worth at least 5, up to {{roll3}}%."
        },
        ancient = true,
        minRolls = {20, 7, 21},
        maxRolls = {35, 15, 40},
        upgIncrements = {1, 0.5, 1}
    },
    -- Ancient Daggers
    scrambler = {
        description = {
            "3% chance on hit to confuse enemies for 4 seconds. Triple the chance against targets within 1.5 tiles.",
            "Increase this chance by 1% when entering a new floor.",
            "Deal {{roll1}}% more damage against confused enemies.",
            "Hitting confused enemies has a {{roll2}}% chance to remove their confusion."
        },
        ancient = true,
        minRolls = {25, 50},
        maxRolls = {40, 20},
        upgIncrements = {1, -2}
    },
    adriftBlade = {
        description = "{{roll1}}% chance on hit to deal between {{roll2}}% and {{roll3}}% of the original damage.",
        ancient = true,
        minRolls = {25, 40, 200},
        maxRolls = {35, 60, 280},
        upgIncrements = {0.5, 1, 5}
    },
    -- Ancient Quickblades
    nimbleTwins = {
        description = {
            "+{{roll1}}% tears.",
            "When hitting an enemy, additionally fire a slow-moving red tear and a quick blue tear towards them.",
            "These tears deal {{roll2}}% of your damage.",
            "Gain +3% damage for 2 seconds when hitting enemies with the red tear, which stacks up to {{roll3}}%.",
            "Gain +3% tears for 2 seconds when hitting enemies with the blue tear, which stacks up to {{roll3}}%."
        },
        ancient = true,
        minRolls = {5, 25, 15},
        maxRolls = {12, 50, 21},
        upgIncrements = {0.5, 3, 0.5}
    },
    crimsonAltruist = {
        description = {
            "+{{roll1}}% damage when using a blood donation machine, up to 100%.",
            "+{{roll2}} tears every {{roll3}} blood donation machine uses.",
            "Halve the active bonuses when entering a new floor."
        },
        ancient = true,
        minRolls = {2, 0.2, 16},
        maxRolls = {6, 0.4, 9},
        upgIncrements = {0.25, 0.02, -1}
    },
    -- Ancient Spears
    beastbane = {
        description = {
            "+{{roll1}}% damage dealt to bosses.",
            "Defeating a boss grants you a permanent +{{roll2}}% damage, once every 2 floors."
        },
        ancient = true,
        minRolls = {12, 4},
        maxRolls = {18, 6},
        upgIncrements = {0.5, 0.1}
    },
    gravitas = {
        description = {
            "When hitting enemies beyond 2 tiles from you, {{roll1}}% chance to additionally fire",
            "3 homing tears dealing {{roll2}}% of your damage. 0.5 seconds cooldown.",
            "When hitting enemies with the homing tears, 3% chance to gain Spoon Bender for the current room.",
            "-{{roll3}}% tears while you have Spoon Bender."
        },
        ancient = true,
        minRolls = {7, 30, 12},
        maxRolls = {12, 50, 6},
        upgIncrements = {0.25, 2, -0.5}
    },
    borealSpear = {
        description = {
            "{{roll1}}% chance on hit to slow enemies for 3 seconds.",
            "When you hit a slowed enemy beyond {{roll2}} tiles of you, +1% chance to freeze that enemy.",
            "Hitting enemies repeatedly increases the chance to freeze them, with the freeze chance being",
            "individual to each enemy."
        },
        ancient = true,
        minRolls = {7, 3},
        maxRolls = {10, 1.5},
        upgIncrements = {0.2, -0.1}
    },
    viperStinger = {
        description = {
            "{{roll1}}% chance to paralyze enemies on hit for 2 seconds.",
            "Double the chance and duration against poisoned enemies.",
            "Killing a paralyzed enemy releases a toxic cloud, poisoning for 4 seconds and dealing {{roll2}}%",
            "of your damage to nearby enemies.",
        },
        ancient = true,
        minRolls = {9, 80},
        maxRolls = {15, 150},
        upgIncrements = {0.1, 4}
    },
    -- Ancient Tridents
    consecrator = {
        description = {
            "Gain +{{roll1}}% damage when entering a devil room, up to {{roll2}}%.",
            "Gain +{{roll1}}% tears when entering an angel room, up to {{roll2}}%.",
            "Active buffs get halved when clearing a boss room.",
            "+{{roll3}}% chance for angel/devil rooms to show up."
        },
        ancient = true,
        minRolls = {9, 30, 5},
        maxRolls = {15, 40, 10},
        upgIncrements = {0.25, 1, 0.25}
    },
    verdantGreen = {
        description = {
            "{{roll1}}% chance on hit to create a poison cloud.",
            "This chance receives a flat increase from your tears stat, up to +5%.",
            "Poison clouds periodically poison enemies within it for 4 seconds. Poisoned enemies instead take {{roll2}}%",
            "of your damage."
        },
        ancient = true,
        minRolls = {6, 25},
        maxRolls = {9, 40},
        upgIncrements = {0.2, 1}
    },
    lostCoralTrident = {
        description = {
            "Start with innate Neptunus.",
            "-{{roll1}}% damage."
        },
        ancient = true,
        minRolls = {25},
        maxRolls = {12},
        upgIncrements = {-0.8}
    },
    oceanicMight = {
        description = {
            "Start with innate Aquarius.",
            "Player creep deals {{roll1}}% more damage to enemies.",
            "Hitting enemies standing on creep created by you has a 10% chance to trigger a water explosion, dealing",
            "25 damage to nearby enemies. 2.5 second cooldown.",
            "Explosion trigger chance becomes 40% against flying enemies."
        },
        ancient = true,
        minRolls = {30, 5},
        maxRolls = {50, 10},
        upgIncrements = {1, 0.25}
    },
    -- Ancient Scythes
    taleEnder = {
        description = {
            "+{{roll1}}% damage dealt to full health enemies.",
            "{{roll2}}% chance to instantly kill the first non-boss enemy you hit in each room.",
            "Halve this chance when the effect triggers, and reset it when entering a new floor."
        },
        ancient = true,
        minRolls = {60, 75},
        maxRolls = {120, 100},
        upgIncrements = {3, 2}
    },
    crimsonReaper = {
        description = {
            "When hitting a full health enemy, apply bleed to them for {{roll1}} seconds.",
            "Double this duration against bosses.",
            "Bleeding enemies below {{roll2}}% HP take increased damage based on their missing HP below {{roll2}}%."
        },
        ancient = true,
        minRolls = {4, 20},
        maxRolls = {6, 50},
        upgIncrements = {0.2, 2}
    },
    mobripper = {
        description = {
            "Circular slashes from the implicit modifier now deal {{roll1}}% of the hit's damage instead.",
            "If the circular slash kills any enemy or hits a boss, fear all enemies hit by it for 3 seconds.",
            "-{{roll2}}% damage."
        },
        ancient = true,
        minRolls = {250, 25},
        maxRolls = {350, 15},
        upgIncrements = {8, -1}
    },
    -- Ancient Axes
    starsteelBroadaxe = {
        description = {
            "+2% tears for the current room when hitting bleeding enemies, up to {{roll1}}%.",
            "Hitting a boss reduces their status effect cooldown by 0.5 seconds."
        },
        ancient = true,
        minRolls = {20},
        maxRolls = {40},
        upgIncrements = {1}
    },
    ancientRunicChopper = {
        description = {
            "+{{roll1}}% permanent damage whenever you use a full rune, up to {{roll2}}%.",
            "+{{roll3}}% tears for 10 seconds whenever you use a rune or rune shard."
        },
        ancient = true,
        minRolls = {3, 24, 12},
        maxRolls = {5, 36, 18},
        upgIncrements = {0.1, 0.8, 0.4}
    },
    circuitSplitter = {
        description = {
            "Hitting a bleeding enemy creates a laser ring that follows them, damaging nearby enemies",
            "for {{roll1}}% of your damage per tick, capped at 5.",
            "Laser rings last {{roll2}} seconds and can linger in place after the enemy dies.",
            "Up to 3 laser rings from this effect can be in the room simultaneously."
        },
        ancient = true,
        minRolls = {15, 2},
        maxRolls = {25, 3},
        upgIncrements = {1, 0.1}
    },
    -- Ancient Greataxes
    berserkerWrath = {
        description = {
            "Trigger Berserk! when first entering a room with monsters, once per floor.",
            "Entering the boss room causes Berserk! to stop.",
            "+{{roll1}} seconds to Berserk!'s duration."
        },
        ancient = true,
        minRolls = {3},
        maxRolls = {5},
        upgIncrements = {0.1, 0.5, 1}
    },
    frozenTerror = {
        description = {
            "When hitting bleeding enemies, {{roll1}}% chance to slow them for 3 seconds.",
            "When hitting slowed enemies within {{roll2}} tile(s) of you, perform a circular slash",
            "around you that can freeze slowed enemies. 1.5 second cooldown.",
            "Slash deals {{roll3}}% of your damage."
        },
        ancient = true,
        minRolls = {15, 1.5, 80},
        maxRolls = {25, 2.5, 160},
        upgIncrements = {1, 0.1, 4}
    },
    -- Ancient Shortbows
    stormAdvance = {
        description = {
            "Start with innate 120 Volt.",
            "Every {{roll1}} hits against enemies, launch a fan of electrified tears towards the last target hit.",
            "These tears deal {{roll2}}% of your damage.",
            "Effect has a 2 second cooldown."
        },
        ancient = true,
        minRolls = {10, 40},
        maxRolls = {6, 100},
        upgIncrements = {-0.25, 4}
    },
    quillRain = {
        description = {
            "Start with innate Soy Milk.",
            "-{{roll2}}% damage dealt to enemies within {{roll1}} tiles of you."
        },
        ancient = true,
        minRolls = {2.5, 40},
        maxRolls = {1.5, 10},
        upgIncrements = {-0.1, -2}
    },
    -- Ancient Bows
    gildedSeeker = {
        description = {
            "Start with innate Head of the Keeper.",
            "+1% damage when collecting any coin while there are monsters in the room, up to {{roll1}}%.",
            "Halve your current bonus when clearing a room.",
        },
        ancient = true,
        minRolls = {25, 25},
        maxRolls = {40, 40},
        upgIncrements = {1, 1}
    },
    twistedOakstring = {
        description = {
            "When hitting enemies beyond {{roll1}} tiles of you, create an additional homing, spectral and",
            "fearing tear at their position. 0.5 second cooldown.",
            "This tear deals {{roll2}}% of the hit's damage."
        },
        ancient = true,
        minRolls = {2.5, 80},
        maxRolls = {1.5, 140},
        upgIncrements = {-0.1, 4}
    },
    bruteOnslaught = {
        description = {
            "When using an active item, for each charge used, boost the next 5 hits' damage by {{roll1}}%.",
            "+{{roll2}}% tears for 5 seconds after using an active item."
        },
        ancient = true,
        minRolls = {20, 10},
        maxRolls = {40, 16},
        upgIncrements = {2, 0.4}
    },
    -- Ancient Crossbows
    volatileArbalest = {
        description = {
            "{{roll1}}% chance to cause a small explosion when hitting enemies beyond 2.5 tiles of you,",
            "dealing {{roll2}}% of your damage. 1 second cooldown."
        },
        ancient = true,
        minRolls = {7, 250},
        maxRolls = {10, 400},
        upgIncrements = {0.2, 10}
    },
    avelyn = {
        description = {
            "Every {{roll1}} total seconds spent firing, shoot 3 tears towards a nearby enemy, each dealing {{roll2}}%",
            "of your damage."
        },
        ancient = true,
        minRolls = {4, 40},
        maxRolls = {2.5, 75},
        upgIncrements = {-0.1, 1}
    },
    preciseSeeker = {
        description = {
            "Every second, mark a random enemy if available, prioritizing bosses.",
            "Every {{roll1}} seconds, fire a very quick piercing and spectral tear towards the marked enemy.",
            "Fired tear deals {{roll2}}% of your damage, up to 60."
        },
        ancient = true,
        minRolls = {5, 200},
        maxRolls = {2.5, 400},
        upgIncrements = {-0.25, 10}
    },
    -- Ancient Gauntlets
    magefist = {
        description = {
            "Can imprint up to 3 modifiers on this weapon.",
            "Imprinting cost is halved.",
            "+{{roll1}}% all stats per modifier on this weapon."
        },
        ancient = true,
        minRolls = {0.2},
        maxRolls = {1.5},
        upgIncrements = {0, 0.1}
    },
    ironhand = {
        description = {
            "Rolls 3 random weapon implicits.",
            "Cannot imprint modifiers into this weapon.",
            "+{{roll1}}% all stats for every 10 honing on this weapon."
        },
        ancient = true,
        minRolls = {0.2},
        maxRolls = {1},
        upgIncrements = {0.05}
    }
}

PST.astralWepPrefix = "astralwep_"
function PST:getSnapAstralWepMod(modName, default)
    return PST:getTreeSnapshotMod(PST.astralWepPrefix .. modName, default)
end

-- Astral weapon data (honing goes from 0-50 for implicit mod rolls)
PST.astralWepData = {
    -- Longswords
    [PSTAstralWepType.LONGSWORD] = {
        name = "Longsword",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 0,
            [PSTAstralWepRarity.MAGIC] = 1,
            overlay = 0
        },
        implicitMod = {
            name = "longswordImp",
            description = "+{{roll1}}% damage dealt to enemies within 1.5 tiles.",
            rollsFunc = function(honing)
                return {
                    roll1 = 10 + math.floor(honing / 3)
                }
            end
        },
        ancients = {
            -- Grey Wind
            {
                name = "Grey Wind",
                spriteFrame = 0,
                weight = 100,
                ancientMods = {"greyWind"}
            },
            -- Executioner
            {
                name = "Executioner",
                spriteFrame = 1,
                weight = 100,
                ancientMods = {"executioner"}
            },
            -- Sword of Song
            {
                name = "Sword of Song",
                spriteFrame = 2,
                weight = 100,
                ancientMods = {"swordOfSong"}
            },
            -- Redbeak
            {
                name = "Redbeak",
                spriteFrame = 3,
                weight = 100,
                ancientMods = {"redbeak"}
            },
            -- Glowing Moonblade
            {
                name = "Glowing Moonblade",
                spriteFrame = 31,
                weight = 100,
                ancientMods = {"glowingMoonblade"}
            },
            -- Maxwell's Thermic Engine
            {
                name = "Maxwell's Thermic Engine",
                spriteFrame = 34,
                weight = 100,
                ancientMods = {"maxwellEngine"}
            },
            -- Glowing Sunblade
            {
                name = "Glowing Sunblade",
                spriteFrame = 35,
                weight = 100,
                ancientMods = {"glowingSunblade"}
            }
        }
    },
    -- Estocs
    [PSTAstralWepType.ESTOC] = {
        name = "Estoc",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 2,
            [PSTAstralWepRarity.MAGIC] = 3,
            overlay = 1
        },
        implicitMod = {
            name = "estocImp",
            description = {
                "Consecutive hits against enemies within 2 tiles of you grants +{{roll1}}% tears, up to {{roll2}}%.",
                "Hitting an enemy beyond 2 tiles resets the bonus."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 3 + PST:roundFloat(5 * (honing / 50), -2),
                    roll2 = 20 + math.floor(honing / 5)
                }
            end
        },
        ancients = {
            -- Arcing Needle
            {
                name = "Arcing Needle",
                spriteFrame = 4,
                weight = 100,
                ancientMods = {"arcingNeedle"}
            },
            -- Auric Persecutor
            {
                name = "Auric Persecutor",
                spriteFrame = 5,
                weight = 100,
                ancientMods = {"auricPersecutor"}
            }
        }
    },
    -- Daggers
    [PSTAstralWepType.DAGGER] = {
        name = "Dagger",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 4,
            [PSTAstralWepRarity.MAGIC] = 5,
            overlay = 2
        },
        implicitMod = {
            name = "daggerImp",
            description = {
                "{{roll1}}% chance for hits to deal {{roll2}}% more damage.",
                "Double the chance against targets within 1.5 tiles."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 3 + PST:roundFloat(honing / 10, -2),
                    roll2 = 40 + math.floor(honing / 2)
                }
            end
        },
        ancients = {
            -- The Scrambler
            {
                name = "The Scrambler",
                spriteFrame = 6,
                weight = 100,
                ancientMods = {"scrambler"}
            },
            -- Adrift Blade
            {
                name = "Adrift Blade",
                spriteFrame = 7,
                weight = 100,
                ancientMods = {"adriftBlade"}
            }
        }
    },
    -- Quickblades
    [PSTAstralWepType.QUICKBLADE] = {
        name = "Quickblade",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 6,
            [PSTAstralWepRarity.MAGIC] = 7,
            overlay = 3
        },
        implicitMod = {
            name = "quickbladeImp",
            description = {
                "+{{roll1}} tears for {{roll2}} second(s) when hitting an enemy, which stacks up to {{roll3}}.",
                "Double the duration if hitting targets within 1.5 tiles.",
                "Each stack has its own duration."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 0.1 + PST:roundFloat(0.14 * (honing / 50), -2),
                    roll2 = 1 + PST:roundFloat(honing / 50, -2),
                    roll3 = 2 + PST:roundFloat(2 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Nimble Twins
            {
                name = "Nimble Twins",
                spriteFrame = 8,
                weight = 100,
                ancientMods = {"nimbleTwins"}
            },
            -- Crimson Altruist
            {
                name = "Crimson Altruist",
                spriteFrame = 9,
                weight = 100,
                ancientMods = {"crimsonAltruist"}
            }
        }
    },
    -- Spears
    [PSTAstralWepType.SPEAR] = {
        name = "Spear",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 8,
            [PSTAstralWepRarity.MAGIC] = 9,
            overlay = 4
        },
        implicitMod = {
            name = "spearImp",
            description = {
                "+{{roll1}}% damage dealt to enemies between 1.5 and 2.5 tiles away from you.",
                "-{{roll2}}% damage dealt to enemies within 1.5 tiles."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 14 + PST:roundFloat(11 * (honing / 50), -2),
                    roll2 = 15 - PST:roundFloat(8 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Beastbane
            {
                name = "Beastbane",
                spriteFrame = 10,
                weight = 100,
                ancientMods = {"beastbane"}
            },
            -- Gravitas
            {
                name = "Gravitas",
                spriteFrame = 11,
                weight = 100,
                ancientMods = {"gravitas"}
            },
            -- Boreal Frostspear
            {
                name = "Boreal Frostspear",
                spriteFrame = 22,
                weight = 100,
                ancientMods = {"borealSpear"}
            },
            -- Viper Stinger
            {
                name = "Viper Stinger",
                spriteFrame = 32,
                weight = 100,
                ancientMods = {"viperStinger"}
            }
        }
    },
    -- Tridents
    [PSTAstralWepType.TRIDENT] = {
        name = "Trident",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 10,
            [PSTAstralWepRarity.MAGIC] = 11,
            overlay = 5
        },
        implicitMod = {
            name = "tridentImp",
            description = {
                "Consecutive hits against enemies beyond 1.5 tiles of you grant +{{roll1}}% damage and tears, up to {{roll2}}%.",
                "Hitting an enemy within 1.5 tiles of you resets the bonus."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 0.3 + PST:roundFloat(0.7 * (honing / 50), -2),
                    roll2 = 8 + PST:roundFloat(4 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Consecrator
            {
                name = "Consecrator",
                spriteFrame = 12,
                weight = 100,
                ancientMods = {"consecrator"}
            },
            -- Verdant Green
            {
                name = "Verdant Green",
                spriteFrame = 13,
                weight = 100,
                ancientMods = {"verdantGreen"}
            },
            -- Lost Coral Trident
            {
                name = "Lost Coral Trident",
                spriteFrame = 14,
                weight = 100,
                ancientMods = {"lostCoralTrident"}
            },
            -- Oceanic Might
            {
                name = "Oceanic Might",
                spriteFrame = 33,
                weight = 100,
                ancientMods = {"oceanicMight"}
            }
        }
    },
    -- Scythes
    [PSTAstralWepType.SCYTHE] = {
        name = "Scythe",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 12,
            [PSTAstralWepRarity.MAGIC] = 13,
            overlay = 6
        },
        implicitMod = {
            name = "scytheImp",
            description = {
                "Hitting an enemy triggers a circular slash that hits nearby enemies for {{roll1}}% of the hit's damage.",
                "This effect has a {{roll2}} second cooldown."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 70 + PST:roundFloat(50 * (honing / 50), -2),
                    roll2 = 2.5 - PST:roundFloat(1.75 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Tale Ender
            {
                name = "Tale Ender",
                spriteFrame = 15,
                weight = 100,
                ancientMods = {"taleEnder"}
            },
            -- Crimson Reaper
            {
                name = "Crimson Reaper",
                spriteFrame = 16,
                weight = 100,
                ancientMods = {"crimsonReaper"}
            },
            -- Mobripper
            {
                name = "Mobripper",
                spriteFrame = 17,
                weight = 100,
                ancientMods = {"mobripper"}
            }
        }
    },
    -- Axes
    [PSTAstralWepType.AXE] = {
        name = "Axe",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 14,
            [PSTAstralWepRarity.MAGIC] = 15,
            overlay = 7
        },
        implicitMod = {
            name = "axeImp",
            description = {
                "{{roll1}}% chance to cause bleeding for 3 seconds when hitting enemies.",
                "+{{roll2}}% damage with hits against bleeding enemies."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 6 + PST:roundFloat(9 * (honing / 50), -2),
                    roll2 = 10 + PST:roundFloat(6 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Starsteel Broadaxe
            {
                name = "Starsteel Broadaxe",
                spriteFrame = 18,
                weight = 100,
                ancientMods = {"starsteelBroadaxe"}
            },
            -- Ancient Runic Chopper
            {
                name = "Ancient Runic Chopper",
                spriteFrame = 19,
                weight = 100,
                ancientMods = {"ancientRunicChopper"}
            },
            -- Circuit Splitter
            {
                name = "Circuit Splitter",
                spriteFrame = 36,
                weight = 100,
                ancientMods = {"circuitSplitter"}
            }
        }
    },
    -- Greataxes
    [PSTAstralWepType.GREATAXE] = {
        name = "Greataxe",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 16,
            [PSTAstralWepRarity.MAGIC] = 17,
            overlay = 8
        },
        implicitMod = {
            name = "greataxeImp",
            description = {
                "Every {{roll1}} hits against each enemy causes them to bleed for 4 seconds.",
                "+{{roll2}}% damage for 2 seconds after hitting a bleeding enemy.",
                "{{roll3}}% tears."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 5 - math.floor(honing / 20),
                    roll2 = 12 + PST:roundFloat(10 * (honing / 50), -2),
                    roll3 = -8 + PST:roundFloat(4 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Berserker's Wrath
            {
                name = "Berserker's Wrath",
                spriteFrame = 20,
                weight = 100,
                ancientMods = {"berserkerWrath"}
            },
            -- Frozen Terror
            {
                name = "Frozen Terror",
                spriteFrame = 21,
                weight = 100,
                ancientMods = {"frozenTerror"}
            }
        }
    },
    -- Shortbows
    [PSTAstralWepType.SHORTBOW] = {
        name = "Shortbow",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 18,
            [PSTAstralWepRarity.MAGIC] = 19,
            overlay = 9
        },
        implicitMod = {
            name = "shortbowImp",
            description = {
                "+{{roll1}} shot speed.",
                "{{roll2}}% of your shot speed above 1 becomes a tears multiplier, up to +80%."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 0.07 + PST:roundFloat(0.05 * (honing / 50), -2),
                    roll2 = 35 + honing
                }
            end
        },
        ancients = {
            -- Storm's Advance
            {
                name = "Storm's Advance",
                spriteFrame = 24,
                weight = 100,
                ancientMods = {"stormAdvance"}
            },
            -- Quill Rain
            {
                name = "Quill Rain",
                spriteFrame = 23,
                weight = 50,
                ancientMods = {"quillRain"}
            }
        }
    },
    -- Bows
    [PSTAstralWepType.BOW] = {
        name = "Bow",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 20,
            [PSTAstralWepRarity.MAGIC] = 21,
            overlay = 10
        },
        implicitMod = {
            name = "bowImp",
            description = {
                "+{{roll1}} shot speed.",
                "Hits against enemies deal additional damage the farther away they are from you, up to {{roll2}}%."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 0.04 + PST:roundFloat(0.04 * (honing / 50), -2),
                    roll2 = 15 + PST:roundFloat(10 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Gilded Seeker
            {
                name = "Gilded Seeker",
                spriteFrame = 25,
                weight = 100,
                ancientMods = {"gildedSeeker"}
            },
            -- Twisted Oakstring
            {
                name = "Twisted Oakstring",
                spriteFrame = 26,
                weight = 100,
                ancientMods = {"twistedOakstring"}
            },
            -- Brute's Onslaught
            {
                name = "Brute's Onslaught",
                spriteFrame = 27,
                weight = 100,
                ancientMods = {"bruteOnslaught"}
            }
        }
    },
    -- Crossbows
    [PSTAstralWepType.CROSSBOW] = {
        name = "Crossbow",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 22,
            [PSTAstralWepRarity.MAGIC] = 23,
            overlay = 11
        },
        implicitMod = {
            name = "crossbowImp",
            description = {
                "{{roll1}} tears.",
                "+{{roll2}} shot speed.",
                "Your total shot speed becomes a damage multiplier, up to {{roll3}}%."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = -0.15 + PST:roundFloat(0.1 * (honing / 50), -2),
                    roll2 = 0.08 + PST:roundFloat(0.42 * (honing / 50), -2),
                    roll3 = 30 + PST:roundFloat(20 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Volatile Arbalest
            {
                name = "Volatile Arbalest",
                spriteFrame = 28,
                weight = 100,
                ancientMods = {"volatileArbalest"}
            },
            -- Avelyn
            {
                name = "Avelyn",
                spriteFrame = 29,
                weight = 100,
                ancientMods = {"avelyn"}
            },
            -- Precise Seeker
            {
                name = "Precise Seeker",
                spriteFrame = 30,
                weight = 100,
                ancientMods = {"preciseSeeker"}
            }
        }
    },
    -- Gauntlets
    [PSTAstralWepType.GAUNTLET] = {
        name = "Gauntlet",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 24,
            [PSTAstralWepRarity.MAGIC] = 25,
            overlay = 12
        },
        implicitMod = {
            name = "gauntletImp",
            description = {
                "Can have an additional magic modifier.",
                "Transmutation cost is halved."
            },
            rollsFunc = function(honing)
                return { roll1 = 1 }
            end,
            noAncient = true
        },
        ancients = {
            -- Magefist
            {
                name = "Magefist",
                spriteFrame = 37,
                weight = 100,
                ancientMods = {"magefist"}
            },
            -- Ironhand
            {
                name = "Ironhand",
                spriteFrame = 38,
                weight = 100,
                ancientMods = {"ironhand"}
            }
        }
    }
}