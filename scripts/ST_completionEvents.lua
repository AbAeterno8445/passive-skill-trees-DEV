-- Attempt to unlock an achievement associated with the currently selected Cosmic Realignment character
function PST:cosmicRTryUnlock(unlockSource)
	local player = PST:getPlayer()
	local cosmicRChar = PST:getTreeSnapshotMod("cosmicRealignment", false)
	if type(cosmicRChar) == "number" and player:GetPlayerType() ~= cosmicRChar then
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
					--[[for _, charData in pairs(PST.modData.charData) do
						charData.skillPoints = charData.skillPoints + tmpRewards[1]
					end]]
					PST.modData.respecPoints = PST.modData.respecPoints + tmpRewards[2]
					PST.modData.ancientRewards[ancientJewel.name][rewardMod] = true

					SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
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
		local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
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