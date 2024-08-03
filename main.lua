PST = RegisterMod("PST", 1)

local json = require("json")

include("scripts.ST_initData")
PST:resetData()

PST.debugOptions = {
	infSP = true, -- No longer spend or require skill points for nodes
	infRespec = true, -- No longer spend or require respec points for nodes
	allAvailable = true, -- Makes all nodes available
}

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

function PST:onExitGame()
	PST:save()
	PST.gameInit = false
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
include("scripts.ST_onAddHearts")
include("scripts.ST_shops")
include("scripts.ST_cardsPills")

PST:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PST.playerInit)
PST:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, PST.onExitGame)
PST:AddCallback(ModCallbacks.MC_POST_GAME_END, PST.onExitGame)
PST:AddCallback(ModCallbacks.MC_POST_RENDER, PST.Render)
PST:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, PST.onDamage)
PST:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PST.onNewRoom)
PST:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PST.onCache)
PST:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PST.onEntitySpawn)
PST:AddCallback(ModCallbacks.MC_POST_NPC_INIT, PST.postNPCInit)
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PST.onPickupInit)
PST:AddCallback(ModCallbacks.MC_POST_UPDATE, PST.onUpdate)
PST:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PST.onCurseEval)
PST:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, PST.onRollCollectible)
PST:AddCallback(ModCallbacks.MC_USE_ITEM, PST.onUseItem)
PST:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PST.onNewRun)
PST:AddCallback(ModCallbacks.MC_POST_GAME_END, PST.onRunOver)
PST:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, PST.onDeath)
PST:AddCallback(ModCallbacks.MC_GET_CARD, PST.onGetCard)
PST:AddCallback(ModCallbacks.MC_USE_CARD, PST.onUseCard)
PST:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, PST.onPillEffect)
PST:AddCallback(ModCallbacks.MC_USE_PILL, PST.onUsePill)
-- Repentogon callbacks
PST:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, PST.load)
PST:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARKS_RENDER, PST.onCharSelect)
PST:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, PST.onNewLevel)
PST:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, PST.preSlotCollision)
PST:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, PST.onSlotUpdate)
PST:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, PST.prePickup)
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PST.onPickup)
PST:AddCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_SPECIAL_ITEMS, PST.applyDevilChance)
PST:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, PST.onGrabCollectible)
PST:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, PST.onRemoveCollectible)
PST:AddCallback(ModCallbacks.MC_POST_PLAYER_COLLISION, PST.onPlayerCollision)
PST:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, PST.onCompletionEvent)
PST:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_HEARTS, PST.onAddHearts)
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, PST.onShopPurchase)
PST:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, PST.onTrinketAdd)
PST:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, PST.onTrinketRemove)

-- First load
PST:load()

print("Initialized Passive Skill Trees.")
for optName, _ in pairs(PST.debugOptions) do
	Console.PrintWarning("Passive Skill Trees: " .. optName .. " debug option is enabled")
end