function SkillTrees:applyDevilChance(chance)
    local treeDevilChance = SkillTrees:getTreeSnapshotMod("devilChance", 0) / 100
    return chance + treeDevilChance
end