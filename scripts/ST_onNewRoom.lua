local statsList = {"damage", "luck", "speed", "tears", "shotSpeed", "range"}

-- On new room
function SkillTrees:onNewRoom()
	SkillTrees.modData.spawnKills = 0
	SkillTrees.modData.xpObtained = 0
	SkillTrees.modData.roomSlotIDs = {}
	SkillTrees.specialNodes.quickWit.pauseTime = 0
	floatingTexts = {}

	local room = Game():GetRoom()
	-- Quick Wit node, start timer
	local quickWitMod = SkillTrees:getTreeSnapshotMod("quickWit", {0, 0})
	if quickWitMod[1] ~= 0 or quickWitMod[2] ~= 0 then
		if room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH then
			SkillTrees.specialNodes.quickWit.startTime = os.clock()
		else
			-- Deactivate on boss rooms
			SkillTrees.specialNodes.quickWit.startTime = 0
		end
	end

	-- First room entry XP reward
	if room:IsFirstVisit() then
		-- Secret rooms
		if room:GetType() == RoomType.ROOM_SECRET or
		room:GetType() == RoomType.ROOM_SUPERSECRET or
		room:GetType() == RoomType.ROOM_ULTRASECRET then
			local secretXP = SkillTrees:getTreeSnapshotMod("secretXP", 0)
			local expertSpelunkerXP = SkillTrees:getTreeSnapshotMod("expertSpelunker", 0)
			if expertSpelunkerXP == 0 and secretXP > 0 then
				SkillTrees:addXP(secretXP, true)
			elseif expertSpelunkerXP > 0 then
				if room:GetType() == RoomType.ROOM_SUPERSECRET or room:GetType() == RoomType.ROOM_ULTRASECRET then
					SkillTrees:addXP(expertSpelunkerXP, true)
				end
			end
		-- Devil/Angel rooms
		elseif room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL then
			-- Hell's favour mod
			local hellFavourMod = SkillTrees:getTreeSnapshotMod("hellFavour", false)
			if hellFavourMod then
				local randomStat = statsList[math.random(#statsList)]
				if room:GetType() == RoomType.ROOM_DEVIL then
					SkillTrees:addModifier({
						[randomStat] = 1
					}, true)
				else
					SkillTrees:addModifier({
						[randomStat] = -1
					}, true)
					SkillTrees:addModifier({causeCurse = true}, true)
				end
			end

			-- Angel's favour mod
			local heavenFavourMod = SkillTrees:getTreeSnapshotMod("heavenFavour", false)
			if heavenFavourMod then
				local randomStat = statsList[math.random(#statsList)]
				if room:GetType() == RoomType.ROOM_ANGEL then
					SkillTrees:addModifier({
						[randomStat] = 1
					}, true)
				else
					SkillTrees:addModifier({
						[randomStat] = -1
					}, true)
					SkillTrees:addModifier({causeCurse = true}, true)
				end
			end
		end
	end
end