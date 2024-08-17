function PST:applyDevilChance(chance)
    local treeDevilChance = PST:getTreeSnapshotMod("devilChance", 0) / 100

    -- Starcursed mod: -% chance to find a devil/angel room
    local starcursedChance = PST:SC_getSnapshotMod("lessDevilRoomChance", 0) / 100

    return math.max(0, chance + treeDevilChance - starcursedChance)
end