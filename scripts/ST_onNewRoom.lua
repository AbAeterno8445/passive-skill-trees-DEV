-- On new room
function PST:onNewRoom()
	PST.modData.spawnKills = 0
	PST.modData.xpObtained = 0
	PST.modData.roomSlotIDs = {}
	PST.specialNodes.quickWit.pauseTime = 0
	floatingTexts = {}

	local room = Game():GetRoom()

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
	if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON) then
		-- Samson, reset damage debuff
		if cosmicRCache.samsonDmg > 0 then
			PST:addModifiers({ damage = cosmicRCache.samsonDmg }, true)
			cosmicRCache.samsonDmg = 0
		end
	end

	-- Quick Wit node, start timer
	local quickWitMod = PST:getTreeSnapshotMod("quickWit", {0, 0})
	if quickWitMod[1] ~= 0 or quickWitMod[2] ~= 0 then
		if room:GetType() ~= RoomType.ROOM_BOSS and room:GetType() ~= RoomType.ROOM_BOSSRUSH then
			PST.specialNodes.quickWit.startTime = os.clock()
		else
			-- Deactivate on boss rooms
			PST.specialNodes.quickWit.startTime = 0
		end
	end

	-- First room entry XP reward
	if room:IsFirstVisit() then
		-- Secret rooms
		if room:GetType() == RoomType.ROOM_SECRET or
		room:GetType() == RoomType.ROOM_SUPERSECRET or
		room:GetType() == RoomType.ROOM_ULTRASECRET then
			local secretXP = PST:getTreeSnapshotMod("secretXP", 0)
			local expertSpelunkerXP = PST:getTreeSnapshotMod("expertSpelunker", 0)
			if expertSpelunkerXP == 0 and secretXP > 0 then
				PST:addXP(secretXP, true)
			elseif expertSpelunkerXP > 0 then
				if room:GetType() == RoomType.ROOM_SUPERSECRET or room:GetType() == RoomType.ROOM_ULTRASECRET then
					PST:addXP(expertSpelunkerXP, true)
				end
			end
		-- Devil/Angel rooms
		elseif room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL then
			local randomStat = PST:getRandomStat()
			local tmpAdd = 1
			if randomStat == "speed" then
				tmpAdd = 0.1
			end

			-- Hell's favour mod
			local hellFavourMod = PST:getTreeSnapshotMod("hellFavour", false)
			if hellFavourMod then
				if room:GetType() == RoomType.ROOM_DEVIL then
					PST:addModifiers({ [randomStat] = tmpAdd }, true)
				else
					PST:addModifiers({
						[randomStat] = -tmpAdd,
						causeCurse = true
					}, true)
				end
			end

			-- Angel's favour mod
			local heavenFavourMod = PST:getTreeSnapshotMod("heavenFavour", false)
			if heavenFavourMod then
				if room:GetType() == RoomType.ROOM_ANGEL then
					PST:addModifiers({ [randomStat] = tmpAdd }, true)
				else
					PST:addModifiers({
						[randomStat] = -tmpAdd,
						causeCurse = true
					}, true)
				end
			end
		end
	end
end