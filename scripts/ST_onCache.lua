-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function PST:onCache(player, cacheFlag)
    local allstats = PST:getTreeSnapshotMod("allstats", 0)
    local allstatsPerc = PST:getTreeSnapshotMod("allstatsPerc", 0)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local tmpMod = PST:getTreeSnapshotMod("damage", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100 + PST:getTreeSnapshotMod("damagePerc", 0) / 100
        player.Damage = (player.Damage + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tmpMod = PST:getTreeSnapshotMod("tears", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.FireDelay = (player.FireDelay + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        local tmpMod = PST:getTreeSnapshotMod("luck", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.Luck = (player.Luck + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        local tmpMod = PST:getTreeSnapshotMod("range", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100 + PST:getTreeSnapshotMod("rangePerc", 0) / 100
        player.TearRange = (player.TearRange + tmpMod * 40) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        local tmpMod = PST:getTreeSnapshotMod("shotSpeed", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.ShotSpeed = (player.ShotSpeed + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        local tmpMod = PST:getTreeSnapshotMod("speed", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        local baseSpeed = player.MoveSpeed

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE) then
            -- Magdalene, set base movement speed to 0.85
            baseSpeed = 0.85
        end
        player.MoveSpeed = (baseSpeed + tmpMod) * tmpMult
    end
end