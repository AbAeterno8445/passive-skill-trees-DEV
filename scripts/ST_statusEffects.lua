---@param statusID StatusEffect
---@param entity Entity
---@param source EntityRef
---@param duration integer
function PST:preStatusEffectApply(statusID, entity, source, duration)
    -- Status application by player
    if source and (source.Type == EntityType.ENTITY_PLAYER or source.SpawnerType == EntityType.ENTITY_PLAYER) then
        -- Poison
        if statusID == StatusEffect.POISON then
            if entity:GetPoisonCountdown() == 0 then
                -- Astral Companion: Adder scavenge event and objective
                PST:astralCompAddProgress("adder", 1)

                -- Astral Companion: Water Moccasin objective
                if entity.MaxHitPoints >= 40 then
                    PST:astralCompAddProgress("waterMoccasin", 1)
                end
            end
        -- Petrification
        elseif statusID == StatusEffect.FREEZE then
            if entity:GetFreezeCountdown() == 0 then
                -- Astral Companion: Anaconda objective
                PST:astralCompAddProgress("anaconda", 1)

                -- Astral Companion: Catoblepas objective
                if entity:IsBoss() then
                    PST:astralCompAddProgress("catoblepas", 1)
                end
            end
        -- Fear
        elseif statusID == StatusEffect.FEAR then
            if entity:GetFearCountdown() == 0 then
                -- Astral Companion: Abyssal Tarantula objective
                PST:astralCompAddProgress("abyssalTarantula", 1)
            end
        -- Slow
        elseif statusID == StatusEffect.SLOWING then
            if entity:GetSlowingCountdown() == 0 then
                -- Astral Companion: Jumping Spider objective
                if source.Entity and source.Entity.Position:Distance(entity.Position) > 120 then
                    PST:astralCompAddProgress("jumpingSpider", 1)
                end
            end
        end
    end
end

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

    -- Player status application
    if source and (source.Type == EntityType.ENTITY_PLAYER or source.SpawnerType == EntityType.ENTITY_PLAYER) then
        -- Astral Companion: Manticore scavenge event
        if PST:isCompEquipped("manticore") and entity:IsBoss() then
            local bossData = PST:getEntData(entity)
            if not bossData.manticoreFirstStatusList then
                bossData.manticoreFirstStatusList = {}
            end
            if not PST:arrHasValue(bossData.manticoreFirstStatusList, statusID) then
                PST:astralCompProcScavenge("manticore")
                table.insert(bossData.manticoreFirstStatusList, statusID)
            end
        -- Astral Companion: Catoblepas scavenge event
        elseif PST:isCompEquipped("catoblepas") and entity:IsBoss() then
            local bossData = PST:getEntData(entity)
            if not bossData.firstPetrif then
                PST:astralCompProcScavenge("catoblepas")
                bossData.firstPetrif = true
            end
        end
    end
end