-- On new room
function PST:onNewRoom()
	PST.modData.spawnKills = 0
	PST.modData.xpObtained = 0
	PST.specialNodes.quickWit.pauseTime = 0
	floatingTexts = {}

	local player = Isaac.GetPlayer()
	local room = Game():GetRoom()

	-- Mod: chance to gain +4% all stats when entering a room with monsters
	local tmpTreeMod = PST:getTreeSnapshotMod("allstatsRoom", 0)
	if tmpTreeMod and room:GetAliveEnemiesCount() > 0 and 100 * math.random() < tmpTreeMod then
		if not PST:getTreeSnapshotMod("allstatsRoomProc", false) then
			PST:addModifiers({ allstatsPerc = 4, allstatsRoomProc = true }, true)
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
		end
	elseif PST:getTreeSnapshotMod("allstatsRoomProc", false) then
		PST:addModifiers({ allstatsPerc = -4, allstatsRoomProc = false}, true)
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
	end

	-- Impromptu Gambler node (Cain's tree)
	if PST:getTreeSnapshotMod("impromptuGambler", false) and room:GetType() == RoomType.ROOM_TREASURE then
		if not PST:getTreeSnapshotMod("impromptuGamblerProc", false) then
			PST.specialNodes.impromptuGamblerItems = {}
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
					table.insert(
						PST.specialNodes.impromptuGamblerItems,
						Vector(math.floor(tmpEntity.Position.X / 40), math.floor(tmpEntity.Position.Y / 40))
					)
				end
			end
			PST:addModifiers({ impromptuGamblerProc = true }, true)

			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 80)
			local newCrane = Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.CRANE_GAME, tmpPos, Vector.Zero, nil, 0, Random() + 1)
			Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
			SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND, 0.7)

			local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_NULL, false, Random() + 1)
			newCrane:ToSlot():SetPrizeCollectible(newItem)
		end
	end

	-- Dark Heart node (Judas' tree)
	if PST:getTreeSnapshotMod("darkHeart", false) and PST:getTreeSnapshotMod("darkHeartBelial", false) then
		PST:addModifiers({ darkHeartBelial = false }, true)
	end

	-- Reset book of belial charges gained counter
    if PST:getTreeSnapshotMod("belialChargesGained", 0) > 0 then
        PST:addModifiers({ belialChargesGained = { value = 0, set = true } }, true)
    end

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
	if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON) then
		-- Samson, reset damage debuff
		if cosmicRCache.samsonDmg > 0 then
			PST:addModifiers({ damage = cosmicRCache.samsonDmg }, true)
			cosmicRCache.samsonDmg = 0
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
		-- Tainted Judas, reset damage buff
		local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
		if cosmicRCache.TJudasDmgUps > 0 then
			if not isKeeper then
				PST:addModifiers({ damage = -0.4 * cosmicRCache.TJudasDmgUps }, true)
			else
				PST:addModifiers({ damage = -0.2 * cosmicRCache.TJudasDmgUps }, true)
			end
			cosmicRCache.TJudasDmgUps = 0
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
		-- Tainted Forgotten, as Keeper: reset trackers
		cosmicRCache.TForgottenTracker.keeperCoin = false
		cosmicRCache.TForgottenTracker.keeperHeal = false
		player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
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

	-- First room entry
	if room:IsFirstVisit() then
		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
			-- Tainted Magdalene, if room has monsters and you have more than 2 red hearts, take 1/2 heart damage
			local player = Isaac.GetPlayer()
			if room:GetAliveEnemiesCount() > 0 and player:GetHearts() > 4 then
				player:TakeDamage(1, 0, EntityRef(player), 0)
			end
		end

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
		-- Treasure room
		elseif room:GetType() == RoomType.ROOM_TREASURE then
			-- Cosmic Realignment node
			if PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC_B) then
				-- Tainted Isaac, remove items from first treasure room entered
				if not cosmicRCache.TIsaacProc then
					for _, entity in ipairs(Isaac.GetRoomEntities()) do
						if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
							entity:Remove()
						end
					end
					PST:createFloatTextFX("Curse of T. Isaac", Vector.Zero, Color(1, 0.4, 0.4, 1), 0.09, 120, true)
					SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
					cosmicRCache.TIsaacProc = true
					PST:save()
				end
			end
		end
	end
end