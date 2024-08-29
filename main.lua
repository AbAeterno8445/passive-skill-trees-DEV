PST = RegisterMod("PST", 1)
local saveManager = include("scripts.libs.save_manager")
saveManager.Init(PST)

include("scripts.ST_initData")
include("PST_config")
PST:resetData()

local oldLoadFlag = false
saveManager.AddCallback(saveManager.Utility.CustomCallback.PRE_DATA_LOAD, function(modRef, saveData, isLuamod)
	if modRef == PST and saveData.lastVersion then
		-- Loading from old version of savefile, update to new system
		Isaac.DebugString("Detected old savefile layout for Passive Skill Trees, converting to SaveManager layout...")
		oldLoadFlag = true

		-- Remove treeMods if present
		if saveData.treeMods then saveData.treeMods = nil end
		-- Remove config if present
		local oldConfig
		if saveData.config then
			oldConfig = PST:copyTable(saveData.config)
			saveData.config = nil
		else
			oldConfig = PST:copyTable(PST.config)
		end

		return {
			file = {
				other = {
					modData = saveData
				},
				settings = {
					config = oldConfig
				}
			}
		}
	end
end)
saveManager.AddCallback(saveManager.Utility.CustomCallback.POST_DATA_LOAD, function(modRef, saveData, isLuamod)
	if modRef == PST and isLuamod ~= nil then
		PST:load()
	end
end)

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
function PST:save(forceSave)
	-- Limit saving to once every 250 ms
	if not forceSave and lastSave ~= 0 and os.clock() - lastSave < 0.25 then
		return
	end

	-- Save config
	local settingsSave = saveManager.GetSettingsSave()
	settingsSave.config = PST:copyTable(PST.config)

	local modSave = saveManager.GetPersistentSave()
	modSave.modData = PST:copyTable(PST.modData)

	saveManager.Save()
	lastSave = os.clock()
end

-- Load mod data
function PST:processLoadedData(loadedData)
	if not loadedData then return end

	-- Add missing fields (old save)
	for k, v in pairs(PST.modData) do
		if loadedData[k] == nil then
			loadedData[k] = v
		end
	end
	-- Remove old treeMods if present
	if loadedData.treeMods then
		loadedData.treeMods = nil
	end
	-- Remove old config if present
	if loadedData.config then
		loadedData.config = nil
	end
	for k, v in pairs(PST.modData.treeNodes) do
		if loadedData.treeNodes[k] == nil then
			loadedData.treeNodes[k] = v
		else
			-- Convert node IDs to numbers. With [0] we make sure they get saved as strings again later (stops the table from being ordered numbers)
			local tmpTreeNodes = { [0] = false }
			for nodeID, nodeVal in pairs(loadedData.treeNodes[k]) do
				tmpTreeNodes[tonumber(nodeID)] = nodeVal
			end
			loadedData.treeNodes[k] = tmpTreeNodes
		end
	end
	for k, v in pairs(PST.modData.starTreeInventory) do
		if loadedData.starTreeInventory[k] == nil then
			loadedData.starTreeInventory[k] = v
		end
	end
	-- New version
	PST.isNewVersion = false
	if not loadedData.lastVersion or loadedData.lastVersion ~= PST.modVersion then
		loadedData.lastVersion = PST.modVersion
		PST.isNewVersion = true
	end
	PST.modData = loadedData

	-- Load new character names
	for _, tmpNewName in ipairs(PST.modData.newChars) do
		local tmpID = Isaac.GetPlayerTypeByName(tmpNewName)
		if tmpID ~= -1 and PST.charNames[1 + tmpID] == nil then
			PST.charNames[1 + tmpID] = tmpNewName
		end
	end
	for _, tmpNewName in ipairs(PST.modData.newCharsTainted) do
		local tmpID = Isaac.GetPlayerTypeByName(tmpNewName, true)
		if tmpID ~= -1 and PST.charNames[1 + tmpID] == nil then
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
						if tree == "global" or tree == "starTree" then
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
end
function PST:load()
	local modDataSave = saveManager.GetPersistentSave()
	if modDataSave.modData then
		PST:processLoadedData(modDataSave.modData)
		PST:updateNodes()
	end

	local modConfigSave = saveManager.GetSettingsSave()
	if modConfigSave.config then
		PST.config = modConfigSave.config
	end

	if oldLoadFlag then
		oldLoadFlag = false
		PST:save()
	end
end

function PST:resetSaveData()
	PST:resetData()
	PST:resetNodes()
	PST:save()
end

function PST:onSaveSlot(slot)
	local existingData = PST:LoadData()
	if #existingData == 0 then
		print("Passive Skill Trees: initialized fresh savefile on slot", slot)
		PST:resetSaveData()
	end
end

-- On player init
function PST:playerInit()
	local charName = PST:getCurrentCharName()
	if charName then
		PST:charInit(charName)
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
PST:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, PST.onSaveSlot)
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