function PST:onNewLevel()
    local level = Game():GetLevel()
    local floor = level:GetStage()

    PST.specialNodes.momDeathProc = false
    PST.floorFirstUpdate = true
    PST:addModifiers({ staticEntitiesCache = { value = {}, set = true } }, true)

    -- Impromptu Gambler node (Cain's tree)
	if PST:getTreeSnapshotMod("impromptuGambler", false) then
		PST:addModifiers({ impromptuGamblerProc = false }, true)
    end

    -- Sacrifice Darkness node (Judas' tree)
    if PST:getTreeSnapshotMod("sacrificeDarkness", false) then
        PST:addModifiers({ blackHeartSacrifices = { value = 0, set = true } }, true)
    end

    -- Mod: +% tears and range when picking up a soul heart (reset)
    local tmpBonusTotal = PST:getTreeSnapshotMod("soulHeartTearsRangeTotal", 0)
    if tmpBonusTotal > 0 then
        PST:addModifiers({
            tearsPerc = -tmpBonusTotal,
            rangePerc = -tmpBonusTotal,
            soulHeartTearsRangeTotal = { value = 0, set = true }
        }, true)
    end

    -- Carrion Avian node (Eve's tree)
    if PST:getTreeSnapshotMod("carrionAvian", false) then
        PST:addModifiers({
            damage = -PST:getTreeSnapshotMod("carrionAvianTempBonus", 0),
            carrionAvianTempBonus = { value = 0, set = true }
        }, true)
    end

    -- Hasted node (Samson's tree)
    if PST:getTreeSnapshotMod("hasted", false) then
        local tmpHits = PST:getTreeSnapshotMod("hastedHits", 0)
        PST:addModifiers({
            tearsPerc = tmpHits * 1.5,
            shotSpeedPerc = tmpHits * 1.5,
            hastedHits = { value = 0, set = true }
        }, true)
    end

    -- Mod: +damage / +luck on card use, resets every floor
    local tmpTotal = PST:getTreeSnapshotMod("cardFloorDamageTotal", 0)
    if tmpTotal > 0 then
        PST:addModifiers({
            damage = -tmpTotal,
            cardFloorDamageTotal = { value = 0, set = true }
        }, true)
    end
    tmpTotal = PST:getTreeSnapshotMod("cardFloorTearsTotal", 0)
    if tmpTotal > 0 then
        PST:addModifiers({
            tears = -tmpTotal,
            cardFloorTearsTotal = { value = 0, set = true }
        }, true)
    end

    -- Chaotic Treasury node (Eden's tree)
    if PST:getTreeSnapshotMod("chaoticTreasury", false) then
        PST:addModifiers({ chaoticTreasuryProc = false }, true)
    end

    -- Sporadic Growth node (Eden's tree)
    if PST:getTreeSnapshotMod("sporadicGrowth", false) and not PST:isFirstOrigStage() then
        for _=1,2 do
            local tmpStat = PST:getRandomStat()
            PST:addModifiers({ [tmpStat .. "Perc"] = 1 }, true)
        end
    end

    -- Mod: +damage when a blue fly dies, up to +2. Resets every floor
    tmpTotal = PST:getTreeSnapshotMod("blueFlyDeathDamageTotal", 0)
    if tmpTotal > 0 then
        PST:addModifiers({
            damage = -tmpTotal,
            blueFlyDeathDamageTotal = { value = 0, set = true }
        }, true)
    end

    -- Null node (Apollyon's tree)
    if PST:getTreeSnapshotMod("null", false) then
        if not PST:getTreeSnapshotMod("nullActiveAbsorbed", false) and PST:getTreeSnapshotMod("nullAppliedBonus", 0) < 3 then
            PST:addModifiers({ allstatsPerc = 5, nullAppliedBonus = 1 }, true)
        end
    end

    -- Mod: +% all stats per wisp orbiting you when entering a floor, up to 15%
    local tmpBonus = PST:getTreeSnapshotMod("wispFloorBuff", 0)
    if tmpBonus ~= 0 then
        tmpTotal = 0
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
            if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and tmpEntity.Variant == FamiliarVariant.WISP then
                tmpTotal = tmpTotal + tmpBonus
            end
        end
        local treeTotal = PST:getTreeSnapshotMod("wispFloorBuffTotal", 0)
        if tmpTotal ~= 0 and treeTotal < 15 then
            local tmpAdd = math.min(tmpTotal, 15 - treeTotal)
            PST:addModifiers({ allstatsPerc = tmpAdd, wispFloorBuffTotal = tmpAdd }, true)
        end
    end

    -- Floor stat buffs reset
    tmpBonus = PST:getTreeSnapshotMod("floorLuckPerc", 0)
    if tmpBonus ~= 0 then
        PST:addModifiers({ luckPerc = -tmpBonus, floorLuckPerc = { value = 0, set = true } }, true)
    end
    tmpBonus = PST:getTreeSnapshotMod("floorLuck", 0)
    if tmpBonus ~= 0 then
        PST:addModifiers({ luck = -tmpBonus, floorLuck = { value = 0, set = true } }, true)
    end

    -- Cosmic Realignment node
    local player = Isaac.GetPlayer()
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
    if PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY) then
        -- Blue baby, reset non-soul heart pickups
        cosmicRCache.blueBabyHearts = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN) then
        -- Eden, -0.1 to random stat when entering a floor (from 2 onwards)
        if not PST:isFirstOrigStage() then
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
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
        -- Tainted Lost, reset Keeper coins tracker
        cosmicRCache.TLostKeeperCoins = 0
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
        -- Tainted Keeper, if < 15 coins, lose a heart container, otherwise halve coin count
        if not PST:isFirstOrigStage() then
            if player:GetNumCoins() < 15 then
                if player:GetMaxHearts() > 2 then
                    player:AddMaxHearts(-2)
                elseif player:GetSoulHearts() > 2 then
                    player:AddSoulHearts(-2)
                end
            else
                player:AddCoins(-math.ceil(player:GetNumCoins() / 2))
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON_B) then
        -- Tainted Apollyon, despawn a locust
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
            if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and tmpEntity.Variant == FamiliarVariant.ABYSS_LOCUST then
                tmpEntity:Remove()
                cosmicRCache.TApollyonLocusts = math.max(0, cosmicRCache.TApollyonLocusts - 1)
                player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
                break
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
        -- Tainted Bethany, heal wisps
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
            if tmpEntity.Type == EntityType.ENTITY_FAMILIAR and tmpEntity.Variant == FamiliarVariant.ITEM_WISP then
                tmpEntity:AddHealth(tmpEntity.MaxHitPoints)
            end
        end
    end
    PST:save()
end

local curseIDs = {
    LevelCurse.CURSE_OF_BLIND,
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_MAZE,
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

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
        -- Tainted Cain, roll for curse of the blind
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
        if 100 * math.random() < 100 - cosmicRCache.TCainUses * 10 then
            curses = curses | LevelCurse.CURSE_OF_BLIND
        end
    end

    -- Apollyon's Blessing node (Apollyon's tree)
    if PST:getTreeSnapshotMod("apollyonBlessing", false) then
        -- Curse of blind immunity
        curses = curses ~ LevelCurse.CURSE_OF_BLIND
    end

    return curses
end