function PST:getStaticEntityID(entity)
    local stage = Game():GetLevel():GetStage()
    local roomID = Game():GetLevel():GetCurrentRoomIndex()
    if entity.GetGridIndex then
        return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(entity:GetGridIndex())
    end
    return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(math.floor(entity.Position.X / 40)) .. "." .. tostring(math.floor(entity.Position.Y / 40))
end

function PST:initStaticEntity(entity)
    local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", nil)
    if staticEntCache then
        local entityID = PST:getStaticEntityID(entity)
        if not staticEntCache[entityID] then
            staticEntCache[entityID] = { State = -1 }
        end
        return staticEntCache[entityID]
    end
    return nil
end

function PST:gridEntityPoopUpdate(entityParam)
    local entity = PST:initStaticEntity(entityParam)
    if entity then
        if entity.State < entityParam.State then
            entity.State = entityParam.State
            -- Poop destroyed
            if entity.State >= 1000 then
                -- Mod: +xp when destroying poop
                local tmpMod = PST:getTreeSnapshotMod("poopXP", 0)
                if tmpMod > 0 then
                    PST:addTempXP(tmpMod, true)
                end
            end
        end
    end
end

function PST:gridEntityRockUpdate(entityParam)
    -- Tinted rocks
    if entityParam.Desc.Type == GridEntityType.GRID_ROCKT then
        local entity = PST:initStaticEntity(entityParam)
        if entity then
            if entity.State ~= entityParam.State then
                entity.State = entityParam.State
                -- Tinted rock destroyed
                if entity.State >= 2 then
                    -- Mod: +xp when destroying tinted rocks
                    local tmpMod = PST:getTreeSnapshotMod("tintedRockXP", 0)
                    if tmpMod ~= 0 then
                        PST:addTempXP(tmpMod, true)
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
    local entity = PST:initStaticEntity(entityParam)
    if entity then
        if entity.State ~= entityParam.HitPoints then
            -- Fireplace destroyed
            if entity.State > 1 and entityParam.HitPoints <= 1 then
                -- Mod: +xp when destroying a fireplace
                local tmpBonus = PST:getTreeSnapshotMod("fireXP", 0)
                if tmpBonus ~= 0 then
                    PST:addTempXP(tmpBonus, true)
                end
            end
            entity.State = entityParam.HitPoints
        end
    end
end