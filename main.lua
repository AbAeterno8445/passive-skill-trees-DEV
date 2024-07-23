PST = RegisterMod("PST", 1)

local json = require("json")

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

PST.debugOptions = {
	infSP = true, -- No longer spend or require skill points for nodes
	infRespec = true, -- No longer spend or require respec points for nodes
	allAvailable = true, -- Makes all nodes available
}

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
		}
	}
	-- Holds temporary data for allocated special nodes
	PST.specialNodes = {
		quickWit = { startTime = 0, pauseTime = 0 },
		TJacobEsauSpawned = false
	}
end
function PST:resetData()
	PST.modData = {
		xpObtained = 0,
		skillPoints = 2,
		respecPoints = 4,
		spawnKills = 0,
		treeDisabled = false,

		-- Stores IDs of slots in the current room. Used to check if coins are given to slot entities
		roomSlotIDs = {},

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
PST:resetData()

-- Initialize character data for the given char
---@param charName string Character name
---@param forceReset? boolean Forces resetting the character's data
function PST:charInit(charName, forceReset)
	if PST.modData.charData[charName] == nil or forceReset == true then
		PST.modData.charData[charName] = {
			level = 1,
			xp = 0,
			xpRequired = PST.startXPRequired,
			skillPoints = 0
		}
	end
end

-- Save mod data
function PST:save()
	PST:SaveData(json.encode(PST.modData))
end

-- Load mod data
function PST:load()
	local loadedData = PST:LoadData()
	local loadSuccess = false

	PST:resetData()
	PST:resetNodes()
	if #loadedData ~= 0 then
		local tmpJson = json.decode(loadedData)

		-- Add missing fields (old save)
		for k, v in pairs(PST.modData) do
			if tmpJson[k] == nil then
				tmpJson[k] = v
			end
		end
		for k, v in pairs(PST.modData.treeMods) do
			if tmpJson.treeMods[k] == nil then
				tmpJson.treeMods[k] = v
			end
			if tmpJson.treeModSnapshot[k] == nil then
				tmpJson.treeModSnapshot[k] = v
			end
		end
		for k, v in pairs(PST.modData.treeNodes) do
			if tmpJson.treeNodes[k] == nil then
				tmpJson.treeNodes[k] = v
			else
				-- Convert node IDs to numbers. With [0] we make sure they get saved as strings again later (stops the table from being ordered numbers)
				local tmpTreeNodes = { [0] = false }
				for nodeID, nodeVal in pairs(tmpJson.treeNodes[k]) do
					tmpTreeNodes[tonumber(nodeID)] = nodeVal
				end
				tmpJson.treeNodes[k] = tmpTreeNodes
			end
		end
		PST.modData = tmpJson

		loadSuccess = true
	end
	PST:updateNodes()

	return loadSuccess
end

-- On player init
function PST:playerInit()
	local loadSuccess = PST:load()
	PST:charInit(PST:getCurrentCharName(), not loadSuccess)
end

-- Fetch the current character's skill tree data (makes sure it's initialized)
function PST:getCurrentCharData()
	local currentChar = PST:getCurrentCharName()
	PST:charInit(currentChar)
	return PST.modData.charData[currentChar]
end

include("scripts.ST_utility")
include("scripts.ST_cosmicRData")
include("scripts.ST_treeScreen")
include("scripts.ST_onNewRoom")
include("scripts.ST_onDamage")
include("scripts.ST_onUpdate")
include("scripts.ST_rendering")
include("scripts.ST_onCache")
include("scripts.ST_onNewRun")
include("scripts.ST_onCharSelect")
include("scripts.ST_slots")
include("scripts.ST_pickups")
include("scripts.ST_devilChance")
include("scripts.ST_onRunOver")
include("scripts.ST_onNewLevel")
include("scripts.ST_collectibles")
include("scripts.ST_entities")

PST:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PST.playerInit)
PST:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, PST.save)
PST:AddCallback(ModCallbacks.MC_POST_GAME_END, PST.save)
PST:AddCallback(ModCallbacks.MC_POST_RENDER, PST.Render)
PST:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, PST.onDamage)
PST:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PST.onNewRoom)
PST:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PST.onCache)
PST:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PST.onEntitySpawn)
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PST.onPickupInit)
PST:AddCallback(ModCallbacks.MC_POST_UPDATE, PST.onUpdate)
PST:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PST.onCurseEval)
PST:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, PST.onRollCollectible)
PST:AddCallback(ModCallbacks.MC_USE_ITEM, PST.onUseItem)
PST:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PST.onNewRun)
PST:AddCallback(ModCallbacks.MC_POST_GAME_END, PST.onRunOver)
PST:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, PST.onDeath)
-- Repentogon callbacks
PST:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, PST.load)
PST:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARKS_RENDER, PST.onCharSelect)
PST:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, PST.onNewLevel)
PST:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, PST.onSlotUpdate)
PST:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, PST.prePickup)
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PST.onPickup)
PST:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_SPECIAL_ITEMS, PST.applyDevilChance)
PST:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PST.onGrabCollectible)
PST:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, PST.onPlayerCollision)
PST:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, PST.onCompletionEvent)

-- First load
PST:load()

print("Initialized Passive Skill Trees.")
for optName, _ in pairs(PST.debugOptions) do
	Console.PrintWarning("Passive Skill Trees: " .. optName .. " debug option is enabled")
end