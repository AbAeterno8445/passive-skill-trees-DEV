-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function SkillTrees:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local dmgMod = SkillTrees:getTreeSnapshotMod("damage", 0) + SkillTrees:getTreeSnapshotMod("allstats", 0)
        player.Damage = player.Damage + dmgMod

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        local firedelayMod = SkillTrees:getTreeSnapshotMod("allstats", 0)
        player.FireDelay = player.FireDelay + firedelayMod

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        local luckMod = SkillTrees:getTreeSnapshotMod("allstats", 0)
        player.Luck = player.Luck + luckMod

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        local rangeMod = SkillTrees:getTreeSnapshotMod("allstats", 0)
        player.TearRange = player.TearRange + rangeMod

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        local shotspeedMod = SkillTrees:getTreeSnapshotMod("allstats", 0)
        player.ShotSpeed = player.ShotSpeed + shotspeedMod

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        local speedMod = SkillTrees:getTreeSnapshotMod("allstats", 0)
        player.MoveSpeed = player.MoveSpeed + speedMod
    end
end