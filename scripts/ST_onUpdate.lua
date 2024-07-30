local sfx = SFXManager()

local blackHeartTracker = 0
local soulHeartTracker = 0

-- On update
local clearRoomProc = false
function PST:onUpdate()
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer()

	-- First heart-related functions update
	if not PST.modData.firstHeartUpdate then
		PST:onAddHearts(player, 0, 0)
		PST.modData.firstHeartUpdate = true
	end

	-- First update when entering floor
	if PST.floorFirstUpdate then
		PST.floorFirstUpdate = false
		blackHeartTracker = 0
		soulHeartTracker = 0

		local level = Game():GetLevel()
		-- Mod: chance to reveal the arcade room's location if it is present
		if 100 * math.random() < PST:getTreeSnapshotMod("arcadeReveal", 0) then
			local arcadeIdx = level:QueryRoomTypeIndex(RoomType.ROOM_ARCADE, false, RNG())
			local arcadeRoom = level:GetRoomByIdx(arcadeIdx)
			if arcadeRoom then
				arcadeRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Mod: chance to reveal the shop room's location if it is present
		if 100 * math.random() < PST:getTreeSnapshotMod("shopReveal", 0) then
			local shopIdx = level:QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG())
			local shopRoom = level:GetRoomByIdx(shopIdx)
			if shopRoom then
				shopRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- After first floor
		if level:GetStage() > 1 then
			-- Mod: chance to reveal map
			if 100 * math.random() < PST:getTreeSnapshotMod("mapChance", 0) then
				level:ShowMap()
				PST:createFloatTextFX("Map revealed!", Vector.Zero, Color(1, 1, 1, 1), 0.12, 70, true)
			end

			-- Mod: chance to spawn a Blood Donation Machine at the start of a floor
			if 100 * math.random() < PST:getTreeSnapshotMod("bloodMachineSpawn", 0) then
				local tmpPos = room:GetCenterPos()
				tmpPos.Y = tmpPos.Y - 40
				Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.BLOOD_DONATION_MACHINE, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND, 0.7)
			end

			-- Mod: chance to spawn a random trinket at the start of a floor
			if 100 * math.random() < PST:getTreeSnapshotMod("trinketSpawn", 0) then
				local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 40)
       			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, Game():GetItemPool():GetTrinket(), Random() + 1)
			end
		end
	end

	-- Fickle Fortune node (Cain's tree)
	if PST:getTreeSnapshotMod("fickleFortune", false) then
		-- +7% luck while holding a trinket
		local hasTrinket = player:GetTrinket(0) ~= 0 or player:GetTrinket(1) ~= 0
		if not PST:getTreeSnapshotMod("fickleFortuneActive", false) and hasTrinket then
			PST:addModifiers({ luckPerc = 7, fickleFortuneActive = true }, true)
		elseif PST:getTreeSnapshotMod("fickleFortuneActive", false) and not hasTrinket then
			PST:addModifiers({ luckPerc = -7, fickleFortuneActive = false }, true)
		end
	end

	-- Dark Heart node (Judas' tree)
	if PST:getTreeSnapshotMod("darkHeart", false) then
		-- -6% all stats while you have no black hearts. Book of Belial removes this reduction for the current room
		if not PST:getTreeSnapshotMod("darkHeartActive", false) and not PST:getTreeSnapshotMod("darkHeartBelial", false) and player:GetBlackHearts() == 0 then
			PST:addModifiers({ allstatsPerc = -6, darkHeartActive = true }, true)
		elseif PST:getTreeSnapshotMod("darkHeartActive", false) and (player:GetBlackHearts() > 0 or PST:getTreeSnapshotMod("darkHeartBelial", false)) then
			PST:addModifiers({ allstatsPerc = 6, darkHeartActive = false }, true)
		end
	end

	-- Inner Demon node (Judas' tree)
	if PST:getTreeSnapshotMod("innerDemon", false) then
		-- -15% damage as Dark Judas and start with 1 black heart instead
		if not PST:getTreeSnapshotMod("innerDemonActive") and player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
			PST:addModifiers({ damagePerc = -15, innerDemonActive = true }, true)
			player:AddSoulHearts(-2)
		end
	end

	-- Mod: +luck whenever you lose black hearts
	local lostBlackHeartsLuck = PST:getTreeSnapshotMod("lostBlackHeartsLuck", 0)
	if lostBlackHeartsLuck > 0 and player:GetBlackHearts() < blackHeartTracker then
		PST:addModifiers({ luck = lostBlackHeartsLuck }, true)
	end
	blackHeartTracker = player:GetBlackHearts()

	-- Slipping Essence node (Blue Baby's tree)
	local slippingEssenceLost = PST:getTreeSnapshotMod("slippingEssenceLost", 0)
	if player:GetSoulHearts() < soulHeartTracker and 100 * math.random() < 100 / (2 ^ slippingEssenceLost) then
		PST:addModifiers({ slippingEssenceLost = 1, luck = -0.1 }, true)
		Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, player.Position, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
	end
	soulHeartTracker = player:GetSoulHearts()

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
	local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
	if PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
		-- Lilith, -8% all stats if you don't currently have a baby familiar
		local hasBabyFamiliar = false
		for _, familiarType in ipairs(PST.babyFamiliarItems) do
			if player:HasCollectible(familiarType) then
				hasBabyFamiliar = true
				break
			end
		end
		if not cosmicRCache.lilithActive and not hasBabyFamiliar then
			PST:addModifiers({ allstatsPerc = -8 }, true)
			cosmicRCache.lilithActive = true
		elseif cosmicRCache.lilithActive and hasBabyFamiliar then
			PST:addModifiers({ allstatsPerc = 8 }, true)
			cosmicRCache.lilithActive = false
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
		-- The Forgotten, Keeper debuff: -4% all stats per active blue fly, up to -40%
		if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or
		player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
			local debuffVal = math.max(-40, math.min(cosmicRCache.forgottenKeeperDebuff, player:GetNumBlueFlies() * -4))
			if cosmicRCache.forgottenKeeperDebuff ~= debuffVal then
				cosmicRCache.forgottenKeeperDebuff = debuffVal
				player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
			end
		end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC_B) then
        -- Tainted Isaac, -4% all stats per item obtained after the 8th one, up to -40%
		local tmpItemCount = math.max(0, player:GetCollectibleCount() - 8)
		if tmpItemCount ~= cosmicRCache.TIsaacItems then
        	cosmicRCache.TIsaacItems = tmpItemCount
			player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
		end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
		-- Tainted Cain, -2 luck if not holding Bag of Crafting
		if not cosmicRCache.TCainActive and not player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
			PST:addModifiers({ luck = -2 }, true)
			cosmicRCache.TCainActive = true
		elseif cosmicRCache.TCainActive and player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
			PST:addModifiers({ luck = 2 }, true)
			cosmicRCache.TCainActive = false
		end

		-- Set bag full status to detect crafting
		cosmicRCache.TCainBag = player:GetBagOfCraftingSlot(7) ~= 0
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB_B) then
		-- Tainted Jacob, spawn Dark Esau if he's not around
		if room:GetAliveEnemiesCount() > 0 and not PST.specialNodes.TJacobEsauSpawned then
			local spawned = false
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				if tmpEntity.Type == EntityType.ENTITY_DARK_ESAU then
					spawned = true
					break
				end
			end
			if not spawned then
				Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, room:GetCenterPos(), Vector.Zero, nil, 0, Random() + 1)
				PST.specialNodes.TJacobEsauSpawned = true
			end
		end
	end

	-- On room clear
	if room:GetAliveEnemiesCount() == 0 and (not clearRoomProc or PST.modData.xpObtained > 0) then
		PST.modData.spawnKills = 0

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
			-- Thievery node Greed proc (Cain's tree)
			if PST:getTreeSnapshotMod("thieveryGreedProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				Game():Spawn(EntityType.ENTITY_GREED, 0, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND)
				PST:addModifiers({ thieveryGreedProc = false }, true)
			else
				-- Respec chance
				local respecChance = PST:getTreeSnapshotMod("respecChance", 15)
				if not PST:getTreeSnapshotMod("relearning", false) then
					local tmpRespecs = 0
					while (respecChance > 0) do
						if 100 * math.random() < respecChance then
							tmpRespecs = tmpRespecs + 1
						end
						respecChance = respecChance - 100
					end
					if tmpRespecs > 0 then
						PST:createFloatTextFX("+" .. tmpRespecs .. " Respec(s)", Vector.Zero, Color(1, 1, 1, 1), 0.12, 90, true)
						sfx:Play(SoundEffect.SOUND_THUMBSUP)
						PST.modData.respecPoints = PST.modData.respecPoints + tmpRespecs
					end
				else
					-- Relearning node, count as completed floor
					PST:addModifiers({ relearningFloors = 1 }, true)
				end
			end
		end

		-- Once-per-clear effects
		if not clearRoomProc and PST.modData.xpObtained > 0 then
			local isBossRoom = room:GetType() == RoomType.ROOM_BOSS

			-- Mod: chance to heal 1/2 red heart when clearing a room
			local tmpChance = PST:getTreeSnapshotMod("healOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if 100 * math.random() < tmpChance then
				player:AddHearts(1)
				if room:GetType() == RoomType.ROOM_BOSS then
					player:AddHearts(1)
				end
			end

			-- Mod: chance to spawn an additional nickel when clearing a room
			tmpChance = PST:getTreeSnapshotMod("nickelOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if 100 * math.random() < tmpChance then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
			end
		end

		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
			-- The Forgotten, reset Keeper debuff
			if isKeeper then
				local debuffVal = math.max(-40, math.min(0, player:GetNumBlueFlies() * -4))
				if cosmicRCache.forgottenKeeperDebuff ~= debuffVal then
					cosmicRCache.forgottenKeeperDebuff = debuffVal
					player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
				end
			end
		elseif PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
			-- Tainted Samson, take up to 1 heart damage if final buff was negative, then reset
			local totalHP = player:GetHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetBrokenHearts() + player:GetBoneHearts()
			if cosmicRCache.TSamsonBuffer < 0 and totalHP - 1 > 0 then
				player:TakeDamage(math.min(2, totalHP - 1), 0, EntityRef(player), 0)
			end
			cosmicRCache.TSamsonBuffer = 0
			player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
		elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
			-- Tainted Lazarus, switch health banks
			if not isKeeper and PST.modData.xpObtained > 0 then
				local newBank = nil
				if cosmicRCache.TLazarusBank1.active then
					newBank = cosmicRCache.TLazarusBank2
					cosmicRCache.TLazarusBank1.active = false
				else
					newBank = cosmicRCache.TLazarusBank1
					cosmicRCache.TLazarusBank1.active = true
				end
				player:AddMaxHearts(-player:GetMaxHearts() + newBank.max)
				player:AddSoulHearts(-player:GetSoulHearts() + newBank.soul)
				---@diagnostic disable-next-line: undefined-field
				player:SetBlackHeart(newBank.black)
				player:AddRottenHearts(-player:GetRottenHearts() + newBank.rotten)
				player:AddBoneHearts(-player:GetBoneHearts() + newBank.bone)
				player:AddBrokenHearts(-player:GetBrokenHearts() + newBank.broken)
				player:AddHearts(-player:GetHearts() + newBank.red)
				player:AddEternalHearts(-player:GetEternalHearts() + newBank.eternal)
			end
		end

		-- Convert temp xp to normal xp
		if PST.modData.xpObtained > 0 then
			PST:addXP(PST.modData.xpObtained, false)
			PST.modData.xpObtained = 0
		end

		-- Save data
		PST:save()
		clearRoomProc = true
	elseif room:GetAliveEnemiesCount() > 0 then
		clearRoomProc = false
	end
end