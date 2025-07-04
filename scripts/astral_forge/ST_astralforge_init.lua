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
    GAUNTLET = 12,
    GREATMACE = 13,
    WHIP = 14
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
---@field starblessed? boolean
---@field favorite? boolean
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
        serial = 1,
        description = PST:getLocalized("aforge_mod_desc_dmgStatus"),
        color = {145, 203, 196},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 3 + 3 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusSlow = {
        serial = 2,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusSlow"),
        color = {185, 223, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusCharm = {
        serial = 3,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusCharm"),
        color = {249, 185, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusPara = {
        serial = 4,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusPara"),
        color = {72, 77, 92},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 7 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusFear = {
        serial = 5,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusFear"),
        color = {135, 60, 185},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusBleed = {
        serial = 6,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusBleed"),
        color = {185, 60, 93},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusPoison = {
        serial = 7,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusPoison"),
        color = {55, 172, 50},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },
    dmgStatusBurn = {
        serial = 8,
        description = PST:getLocalized("aforge_mod_desc_dmgStatusBurn"),
        color = {255, 137, 20},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2
            }
        end
    },

    consecFireDmg = {
        serial = 9,
        description = PST:getLocalized("aforge_mod_desc_consecFireDmg"),
        color = {235, 167, 90},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 5 * rollPerc[1] + math.ceil(wepTier * 1.5)
            }
        end
    },
    consecFireDmg2 = {
        serial = 10,
        description = PST:getLocalized("aforge_mod_desc_consecFireDmg2"),
        color = {255, 140, 10},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 10 + 8 * rollPerc[1] + wepTier * 2
            }
        end
    },

    farEnemyDmg = {
        serial = 11,
        description = PST:getLocalized("aforge_mod_desc_farEnemyDmg"),
        color = {127, 107, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 4 * rollPerc[1] + math.floor(wepTier * 2.5)
            }
        end
    },
    closeEnemyDmg = {
        serial = 12,
        description = PST:getLocalized("aforge_mod_desc_closeEnemyDmg"),
        color = {255, 107, 107},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + math.ceil(wepTier * 2.5)
            }
        end
    },

    baseDmg = {
        serial = 13,
        description = PST:getLocalized("aforge_mod_desc_baseDmg"),
        color = {175, 0, 0},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.1 + 0.2 * rollPerc[1] + wepTier * 0.1
            }
        end
    },
    baseDmg2 = {
        serial = 14,
        description = PST:getLocalized("aforge_mod_desc_baseDmg2"),
        color = {200, 20, 20},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.3 + 0.2 * rollPerc[1] + wepTier * 0.2,
                roll2 = 5 + 5 * rollPerc[2] - (wepTier - 1) * 0.4
            }
        end
    },

    redHealDmg = {
        serial = 15,
        description = PST:getLocalized("aforge_mod_desc_redHealDmg"),
        color = {255, 0, 110},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 2.5 * rollPerc[1] + wepTier,
                roll2 = 10 + 4 * rollPerc[2] + wepTier * 2
            }
        end
    },
    soulHealDmg = {
        serial = 16,
        description = PST:getLocalized("aforge_mod_desc_soulHealDmg"),
        color = {105, 160, 215},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 2 + 4 * rollPerc[1] + wepTier,
                roll2 = 12 + 4 * rollPerc[2] + wepTier * 2
            }
        end
    },
    blackHealDmg = {
        serial = 17,
        description = PST:getLocalized("aforge_mod_desc_blackHealDmg"),
        color = {48, 48, 48},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 2 + 4 * rollPerc[1] + wepTier,
                roll2 = 12 + 4 * rollPerc[2] + wepTier * 2
            }
        end
    },

    purchaseDmg = {
        serial = 18,
        description = PST:getLocalized("aforge_mod_desc_purchaseDmg"),
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
        serial = 19,
        description = PST:getLocalized("aforge_mod_desc_coinPickupDmg"),
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
        serial = 20,
        description = PST:getLocalized("aforge_mod_desc_coinPermDmg"),
        color = {183, 172, 5},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1 + 1 * rollPerc[1] + math.ceil(wepTier / 2),
                roll2 = 24 + 6 * rollPerc[2] + wepTier * 2
            }
        end
    },

    onHitEnemyDmgTaken = {
        serial = 21,
        description = PST:getLocalized("aforge_mod_desc_onHitEnemyDmgTaken"),
        color = {186, 113, 113},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 10 + 8 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 2 * rollPerc[2] + wepTier / 2
            }
        end
    },

    flyGroundDmg = {
        serial = 22,
        description = PST:getLocalized("aforge_mod_desc_flyGroundDmg"),
        color = {158, 255, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 4 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeFamDmg = {
        serial = 23,
        description = PST:getLocalized("aforge_mod_desc_activeFamDmg"),
        color = {177, 225, 129},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 1.5 + 1.5 * rollPerc[1] + wepTier / 2
            }
        end
    },
    famKillDmg = {
        serial = 24,
        description = PST:getLocalized("aforge_mod_desc_famKillDmg"),
        color = {182, 255, 108},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 4 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 4 * rollPerc[2] + wepTier / 3
            }
        end
    },

    holyMantleDmg = {
        serial = 25,
        description = PST:getLocalized("aforge_mod_desc_holyMantleDmg"),
        color = {223, 253, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 4 * rollPerc[1] + wepTier * 2
            }
        end
    },

    eternalDmg = {
        serial = 26,
        description = PST:getLocalized("aforge_mod_desc_eternalDmg"),
        color = {255, 255, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeDmg = {
        serial = 27,
        description = PST:getLocalized("aforge_mod_desc_activeDmg"),
        color = {0, 213, 192},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 6 + 6 * rollPerc[1] + wepTier * 2,
                roll2 = 4 + 3 * rollPerc[1] + wepTier / 3
            }
        end
    },

    healthyMobDmg = {
        serial = 28,
        description = PST:getLocalized("aforge_mod_desc_healthyMobDmg"),
        color = {255, 0, 145},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },
    injuredMobDmg = {
        serial = 29,
        description = PST:getLocalized("aforge_mod_desc_injuredMobDmg"),
        color = {150, 0, 85},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 6 * rollPerc[1] + wepTier * 3
            }
        end
    },

    creepDmg = {
        serial = 30,
        description = PST:getLocalized("aforge_mod_desc_creepDmg"),
        color = {150, 200, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 8 + 4 * rollPerc[1] + wepTier * 4
            }
        end
    },
    playerCreepDmg = {
        serial = 31,
        description = PST:getLocalized("aforge_mod_desc_playerCreepDmg"),
        color = {130, 150, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 9 + 8 * rollPerc[1] + wepTier * 3
            }
        end
    },

    laserDmg = {
        serial = 32,
        description = PST:getLocalized("aforge_mod_desc_laserDmg"),
        color = {240, 140, 110},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2.5
            }
        end
    },
    explosionDmg = {
        serial = 33,
        description = PST:getLocalized("aforge_mod_desc_explosionDmg"),
        color = {111, 111, 111},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 7 + 5 * rollPerc[1] + wepTier * 2.5
            }
        end
    },

    injuredDmg = {
        serial = 34,
        description = PST:getLocalized("aforge_mod_desc_injuredDmg"),
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
        serial = 35,
        description = PST:getLocalized("aforge_mod_desc_greyWind"),
        ancient = true,
        minRolls = {7, 120},
        maxRolls = {12, 160},
        upgIncrements = {0.5, 4}
    },
    executioner = {
        serial = 36,
        description = PST:getLocalized("aforge_mod_desc_executioner"),
        ancient = true,
        minRolls = {5, 25, 12},
        maxRolls = {8, 35, 16},
        upgIncrements = {0.4, 1, 0.25}
    },
    swordOfSong = {
        serial = 37,
        description = PST:getLocalized("aforge_mod_desc_swordOfSong"),
        ancient = true,
        minRolls = {5, 16},
        maxRolls = {8, 8},
        upgIncrements = {0.2, -1}
    },
    redbeak = {
        serial = 38,
        description = PST:getLocalized("aforge_mod_desc_redbeak"),
        ancient = true,
        minRolls = {12, 6, 4},
        maxRolls = {20, 15, 8},
        upgIncrements = {0.5, 0.5, 0.2}
    },
    glowingMoonblade = {
        serial = 39,
        description = PST:getLocalized("aforge_mod_desc_glowingMoonblade"),
        ancient = true,
        minRolls = {18, 0.06},
        maxRolls = {10, 0.12},
        upgIncrements = {-0.5, 0.005}
    },
    maxwellEngine = {
        serial = 40,
        description = PST:getLocalized("aforge_mod_desc_maxwellEngine"),
        ancient = true,
        minRolls = {6, 12},
        maxRolls = {12, 22},
        upgIncrements = {0.5, 1}
    },
    glowingSunblade = {
        serial = 41,
        description = PST:getLocalized("aforge_mod_desc_glowingSunblade"),
        ancient = true,
        minRolls = {16, 0.05},
        maxRolls = {8, 0.1},
        upgIncrements = {-0.5, 0.005}
    },
    divineInterceptor = {
        serial = 86,
        description = PST:getLocalized("aforge_mod_desc_divineInterceptor"),
        ancient = true,
        minRolls = {0},
        maxRolls = {6},
        upgIncrements = {1}
    },
    -- Ancient Estocs
    arcingNeedle = {
        serial = 42,
        description = PST:getLocalized("aforge_mod_desc_arcingNeedle"),
        ancient = true,
        minRolls = {2, 2.5},
        maxRolls = {6, 4},
        upgIncrements = {0.25, 0.1}
    },
    auricPersecutor = {
        serial = 43,
        description = PST:getLocalized("aforge_mod_desc_auricPersecutor"),
        ancient = true,
        minRolls = {20, 7, 21},
        maxRolls = {35, 15, 40},
        upgIncrements = {1, 0.5, 1}
    },
    -- Ancient Daggers
    scrambler = {
        serial = 44,
        description = PST:getLocalized("aforge_mod_desc_scrambler"),
        ancient = true,
        minRolls = {25, 50},
        maxRolls = {40, 20},
        upgIncrements = {1, -2}
    },
    adriftBlade = {
        serial = 45,
        description = PST:getLocalized("aforge_mod_desc_adriftBlade"),
        ancient = true,
        minRolls = {25, 40, 200},
        maxRolls = {35, 60, 280},
        upgIncrements = {0.5, 1, 5}
    },
    ivoryVampire = {
        serial = 46,
        description = PST:getLocalized("aforge_mod_desc_ivoryVampire"),
        ancient = true,
        minRolls = {2, 4},
        maxRolls = {4, 5},
        upgIncrements = {0.2, 0.1}
    },
    -- Ancient Quickblades
    nimbleTwins = {
        serial = 47,
        description = PST:getLocalized("aforge_mod_desc_nimbleTwins"),
        ancient = true,
        minRolls = {5, 25, 15},
        maxRolls = {12, 50, 21},
        upgIncrements = {0.5, 3, 0.5}
    },
    crimsonAltruist = {
        serial = 48,
        description = PST:getLocalized("aforge_mod_desc_crimsonAltruist"),
        ancient = true,
        minRolls = {2, 0.2, 16},
        maxRolls = {6, 0.4, 9},
        upgIncrements = {0.25, 0.02, -1}
    },
    quicksilver = {
        serial = 49,
        description = PST:getLocalized("aforge_mod_desc_quicksilver"),
        ancient = true,
        minRolls = {1.5, 8},
        maxRolls = {0.8, 12},
        upgIncrements = {-0.05, 0.4}
    },
    -- Ancient Spears
    beastbane = {
        serial = 50,
        description = PST:getLocalized("aforge_mod_desc_beastbane"),
        ancient = true,
        minRolls = {12, 4},
        maxRolls = {18, 6},
        upgIncrements = {0.5, 0.1}
    },
    gravitas = {
        serial = 51,
        description = PST:getLocalized("aforge_mod_desc_gravitas"),
        ancient = true,
        minRolls = {7, 30, 12},
        maxRolls = {12, 50, 6},
        upgIncrements = {0.25, 2, -0.5}
    },
    borealSpear = {
        serial = 52,
        description = PST:getLocalized("aforge_mod_desc_borealSpear"),
        ancient = true,
        minRolls = {7, 3},
        maxRolls = {10, 1.5},
        upgIncrements = {0.2, -0.1}
    },
    viperStinger = {
        serial = 53,
        description = PST:getLocalized("aforge_mod_desc_viperStinger"),
        ancient = true,
        minRolls = {9, 80},
        maxRolls = {15, 150},
        upgIncrements = {0.1, 4}
    },
    -- Ancient Tridents
    consecrator = {
        serial = 54,
        description = PST:getLocalized("aforge_mod_desc_consecrator"),
        ancient = true,
        minRolls = {9, 30, 5},
        maxRolls = {15, 40, 10},
        upgIncrements = {0.25, 1, 0.25}
    },
    verdantGreen = {
        serial = 55,
        description = PST:getLocalized("aforge_mod_desc_verdantGreen"),
        ancient = true,
        minRolls = {6, 25},
        maxRolls = {9, 40},
        upgIncrements = {0.2, 1}
    },
    lostCoralTrident = {
        serial = 56,
        description = PST:getLocalized("aforge_mod_desc_lostCoralTrident"),
        ancient = true,
        minRolls = {25},
        maxRolls = {12},
        upgIncrements = {-0.8}
    },
    oceanicMight = {
        serial = 57,
        description = PST:getLocalized("aforge_mod_desc_oceanicMight"),
        ancient = true,
        minRolls = {30, 5},
        maxRolls = {50, 10},
        upgIncrements = {1, 0.25}
    },
    -- Ancient Scythes
    taleEnder = {
        serial = 58,
        description = PST:getLocalized("aforge_mod_desc_taleEnder"),
        ancient = true,
        minRolls = {60, 75},
        maxRolls = {120, 100},
        upgIncrements = {3, 2}
    },
    crimsonReaper = {
        serial = 59,
        description = PST:getLocalized("aforge_mod_desc_crimsonReaper"),
        ancient = true,
        minRolls = {4, 20},
        maxRolls = {6, 50},
        upgIncrements = {0.2, 2}
    },
    mobripper = {
        serial = 60,
        description = PST:getLocalized("aforge_mod_desc_mobripper"),
        ancient = true,
        minRolls = {250, 25},
        maxRolls = {350, 15},
        upgIncrements = {8, -1}
    },
    -- Ancient Axes
    starsteelBroadaxe = {
        serial = 61,
        description = PST:getLocalized("aforge_mod_desc_starsteelBroadaxe"),
        ancient = true,
        minRolls = {20},
        maxRolls = {33},
        upgIncrements = {1}
    },
    ancientRunicChopper = {
        serial = 62,
        description = PST:getLocalized("aforge_mod_desc_ancientRunicChopper"),
        ancient = true,
        minRolls = {3, 24, 12},
        maxRolls = {5, 36, 18},
        upgIncrements = {0.1, 0.8, 0.4}
    },
    circuitSplitter = {
        serial = 63,
        description = PST:getLocalized("aforge_mod_desc_circuitSplitter"),
        ancient = true,
        minRolls = {15, 2},
        maxRolls = {25, 3},
        upgIncrements = {1, 0.1}
    },
    -- Ancient Greataxes
    berserkerWrath = {
        serial = 64,
        description = PST:getLocalized("aforge_mod_desc_berserkerWrath"),
        ancient = true,
        minRolls = {3},
        maxRolls = {5},
        upgIncrements = {0.1, 0.5, 1}
    },
    frozenTerror = {
        serial = 65,
        description = PST:getLocalized("aforge_mod_desc_frozenTerror"),
        ancient = true,
        minRolls = {15, 1.5, 80},
        maxRolls = {25, 2.5, 160},
        upgIncrements = {1, 0.1, 4}
    },
    -- Ancient Shortbows
    stormAdvance = {
        serial = 66,
        description = PST:getLocalized("aforge_mod_desc_stormAdvance"),
        ancient = true,
        minRolls = {10, 40},
        maxRolls = {6, 100},
        upgIncrements = {-0.25, 4}
    },
    quillRain = {
        serial = 67,
        description = PST:getLocalized("aforge_mod_desc_quillRain"),
        ancient = true,
        minRolls = {2.5, 40},
        maxRolls = {1.5, 10},
        upgIncrements = {-0.1, -2}
    },
    -- Ancient Bows
    gildedSeeker = {
        serial = 68,
        description = PST:getLocalized("aforge_mod_desc_gildedSeeker"),
        ancient = true,
        minRolls = {25, 25},
        maxRolls = {40, 40},
        upgIncrements = {1, 1}
    },
    twistedOakstring = {
        serial = 69,
        description = PST:getLocalized("aforge_mod_desc_twistedOakstring"),
        ancient = true,
        minRolls = {2.5, 80},
        maxRolls = {1.5, 140},
        upgIncrements = {-0.1, 4}
    },
    bruteOnslaught = {
        serial = 70,
        description = PST:getLocalized("aforge_mod_desc_bruteOnslaught"),
        ancient = true,
        minRolls = {20, 10},
        maxRolls = {40, 16},
        upgIncrements = {2, 0.4}
    },
    divineMessenger = {
        serial = 87,
        description = PST:getLocalized("aforge_mod_desc_divineMessenger"),
        ancient = true,
        minRolls = {12},
        maxRolls = {18},
        upgIncrements = {0.5}
    },
    -- Ancient Crossbows
    volatileArbalest = {
        serial = 71,
        description = PST:getLocalized("aforge_mod_desc_volatileArbalest"),
        ancient = true,
        minRolls = {7, 250},
        maxRolls = {10, 400},
        upgIncrements = {0.2, 10}
    },
    avelyn = {
        serial = 72,
        description = PST:getLocalized("aforge_mod_desc_avelyn"),
        ancient = true,
        minRolls = {4, 40},
        maxRolls = {2.5, 75},
        upgIncrements = {-0.1, 1}
    },
    preciseSeeker = {
        serial = 73,
        description = PST:getLocalized("aforge_mod_desc_preciseSeeker"),
        ancient = true,
        minRolls = {5, 200},
        maxRolls = {2.5, 400},
        upgIncrements = {-0.25, 10}
    },
    -- Ancient Gauntlets
    magefist = {
        serial = 74,
        description = PST:getLocalized("aforge_mod_desc_magefist"),
        ancient = true,
        minRolls = {0.2},
        maxRolls = {1.5},
        upgIncrements = {0.1}
    },
    ironhand = {
        serial = 75,
        description = PST:getLocalized("aforge_mod_desc_ironhand"),
        ancient = true,
        minRolls = {0.2},
        maxRolls = {1},
        upgIncrements = {0.05}
    },
    metamorphicClaw = {
        serial = 76,
        description = PST:getLocalized("aforge_mod_desc_metamorphicClaw"),
        ancient = true,
        minRolls = {0},
        maxRolls = {8},
        upgIncrements = {1}
    },
    -- Ancient Great Maces
    mightyPurifier = {
        serial = 77,
        description = PST:getLocalized("aforge_mod_desc_mightyPurifier"),
        ancient = true,
        minRolls = {1.5, 15, 25},
        maxRolls = {2.5, 22, 35},
        upgIncrements = {0.1, 0.5, 1}
    },
    chaoticTumult = {
        serial = 78,
        description = PST:getLocalized("aforge_mod_desc_chaoticTumult"),
        ancient = true,
        minRolls = {3, 8},
        maxRolls = {4, 15},
        upgIncrements = {0.1, 0.5}
    },
    firestarter = {
        serial = 79,
        description = PST:getLocalized("aforge_mod_desc_firestarter"),
        ancient = true,
        minRolls = {12, 220},
        maxRolls = {18, 300},
        upgIncrements = {0.2, 6}
    },
    colossalMaul = {
        serial = 80,
        description = PST:getLocalized("aforge_mod_desc_colossalMaul"),
        ancient = true,
        minRolls = {3, 12, 30},
        maxRolls = {2, 5, 40},
        upgIncrements = {-0.1, -0.5, 1}
    },
    tollingBell = {
        serial = 81,
        description = PST:getLocalized("aforge_mod_desc_tollingBell"),
        ancient = true,
        minRolls = {7, 10, 10},
        maxRolls = {12, 18, 20},
        upgIncrements = {0.5, 0.5, 1}
    },
    -- Ancient Whips
    snakebite = {
        serial = 82,
        description = PST:getLocalized("aforge_mod_desc_snakebite"),
        ancient = true,
        minRolls = {250},
        maxRolls = {400},
        upgIncrements = {10}
    },
    devilTongue = {
        serial = 83,
        description = PST:getLocalized("aforge_mod_desc_devilTongue"),
        ancient = true,
        minRolls = {0.8, 12},
        maxRolls = {1.6, 18},
        upgIncrements = {0.05, 0.5}
    },
    azurebinder = {
        serial = 84,
        description = PST:getLocalized("aforge_mod_desc_azurebinder"),
        ancient = true,
        minRolls = {1, 8},
        maxRolls = {3, 15},
        upgIncrements = {0.2, 0.2, 0.4}
    },
    sacredScourge = {
        serial = 85,
        description = PST:getLocalized("aforge_mod_desc_sacredScourge"),
        ancient = true,
        minRolls = {5},
        maxRolls = {9},
        upgIncrements = {0.2}
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
            description = PST:getLocalized("aforge_mod_desc_longswordImp"),
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
            },
            -- Divine Interceptor
            {
                name = "Divine Interceptor",
                spriteFrame = 51,
                weight = 100,
                ancientMods = {"divineInterceptor"}
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
            description = PST:getLocalized("aforge_mod_desc_estocImp"),
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
            description = PST:getLocalized("aforge_mod_desc_daggerImp"),
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
            },
            -- Ivory Vampire
            {
                name = "Ivory Vampire",
                spriteFrame = 39,
                weight = 100,
                ancientMods = {"ivoryVampire"}
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
            description = PST:getLocalized("aforge_mod_desc_quickbladeImp"),
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
            },
            -- Quicksilver
            {
                name = "Quicksilver",
                spriteFrame = 46,
                weight = 100,
                ancientMods = {"quicksilver"}
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
            description = PST:getLocalized("aforge_mod_desc_spearImp"),
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
            description = PST:getLocalized("aforge_mod_desc_tridentImp"),
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
            description = PST:getLocalized("aforge_mod_desc_scytheImp"),
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
            description = PST:getLocalized("aforge_mod_desc_axeImp"),
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
            description = PST:getLocalized("aforge_mod_desc_greataxeImp"),
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
            description = PST:getLocalized("aforge_mod_desc_shortbowImp"),
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
            description = PST:getLocalized("aforge_mod_desc_bowImp"),
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
            },
            -- Divine Messenger
            {
                name = "Divine Messenger",
                spriteFrame = 52,
                weight = 100,
                ancientMods = {"divineMessenger"}
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
            description = PST:getLocalized("aforge_mod_desc_crossbowImp"),
            rollsFunc = function(honing)
                return {
                    roll1 = -0.15 + PST:roundFloat(0.1 * (honing / 50), -2),
                    roll2 = 0.08 + PST:roundFloat(0.42 * (honing / 50), -2),
                    roll3 = 10 + PST:roundFloat(15 * (honing / 50), -2)
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
            description = PST:getLocalized("aforge_mod_desc_gauntletImp"),
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
            },
            -- Metamorphic Claw
            {
                name = "Metamorphic Claw",
                spriteFrame = 45,
                weight = 100,
                ancientMods = {"metamorphicClaw"}
            }
        }
    },
    -- Great Maces
    [PSTAstralWepType.GREATMACE] = {
        name = "Great Mace",
        internalName = "GreatMace",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 26,
            [PSTAstralWepRarity.MAGIC] = 27,
            overlay = 13
        },
        implicitMod = {
            name = "greatmaceImp",
            description = PST:getLocalized("aforge_mod_desc_greatmaceImp"),
            rollsFunc = function(honing)
                return {
                    roll1 = 1.5 + PST:roundFloat(0.5 * (honing / 50), -2),
                    roll2 = 200 + honing,
                    roll3 = 7 - PST:roundFloat(1.5 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Mighty Purifier
            {
                name = "Mighty Purifier",
                spriteFrame = 40,
                weight = 100,
                ancientMods = {"mightyPurifier"}
            },
            -- Chaotic Tumult
            {
                name = "Chaotic Tumult",
                spriteFrame = 41,
                weight = 100,
                ancientMods = {"chaoticTumult"}
            },
            -- Firestarter
            {
                name = "Firestarter",
                spriteFrame = 42,
                weight = 100,
                ancientMods = {"firestarter"}
            },
            -- Colossal Maul
            {
                name = "Colossal Maul",
                spriteFrame = 43,
                weight = 100,
                ancientMods = {"colossalMaul"}
            },
            -- Tolling Bell
            {
                name = "Tolling Bell",
                spriteFrame = 44,
                weight = 100,
                ancientMods = {"tollingBell"}
            }
        }
    },
    -- Whips
    [PSTAstralWepType.WHIP] = {
        name = "Whip",
        internalName = "Whip",
        spriteFrames = {
            [PSTAstralWepRarity.NORMAL] = 28,
            [PSTAstralWepRarity.MAGIC] = 29,
            overlay = 14
        },
        implicitMod = {
            name = "whipImp",
            description = PST:getLocalized("aforge_mod_desc_whipImp"),
            rollsFunc = function(honing)
                return {
                    roll1 = 0.3 + PST:roundFloat(0.9 * (honing / 50), -2), --1.5 + PST:roundFloat(0.5 * (honing / 50), -2),
                    roll2 = 8 + PST:roundFloat(7 * (honing / 50), -2),
                    roll3 = 2 + PST:roundFloat(3 * (honing / 50), -2)
                }
            end
        },
        ancients = {
            -- Snakebite
            {
                name = "Snakebite",
                spriteFrame = 47,
                weight = 100,
                ancientMods = {"snakebite"}
            },
            -- Devil's Tongue
            {
                name = "Devil's Tongue",
                spriteFrame = 48,
                weight = 100,
                ancientMods = {"devilTongue"}
            },
            -- Azurebinder
            {
                name = "Azurebinder",
                spriteFrame = 49,
                weight = 100,
                ancientMods = {"azurebinder"}
            },
            -- Sacred Scourge
            {
                name = "Sacred Scourge",
                spriteFrame = 50,
                weight = 100,
                ancientMods = {"sacredScourge"}
            }
        }
    }
}