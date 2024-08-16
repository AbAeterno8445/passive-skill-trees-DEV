-- On new room
function PST:onNewRoom()
	PST.modData.spawnKills = 0
	PST.modData.xpObtained = 0
	PST.specialNodes.quickWit.pauseTime = 0
	PST.specialNodes.bossHits = 0
	PST.specialNodes.bossRoomHitsFrom = 0
	PST.specialNodes.forgottenMeleeTearBuff = 0
	PST.specialNodes.oneShotProtectedMobs = {}
	PST.specialNodes.mobFirstHitsBlocked = {}
	PST.specialNodes.mobPeriodicShield = false
	PST.specialNodes.mobHitRoomExtraDmg = { hits = 0, proc = false }
	PST.specialNodes.SC_soulEaterMobs = {}

	local player = Isaac.GetPlayer()
	local room = Game():GetRoom()
	local roomEntities = {}

	-- Optimize GetRoomEntities
	local function PST_FetchRoomEntities()
		if #roomEntities == 0 then
			roomEntities = Isaac.GetRoomEntities()
		end
		return roomEntities
	end

	-- Starcursed modifiers
	if room:GetAliveEnemiesCount() > 0 then
		local mobsList = {}
		local soulEaterList = {}
		for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpEntity:IsActiveEnemy(false) then
				if not tmpNPC:IsBoss() then table.insert(mobsList, tmpNPC)
				else table.insert(soulEaterList, tmpNPC) end

				-- Chance to duplicate
				local tmpChance = PST:SC_getSnapshotMod("mobDuplicate", 0)
				if not tmpNPC:IsBoss() and not tmpEntity.Parent and 100 * math.random() < tmpChance then
					local tmpPos = Isaac.GetFreeNearPosition(tmpEntity.Position, 5)
					Game():Spawn(tmpEntity.Type, tmpEntity.Variant, tmpPos, Vector.Zero, nil, tmpEntity.SubType, Random() + 1)
				end

				-- Chance to turn into champion
				tmpChance = PST:SC_getSnapshotMod("mobTurnChampion", 0)
				if 100 * math.random() < tmpChance then
					tmpNPC:MakeChampion(Random() + 1)
				end

				-- HP modifiers
				local tmpHPMod = 0
				local tmpHPMult = 1
				if not tmpNPC:IsBoss() and not tmpNPC:IsChampion() then
					tmpHPMod = tmpHPMod + PST:SC_getSnapshotMod("mobHP", 0)
					tmpHPMult = tmpHPMult + PST:SC_getSnapshotMod("mobHPPerc", 0) / 100
				else
					if tmpNPC:IsChampion() then
						tmpHPMult = tmpHPMult + PST:SC_getSnapshotMod("champHPPerc", 0) / 100
					end
					if tmpNPC:IsBoss() then
						tmpHPMod = tmpHPMod + PST:SC_getSnapshotMod("bossHP", 0)
						tmpHPMult = tmpHPMult + PST:SC_getSnapshotMod("bossHPPerc", 0) / 100
					end
				end
				tmpEntity.MaxHitPoints = (tmpEntity.MaxHitPoints + tmpHPMod) * tmpHPMult
				tmpEntity.HitPoints = tmpEntity.MaxHitPoints
			end
		end

		-- Ancient starcursed jewel: Soul Watcher
		if PST:SC_getSnapshotMod("soulWatcher", false) then
			if #mobsList > 0 then
				local tmpSoulEater = mobsList[math.random(#mobsList)]
				table.insert(soulEaterList, tmpSoulEater)
			end
			for _, tmpMob in ipairs(soulEaterList) do
				tmpMob.Scale = tmpMob.Scale * 1.12
				tmpMob:SetColor(Color(0.86, 0.71, 0.93, 1), -1, 0, false)
				if not tmpMob:IsBoss() then
					tmpMob.MaxHitPoints = tmpMob.MaxHitPoints * 1.2
					tmpMob.HitPoints = tmpMob.MaxHitPoints
				end
				table.insert(PST.specialNodes.SC_soulEaterMobs, { mob = tmpMob, souls = 0})
			end
		end
	end

	-- Ancient starcursed jewel: Challenger's Starpiece
	if PST:SC_getSnapshotMod("challengerStarpiece", false) and not PST:getTreeSnapshotMod("SC_challClear", false) and
	PST:getTreeSnapshotMod("SC_levelHasChall", false) then
		if room:GetType() ~= RoomType.ROOM_CHALLENGE and not PST:getTreeSnapshotMod("SC_challDebuff", false) then
			PST:addModifiers({ damagePerc = -50, SC_challDebuff = true }, true)
		elseif room:GetType() == RoomType.ROOM_CHALLENGE and PST:getTreeSnapshotMod("SC_challDebuff", false) then
			PST:addModifiers({ damagePerc = 50, SC_challDebuff = false }, true)
		end
	end

	-- Mod: chance to gain +4% all stats when entering a room with monsters
	local tmpTreeMod = PST:getTreeSnapshotMod("allstatsRoom", 0)
	if tmpTreeMod ~= 0 then
		if room:GetAliveEnemiesCount() > 0 and 100 * math.random() < tmpTreeMod then
			if not PST:getTreeSnapshotMod("allstatsRoomProc", false) then
				PST:addModifiers({ allstatsPerc = 4, allstatsRoomProc = true }, true)
				player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
			end
		elseif PST:getTreeSnapshotMod("allstatsRoomProc", false) then
			PST:addModifiers({ allstatsPerc = -4, allstatsRoomProc = false}, true)
			player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
		end
	end

	-- Intermittent Conceptions node (Isaac's tree)
	if PST:getTreeSnapshotMod("intermittentConceptions", false) then
		for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
			if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
					break
				end
			end
		end
	end

	-- Impromptu Gambler node (Cain's tree)
	if PST:getTreeSnapshotMod("impromptuGambler", false) and room:GetType() == RoomType.ROOM_TREASURE then
		if not PST:getTreeSnapshotMod("impromptuGamblerProc", false) then
			PST.specialNodes.impromptuGamblerItems = {}
			for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
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

	-- Mod: +all stats when using the poop (reset)
	if PST:getTreeSnapshotMod("poopAllStatsProc", false) then
		PST:addModifiers({
			allstats = -PST:getTreeSnapshotMod("thePoopAllStats", 0),
			allstatsPerc = -PST:getTreeSnapshotMod("thePoopAllStatsPerc", 0),
			poopAllStatsProc = false
		}, true)
	end

	-- Active dead bird mods
	if PST.specialNodes.deadBirdActive then
		PST:addModifiers({
			damage = -PST:getTreeSnapshotMod("activeDeadBirdDamage", 0),
			speed = -PST:getTreeSnapshotMod("activeDeadBirdSpeed", 0),
			range = -PST:getTreeSnapshotMod("activeDeadBirdRange", 0),
			tears = -PST:getTreeSnapshotMod("activeDeadBirdTears", 0),
			shotSpeed = -PST:getTreeSnapshotMod("activeDeadBirdShotspeed", 0)
		}, true)
		PST.specialNodes.deadBirdActive = false
	end

	-- Mod: +% speed when hit. Resets every room
	local tmpTotal = PST:getTreeSnapshotMod("speedWhenHitTotal", 0)
	if tmpTotal > 0 then
		PST:addModifiers({
			speedPerc = -tmpTotal,
			speedWhenHitTotal = { value = 0, set = true }
		}, true)
	end

	-- Chaotic Treasury node (Eden's tree)
	local level = Game():GetLevel()
	if PST:getTreeSnapshotMod("chaoticTreasury", false) and room:GetType() == RoomType.ROOM_TREASURE and
	not PST:getTreeSnapshotMod("chaoticTreasuryProc", false) then
		if level:GetStage() == LevelStage.STAGE1_1 then
			-- Spawn Chaos in the first floor's treasure room
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 80)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_CHAOS, Random() + 1)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
			-- If you have Chaos, spawn an additional random item
			local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE)
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 80)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, newItem, Random() + 1)
		end
		PST:addModifiers({ chaoticTreasuryProc = true }, true)
	end

	-- Sacred Aegis node (The Lost's tree)
	if PST:getTreeSnapshotMod("sacredAegis", false) then
		local hitsTaken = PST.specialNodes.sacredAegis.hitsTaken
		if hitsTaken > 0 then
			PST:addModifiers({ allstatsPerc = 7 * hitsTaken }, true)
		end
		PST.specialNodes.sacredAegis = { hitTime = 0, proc = false, hitsTaken = 0 }
	end

	-- Minion Maneuvering node (Lilith's tree)
	if PST:getTreeSnapshotMod("minionManeuvering", false) then
		PST.specialNodes.minionManeuveringMaxBonus = 15
		player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
	end

	-- Mod: +all stats when using Box of Friends (reset)
	local tmpStats = PST:getTreeSnapshotMod("boxOfFriendsAllStats", 0)
	if PST:getTreeSnapshotMod("boxOfFriendsAllStatsProc", 0) then
		PST:addModifiers({ allstats = -tmpStats, boxOfFriendsAllStatsProc = false }, true)
	end

	-- Keeper's Blessing node (Keeper's tree)
	if PST:getTreeSnapshotMod("keeperBlessing", false) then
		PST:addModifiers({ keeperBlessingHeals = { value = 0, set = true } }, true)
	end

	-- Mod: chance for the second floor's treasure room to contain an additional Eraser item pedestal
	if (level:GetStage() == LevelStage.STAGE1_2 or not PST:isFirstOrigStage()) and
	room:GetType() == RoomType.ROOM_TREASURE and not PST:getTreeSnapshotMod("eraserSecondFloorProc", false) then
		if 100 * math.random() < PST:getTreeSnapshotMod("eraserSecondFloor", 0) then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_ERASER, Random() + 1)
			PST:addModifiers({ eraserSecondFloorProc = true }, true)
		end
	end

	-- Spirit Ebb node (The Forgotten's tree)
	if PST.specialNodes.spiritEbbHits.forgotten > 0 or PST.specialNodes.spiritEbbHits.soul > 0 then
		PST.specialNodes.spiritEbbHits.forgotten = 0
		PST.specialNodes.spiritEbbHits.soul = 0
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY, true)
	end

	-- Inner Flare node (The Forgotten's tree)
	if PST:getTreeSnapshotMod("innerFlareProc", false) then
		PST:addModifiers({ innerFlareProc = false }, true)
	end

	-- Will-o-the-Wisp node (Bethany's tree)
	tmpTreeMod = PST:getTreeSnapshotMod("willOTheWispDmgBuff", 0)
	if tmpTreeMod ~= 0 then
		PST:addModifiers({ damage = -tmpTreeMod, willOTheWispDmgBuff = { value = 0, set = true } }, true)
	end

	-- Soul Trickle node (Bethany's tree)
	tmpTreeMod = PST:getTreeSnapshotMod("soulTrickleWispDrops", 0)
	if tmpTreeMod ~= 0 then
		PST:addModifiers({ soulTrickleWispDrops = { value = 0, set = true } }, true)
	end

	-- Coordination node (Jacob & Esau's tree)
	if PST.specialNodes.coordinationHits.jacob > 0 or PST.specialNodes.coordinationHits.esau > 0 then
		PST.specialNodes.coordinationHits.jacob = 0
		PST.specialNodes.coordinationHits.esau = 0
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
		if player:GetOtherTwin() then
			player:GetOtherTwin():AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
		end
	end

	-- Mod: chance for enemies killed by Jacob to drop 1/2 red heart, once per room
	if PST:getTreeSnapshotMod("jacobHeartOnKillProc", false) or PST:getTreeSnapshotMod("esauSoulOnKillProc", false) then
		PST:addModifiers({ jacobHeartOnKillProc = false, esauSoulOnKillProc = false }, true)
	end

	-- Dark Songstress node (Siren's tree)
	if PST:getTreeSnapshotMod("darkSongstressActive", false) then
		PST:addModifiers({ damagePerc = -8, speedPerc = -8, darkSongstressActive = false }, true)
	end

	-- Song of Darkness node (Siren's tree)
	if PST:getTreeSnapshotMod("songOfDarkness", false) and PST:getTreeSnapshotMod("songOfDarknessChance", 2) > 2 then
		PST:addModifiers({ songOfDarknessChance = { value = 2, set = true } }, true)
	end

	-- Song of Celerity node (Siren's tree)
	tmpTreeMod = PST:getTreeSnapshotMod("songOfCelerityBuff", 0)
	if tmpTreeMod ~= 0 then
		PST:addModifiers({ tearsPerc = -tmpTreeMod, songOfCelerityBuff = { value = 0, set = true } }, true)
	end

	-- Song of Awe node (Siren's tree)
	if PST:getTreeSnapshotMod("songOfAweActive", false) then
		PST:addModifiers({ allstatsPerc = -4, songOfAweActive = false }, true)
	end

	-- Mod: charmed hit negation (reset)
	if PST:getTreeSnapshotMod("charmedHitNegationProc", false) then
		PST:addModifiers({ charmedHitNegationProc = false }, true)
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

	-- Mod: chance to unlock boss challenge rooms regardless of hearts
	if PST:getTreeSnapshotMod("bossChallengeUnlockProc", false) and level:HasBossChallenge() then
		for i=0,7 do
			local tmpDoor = room:GetDoor(i)
			if tmpDoor and tmpDoor.TargetRoomType == RoomType.ROOM_CHALLENGE then
				tmpDoor:TryUnlock(player, true)
			end
		end
	end

	-- First room entry
	if room:IsFirstVisit() then
		-- Starcursed jewel in planetariums
		if room:GetType() == RoomType.ROOM_PLANETARIUM and 100 * math.random() < PST.SCDropRates.planetarium().regular then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.planetarium().ancient)
		end

		-- Ancient starcursed jewel: Umbra
		if PST:SC_getSnapshotMod("umbra", false) and level:GetCurses() & LevelCurse.CURSE_OF_DARKNESS and
		not player:HasCollectible(CollectibleType.COLLECTIBLE_NIGHT_LIGHT) then
			if PST:getTreeSnapshotMod("SC_umbraStatsDown", 0) < 20 then
				PST:addModifiers({ allstatsPerc = -2, SC_umbraStatsDown = 2 }, true)
			end
		end

		-- Ancient starcursed jewel: Cursed Starpiece
		if PST:SC_getSnapshotMod("cursedStarpiece", false) and not PST:isFirstOrigStage() and room:GetType() == RoomType.ROOM_TREASURE then
			local firstItem = true
			for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
				local tmpItem = tmpEntity:ToPickup()
				if tmpItem and tmpItem.Variant == PickupVariant.PICKUP_COLLECTIBLE then
					if firstItem then
						Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpItem.Position, Vector.Zero, nil, Card.CARD_REVERSE_STARS, Random() + 1)
						firstItem = false
					end
					tmpItem:Remove()
				end
			end
		end

		-- Ancient starcursed jewel: Baubleseeker
		if PST:SC_getSnapshotMod("baubleseeker", false) and room:GetType() == RoomType.ROOM_TREASURE then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and 100 * math.random() < 10 then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_MOMS_BOX, Random() + 1)
			end
		end

		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
			-- Tainted Magdalene, if room has monsters and you have more than 2 red hearts, take 1/2 heart damage
			player = Isaac.GetPlayer()
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

			-- Mod: +luck for the current floor when entering a secret room
			local secretLuck = PST:getTreeSnapshotMod("secretRoomFloorLuck", 0)
			if secretLuck ~= 0 then
				PST:addModifiers({ luck = secretLuck, floorLuck = secretLuck }, true)
			end

			-- Mod: +0.01 to a random stat when entering a secret room. Rolls more times if multiple are allocated
			local tmpMod = PST:getTreeSnapshotMod("secretRoomRandomStat", 0)
			if tmpMod > 0 and room:GetType() == RoomType.ROOM_SECRET then
				local tmpAdd = {}
				for _=1,tmpMod do
					local randStat = PST:getRandomStat()
					if tmpAdd[randStat] == nil then
						tmpAdd[randStat] = 0
					end
					tmpAdd[randStat] = tmpAdd[randStat] + 0.01
				end
				PST:addModifiers(tmpAdd, true)
			end
		-- Devil/Angel rooms
		elseif room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL then
			local randomStat = PST:getRandomStat()
			local tmpAdd = 1
			if randomStat == "speed" then
				tmpAdd = 0.2
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
					for _, entity in ipairs(PST_FetchRoomEntities()) do
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
		-- Planetarium
		elseif room:GetType() == RoomType.ROOM_PLANETARIUM then
			-- Mod: +% all stats when entering the planetarium for the first time in this run
			tmpStats = PST:getTreeSnapshotMod("planetariumAllstats", 0)
			if tmpStats ~= 0 and not PST:getTreeSnapshotMod("planetariumAllstatsProc") then
				PST:addModifiers({ allstatsPerc = tmpStats, planetariumAllstatsProc = true }, true)
			end
		end
	end
end