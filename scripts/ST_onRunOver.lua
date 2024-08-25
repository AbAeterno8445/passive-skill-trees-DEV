function PST:onRunOver(isGameOver)
    if not isGameOver then
        -- Relearning node, grant respecs
        local relearningMod = PST:getTreeSnapshotMod("relearning", false)
        if relearningMod then
            PST.modData.respecPoints = PST.modData.respecPoints + 10 + 2 * PST:getTreeSnapshotMod("relearningFloors", 1)
        end
    end
    PST:onExitGame()
end