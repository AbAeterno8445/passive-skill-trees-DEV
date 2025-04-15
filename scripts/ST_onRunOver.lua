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
        if PST:SC_getSnapshotMod("circadianDestructor", false) then
            PST:sideArtiObjProgress("blastingMeridion", 1)
        end
        -- Sidereal Artifact objective: win a run with at least 4 smelted trinkets
        local tmpTrinkets = 0
        for _, tmpTrinket in pairs(PST:getPlayer():GetSmeltedTrinkets()) do
            if tmpTrinket.trinketAmount > 0 or tmpTrinket.goldenTrinketAmount > 0 then
                tmpTrinkets = tmpTrinkets + tmpTrinket.trinketAmount + tmpTrinket.goldenTrinketAmount
            end
        end
        if tmpTrinkets >= 4 then
            PST:sideArtiObjProgress("smelterMeridion", 1)
        end

        if PST:getTreeSnapshotMod("isExpedRun", false) then
            -- Expedition objective: Win a run having killed at least 1 final boss
            if PST:getTreeSnapshotMod("finalBossKills", 0) > 0 then
                PST:expedAddProgress(PST:getTreeSnapshotMod("expedDepth", 0), 1, "winRun", PST:getTreeSnapshotMod("isExpedUber", false))
            end

            -- Expedition order objective: Win a run without having killed any Angel bosses
            if not PST:getTreeSnapshotMod("killedAngels", false) then
                PST:expedAddOrderProgInRun("expedOrd_noAngels", 1)
            end
        end
    else
        -- Astral Expeditions, subtract attempts on run loss
        if PST:getTreeSnapshotMod("isExpedRun", false) then
            local depth = PST:getTreeSnapshotMod("expedDepth", 0)
            if depth > 0 then
                local loseAttempt = true
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

                -- Uber expedition mods
                if PST:getTreeSnapshotMod("isExpedUber", false) then
                    -- Bring The Order node (Deep-Space tree)
                    local expData = PST:getExpedData(PST:getTreeSnapshotMod("expedDepth", 0), true)
                    if expData and expData.modifiers and expData.modifiers.bringTheOrder and expData.order and expData.order >= 15 then
                        loseAttempt = false
                    end
                end

                if loseAttempt and noAttemptStage == 0 or PST:getLevel():GetStage() < noAttemptStage then
                    PST:expedLoseAttempt(depth)
                end
            end

            -- Uber expedition entropy mod
            if PST:getTreeSnapshotMod("expedEnt_loseRun", false) then
                PST:expedAddEntropy(
                    PST:getTreeSnapshotMod("expedDepth", 1),
                    PST.expedEntropyMods.expedEnt_loseRun.entropy
                )
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