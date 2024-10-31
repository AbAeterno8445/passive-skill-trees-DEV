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
    CROSSBOW = 11
}

---@enum PSTAstralWepRarity
PSTAstralWepRarity = {
    NORMAL = 0,
    MAGIC = 1,
    ANCIENT = 2
}

---@class PSTAstralWepModEntry
---@field name string
---@field rolls table

---@class PSTAstralWeapon
---@field type PSTAstralWepType
---@field rarity PSTAstralWepRarity
---@field tier number
---@field implicitMod? number[]
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
    dmgStatus = { -- TODO
        description = "+{{roll1}}% damage dealt to enemies affected by status effects.",
        color = {145, 203, 196},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 3 + 3 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusSlow = { -- TODO
        description = "+{{roll1}}% damage dealt to slowed enemies.",
        color = {185, 223, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusCharm = { -- TODO
        description = "+{{roll1}}% damage dealt to charmed enemies.",
        color = {249, 185, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusPara = { -- TODO
        description = "+{{roll1}}% damage dealt to paralyzed enemies.",
        color = {72, 77, 92},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 7 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusFear = { -- TODO
        description = "+{{roll1}}% damage dealt to feared enemies.",
        color = {135, 60, 185},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusBleed = { -- TODO
        description = "+{{roll1}}% damage dealt to bleeding enemies.",
        color = {185, 60, 93},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },

    consecFireDmg = { -- TODO
        description = "+{{roll1}}% damage dealt after firing consecutively for 2 seconds. Resets when you stop firing.",
        color = {235, 167, 90},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 5 * rollPerc[1] + math.ceil(wepTier * 1.5)
            }
        end
    },
    consecFireDmg2 = { -- TODO
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

    farEnemyDmg = { -- TODO
        description = "+{{roll1}}% damage dealt to enemies beyond 1.5 tiles of you.",
        color = {127, 107, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 4 * rollPerc[1] + math.floor(wepTier * 2.5)
            }
        end
    },
    closeEnemyDmg = { -- TODO
        description = "+{{roll1}}% damage dealt to enemies within 1.5 tiles of you.",
        color = {255, 107, 107},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + math.ceil(wepTier * 2.5)
            }
        end
    },

    baseDmg = { -- TODO
        description = "+{{roll1}} base damage.",
        color = {175, 0, 0},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.1 + 0.2 * rollPerc[1] + wepTier * 0.1
            }
        end
    },
    baseDmg2 = { -- TODO
        description = "+{{roll1}} base damage, removed for 10 seconds when you get hit.",
        color = {200, 20, 20},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.3 + 0.2 * rollPerc[1] + wepTier * 0.2
            }
        end
    },

    redHealDmg = { -- TODO
        description = {
            "When healing red hearts, +{{roll1}}% damage dealt for 5 seconds per 1/2 red heart recovered,",
            "which stacks up to {{roll2}}%."
        },
        color = {255, 0, 110},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 2.5 * rollPerc[1] + wepTier,
                roll2 = 10 + 2 * rollPerc[2] + wepTier * 2
            }
        end
    },
    soulHealDmg = { -- TODO
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
    blackHealDmg = { -- TODO
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

    purchaseDmg = { -- TODO
        description = "+{{roll1}}% damage for {{roll2}} seconds after purchasing an item, which stacks up to {{roll3}}%.",
        color = {255, 250, 188},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 3 + 2 * rollPerc[1] + wepTier,
                roll2 = 22 + 8 * rollPerc[2] + wepTier * 4,
                roll3 = 10 + 5 * rollPerc[3] + wepTier * 3
            }
        end
    },

    coinPickupDmg = { -- TODO
        description = "+{{roll1}}% damage dealt for {{roll2}} seconds after picking up any coin, which stacks up to {{roll3}}%.",
        color = {255, 244, 78},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 1.5 * rollPerc[1] + wepTier / 2,
                roll2 = 3 + 2 * rollPerc[2] + wepTier / 2,
                roll3 = 10 + 5 * rollPerc[3] + wepTier * 2
            }
        end
    },
    coinPermDmg = { -- TODO
        description = "+{{roll1}}% permanent damage after picking up any coin worth at least 5, up to {{roll2}}%.",
        color = {183, 172, 5},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1 + 1 * rollPerc[1] + math.ceil(wepTier / 2),
                roll2 = 24 + 6 * rollPerc[2] + wepTier * 2
            }
        end
    },

    onHitEnemyDmgTaken = { -- TODO
        description = "All enemies take {{roll1}}% more damage for {{roll2}} seconds after you get hit.",
        color = {186, 113, 113},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 3 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 2 * rollPerc[2] + wepTier / 2
            }
        end
    },

    flyGroundDmg = { -- TODO
        description = {
            "+{{roll1}}% damage dealt to flying enemies if you're on the ground.",
            "+{{roll1}}% damage dealt to ground enemies if you're flying."
        },
        color = {158, 255, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 3 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeFamDmg = { -- TODO
        description = "+{{roll1}}% damage dealt per active familiar.",
        color = {177, 225, 129},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 1.5 * rollPerc[1] + wepTier / 2
            }
        end
    },
    famKillDmg = { -- TODO
        description = "+{{roll1}}% damage dealt for {{roll2}} seconds after a familiar kills an enemy.",
        color = {182, 255, 108},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 3 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 1 * rollPerc[2] + wepTier / 3
            }
        end
    },

    holyMantleDmg = { -- TODO
        description = "+{{roll1}}% damage dealt while you have a holy mantle shield.",
        color = {223, 253, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 4 * rollPerc[1] + wepTier * 2
            }
        end
    },

    eternalDmg = { -- TODO
        description = "+{{roll1}}% damage dealt while you have an eternal heart.",
        color = {255, 255, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeDmg = { -- TODO
        description = "+{{roll1}}% damage dealt for {{roll2}} seconds after using an active item.",
        color = {0, 213, 192},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 6 + 4 * rollPerc[1] + wepTier * 2
            }
        end
    },

    healthyMobDmg = { -- TODO
        description = "+{{roll1}}% damage dealt to enemies above 90% HP.",
        color = {255, 0, 145},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },
    injuredMobDmg = { -- TODO
        description = "+{{roll1}}% damage dealt to enemies below 15% HP.",
        color = {150, 0, 85},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },

    creepDmg = { -- TODO
        description = "+{{roll1}}% damage dealt while standing on creep.",
        color = {150, 200, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 4 * rollPerc[1] + wepTier * 4
            }
        end
    },

    ---- ANCIENT MODS ----
    -- Ancient Longswords
    greyWind = { -- TODO
        description = {
            "{{roll1}}% chance on hit to slash all enemies within 2 tiles of the target, dealing {{roll2}}%",
            "of the hit's damage. This effect has a 1 second cooldown.",
            "If the slashes target less than 3 enemies, they deal double damage and cause bleeding for 4 seconds."
        },
        ancient = true,
        minRolls = {7, 120},
        maxRolls = {12, 160},
        upgIncrements = {0.5, 4}
    },
    executioner = { -- TODO
        description = {
            "+{{roll1}}% damage.",
            "{{roll2}}% chance on hit to instantly kill enemies that are left with {{roll3}}% or less HP."
        },
        ancient = true,
        minRolls = {5, 25, 7},
        maxRolls = {8, 35, 10},
        upgIncrements = {0.4, 1, 0.2}
    },
    swordOfSong = { -- TODO
        description = {
            "{{roll1}}% chance on hit to cause an area pulse at the hit's location that charms nearby enemies for 3 seconds.",
            "+1% damage whenever you kill a charmed monster.",
            "Every {{roll2}} charmed monsters you kill, reset the damage bonus and trigger Isaac's Tears' item effect."
        },
        ancient = true,
        minRolls = {5, 20},
        maxRolls = {8, 10},
        upgIncrements = {0.2, -1}
    },
    redbeak = { -- TODO
        description = {
            "If half or more of your total red heart containers are empty:",
            "    +{{roll1}}% damage dealt.",
            "    {{roll2}}% chance for hits to inflict bleed on enemies.",
            "    {{roll3}}% chance for bleeding enemies to drop a 1/2 red heart on kill, which vanishes after 2 seconds."
        },
        ancient = true,
        minRolls = {12, 6, 4},
        maxRolls = {20, 15, 8},
        upgIncrements = {0.5, 0.5, 0.2}
    },
    maxwellEngine = { -- TODO
        description = {
            "+0.5% damage for 3 seconds when hitting an enemy, which stacks up to {{roll1}}%.",
            "While the buff is maxed:",
            "    {{roll2}}% chance for hits to cause burning or slow for 3 seconds on hit.",
            "    15% chance for burning enemies to explode on death, dealing damage to nearby enemies but not you.",
            "    15% chance for slowed enemies to freeze on death."
        },
        ancient = true,
        minRolls = {6, 12},
        maxRolls = {12, 22},
        upgIncrements = {0.5, 1}
    },
    -- Ancient Estocs
    arcingNeedle = { -- TODO
        description = {
            "Every 0.5 seconds spent firing, {{roll1}}% chance to gain Jacob's Ladder as an innate effect for {{roll2}} seconds.",
            "Chance goes up in 2% increments as you keep firing, and resets once you stop firing.",
            "Obtaining Jacob's Ladder naturally grants you +15% tears."
        },
        ancient = true,
        minRolls = {2, 2.5},
        maxRolls = {6, 4},
        upgIncrements = {0.25, 0.1}
    },
    auricPersecutor = { -- TODO
        description = {
            "Half of your coin count now acts as a tears multiplier, up to {{roll1}}%.",
            "+{{roll2}}% damage for the current floor when picking up a coin worth at least 5, up to {{roll3}}%."
        },
        ancient = true,
        minRolls = {25, 3, 15},
        maxRolls = {40, 6, 24},
        upgIncrements = {1, 0.2, 0.5}
    },
    -- Ancient Daggers
    scrambler = { -- TODO
        description = {
            "3% chance on hit to confuse enemies. Double the chance against targets within 1.5 tiles.",
            "Deal {{roll1}}% more damage against confused enemies.",
            "Hitting confused enemies has a {{roll2}}% chance to remove their confusion."
        },
        ancient = true,
        minRolls = {25, 50},
        maxRolls = {40, 20},
        upgIncrements = {1, -2}
    },
    adriftBlade = { -- TODO
        description = "{{roll1}}% chance on hit to deal between {{roll2}}% and {{roll3}}% of the original damage.",
        ancient = true,
        minRolls = {25, 40, 200},
        maxRolls = {35, 60, 280},
        upgIncrements = {0.5, 1, 5}
    },
    -- Ancient Quickblades
    nimbleTwins = { -- TODO
        description = {
            "+{{roll1}}% tears.",
            "When hitting an enemy, additionally fire a slow-moving red tear and a quick blue tear towards them.",
            "These tears have {{roll2}}% of your damage and range.",
            "Gain +3% damage for 2 seconds when hitting enemies with the red tear, which stacks up to {{roll3}}%.",
            "Gain +3% tears for 2 seconds when hitting enemies with the blue tear, which stacks up to {{roll3}}%."
        },
        ancient = true,
        minRolls = {5, 25, 15},
        maxRolls = {12, 50, 21},
        upgIncrements = {0.5, 3, 0.5}
    },
    crimsonAltruist = { -- TODO
        description = {
            "+{{roll1}}% damage when using a blood donation machine, up to 100%.",
            "+{{roll2}} tears when a blood donation machine explodes on use.",
            "Halve the active bonuses when entering a new floor."
        },
        ancient = true,
        minRolls = {2, 0.2},
        maxRolls = {6, 0.4},
        upgIncrements = {0.25, 0.02}
    },
    -- Ancient Spears
    beastbane = { -- TODO
        description = {
            "+{{roll1}}% damage dealt to bosses.",
            "Defeating a boss grants you a permanent +{{roll2}}% damage, once every 2 floors."
        },
        ancient = true,
        minRolls = {12, 4},
        maxRolls = {18, 6},
        upgIncrements = {0.5, 0.1}
    },
    gravitas = { -- TODO
        description = {
            "When hitting enemies within 1.5 and 2.5 tiles away from you, {{roll1}}% chance to additionally fire",
            "3 homing tears dealing {{roll2}}% of your damage. 0.5 seconds cooldown.",
            "When hitting enemies with the homing tears, 1% chance to gain Spoon Bender for the current room.",
            "-{{roll3}}% tears while you have Spoon Bender."
        },
        ancient = true,
        minRolls = {6, 30, 12},
        maxRolls = {10, 50, 6},
        upgIncrements = {0.25, 2, -0.5}
    },
    borealSpear = { -- TODO
        description = {
            "{{roll1}}% chance on hit to slow enemies for 2 seconds.",
            "When you hit a slowed enemy beyond {{roll2}} tiles of you, +1% chance to freeze that enemy.",
            "Hitting enemies repeatedly increases the chance to freeze them, with the freeze chance being",
            "individual to each enemy."
        },
        ancient = true,
        minRolls = {6, 3},
        maxRolls = {9, 1.5},
        upgIncrements = {0.2, -0.1}
    },
    viperStinger = { -- TODO
        description = {
            "{{roll1}}% chance to paralyze enemies on hit for 2 seconds.",
            "Double this chance against poisoned enemies.",
            "Killing a paralyzed enemy releases a toxic cloud, poisoning and dealing {{roll2}}% of your damage",
            "to nearby enemies."
        },
        ancient = true,
        minRolls = {3, 80},
        maxRolls = {5, 150},
        upgIncrements = {0.1, 4}
    },
    -- Ancient Tridents
    consecrator = { -- TODO
        description = {
            "Gain +{{roll1}}% damage when entering a devil room, up to {{roll2}}%.",
            "Gain +{{roll1}}% tears when entering an angel room, up to {{roll2}}%.",
            "Active buffs get halved when clearing a boss room.",
            "+{{roll3}}% chance for angel/devil rooms to show up."
        },
        ancient = true,
        minRolls = {6, 30, 5},
        maxRolls = {10, 40, 10},
        upgIncrements = {0.25, 1, 0.25}
    },
    verdantGreen = { -- TODO
        description = {
            "{{roll1}}% chance on hit to create a poison cloud.",
            "Poison clouds periodically poison enemies within it. Poisoned enemies instead take {{roll2}}%",
            "of your damage.",
            "Up to 3 poison clouds can be active in the room simultaneously."
        },
        ancient = true,
        minRolls = {6, 25},
        maxRolls = {9, 40},
        upgIncrements = {0.2, 1}
    },
    lostCoralTrident = { -- TODO
        description = {
            "Start with innate Neptunus.",
            "-{{roll1}}% damage."
        },
        ancient = true,
        minRolls = {25},
        maxRolls = {12},
        upgIncrements = {-0.8}
    },
    oceanicMight = { -- TODO
        description = {
            "Start with innate Aquarius.",
            "Creeps of any type deal {{roll1}}% more damage to enemies.",
            "+{{roll2}}% speed while standing on creep."
        },
        ancient = true,
        minRolls = {30, 5},
        maxRolls = {50, 10},
        upgIncrements = {1, 0.25}
    },
    -- Ancient Scythes
    taleEnder = { -- TODO
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
    crimsonReaper = { -- TODO
        description = {
            "When hitting a full health enemy, apply bleed to them for {{roll1}} seconds.",
            "Double this duration against bosses.",
            "Bleeding enemies below {{roll1}}% HP take increased damage based on their missing HP below {{roll2}}%."
        },
        ancient = true,
        minRolls = {4, 20},
        maxRolls = {6, 50},
        upgIncrements = {0.2, 2}
    },
    mobripper = { -- TODO
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
    starsteelBroadaxe = { -- TODO
        description = {
            "+2% tears for the current room when hitting bleeding enemies, up to {{roll1}}%.",
            "Hitting a boss reduces their status effect cooldown by 0.5 seconds."
        },
        ancient = true,
        minRolls = {20},
        maxRolls = {40},
        upgIncrements = {1}
    },
    ancientRunicChopper = { -- TODO
        description = {
            "+{{roll1}}% permanent damage whenever you use a rune, up to {{roll2}}%.",
            "+{{roll3}}% tears for 10 seconds whenever you use a rune.",
            "Receive half of these boosts when using rune shards."
        },
        ancient = true,
        minRolls = {3, 24, 8},
        maxRolls = {5, 36, 12},
        upgIncrements = {0.1, 0.8, 0.2}
    },
    -- Ancient Greataxes
    berserkerWrath = { -- TODO
        description = {
            "Gain Berserk! as an innate effect when entering a floor, if you don't have it.",
            "Remove Berserk! once it triggers.",
            "+{{roll1}} seconds to Berserk!'s duration.",
            "+{{roll2}}% damage during berserk."
        },
        ancient = true,
        minRolls = {3, 8},
        maxRolls = {5, 15},
        upgIncrements = {0.1, 0.5}
    },
    frozenTerror = { -- TODO
        description = {
            "When hitting bleeding enemies, {{roll1}}% chance to slow them for 2 seconds.",
            "When hitting slowed enemies within {{roll2}} tile(s) of you, perform a circular slash around you",
            "that can freeze slowed enemies. 1 second cooldown.",
            "Slash deals {{roll3}}% of your damage."
        },
        ancient = true,
        minRolls = {15, 1, 80},
        maxRolls = {25, 2, 160},
        upgIncrements = {1, 0.1, 4}
    },
    -- Ancient Shortbows
    stormAdvance = { -- TODO
        description = {
            "When hitting enemies beyond 2.5 tiles of you, create a storm cloud at their position that",
            "lasts 8 seconds. {{roll1}} second cooldown.",
            "Storm clouds periodically zap enemies near it for {{roll2}} damage.",
            "Gain +{{roll3}}% tears and electrified tears when inside a storm cloud."
        },
        ancient = true,
        minRolls = {6, 5, 7},
        maxRolls = {3, 8, 10},
        upgIncrements = {-0.2, 0.2, 0.2}
    },
    quillRain = { -- TODO
        description = {
            "Start with innate Soy Milk.",
            "Deal half as much damage to enemies within {{roll1}} tiles of you.",
            "Turns the implicit shot speed to tear multiplier into a damage multiplier."
        },
        ancient = true,
        minRolls = {3},
        maxRolls = {1.5},
        upgIncrements = {-0.1}
    },
    -- Ancient Bows
    gildedSeeker = { -- TODO
        description = {
            "Gain +1% damage when collecting any coin, up to {{roll1}}%.",
            "Halve your current bonus when clearing a room.",
            "{{roll2}}% chance for fired tears to be coin tears."
        },
        ancient = true,
        minRolls = {40, 5},
        maxRolls = {60, 15},
        upgIncrements = {1, 0.5}
    },
    twistedOakstring = { -- TODO
        description = {
            "When hitting enemies beyond {{roll1}} tiles of you, create an additional homing and",
            "fearing tear at their position.",
            "This tear deals {{roll2}}% of the hit's damage."
        },
        ancient = true,
        minRolls = {3, 80},
        maxRolls = {1.5, 140},
        upgIncrements = {-0.1, 4}
    },
    bruteOnslaught = { -- TODO
        description = {
            "When using an active item, for each charge used, boost the next 3 hits' damage by {{roll1}}%.",
            "+{{roll2}}% tears for 5 seconds after using an active item."
        },
        ancient = true,
        minRolls = {20, 7},
        maxRolls = {40, 12},
        upgIncrements = {2, 0.2}
    },
    -- Ancient Crossbows
    volatileArbalest = { -- TODO
        description = {
            "{{roll1}}% chance to cause a small explosion when hitting enemies beyond 2.5 tiles of you,",
            "dealing {{roll2}}% of your damage. 2 seconds cooldown."
        },
        ancient = true,
        minRolls = {6, 250},
        maxRolls = {10, 400},
        upgIncrements = {0.25, 10}
    },
    avelyn = { -- TODO
        description = {
            "Every {{roll1}} total seconds spent firing, shoot 3 tears towards a nearby enemy, each dealing {{roll2}}%",
            "of your damage."
        },
        ancient = true,
        minRolls = {4, 33},
        maxRolls = {2.5, 50},
        upgIncrements = {-0.1, 1}
    },
    preciseSeeker = { -- TODO
        description = {
            "When entering a room, mark a random enemy. Prioritizes bosses.",
            "Every {{roll1}} seconds, fire a very quick piercing and spectral tear towards the marked enemy.",
            "Fired tear deals {{roll2}}% of your damage, up to 80."
        },
        ancient = true,
        minRolls = {6, 200},
        maxRolls = {4, 400},
        upgIncrements = {-0.1, 10}
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
                ancientMods = {"ancientNeedle"}
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
                "{{roll2}} shot speed.",
                "Your total shot speed becomes a damage multiplier, up to {{roll3}}%."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = -0.15 + PST:roundFloat(0.1 * (honing / 50), -2),
                    roll2 = 0.08 + PST:roundFloat(0.8 * (honing / 50), -2),
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
    }
}