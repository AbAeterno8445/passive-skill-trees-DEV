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
	if Isaac.IsInGame() then
		local player = PST:getPlayer()
		return PST.charNames[1 + player:GetPlayerType()]
	elseif PST.selectedMenuChar then
		return PST.charNames[1 + PST.selectedMenuChar]
	end
	return nil
end

-- Attempt to init a non-vanilla character so they can earn XP
function PST:initUnknownChar(charName, tainted, customID)
	local tmpName = charName
	if tainted then
		tmpName = "T. " .. charName
	end
	local tmpCharID = customID or (1 + Isaac.GetPlayerTypeByName(charName, tainted))
	if PST.charNames[tmpCharID] == nil then
		PST.charNames[tmpCharID] = tmpName
		if not tainted and not PST:arrHasValue(PST.modData.newChars, tmpName) then
			table.insert(PST.modData.newChars, tmpName)
		elseif tainted and not PST:arrHasValue(PST.modData.newCharsTainted, tmpName) then
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

-- Returns whether the current difficulty counts as 'hard'
function PST:isHardMode()
	local hardMode = Game():IsHardMode()
	-- Community Remix Insane difficulty support
	if DifficultyManager and DifficultyManager.GetDifficulty() == "Insane" then
		hardMode = true
	end
	return hardMode
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

	-- Tie challenge xp gain to 'enable tree on challenges' option
	if not PST.config.treeOnChallenges and Isaac.GetChallenge() ~= 0 then
		return
	end

	local room = PST:getRoom()
	local roomType = room:GetType()
    local xpMult = (PST.config.xpMult or 1) + PST:getTreeSnapshotMod("xpgain", 0) / 100

	-- Uber expedition mods
	if PST:getTreeSnapshotMod("isExpedUber", false) then
		-- Mod: Uber expedition run xp gain
		xpMult = xpMult + PST:getTreeSnapshotMod("xpgainUber", 0) / 100

		-- Bring The Chaos node (Deep-Space tree)
		local expData = PST:getExpedData(PST:getTreeSnapshotMod("expedDepth", 0), true)
		if expData and expData.modifiers and expData.modifiers.bringTheChaos and expData.entropy and expData.entropy >= 100 then
			xpMult = xpMult + 0.25
		end
	end

	-- -40% xp gain outside hard mode
	if not PST:isHardMode() then
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
	-- Multiplicative -50% xp gain in boss rush
	elseif roomType == RoomType.ROOM_BOSSRUSH then
		xpMult = xpMult * 0.5
	end

	-- Mod: +% xp gain while you haven't taken damage in the current floor
	local tmpMod = PST:getTreeSnapshotMod("flawlessXP", 0)
	if tmpMod > 0 and PST:getTreeSnapshotMod("floorHitsReceived", 0) == 0 then
		xpMult = xpMult + tmpMod / 100
	end

	-- Penalty from multiple clears on the same room
	if not Game():IsGreedMode() then
		local clearsPerRoom = PST:getTreeSnapshotMod("clearsPerRoom", {})
		local roomIdxStr = tostring(PST:getLevel():GetCurrentRoomIndex())
		if clearsPerRoom[roomIdxStr] then
			xpMult = 1 - 0.15 * (clearsPerRoom[roomIdxStr] - 1)
		end
	end

	if noMult then xpMult = 1 end

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
---@param overflow? boolean Whether XP overflow limit is applied
---@param noExped? boolean Whether this instance of xp addition shouldn't count for relevant expedition objectives
function PST:addXP(xpParam, showText, overflow, noExped)
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

		-- Expedition objective: earn xp within run
		if noExped ~= true then
			PST:expedAddProgInRun("experience", math.ceil(xp))
		end

		-- Character level up
		if charData.xp >= charData.xpRequired then
			local currentChar = PST:getCurrentCharName()
			if currentChar then
				SFXManager():Play(SoundEffect.SOUND_POWERUP2)
				charData.level = charData.level + 1
				charData.skillPoints = PST.modData.charData[currentChar].skillPoints + 1

				-- Next level xp requirement formula
				charData.xpRequired = PST:getLevelXPReq(charData.level)

				-- Add overflowing xp to next level, capped at 33%
				if not overflow then
					local xpRemaining = charData.xp - charData.xpRequired
					charData.xp = math.min(math.floor(charData.xpRequired * 0.33), xpRemaining)
				else
					while charData.xp >= charData.xpRequired do
						charData.xp = charData.xp - charData.xpRequired
						charData.level = charData.level + 1
						charData.skillPoints = PST.modData.charData[currentChar].skillPoints + 1
						charData.xpRequired = PST:getLevelXPReq(charData.level)
					end
				end

				PST:createFloatTextFX(PST:getLocalized("ftxt_levelUp"), Vector.Zero, Color(0.7, 0.85, 1, 0.7), 0.17, 100, true)
			end
		end

		-- Global level up
		if PST.modData.xp >= PST.modData.xpRequired then
			SFXManager():Play(SoundEffect.SOUND_1UP, 0.9)
			PST.modData.level = PST.modData.level + 1
			PST.modData.skillPoints = PST.modData.skillPoints + 1

			local xpRemaining = PST.modData.xp - PST.modData.xpRequired

			-- Next level xp requirement formula
			PST.modData.xpRequired = PST:getGlobalLevelXPReq(PST.modData.level)

			-- Add overflowing xp to next level, capped at 33%
			PST.modData.xp = math.min(math.floor(PST.modData.xpRequired * 0.33), xpRemaining)

			PST:createFloatTextFX(PST:getLocalized("ftxt_globalLevelUp"), Vector.Zero, Color(0.1, 0.4, 1, 0.7), 0.17, 100, true)
		end
	end
