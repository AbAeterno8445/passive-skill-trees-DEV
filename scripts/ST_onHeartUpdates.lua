-- Tracks player hearts: {main player, twin player}
local heartTracker = {
	red = {0, 0},
	redMax = {0, 0},
	black = {0, 0},
	soul = {0, 0},
	bone = {0, 0},
    broken = {0, 0},
    rotten = {0, 0},
    eternal = {0, 0}
}

function PST:resetHeartUpdater()
    for i=1,2 do
        local player = PST:getPlayer()
        if i == 2 then
            player = player:GetOtherTwin()
        end
        if not player then break end

        heartTracker.red[i] = player:GetHearts()
        heartTracker.redMax[i] = player:GetMaxHearts()
        heartTracker.soul[i] = player:GetSoulHearts()
        heartTracker.black[i] = player:GetBlackHearts()
        heartTracker.bone[i] = player:GetBoneHearts()
        heartTracker.broken[i] = player:GetBrokenHearts()
        heartTracker.rotten[i] = player:GetRottenHearts()
        heartTracker.eternal[i] = player:GetEternalHearts()
    end
end

function PST:onHeartUpdate(force)
    local player = PST:getPlayer()
    local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
    local heartUpdated = false

    for i=1,2 do
        if i == 2 then
            player = player:GetOtherTwin()
        end
        if not player then break end
        local tmpTwin = player:GetOtherTwin()
        local tmpTwinID = (i % 2) + 1

        -- Max red hearts quantity updates
        if force or player:GetMaxHearts() ~= heartTracker.redMax[i] then
            -- Heart Link (Jacob & Esau's tree)
            if player:GetMaxHearts() > heartTracker.redMax[i] then
                local tmpAmount = player:GetMaxHearts() - heartTracker.redMax[i]
                if PST:getTreeSnapshotMod("heartLink", false) and tmpTwin and tmpAmount > 0 then
                    tmpTwin:AddMaxHearts(tmpAmount)
                end
            end

            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST) then
                -- The Lost, limit max red hearts to 2
                if player:GetMaxHearts() > 4 then
                    player:AddMaxHearts(4 - player:GetMaxHearts())
                end
                if tmpTwin and tmpTwin:GetMaxHearts() > 4 then
                    tmpTwin:AddMaxHearts(4 - tmpTwin:GetMaxHearts())
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, limit max hearts of each type to 1
                if not isKeeper then
                    if player:GetMaxHearts() > 2 then
                        player:AddMaxHearts(2 - player:GetMaxHearts())
                    end
                    if tmpTwin and tmpTwin:GetMaxHearts() > 2 then
                        tmpTwin:AddMaxHearts(2 - tmpTwin:GetMaxHearts())
                    end
                end
            end
            heartTracker.redMax[i] = player:GetMaxHearts()
            -- Update twin tracker - prevents extra updates from Heart Link (Jacob & Esau)
            if tmpTwin and heartTracker.redMax[tmpTwinID] ~= tmpTwin:GetMaxHearts() then
                heartTracker.redMax[tmpTwinID] = tmpTwin:GetMaxHearts()
            end
            heartUpdated = true
        end

        -- Remaining red hearts quantity updates
        if force or player:GetHearts() ~= heartTracker.red[i] then
            local tmpFlags = 0

            -- Mod: all stats while you have at least 1 red heart container and are at full health
            local tmpTreeMod = PST:getTreeSnapshotMod("allstatsFullRed", 0)
            if tmpTreeMod ~= 0 then
                if player:GetMaxHearts() > 1 and player:HasFullHearts() and not PST:getTreeSnapshotMod("allstatsFullRedProc", false) then
                    PST:addModifiers({ allstats = tmpTreeMod, allstatsFullRedProc = true }, true)
                elseif PST:getTreeSnapshotMod("allstatsFullRedProc", false) and (player:GetMaxHearts() == 0 or not player:HasFullHearts()) then
                    PST:addModifiers({ allstats = -tmpTreeMod, allstatsFullRedProc = false }, true)
                end
            end

            -- Magdalene's Blessing node (Magdalene's tree)
            if PST:getTreeSnapshotMod("magdaleneBlessing", false) then
                tmpFlags = tmpFlags | CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED
            end

            -- Dark protection node (Eve's tree)
            if PST:getTreeSnapshotMod("darkProtection", false) and not PST:getTreeSnapshotMod("darkProtectionProc", false) and player:GetHearts() <= 2 then
                PST:addModifiers({ darkProtectionProc = true }, true)
                SFXManager():Play(SoundEffect.SOUND_EMPRESS)
                PST:createFloatTextFX("Dark protection!", Vector.Zero, Color(0.8, 0.4, 1, 1), 0.12, 70, true)
                player:AddBlackHearts(2)
            end

            -- Mod: all stats while you have only 1 red heart
            tmpTreeMod = PST:getTreeSnapshotMod("allstatsOneRed", 0)
            if tmpTreeMod ~= 0 then
                if player:GetHearts() == 2 and not PST:getTreeSnapshotMod("allStatsOneRedActive", false) then
                    PST:addModifiers({ allstats = tmpTreeMod, allStatsOneRedActive = true }, true)
                elseif player:GetHearts() ~= 2 and PST:getTreeSnapshotMod("allStatsOneRedActive", false) then
                    PST:addModifiers({ allstats = -tmpTreeMod, allStatsOneRedActive = false }, true)
                end
            end

            -- Hearty node (Samson's tree)
            if PST:getTreeSnapshotMod("hearty", false) then
                tmpFlags = tmpFlags | CacheFlag.CACHE_DAMAGE
            end

            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_EVE) then
                -- Eve, -8% all stats if you have 1 remaining red heart or less
                if not cosmicRCache.eveActive and player:GetHearts() <= 2 then
                    PST:addModifiers({ allstatsPerc = -8 }, true)
                    cosmicRCache.eveActive = true
                elseif cosmicRCache.eveActive and player:GetHearts() > 2 then
                    PST:addModifiers({ allstatsPerc = 8 }, true)
                    cosmicRCache.eveActive = false
                end
            end

            if tmpFlags ~= 0 then
                player:AddCacheFlags(tmpFlags, true)
            end
            heartTracker.red[i] = player:GetHearts()
            heartUpdated = true
        end

        -- Black heart quantity updates
        if force or player:GetBlackHearts() ~= heartTracker.black[i] then
            -- Mod: +luck whenever you lose black hearts
            local lostBlackHeartsLuck = PST:getTreeSnapshotMod("lostBlackHeartsLuck", 0)
            if lostBlackHeartsLuck > 0 and player:GetBlackHearts() < heartTracker.black[i] then
                PST:addModifiers({ luck = lostBlackHeartsLuck }, true)
            end

            -- Song of Darkness node (Siren's tree) [Harmonic modifier]
            if PST:getTreeSnapshotMod("songOfDarkness", false) and PST:songNodesAllocated(true) <= 2 then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
            end
            heartTracker.black[i] = player:GetBlackHearts()
            heartUpdated = true
        end

        -- Soul heart quantity updates
        if force or player:GetSoulHearts() ~= heartTracker.soul[i] then
            -- Slipping Essence node (Blue Baby's tree)
            if PST:getTreeSnapshotMod("slippingEssence", false) then
                local slippingEssenceLost = PST:getTreeSnapshotMod("slippingEssenceLost", 0)
                if player:GetSoulHearts() < heartTracker.soul[i] and 100 * math.random() < 100 / (2 ^ slippingEssenceLost) then
                    PST:addModifiers({ slippingEssenceLost = 1, luck = -0.1 }, true)
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, player.Position, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
                end
            end

            -- The Forgotten mod updates
            if PST:getTreeSnapshotMod("forgottenSoulDamage", 0) ~= 0 or PST:getTreeSnapshotMod("forgottenSoulTears", 0) ~= 0 then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
            end

            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, limit max hearts of each type to 1
                if not isKeeper then
                    if player:GetSoulHearts() > 2 then
                        player:AddSoulHearts(2 - player:GetSoulHearts())
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
                -- Tainted Forgotten, cannot have more than 1 soul/black heart
                if not isKeeper then
                    if player:GetSoulHearts() > 2 then
                        player:AddSoulHearts(2 - player:GetSoulHearts())
                    end

                    -- -15% range, shot speed and luck when no soul hearts
                    if not cosmicRCache.TForgottenTracker.soul and player:GetSoulHearts() == 0 then
                        PST:addModifiers({ rangePerc = -15, shotSpeedPerc = -15, luckPerc = -15 }, true)
                        cosmicRCache.TForgottenTracker.soul = true
                    elseif cosmicRCache.TForgottenTracker.soul and player:GetSoulHearts() > 0 then
                        PST:addModifiers({ rangePerc = 15, shotSpeedPerc = 15, luckPerc = 15 }, true)
                        cosmicRCache.TForgottenTracker.soul = false
                    end
                end
            end
            heartTracker.soul[i] = player:GetSoulHearts()
            heartUpdated = true
        end

        -- Bone heart quantity updates
        if force or player:GetBoneHearts() ~= heartTracker.bone[i] then
            -- Soulful node (Therefore Forgotten's tree)
            if PST:getTreeSnapshotMod("soulful", false) then
                if player:GetBoneHearts() < heartTracker.bone[i] and player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL then
                    for _=1, heartTracker.bone[i] - player:GetBoneHearts() do
                        local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
                        PST:addModifiers({ luck = -0.25 }, true)
                    end
                end
            end

            -- The Forgotten mod updates
            if PST:getTreeSnapshotMod("theSoulBoneDamage", 0) ~= 0 or PST:getTreeSnapshotMod("theSoulBoneTears", 0) ~= 0 then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
            end

            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, limit max hearts of each type to 1
                if not isKeeper then
                    if player:GetBoneHearts() > 1 then
                        player:AddBoneHearts(1 - player:GetBoneHearts())
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
                -- Tainted Forgotten, cannot have more than 1 bone heart
                if not isKeeper then
                    if player:GetBoneHearts() > 1 then
                        player:AddBoneHearts(1 - player:GetBoneHearts())
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
            heartTracker.bone[i] = player:GetBoneHearts()
            heartUpdated = true
        end

        -- Broken heart quantity updates
        if force or player:GetBrokenHearts() ~= heartTracker.broken[i] then
            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, limit max hearts of each type to 1
                if not isKeeper then
                    if player:GetBrokenHearts() > 2 then
                        player:AddBrokenHearts(2 - player:GetBrokenHearts())
                    end
                end
            end
            heartTracker.broken[i] = player:GetBrokenHearts()
            heartUpdated = true
        end

        -- Rotten heart quantity updates
        if force or player:GetRottenHearts() ~= heartTracker.rotten[i] then
            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, limit max hearts of each type to 1
                if not isKeeper then
                    if player:GetRottenHearts() > 2 then
                        player:AddRottenHearts(2 - player:GetRottenHearts())
                    end
                end
            end
            heartTracker.rotten[i] = player:GetRottenHearts()
            heartUpdated = true
        end

        -- Eternal heart quantity updates
        if force or player:GetEternalHearts() ~= heartTracker.eternal[i] then
            heartTracker.eternal[i] = player:GetEternalHearts()
            heartUpdated = true
        end
    end

    -- Cosmic Realignment node - Tainted Lazarus bank
    if heartUpdated and PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
        local taintedLazBank = cosmicRCache.TLazarusBank1
        if not cosmicRCache.TLazarusBank1.active then
            taintedLazBank = cosmicRCache.TLazarusBank2
        end
        taintedLazBank.red = player:GetHearts()
        taintedLazBank.max = player:GetMaxHearts()
        taintedLazBank.soul = player:GetSoulHearts()
        taintedLazBank.black = player:GetBlackHearts()
        taintedLazBank.bone = player:GetBoneHearts()
        taintedLazBank.rotten = player:GetRottenHearts()
        taintedLazBank.broken = player:GetBrokenHearts()
        taintedLazBank.eternal = player:GetEternalHearts()
    end
end