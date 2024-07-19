SkillTrees = RegisterMod("SkillTrees", 1)

local json = require("json")

SkillTrees.modData = {}
SkillTrees.selectedMenuChar = 0
SkillTrees.startXPRequired = 25
SkillTrees.charNames = {
	"Isaac", "Magdalene", "Cain", "Judas", "???", "Eve",
	"Samson", "Azazel", "Lazarus", "Eden", "The Lost", "Lazarus",
	"Judas", "Lilith", "Keeper", "Apollyon", "The Forgotten", "The Soul",
	"Bethany", "Jacob & Esau", "Jacob & Esau",
	"T. Isaac", "T. Magdalene", "T. Cain", "T. Judas", "T. ???", "T. Eve",
	"T. Samson", "T. Azazel", "T. Lazarus", "T. Eden", "T. Lost", "T. Lilith",
	"T. Keeper", "T. Apollyon", "T. Forgotten", "T. Bethany", "T. Jacob", "T. Lazarus",
	"T. Jacob", "T. Soul"
}
-- Init mod char names here (index is the character's playerType + 1)
SkillTrees.charNames[42] = "Siren"
SkillTrees.charNames[43] = "T. Siren"

SkillTrees.debugOptions = {
	infSP = true, -- No longer spend or require skill points for nodes
	infRespec = true, -- No longer spend or require respec points for nodes
	allAvailable = true, -- Makes all nodes available
}

function SkillTrees:resetMods()
	-- List of available tree modifiers
	SkillTrees.modData.treeMods = {
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

		causeCurse = false, -- If true, causes a curse when entering the next floor then flips back to false. Skipped by items like black candle

		-- 'Keystone' nodes
		relearning = false,
		relearningFloors = 0,
		quickWit = {0, 0},
		expertSpelunker = 0,
		hellFavour = false,
		heavenFavour = false,
		cosmicRealignment = false, -- TODO
	}
	-- Holds temporary data for allocated special nodes
	SkillTrees.specialNodes = {
		quickWit = { startTime = 0, pauseTime = 0 }
	}
end
function SkillTrees:resetData()
	SkillTrees.modData = {
		xpObtained = 0,
		skillPoints = 2,
		respecPoints = 4,
		spawnKills = 0,

		-- Stores IDs of slots in the current room. Used to check if coins are given to slot entities
		roomSlotIDs = {},

		-- List of nodes and whether they're allocated
		treeNodes = {},
		-- List of applied modifiers from tree
		treeMods = {},
		-- List of applied modifiers that stays fixed during a run
		treeModSnapshot = nil,
		charData = {}
	}
	SkillTrees:resetMods()
end
SkillTrees:resetData()

-- Initialize character data for the given char
---@param charName string Character name
---@param forceReset? boolean Forces resetting the character's data
function SkillTrees:charInit(charName, forceReset)
	if SkillTrees.modData.charData[charName] == nil or forceReset == true then
		SkillTrees.modData.charData[charName] = {
			level = 1,
			xp = 0,
			xpRequired = SkillTrees.startXPRequired,
			skillPoints = 0
		}
	end
end

-- Save mod data
function SkillTrees:save()
	SkillTrees:SaveData(json.encode(SkillTrees.modData))
end

-- Load mod data
function SkillTrees:load()
	local loadedData = SkillTrees:LoadData()
	local loadSuccess = false

	SkillTrees:resetData()
	SkillTrees:resetNodes()
	if #loadedData ~= 0 then
		local tmpJson = json.decode(loadedData)

		-- Add missing fields (old save)
		for k, v in pairs(SkillTrees.modData) do
			if tmpJson[k] == nil then
				tmpJson[k] = v
			end
		end
		for k, v in pairs(SkillTrees.modData.treeMods) do
			if tmpJson.treeMods[k] == nil then
				tmpJson.treeMods[k] = v
			end
		end
		for k, v in pairs(SkillTrees.modData.treeNodes) do
			if tmpJson.treeNodes[k] == nil then
				tmpJson.treeNodes[k] = v
			end
		end
		SkillTrees.modData = tmpJson

		loadSuccess = true
	end
	SkillTrees:updateNodes()

	return loadSuccess
end

-- On player init
function SkillTrees:playerInit()
	local loadSuccess = SkillTrees:load()
	SkillTrees:charInit(SkillTrees:getCurrentCharName(), not loadSuccess)
end

-- Fetch the current character's skill tree data (makes sure it's initialized)
function SkillTrees:getCurrentCharData()
	local currentChar = SkillTrees:getCurrentCharName()
	SkillTrees:charInit(currentChar)
	return SkillTrees.modData.charData[currentChar]
end

include("scripts.ST_utility")
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

SkillTrees:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, SkillTrees.playerInit)
SkillTrees:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SkillTrees.save)
SkillTrees:AddCallback(ModCallbacks.MC_POST_GAME_END, SkillTrees.save)
SkillTrees:AddCallback(ModCallbacks.MC_POST_RENDER, SkillTrees.Render)
SkillTrees:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SkillTrees.onDamage)
SkillTrees:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SkillTrees.onNewRoom)
SkillTrees:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SkillTrees.onCache)
SkillTrees:AddCallback(ModCallbacks.MC_POST_UPDATE, SkillTrees.onUpdate)
SkillTrees:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, SkillTrees.onCurseEval)
SkillTrees:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, SkillTrees.onNewRun)
SkillTrees:AddCallback(ModCallbacks.MC_POST_GAME_END, SkillTrees.onRunOver)
-- Repentogon callbacks
SkillTrees:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, SkillTrees.load)
SkillTrees:AddCallback(ModCallbacks.MC_PRE_COMPLETION_MARKS_RENDER, SkillTrees.onCharSelect)
SkillTrees:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, SkillTrees.onNewLevel)
SkillTrees:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, SkillTrees.onSlotUpdate)
SkillTrees:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, SkillTrees.onPickup)
SkillTrees:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_SPECIAL_ITEMS, SkillTrees.applyDevilChance)

-- First load
SkillTrees:load()

print("Initialized Skill Trees.")
for optName, _ in pairs(SkillTrees.debugOptions) do
	Console.PrintWarning("Skill Trees: " .. optName .. " debug option is enabled")
end