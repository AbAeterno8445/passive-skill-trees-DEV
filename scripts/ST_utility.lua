local sfx = SFXManager()

function PST:getPlayer()
	local player = PST.player
	if not player then
		PST.player = Isaac.GetPlayer()
		player = PST.player
	elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
		player = Isaac.GetPlayer()
	end
	return player
end

function PST:getLevel()
	local level = PST.level
	if not level then
		PST.level = Game():GetLevel()
		level = PST.level
	end
	return level
end

function PST:getRoom()
	local room = PST.room
	if not room then
		PST.room = Game():GetRoom()
		room = PST.room
	end
	return room
end

-- Get current char name (different to EntityPlayer's GetName() func as it uses a custom name table)
function PST:getCurrentCharName()
	if not PST.charNames then return nil end
	local player = PST:getPlayer()
	return PST.charNames[1 + player:GetPlayerType()]
end

-- Attempt to init a non-vanilla character so they can earn XP
function PST:initUnknownChar(charName, tainted)
	local tmpName = charName
	if tainted then
		tmpName = "T. " .. charName
	end
	if PST.charNames[1 + Isaac.GetPlayerTypeByName(charName, tainted)] == nil then
		PST.charNames[1 + Isaac.GetPlayerTypeByName(charName, tainted)] = tmpName
		if not tainted then
			table.insert(PST.modData.newChars, charName)
		else
			table.insert(PST.modData.newCharsTainted, tmpName)
		end
		PST:charInit(tmpName)
		PST:save()
	end
end

-- Updates stat caches a frame after this is called. If no cache flags are provided, update all stat caches
function PST:updateCacheDelayed(flags)
	if not flags then
		PST.delayedCacheFlags = PST.allstatsCache
	else
		PST.delayedCacheFlags = PST.delayedCacheFlags | flags
	end
	if PST.delayedCacheUpdate == 0 then
		PST.delayedCacheUpdate = Game():GetFrameCount()
	end
end

-- Get the required XP for the given level
function PST:getLevelXPReq(level)
	if level <= 1 then return PST.startXPRequired end

	local xpRequired = PST.startXPRequired
	local expFactor = 1.08
	local lvlFactor = 0.6
	if level >= 30 then
		expFactor = 1.09
		lvlFactor = 0.7
	end
	if level >= 60 then
		expFactor = 1.11
		lvlFactor = 0.8
	end
	if level >= 90 then
		expFactor = 1.135
		lvlFactor = 0.9
	end
	if level >= 100 then
		expFactor = 1.15
		lvlFactor = 0.95
	end
	if level >= 120 then
		expFactor = 1.16
		lvlFactor = 1
	end
	if level >= 200 then
		expFactor = 1.3
		lvlFactor = 1.2
	end
	xpRequired = math.ceil(PST.startXPRequired * (level ^ expFactor) * lvlFactor)
	return xpRequired
end

-- Get the required XP for the given level (global tree)
function PST:getGlobalLevelXPReq(level)
	if level <= 1 then return PST.startXPRequired end

	local xpRequired = PST.startXPRequired + (level - 1) * 10 + ((level - 1) / 5) ^ 1.6
	return math.ceil(xpRequired)
end

-- Updates all characters' xp requirement values to current formula
function PST:updateAllCharsXPReq()
	for _, charData in pairs(PST.modData.charData) do
		charData.xpRequired = PST:getLevelXPReq(charData.level)
		if charData.xp >= charData.xpRequired then
			charData.xp = charData.xpRequired - 1
		end
	end
	-- Update global level
	local projectedLevel = PST.modData.skillPoints
	for nodeID, _ in pairs(PST.modData.treeNodes["global"]) do
		if PST:isNodeAllocated("global", nodeID) then projectedLevel = projectedLevel + 1 end
	end
	for nodeID, _ in pairs(PST.modData.treeNodes["starTree"]) do
		if PST:isNodeAllocated("starTree", nodeID) then projectedLevel = projectedLevel + 1 end
	end
	if PST.modData.level < projectedLevel then
		PST.modData.level = projectedLevel
	end
	PST.modData.xpRequired = PST:getGlobalLevelXPReq(PST.modData.level)
	if PST.modData.xp >= PST.modData.xpRequired then
		PST.modData.xp = PST.modData.xpRequired - 1
	end
end

-- Add temporary XP (gets converted to normal xp once room is cleared)
---@param xp number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
---@param noMult? boolean If true, apply no multipliers to xp
function PST:addTempXP(xp, showText, noMult)
	if PST:getCurrentCharData() == nil then return end

	local room = PST:getRoom()
	local roomType = room:GetType()
    local xpMult = (PST.config.xpMult or 1) + PST:getTreeSnapshotMod("xpgain", 0) / 100

	-- -40% xp gain outside hard mode
	if not Game():IsHardMode() then
		xpMult = xpMult - 0.4
	else
		-- Hard mode floor xp bonus, +2.5% per floor past first (except boss rush)
		if roomType ~= RoomType.ROOM_BOSSRUSH then
			local stage = PST:getLevel():GetStage()
			xpMult = xpMult + math.max(0, (stage - 1) * 0.025)
		end
	end

	-- Extra challenge room XP gain mod
	if roomType == RoomType.ROOM_CHALLENGE then
		xpMult = xpMult + PST:getTreeSnapshotMod("challengeXPgain", 0) / 100
	-- -40% xp gain in boss rush
	elseif roomType == RoomType.ROOM_BOSSRUSH then
		xpMult = xpMult - 0.4
	end

	if noMult then
		xpMult = 1
	end

	-- Victory lap XP penalty
	local victoryLap = Game():GetVictoryLap()
	if victoryLap > 0 then
		xpMult = xpMult * math.max(0.05, 0.5 - 0.1 * victoryLap)
	end

	local xpGain = xp * math.max(0.01, xpMult)
	PST.modData.xpObtained = PST.modData.xpObtained + xpGain
	if showText then
        local xpStr = string.format("+%.2f xp", xpGain)
        if xpGain % 1 == 0 then
            xpStr = string.format("+%d xp", xpGain)
        end
		PST:createFloatTextFX(xpStr, Vector.Zero, Color(0.58, 0, 0.83, 0.7), 0.14, 60, true)
	end
end

-- Add XP
---@param xpParam number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
function PST:addXP(xpParam, showText)
	local charData = PST:getCurrentCharData()
	if charData then
		local xp = xpParam
		charData.xp = math.max(0, charData.xp + xp)
		PST.modData.xp = math.max(0, PST.modData.xp + xp)
		if showText then
			local xpStr = string.format("+%.2f xp", xp)
			if xp % 1 == 0 then
				xpStr = string.format("+%d xp", xp)
			end
			PST:createFloatTextFX(xpStr, Vector.Zero, Color(0.58, 0, 0.83, 0.7), 0.14, 60, true)
		end

		-- Character level up
		if charData.xp >= charData.xpRequired then
			local currentChar = PST:getCurrentCharName()
			if currentChar then
				sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
				charData.level = charData.level + 1
				charData.skillPoints = PST.modData.charData[currentChar].skillPoints + 1

				local xpRemaining = charData.xp - charData.xpRequired

				-- Next level xp requirement formula
				charData.xpRequired = PST:getLevelXPReq(charData.level)

				-- Add overflowing xp to next level, capped at 33%
				charData.xp = math.min(math.floor(charData.xpRequired * 0.33), xpRemaining)

				PST:createFloatTextFX("Level up!", Vector.Zero, Color(0.7, 0.85, 1, 0.7), 0.17, 100, true)
			end
		end

		-- Global level up
		if PST.modData.xp >= PST.modData.xpRequired then
			sfx:Play(SoundEffect.SOUND_1UP, 0.9)
			PST.modData.level = PST.modData.level + 1
			PST.modData.skillPoints = PST.modData.skillPoints + 1

			local xpRemaining = PST.modData.xp - PST.modData.xpRequired

			-- Next level xp requirement formula
			PST.modData.xpRequired = PST:getGlobalLevelXPReq(PST.modData.level)

			-- Add overflowing xp to next level, capped at 33%
			PST.modData.xp = math.min(math.floor(PST.modData.xpRequired * 0.33), xpRemaining)

			PST:createFloatTextFX("Global level up!", Vector.Zero, Color(0.1, 0.4, 1, 0.7), 0.17, 100, true)
		end
	end
end

-- Get tree modifier (pre-run tree)
---@return any
function PST:getTreeMod(modName, default)
	if PST.treeMods[modName] == nil then
		return default
	end
	return PST.treeMods[modName]
end

-- Get current snapshot tree modifier
---@return any
function PST:getTreeSnapshotMod(modName, default)
    if PST.modData.treeModSnapshot[modName] == nil then
        return default
    end
    return PST.modData.treeModSnapshot[modName]
end

-- Return whether the given PlayerType character has been picked in the Cosmic Realignment node.
-- Also returns false if the player is currently playing as the given character.
---@param character PlayerType
function PST:cosmicRCharPicked(character)
	local player = PST:getPlayer()
	if player:GetPlayerType() == character then
		return false
	end
	return PST:getTreeSnapshotMod("cosmicRealignment", false) == character
end

function PST:cosmicRIsCharUnlocked(char)
	if not PST.cosmicRData.characters[char].unlockReq or PST.debugOptions.cosmicRUnlocked then
		return true
	end
	return Isaac.GetPersistentGameData():Unlocked(PST.cosmicRData.characters[char].unlockReq)
end

---@param npc EntityNPC
---@param target Entity
function PST:onNPCPickTarget(npc, target)
	if not target then return end

	local player = target:ToPlayer()
	if player then
		-- Statue Pilgrimage node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("statuePilgrimage", false) then
			-- If Esau is transformed by Gnawed Leaf, make enemy target Jacob instead
			if player:GetPlayerType() == PlayerType.PLAYER_ESAU and PST.specialNodes.esauIsStatue then
				local mainPlayer = PST:getPlayer()
				if mainPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then
					return mainPlayer
				end
			end
		end
	end

	-- Dark Esau targeting
	if npc.Type == EntityType.ENTITY_DARK_ESAU then
		-- Spiritual Covenant node (T. Jacob's tree)
		if PST:getTreeSnapshotMod("spiritualCovenant", false) and PST.specialNodes.spiritCovenantTarget ~= nil and
		PST.specialNodes.spiritCovenantTarget:Exists() then
			return PST.specialNodes.spiritCovenantTarget
		end
	end
end

--- Get the amount of familiars in the room
---@param specificType? FamiliarVariant Check for a specific familiar type instead, and return the amount of those
function PST:getRoomFamiliars(specificType)
	local totalFamiliars = 0
	for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
		if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and (specificType == nil or tmpEntity.Variant == specificType) then
			totalFamiliars = totalFamiliars + 1
		end
	end
	return totalFamiliars
end

function PST:removeRoomItems(protected)
	for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
		if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE and
		not PST:arrHasValue(PST.progressionItems, tmpEntity.SubType) then
			if not protected or (protected and not PST:arrHasValue(PST.specialNodes.itemRemovalProtected, tmpEntity.InitSeed)) then
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, 0)
				tmpEntity:Remove()
			end
		end
	end
end

---@param sourceItem Entity
---@param targetQual number
function PST:rerollQualItem(sourceItem, targetQual)
	local itmPool = Game():GetItemPool():GetPoolForRoom(PST:getRoom():GetType(), Random() + 1)

	local newItem = Game():GetItemPool():GetCollectible(itmPool, true)
	local newItemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
	local failsafe = 0
	while ((newItemCfg and newItemCfg.Quality ~= targetQual) or not newItemCfg) and failsafe < 200 do
		newItem = Game():GetItemPool():GetCollectible(itmPool, true)
		newItemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
		failsafe = failsafe + 1
	end
	if newItem > 0 and failsafe < 200 then
		Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, sourceItem.Position, Vector.Zero, nil, 0, Random() + 1)
		sourceItem:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true)
		return true
	end
	return false
