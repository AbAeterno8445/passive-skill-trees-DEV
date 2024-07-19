function SkillTrees:applyDevilChance(chance)
    local treeDevilChance = SkillTrees:getTreeSnapshotMod("devilChance", 0) + 10

    --print("Current devil chance float is", chance)
    return chance + treeDevilChance
end