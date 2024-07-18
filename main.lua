SkillTrees = RegisterMod("SkillTrees", 1)

local json = require("json")

local startXPRequired = 60
SkillTrees.modData = {}
SkillTrees.selectedMenuChar = 0
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

function SkillTrees:resetMods()
	-- List of available tree modifiers
	SkillTrees.modData.treeMods = {
		allstats = 0,
		damage = 0,
		luck = 0, -- TODO
		speed = 0, -- TODO
		tears = 0, -- TODO
		shotSpeed = 0, -- TODO
		range = 0, -- TODO
		xpgain = 0,
		respecChance = 15, -- Chance to gain respec on floor clear
		secretXP = 0, -- TODO
		challengeXP = 0, -- TODO
		challengeXPgain = 0, -- TODO
		xpgainNormalMob = 0, -- TODO
		xpgainBoss = 0, -- TODO
		beggarLuck = 0, -- TODO
		devilChance = 0, -- TODO
		coinDupe = 0, -- TODO
		keyDupe = 0, -- TODO
		bombDupe = 0, -- TODO
		grabBag = 0, -- TODO
		mapChance = 0, -- TODO

		-- 'Keystone' nodes
		unholyGrowth = false, -- TODO
		relearning = false, -- TODO
		quickWit = {0, 0}, -- TODO
		expertSpelunker = 0, -- TODO
		hellFavour = false, -- TODO
		heavenFavour = false, -- TODO
		cosmicRealignment = false, -- TODO
	}
end
function SkillTrees:resetData()
	SkillTrees.modData = {
		xpObtained = 0,
		skillPoints = 2,
		respecPoints = 4,
		spawnKills = 0,

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
			xpRequired = startXPRequired,
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

SkillTrees:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, SkillTrees.playerInit)
SkillTrees:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SkillTrees.save)
SkillTrees:AddCallback(ModCallbacks.MC_POST_GAME_END, SkillTrees.save)
SkillTrees:AddCallback(ModCallbacks.MC_POST_RENDER, SkillTrees.Render)
SkillTrees:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SkillTrees.onDamage)
SkillTrees:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SkillTrees.onNewRoom)
SkillTrees:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SkillTrees.onCache)
SkillTrees:AddCallback(ModCallbacks.MC_POST_UPDATE, SkillTrees.onUpdate)
SkillTrees:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, SkillTrees.onNewRun)
-- MC_POST_GAME_END for run over

SkillTrees:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, SkillTrees.load)
SkillTrees:AddCallback(ModCallbacks.MC_PRE_COMPLETION_MARKS_RENDER, SkillTrees.onCharSelect)

-- First load
SkillTrees:load()

print("Initialized Skill Trees.")