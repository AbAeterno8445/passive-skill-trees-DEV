-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function SkillTrees:onCache(player, cacheFlag)
    local allstats = SkillTrees:getTreeSnapshotMod("allstats", 0)
    local allstatsPerc = SkillTrees:getTreeSnapshotMod("allstatsPerc", 0)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local tmpMod = SkillTrees:getTreeSnapshotMod("damage", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.Damage = (player.Damage + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local tmpMod = SkillTrees:getTreeSnapshotMod("tears", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.FireDelay = (player.FireDelay + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        local tmpMod = SkillTrees:getTreeSnapshotMod("luck", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.Luck = (player.Luck + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        local tmpMod = SkillTrees:getTreeSnapshotMod("range", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.TearRange = (player.TearRange + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        local tmpMod = SkillTrees:getTreeSnapshotMod("shotSpeed", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.ShotSpeed = (player.ShotSpeed + tmpMod) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        local tmpMod = SkillTrees:getTreeSnapshotMod("speed", 0) + allstats
        local tmpMult = 1 + allstatsPerc / 100
        player.MoveSpeed = (player.MoveSpeed + tmpMod) * tmpMult
    end
end