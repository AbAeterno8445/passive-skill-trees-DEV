-- On new room
function PST:onNewRoom()
    if not PST.gameInit then return end

	PST.modData.spawnKills = 0
	PST.modData.xpObtained = 0
	PST.specialNodes.bossHits = 0
	PST.specialNodes.bossRoomHitsFrom = 0
	PST.specialNodes.forgottenMeleeTearBuff = 0
	PST.specialNodes.oneShotProtectedMobs = {}
	PST.specialNodes.mobFirstHitsBlocked = {}
	PST.specialNodes.mobPeriodicShield = false
	PST.specialNodes.mobHitRoomExtraDmg = { hits = 0, proc = false }
	PST.specialNodes.SC_soulEaterMobs = {}
	PST.specialNodes.SC_hoveringTears = {}
	PST.specialNodes.SC_exploderTears = {}
	PST.specialNodes.SC_martianFX = {}
	PST.specialNodes.SC_martianTears = {}
	PST.specialNodes.SC_nullstoneCurrentSpawn = nil
	PST.specialNodes.SC_nullstoneSpawned = 0
	PST.specialNodes.lingMaliceCreepList = {}
	PST.specialNodes.temporaryHearts = {}
	PST.specialNodes.trollBombDisarmDebuffTimer = 0
	PST.specialNodes.annihilationProcs = 0
	PST.specialNodes.annihilationHitList = {}
	PST.specialNodes.anarchyBombProcs = 0
	PST.specialNodes.howToJumpPulseTimer = 0

	local player = PST:getPlayer()
	local room = Game():GetRoom()
	PST.room = room

	local roomEntities = {}

	if room:GetAliveEnemiesCount() == 0 then
		PST:addModifiers({ roomClearProc = true }, true)
	else
		PST:addModifiers({ roomClearProc = false }, true)
	end

	-- Optimize GetRoomEntities
	local function PST_FetchRoomEntities()
		if #roomEntities == 0 then
			roomEntities = Isaac.GetRoomEntities()
		end
		return roomEntities
	end

	-- Reset d7 proc
	if PST:getTreeSnapshotMod("d7Proc", false) then
		PST:addModifiers({ d7Proc = false }, true)
	end

	-- Curse of Maze teleport - reapply curse
	if PST.specialNodes.levelMazeCurseProc then
		PST:getLevel():AddCurse(LevelCurse.CURSE_OF_MAZE, false)
		PST.specialNodes.levelMazeCurseProc = false
	end

	-- Starcursed modifiers
	if room:GetAliveEnemiesCount() > 0 then
		local mobsList = {}
		local soulEaterList = {}
		for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpEntity:IsActiveEnemy(false) and tmpEntity:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
				if not tmpNPC:IsBoss() then table.insert(mobsList, tmpNPC)
				else table.insert(soulEaterList, tmpNPC) end

				if room:GetType() ~= RoomType.ROOM_BOSS then
					-- Chance to duplicate
					local tmpChance = PST:SC_getSnapshotMod("mobDuplicate", 0)
					if not tmpNPC:IsBoss() and not tmpEntity.Parent and 100 * math.random() < tmpChance then
						local tmpPos = Isaac.GetFreeNearPosition(tmpEntity.Position, 5)
						Game():Spawn(tmpEntity.Type, tmpEntity.Variant, tmpPos, Vector.Zero, nil, tmpEntity.SubType, Random() + 1)
					end

					-- Chance to turn into champion
					local jewelChampChance = PST:SC_getSnapshotMod("mobTurnChampion", 0)
					if PST:SC_getSnapshotMod("mightstone", false) then
						jewelChampChance = jewelChampChance + 50
					end
					tmpChance = PST:getTreeSnapshotMod("championChance", 0)
					if jewelChampChance > 0 and (not tmpNPC:IsBoss() or (tmpNPC:IsBoss() and PST:NPCChampionAvailable(tmpNPC)))
					and not PST:arrHasValue(PST.noChampionMobsJewel, tmpNPC.Type) and 100 * math.random() < jewelChampChance then
						tmpNPC:MakeChampion(Random() + 1)
					elseif tmpChance > 0 and PST:NPCChampionAvailable(tmpNPC) and 100 * math.random() < tmpChance then
						tmpNPC:MakeChampion(Random() + 1)
					end
				end

				-- HP modifiers
				if tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
					local tmpHPMod = 0
					local tmpHPMult = 1
					local extraHPMult = 1
					if PST:isFirstOrigStage() then
						extraHPMult = 0.5
					end
					if tmpNPC.Type == EntityType.ENTITY_LARRYJR then
						extraHPMult = extraHPMult / 2
					end
					if not tmpNPC:IsBoss() and not tmpNPC:IsChampion() then
						tmpHPMod = tmpHPMod + PST:SC_getSnapshotMod("mobHP", 0)
						tmpHPMult = tmpHPMult + (PST:SC_getSnapshotMod("mobHPPerc", 0) * extraHPMult) / 100
					else
						if tmpNPC:IsChampion() then
							tmpHPMult = tmpHPMult + (PST:SC_getSnapshotMod("champHPPerc", 0) * extraHPMult) / 100
							if PST:SC_getSnapshotMod("mightstone", false) then
								tmpHPMult = tmpHPMult + 0.15 * extraHPMult
							end
						end
						if tmpNPC:IsBoss() then
							tmpHPMod = tmpHPMod + PST:SC_getSnapshotMod("bossHP", 0)
							tmpHPMult = tmpHPMult + (PST:SC_getSnapshotMod("bossHPPerc", 0) * extraHPMult) / 100
						end
					end
					tmpEntity.MaxHitPoints = (tmpEntity.MaxHitPoints + tmpHPMod * extraHPMult) * tmpHPMult
					tmpEntity.HitPoints = tmpEntity.MaxHitPoints
				end
			end
		end

		-- Ancient starcursed jewel: Soul Watcher
		if PST:SC_getSnapshotMod("soulWatcher", false) then
			if #mobsList > 0 then
				local tmpSoulEater = mobsList[math.random(#mobsList)]
				table.insert(soulEaterList, tmpSoulEater)
			end
			for _, tmpMob in ipairs(soulEaterList) do
				if tmpMob.Type ~= EntityType.ENTITY_GIDEON then
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

		-- Ancient starcursed jewel: Nightmare Projector
		if PST:SC_getSnapshotMod("nightmareProjector", false) and not PST:getTreeSnapshotMod("SC_nightProjProc", false) then
			PST.specialNodes.SC_nightProjTimer = 3600
			player:UseCard(Card.CARD_REVERSE_HIGH_PRIESTESS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
			SFXManager():Play(SoundEffect.SOUND_REVERSE_HIGH_PRIESTESS)
			PST:addModifiers({ SC_nightProjProc = true }, true)
		end

		-- Ancient starcursed jewel: Teprucord Tenican Eljwe
		if PST:SC_getSnapshotMod("teprucordTenicanEljwe", false) and room:GetType() ~= RoomType.ROOM_BOSS and 100 * math.random() < 40 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_DATAMINER, UseFlag.USE_NOANIM)
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
	elseif PST:getTreeSnapshotMod("SC_challDebuff", false) then
		PST:addModifiers({ damagePerc = 50, SC_challDebuff = false }, true)
	end

	-- Ancient starcursed jewel: Chronicler Stone
	if room:IsFirstVisit() and PST:SC_getSnapshotMod("chroniclerStone", false) then
		local tmpMod = PST:getTreeSnapshotMod("SC_chroniclerRooms", 0)
		if tmpMod > 0 then
			PST:addModifiers({ SC_chroniclerRooms = -1 }, true)
		end
	end

	-- Ancient starcursed jewel: Martian Ultimatum
	local tmpMod = PST:getTreeSnapshotMod("SC_martianDebuff", 0)
	if PST:SC_getSnapshotMod("martianUltimatum", false) and tmpMod > 0 then
		PST:addModifiers({ speed = tmpMod, SC_martianDebuff = { value = 0, set = true } }, true)
	end

	-- Ancient starcursed jewel: Nullstone
	if PST:SC_getSnapshotMod("nullstone", false) then
		-- Reset proc
		if PST:getTreeSnapshotMod("SC_nullstoneProc", false) then
			PST:addModifiers({ SC_nullstoneProc = false }, true)
		end
		-- Get highest enemy HP
		if room:GetType() ~= RoomType.ROOM_BOSS and room:GetAliveEnemiesCount() > 0 then
			local highestHP = 0
			for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
				local tmpNPC = tmpEntity:ToNPC()
				if tmpNPC and not tmpNPC:IsBoss() and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and
				not EntityRef(tmpNPC).IsFriendly then
					if tmpNPC.MaxHitPoints > highestHP then
						highestHP = tmpNPC.MaxHitPoints
					end
				end
			end
			PST:addModifiers({ SC_nullstoneHPThreshold = { value = highestHP, set = true } }, true)
		end
	end

	-- Ancient starcursed jewel: Twisted Emperor's Heirloom
	if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) then
		local roomID = PST:getLevel():GetCurrentRoomDesc().SafeGridIndex
		if PST:getTreeSnapshotMod("SC_empHeirloomUsedCard", false) then
			if room:GetType() == RoomType.ROOM_BOSS then
				if PST:getTreeSnapshotMod("SC_empHeirloomRoomID", -1) == -1 then
					PST:addModifiers({ SC_empHeirloomRoomID = { value = roomID, set = true } }, true)
				end
			else
				-- Got teleported elsewhere, meaning no rev boss to fight
				PST:addModifiers({ SC_empHeirloomProc = true }, true)
			end
		end
	end

	-- Ancient starcursed jewel: Cursed Auric Shard
	if PST:getTreeSnapshotMod("SC_cursedAuricSpeedProc", false) then
		player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
	end

	-- Ancient starcursed jewel: Glowing Glass Piece
	if PST:SC_getSnapshotMod("glowingGlassPiece", false) then
		if room:GetAliveEnemiesCount() == 0 and PST:getLevel():GetCurrentRoomDesc().ClearCount == 1 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, UseFlag.USE_NOANIM)
			PST.specialNodes.SC_glowingGlassProc = true
		end
	end

	-- Ancient starcursed jewel: Astral Insignia
	if PST:SC_getSnapshotMod("astralInsignia", false) and room:IsFirstVisit() then
		tmpMod = PST:getTreeSnapshotMod("SC_astralInsigniaDebuff", 0)
		if room:GetType() == RoomType.ROOM_DEFAULT and tmpMod < 60 and not PST:getLevel():IsAscent() then
			PST:addModifiers({ allstatsPerc = -2, SC_astralInsigniaDebuff = 2 }, true)
		elseif room:GetType() == RoomType.ROOM_PLANETARIUM and tmpMod > 0 then
			PST:addModifiers({ allstatsPerc = tmpMod / 2, SC_astralInsigniaDebuff = -tmpMod / 2 }, true)
		end
	end

	-- Ancient starcursed jewel: Mightstone
	if PST:getTreeSnapshotMod("SC_mightstoneProcs", 0) > 0 then
		PST:addModifiers({ SC_mightstoneProcs = { value = 0, set = true } }, true)
	end

	-- Mod: chance to gain +4% all stats when entering a room with monsters
	local tmpTreeMod = PST:getTreeSnapshotMod("allstatsRoom", 0)
	if tmpTreeMod ~= 0 then
		if room:GetAliveEnemiesCount() > 0 and 100 * math.random() < tmpTreeMod then
			if not PST:getTreeSnapshotMod("allstatsRoomProc", false) then
				PST:addModifiers({ allstatsPerc = 4, allstatsRoomProc = true }, true)
				player:AddCacheFlags(PST.allstatsCache, true)
			end
		elseif PST:getTreeSnapshotMod("allstatsRoomProc", false) then
			PST:addModifiers({ allstatsPerc = -4, allstatsRoomProc = false}, true)
			player:AddCacheFlags(PST.allstatsCache, true)
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
	if PST:getTreeSnapshotMod("impromptuGambler", false) and room:GetType() == RoomType.ROOM_TREASURE and not PST:getLevel():IsAscent() then
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
			newCrane:SetSize(0.6, Vector(0.6, 0.6), 1)

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
		PST.specialNodes.deadBirdActive = false
		PST:updateCacheDelayed()
	end

	-- Carrion Avian node (Eve's tree)
    if PST:getTreeSnapshotMod("carrionAvian", false) then
        PST:addModifiers({ carrionAvianBossProc = { value = 0, set = true } }, true)
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
	local level = PST:getLevel()
	if PST:getTreeSnapshotMod("chaoticTreasury", false) and room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
		if PST:isFirstOrigStage() and not player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
			-- Spawn Chaos in the first floor's treasure room
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			local chaosItem = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_CHAOS, Random() + 1)
			chaosItem:SetSize(0.6, Vector(0.6, 0.6), 1)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
			-- If you have Chaos, spawn an additional random item
			local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE)
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			local rndItem = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, newItem, Random() + 1)
			rndItem:SetSize(0.6, Vector(0.6, 0.6), 1)
		end
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
	if (level:GetStage() == LevelStage.STAGE1_2 or (level:GetStage() == LevelStage.STAGE1_1 and not PST:isFirstOrigStage())) and
	room:GetType() == RoomType.ROOM_TREASURE and not PST:getTreeSnapshotMod("eraserSecondFloorProc", false) then
		if 100 * math.random() < PST:getTreeSnapshotMod("eraserSecondFloor", 0) then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_ERASER, Random() + 1)
		end
		PST:addModifiers({ eraserSecondFloorProc = true }, true)
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

	-- Overwhelming Song node (Siren's tree)
	tmpTreeMod = PST:getTreeSnapshotMod("overwhelmingVoiceBuff", 0)
	if tmpTreeMod > 0 then
		PST:addModifiers({ damagePerc = -tmpTreeMod, overwhelmingVoiceBuff = { value = 0, set = true } }, true)
	end

	-- Ransacking node (T. Cain's tree)
	if PST:getTreeSnapshotMod("ransackingRoomPickups", 0) > 0 then
		PST:addModifiers({ ransackingRoomPickups = { value = 0, set = true } }, true)
	end

	-- Mod: charmed hit negation (reset)
	if PST:getTreeSnapshotMod("charmedHitNegationProc", false) then
		PST:addModifiers({ charmedHitNegationProc = false }, true)
	end

	-- Sinistral Runemaster Ehwaz proc
	if PST:getTreeSnapshotMod("ehwazAllstatsProc", false) then
		PST:addModifiers({ ehwazAllstatsProc = false }, true)
	end

	-- Bloodful node (T. Magdalene's tree)
	if PST:getTreeSnapshotMod("bloodful", false) then
		local tmpModList = { allstatsPerc = 0 }
		if PST:getTreeSnapshotMod("bloodfulDebuffProc", false) then
			tmpModList.allstatsPerc = tmpModList.allstatsPerc - 5
			tmpModList.bloodfulDebuffProc = false
		end
		tmpMod = PST:getTreeSnapshotMod("bloodfulBuff", false)
		if tmpMod > 0 then
			tmpModList.allstatsPerc = tmpModList.allstatsPerc - tmpMod
			tmpModList.bloodfulBuff = { value = 0, set = true }
		end
		if tmpModList.allstatsPerc ~= 0 then
			PST:addModifiers(tmpModList, true)
		end
	end

	-- Mod: chance for Bob's Head to spawn blue flies on hit (reset)
	if PST:getTreeSnapshotMod("bobHeadFliesSpawned", 0) > 0 then
		PST:addModifiers({ bobHeadFliesSpawned = { value = 0, set = true } }, true)
	end

	-- Mod: chance to trigger Brown Nugget item's effect when using Hold (reset)
	if PST:getTreeSnapshotMod("holdBrownNuggetProcs", 0) > 0 then
		PST:addModifiers({ holdBrownNuggetProcs = { value = 0, set = true } }, true)
	end

	-- Mod: chance for poops found in rooms to be replaced with special variants (reset)
	if PST:getTreeSnapshotMod("specialPoopFindReplaced", 0) > 0 then
		PST:addModifiers({ specialPoopFindReplaced = { value = 0, set = true } }, true)
	end

	-- Curseborne node (T. Azazel's tree)
	if PST:getTreeSnapshotMod("curseborne", false) and room:GetAliveEnemiesCount() > 0 then
		local enemyList = {}
		local playerTears = 30 / (player.MaxFireDelay + 1)
		local procs = math.max(1, math.floor(playerTears / 0.8))
		for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() then
				table.insert(enemyList, tmpNPC)
			end
		end
		if #enemyList > 0 then
			for _=1,math.min(#enemyList, procs) do
				local randEnemy = enemyList[math.random(#enemyList)]
				if randEnemy then
					randEnemy:AddBrimstoneMark(EntityRef(player), 600)
					for i, tmpNPC in ipairs(enemyList) do
						if tmpNPC.InitSeed == randEnemy.InitSeed then
							table.remove(enemyList, i)
							break
						end
					end
				end
			end
		end
	end

	-- Gilded Regrowth node (T. Azazel's tree)
	tmpMod = PST:getTreeSnapshotMod("gildedRegrowthKills", false)
	if tmpMod > 0 then
		if tmpMod >= 5 and not player:HasCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT) then
			player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT))
		end
		PST:addModifiers({ gildedRegrowthKills = { value = 0, set = true } }, true)
	end

	-- Reset mob room hit
	if PST:getTreeSnapshotMod("roomGotHitByMob", false) then
		PST:addModifiers({ roomGotHitByMob = false }, true)
	end

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
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
		player:AddCacheFlags(PST.allstatsCache, true)
	end

	-- Mod: chance to unlock boss challenge rooms regardless of hearts
	if level:GetDimension() ~= Dimension.MIRROR and ((PST:getTreeSnapshotMod("bossChallengeUnlockProc", false) and level:HasBossChallenge())
	or PST:SC_getSnapshotMod("challengerStarpiece", false)) then
		for i=0,7 do
			local tmpDoor = room:GetDoor(i)
			if tmpDoor and tmpDoor.TargetRoomType == RoomType.ROOM_CHALLENGE then
				tmpDoor:TryUnlock(player, true)
			end
		end
	end

	-- Mod: chance to turn adjacent curse room spiked door into a regular one
	if PST:getTreeSnapshotMod("curseRoomSpikesOutProc", false) then
		for i=0,7 do
			local tmpDoor = room:GetDoor(i)
			if tmpDoor then
				if room:GetType() == RoomType.ROOM_CURSE then
					tmpDoor:SetRoomTypes(RoomType.ROOM_DEFAULT, tmpDoor.TargetRoomType)
				elseif tmpDoor.TargetRoomType == RoomType.ROOM_CURSE then
					tmpDoor:SetRoomTypes(room:GetType(), RoomType.ROOM_DEFAULT)
				end
			end
		end
	end

	-- Alacritous Purpose node (T. Blue Baby's tree)
	if PST:getTreeSnapshotMod("alacritousFlyProc", false) then
		PST:addModifiers({ alacritousFlyProc = false }, true)
	end

	-- Mod: +% damage per absorbed red clot (reset)
	tmpMod = PST:getTreeSnapshotMod("redClotAbsorbBuff", 0)
	if tmpMod > 0 then
		PST:addModifiers({ damagePerc = -tmpMod, redClotAbsorbBuff = { value = 0, set = true } }, true)
	end

	-- Mod: +% tears per absorbed soul clot (reset)
	tmpMod = PST:getTreeSnapshotMod("soulClotAbsorbBuff", 0)
	if tmpMod > 0 then
		PST:addModifiers({ tearsPerc = -tmpMod, soulClotAbsorbBuff = { value = 0, set = true } }, true)
	end

	-- Tempered node (T. Samson's tree)
	tmpMod = PST:getTreeSnapshotMod("temperedBuff", 0)
	if tmpMod > 0 then
		PST:addModifiers({ tearsPerc = -tmpMod, temperedBuff = { value = 0, set = true } }, true)
	end
	if PST:getTreeSnapshotMod("tempered", false) and room:GetAliveEnemiesCount() > 0 then
		if player.SamsonBerserkCharge > 0 then
			local lostCharge = player.SamsonBerserkCharge * 0.3
			player.SamsonBerserkCharge = math.ceil(player.SamsonBerserkCharge - lostCharge)
			local tearGain = lostCharge / 3000
			PST:addModifiers({ tearsPerc = tearGain, temperedBuff = { value = tearGain, set = true } }, true)
			PST:updateCacheDelayed(CacheFlag.CACHE_COLOR)
		end
	end

	-- First room entry
	if room:IsFirstVisit() then
		-- Starcursed jewel in planetariums
		if room:GetType() == RoomType.ROOM_PLANETARIUM and 100 * math.random() < PST.SCDropRates.planetarium().regular then
			local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
			PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.planetarium().ancient)
		end

		-- Starcursed jewel in curse rooms
		if room:GetType() == RoomType.ROOM_CURSE and 100 * math.random() < PST.SCDropRates.curseRoom(level:GetStage()).regular then
			local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
			PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.curseRoom(level:GetStage()).ancient)
		end

		-- Ancient starcursed jewel: Umbra
		if PST:SC_getSnapshotMod("umbra", false) and (level:GetCurses() & LevelCurse.CURSE_OF_DARKNESS) > 0 and
		not player:HasCollectible(CollectibleType.COLLECTIBLE_NIGHT_LIGHT) then
			if PST:getTreeSnapshotMod("SC_umbraStatsDown", 0) < 20 then
				PST:addModifiers({ allstatsPerc = -2, SC_umbraStatsDown = 2 }, true)
			end
		end

		-- Ancient starcursed jewel: Challenger Starpiece
		if PST:SC_getSnapshotMod("challengerStarpiece", false) and room:GetType() == RoomType.ROOM_CHALLENGE then
			-- Spawn a key if challenge room has no regular chests, and has locked chests, or a bomb if it has stone chests
			local chestSetup = {
				locked = false,
				regular = false,
				bomb = false
			}
			for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
				if tmpEntity.Type == EntityType.ENTITY_PICKUP then
					if PST:arrHasValue(PST.regularChests, tmpEntity.Variant) then
						chestSetup.regular = true
						break
					elseif PST:arrHasValue(PST.lockedChests, tmpEntity.Variant) then
						chestSetup.locked = true
					elseif tmpEntity.Variant == PickupVariant.PICKUP_BOMBCHEST then
						chestSetup.bomb = true
					end
				end
			end
			if not chestSetup.regular then
				local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
				if chestSetup.locked then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, tmpPos, Vector.Zero, nil, KeySubType.KEY_NORMAL, Random() + 1)
				elseif chestSetup.bomb then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, tmpPos, Vector.Zero, nil, BombSubType.BOMB_NORMAL, Random() + 1)
				end
			end
		end

		-- Ancient starcursed jewel: Cursed Starpiece
		if PST:SC_getSnapshotMod("cursedStarpiece", false) and not PST:isFirstOrigStage() and room:GetType() == RoomType.ROOM_TREASURE then
			local firstItem = true
			for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
				local tmpItem = tmpEntity:ToPickup()
				if tmpItem and (tmpItem.Variant == PickupVariant.PICKUP_COLLECTIBLE or (PST:SC_getSnapshotMod("cursedStarpiece", false) and tmpItem.Variant == PickupVariant.PICKUP_TRINKET))
				and not PST:arrHasValue(PST.progressionItems, tmpItem.SubType) then
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

		-- Ancient starcursed jewel: Crimson Warpstone
		if PST:SC_getSnapshotMod("crimsonWarpstone", false) then
			if room:GetAliveEnemiesCount() > 0 then
				local tmpBonus = (level:GetStage() - 1) * 1.7
				if (level:GetCurrentRoomDesc().Flags & (1 << 10)) > 0 then
					tmpBonus = -15
				end
				PST:addModifiers({ SC_crimsonWarpKeyDrop = { value = 35 + tmpBonus, set = true } }, true)
			end

			if room:GetType() == RoomType.ROOM_ULTRASECRET then
				local tmpDebuff = PST:getTreeSnapshotMod("SC_crimsonWarpDebuff", 0)
				if tmpDebuff > 0 then
					PST:addModifiers({ allstatsPerc = tmpDebuff / 2, SC_crimsonWarpDebuff = -tmpDebuff / 2 }, true)
				end
			elseif (level:GetCurrentRoomDesc().Flags & (1 << 10)) > 0 then
				local tmpDebuff = PST:getTreeSnapshotMod("SC_crimsonWarpDebuff", 0)
				if tmpDebuff > 0 then
					PST:addModifiers({ allstatsPerc = 2.5, SC_crimsonWarpDebuff = -2.5 }, true)
				end
			end
		end

		-- Mod: chance to reroll active item pedestals into passive items, if you're holding an active item
		tmpMod = PST:getTreeSnapshotMod("activeItemReroll", 0)
		if tmpMod > 0 and PST:getTreeSnapshotMod("activeItemRerolled", 0) < 2 and 100 * math.random() < tmpMod and player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) > 0 then
			local itemPool = Game():GetItemPool()
			local rolledItems = {}
			for _, tmpEntity in ipairs(PST_FetchRoomEntities()) do
				local tmpPickup = tmpEntity:ToPickup()
				if tmpPickup and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, tmpEntity.SubType) then
					if Isaac.GetItemConfig():GetCollectible(tmpEntity.SubType).Type == ItemType.ITEM_ACTIVE then
						local addedItem = false
						local failSafe = 0
						while not addedItem and failSafe < 100 do
							local newItem = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), Random() + 1))
							local itemConfig = Isaac.GetItemConfig():GetCollectible(newItem)
							if not PST:arrHasValue(rolledItems, newItem) and itemConfig and itemConfig.Type ~= ItemType.ITEM_ACTIVE then
								tmpPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, true)
								PST:addModifiers({ activeItemRerolled = 1 }, true)

								table.insert(rolledItems, newItem)
								addedItem = true
							end
							failSafe = failSafe + 1
						end
					end
				end
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
				tmpAdd = 0.15
			elseif randomStat == "shotSpeed" then
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