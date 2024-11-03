function PST:applyDevilChance(chance)
    local chanceMod = 0

    -- Tree nodes devil/angel chance
    chanceMod = chanceMod + PST:getTreeSnapshotMod("devilChance", 0) / 100

    -- Starcursed mod: -% chance to find a devil/angel room
    chanceMod = chanceMod - PST:SC_getSnapshotMod("lessDevilRoomChance", 0) / 100

    -- Ancient weapon mod: Consecrator
    local tmpMod = PST:getSnapAstralWepMod("consecrator")
    if tmpMod then
        chanceMod = chanceMod + tmpMod[3] / 100
    end

    return math.max(0, chance + chanceMod)
end