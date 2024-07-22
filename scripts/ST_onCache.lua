-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function PST:onCache(player, cacheFlag)
    local dynamicMods = {
        damage = 0, luck = 0, speed = 0, tears = 0, shotSpeed = 0, range = 0,
        damagePerc = 0, luckPerc = 0, speedPerc = 0, tearsPerc = 0, shotSpeedPerc = 0, rangePerc = 0,
        allstatsPerc = 0,
    }

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
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
        -- Tainted Samson, all stats buffer (-20% to 10%)
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + math.max(-20, math.min(10, cosmicRCache.TSamsonBuffer))
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN_B) then
        -- Tainted Eden, shuffle stat reduction
        for stat, val in pairs(dynamicMods) do
            if cosmicRCache.TEdenDebuff[stat] ~= nil then
                dynamicMods[stat] = val + cosmicRCache.TEdenDebuff[stat]
            end
        end
    end

    local allstats = PST:getTreeSnapshotMod("allstats", 0)
    local allstatsPerc = PST:getTreeSnapshotMod("allstatsPerc", 0) + dynamicMods.allstatsPerc
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local tmpMod = PST:getTreeSnapshotMod("damage", 0) + dynamicMods.damage + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("damagePerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.damagePerc / 100
        player.Damage = (player.Damage + tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tmpMod = PST:getTreeSnapshotMod("tears", 0) + dynamicMods.tears + allstats
        local tmpMult = 1 - allstatsPerc / 100
        tmpMult = tmpMult - PST:getTreeSnapshotMod("tearsPerc", 0) / 100
        tmpMult = tmpMult - dynamicMods.tearsPerc / 100
        player.MaxFireDelay = (player.MaxFireDelay - tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        local tmpMod = PST:getTreeSnapshotMod("luck", 0) + dynamicMods.luck + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.luckPerc / 100
        player.Luck = (player.Luck + tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        local tmpMod = PST:getTreeSnapshotMod("range", 0) + dynamicMods.range + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("rangePerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.rangePerc / 100
        player.TearRange = (player.TearRange + tmpMod * 40) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        local tmpMod = PST:getTreeSnapshotMod("shotSpeed", 0) + dynamicMods.shotSpeed + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.shotSpeedPerc / 100
        player.ShotSpeed = (player.ShotSpeed + tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        local tmpMod = PST:getTreeSnapshotMod("speed", 0) + dynamicMods.speed + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.speedPerc / 100
        local baseSpeed = player.MoveSpeed

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE) then
            -- Magdalene, set base movement speed to 0.85
            baseSpeed = 0.85
        end
        player.MoveSpeed = (baseSpeed + tmpMod) * math.max(0.05, tmpMult)
    end
end