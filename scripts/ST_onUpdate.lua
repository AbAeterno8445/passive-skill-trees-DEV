local sfx = SFXManager()

-- On update
local clearRoomProc = false
function PST:onUpdate()
	-- On room clear
	local room = Game():GetRoom()
	if room:IsClear() and (not clearRoomProc or PST.modData.xpObtained > 0) then
		clearRoomProc = true

		local level = Game():GetLevel()
		-- Challenge rooms
		if room:GetType() == RoomType.ROOM_CHALLENGE then
			-- Challenge room XP reward
			local challengeXP = PST:getTreeSnapshotMod("challengeXP", 0);
			local bossChallengeXP = PST:getTreeSnapshotMod("bossChallengeXP", false);
			if (not level:HasBossChallenge() and challengeXP > 0) or
			(level:HasBossChallenge() and bossChallengeXP) then
				PST:addTempXP(challengeXP, true)
			end
		-- Boss rooms
		elseif room:GetType() == RoomType.ROOM_BOSS then
			-- Respec chance
			local relearningMod = PST:getTreeSnapshotMod("relearning", false)
			local respecChance = PST:getTreeSnapshotMod("respecChance", 15)

			if not relearningMod then
				local tmpRespecs = 0
				while (respecChance > 0) do
					if 100 * math.random() < respecChance then
						tmpRespecs = tmpRespecs + 1
					end
					respecChance = respecChance - 100
				end
				if tmpRespecs > 0 then
					PST:createFloatTextFX("+" .. tmpRespecs .. " Respec(s)", Vector(0, 0), Color(1, 1, 1, 1), 0.12, 90, true)
					sfx:Play(SoundEffect.SOUND_THUMBSUP)
					PST.modData.respecPoints = PST.modData.respecPoints + tmpRespecs
				end
			else
				-- Relearning node, count as completed floor
				PST:addModifiers({ relearningFloors = 1 }, true)
			end
		end

		-- Convert temp xp to normal xp
		if PST.modData.xpObtained > 0 then
			PST:addXP(PST.modData.xpObtained, false)
			PST.modData.xpObtained = 0
		end

		-- Save data
		PST:save()
	elseif not room:IsClear() then
		clearRoomProc = false
	end
end