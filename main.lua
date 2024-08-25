PST = RegisterMod("PST", 1)

local json = require("json")

include("scripts.ST_initData")
include("PST_config")
PST:resetData()

PST.debugOptions = {
	infSP = false, -- No longer spend or require skill points for nodes
	infRespec = false, -- No longer spend or require respec points for nodes
	allAvailable = false, -- Makes all nodes available
	cosmicRUnlocked = false, -- Removes character unlock requirement from the Cosmic Realignment node
	drawNodeIDs = false, -- Draw node IDs on the tree screen
}

local localDebugMode = false
function PST:toggleDebugMode()
	localDebugMode = not localDebugMode
	PST.debugOptions.infSP = localDebugMode
	PST.debugOptions.infRespec = localDebugMode
	PST.debugOptions.allAvailable = localDebugMode
	PST.debugOptions.cosmicRUnlocked = localDebugMode
	print("Passive Skill Trees: debug mode now", localDebugMode and "on" or "off")
end

-- Initialize character data for the given char
---@param charName string Character name
---@param forceReset? boolean Forces resetting the character's data
function PST:charInit(charName, forceReset)
	if not charName then return end

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
local lastSave = 0
function PST:save()
	-- Limit saving to once every 200 ms
	if lastSave ~= 0 and os.clock() - lastSave < 0.2 then
		return
	end

	-- Save config
	PST.modData.config = PST.config

	PST:SaveData(json.encode(PST.modData))
	lastSave = os.clock()
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
		for k, v in pairs(PST.modData.starTreeInventory) do
			if tmpJson.starTreeInventory[k] == nil then
				tmpJson.starTreeInventory[k] = v
			end
		end
		-- Load saved config
		if tmpJson.config then
			for tmpConfig, configVal in pairs(tmpJson.config) do
				-- Keybinds should remain as defined in file until they get support for changing
				if tmpConfig ~= "keybinds" then
					PST.config[tmpConfig] = configVal
				end
			end
		end
		-- New version
		if not tmpJson.lastVersion or tmpJson.lastVersion ~= PST.modVersion then
			tmpJson.lastVersion = PST.modVersion
			PST.isNewVersion = true
		end
		PST.modData = tmpJson

		-- Load new character names
		for _, tmpNewName in ipairs(PST.modData.newChars) do
			local tmpID = Isaac.GetPlayerTypeByName(tmpNewName)
			if PST.charNames[1 + tmpID] == nil then
				PST.charNames[1 + tmpID] = tmpNewName
			end
		end
		for _, tmpNewName in ipairs(PST.modData.newCharsTainted) do
			local tmpID = Isaac.GetPlayerTypeByName(tmpNewName, true)
			if PST.charNames[1 + tmpID] == nil then
				PST.charNames[1 + tmpID] = "T. " .. tmpNewName
			end
		end

		-- Refund allocated nodes that no longer exist
		for tree, nodes in pairs(PST.modData.treeNodes) do
			for nodeID, allocated in pairs(nodes) do
				if PST.trees[tree] ~= nil then
					if PST.trees[tree][nodeID] == nil and nodeID ~= 0 then
						if allocated then
							print("Passive Skill Trees: Found allocated non-existant node ID", nodeID, "for tree [", tree, "]. Refunding skill point.")
							if tree == "global" then
								PST.modData.skillPoints = PST.modData.skillPoints + 1
							elseif PST.modData.charData[tree] then
								PST.modData.charData[tree].skillPoints = PST.modData.charData[tree].skillPoints + 1
							end
						end
						PST.modData.treeNodes[tree][nodeID] = nil
					end
				end
			end
		end
		-- Post-load data update funcs
		PST:oldJewelReplacements()
		PST:updateStarTreeTotals()
		PST:updateAllCharsXPReq()

		loadSuccess = true
	end
	PST:updateNodes()

	return loadSuccess
end

-- On player init
function PST:playerInit()
	local loadSuccess = PST:load()
	local charName = PST:getCurrentCharName()
	if charName then
		PST:charInit(charName, not loadSuccess)
	end
end

-- Fetch the current character's skill tree data (makes sure it's initialized)
function PST:getCurrentCharData()
	local currentChar = PST:getCurrentCharName()
	if not currentChar then return nil end

	PST:charInit(currentChar)
	return PST.modData.charData[currentChar]
end

function PST:onExitGame()
	PST:save()
	PST.gameInit = false
	PST.player = nil
	PST.level = nil
	PST.room = nil
end

include("scripts.ST_utility")
include("scripts.ST_cosmicRData")
include("scripts.ST_treeScreen")
include("scripts.ST_onNewRoom")
include("scripts.ST_onDamage")
include("scripts.ST_onHeartUpdates")
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
include("scripts.ST_inputs")
include("scripts.ST_gridEntities")
include("scripts.ST_tears")
include("scripts.starcursed_data.ST_starcursed")

PST:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PST.playerInit)
PST:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, PST.onExitGame)
PST:AddCallback(ModCallbacks.MC_POST_RENDER, PST.Render)
PST:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, PST.onDamage)
PST:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PST.onNewRoom)
PST:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PST.onCache)
PST:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, PST.onEntitySpawn)
PST:AddCallback(ModCallbacks.MC_POST_NPC_INIT, PST.postNPCInit)
PST:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, PST.familiarInit)
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, PST.onPickupInit)
PST:AddCallback(ModCallbacks.MC_POST_UPDATE, PST.onUpdate)
PST:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, PST.onCurseEval)
PST:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, PST.onRollCollectible)
PST:AddCallback(ModCallbacks.MC_USE_ITEM, PST.onUseItem)
PST:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PST.onNewRun)
PST:AddCallback(ModCallbacks.MC_POST_GAME_END, PST.onRunOver)
PST:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, PST.onDeath)
PST:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, PST.onFireRender, EntityType.ENTITY_FIREPLACE)
PST:AddCallback(ModCallbacks.MC_GET_CARD, PST.onGetCard)
PST:AddCallback(ModCallbacks.MC_USE_CARD, PST.onUseCard)
PST:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, PST.onPillEffect)
PST:AddCallback(ModCallbacks.MC_USE_PILL, PST.onUsePill)
PST:AddCallback(ModCallbacks.MC_INPUT_ACTION, PST.onInput)
PST:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, PST.onTearDeath)
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
PST:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, PST.onShopPurchase)
PST:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, PST.onTrinketAdd)
PST:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, PST.onTrinketRemove)
PST:AddCallback(ModCallbacks.MC_NPC_PICK_TARGET, PST.onNPCPickTarget)
PST:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE, PST.gridEntityPoopUpdate)
PST:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_ROCK_UPDATE, PST.gridEntityRockUpdate)
PST:AddCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_TELESCOPE_LENS, PST.onPlanetariumChance)
PST:AddCallback(ModCallbacks.MC_PRE_COMPLETION_MARKS_RENDER, PST.cosmicRMarksRender)
PST:AddCallback(ModCallbacks.MC_GET_SHOP_ITEM_PRICE, PST.onShopItemPrice)
PST:AddCallback(ModCallbacks.MC_POST_RESTOCK_SHOP, PST.onShopRestock)
-- Additional hooks are found for tree menu functionality in ST_treeScreen.lua

-- First load
PST:load()

if Isaac.IsInGame() then
	PST:firstRenderInit()
	PST.gameInit = true
end

print("Initialized Passive Skill Trees", PST.modVersion)
for optName, enabled in pairs(PST.debugOptions) do
	if enabled then
		Console.PrintWarning("Passive Skill Trees: " .. optName .. " debug option is enabled")
	end
end