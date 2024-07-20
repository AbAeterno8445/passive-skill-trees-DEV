function PST:onNewLevel()
    local level = Game():GetLevel()
    local floor = level:GetStage()

    -- Chance to reveal map mod
    local mappingChance = PST:getTreeSnapshotMod("mapChance", 0)
    if mappingChance > 0 then
        if floor > 1 and 100 * math.random() < mappingChance then
            level:ShowMap()
            PST:createFloatTextFX("Map revealed!", Vector(0, 0), Color(1, 1, 1, 1), 0.12, 70, true)
        end
    end

    -- Cosmic Realignment node
    local player = Isaac.GetPlayer()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
    if PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY) then
        -- Blue baby, reset non-soul heart pickups
        cosmicRCache.blueBabyHearts = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN) then
        -- Eden, -0.1 to random stat when entering a floor (from 2 onwards)
        if floor > 1 then
            local randomStat = PST:getRandomStat()
            PST:addModifiers({ [randomStat] = -0.1 }, true)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER) then
        -- Keeper, tally collected coins in previous floor and halve coin count if < 5
        if cosmicRCache.keeperFloorCoins < 5 then
            player:AddCoins(math.floor(player:GetNumCoins() / 2) * -1)
        end
        cosmicRCache.keeperFloorCoins = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
        -- The Forgotten, convert a red/bone heart into a full soul heart (prioritizes bone hearts)
        local boneHearts = player:GetBoneHearts()
        if boneHearts > 0 then
            player:AddBoneHearts(-1)
            player:AddSoulHearts(2)
        end
    end
    PST:save()
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