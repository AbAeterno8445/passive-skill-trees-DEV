function PST:applyDevilChance(chance)
    local treeDevilChance = PST:getTreeSnapshotMod("devilChance", 0) / 100
    return chance + treeDevilChance
end