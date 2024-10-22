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
                PST:expedLoseAttempt(depth)
            end
        end
    end
    PST:onExitGame()
end