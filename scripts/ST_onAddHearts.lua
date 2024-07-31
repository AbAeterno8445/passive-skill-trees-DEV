-- Useful for heart-related checks
function PST:onAddHearts(player, amount, healthType, optional)
	-- Mod: all stats while you have at least 1 red heart container and are at full health
	local tmpTreeMod = PST:getTreeSnapshotMod("allstatsFullRed", 0)
    if tmpTreeMod and player:GetMaxHearts() > 1 and player:HasFullHearts() and not PST:getTreeSnapshotMod("allstatsFullRedProc", false) then
        PST:addModifiers({ allstats = tmpTreeMod }, true)
		PST.modData.treeModSnapshot.allstatsFullRedProc = true
	elseif PST:getTreeSnapshotMod("allstatsFullRedProc", false) and (player:GetMaxHearts() == 0 or not player:HasFullHearts()) then
		PST:addModifiers({ allstats = -tmpTreeMod }, true)
		PST.modData.treeModSnapshot.allstatsFullRedProc = false
    end

    -- Magdalene's Blessing node (Magdalene's tree)
    if PST:getTreeSnapshotMod("magdaleneBlessing", false) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
    end

	-- Dark protection node (Eve's tree)
	if PST:getTreeSnapshotMod("darkProtection", false) and not PST:getTreeSnapshotMod("darkProtectionProc", false) and player:GetHearts() <= 2 then
		PST:addModifiers({ darkProtectionProc = true }, true)
		SFXManager():Play(SoundEffect.SOUND_EMPRESS)
		PST:createFloatTextFX("Dark protection!", Vector.Zero, Color(0.8, 0.4, 1, 1), 0.12, 70, true)
		player:AddBlackHearts(2)
	end

	-- Mod: all stats while you have only 1 red heart
	local tmpBonus = PST:getTreeSnapshotMod("allstatsOneRed", 0)
	if tmpBonus > 0 then
		if player:GetHearts() == 2 and not PST:getTreeSnapshotMod("allStatsOneRedActive", false) then
			PST:addModifiers({ allstats = tmpBonus, allStatsOneRedActive = true }, true)
		elseif player:GetHearts() ~= 2 and PST:getTreeSnapshotMod("allStatsOneRedActive", false) then
			PST:addModifiers({ allstats = -tmpBonus, allStatsOneRedActive = false }, true)
		end
	end

	-- Hearty node (Samson's tree)
	if PST:getTreeSnapshotMod("hearty", false) then
		if healthType == HealthType.RED then
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		end
	end

    -- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
	local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
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
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
		-- Tainted Forgotten, cannot have more than 1 soul/black heart or bone hearts
		if not isKeeper then
			if player:GetSoulHearts() > 2 then
				player:AddSoulHearts(2 - player:GetSoulHearts())
			end
			if player:GetBoneHearts() > 1 then
				player:AddBoneHearts(1 - player:GetBoneHearts())
			end

			-- -15% range, shot speed and luck when no soul hearts
			if not cosmicRCache.TForgottenTracker.soul and player:GetSoulHearts() == 0 then
				PST:addModifiers({ rangePerc = -15, shotSpeedPerc = -15, luckPerc = -15 }, true)
				cosmicRCache.TForgottenTracker.soul = true
			elseif cosmicRCache.TForgottenTracker.soul and player:GetSoulHearts() > 0 then
				PST:addModifiers({ rangePerc = 15, shotSpeedPerc = 15, luckPerc = 15 }, true)
				cosmicRCache.TForgottenTracker.soul = false
			end

			-- -15% damage, tears and shot speed when no bone hearts
			if not cosmicRCache.TForgottenTracker.bone and player:GetBoneHearts() == 0 then
				PST:addModifiers({ damagePerc = -15, tearsPerc = -15, shotSpeedPerc = -15 }, true)
				cosmicRCache.TForgottenTracker.bone = true
			elseif cosmicRCache.TForgottenTracker.bone and player:GetBoneHearts() > 0 then
				PST:addModifiers({ damagePerc = 15, tearsPerc = 15, shotSpeedPerc = 15 }, true)
				cosmicRCache.TForgottenTracker.bone = false
			end
		end
	end
end