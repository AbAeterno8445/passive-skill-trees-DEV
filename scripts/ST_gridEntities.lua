function PST:getStaticEntityID(entity)
    local stage = Game():GetLevel():GetStage()
    local roomID = Game():GetLevel():GetCurrentRoomDesc().SafeGridIndex
    if entity.GetGridIndex then
        return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(entity:GetGridIndex())
    elseif entity.SpawnGridIndex then
        return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(entity.SpawnGridIndex)
    end
    local tmpGridIndex = Game():GetRoom():GetGridIndex(entity.Position)
    return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(tmpGridIndex)
end

function PST:initStaticEntity(entity)
    local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", nil)
    if staticEntCache then
        local entityID = PST:getStaticEntityID(entity)
        if not staticEntCache[entityID] then
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
            staticEntCache[entityID] = entityParam.State
            -- Poop destroyed
            if staticEntCache[entityID] >= 1000 then
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
                staticEntCache[entityID] = entityParam.State
                -- Tinted rock destroyed
                if staticEntCache[entityID] >= 2 then
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