end

-- Get tree modifier (pre-run tree)
---@return any
function PST:getTreeMod(modName, default)
	local modVal = PST.treeMods[modName]
	if modVal == nil then return default end
	return modVal
end

-- Get current snapshot tree modifier
---@return any
function PST:getTreeSnapshotMod(modName, default)
	local modVal = PST.modData.treeModSnapshot[modName]
    if modVal == nil then return default end
    return modVal
end

-- Get a list of total modifiers formed from the currently allocated nodes in the given tree (currently only for non-character trees)
function PST:getAllTreeMods(tree)
	local tmpMods = {}
	if PST.trees[tree] then
		for nodeID, node in pairs(PST.trees[tree]) do
			if PST:isNodeAllocated(tree, nodeID) then
				for modName, val in pairs(node.modifiers) do
					if tmpMods[modName] ~= nil and type(tmpMods[modName]) == "number" and type(val) == "number" then
						tmpMods[modName] = tmpMods[modName] + val
					else
						tmpMods[modName] = val
					end
				end
			end
		end
	end
	return tmpMods
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

-- Returns whether the given entity has any active status effects
---@param entity Entity
function PST:entityHasAnyStatus(entity)
	return entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION | EntityFlag.FLAG_POISON | EntityFlag.FLAG_BURN | EntityFlag.FLAG_FEAR |
	EntityFlag.FLAG_BAITED | EntityFlag.FLAG_ICE | EntityFlag.FLAG_FREEZE | EntityFlag.FLAG_SHRINK | EntityFlag.FLAG_CHARM |
	EntityFlag.FLAG_SLOW | EntityFlag.FLAG_BLEED_OUT) or entity:GetSpeedMultiplier() < 1
end

---@param entity Entity
function PST:entityIsFinalBoss(entity)
	local isFinalBoss = PST:arrHasValue(PST.finalBosses, entity.Type)
	-- ??? is Isaac with variant 1
	if isFinalBoss and entity.Type == EntityType.ENTITY_ISAAC and entity.Variant ~= 1 then
		isFinalBoss = false
	end
	-- Beast must be variant 0
	if isFinalBoss and entity.Type == EntityType.ENTITY_BEAST and entity.Variant ~= 0 then
		isFinalBoss = false
	end
	return isFinalBoss
end

---@param entity Entity
function PST:entityIsHPModBlacklisted(entity)
	local noHPMods = false
	for _, tmpMob in ipairs(PST.mobHPBlacklist) do
		if type(tmpMob) == "table" then
			if entity.Type == tmpMob[1] and entity.Variant == tmpMob[2] then
				noHPMods = true
			end
		elseif entity.Type == tmpMob then
			noHPMods = true
		end
		if noHPMods then break end
	end
	return noHPMods
end

