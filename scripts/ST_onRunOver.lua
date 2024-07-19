function SkillTrees:onRunOver(isGameOver)
    if not isGameOver then
        -- Relearning node, grant respecs
        local relearningMod = SkillTrees:getTreeSnapshotMod("relearning", false)
        if relearningMod then
            SkillTrees.modData.respecPoints = SkillTrees.modData.respecPoints + 10 + 2 * SkillTrees:getTreeSnapshotMod("relearningFloors", 1)
        end
    end
end