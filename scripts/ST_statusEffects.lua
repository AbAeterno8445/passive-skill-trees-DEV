---@param statusID StatusEffect
---@param entity Entity
---@param source EntityRef
---@param duration integer
function PST:postStatusEffectApply(statusID, entity, source, duration)
    -- Mod: bosses receive % more damage for each different status effect they've received
    if PST:getTreeSnapshotMod("bossDiffStatusDmg", 0) > 0 and entity and entity:IsBoss() then
        local bossData = PST:getEntData(entity)
        if not bossData.bossDiffStatusDmgList then
            bossData.bossDiffStatusDmgList = {}
        end
        if not PST:arrHasValue(bossData.bossDiffStatusDmgList, statusID) then
            table.insert(bossData.bossDiffStatusDmgList, statusID)
        end
    end
end