--- Get the amount of familiars in the room
---@param specificVariant? FamiliarVariant Check for a specific familiar variant instead, and return the amount of those
function PST:getRoomFamiliars(specificVariant)
	return #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, specificVariant or -1)
end

function PST:removeRoomItems(protected)
	for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
		if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE and
		not PST:arrHasValue(PST.progressionItems, tmpEntity.SubType) then
			if not protected or (protected and not PST:arrHasValue(PST.specialNodes.itemRemovalProtected, tmpEntity.InitSeed)) then
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, Random() + 1)
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

---@param target Entity
function PST:inflictRandomStatus(srcPlayer, target, duration)
	local playerRef = EntityRef(srcPlayer)
	local randStatus = math.random(10)
	if randStatus == 1 then
		target:AddBurn(playerRef, duration, srcPlayer.Damage)
	elseif randStatus == 2 then
		target:AddFear(playerRef, duration)
	elseif randStatus == 3 then
		target:AddBaited(playerRef, duration)
	elseif randStatus == 4 then
		target:AddFreeze(playerRef, duration)
	elseif randStatus == 5 then
		target:AddShrink(playerRef, duration)
	elseif randStatus == 6 then
		target:AddCharmed(playerRef, duration)
	elseif randStatus == 7 then
		target:AddSlowing(playerRef, duration, 0.8, Color(0.8, 0.8, 0.8, 1))
		if math.random() < 0.3 then
			target:AddIce(playerRef, duration * 3)
		end
	elseif randStatus == 8 then
		target:AddBleeding(playerRef, duration)
	elseif randStatus == 9 then
		target:AddConfusion(playerRef, duration, false)
	elseif randStatus == 10 then
		target:AddPoison(playerRef, duration, srcPlayer.Damage)
	end
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
	local stageType = level:GetStageType()
	return level:GetStage() == LevelStage.STAGE1_1 and (stageType == StageType.STAGETYPE_ORIGINAL or
	stageType == StageType.STAGETYPE_AFTERBIRTH or stageType == StageType.STAGETYPE_WOTL) and not level:IsAscent()
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

