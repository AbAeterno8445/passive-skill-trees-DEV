function PST:onNewLevel()
    local mappingChance = PST:getTreeSnapshotMod("mapChance", 0)

    if mappingChance > 0 then
        local level = Game():GetLevel()
        local floor = level:GetStage()
        if floor > 1 and 100 * math.random() < mappingChance then
            level:ShowMap()
            PST:createFloatTextFX("Map revealed!", Vector(0, 0), Color(1, 1, 1, 1), 0.12, 70, true)
        end
    end
end

local curseIDs = {
    LevelCurse.CURSE_OF_BLIND,
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_THE_CURSED,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN
}
function PST:onCurseEval(curses)
    local causeCurse = PST:getTreeSnapshotMod("causeCurse", false)
    if causeCurse and curses == LevelCurse.CURSE_NONE then
        PST:addModifiers({causeCurse = false}, true)
        
        local newCurse = curseIDs[math.random(#curseIDs)]
        return newCurse
    end
    return curses
end