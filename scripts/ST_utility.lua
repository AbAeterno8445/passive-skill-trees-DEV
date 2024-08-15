local sfx = SFXManager()

-- Get current char name (different to EntityPlayer's GetName() func as it uses a custom name table)
function PST:getCurrentCharName()
	if not PST.charNames then return nil end
	return PST.charNames[1 + Isaac.GetPlayer():GetPlayerType()]
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

-- Add temporary XP (gets converted to normal xp once room is cleared)
---@param xp number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
---@param noMult? boolean If true, apply no multipliers to xp
function PST:addTempXP(xp, showText, noMult)
	if PST:getCurrentCharData() == nil then return end

    local xpMult = 1 + PST:getTreeSnapshotMod("xpgain", 0) / 100

	if not Game():IsHardMode() then
		xpMult = xpMult - 0.25
	end

	-- Extra challenge room XP gain mod
	local room = Game():GetRoom()
	if room:GetType() == RoomType.ROOM_CHALLENGE then
		xpMult = xpMult + PST:getTreeSnapshotMod("challengeXPgain", 0) / 100
	-- -40% xp gain in boss rush
	elseif room:GetType() == RoomType.ROOM_BOSSRUSH then
		xpMult = xpMult - 0.4
	end

	-- Quick wit mod
	local quickWitMod = PST:getTreeSnapshotMod("quickWit", {0, 0})
	local quickWitTime = PST.specialNodes.quickWit.startTime
	if quickWitTime ~= 0 then
		local timeDiff = os.clock() - quickWitTime
		local quickWitMult = quickWitMod[1] / 100
		if timeDiff > 8 then
			local tmpProgress = math.abs(quickWitMod[2] - quickWitMod[1]) * ((timeDiff - 8) / 10)
			quickWitMult = (math.max(quickWitMod[2], quickWitMod[1] - tmpProgress)) / 100
		end
		xpMult = xpMult + quickWitMult
	end

	if noMult then
		xpMult = 1
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
---@param xp number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
function PST:addXP(xp, showText)
	local charData = PST:getCurrentCharData()
	if charData then
		charData.xp = math.max(0, charData.xp + xp)
		if showText then
			local xpStr = string.format("+%.2f xp", xp)
			if xp % 1 == 0 then
				xpStr = string.format("+%d xp", xp)
			end
			PST:createFloatTextFX(xpStr, Vector.Zero, Color(0.58, 0, 0.83, 0.7), 0.14, 60, true)
		end

		-- Level up
		if charData.xp >= charData.xpRequired then
			local currentChar = PST:getCurrentCharName()
			if currentChar then
				sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)
				charData.level = charData.level + 1
				charData.skillPoints = PST.modData.charData[currentChar].skillPoints + 1
				PST.modData.skillPoints = PST.modData.skillPoints + 1

				local xpRemaining = charData.xp - charData.xpRequired

				-- Next level xp requirement formula
				charData.xpRequired = math.ceil(PST.startXPRequired * (charData.level ^ 1.1))

				-- Add overflowing xp to next level, capped at 50%
				charData.xp = math.min(math.floor(charData.xpRequired * 0.5), xpRemaining)

				PST:createFloatTextFX("Level up!", Vector.Zero, Color(1, 1, 1, 0.7), 0.17, 100, true)
			end
		end
	end
end

-- Get tree modifier (pre-run tree)
---@return any
function PST:getTreeMod(modName, default)
	if PST.modData.treeMods[modName] == nil then
		return default
	end
	return PST.modData.treeMods[modName]
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
	local player = Isaac.GetPlayer()
	if player:GetPlayerType() == character then
		return false
	end
	return PST:getTreeSnapshotMod("cosmicRealignment", false) == character
end

function PST:cosmicRIsCharUnlocked(char)
	if not PST.cosmicRData.characters[char].unlockReq then
		return true
	end
	return Isaac.GetPersistentGameData():Unlocked(PST.cosmicRData.characters[char].unlockReq)
end