-- For Forgotten tree, checks how many "Spiritful" nodes you currently have allocated
function PST:spiritfulNodesAllocated(checkSnapshot)
	local tmpCount = 0
	if not checkSnapshot then
		for nodeID, node in pairs(PST.trees["The Forgotten"]) do
			if PST:strStartsWith(node.name, "Spirit-") and PST:isNodeAllocated("The Forgotten", nodeID) then
				tmpCount = tmpCount + 1
			end
		end
	else
		if PST:getTreeSnapshotMod("spiritBringer", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("spiritTaker", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("spiritReaper", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("spiritProtector", false) then tmpCount = tmpCount + 1 end
		if PST:getTreeSnapshotMod("spiritGambler", false) then tmpCount = tmpCount + 1 end
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

-- Eden Chaotic Epiphany mechanic
---@param player EntityPlayer
function PST:edenChaoticEpiphany(player)
	local roll = math.random()
	-- 25%: add 2-4% to a random stat
	if roll < 0.25 then
		local randStat = PST:getRandomStat() .. "Perc"
		PST:addModifiers({ [randStat] = 1 + math.random(3) }, true)
	-- 25%: spawn a double coin/key/bomb
	elseif roll >= 0.25 and roll < 0.5 then
		local randPickups = {
			{PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK},
			{PickupVariant.PICKUP_KEY, KeySubType.KEY_DOUBLEPACK},
			{PickupVariant.PICKUP_BOMB, BombSubType.BOMB_DOUBLEPACK}
		}
		local tmpPos = Isaac.GetFreeNearPosition(player.Position, 20)
		local newPickupType = randPickups[math.random(#randPickups)]
		Isaac.Spawn(EntityType.ENTITY_PICKUP, newPickupType[1], newPickupType[2], tmpPos, Vector.Zero, nil)
	-- 20%: spawn a random heart
	elseif roll >= 0.5 and roll < 0.7 then
		local randHearts = {
			HeartSubType.HEART_HALF, HeartSubType.HEART_HALF_SOUL, HeartSubType.HEART_SOUL, HeartSubType.HEART_BLACK,
			HeartSubType.HEART_FULL, HeartSubType.HEART_DOUBLEPACK, HeartSubType.HEART_BONE, HeartSubType.HEART_ROTTEN,
			HeartSubType.HEART_BLENDED, HeartSubType.HEART_ETERNAL, HeartSubType.HEART_GOLDEN
		}
		local tmpPos = Isaac.GetFreeNearPosition(player.Position, 20)
		local newPickupType = randHearts[math.random(#randHearts)]
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, newPickupType, tmpPos, Vector.Zero, nil)
	-- 20%: spawn a regular chest
	elseif roll >= 0.7 and roll < 0.9 then
		local tmpPos = Isaac.GetFreeNearPosition(player.Position + 20 * RandomVector(), 20)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, tmpPos, Vector.Zero, nil)
	-- 10%: spawn a special chest
	else
		local tmpChestTypes = {table.unpack(PST.regularChests), table.unpack(PST.lockedChests)}
		for i, tmpChestType in ipairs(tmpChestTypes) do
			if tmpChestType == PickupVariant.PICKUP_CHEST then
				table.remove(tmpChestTypes, i)
				break
			end
		end
		if PST:isRunSidereal() then
			table.insert(tmpChestTypes, Isaac.GetEntityVariantByName("Sidereal Cache"))
		end
		local tmpPos = Isaac.GetFreeNearPosition(player.Position + 20 * RandomVector(), 20)
		local newChestType = tmpChestTypes[math.random(#tmpChestTypes)]
		Isaac.Spawn(EntityType.ENTITY_PICKUP, newChestType, 0, tmpPos, Vector.Zero, nil)
	end
end

function PST:isBerserk()
	-- Avoids rare crash?
	if PST:getRoom():GetFrameCount() > 1 then
		return PST:getPlayer():GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
	else
		return false
	end
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

-- Returns true if either the run is an expedition run or the Sidereal Universalization node is allocated
function PST:isRunSidereal()
	return PST:getTreeSnapshotMod("isExpedRun", false) or PST:getTreeSnapshotMod("siderealUniv", false)
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
		end
	end
	PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
end

function PST:addRandomWisp()
	local randItem = PST.wispActives[math.random(#PST.wispActives)]
	PST:getPlayer():AddWisp(randItem, PST:getPlayer().Position)
end

function PST:inRedRoom()
	return (PST:getLevel():GetCurrentRoomDesc().Flags & (1 << 10)) > 0
end

function PST:restoreDonoMachine()
	Game():SetStateFlag(GameStateFlag.STATE_DONATION_SLOT_JAMMED, false)

	local donoSlots = Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.DONATION_MACHINE)
	for _, tmpSlot in ipairs(donoSlots) do
		local newSlot = Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.DONATION_MACHINE, 0, tmpSlot.Position, Vector.Zero, nil)
		newSlot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		newSlot.TargetPosition = tmpSlot.TargetPosition
		tmpSlot:Remove()

		PST:createFloatTextFX(PST:getLocalized("ftxt_donoMachineRestore"), tmpSlot.Position, Color(0.6, 1, 0.6, 1), 0.13, 100, false)
		Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpSlot.Position, Vector.Zero, nil, 0, Random() + 1)
		SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
	end
	if PST:getTreeSnapshotMod("generosityInSteps", false) then
		PST:addModifiers({ generosityInStepsCount = { value = 0, set = true } }, true)
	end
end

---- Function by TheCatWizard, taken from Modding of Isaac Discord ----
-- Returns the actual amount of black hearts the player has
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

	-- Dark Heart node (Judas' tree)
	if PST:getTreeSnapshotMod("darkHeart", false) then
		black_count = black_count + soul_hearts
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

function PST:NPCChampionAvailable(npc, jewelList)
	local tmpBlacklist = PST.noChampionMobs
	if jewelList then
		tmpBlacklist = PST.noChampionMobsJewel
	end
	if npc:IsBoss() then
		return false
	end
	for _, mobData in ipairs(tmpBlacklist) do
		if type(mobData) == "table" then
			if npc.Type == mobData[1] and npc.Variant == mobData[2] then
				return false
			end
		elseif npc.Type == mobData then
			return false
		end
	end
	return true
end

function PST:isMobUndead(npc)
	local isUndead = PST:arrHasValue(PST.undeadEnemies, npc.Type)
	if not isUndead then
		local tmpVariant = PST.undeadEnemiesSpec[npc.Type]
		if tmpVariant then
			if (type(tmpVariant) == "table" and PST:arrHasValue(tmpVariant, npc.Variant)) or tmpVariant == npc.Variant then
				isUndead = true
			end
		end
	end
	return isUndead
end

function PST:roomHasSubmerged()
	for _, tmpType in ipairs(PST.submergedEnemies) do
		if #Isaac.FindByType(tmpType) > 0 then return true end
	end
	return false
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

	-- Ancient weapon mod: Tolling Bell
	local tmpMod = PST:getSnapAstralWepMod("tollingBell")
	if tmpMod then
		if PST:arrHasValue(PST.explosionSounds, sfxID) then
			PST.specialNodes.ancwep_tollBellSpeedTimer = 90
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
		if PST:arrHasValue(PST.rockBreakSounds, sfxID) then
			PST.specialNodes.ancwep_tollBellDamageTimer = 120
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
		if sfxID == SoundEffect.SOUND_DOOR_HEAVY_CLOSE then
			PST.specialNodes.ancwep_tollBellTearsTimer = 210
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
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
	local stage = level:GetStage()
	return level:GetDimension() == Dimension.MINESHAFT and (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2)
end

function PST:LJ_inMortis()
	if not StageAPI then return false end

	local currentStage = StageAPI:GetCurrentStage()
	if currentStage then
		return LastJudgement and currentStage.Name == "Mortis"
	end
	return false
end

---@param entity Entity
function PST:getEntData(entity, trueGetData)
    if not PST.entDataCache[entity.InitSeed] then
        local entData = {}
		if trueGetData then entData = entity:GetData() end
        PST.entDataCache[entity.InitSeed] = entData
        return entData
    end
    return PST.entDataCache[entity.InitSeed]
end

function PST:getTilesDist(tiles)
	return 40 + math.ceil(40 * tiles)
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

function PST:ParametricBlend(t)
    local sqr = t ^ 2
    return sqr / (2 * (sqr - t) + 1)
end

-- Returns the distance between two given Vector positions
---@param p1 Vector
---@param p2 Vector
function PST:distBetweenPoints(p1, p2)
	return math.sqrt((p1.X - p2.X)^2 + (p1.Y - p2.Y)^2)
end

---@param tbl table
---@param RNG? RNG
function PST:shuffleList(tbl, RNG)
	for i = #tbl, 2, -1 do
	  	local j = math.random(i)
		if RNG then j = RNG:RandomInt(1, i) end
	  	tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

-- Format a string utilizing curly braces to place variables
---@param str string String to parse, such as "I'm looking for the value {{targetValue}}"
---@param values table Table of values to format into the string, such as { targetValue = 123 }
function PST:formatString(str, values)
	local result = str:gsub("{{(%w+)}}", function(key)
        return values[key] or ""
    end)
	return result
end

-- Removes the first matching value in the given table
function PST:tableRemoveFirst(t, val)
	for i, tmpVal in ipairs(t) do
		if tmpVal == val then
			table.remove(t, i)
			break
		end
	end
end

function PST:alphaBlend(color1, color2, alpha)
    local r = color1.R * alpha + color2.R * (1 - alpha)
    local g = color1.G * alpha + color2.G * (1 - alpha)
    local b = color1.B * alpha + color2.B * (1 - alpha)
    return Color(r, g, b)
end

function PST:mixColors(col1, col2)
    local baseColor = Color()
    local mixedColor

    if col1 and col2 then
        local blend1 = PST:alphaBlend(col1, col2, 0.3) -- Blend the two enchantments
        mixedColor = PST:alphaBlend(baseColor, blend1, 0.3) -- Blend the base with the result
    elseif col1 then
        mixedColor = PST:alphaBlend(baseColor, col1, 0.3) -- Blend base with the first enchantment
    else
        mixedColor = baseColor -- No enchantments, return the base color
    end

    return mixedColor
end

function PST:forceLoadBackup(backupID)
	if type(backupID) ~= "integer" then return end
	-- Load given backup
	if PST_BackupReplace and PST_BackupReplace(PST.saveSlot, backupID) then
		SFXManager():Play(SoundEffect.SOUND_1UP)
		PST.saveManager.Load(false)
		PST:closeTreeMenu()
	else
		SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.7)
	end
end