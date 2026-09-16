-- Defines which floors companion slots 1 and 2 are active in
PST.astralCompSlotFloors = {{1, 5}, {6, 10}}

-- objReqs: {hatching, level 1->2, level 2->3}
PST.astralCompanions = {
    rat = {
        identifier = "astralcomp_rat",
        compSprite = 0,
        scavengeRanges = {{1, 3}, {2, 6}, 8},
        scavengeMax = {20, 30, 40},
        objReqs = {40, 60, 100},
        maxLevelEffects = {
            roomClearCoin = 7
        }
    },
    riverRat = {
        identifier = "astralcomp_riverrat",
        compSprite = 1,
        scavengeRanges = {10, 18, 24},
        scavengeMax = {10, 15, 20},
        objReqs = {25, 40, 65},
        maxLevelEffects = {
            pennyToDouble = 15
        }
    },
    hellRat = {
        identifier = "astralcomp_hellrat",
        compSprite = 2,
        scavengeRanges = {7, 10, 15},
        scavengeMax = {20, 25, 30},
        objReqs = {40, 70, 100},
        maxLevelEffects = {
            champExtraCoin = 8
        }
    },
    quokka = {
        identifier = "astralcomp_quokka",
        compSprite = 3,
        scavengeRanges = {{1, 2}, {3, 4}, 6},
        scavengeMax = {15, 20, 25},
        objReqs = {70, 120, 160},
        maxLevelEffects = {
            extraPickupOnGrab = 7
        }
    },
    jackal = {
        identifier = "astralcomp_jackal",
        compSprite = 4,
        eggRate = 10,
        scavengeRanges = {5, 8, 12},
        scavengeMax = {10, 15, 25},
        objReqs = {30, 40, 50},
        maxLevelEffects = {
            championChest = 10
        }
    },
    hound = {
        identifier = "astralcomp_hound",
        compSprite = 5,
        eggRate = 10,
        scavengeRanges = {7, 9, 12},
        scavengeMax = {10, 15, 20},
        objReqs = {15, 25, 35},
        maxLevelEffects = {
            houndGoldChestOnClear = 10
        }
    },
    wolf = {
        identifier = "astralcomp_wolf",
        compSprite = 6,
        eggRate = 10,
        scavengeRanges = {6, 10, 15},
        scavengeMax = {15, 20, 20},
        objReqs = {25, 45, 65},
        maxLevelEffects = {
            chestReclose = 7
        }
    },
    cosmicHound = {
        identifier = "astralcomp_cosmichound",
        compSprite = 7,
        eggRate = 25,
        scavengeRanges = {8, 12, 18},
        scavengeMax = {20, 20, 20},
        objReqs = {15, 30, 50},
        maxLevelEffects = {
            cHoundSideCacheOnClear = 5
        }
    },
    hellHound = {
        identifier = "astralcomp_hellhound",
        compSprite = 8,
        scavengeRanges = {2, 4, 7},
        scavengeMax = {20, 25, 30},
        objReqs = {45, 70, 120},
        maxLevelEffects = {
            hHoundBurnKillDmg = 0.5
        }
    },
    raiju = {
        identifier = "astralcomp_raiju",
        compSprite = 9,
        eggRate = 33,
        scavengeRanges = {{8, 10}, {12, 15}, {18, 22}},
        scavengeMax = {20, 25, 30},
        objReqs = {20, 35, 55},
        maxLevelEffects = {
            raijuBatteryOnClear = 7,
            raijuCapacitor = 20
        }
    },
    boulderBeetle = {
        identifier = "astralcomp_boulderbeetle",
        compSprite = 10,
        eggRate = 25,
        scavengeRanges = {{10, 15}, {16, 22}, {23, 30}},
        objReqs = {20, 35, 50},
        maxLevelEffects = {
            boulderBeetleTintRocks = 7
        }
    },
    bombardierBeetle = {
        identifier = "astralcomp_bombardierbeetle",
        compSprite = 11,
        eggRate = 10,
        scavengeRanges = {8, 15, 25},
        scavengeMax = {10, 15, 15},
        objReqs = {45, 70, 115},
        maxLevelEffects = {
            startingBomb = 1
        }
    },
    deathScarab = {
        identifier = "astralcomp_deathscarab",
        compSprite = 12,
        eggRate = 10,
        scavengeRanges = {{4, 8}, {10, 12}, {14, 18}},
        scavengeMax = {20, 25, 30},
        objReqs = {30, 50, 75},
        maxLevelEffects = {
            undeadDmg = 7,
            deathScarabFlies = 15
        }
    },
    pharaohAnt = {
        identifier = "astralcomp_pharaohant",
        compSprite = 13,
        eggRate = 40,
        scavengeRanges = {{5, 7}, {8, 10}, {11, 12}},
        scavengeOdds = {15, 20, 25},
        scavengeMax = {20, 25, 25},
        objReqs = {50, 80, 120},
        maxLevelEffects = {
            undeadChamps = 15
        }
    },
    clockroach = {
        identifier = "astralcomp_clockroach",
        compSprite = 14,
        eggRate = 10,
        scavengeRanges = {{5, 7}, {8, 9}, {10, 12}},
        scavengeOdds = {15, 25, 35},
        scavengeMax = {15, 20, 25},
        objReqs = {50, 75, 110},
        maxLevelEffects = {
            clockroachSlow = 8
        }
    },
    butterfly = {
        identifier = "astralcomp_butterfly",
        compSprite = 15,
        scavengeRanges = {10, 14, 18},
        objReqs = {35, 55, 90},
        maxLevelEffects = {
            butterflyRoomSpeed = 0.01
        }
    },
    lunarMoth = {
        identifier = "astralcomp_lunarmoth",
        compSprite = 16,
        eggRate = 33,
        scavengeRanges = {25, 35, 48},
        objReqs = {45, 70, 110},
        maxLevelEffects = {
            lunarMothSecretRoomStats = 1
        }
    },
    crimsonMoth = {
        identifier = "astralcomp_crimsonmoth",
        compSprite = 35,
        eggRate = 8,
        scavengeRanges = {15, 20, 25},
        scavengeOdds = {50, 50, 50},
        scavengeMax = {15, 20, 25},
        objReqs = {12, 22, 42},
        maxLevelEffects = {
            crimsonMothRedRooms = true,
            redRoomSpeedPerc = 3,
        }
    },
    adder = {
        identifier = "astralcomp_adder",
        compSprite = 17,
        eggRate = 8,
        scavengeRanges = {{3, 5}, {6, 8}, 10},
        scavengeOdds = {2, 3, 5},
        scavengeMax = {25, 25, 25},
        objReqs = {60, 120, 200},
        maxLevelEffects = {
            remainingPoisonDmg = 1,
            blackMambaPoisonChampObols = 7
        }
    },
    waterMoccasin = {
        identifier = "astralcomp_watermoccasin",
        compSprite = 18,
        eggRate = 50,
        scavengeRanges = {{6, 8}, {11, 12}, 15},
        scavengeOdds = {40, 50, 60},
        scavengeMax = {25, 30, 35},
        objReqs = {25, 50, 75},
        maxLevelEffects = {
            waterMocPoisonKillDmg = 0.5,
            blackMambaPoisonLuck = 0.05
        }
    },
    --[[
    blackMamba = { 
        identifier = "astralcomp_blackmamba",
        compSprite = 19,
        eggRate = 40,
        scavengeRanges = {7, 10, 14},
        scavengeOdds = {20, 22, 25},
        scavengeMax = {40, 45, 50},
        objReqs = {50, 90, 150},
        maxLevelEffects = {
            blackMambaPoisonLuck = 0.05,
            blackMambaPoisonChampObols = 7
        }
    },]]
    manaViper = {
        identifier = "astralcomp_manaviper",
        compSprite = 20,
        eggRate = 10,
        scavengeRanges = {10, 12, 16},
        scavengeOdds = {7, 10, 15},
        scavengeMax = {20, 25, 30},
        objReqs = {50, 75, 100},
        maxLevelEffects = {
            microBatteryOnActive = 7
        }
    },
    anaconda = {
        identifier = "astralcomp_anaconda",
        compSprite = 21,
        eggRate = 7,
        scavengeRanges = {7, 10, 14},
        scavengeOdds = {5, 8, 15},
        scavengeMax = {20, 25, 30},
        objReqs = {60, 80, 120},
        maxLevelEffects = {
            anacondaPetrifKillDmg = 0.5,
            remainingPetrifDmg = 1
        }
    },
    snappingTurtle = {
        identifier = "astralcomp_snappingturtle",
        compSprite = 22,
        eggRate = 10,
        scavengeRanges = {12, 16, 20},
        scavengeOdds = {25, 35, 50},
        scavengeMax = {20, 25, 25},
        objReqs = {25, 40, 66},
        maxLevelEffects = {
            snapTurtleBossBlock = 50
        }
    },
    alligatorSnappingTurtle = {
        identifier = "astralcomp_alligatorsnappingturtle",
        compSprite = 23,
        eggRate = 5,
        scavengeRanges = {12, 24, 36},
        objReqs = {15, 20, 30},
        maxLevelEffects = {
            aSnapTurtleBossBlock = 25
        }
    },
    mountainshell = {
        identifier = "astralcomp_mountainshell",
        compSprite = 24,
        eggRate = 33,
        scavengeRanges = {35, 50, 70},
        objReqs = {8, 15, 25},
        maxLevelEffects = {
            mountainshellBlock = 2
        }
    },
    culicivora = {
        identifier = "astralcomp_culicivora",
        compSprite = 25,
        eggRate = 8,
        scavengeRanges = {2, 4, 7},
        scavengeMax = {30, 35, 40},
        objReqs = {55, 75, 100},
        maxLevelEffects = {
            culicivoraBleedKillDmg = 0.5,
            remainingBleedDmg = 1
        }
    },
    abyssalTarantula = {
        identifier = "astralcomp_abyssaltarantula",
        compSprite = 26,
        eggRate = 8,
        scavengeRanges = {7, 10, 14},
        scavengeOdds = {5, 8, 15},
        scavengeMax = {25, 30, 35},
        objReqs = {60, 90, 135},
        maxLevelEffects = {
            abTarFearKillDmg = 0.5,
            remainingFearDmg = 1
        }
    },
    jumpingSpider = {
        identifier = "astralcomp_jumpingspider",
        compSprite = 27,
        eggRate = 40,
        scavengeRanges = {8, 11, 15},
        scavengeMax = {20, 25, 30},
        objReqs = {50, 60, 75},
        maxLevelEffects = {
            jumpSpiderSlowKillDmg = 0.5,
            remainingSlowDmg = 1
        }
    },
    scorpion = {
        identifier = "astralcomp_scorpion",
        compSprite = 28,
        eggRate = 40,
        scavengeRanges = {6, 8, 10},
        scavengeOdds = {5, 10, 14},
        scavengeMax = {25, 30, 35},
        objReqs = {50, 75, 110},
        maxLevelEffects = {
            scorpionHeartOnKill = 1
        }
    },
    emperorScorpion = {
        identifier = "astralcomp_emperorscorpion",
        compSprite = 29,
        eggRate = 33,
        scavengeRanges = {8, 12, 16},
        scavengeOdds = {15, 20, 25},
        scavengeMax = {20, 25, 30},
        objReqs = {30, 45, 75},
        maxLevelEffects = {
            empScorpionSoulOnKill = 1
        }
    },
    cosmicJellyfish = {
        identifier = "astralcomp_cosmicjellyfish",
        compSprite = 30,
        eggRate = 8,
        scavengeRanges = {30, 40, 50},
        scavengeOdds = {4, 6, 8},
        objReqs = {15, 25, 35},
        maxLevelEffects = {
            cJellyfishSoulSpeed = 1
        }
    },
    manticore = {
        identifier = "astralcomp_manticore",
        compSprite = 31,
        eggRate = 8,
        scavengeRanges = {8, 14, 20},
        scavengeOdds = {35, 40, 50},
        scavengeMax = {20, 25, 25},
        objReqs = {100, 250, 400},
        maxLevelEffects = {
            bossDiffStatusDmg = 2
        }
    },
    catoblepas = {
        identifier = "astralcomp_catoblepas",
        compSprite = 32,
        eggRate = 5,
        scavengeRanges = {18, 22, 26},
        scavengeOdds = {50, 65, 80},
        scavengeMax = {20, 25, 25},
        objReqs = {30, 55, 80},
        maxLevelEffects = {
            petrifChampObols = 15
        }
    },
    skyshark = {
        identifier = "astralcomp_skyshark",
        compSprite = 33,
        eggRate = 20,
        scavengeRanges = {10, 12, 15},
        scavengeOdds = {30, 40, 50},
        scavengeMax = {20, 25, 30},
        objReqs = {40, 70, 110},
        maxLevelEffects = {
            skysharkBleedEnemDmg = 1,
            bleedChampObols = 7
        }
    },
    goldenDragon = {
        identifier = "astralcomp_goldendragon",
        compSprite = 34,
        eggRate = 50,
        scavengeRanges = {200, 260, 320},
        objReqs = {1, 2, 3},
        maxLevelEffects = {
            finalBossDmg = 7
        }
    },
    shadowDragon = {
        identifier = "astralcomp_shadowdragon",
        compSprite = 36,
        eggRate = 10,
        scavengeRanges = {50, 70, 90},
        objReqs = {3, 6, 14},
        maxLevelEffects = {
            shadowDragDevilDealDmg = 2
        }
    },
    pearlDragon = {
        identifier = "astralcomp_pearldragon",
        compSprite = 37,
        eggRate = 20,
        scavengeRanges = {70, 100, 120},
        objReqs = {7, 10, 14},
        maxLevelEffects = {
            pearlDragAngelRoomDmg = 2
        }
    },
    iceBeast = {
        identifier = "astralcomp_icebeast",
        compSprite = 38,
        eggRate = 10,
        scavengeRanges = {{7, 10}, {12, 15}, {16, 18}},
        scavengeOdds = {10, 12, 15},
        scavengeMax = {20, 25, 30},
        objReqs = {35, 60, 90},
        maxLevelEffects = {
            iceBeastFrozenDmg = 1
        }
    },
    gildedGolem = {
        identifier = "astralcomp_gildedgolem",
        compSprite = 39,
        eggRate = 10,
        scavengeRanges = {1, 2, 3},
        scavengeMax = {100, 200, 250},
        objReqs = {15, 25, 45},
        maxLevelEffects = {
            gildedGolemPurchaseDmg = 1
        }
    },
    salamander = {
        identifier = "astralcomp_salamander",
        compSprite = 40,
        eggRate = 2,
        scavengeRanges = {3, 6, 9},
        scavengeMax = {20, 25, 30},
        objReqs = {30, 50, 80},
        maxLevelEffects = {
            salamanderRedHeartLuck = 1
        }
    },
    warg = {
        identifier = "astralcomp_warg",
        compSprite = 41,
        eggRate = 33,
        scavengeRanges = {{30, 60}, {70, 100}, {90, 140}},
        objReqs = {3, 6, 12},
        maxLevelEffects = {
            wargChallAllStats = 1
        }
    },
    dreamSheep = {
        identifier = "astralcomp_dreamsheep",
        compSprite = 42,
        scavengeRanges = {4, 8, 12},
        objReqs = {7000, 20000, 60000},
        maxLevelEffects = {
            flawlessXP = 15,
            flawlessObols = 15,
            dreamSheepFirstDmgSoul = 15
        }
    },
    bluecap = {
        identifier = "astralcomp_bluecap",
        compSprite = 43,
        scavengeRanges = {{5, 8}, {9, 12}, 15},
        objReqs = {20, 35, 60},
        maxLevelEffects = {
            bluecapPillDmg = 1,
            bluecapChampDeathPill = 7
        }
    }
}
PST.astralCompanionsLen = 0
for _ in pairs(PST.astralCompanions) do
    PST.astralCompanionsLen = PST.astralCompanionsLen + 1
end
PST.astralCompanionsOrdered = {
    "rat", "riverRat", "hellRat", "quokka", "jackal", "hound", "wolf", "cosmicHound", "hellHound",
    "warg", "raiju", "dreamSheep", "iceBeast", "salamander", "boulderBeetle", "bombardierBeetle", "deathScarab",
    "pharaohAnt", "clockroach", "butterfly", "lunarMoth", "crimsonMoth", "adder",
    "waterMoccasin", "manaViper", "anaconda", "snappingTurtle", "alligatorSnappingTurtle",
    "mountainshell", "culicivora", "abyssalTarantula", "jumpingSpider", "scorpion", "emperorScorpion",
    "cosmicJellyfish", "manticore", "catoblepas", "skyshark", "iceBeast", "goldenDragon", "shadowDragon",
    "pearlDragon", "gildedGolem"
}