function PST:onRunOver(isGameOver)
    if not isGameOver then
        -- Relearning node, grant respecs
        local relearningMod = PST:getTreeSnapshotMod("relearning", false)
        if relearningMod then
            PST.modData.respecPoints = PST.modData.respecPoints + 10 + 2 * PST:getTreeSnapshotMod("relearningFloors", 1)
        end

        -- Timeless Bazaar, refresh
        local charData = PST:getCurrentCharData()
        if charData and not charData.bazaarFrozen and charData.bazaarSelection ~= nil then
            charData.bazaarPurchased = {}
            charData.bazaarDone = nil
            PST:bazaarGenSelection()
        end

        -- Sidereal Artifact objective: win a run with the Circadian Destructor ancient jewel equipped
        if PST:SC_getSocketedAncient("Circadian Destructor") ~= nil then
            PST:sideArtiObjProgress("blastingMeridion", 1)
        end
        -- Sidereal Artifact objective: win a run with at least 4 smelted trinkets
        local tmpTrinkets = 0
        for _, tmpTrinket in pairs(PST:getPlayer():GetSmeltedTrinkets()) do
            if tmpTrinket.trinketAmount > 0 or tmpTrinket.goldenTrinketAmount > 0 then
                tmpTrinkets = tmpTrinkets + 1
            end
        end
        if tmpTrinkets >= 4 then
            PST:sideArtiObjProgress("smelterMeridion", 1)
        end
    else
        -- Astral Expeditions, subtract attempts on run loss
        if PST:getTreeSnapshotMod("isExpedRun", false) then
            local depth = PST:getTreeSnapshotMod("expedDepth", 0)
            if depth > 0 then
                -- Boon: lose no attempts when dying to final bosses, or past womb II (upgraded)
                local tmpMod = PST:getTreeSnapshotMod("boonLastGasp", 0)
                local noAttemptStage = 0
                if tmpMod == 1 then
                    if not Game():IsGreedMode() then noAttemptStage = 11
                    else noAttemptStage = 7 end
                elseif tmpMod == 2 then
                    if not Game():IsGreedMode() then noAttemptStage = 8
                    else noAttemptStage = 4 end
                end

                if noAttemptStage == 0 or PST:getLevel():GetStage() < noAttemptStage then
                    PST:expedLoseAttempt(depth)
                end
            end
        end

        -- Timeless Bazaar, refresh after losing 2x past floor 7
        local charData = PST:getCurrentCharData()
        if charData and not charData.bazaarFrozen and charData.bazaarSelection ~= nil and PST:getLevel():GetStage() > 7 then
            PST:addModifiers({ bazaarLoseRefresh = 1 }, true)
            if PST:getTreeSnapshotMod("bazaarLoseRefresh", 0) >= 2 then
                charData.bazaarPurchased = {}
                charData.bazaarDone = nil
                PST:bazaarGenSelection()
                PST:addModifiers({ bazaarLoseRefresh = { value = 0, set = true } }, true)
            end
        end
    end
    PST:onExitGame()
end