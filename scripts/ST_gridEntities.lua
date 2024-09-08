function PST:getStaticEntityID(entity)
    local level = PST:getLevel()
    local stage = level:GetStage()
    local roomID = level:GetCurrentRoomDesc().SafeGridIndex
    local tmpIndex = nil
    if entity.InitSeed then
        tmpIndex = entity.InitSeed
    elseif entity.GetGridIndex then
        tmpIndex = entity:GetGridIndex()
    elseif entity.SpawnGridIndex and entity.SpawnGridIndex ~= -1 then
        tmpIndex = entity.SpawnGridIndex
    else
        tmpIndex = PST:getRoom():GetGridIndex(entity.Position)
    end
    if tmpIndex and tmpIndex ~= -1 then
        return tostring(stage) .. "." .. tostring(roomID) .. "." .. tostring(tmpIndex)
    end
    return nil
end

function PST:initStaticEntity(entity)
    local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", {})
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
    local convertedPoop = false
    if PST:getRoom():IsFirstVisit() and PST:getRoom():GetFrameCount() == 0 then
        -- Mod: chance to replace poop with special variants
        local tmpMod = PST:getTreeSnapshotMod("specialPoopFind", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("specialPoopFindReplaced", 0) < 4 and 100 * math.random() < tmpMod then
            local room = PST:getRoom()
            local gridIdx = entityParam:GetGridIndex()
            room:RemoveGridEntityImmediate(gridIdx, 0, false)
            if math.random() < 0.4 then
                room:SpawnGridEntity(gridIdx, GridEntityType.GRID_POOP, GridPoopVariant.BLACK)
            elseif math.random() < 0.3 then
                room:SpawnGridEntity(gridIdx, GridEntityType.GRID_POOP, GridPoopVariant.CHARMING)
            elseif math.random() < 0.3 then
                room:SpawnGridEntity(gridIdx, GridEntityType.GRID_POOP, GridPoopVariant.GOLDEN)
            elseif math.random() < 0.15 then
                room:SpawnGridEntity(gridIdx, GridEntityType.GRID_POOP, GridPoopVariant.HOLY)
            else
                room:SpawnGridEntity(gridIdx, GridEntityType.GRID_POOP, GridPoopVariant.RAINBOW)
            end
            PST:addModifiers({ specialPoopFindReplaced = 1 }, true)
            convertedPoop = true
        end
    end

    if not convertedPoop then
        local entityID = PST:initStaticEntity(entityParam)
        if entityID then
            local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", {})
            if staticEntCache[entityID] < entityParam.State then
                local noXP = staticEntCache[entityID] == -1
                staticEntCache[entityID] = entityParam.State
                -- Poop destroyed
                if staticEntCache[entityID] >= 1000 and not noXP then
                    -- Mod: +xp when destroying poop
                    local tmpMod = PST:getTreeSnapshotMod("poopXP", 0)
                    if tmpMod > 0 then
                        -- Reduce poop xp gain if card against humanity was used
                        if PST:getTreeSnapshotMod("cardAgainstHumanityProc", false) then
                            tmpMod = tmpMod / 10
                        end
                        PST:addTempXP(tmpMod, true, true)
                    end

                    -- Alacritous Purpose node (T. Blue Baby's tree)
                    if PST:getTreeSnapshotMod("alacritousPurpose", false) then
                        tmpMod = PST:getTreeSnapshotMod("alacritousTearBuff", 0)
                        if tmpMod < 0.5 then
                            local tmpAdd = math.min(0.04, 0.5 - tmpMod)
                            PST:addModifiers({ tears = tmpAdd, alacritousTearBuff = tmpAdd }, true)
                        end
                        tmpMod = PST:getTreeSnapshotMod("alacritousLuckBuff", 0)
                        if tmpMod < 2 then
                            local tmpAdd = math.min(0.04, 2 - tmpMod)
                            PST:addModifiers({ luck = tmpAdd, alacritousLuckBuff = tmpAdd }, true)
                        end

                        if not PST:getTreeSnapshotMod("alacritousFlyProc", false) then
                            local flyEntities = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0)
                            if #flyEntities < 15 then
                                local tmpSpawn = math.min(3, 15 - #flyEntities)
                                for _=1,tmpSpawn do
                                    Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, entityParam.Position, Vector.Zero, nil, 0, Random() + 1)
                                end
                            end
                            PST:addModifiers({ alacritousFlyProc = true }, true)
                        end
                    end

                    -- Mod: +% damage for 2 seconds after destroying poop
                    tmpMod = PST:getTreeSnapshotMod("poopDamageBuff", 0)
                    if tmpMod ~= 0 then
                        PST.specialNodes.poopDestroyBuffTimer = 60
                        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                    end

                    -- Rainbow poop destroyed
                    if entityParam.Variant == GridPoopVariant.RAINBOW then
                        -- Mod: +% luck when destroying rainbow poop
                        tmpMod = PST:getTreeSnapshotMod("rainbowPoopLuck", 0)
                        local tmpTotal = PST:getTreeSnapshotMod("rainbowPoopLuckBuff", 0)
                        if tmpMod > 0 and tmpTotal < 35 then
                            local tmpAdd = math.min(tmpMod, 35 - tmpTotal)
                            PST:addModifiers({ luckPerc = tmpAdd, rainbowPoopLuckBuff = tmpAdd }, true)
                        end

                        -- Mod: % chance to gain a soul heart when destroying rainbow poop
                        tmpMod = PST:getTreeSnapshotMod("rainbowPoopSoul", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod then
                            PST:getPlayer():AddSoulHearts(2)
                        end
                    end
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
            local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", {})
            if staticEntCache[entityID] ~= entityParam.State then
                local noXP = staticEntCache[entityID] == -1
                staticEntCache[entityID] = entityParam.State
                -- Tinted rock destroyed
                if staticEntCache[entityID] >= 2 and not noXP then
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
    elseif entityParam.Desc.Type == GridEntityType.GRID_ROCK then
        if PST:getRoom():IsFirstVisit() and PST:getRoom():GetFrameCount() == 0 and not PST:getLevel():GetDimension() == Dimension.MINESHAFT then
            -- Ancient starcursed jewel: Tellurian Splinter
            if PST:SC_getSnapshotMod("tellurianSplinter", false) and 100 * math.random() < 20 then
                local room = PST:getRoom()
                local gridIdx = entityParam:GetGridIndex()
                room:GetGridEntity(gridIdx):ToRock():Destroy(true)
                room:SpawnGridEntity(gridIdx, GridEntityType.GRID_ROCK_BOMB)
            end
        end
    elseif entityParam.Desc.Type == GridEntityType.GRID_ROCK_BOMB and entityParam.State == 2 then
        -- Ancient starcursed jewel: Tellurian Splinter
        if PST:SC_getSnapshotMod("tellurianSplinter", false) then
            local entityID = PST:initStaticEntity(entityParam)
            if entityID then
                local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", {})
                if staticEntCache[entityID] ~= entityParam.State then
                    -- Bomb rock destroyed
                    if PST:getTreeSnapshotMod("SC_tellurianBuff", 0) < 35 then
                        PST:addModifiers({ speedPerc = 1, SC_tellurianBuff = 1 }, true)
                    end
                    staticEntCache[entityID] = entityParam.State
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