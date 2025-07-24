PST.treeModDescriptionCategories = {
    stats = { name = PST:getLocalized("ui_modcategory_stats"), color = KColor(0.9, 1, 0.9, 1) },
    condStats = { name = PST:getLocalized("ui_modcategory_condstats"), color = KColor(0.8, 1, 0.8, 1) },
    xp = { name = PST:getLocalized("ui_modcategory_xp"), color = KColor(0.9, 0.9, 0.9, 1) },
    extra = { name = PST:getLocalized("ui_modcategory_misc"), color = KColor(0.9, 0.9, 0.7, 1) },
    charTree = { name = "", color = KColor(1, 0.8, 1, 1) }
}
PST.treeModCategoryOrder = {"stats", "condStats", "xp", "extra", "charTree"}

PST.treeModCategories = {
    stats = {
        "allstats", "allstatsPerc", "damage", "damagePerc", "luck", "luckPerc", "speed", "speedPerc", "tears", "tearsPerc",
        "shotSpeed", "shotSpeedPerc", "range", "rangePerc"
    },
    condStats = {
        "beggarLuck", "cardFloorLuck", "pillFloorLuck", "secretRoomFloorLuck", "secretRoomRandomStat", "tintedRockAllstats",
        "planetariumAllstats", "firstItemDamage", "firstItemTears", "firstItemRange", "firstItemSpeed", "firstItemShotspeed",
        "firstItemLuck", "curseAllstats", "donoMachineStatBoost"
    },
    xp = {
        "xpgain", "secretXP", "challengeXP", "challengeXPgain", "bossChallengeXP", "xpgainNormalMob", "xpgainBoss", "expertSpelunker",
        "fireXP", "poopXP", "tintedRockXP", "championXP", "beggarHelpXP", "shellGameXP", "slotMachineXP", "fortuneMachineXPmax",
        "flawlessXP", "respecChance", "relearning"
    },
    extra = {
        "devilChance", "coinDupe", "keyDupe", "bombDupe", "grabBag", "mapChance", "luckyPennyChance", "planetariumChance", "hellFavour",
        "heavenFavour", "curseRoomSpikesOut", "goldenKeyConvert", "sacrificeRoomHearts", "naturalCurseCleanse", "goldenTrinkets", "championChance",
        "activeItemReroll", "shopSaving", "spiderMod", "eldritchMapping", "trollBombDisarm", "trollDisarmGiga", "championChest", "championStoneChest",
        "championMaxChests", "spikedChestReplace", "chargedKeyConv", "clearThrowableBomb", "deadlySinKey", "deadlySinBattery", "donoEntranceRestore",
        "donoPurchaseRestore", "donoPurchaseThresh", "generosityInSteps", "bossRushTimer", "beasthunterRush", "hushTimer", "bossLockedChest",
        "bossRedChest", "bossStoneChest", "bossRushWaves", "coalescingSoulChance", "coalescingSoulProcs", "warpedCoalescence", "coalSoulRoomClearChance",
        "coalSoulHitChance", "soulStoneAllstats", "soulStoneUnusedAllstats", "sacRoomBuff", "specialSacks", "enableSCJewels", "SC_SMMightyChance",
        "SC_SMAncientChance"
    },
    charTree = {
        -- Isaac
        "isaacBlessing", "magicDie", "intermittentConceptions", "boonOrdinary", "allstatsBirthright", "allstatsRoom", "d6Pickup", "d6HalfCharge", "pickupDupe",
        "pickupBoons", "chestReclose",
        -- Magdalene
        "magdaleneBlessing", "crystalHeart", "bloodDonor", "blesserHeart", "innerGlow", "yumHeartHealHalf", "allstatsFullRed", "bloodMachineSpawn",
        "bloodDonationLuck", "bloodDonationNickel", "healOnClear", "heartblessedChests", "heartblessedSpeed", "fullHealthCharge",
        -- Cain
        "impromptuGambler", "thievery", "fickleFortune", "goldenGimmick", "wealthsmith", "stealChance", "trinketSpawn", "freeMachinesChance", "arcadeReveal",
        "shopReveal", "nickelOnClear", "gildedMachines",
        -- Judas
        "darkHeart", "innerDemon", "sacrificeDarkness", "tenetBelial", "darkApotheosis", "darkJudasSpeed", "darkJudasShotspeedRange", "belialBossHitCharge",
        "lostBlackHeartsLuck", "blackHeartLuckDrop",
        -- Blue Baby
        "blueGambit", "brownBlessing", "slippingEssence", "beanDiet", "soulOnCardPill", "poopItemLuck", "poopTrinketLuck", "thePoopAllStats", "thePoopAllStatsPerc",
        "soulHeartTearsRange", "cardPillPoop", "beanActiveSpeed",
        -- Eve
        "heartless", "darkProtection", "carrionAvian", "phantomcrows", "deadBirdNullify", "activeDeadBirdDamage", "activeDeadBirdSpeed", "activeDeadBirdTears",
        "activeDeadBirdRange", "activeDeadBirdShotspeed", "deadBirdInheritDamage", "luckOnClearBelowFull", "allstatsOneRed", "eveMascaraChamp",
        -- Samson
        "hasted", "rageBuildup", "hearty", "bloodcrowned", "samsonTempDamage", "samsonTempSpeed", "speedWhenHit", "bossCulling", "bossQuickKillLuck",
        "bossFlawlessLuck", "treasureDoubleHeart",
        -- Azazel
        "demonicSouvenirs", "demonHelpers", "demonicAmbition", "earlyBird", "heartsToBlack", "blackHeartOnDeals", "evilTrinketLuck", "devilBeggarBlackHeart",
        "cardFloorDamage", "cardFloorTears",
        -- Lazarus
        "soulfulAwakening", "kingCurse", "aTrueEnding", "growingContrition", "lazarusDamage", "lazarusSpeed", "lazarusTears", "lazarusRange", "lazarusLuck",
        "luckyAllStats", "momPlanC", "lazarusClearHearts",
        -- Eden
        "chaoticTreasury", "sporadicGrowth", "starblessed", "spaghettification", "clayshaping", "edenHairdo", "treasureShopItemStat", "treasureShopItemStatPerc",
        "devilAngelBossItemStat", "devilAngelBossItemStatPerc", "itemRandLuck", "itemRandLuckPerc", "trinketRandLuck", "startCoinKeyBomb", "edenBlessingSpawn",
        "treasureItemCEpiphany", "devilItemCEpiphany", "curseRoomCEpiphany", "myosotisOnClear",
        -- The Lost
        "spectralAdvantage", "sacredAegis", "heartseekerPhantasm", "vagrantSoul", "killingHitNegation", "noHolyMantleAllStats", "soulHeartTears", "blackHeartDamage",
        "eternalD6Charge", "soulHeartOnClear", "pennyToBlessed",
        -- Lilith
        "minionManeuvering", "heavyFriends", "daemonArmy", "companionshipGravitas", "familiarKillSoulHeart", "activeFamiliarsLuck", "activeIncubusDamage", "activeIncubusTears",
        "boxOfFriendsCharge", "boxOfFriendsAllStats", "monsterManualOnClear",
        -- Keeper
        "keeperBlessing", "gulp", "avidShopper", "blueKin", "coinShield", "itemPurchaseLuck", "purchaseKeepCoins", "firstBossGreed", "greedLowerHealth", "greedNickelDrop",
        "greedDimeDrop", "blueFlyDeathDamage",
        -- Apollyon
        "apollyonBlessing", "null", "harbingerLocusts", "reverseAnnihilation", "voidBlueFlies", "voidBlueSpiders", "voidAnnihilation", "eraserSecondFloor", "locustHeldLuck",
        "locustConsumedLuck", "conquestLocustSpeed", "deathLocustTears", "famineLocustRangeShotspeed", "pestilenceLocustLuck", "warLocustDamage",
        -- Forgotten (old)
        "soulful", "spiritEbb", "innerFlare", "innerFlareSlowDuration", "forgottenMeleeTearBuff", "forgottenSoulDamage", "forgottenSoulTears", "theSoulBoneDamage",
        "theSoulBoneTears",
        -- Forgotten
        "spiritBringer", "spiritTaker", "spiritReaper", "spiritProtector", "spiritGambler", "osteomancy", "necromancy", "soulWispOnClear", "soulWispTears", "redFullToBone",
        "treasureBoneItem", "forgCarrionPrincess",
        -- Bethany
        "willOTheWisp", "soulTrickle", "fatePendulum", "chaoticWisps", "activeItemWisp", "chargeOnClear", "soulChargeOnClear", "wispDestroyedLuck", "wispFloorBuff", "redHeartsSoulCharge",
        -- Jacob & Esau
        "heartLink", "statuePilgrimage", "coordination", "keepThemAtBay", "JEChoices", "brotherHitNegation", "jacobHeartLuck", "jacobBirthright", "jacobHeartOnKill", "esauSoulOnKill",
        "jacobItemAllstats", "slowParaExtension", "redStewBoon",
        -- Siren
        "darkSongstress", "songOfDarkness", "songOfFortune", "songOfCelerity", "songOfAwe", "overwhelmingVoice", "luckOnCharmedKill", "mightOfFortune", "charmedRetaliation",
        "charmedHitNegation", "charmExplosions",
        -- T. Isaac
        "vacuophobia", "consumingVoid", "fracturedRemains", "sinistralRunemaster", "dextralRunemaster", "blackRuneAbsorb", "trinketOnClear", "obtainedItemDamage", "obtainedItemTears",
        "obtainedItemRange", "flawlessBossLuck", "voidConsumeLuck", "diceShardRuneShard", "runicSpeed", "runeshardStacking", "runeshardStacksReq",
        -- T. Magdalene
        "taintedHealth", "testOfTemperance", "bloodful", "lingeringMalice", "creepDamage", "remainingHeartsSpeed", "remainingHeartsDmg", "remainingHeartsTears", "temporaryHeartTime",
        "temporaryHeartDmg", "temporaryHeartTears", "temporaryHeartLuck", "halfHeartPickupToFull", "bloodDonoTempHeart",
        -- T. Cain
        "ransacking", "magicBag", "opportunist", "grandIngredientCoins", "grandIngredientKeys", "craftBagMeleeDmgInherit", "craftPickupRecovery", "randPickupOnClear", "droppedSpecialPickups",
        "itemCraftingLuck", "bagBombDamage", "bagKeyTears", "bagCoinRangeLuck", "bagHeartSpeed", "additionalPedestalPickup",
        -- T. Judas
        "darkExpertise", "agileExpertise", "stealthTactics", "lightlessBounty", "annihilation", "anarchy", "howToJumpPulse", "darkArtsCDReset", "darkArtsDmg", "darkArtsCD", "darkArtsTears",
        "nonDarkArtsDmg", "darkArtsKillStat", "trollBombProtection", "trollBombKillLuck",
        -- T. Blue Baby
        "alacritousPurpose", "treasuredWaste", "asceticSoul", "slothLegacy", "holdPoopRegain", "holdEmptySpeed", "holdFullLuck", "poopDamageBuff", "poopTransmutation", "poopPickupEnlarge",
        "bobHeadFlySpawn", "holdBrownNugget", "specialPoopFind", "rainbowPoopLuck", "rainbowPoopSoul",
        -- T. Eve
        "bloodwrath", "resilientBlood", "blessedBlood", "congealedBuddy", "mysticVampirism", "clotHeartDrop", "clotHitPulse", "clotPulseDmgInherit", "lilClotDmg", "redClotAbsorbDmg",
        "soulClotAbsorbTears", "clotDmg", "redClotHeartDmg", "soulClotHeartDmg", "blackClotBabylon", "clotDestroyedLuck",
        -- T. Samson
        "balancedApproach", "tempered", "violentMarauder", "absoluteRage", "meleeDmg", "nonMeleeDmg", "berserkHitChargeGain", "berserkDuration", "berserkDmg", "berserkSpeed", "berserkTears",
        "suplexCooldown", "berserkSize", "berserkKillTempHeart", "redHeartLuckSamson", "berserkSpdTradeoff",
        -- T. Azazel
        "curseborne", "gildedRegrowth", "brimsoul", "darkBestowal", "hemoptysisSlowChance", "cursedKillTears", "proximityDamage", "hemoptysisSpeed", "brimstoneDmg", "flightlessDevilDeal", "hemoptysisKillLuck",
        -- T. Lazarus
        "ephemeralBond", "greatOverlap", "entanglement", "spiritus", "ephBondBossHitless", "ephBondFloor", "flipBossHitCharge", "flipSpecialRoomCharge", "flipMobHPDown", "floorWoodenChest", "lazFormKillStat",
        "formHeartDiffLuck",
        -- T. Eden
        "serendipitousSoul", "birthrightActiveRemoveChance", "blessedCrucifix", "normalizedVitality", "chaosTakeTheWorld", "rerollAvoidance", "devilActiveOnHit", "angelActiveOnHit", "shieldActiveStat",
        "treasureItemOnHit", "higherQualityReroll", "minLuck", "minLuckSet",
        -- T. Lost
        "glassSpecter", "helpingHands", "deferredAegis", "spindown", "quality0Upgrade", "quality1Upgrade", "quality2Upgrade", "roomEnterSpd", "roomEnterSpdDecayDur", "shieldlessBossSpeed", "champHolyCardDrop",
        "stairwayBoon", "deathTrial", "holyCardLuck",
        -- T. Lilith
        "chargingBehemoth", "mightyGestation", "coordinatedDemons", "chimericAmalgam", "whipDmg", "nonWhipDmg", "gelloPulseDmg", "pulseKillBlackHeart", "whipSpeed", "gelloTearsBonus", "cordDamage", "cordBleed",
        "tLilithTreasureBaby", "nearbyKillLuck", "familiarItemAllstats",
        -- T. Keeper
        "fortunateSpender", "marquessOfFlies", "strangeCoupon", "blessedPennies", "voodooTrick", "couponNullifyChance", "vanishCoinTimer", "coinTearsChance", "gildMonsters", "gildMonsterPenny", "gildMonsterLuck",
        "gildMonsterSpeed", "gildMonsterPennyUpgrade", "voodooCurseNickel", "blueFlyDamage", "steamSaleKeep",
        -- T. Apollyon
        "electrifiedSwarm", "closeKeeper", "carrionLocusts", "greatDevourer", "locustDmg", "extCordDmgInherit", "extCordSlow", "locustTears", "locustTearDmgInherit", "locustTearSpectral", "locustKillPickup",
        "locustKillTears", "killCricketLeg", "cricketLegSpeed", "locustKillLuck",
        -- T. Forgotten
        "forgRecall", "harmonizedSpecters", "ballistosseous", "magnetizedShell", "forgHoldSpeed", "forgNoHoldSpeed", "forgBoneTearDmg", "forgBoneTearPara", "forgBoneTearSlow", "paraEnemyDmg", "recallDmg",
        "forgTelekinesis", "flawlessClearPBone", "forgBoneTearKillLuck",
        -- T. Bethany
        "bloodHarvest", "resilientFlickers", "othersideSeeker", "inheritedChaos", "redHeartRoomDmg", "wispHomingTearRetal", "wispActiveTears", "destroyedWispItem", "blueKeyRedClear", "bloodChargeStat",
        "wispKillSoul", "tBethHomingTear", "tBethHomingTearFear", "tBethKillLuck",
        -- T. Jacob
        "reaperWraiths", "wrathfulChains", "spiritualCovenant", "kineticVengeance", "chainedEnemyDmg", "darkEsauProxDmgSpeed", "darkEsauDmg", "animaSolaCooldown", "animaSolaKillTears", "heartEternalConv",
        "slowEnemyDmg", "animaSolaDuration", "darkEsauKillLuck", "animaAddChains",
        -- T. Siren
        "shadowmeld", "darkArpeggio", "chromaticBlessing", "grandConsonance", "songOfTheFew", "fearedDmg", "fearedTearBurst", "acridGaze", "sirenMinionDmg", "darkArpeggioTearDelay", "shadowmeldExplosion",
        "shadowmeldExplosionDmg", "blackHeartFearKill", "fearedKillLuck"
    }
}

PST.treeModDescriptions = {}