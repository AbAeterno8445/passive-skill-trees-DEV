-- Mod data initialization
PST.modData = {}
PST.selectedMenuChar = 0
PST.startXPRequired = 25
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
-- Init mod char names here (index is the character's playerType + 1)
PST.charNames[42] = "Siren"
PST.charNames[43] = "T. Siren"

-- Blood machine on floor start spawn proc
PST.spawnBloodMachine = false

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
		respecChance = 15, -- Chance to gain respec on floor clear
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
			blueBabyPickups = 0,
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
        ---- Isaac's tree ----
        isaacBlessing = 0, -- Mom Heart Proc
        magicDie = false,
        magicDieData = {
            source = "none", -- Can be: "none" (not procced yet), "any" (unspecified room), "angel", "devil", "boss", "treasure" (for both treasure room and shop)
            value = 0
        },
        intermittentConceptions = false,
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
        healOnClear = 0
	}
	-- Holds temporary data for allocated special nodes
	PST.specialNodes = {
		quickWit = { startTime = 0, pauseTime = 0 },
		TJacobEsauSpawned = false
	}
    PST.modData.firstHeartUpdate = false
	PST.spawnBloodMachine = false
end
function PST:resetData()
	PST.modData = {
		xpObtained = 0,
		skillPoints = 2,
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
		charData = {}
	}
	PST:resetMods()
end