-- Attempt to unlock an achievement associated with the currently selected Cosmic Realignment character
function PST:cosmicRTryUnlock(unlockSource)
	local cosmicRChar = PST:getTreeSnapshotMod("cosmicRealignment", false)
	if type(cosmicRChar) == "number" and Isaac.GetPlayer():GetPlayerType() ~= cosmicRChar then
		local tmpData = PST.cosmicRData.characters
		if tmpData[cosmicRChar].unlocks ~= nil then
			if tmpData[cosmicRChar].unlocks[unlockSource] ~= nil then
				Isaac.GetPersistentGameData():TryUnlock(tmpData[cosmicRChar].unlocks[unlockSource])
			end
			if Game():IsHardMode() then
				local tmpSource = unlockSource .. "hard"
				if tmpData[cosmicRChar].unlocks[tmpSource] ~= nil then
					Isaac.GetPersistentGameData():TryUnlock(tmpData[cosmicRChar].unlocks[tmpSource])
				end
			end
		end
	end
end

local starcursedEvents = {
	[CompletionType.DELIRIUM] = "deliriumRewards",
	[CompletionType.BEAST] = "beastRewards"
}
function PST:onCompletionEvent(event)
	local pType = PST:getTreeSnapshotMod("cosmicRealignment", false)

	-- Mom's Heart procs
	if event == CompletionType.MOMS_HEART then
		for procName, _ in pairs(PST.modData.momHeartProc) do
			PST.modData.momHeartProc[procName] = true
		end

		-- Dark Protection node (Eve's tree)
		if PST:getTreeSnapshotMod("darkProtection", false) then
			PST:addModifiers({ darkProtectionProc = false }, true)
		end
	end

	-- Ancient starcursed jewel rewards
	for i=1,2 do
		local ancientJewel = PST:SC_getSocketedJewel(PSTStarcursedType.ANCIENT, tostring(i))
		if ancientJewel and ancientJewel.rewards then
			if not PST.modData.ancientRewards[ancientJewel.name] then
				PST.modData.ancientRewards[ancientJewel.name] = {}
			end

			-- Skill point and respec point reward mods
			for tmpEvent, rewardMod in pairs(starcursedEvents) do
				local tmpRewards = ancientJewel.rewards[rewardMod]
				if tmpRewards and event == tmpEvent and not PST.modData.ancientRewards[ancientJewel.name][rewardMod] then
					PST.modData.skillPoints = PST.modData.skillPoints + tmpRewards[1]
					for _, charData in pairs(PST.modData.charData) do
						charData.skillPoints = charData.skillPoints + tmpRewards[1]
					end
					PST.modData.respecPoints = PST.modData.respecPoints + tmpRewards[2]
					PST.modData.ancientRewards[ancientJewel.name][rewardMod] = true

					sfx:Play(SoundEffect.SOUND_THUMBSUP)
					PST:createFloatTextFX("Ancient jewel objective complete!", Vector.Zero, Color(1, 0.9, 0.5, 1), 0.13, 160, true)
				end
			end
		end
	end

	-- Cosmic Realignment unlocks
	if type(pType) == "number" then
		-- Store completion
		local tmpCompletions = PST.modData.cosmicRCompletions
		if tmpCompletions[tostring(pType)] == nil then
			tmpCompletions[tostring(pType)] = {}
		end
		local pComp = tmpCompletions[tostring(pType)]
		pComp[tostring(event)] = true
		if Game():IsHardMode() then
			pComp[event .. "hard"] = true
		end

		-- More specific Cosmic Realignment unlocks
		local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
		if pType == PlayerType.PLAYER_LAZARUS then
			-- Lazarus, kill Mom's Heart/It Lives! without dying in hard mode -> Bethany
			if event == CompletionType.MOMS_HEART and not cosmicRCache.lazarusHasDied and Game():IsHardMode() then
				Isaac.GetPersistentGameData():TryUnlock(Achievement.BETHANY)
			end
		end

		-- Isaac + Blue Baby + Satan + Lamb, for tainted characters
		if pComp[tostring(CompletionType.ISAAC)] and pComp[tostring(CompletionType.BLUE_BABY)] and
		pComp[tostring(CompletionType.SATAN)] and pComp[tostring(CompletionType.LAMB)] then
			PST:cosmicRTryUnlock("tainted1")
		end

		-- Hush + Boss Rush, for tainted characters
		if pComp[tostring(CompletionType.HUSH)] and pComp[tostring(CompletionType.BOSS_RUSH)] then
			PST:cosmicRTryUnlock("tainted2")
		end

		-- All hard completion mark unlocks
		if pComp[CompletionType.MOMS_HEART .. "hard"] and pComp[CompletionType.ISAAC .. "hard"] and
		pComp[CompletionType.BLUE_BABY .. "hard"] and pComp[CompletionType.SATAN .. "hard"] and
		pComp[CompletionType.LAMB .. "hard"] and pComp[CompletionType.MEGA_SATAN .. "hard"] and
		pComp[CompletionType.BOSS_RUSH .. "hard"] and pComp[CompletionType.HUSH .. "hard"] and
		pComp[CompletionType.ULTRA_GREED .. "hard"] and pComp[CompletionType.ULTRA_GREEDIER .. "hard"] and
		pComp[CompletionType.DELIRIUM .. "hard"] and pComp[CompletionType.MOTHER .. "hard"] and
		pComp[CompletionType.BEAST .. "hard"] then
			PST:cosmicRTryUnlock("allHardMarks")
		end

		PST:cosmicRTryUnlock(event)
	end
	PST:save()
end

function PST:onNPCPickTarget(NPC, target)
	if not target then return end

	local player = target:ToPlayer()
	if player then
		-- Statue Pilgrimage node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("statuePilgrimage", false) then
			-- If Esau is transformed by Gnawed Leaf, make enemy target Jacob instead
			if player:GetPlayerType() == PlayerType.PLAYER_ESAU and PST.specialNodes.esauIsStatue then
				local mainPlayer = Isaac.GetPlayer()
				if mainPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then
					return mainPlayer
				end
			end
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
	-- Mod: % increased chance for the planetarium to appear
	return chance + PST:getTreeSnapshotMod("planetariumChance", 0) / 100
end

function PST:isFirstOrigStage()
	local level = Game():GetLevel()
	return level:GetStage() == LevelStage.STAGE1_1 and (level:GetStageType() == StageType.STAGETYPE_ORIGINAL or
	level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH or level:GetStageType() == StageType.STAGETYPE_WOTL)
end

function PST:resetSaveData()
	PST:RemoveData()
	PST:load()
end

function PST:arrHasValue(arr, value)
	for _, item in ipairs(arr) do
		if item == value then
			return true
		end
	end
	return false
end

-- Render Cosmic Realignment completion marks on relevant characters (original marks take priority)
local markLayerOverrides = {
    [CompletionType.ULTRA_GREEDIER] = 8,
    [CompletionType.DELIRIUM] = 0,
    [CompletionType.MOTHER] = 10,
    [CompletionType.BEAST] = 11
}
function PST:cosmicRMarksRender(markSprite, markPos, markScale, playerType)
    local pTypeStr = tostring(playerType)
    local markPathNormal = "gfx/ui/completion_widget.png"
    local markPathCosmic = "gfx/ui/skilltrees/completion_widget_cosmic.png"
    if Game():IsPauseMenuOpen() then
        markPathNormal = "gfx/ui/completion_widget_pause.png"
        markPathCosmic = "gfx/ui/skilltrees/completion_widget_pause_cosmic.png"
    end

    for i=0,14 do
        local layerID = i + 1
        if markLayerOverrides[i] ~= nil then
            layerID = markLayerOverrides[i]
        end

        if PST.modData.cosmicRCompletions[pTypeStr] ~= nil then
            local hasMark = Isaac.GetCompletionMark(playerType, i)
            if PST.modData.cosmicRCompletions[pTypeStr][i .. "hard"] and hasMark < 2 then
                markSprite:ReplaceSpritesheet(layerID, markPathCosmic, true)
                markSprite:SetLayerFrame(layerID, 2)
            elseif PST.modData.cosmicRCompletions[pTypeStr][tostring(i)] and hasMark == 0 then
                markSprite:ReplaceSpritesheet(layerID, markPathCosmic, true)
                markSprite:SetLayerFrame(layerID, 1)
            else
                markSprite:ReplaceSpritesheet(layerID, markPathNormal, true)
            end
        else
            markSprite:ReplaceSpritesheet(layerID, markPathNormal, true)
        end
    end
end

-- For Siren tree, checks how many "Song of..." nodes you currently have allocated
function PST:songNodesAllocated(checkSnapshot)
	local tmpCount = 0
	if not checkSnapshot then
		for nodeID, node in pairs(PST.trees["Siren"]) do
			if PST:strStartsWith(node.name, "Song of") and PST.modData.treeNodes["Siren"][nodeID] then
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

function PST:strStartsWith(txt, start)
	return string.sub(txt, 1, string.len(start)) == start
end

function PST:roundFloat(number, digit)
	local precision = 10 ^ digit
	number = number + (precision / 2)
	return math.floor(number / precision) * precision
end