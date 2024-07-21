-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function PST:onCache(player, cacheFlag)
    local dynamicMods = { allstatsPerc = 0, damagePerc = 0, tearsPerc = 0 }

    -- Cosmic Realignment node
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache")
    if PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
        -- The Forgotten, Keeper debuff
        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or
        player:GetPlayerType() == PlayerType.PLAYER_KEEPERB then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + cosmicRCache.forgottenKeeperDebuff
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB) then
        -- Jacob & Esau, damage and tears debuff
        dynamicMods.damagePerc = dynamicMods.damagePerc - 25 / (2 ^ cosmicRCache.jacobProcs)
        dynamicMods.tearsPerc = dynamicMods.tearsPerc - 25 / (2 ^ cosmicRCache.jacobProcs)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC_B) then
        -- Tainted Isaac, -4% all stats per item obtained after the 8th one, up to 40%
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + math.max(-40, cosmicRCache.TIsaacItems * -4)
    end

    local allstats = PST:getTreeSnapshotMod("allstats", 0)
    local allstatsPerc = PST:getTreeSnapshotMod("allstatsPerc", 0) + dynamicMods.allstatsPerc
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local tmpMod = PST:getTreeSnapshotMod("damage", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("damagePerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.damagePerc / 100
        tmpMult = math.max(0.05, tmpMult)
        player.Damage = (player.Damage + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tmpMod = PST:getTreeSnapshotMod("tears", 0) + allstats
        local tmpMult = 1 - allstatsPerc / 100 - dynamicMods.tearsPerc / 100
        tmpMult = math.max(0.05, tmpMult)
        player.MaxFireDelay = (player.MaxFireDelay - tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        local tmpMod = PST:getTreeSnapshotMod("luck", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = math.max(0.05, tmpMult)
        player.Luck = (player.Luck + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        local tmpMod = PST:getTreeSnapshotMod("range", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100 + PST:getTreeSnapshotMod("rangePerc", 0) / 100
        tmpMult = math.max(0.05, tmpMult)
        player.TearRange = (player.TearRange + tmpMod * 40) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        local tmpMod = PST:getTreeSnapshotMod("shotSpeed", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = math.max(0.05, tmpMult)
        player.ShotSpeed = (player.ShotSpeed + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        local tmpMod = PST:getTreeSnapshotMod("speed", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = math.max(0.05, tmpMult)
        local baseSpeed = player.MoveSpeed

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE) then
            -- Magdalene, set base movement speed to 0.85
            baseSpeed = 0.85
        end
        player.MoveSpeed = (baseSpeed + tmpMod) * tmpMult
    end
end