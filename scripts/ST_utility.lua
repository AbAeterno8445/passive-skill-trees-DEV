local sfx = SFXManager()

-- Get current char name (different to EntityPlayer's GetName() func as it uses a custom name table)
function PST:getCurrentCharName()
	return PST.charNames[1 + Isaac.GetPlayer():GetPlayerType()]
end

-- Add temporary XP (gets converted to normal xp once room is cleared)
---@param xp number Amount of XP to add
---@param showText? boolean Whether to display the +xp floating text
function PST:addTempXP(xp, showText)
    local xpMult = 1 + PST:getTreeSnapshotMod("xpgain", 0) / 100

	-- Extra challenge room XP gain mod
	local room = Game():GetRoom()
	if room:GetType() == RoomType.ROOM_CHALLENGE then
		xpMult = xpMult + PST:getTreeSnapshotMod("challengeXPgain", 0) / 100
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

	local xpGain = xp * xpMult
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