end

local statsList = {"damage", "luck", "speed", "tears", "shotSpeed", "range"}
function PST:getRandomStat(exclude)
	if exclude and type(exclude) == "table" then
		local tmpStat = ""
		local picked = false
		while not picked do
			tmpStat = statsList[math.random(#statsList)]
			picked = true
			for _, excludeStat in ipairs(exclude) do
				if tmpStat == excludeStat then
					picked = false
				end
			end
		end
		return tmpStat
	end
	return statsList[math.random(#statsList)]
end

function PST:onPlanetariumChance(chance)
	if not PST.gameInit then return chance end

	-- Mod: % increased chance for the planetarium to appear
	return chance + PST:getTreeSnapshotMod("planetariumChance", 0) / 100
end

function PST:finalPlanetariumChance(chance)
	-- Ancient starcursed jewel: Astral Insignia
	if PST:SC_getSnapshotMod("astralInsignia", false) and not PST:isFirstOrigStage() then
		local currentLevel = PST:getTreeSnapshotMod("SC_astralInsigniaLevel", 0)
		if ((currentLevel) % 2) == 0 then
			return 1
		end
	end
end

function PST:isFirstOrigStage()
	local level = PST:getLevel()
	return level:GetStage() == LevelStage.STAGE1_1 and (level:GetStageType() == StageType.STAGETYPE_ORIGINAL or
	level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH or level:GetStageType() == StageType.STAGETYPE_WOTL)
end

function PST:arrHasValue(arr, value)
	for _, item in ipairs(arr) do
		if item == value then
			return true
		end
	end
	return false
end

-- For Siren tree, checks how many "Song of..." nodes you currently have allocated
function PST:songNodesAllocated(checkSnapshot)
	local tmpCount = 0
	if not checkSnapshot then
		for nodeID, node in pairs(PST.trees["Siren"]) do
			if PST:strStartsWith(node.name, "Song of") and PST:isNodeAllocated("Siren", nodeID) then
				tmpCount = tmpCount + 1
			end
		end
	else
		if PST:getTreeSnapshotMod("songOfDarkness", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("songOfFortune", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("songOfCelerity", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("songOfAwe", false) then tmpCount = tmpCount + 1 end
	end
	return tmpCount
end

-- For T. Cain tree, checks how many "Grand Ingredient" nodes you currently have allocated
function PST:grandIngredientNodes(checkSnapshot)
	local tmpCount = 0
	if not checkSnapshot then
		for nodeID, node in pairs(PST.trees["T. Cain"]) do
			if PST:strStartsWith(node.name, "Grand Ingredient") and PST:isNodeAllocated("T. Cain", nodeID) then
				tmpCount = tmpCount + 1
			end
		end
	else
		if PST:getTreeSnapshotMod("grandIngredientCoins", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("grandIngredientKeys", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("grandIngredientBombs", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("grandIngredientHearts", false) then tmpCount = tmpCount + 1 end
	end
	return tmpCount
end

function PST:getTIsaacInvItems()
	local player = PST:getPlayer()
	local collectibleCount = player:GetCollectibleCount()
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		collectibleCount = collectibleCount - 1
	end
	if player:GetActiveItem(0) ~= 0 then collectibleCount = collectibleCount - 1 end
	if player:GetActiveItem(1) ~= 0 then collectibleCount = collectibleCount - 1 end
	return collectibleCount
end

function PST:isTIsaacInvFull()
	local player = PST:getPlayer()
	local tmpMax = 8
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		tmpMax = 12
	end
	return PST:getTIsaacInvItems() >= tmpMax
end

-- Return a random pickup as {PickupVariant, SubType}
function PST:getTCainRandPickup()
	local randPickup = math.random(4)
	if randPickup == 1 then
		return {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY}
	elseif randPickup == 2 then
		return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
	elseif randPickup == 3 then
		return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
	else
		if math.random() < 0.3 then
			return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL}
		else
			return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF}
		end
	end
end

function PST:isBerserk()
	return PST:getPlayer():GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
end

function PST:getTLazOtherForm()
	return PST:getPlayer():GetFlippedForm() or PST:getPlayer():GetOtherTwin()
end

function PST:getBerserkMaxCharge()
	local berserkCharge = 150
	-- Mod: +- seconds to berserk duration
	local tmpMod = PST:getTreeSnapshotMod("berserkDuration", 0)
	if tmpMod ~= 0 then
		berserkCharge = berserkCharge + math.floor(tmpMod * 30)
	end
	return berserkCharge
end

function PST:TLostHasAnyShield()
	local playerEff = PST:getPlayer():GetEffects()
	return playerEff:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) or playerEff:HasTrinketEffect(TrinketType.TRINKET_WOODEN_CROSS) or
	playerEff:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
end

function PST:removePlayerShields()
	local playerEff = PST:getPlayer():GetEffects()
	playerEff:RemoveNullEffect(NullItemID.ID_HOLY_CARD, -1)
	playerEff:RemoveTrinketEffect(TrinketType.TRINKET_WOODEN_CROSS, -1)
	playerEff:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, -1)
	playerEff:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, -1)
end

function PST:getSirenMelodySlot()
	local player = PST:getPlayer()
	for _, tmpMelody in ipairs(PST.sirenMelodies) do
		local tmpItem = Isaac.GetItemIdByName(tmpMelody)
		if tmpItem ~= -1 then
			local tmpSlot = player:GetActiveItemSlot(tmpItem)
			if tmpSlot ~= -1 then return tmpSlot end
		end
	end
	return -1
end

function PST:isSoulOfTheSirenUnlocked()
	return PST:getTreeSnapshotMod("soulOfTheSiren", false) and Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.BOSS_RUSH) > 0 and
	Isaac.GetCompletionMark(Isaac.GetPlayerTypeByName("Siren", true), CompletionType.HUSH) > 0
end

---@param itemPool ItemPoolType
---@param item CollectibleType
function PST:poolHasCollectible(itemPool, item)
	for _, tmpItem in ipairs(Game():GetItemPool():GetCollectiblesFromPool(itemPool)) do
		if tmpItem.itemID == item then
			return true
		end
	end
	return false
end

local purityPathColors = {
	[PurityState.RED] = "red",
	[PurityState.BLUE] = "blue",
	[PurityState.YELLOW] = "yellow",
	[PurityState.ORANGE] = "orange"
}
---@param newState PurityState
function PST:switchPurityState(newState)
	local player = PST:getPlayer()

	---@diagnostic disable-next-line: undefined-field
	player:SetPurityState(newState)
	player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PURITY)
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_PURITY)
	for _, tmpCostume in ipairs(player:GetCostumeSpriteDescs()) do
		local itemCfg = tmpCostume:GetItemConfig()
		if itemCfg and itemCfg:IsNull() and itemCfg.ID == NullItemID.ID_PURITY_GLOW then
			tmpCostume:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/PurityGlow_" .. purityPathColors[newState] .. ".png", true)
			foundCostume = true
		end
	end
	PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
end

function PST:inRedRoom()
	return (PST:getLevel():GetCurrentRoomDesc().Flags & (1 << 10)) > 0
end

---- Function by TheCatWizard, taken from Modding of Isaac Discord ----
-- Returns the actual amount of black hearts the player has
---@param player EntityPlayer
function PST:GetBlackHeartCount(player)
    local black_count = 0
    local soul_hearts = player:GetSoulHearts()
    local black_mask = player:GetBlackHearts()

    for i = 1, soul_hearts do
        local bit = 2 ^ math.floor((i - 1) / 2)
        if black_mask | bit == black_mask then
            black_count = black_count + 1
        end
    end

    return black_count
end

function PST:debugMod(modName)
	print(PST:getTreeSnapshotMod(modName, "N/A"))
end

-- Returns a matching soul stone type for the given player type. If not found or nil, returns a random soul stone.
---@param playerType PlayerType|nil
---@return Card
function PST:getMatchingSoulstone(playerType)
	if PST.playerSoulstones[playerType] then return PST.playerSoulstones[playerType] end

	local newSoulstone = PST.playerSoulstones[math.random(#PST.playerSoulstones)]
	local failsafe = 0
	while newSoulstone == nil and failsafe < 200 do
		newSoulstone = PST.playerSoulstones[math.random(#PST.playerSoulstones)]
		failsafe = failsafe + 1
	end
	if newSoulstone then
		return newSoulstone
	else
		return PST.playerSoulstones[0]
	end
end

local weightedRunes = {
	[Card.RUNE_ANSUZ] = 100,
	[Card.RUNE_BERKANO] = 100,
	[Card.RUNE_HAGALAZ] = 100,
	[Card.RUNE_BLANK] = 75,
	[Card.RUNE_ALGIZ] = 75,
	[Card.RUNE_EHWAZ] = 75,
	[Card.RUNE_PERTHRO] = 75,
	[Card.RUNE_DAGAZ] = 50,
	[Card.RUNE_JERA] = 30,
}
local weightedRunesTotal = 0
for _, tmpWeight in pairs(weightedRunes) do
	weightedRunesTotal = weightedRunesTotal + tmpWeight
end
function PST:getRandRuneWeighted()
	local weightRoll = math.random(weightedRunesTotal)
	for tmpRune, tmpWeight in pairs(weightedRunes) do
		weightRoll = weightRoll - tmpWeight
		if weightRoll <= 0 then
			return tmpRune
		end
	end
end

function PST:NPCChampionAvailable(npc)
	local tmpBlacklist = PST.noChampionMobs
	if npc:IsBoss() then
		tmpBlacklist = PST.noChampionBosses
	end
	for _, mobData in ipairs(tmpBlacklist) do
		if type(mobData) == "table" then
			if npc.Type == mobData[1] and npc.SubType == mobData[2] then
				return false
			end
		elseif npc.Type == mobData then
			return false
		end
	end
	return true
end

function PST:preSFXPlay(sfxID, volume, frameDelay, loop, pitch, pan)
	-- Ancient starcursed jewel: Cause Converter - mute Siren screech!!
	if PST.specialNodes.SC_causeConvBossEnt and PST.specialNodes.SC_causeConvBossEnt.Type == EntityType.ENTITY_SIREN then
		if sfxID == SoundEffect.SOUND_SIREN_SCREAM or sfxID == SoundEffect.SOUND_SIREN_LUNGE then
			return false
		end
	end

	-- Anima chains broken, update chained enemies
	if sfxID == SoundEffect.SOUND_ANIMA_BREAK then
		PST.specialNodes.checkAnimaChain = true
	end

	if sfxID == SoundEffect.SOUND_PENNYPICKUP then
		if PST:getPlayer():GetPlayerType() == Isaac.GetPlayerTypeByName("Siren", true) then
			-- Chromatic Blessing node (T. Siren's tree) - detect notes
			if PST:getTreeSnapshotMod("chromaticBlessing", false) then
				if pitch >= 2.3999 and pitch <= 2.4001 then
					-- UP
					table.insert(PST.specialNodes.chromBlessingBuffer, "u")
					PST.specialNodes.sirenUsedMelody = PST.specialNodes.sirenUsedMelody + 1
				elseif pitch >= 1.5999 and pitch <= 1.6001 then
					-- DOWN
					table.insert(PST.specialNodes.chromBlessingBuffer, "d")
					PST.specialNodes.sirenUsedMelody = PST.specialNodes.sirenUsedMelody + 1
				elseif pitch >= 1.9999 and pitch <= 2.0001 then
					-- LEFT
					table.insert(PST.specialNodes.chromBlessingBuffer, "l")
					PST.specialNodes.sirenUsedMelody = PST.specialNodes.sirenUsedMelody + 1
				elseif pitch >= 1.7999 and pitch <= 1.8001 then
					-- RIGHT
					table.insert(PST.specialNodes.chromBlessingBuffer, "r")
					PST.specialNodes.sirenUsedMelody = PST.specialNodes.sirenUsedMelody + 1
				end
				if #PST.specialNodes.chromBlessingBuffer > 3 then
					table.remove(PST.specialNodes.chromBlessingBuffer, 1)
				end
			end

			-- T. Siren singing option
			if PST.config.tSirenSing then
				if pitch >= 2.3999 and pitch <= 2.4001 then
					SFXManager():Play(Isaac.GetSoundIdByName("siren note"), volume, frameDelay, loop, 1.48, pan)
					return false
				elseif pitch >= 1.5999 and pitch <= 1.6001 then
					SFXManager():Play(Isaac.GetSoundIdByName("siren note"), volume, frameDelay, loop, 1, pan)
					return false
				elseif pitch >= 1.9999 and pitch <= 2.0001 then
					SFXManager():Play(Isaac.GetSoundIdByName("siren note"), volume, frameDelay, loop, 1.24, pan)
					return false
				elseif pitch >= 1.7999 and pitch <= 1.8001 then
					SFXManager():Play(Isaac.GetSoundIdByName("siren note"), volume, frameDelay, loop, 1.12, pan)
					return false
				end
			end
		end
	end

	if sfxID == SoundEffect.SOUND_THUMBSUP then
		-- Chromatic Blessing node (T. Siren's tree), apply buff when successfully summoning familiar with Manifest Melody
		if PST:getTreeSnapshotMod("chromaticBlessing", false) and PST.specialNodes.sirenUsedMelody == 3 then
			local buffNotes = {
				l = {"speedPerc"},
				r = {"tearsPerc"},
				u = {"damagePerc"},
				d = {"rangePerc", "luckPerc"}
			}
			local buffList = PST:getTreeSnapshotMod("chromBlessingBuffs", nil)
			if buffList then
				for _, tmpNote in ipairs(PST.specialNodes.chromBlessingBuffer) do
					if buffNotes[tmpNote] then
						for _, tmpStat in ipairs(buffNotes[tmpNote]) do
							if not buffList[tmpStat] then
								buffList[tmpStat] = 0
							end
							local tmpTotal = buffList[tmpStat]
							if tmpTotal < 15 then
								PST:addModifiers({ [tmpStat] = 0.5 }, true)
								buffList[tmpStat] = buffList[tmpStat] + 0.5
							end
						end
					end
				end
			end
			PST.specialNodes.sirenUsedMelody = -1
		end
	elseif sfxID == SoundEffect.SOUND_THUMBS_DOWN then
		-- Chromatic Blessing node (T. Siren's tree), reset on failure
		if PST:getTreeSnapshotMod("chromaticBlessing", false) and PST.specialNodes.sirenUsedMelody == 3 then
			PST.specialNodes.sirenUsedMelody = -1
		end
	end
end

---@param weapon Weapon
---@param fireDir Vector
---@param isShooting boolean
---@param isInterpolated boolean
function PST:postWeaponFire(weapon, fireDir, isShooting, isInterpolated)
	if isShooting then
		-- Hemoptysis fired
		if weapon:GetWeaponType() == WeaponType.WEAPON_BRIMSTONE and (weapon:GetModifiers() & WeaponModifier.AZAZELS_SNEEZE) > 0 then
			PST.specialNodes.hemoptysisFired = 5
		-- Gello fired
		elseif weapon:GetWeaponType() == WeaponType.WEAPON_UMBILICAL_WHIP then
			PST.specialNodes.gelloFired = 20

			-- Coordinated Demons node (T. Lilith's tree)
			if PST:getTreeSnapshotMod("coordinatedDemons", false) then
				if PST.specialNodes.coordinatedDemonsDelay == 0 then
					PST.specialNodes.coordinatedDemonsDelay = math.ceil(PST:getPlayer().MaxFireDelay * 3)
				end
			end

			-- Mod: +% speed for 1 second after using the whip attack (T. Lilith)
			local tmpMod = PST:getTreeSnapshotMod("whipSpeed", 0)
			if tmpMod > 0 then
				if PST.specialNodes.whipSpeedTimer == 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
				end
				PST.specialNodes.whipSpeedTimer = 30
			end
		end
	end
end

function PST:inMineshaftPuzzle()
	local level = PST:getLevel()
	return level:GetDimension() == Dimension.MINESHAFT and (level:GetStage() == LevelStage.STAGE2_1 or level:GetStage() == LevelStage.STAGE2_2)
end

---@param r number
---@param g number
---@param b number
---@param a? number
function PST:RGBColor(r, g, b, a)
	return Color(r / 255, g / 255, b / 255, a or 1)
end

-- Brian Kernighan's algorithm
function PST:countSetBits(n)
	if (n == 0) then return 0
	else return 1 + PST:countSetBits(n & (n - 1)) end
end

function PST:strStartsWith(txt, start)
	return string.sub(txt, 1, string.len(start)) == start
end

function PST:roundFloat(number, digit)
	local precision = 10 ^ digit
	number = number + (precision / 2)
	return math.floor(number / precision) * precision
end

-- Returns the distance between two given Vector positions
---@param p1 Vector
---@param p2 Vector
function PST:distBetweenPoints(p1, p2)
	return math.sqrt((p1.X - p2.X)^2 + (p1.Y - p2.Y)^2)
end