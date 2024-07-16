SkillTrees = RegisterMod("SkillTrees", 1)

local json = require("json")

local startXPRequired = 50
SkillTrees.modData = {}

function SkillTrees:resetMods()
	SkillTrees.modData.treeMods = {
		allstats = 0,
		xpgain = 0,
		respecChance = 15, -- Chance to gain respec on floor clear
		damage = 0
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

-- Initialize character data for current char
---@param forceReset? boolean Forces resetting the character's data
function SkillTrees:charInit(forceReset)
	local currentChar = Isaac.GetPlayer():GetName()
	if SkillTrees.modData.charData[currentChar] == nil or forceReset == true then
		SkillTrees.modData.charData[currentChar] = {
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
		SkillTrees.modData = tmpJson

		loadSuccess = true
	end
	SkillTrees:updateNodes()

	return loadSuccess
end

-- On player init
function SkillTrees:playerInit()
	local loadSuccess = SkillTrees:load()
	SkillTrees:charInit(not loadSuccess)
end

-- Fetch the current character's skill tree data (makes sure it's initialized)
function SkillTrees:getCurrentCharData()
	SkillTrees:charInit()
	local currentChar = Isaac.GetPlayer():GetName()
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

-- First load
SkillTrees:load()