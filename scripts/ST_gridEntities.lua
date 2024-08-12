function PST:getStaticEntityID(entity)
    local stage = Game():GetLevel():GetStage()
    local roomID = Game():GetLevel():GetCurrentRoomDesc().SafeGridIndex
    local tmpIndex = nil
    if entity.GetGridIndex then
        tmpIndex = entity:GetGridIndex()
    elseif entity.SpawnGridIndex and entity.SpawnGridIndex ~= -1 then
        tmpIndex = entity.SpawnGridIndex
    else
        tmpIndex = Game():GetRoom():GetGridIndex(entity.Position)
    end
    if tmpIndex and tmpIndex ~= -1 then
        return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(tmpIndex)
    end
    return nil
end

function PST:initStaticEntity(entity)
    local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", nil)
    if staticEntCache then
        local entityID = PST:getStaticEntityID(entity)
        if entityID and not staticEntCache[entityID] then
            staticEntCache[entityID] = -1
        end
        return entityID
    end
    return nil
end

function PST:gridEntityPoopUpdate(entityParam)
    local entityID = PST:initStaticEntity(entityParam)
    if entityID then
        local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", nil)
        if staticEntCache[entityID] < entityParam.State then
            local noXP = staticEntCache[entityID] == -1
            staticEntCache[entityID] = entityParam.State
            -- Poop destroyed
            if staticEntCache[entityID] >= 1000 and not noXP then
                -- Mod: +xp when destroying poop
                local tmpMod = PST:getTreeSnapshotMod("poopXP", 0)
                if tmpMod > 0 then
                    PST:addTempXP(tmpMod, true, true)
                end
            end
        end
    end
end

function PST:gridEntityRockUpdate(entityParam)
    -- Tinted rocks
    if entityParam.Desc.Type == GridEntityType.GRID_ROCKT then
        local entityID = PST:initStaticEntity(entityParam)
        if entityID then
            local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", nil)
            if staticEntCache[entityID] ~= entityParam.State then
                local noXP = staticEntCache[entityID] == -1
                staticEntCache[entityID] = entityParam.State
                -- Tinted rock destroyed
                if staticEntCache[entityID] >= 2 and not noXP then
                    -- Mod: +xp when destroying tinted rocks
                    local tmpMod = PST:getTreeSnapshotMod("tintedRockXP", 0)
                    if tmpMod ~= 0 then
                        PST:addTempXP(tmpMod, true, true)
                    end

                    -- Mod: +all stats when destroying tinted rocks
                    tmpMod = PST:getTreeSnapshotMod("tintedRockAllstats", 0)
                    if tmpMod ~= 0 then
                        PST:addModifiers({ allstats = tmpMod }, true)
                    end
                end
            end
        end
    end
end

function PST:onFireRender(entityParam)
    local entityID = PST:initStaticEntity(entityParam)
    if entityID then
        local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", nil)
        if staticEntCache[entityID] ~= entityParam.HitPoints then
            -- Fireplace destroyed
            if staticEntCache[entityID] > 1 and entityParam.HitPoints <= 1 then
                -- Mod: +xp when destroying a fireplace
                local tmpBonus = PST:getTreeSnapshotMod("fireXP", 0)
                if tmpBonus ~= 0 then
                    PST:addTempXP(tmpBonus, true, true)
                end
            end
            staticEntCache[entityID] = entityParam.HitPoints
        end
    end
end