local sfx = SFXManager()

-- On update
local clearRoomProc = false
function SkillTrees:onUpdate()
	-- On room clear
	local room = Game():GetRoom()
	if room:IsClear() and not clearRoomProc then
		clearRoomProc = true
		if SkillTrees.modData.xpObtained > 0 then
			-- Convert temp xp to normal xp
			SkillTrees:addXP(SkillTrees.modData.xpObtained, false)
			SkillTrees.modData.xpObtained = 0

			--[[local level = Game():GetLevel()
			if room:GetType() == RoomType.ROOM_CHALLENGE then
				-- Challenge room XP reward
				if level:HasBossChallenge() then
					SkillTrees:addXP((90 * level:GetStage()) / 3)
				else
					SkillTrees:addXP((60 + 30 * level:GetStage()) / 3)
				end
			elseif room:GetType() == RoomType.ROOM_BOSSRUSH then
				-- Boss rush XP reward
				SkillTrees:addXP(2000)
			end]]
		end

		-- Respec chance
		if room:GetType() == RoomType.ROOM_BOSS then
			if 100 * math.random() < 99--[[SkillTrees:getTreeSnapshotMod("respecChance", 15)]] then
				SkillTrees:createFloatTextFX("+1 Respec", Vector(-16, -40), Color(1, 1, 1, 1), 0.12, 90, true)
				sfx:Play(SoundEffect.SOUND_THUMBSUP)
				SkillTrees.modData.respecPoints = SkillTrees.modData.respecPoints + 1
			end
		end

		-- Save data
		SkillTrees:save()
	elseif not room:IsClear() then
		clearRoomProc = false
	end
end