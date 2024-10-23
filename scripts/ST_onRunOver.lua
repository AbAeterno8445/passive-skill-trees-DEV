function PST:onRunOver(isGameOver)
    if not isGameOver then
        -- Relearning node, grant respecs
        local relearningMod = PST:getTreeSnapshotMod("relearning", false)
        if relearningMod then
            PST.modData.respecPoints = PST.modData.respecPoints + 10 + 2 * PST:getTreeSnapshotMod("relearningFloors", 1)
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
    end
    PST:onExitGame()
end