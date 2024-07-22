local sfx = SFXManager()

-- On update
local clearRoomProc = false
function PST:onUpdate()
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer()

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
	if PST:cosmicRCharPicked(PlayerType.PLAYER_EVE) then
		-- Eve, -8% all stats if you have 1 remaining red heart or less
		if not cosmicRCache.eveActive and player:GetHearts() <= 2 then
			PST:addModifiers({ allstatsPerc = -8 }, true)
			cosmicRCache.eveActive = true
		elseif cosmicRCache.eveActive and player:GetHearts() > 2 then
			PST:addModifiers({ allstatsPerc = 8 }, true)
			cosmicRCache.eveActive = false
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST) then
		-- The Lost, limit max red hearts to 2
		local plHearts = player:GetMaxHearts()
		if plHearts > 4 then
			player:AddMaxHearts(4 - plHearts)
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
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
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
		-- Tainted Lazarus, update current health bank
		local currentBank = cosmicRCache.TLazarusBank1
		if not cosmicRCache.TLazarusBank1.active then
			currentBank = cosmicRCache.TLazarusBank2
		end
		currentBank.red = player:GetHearts()
		currentBank.max = player:GetMaxHearts()
		currentBank.soul = player:GetSoulHearts()
		currentBank.black = player:GetBlackHearts()
		currentBank.bone = player:GetBoneHearts()
		currentBank.rotten = player:GetRottenHearts()
		currentBank.broken = player:GetBrokenHearts()
		currentBank.eternal = player:GetEternalHearts()
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
		-- Tainted Lost, limit max hearts of each type to 1
		local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
		if not isKeeper then
			if player:GetMaxHearts() > 2 then
				player:AddMaxHearts(2 - player:GetMaxHearts())
			end
			if player:GetSoulHearts() > 2 then
				player:AddSoulHearts(2 - player:GetSoulHearts())
			end
			if player:GetBoneHearts() > 1 then
				player:AddBoneHearts(1 - player:GetBoneHearts())
			end
			if player:GetBrokenHearts() > 2 then
				player:AddBrokenHearts(2 - player:GetBrokenHearts())
			end
			if player:GetRottenHearts() > 2 then
				player:AddRottenHearts(2 - player:GetRottenHearts())
			end
		end
	end

	-- On room clear
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

		-- Cosmic Realignment node
		local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
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
	elseif not room:IsClear() then
		clearRoomProc = false
	end
end