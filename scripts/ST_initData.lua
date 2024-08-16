-- Mod data initialization
PST.modName = "Passive Skill Trees"
PST.modData = {}
PST.selectedMenuChar = -1
PST.startXPRequired = 34
PST.charNames = {
	"Isaac", "Magdalene", "Cain", "Judas", "???", "Eve",
	"Samson", "Azazel", "Lazarus", "Eden", "The Lost", "Lazarus",
	"Judas", "Lilith", "Keeper", "Apollyon", "The Forgotten", "The Forgotten",
	"Bethany", "Jacob & Esau", "Jacob & Esau",
	"T. Isaac", "T. Magdalene", "T. Cain", "T. Judas", "T. ???", "T. Eve",
	"T. Samson", "T. Azazel", "T. Lazarus", "T. Eden", "T. Lost", "T. Lilith",
	"T. Keeper", "T. Apollyon", "T. Forgotten", "T. Bethany", "T. Jacob", "T. Lazarus",
	"T. Jacob", "T. Forgotten"
}
PST.allstatsCache = CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_LUCK

-- For custom mod images
PST.customNodeImages = {}

-- Initialization performed on the first menu render call
function PST:firstRenderInit()
	-- Init mod char names here
	if Isaac.GetPlayerTypeByName("Siren") ~= -1 then
		PST.charNames[1 + Isaac.GetPlayerTypeByName("Siren")] = "Siren"
	end
	if Isaac.GetPlayerTypeByName("Siren", true) ~= -1 then
		PST.charNames[1 + Isaac.GetPlayerTypeByName("Siren", true)] = "T. Siren"
	end
end

