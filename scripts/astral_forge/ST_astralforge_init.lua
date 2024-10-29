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
---@field equipped? boolean

-- Astral weapon modifiers
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
        description = "+{{roll1}}% damage dealt to enemies beyond 1.5 tiles of you.",
        color = {127, 107, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 4 * rollPerc[1] + math.floor(wepTier * 2.5)
            }
        end
    },
    closeEnemyDmg = {
        description = "+{{roll1}}% damage dealt to enemies within 1.5 tiles of you.",
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
        description = "+{{roll1}} base damage, removed for 10 seconds when you get hit.",
        color = {200, 20, 20},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 0.3 + 0.2 * rollPerc[1] + wepTier * 0.2
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
                roll2 = 10 + 2 * rollPerc[2] + wepTier * 2
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

    coinPickupDmg = {
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
                roll1 = 7 + 3 * rollPerc[1] + wepTier * 2,
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
                roll1 = 5 + 3 * rollPerc[1] + wepTier * 3
            }
        end
    },

    activeFamDmg = {
        description = "+{{roll1}}% damage dealt per active familiar.",
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
                roll1 = 7 + 3 * rollPerc[1] + wepTier * 2,
                roll2 = 3 + 1 * rollPerc[2] + wepTier / 3
            }
        end
    },

    holyMantleDmg = {
        description = "+{{roll1}}% damage dealt while you have a holy mantle shield.",
        color = {223, 253, 255},
        rollsFunc = function(wepTier, rollPerc)
            return {
                roll1 = 5 + 4 * rollPerc[1] + wepTier * 2
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
                roll1 = 6 + 4 * rollPerc[1] + wepTier * 2
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

    ---- ANCIENT MODS ----
    -- Ancient Longswords
    greyWind = {
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
    executioner = {
        description = {
            "+{{roll1}}% damage.",
            "{{roll2}}% chance on hit to instantly kill enemies that are left with {{roll3}}% or less HP."
        },
        ancient = true,
        minRolls = {5, 25, 7},
        maxRolls = {8, 35, 10},
        upgIncrements = {0.4, 1, 0.2}
    },
    swordOfSong = {
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
    redbeak = {
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
    maxwellEngine = {
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
    arcingNeedle = {
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
    auricPersecutor = {
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
    scrambler = {
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
    adriftBlade = {
        description = "{{roll1}}% chance on hit to deal between {{roll2}}% and {{roll3}}% of the original damage.",
        ancient = true,
        minRolls = {25, 40, 200},
        maxRolls = {35, 60, 280},
        upgIncrements = {0.5, 1, 5}
    }
}

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
            description = "{{roll1}}% damage dealt to enemies within 1.5 tiles.",
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
                    roll1 = 1 + PST:roundFloat(honing / 50, -2),
                    roll2 = 10 + math.floor(honing / 5)
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
                "{{roll1}} tears for {{roll2}} second(s) when hitting a target, up to {{roll3}}. Stacks.",
                "Double the duration if hitting targets within 1.5 tiles.",
                "Each stack has its own duration."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 0.01 + PST:roundFloat(0.03 * (honing / 50), -2),
                    roll2 = 0.5 + PST:roundFloat(honing / 50, -2),
                    roll3 = 0.4 + PST:roundFloat(0.4 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
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
                    roll1 = 9 + PST:roundFloat(9 * (honing / 50), -2),
                    roll2 = 12 - PST:roundFloat(7 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
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
        ancients = {}
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
                "Hitting an enemy causes a circular slash that hits nearby enemies for {{roll1}}% of the hit's damage.",
                "This effect has a {{roll2}} second cooldown."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 40 + PST:roundFloat(40 * (honing / 50), -2),
                    roll2 = 2.5 - PST:roundFloat(1.75 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
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
                    roll2 = 7 + PST:roundFloat(3 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
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
                "Every {{roll1}}th hit against enemies causes bleeding for 4 seconds.",
                "+{{roll2}}% damage for 2 seconds after hitting a bleeding enemy.",
                "{{roll3}}% tears."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 5 - math.floor(honing / 20),
                    roll2 = 8 + PST:roundFloat(5 * (honing / 50), -2),
                    roll3 = -12 + PST:roundFloat(6 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
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
                "{{roll2}}% of your shot speed above 1 becomes a tears multiplier, up to 40%."
            },
            rollsFunc = function(honing)
                return {
                    roll1 = 0.04 + PST:roundFloat(0.06 * (honing / 50), -2),
                    roll2 = 25 + honing
                }
            end
        },
        ancients = {}
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
                    roll1 = 0.02 + PST:roundFloat(0.04 * (honing / 50), -2),
                    roll2 = 12 + PST:roundFloat(13 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
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
                    roll2 = 0.07 + PST:roundFloat(0.7 * (honing / 50), -2),
                    roll3 = 30 + PST:roundFloat(20 * (honing / 50), -2)
                }
            end
        },
        ancients = {}
    }
}