PST.babyFamiliarItems = {
    CollectibleType.COLLECTIBLE_BROTHER_BOBBY, CollectibleType.COLLECTIBLE_HARLEQUIN_BABY,
    CollectibleType.COLLECTIBLE_HEADLESS_BABY, CollectibleType.COLLECTIBLE_LITTLE_STEVEN,
    CollectibleType.COLLECTIBLE_MONGO_BABY, CollectibleType.COLLECTIBLE_ROTTEN_BABY,
    CollectibleType.COLLECTIBLE_SISTER_MAGGY, CollectibleType.COLLECTIBLE_ABEL,
    CollectibleType.COLLECTIBLE_ACID_BABY, CollectibleType.COLLECTIBLE_BOILED_BABY,
    CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX, CollectibleType.COLLECTIBLE_CUBE_BABY,
    CollectibleType.COLLECTIBLE_DEMON_BABY, CollectibleType.COLLECTIBLE_DRY_BABY,
    CollectibleType.COLLECTIBLE_FARTING_BABY, CollectibleType.COLLECTIBLE_FREEZER_BABY,
    CollectibleType.COLLECTIBLE_GHOST_BABY, CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    CollectibleType.COLLECTIBLE_INCUBUS, CollectibleType.COLLECTIBLE_KING_BABY,
    CollectibleType.COLLECTIBLE_LIL_ABADDON, CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
    CollectibleType.COLLECTIBLE_LIL_LOKI, CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,
    CollectibleType.COLLECTIBLE_QUINTS, CollectibleType.COLLECTIBLE_RAINBOW_BABY,
    CollectibleType.COLLECTIBLE_ROBO_BABY, CollectibleType.COLLECTIBLE_ROBO_BABY_2,
    CollectibleType.COLLECTIBLE_SERAPHIM, CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
    CollectibleType.COLLECTIBLE_TWISTED_PAIR
}
PST.poopItems = {
	CollectibleType.COLLECTIBLE_FLUSH, CollectibleType.COLLECTIBLE_POOP,
	CollectibleType.COLLECTIBLE_BROWN_NUGGET, CollectibleType.COLLECTIBLE_E_COLI,
	CollectibleType.COLLECTIBLE_BUTT_BOMBS, CollectibleType.COLLECTIBLE_DIRTY_MIND,
	CollectibleType.COLLECTIBLE_HALLOWED_GROUND, CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE,
	CollectibleType.COLLECTIBLE_NUMBER_TWO, CollectibleType.COLLECTIBLE_SKATOLE
}
PST.poopTrinkets = {
	TrinketType.TRINKET_PETRIFIED_POOP, TrinketType.TRINKET_BUTT_PENNY, TrinketType.TRINKET_MECONIUM,
	TrinketType.TRINKET_BROWN_CAP, TrinketType.TRINKET_USED_DIAPER, TrinketType.TRINKET_DINGLE_BERRY,
	TrinketType.TRINKET_GIGANTE_BEAN, TrinketType.TRINKET_MYSTERIOUS_CANDY, TrinketType.TRINKET_LIL_LARVA
}
PST.evilTrinkets = {
	TrinketType.TRINKET_GOAT_HOOF, TrinketType.TRINKET_BLACK_LIPSTICK, TrinketType.TRINKET_DAEMONS_TAIL,
	TrinketType.TRINKET_LEFT_HAND, TrinketType.TRINKET_BLACK_FEATHER, TrinketType.TRINKET_MECONIUM,
	TrinketType.TRINKET_SIGIL_OF_BAPHOMET
}
PST.demonFamiliars = {
	CollectibleType.COLLECTIBLE_DARK_BUM, CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
	CollectibleType.COLLECTIBLE_INCUBUS, CollectibleType.COLLECTIBLE_LIL_ABADDON,
	CollectibleType.COLLECTIBLE_TWISTED_PAIR, CollectibleType.COLLECTIBLE_SUCCUBUS
}
PST.heartUpItems = {
	[CollectibleType.COLLECTIBLE_IMMACULATE_HEART] = 1,
	[CollectibleType.COLLECTIBLE_VENUS] = 1,
	[CollectibleType.COLLECTIBLE_JUPITER] = 2,
	[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = 1,
	[CollectibleType.COLLECTIBLE_SUPPER] = 1,
	[CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM] = 1,
	[CollectibleType.COLLECTIBLE_HEART] = 1,
	[CollectibleType.COLLECTIBLE_RAW_LIVER] = 2,
	[CollectibleType.COLLECTIBLE_LUNCH] = 1,
	[CollectibleType.COLLECTIBLE_DINNER] = 1,
	[CollectibleType.COLLECTIBLE_DESSERT] = 1,
	[CollectibleType.COLLECTIBLE_BREAKFAST] = 1,
	[CollectibleType.COLLECTIBLE_ROTTEN_MEAT] = 1,
	[CollectibleType.COLLECTIBLE_SUPER_BANDAGE] = 3,
	[CollectibleType.COLLECTIBLE_HALO] = 1,
	[CollectibleType.COLLECTIBLE_BLOOD_BAG] = 1,
	[CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE] = 1,
	[CollectibleType.COLLECTIBLE_BUCKET_OF_LARD] = 2,
	[CollectibleType.COLLECTIBLE_STIGMATA] = 1,
	[CollectibleType.COLLECTIBLE_STEM_CELLS] = 1,
	[CollectibleType.COLLECTIBLE_HOLY_GRAIL] = 1,
	[CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = 1,
	[CollectibleType.COLLECTIBLE_MEAT] = 1,
	[CollectibleType.COLLECTIBLE_PLACENTA] = 1,
	[CollectibleType.COLLECTIBLE_OLD_BANDAGE] = 1,
	[CollectibleType.COLLECTIBLE_BLACK_LOTUS] = 3,
	[CollectibleType.COLLECTIBLE_MAGIC_SCAB] = 1,
	[CollectibleType.COLLECTIBLE_CANCER] = 3,
	[CollectibleType.COLLECTIBLE_CAPRICORN] = 1,
	[CollectibleType.COLLECTIBLE_MAGGYS_BOW] = 1,
	[CollectibleType.COLLECTIBLE_THUNDER_THIGHS] = 1,
	[CollectibleType.COLLECTIBLE_BLUE_CAP] = 1,
	[CollectibleType.COLLECTIBLE_SNACK] = 1,
	[CollectibleType.COLLECTIBLE_CRACK_JACKS] = 1,
	[CollectibleType.COLLECTIBLE_MIDNIGHT_SNACK] = 1,
	[CollectibleType.COLLECTIBLE_MARROW] = 1,
	[CollectibleType.COLLECTIBLE_SOCKS] = 2,
	[CollectibleType.COLLECTIBLE_REVELATION] = 2,
	[CollectibleType.COLLECTIBLE_ROSARY] = 3,
	[CollectibleType.COLLECTIBLE_MARK] = 1,
	[CollectibleType.COLLECTIBLE_SUPER_BANDAGE] = 2,
	[CollectibleType.COLLECTIBLE_SOUL] = 2,
	[CollectibleType.COLLECTIBLE_LATCH_KEY] = 1,
	[CollectibleType.COLLECTIBLE_MOMS_PEARLS] = 1,
	[CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = 2,
	[CollectibleType.COLLECTIBLE_PJS] = 4,
	[CollectibleType.COLLECTIBLE_BINKY] = 1,
	[CollectibleType.COLLECTIBLE_METAL_PLATE] = 1,
	[CollectibleType.COLLECTIBLE_CONE_HEAD] = 1,
	[CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE] = 2,
	[CollectibleType.COLLECTIBLE_BOZO] = 1,
	[CollectibleType.COLLECTIBLE_BLANKET] = 1,
	[CollectibleType.COLLECTIBLE_FALSE_PHD] = 1,
	[CollectibleType.COLLECTIBLE_PACT] = 2,
	[CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES] = 3,
	[CollectibleType.COLLECTIBLE_ABADDON] = 2,
	[CollectibleType.COLLECTIBLE_BLACK_CANDLE] = 1,
	[CollectibleType.COLLECTIBLE_MISSING_PAGE_2] = 1,
	[CollectibleType.COLLECTIBLE_SAFETY_PIN] = 1,
	[CollectibleType.COLLECTIBLE_MATCH_BOOK] = 1,
	[CollectibleType.COLLECTIBLE_EMPTY_VESSEL] = 2,
	[CollectibleType.COLLECTIBLE_DIVORCE_PAPERS] = 1,
	[CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION] = 1,
	[CollectibleType.COLLECTIBLE_FATE] = 1,
	[CollectibleType.COLLECTIBLE_SACRED_HEART] = 1,
	[CollectibleType.COLLECTIBLE_BODY] = 3
}
PST.locustTrinkets = {
	TrinketType.TRINKET_LOCUST_OF_DEATH, TrinketType.TRINKET_LOCUST_OF_FAMINE, TrinketType.TRINKET_LOCUST_OF_PESTILENCE,
	TrinketType.TRINKET_LOCUST_OF_WRATH, TrinketType.TRINKET_LOCUST_OF_CONQUEST
}
PST.deadlySinBosses = {
	EntityType.ENTITY_ENVY, EntityType.ENTITY_GLUTTONY, EntityType.ENTITY_WRATH,
	EntityType.ENTITY_PRIDE, EntityType.ENTITY_LUST, EntityType.ENTITY_GREED,
	EntityType.ENTITY_SLOTH
}

-- First update when entering a new floor
PST.floorFirstUpdate = false

-- For trinket pickup updates
PST.trinketUpdateProc = 0

function PST:resetMods()
	-- List of available tree modifiers
	PST.modData.treeMods = {
		allstats = 0, -- Flat addition to damage, luck, speed, tears, shot speed and range
		damage = 0,
		luck = 0,
		speed = 0,
		tears = 0,
		shotSpeed = 0,
		range = 0,
		xpgain = 0,
		respecChance = 30, -- Chance to gain respec on floor clear
		secretXP = 0, -- Flat xp granted when entering a secret room
		challengeXP = 0, -- Flat xp granted when completing a challenge room round
		challengeXPgain = 0, -- Extra XP gain % within a challenge room
		bossChallengeXP = false, -- Whether challenge room XP mods apply to boss challenge rooms
		xpgainNormalMob = 0, -- Extra XP gain for normal mobs
		xpgainBoss = 0, -- Extra XP gain for bosses
		beggarLuck = 0, -- Flat luck granted when offering to a beggar
		devilChance = 0, -- Extra chance to spawn devil/angel room, overrides stage penalty similar to goat's head/eucharist
		coinDupe = 0, -- Chance to gain an extra coin when picking one up
		keyDupe = 0, -- Chance to gain an extra key when picking one up
		bombDupe = 0, -- Chance to gain an extra bomb when picking one up
		grabBag = 0, -- Chance to spawn a grab bag when picking up a coin/key/bomb
		mapChance = 0, -- Chance to reveal the map on floor beginning (applied from floor 2 onwards)

		allstatsPerc = 0, -- Multiplier version of allstats
		damagePerc = 0,
		rangePerc = 0,
		tearsPerc = 0,
		speedPerc = 0,
		shotSpeedPerc = 0,
		luckPerc = 0,

		floorLuckPerc = 0,
		floorLuck = 0,

		staticEntitiesCache = {}, -- For storing the state of 'static entities' such as fireplaces, poop and tinted rocks
		roomClearProc = false,

		luckyPennyChance = 0,
		cardFloorLuck = 0,
		pillFloorLuck = 0,
		secretRoomFloorLuck = 0,
		fireXP = 0,
		poopXP = 0,
		tintedRockXP = 0,
		tintedRockAllstats = 0,
		planetariumChance = 0,
		planetariumAllstats = 0,
		planetariumAllstatsProc = false,
		secretRoomRandomStat = 0,
		firstItemDamage = 0,
		firstItemTears = 0,
		firstItemRange = 0,
		firstItemSpeed = 0,
		firstItemShotspeed = 0,
		firstItemLuck = 0,
		cardAgainstHumanityProc = false,
		bossChallengeUnlock = 0,
		bossChallengeUnlockProc = false,
		floorSmeltTrinket = 0,
		shopSaving = 0,
		shopSavingCache = {},

		causeCurse = false, -- If true, causes a curse when entering the next floor then flips back to false. Skipped by items like black candle

		-- 'Keystone' nodes
		relearning = false,
		relearningFloors = 0, -- Completed floors counter for Relearning node
		quickWit = {0, 0}, -- XP gain {ceil, floor} for Quick Wit node. Starts at ceil when entering a room, and after a delay, gradually lowers down to floor
		expertSpelunker = 0,
		hellFavour = false,
		heavenFavour = false,
		-- If set to a character's PlayerType, achievements can be unlocked as if playing that character while playing a different one.
		-- e.g. If set to PlayerType.PLAYER_CAIN, killing ??? in the chest will unlock Cain's Eye.
		cosmicRealignment = false, ---@type boolean|PlayerType
		-- Helper vars for Cosmic Realignment effects
		cosmicRCache = {
			lazarusHasDied = false,
			blueBabyHearts = 0,
			eveActive = false,
			samsonDmg = 0,
			lilithActive = false,
			keeperFloorCoins = 0,
			forgottenKeeperDebuff = 0,
			bethanyKeeperLuck = 0,
			jacobProcs = 0,
			TIsaacProc = false,
			TIsaacItems = 0,
			TCainActive = false,
			TCainBag = false,
			TCainUses = 0,
			TJudasDmgUps = 0,
			TSamsonBuffer = 0,
			TLazarusBank1 = { active = true, red = 0, max = 0, soul = 0, black = 0, bone = 0, rotten = 0, broken = 0, eternal = 0 },
			TLazarusBank2 = { red = 0, max = 0, soul = 4, black = 0, bone = 0, rotten = 0, broken = 0, eternal = 0 },
			TEdenDebuff = {
				damage = -0.15, luck = -0.15, speed = -0.15, tears = -0.15, shotSpeed = -0.15, range = -0.15,
				damagePerc = 0, luckPerc = 0, speedPerc = 0, tearsPerc = 0, shotSpeedPerc = 0, rangePerc = 0
			},
			TLostKeeperCoins = 0,
			TApollyonLocusts = 0,
			TForgottenTracker = { soul = false, bone = false, keeperCoin = false, keeperHeal = false },
			TBethanyDeadWisps = 0
		},

		---- CHARACTER TREE MODS ----
        ---- Isaac's tree ----
        isaacBlessing = 0, -- Mom Heart Proc
        magicDie = false,
        magicDieData = {
            source = "none", -- Can be: "none" (not procced yet), "any" (unspecified room), "angel", "devil", "boss", "treasure" (for both treasure room and shop)
            value = 0
        },
        intermittentConceptions = false,
		intermittentProc = 0,
        allstatsBirthright = 0,
        allstatsRoom = 0,
        allstatsRoomProc = false,
        d6Pickup = 0,
        d6HalfCharge = 0,
        ---- Magdalene's tree ----
        allstatsFullRed = 0,
        allstatsFullRedProc = false,
        magdaleneBlessing = false,
        crystalHeart = false,
        bloodDonor = false,
        yumHeartHealHalf = 0,
        bloodMachineSpawn = 0,
        bloodDonationLuck = 0,
        bloodDonationNickel = 0,
        healOnClear = 0,
		---- Cain's tree ----
		impromptuGambler = false,
		impromptuGamblerProc = false,
		thievery = false,
		thieveryGreedProc = false,
		fickleFortune = false,
		fickleFortuneActive = false,
		stealChance = 0,
		trinketSpawn = 0,
		freeMachinesChance = 0,
		arcadeReveal = 0,
		shopReveal = 0,
		nickelOnClear = 0,
		---- Judas' Tree ----
		darkHeart = false,
		darkHeartActive = false,
		darkHeartBelial = false,
		innerDemon = false,
		innerDemonActive = false,
		sacrificeDarkness = false,
		blackHeartSacrifices = 0,
		darkJudasSpeed = 0,
		darkJudasShotspeedRange = 0,
		belialBossHitCharge = 0,
		belialChargesGained = 0,
		lostBlackHeartsLuck = 0,
		---- Blue Baby's Tree ----
		blueGambit = false,
		blueGambitCardProc = false,
		blueGambitPillProc = false,
		brownBlessing = false,
		slippingEssence = false,
		slippingEssenceLost = 0,
		soulOnCardPill = 0,
		poopItemLuck = 0,
		poopTrinketLuck = 0,
		poopTrinketLuckActive = false,
		thePoopAllStats = 0,
		thePoopAllStatsPerc = 0,
		poopAllStatsProc = false,
		soulHeartTearsRange = 0,
		soulHeartTearsRangeTotal = 0,
		---- Eve's Tree ----
		heartless = false,
		heartlessTotal = 0,
		darkProtection = false,
		darkProtectionProc = false,
		carrionAvian = false,
		carrionAvianTempBonus = 0,
		deadBirdNullify = 0,
		activeDeadBirdDamage = 0,
		activeDeadBirdSpeed = 0,
		activeDeadBirdTears = 0,
		activeDeadBirdRange = 0,
		activeDeadBirdShotspeed = 0,
		deadBirdInheritDamage = 0,
		luckOnClearBelowFull = 0,
		allStatsOneRed = 0,
		allStatsOneRedActive = false,
		---- Samson's Tree ----
		hasted = false,
		hastedHits = 0,
		rageBuildup = false,
		rageBuildupTotal = 0,
		hearty = false,
		samsonTempDamage = 0,
		samsonTempSpeed = 0,
		samsonTempActive = false,
		samsonTempTime = 0,
		speedWhenHit = 0,
		speedWhenHitTotal = 0,
		bossCulling = 0,
		bossQuickKillLuck = 0,
		bossFlawlessLuck = 0,
		---- Azazel's Tree ----
		demonicSouvenirs = false,
		demonicSouvenirsProc = false,
		demonicSouvenirsTrinket = false,
		demonHelpers = false,
		demonHelpersBeggarChance = 5,
		heartsToBlack = 0,
		blackHeartOnDeals = 0,
		evilTrinketLuck = 0,
		devilBeggarBlackHeart = 0,
		cardFloorDamage = 0,
		cardFloorDamageTotal = 0,
		cardFloorTears = 0,
		cardFloorTearsTotal = 0,
		---- Lazarus' Tree ----
		soulfulAwakening = false,
		kingCurse = false,
		kingCurseActive = false,
		aTrueEnding = false,
		aTrueEndingCardUses = 0,
		lazarusDamage = 0,
		lazarusSpeed = 0,
		lazarusTears = 0,
		lazarusRange = 0,
		lazarusLuck = 0,
		luckyAllStats = 0,
		luckyAllStatsActive = false,
		momPlanC = 0,
		lazarusClearHearts = 0,
		---- Eden's Tree ----
		chaoticTreasury = false,
		chaoticTreasuryProc = false,
		sporadicGrowth = false,
		starblessed = false,
		treasureShopItemStat = 0,
		treasureShopItemStatPerc = 0,
		devilAngelBossItemStat = 0,
		devilAngelBossItemStatPerc = 0,
		itemRandLuck = 0,
		itemRandLuckPerc = 0,
		trinketRandLuck = 0,
		startCoinKeyBomb = 0,
		edenBlessingSpawn = 0,
		edenBlessingSpawned = false,
		---- The Lost's Tree ----
		spectralAdvantage = false,
		spectralAdvantageHearts = 0,
		sacredAegis = false,
		heartseekerPhantasm = false,
		heartseekerPhantasmCollected = 0,
		killingHitNegation = 0,
		noHolyMantleAllStats = 0,
		noHolyMantleAllStatsActive = false,
		soulHeartTears = 0,
		soulHeartTearsTotal = 0,
		blackHeartDamage = 0,
		blackHeartDamageTotal = 0,
		eternalD6Charge = 0,
		soulHeartOnClear = 0,
		---- Lilith's Tree ----
		minionManeuvering = false,
		totalFamiliars = 0,
		heavyFriends = false,
		daemonArmy = false,
		familiarKillSoulHeart = 0,
		activeFamiliarsLuck = 0,
		activeIncubusDamage = 0,
		activeIncubusTears = 0,
		boxOfFriendsCharge = 0,
		boxOfFriendsAllStats = 0,
		boxOfFriendsAllStatsProc = false,
		---- Keeper's Tree ----
		keeperBlessing = false,
		keeperBlessingHeals = 0,
		gulp = false,
		gulpActive = false,
		avidShopper = false,
		coinShield = 0,
		itemPurchaseLuck = 0,
		purchaseKeepCoins = 0,
		firstBossGreed = 0,
		firstBossGreedProc = false,
		greedLowerHealth = 0,
		greedNickelDrop = 0,
		greedDimeDrop = 0,
		blueFlyDeathDamage = 0,
		blueFlyDeathDamageTotal = 0,
		---- Apollyon's Tree ----
		apollyonBlessing = false,
		null = false,
		nullActiveAbsorbed = false,
		nullAppliedBonus = 0,
		nullDebuff = false,
		harbingerLocusts = false,
		harbingerLocustsFloorProc = false,
		harbingerLocustsReplace = 2,
		voidBlueFlies = 0,
		voidBlueSpiders = 0,
		voidAnnihilation = 0,
		eraserSecondFloor = 0,
		eraserSecondFloorProc = false,
		locustHeldLuck = 0,
		locustConsumedLuck = 0,
		conquestLocustSpeed = 0,
		deathLocustTears = 0,
		famineLocustRangeShotspeed = 0,
		pestilenceLocustLuck = 0,
		warLocustDamage = 0,
		---- The Forgotten's Tree ----
		soulful = false,
		spiritEbb = false,
		innerFlare = false,
		innerFlareProc = false,
		forgottenMeleeTearBuff = 0,
		forgottenSoulDamage = 0,
		forgottenSoulTears = 0,
		theSoulBoneDamage = 0,
		theSoulBoneTears = 0,
		innerFlareSlowDuration = 2,
		---- Bethany's Tree ----
		willOTheWisp = false,
		willOTheWispDmgBuff = 0,
		soulTrickle = false,
		soulTrickleWispDrops = 0,
		fatePendulum = false,
		fatePendulumDebuffActive = false,
		activeItemWisp = 0,
		chargeOnClear = 0,
		soulChargeOnClear = 0,
		wispDestroyedLuck = 0,
		wispDestroyedLuckTotal = 0,
		wispFloorBuff = 0,
		wispFloorBuffTotal = 0,
		redHeartsSoulCharge = 0,
		---- Jacob & Esau's Tree ----
		heartLink = false,
		statuePilgrimage = false,
		coordination = false,
		brotherHitNegation = 0,
		jacobHeartLuck = 0,
		jacobBirthright = 0,
		jacobBirthrightProc = false,
		jacobHeartOnKill = 0,
		jacobHeartOnKillProc = false,
		esauSoulOnKill = 0,
		esauSoulOnKillProc = false,
		jacobItemAllstats = 0,
		---- Siren's Tree ----
		darkSongstress = false,
		darkSongstressActive = false,
		songOfDarkness = false,
		songOfDarknessChance = 2,
		songOfFortune = false,
		songOfCelerity = false,
		songOfCelerityBuff = 0,
		songOfAwe = false,
		songOfAweActive = false,
		luckOnCharmedKill = 0,
		mightOfFortune = 0,
		charmedRetaliation = 0,
		charmedHitNegation = 0,
		charmedHitNegationProc = false,
		charmExplosions = 0,

		---- STAR TREE ----
		azureStarSockets = 0,
		crimsonStarSockets = 0,
		viridianStarSockets = 0,
		ancientStarSockets = 0,
		azureStarmight = 0,
		crimsonStarmight = 0,
		viridianStarmight = 0,
		ancientStarmight = 0,

		---- Starcursed jewel helpers ----
		starmight = 0,
		enableSCJewels = false,
		SC_jewelDropOnClear = 0,
		SC_SMMightyChance = 0,
		SC_SMAncientChance = 0,
		SC_firstFloorXPHalvedProc = false,
		SC_circadianStatsDown = 0,
		SC_umbraStatsDown = 0,
		SC_umbraNightLightSpawn = false,
		SC_cursedStarpieceDebuff = false,
		SC_opalescentProc = false,
		SC_iridescentItems = {},
		SC_levelHasChall = false,
		SC_challDebuff = false,
		SC_challClear = false,
		SC_luminescentUsedCard = false,
		SC_luminescentDebuff = 0,
		SC_baubleSeekerBuff = 0
	}
	-- Holds temporary data for allocated special nodes
	PST.specialNodes = {
		quickWit = { startTime = 0, pauseTime = 0 },
		TJacobEsauSpawned = false,
		impromptuGamblerItems = {}, -- Hold natural items in treasure room
		fickleFortuneVanish = false,
		deadBirdActive = false,
		bossHits = 0,
		bossRoomHitsFrom = 0,
		momDeathProc = false,
		momHeartDeathProc = false,
		sacredAegis = { hitTime = 0, proc = false, hitsTaken = 0 },
		minionManeuveringMaxBonus = 15,
		bossGreedSpawned = false,
		spiritEbbHits = { soul = 0, forgotten = 0 },
		forgottenMeleeTearBuff = 0,
		heartLinkProc = false,
		esauIsStatue = false,
		jacobNearEsauBuff = false,
		coordinationHits = { jacob = 0, esau = 0 },
		jacobHeartLuckVal = 0,
		oneShotProtectedMobs = {},
		mobFirstHitsBlocked = {},
		mobPeriodicShield = false,
		mobHitReduceDmg = 0,
		mobHitRoomExtraDmg = { hits = 0, proc = false },

		SC_circadianSpawnTime = 0,
		SC_circadianSpawnProc = false,
		SC_circadianExplImmune = 0,
		SC_soulEaterMobs = {}
	}
    PST.modData.firstHeartUpdate = false
	PST.floorFirstUpdate = false
	PST.gameInit = false
end
function PST:resetData()
	PST.modData = {
		xpObtained = 0,
		skillPoints = 0,
		respecPoints = 4,
		spawnKills = 0,
		treeDisabled = false,

        -- Used for first update on heart-related functions
        firstHeartUpdate = false,
        -- Holds relevant vars, which start at true, are set to false when a new run begins, and become true again once you defeat Mom's Heart
        momHeartProc = {},
		-- List of trees with nodes and whether they're allocated
		treeNodes = {},
		-- List of applied modifiers from each tree
		treeMods = {},
		-- List of applied modifiers that stays fixed during a run
		treeModSnapshot = {},
		-- Completion tracker for Cosmic Realignment unlocks
		cosmicRCompletions = { [0] = {} },
		charData = {},

		-- Star Tree
		starTreeInventory = {
			Crimson = {},
			Azure = {},
			Viridian = {},
			Ancient = {}
		},
		-- Ancient starcursed jewels identified so far
		identifiedAncients = {},
		-- Collected ancient jewel rewards (e.g. skill points when killing X boss)
		ancientRewards = {},

		-- For initializing new unsupported characters, so they can gain XP
		newChars = {},
		newCharsTainted = {}
	}
	PST:resetMods()
end

-- External Item Descriptions init
if EID then
	-- Starcursed jewel trinkets
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Azure Starcursed Jewel"),
		"Rolls mods that affect monsters' might in a run.#Gets added unidentified to your Star Tree inventory once picked up."
	)
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Crimson Starcursed Jewel"),
		"Rolls mods that affect monsters' defense in a run.#Gets added unidentified to your Star Tree inventory once picked up."
	)
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Viridian Starcursed Jewel"),
		"Rolls mods that can affect a run directly.#Gets added unidentified to your Star Tree inventory once picked up."
	)
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Ancient Starcursed Jewel"),
		"Can feature unique challenge-like run modifiers.#Gets added unidentified to your Star Tree inventory once picked up."
	)
end