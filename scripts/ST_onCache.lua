local function tearsUp(firedelay, newValue)
    local newTears = 30 / (firedelay + 1) + newValue
    return math.max((30 / newTears) - 1, -0.75)
end

-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function PST:onCache(player, cacheFlag)
    -- SIZE CACHE
    if cacheFlag == CacheFlag.CACHE_SIZE then
        -- Mod: % character size while berserk
        local tmpTreeMod = PST:getTreeSnapshotMod("berserkSize", 0)
        if tmpTreeMod ~= 0 and PST:isBerserk() then
            player.SpriteScale = player.SpriteScale + Vector(tmpTreeMod / 100, tmpTreeMod / 100)
        end

        return
    end

    -- Skip non-stat related cache update
    if (cacheFlag & PST.allstatsCache) == 0 then return end

    local dynamicMods = {
        damage = 0, luck = 0, speed = 0, tears = 0, shotSpeed = 0, range = 0,
        damagePerc = 0, luckPerc = 0, speedPerc = 0, tearsPerc = 0, shotSpeedPerc = 0, rangePerc = 0,
        allstatsPerc = 0, allstats = 0
    }

    -- Magic Die node (Isaac's tree)
    if PST:getTreeSnapshotMod("magicDie", false) then
        local magicDieData = PST:getTreeSnapshotMod("magicDieData", nil)
        if magicDieData then
            if magicDieData.source == "angel" then
                dynamicMods.speedPerc = dynamicMods.speedPerc + magicDieData.value
                dynamicMods.tearsPerc = dynamicMods.tearsPerc + magicDieData.value
            elseif magicDieData.source == "devil" then
                dynamicMods.damagePerc = dynamicMods.damagePerc + magicDieData.value
                dynamicMods.rangePerc = dynamicMods.rangePerc + magicDieData.value
            elseif magicDieData.source == "treasure" then
                dynamicMods.shotSpeedPerc = dynamicMods.shotSpeedPerc + magicDieData.value
                dynamicMods.luckPerc = dynamicMods.luckPerc + magicDieData.value
            else
                dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + magicDieData.value
            end
        end
    end

    -- Mod: all stats while holding Birthright
    local tmpTreeMod = PST:getTreeSnapshotMod("allstatsBirthright", 0)
    if tmpTreeMod ~= 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        dynamicMods.allstats = dynamicMods.allstats + tmpTreeMod
    end

    -- Magdalene's Blessing node (Magdalene's tree)
    if PST:getTreeSnapshotMod("magdaleneBlessing", false) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE or cacheFlag == CacheFlag.CACHE_SPEED then
            local tmpHearts = math.ceil((player:GetMaxHearts() - 8) / 2)
            if tmpHearts > 0 then
                dynamicMods.speed = dynamicMods.speed - tmpHearts * 0.02
                dynamicMods.damage = dynamicMods.damage + tmpHearts * 0.1
            end
        end
    end

    -- Sacrifice Darkness node (Judas' tree)
    if PST:getTreeSnapshotMod("sacrificeDarkness", false) then
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + PST:getTreeSnapshotMod("blackHeartSacrifices", 0)
    end

    -- Dark Judas mods
    if player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
        if cacheFlag == CacheFlag.CACHE_SPEED then
            -- Speed
            dynamicMods.speedPerc = dynamicMods.speedPerc + PST:getTreeSnapshotMod("darkJudasSpeed", 0)
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            -- Shot speed
            dynamicMods.shotSpeedPerc = dynamicMods.shotSpeedPerc + PST:getTreeSnapshotMod("darkJudasShotspeedRange", 0)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            -- Range
            dynamicMods.rangePerc = dynamicMods.rangePerc + PST:getTreeSnapshotMod("darkJudasShotspeedRange", 0)
        end
    end

    local totalFamiliars = PST:getTreeSnapshotMod("totalFamiliars", 0)
    -- LUCK CACHE
    if cacheFlag == CacheFlag.CACHE_LUCK then
        -- Mod: +luck per held poop item
        tmpTreeMod = PST:getTreeSnapshotMod("poopItemLuck", 0)
        if tmpTreeMod ~= 0 then
            local playerCollectibles = player:GetCollectiblesList()
            for _, tmpItem in ipairs(PST.poopItems) do
                if playerCollectibles[tmpItem] > 0 then
                    dynamicMods.luck = dynamicMods.luck + tmpTreeMod
                end
            end
        end

        -- Mod: +luck while holding a poop trinket
        tmpTreeMod = PST:getTreeSnapshotMod("poopTrinketLuck", 0)
        if tmpTreeMod ~= 0 then
            local hasTrinket = PST:arrHasValue(PST.poopTrinkets, player:GetTrinket(0)) or PST:arrHasValue(PST.poopTrinkets, player:GetTrinket(1))
            if hasTrinket then
                dynamicMods.luck = dynamicMods.luck + tmpTreeMod
            end
        end

        -- Mod: +luck per active familiar
        tmpTreeMod = PST:getTreeSnapshotMod("activeFamiliarsLuck", 0)
        if tmpTreeMod > 0 and totalFamiliars > 0 then
            dynamicMods.luck = dynamicMods.luck + totalFamiliars * tmpTreeMod
        end

        -- Mod: +luck while holding a locust (trinket)
        tmpTreeMod = PST:getTreeSnapshotMod("locustHeldLuck", 0)
        if tmpTreeMod ~= 0 then
            local hasLocust = PST:arrHasValue(PST.locustTrinkets, player:GetTrinket(0)) or PST:arrHasValue(PST.locustTrinkets, player:GetTrinket(1))
            if hasLocust then
                dynamicMods.luck = dynamicMods.luck + tmpTreeMod
            end
        end

        -- Mod: +luck per full heart of any type with the brother with lower total health
        tmpTreeMod = PST:getTreeSnapshotMod("jacobHeartLuck", 0)
        if tmpTreeMod ~= 0 and PST.specialNodes.jacobHeartLuckVal ~= 0 then
		    dynamicMods.luck = dynamicMods.luck + (PST.specialNodes.jacobHeartLuckVal / 2) * tmpTreeMod
		end

        -- Mod: +luck per 1/2 heart difference between the two forms, up to +2 (T. Lazarus)
        tmpTreeMod = PST:getTreeSnapshotMod("formHeartDiffLuck", 0)
        if tmpTreeMod ~= 0 then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                local totalHeartsMain = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() + player:GetEternalHearts() + player:GetBrokenHearts()
                local totalHeartsOther = otherForm:GetHearts() + otherForm:GetSoulHearts() + otherForm:GetBoneHearts() + otherForm:GetRottenHearts() + otherForm:GetEternalHearts() + otherForm:GetBrokenHearts()
                local tmpHeartDiff = math.abs(totalHeartsMain - totalHeartsOther)
                dynamicMods.luck = dynamicMods.luck + math.min(2, tmpTreeMod * tmpHeartDiff)
            end
        end
    -- DAMAGE CACHE
    elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- Mod: damage while dead bird is active
        if PST.specialNodes.deadBirdActive and PST:getTreeSnapshotMod("activeDeadBirdDamage", 0) ~= 0 then
            dynamicMods.damage = dynamicMods.damage + PST:getTreeSnapshotMod("activeDeadBirdDamage", 0)
        end

        -- Hearty node (Samson's tree)
        if PST:getTreeSnapshotMod("hearty", false) then
            dynamicMods.damagePerc = dynamicMods.damagePerc - 1.5 * player:GetHearts()
        end

        -- Mod: +% damage per active Incubus familiar
        tmpTreeMod = PST:getTreeSnapshotMod("activeIncubusDamage", 0)
        if tmpTreeMod > 0 then
            local tmpIncubi = PST:getRoomFamiliars(FamiliarVariant.INCUBUS)
            if tmpIncubi > 0 then
                dynamicMods.damagePerc = dynamicMods.damagePerc + tmpIncubi * tmpTreeMod
            end
        end

        -- Spirit Ebb node (The Forgotten's tree)
        if (PST.specialNodes.spiritEbbHits.forgotten >= 6 and player:GetPlayerType() == PlayerType.PLAYER_THESOUL) or
        (PST.specialNodes.spiritEbbHits.soul >= 6 and player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN) then
            dynamicMods.damagePerc = dynamicMods.damagePerc + 10
        end

        if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and player:GetSubPlayer() then
            -- Mod: +damage with The Forgotten per remaining soul/black hearts
            tmpTreeMod = PST:getTreeSnapshotMod("forgottenSoulDamage", 0)
            if tmpTreeMod > 0 then
                dynamicMods.damage = dynamicMods.damage + tmpTreeMod * player:GetSubPlayer():GetSoulHearts() / 2
            end
        elseif player:GetPlayerType() == PlayerType.PLAYER_THESOUL and player:GetSubPlayer() then
            -- Mod: +damage with The Soul per remaining soul/black hearts
            tmpTreeMod = PST:getTreeSnapshotMod("theSoulBoneDamage", 0)
            if tmpTreeMod > 0 then
                dynamicMods.damage = dynamicMods.damage + tmpTreeMod * player:GetSubPlayer():GetBoneHearts()
            end
        end

        -- Coordination node (Jacob & Esau's tree)
        if PST.specialNodes.coordinationHits.esau >= 5 and player:GetPlayerType() == PlayerType.PLAYER_JACOB then
            dynamicMods.damagePerc = dynamicMods.damagePerc + 10
        end

        -- Song of Darkness node (Siren's tree) [Harmonic modifier]
        if PST:getTreeSnapshotMod("songOfDarkness", false) and PST:songNodesAllocated(true) <= 2 then
            dynamicMods.damage = dynamicMods.damage + PST:GetBlackHeartCount(player) * 0.1
        end

        -- Mod: +% damage per held passive item
        tmpTreeMod = PST:getTreeSnapshotMod("obtainedItemDamage", 0)
        if tmpTreeMod > 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc + player:GetCollectibleCount() * tmpTreeMod
        end

        -- Mod: +damage per 1/2 remaining red heart past 2
        tmpTreeMod = PST:getTreeSnapshotMod("remainingHeartsDmg", 0)
        if tmpTreeMod ~= 0 then
            dynamicMods.damage = dynamicMods.damage + tmpTreeMod
        end

        -- Mod: +% damage when picking up temporary hearts
        if PST.specialNodes.temporaryHeartBuffTimer > 0 and PST.specialNodes.temporaryHeartDmgStacks > 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc + PST:getTreeSnapshotMod("temporaryHeartDmg", 0) * PST.specialNodes.temporaryHeartDmgStacks
        end

        -- Mod: +% damage after destroying poop
        tmpTreeMod = PST:getTreeSnapshotMod("poopDamageBuff", 0)
        if tmpTreeMod ~= 0 and PST.specialNodes.poopDestroyBuffTimer > 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc + tmpTreeMod
        end

        -- Bloodwrath node (T. Eve's tree)
        if PST:getTreeSnapshotMod("bloodwrath", false) then
            local heartBonus = 1.5 * player:GetHearts()
            if heartBonus ~= 0 and PST.specialNodes.bloodwrathFlipTimer > 0 then
                dynamicMods.damagePerc = dynamicMods.damagePerc + heartBonus
            else
                dynamicMods.damagePerc = dynamicMods.damagePerc - heartBonus
            end
        end

        -- Mod: % damage while berserk
        if PST:isBerserk() then
            tmpTreeMod = PST:getTreeSnapshotMod("berserkDmg", 0)
            if tmpTreeMod ~= 0 then
                dynamicMods.damagePerc = dynamicMods.damagePerc + tmpTreeMod
            end
        end

        -- Chimeric Amalgam node (T. Lilith's tree)
        tmpTreeMod = PST:getTreeSnapshotMod("chimericAmalgamDmgBonus", 0)
        if tmpTreeMod ~= 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc + tmpTreeMod
        end
    -- SPEED CACHE
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        -- Mod: speed while dead bird is active
        if PST.specialNodes.deadBirdActive and PST:getTreeSnapshotMod("activeDeadBirdSpeed", 0) ~= 0 then
            dynamicMods.speed = dynamicMods.speed + PST:getTreeSnapshotMod("activeDeadBirdSpeed", 0)
        end

        -- Minion Maneuvering node (Lilith's tree)
        if PST:getTreeSnapshotMod("minionManeuvering", false) then
            local maxBonus = PST.specialNodes.minionManeuveringMaxBonus
            dynamicMods.speedPerc = dynamicMods.speedPerc + math.min(maxBonus, totalFamiliars * 3)
        end

        -- Spirit Ebb node (The Forgotten's tree)
        if (PST.specialNodes.spiritEbbHits.forgotten >= 6 and player:GetPlayerType() == PlayerType.PLAYER_THESOUL) then
            dynamicMods.speedPerc = dynamicMods.speedPerc + 10
        end

        -- Mod: +speed per 1/2 remaining red heart past 2
        tmpTreeMod = PST:getTreeSnapshotMod("remainingHeartsSpeed", 0)
        if tmpTreeMod ~= 0 then
            dynamicMods.speed = dynamicMods.speed + tmpTreeMod
        end

        if PST:isBerserk() then
            -- Mod: % speed while berserk
            tmpTreeMod = PST:getTreeSnapshotMod("berserkSpeed", 0)
            if tmpTreeMod ~= 0 then
                dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod
            end
        else
            -- Mod: +% speed while not berserk, -maxspeed while berserk
            tmpTreeMod = PST:getTreeSnapshotMod("berserkSpdTradeoff", 0)
            if tmpTreeMod ~= 0 then
                dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod
            end
        end

        -- Mod: +% speed for 1 second when hitting enemies with hemoptysis
        tmpTreeMod = PST:getTreeSnapshotMod("hemoptysisSpeed", 0)
        if tmpTreeMod ~= 0 and PST.specialNodes.hemoptysisSpeedTimer > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod
        end

        -- Mod: +% speed that decays to 0 over 4+ seconds when entering a room with monsters
        tmpTreeMod = PST:getTreeSnapshotMod("roomEnterSpd", 0)
        if tmpTreeMod ~= 0 and PST.specialNodes.roomEnterSpdTimer > 0 then
            local tmpSpdMult = PST.specialNodes.roomEnterSpdTimer / (120 + PST:getTreeSnapshotMod("roomEnterSpdDecayDur", 0) * 30)
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod * tmpSpdMult
        end

        -- Mod: +% speed for 1 second after using the whip attack (T. Lilith)
        tmpTreeMod = PST:getTreeSnapshotMod("whipSpeed", 0)
        if tmpTreeMod ~= 0 and PST.specialNodes.whipSpeedTimer > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod
        end

        -- Marquess of Flies node (T. Keeper's tree)
        if PST:getTreeSnapshotMod("marquessOfFlies", false) then
            tmpTreeMod = PST:getTreeSnapshotMod("marquessFliesCache", 0)
            if tmpTreeMod > 0 then
                dynamicMods.speedPerc = dynamicMods.speedPerc - tmpTreeMod
            end
        end

        -- Mod: +% speed while you have Cricket Leg
        tmpTreeMod = PST:getTreeSnapshotMod("cricketLegSpeed", 0)
        if tmpTreeMod > 0 and player:HasTrinket(TrinketType.TRINKET_CRICKET_LEG) then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod
        end
    -- TEARS CACHE
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- Mod: tears while dead bird is active
        if PST.specialNodes.deadBirdActive and PST:getTreeSnapshotMod("activeDeadBirdTears", 0) ~= 0 then
            dynamicMods.tears = dynamicMods.tears + PST:getTreeSnapshotMod("activeDeadBirdTears", 0)
        end

        -- Mod: +% tears per active Incubus familiar
        tmpTreeMod = PST:getTreeSnapshotMod("activeIncubusTears", 0)
        if tmpTreeMod > 0 then
            local tmpIncubi = PST:getRoomFamiliars(FamiliarVariant.INCUBUS)
            if tmpIncubi > 0 then
                dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpIncubi * tmpTreeMod
            end
        end

        -- Spirit Ebb node (The Forgotten's tree)
        if PST.specialNodes.spiritEbbHits.soul >= 6 and player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + 10
        end

        if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and player:GetSubPlayer() then
            -- Mod: +tears with The Forgotten per remaining soul/black hearts
            tmpTreeMod = PST:getTreeSnapshotMod("forgottenSoulTears", 0)
            if tmpTreeMod > 0 then
                dynamicMods.tears = dynamicMods.tears + tmpTreeMod * player:GetSubPlayer():GetSoulHearts() / 2
            end
        elseif player:GetPlayerType() == PlayerType.PLAYER_THESOUL and player:GetSubPlayer() then
            -- Mod: +tears with The Soul per remaining soul/black hearts
            tmpTreeMod = PST:getTreeSnapshotMod("theSoulBoneTears", 0)
            if tmpTreeMod > 0 then
                dynamicMods.tears = dynamicMods.tears + tmpTreeMod * player:GetSubPlayer():GetBoneHearts()
            end
        end

        -- Coordination node (Jacob & Esau's tree)
        if PST.specialNodes.coordinationHits.jacob >= 5 and player:GetPlayerType() == PlayerType.PLAYER_ESAU then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + 10
        end

        -- Mod: +% tears per held passive item
        tmpTreeMod = PST:getTreeSnapshotMod("obtainedItemTears", 0)
        if tmpTreeMod > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + player:GetCollectibleCount() * tmpTreeMod
        end

        -- Mod: +tears per 1/2 remaining red heart past 2
        tmpTreeMod = PST:getTreeSnapshotMod("remainingHeartsDmg", 0)
        if tmpTreeMod ~= 0 then
            dynamicMods.tears = dynamicMods.tears + tmpTreeMod
        end

        -- Mod: +% tears when picking up temporary hearts
        if PST.specialNodes.temporaryHeartBuffTimer > 0 and PST.specialNodes.temporaryHeartTearStacks > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + PST:getTreeSnapshotMod("temporaryHeartTears", 0) * PST.specialNodes.temporaryHeartTearStacks
        end

        -- Mod: +% tears for 2 seconds after using Dark Arts
        tmpTreeMod = PST:getTreeSnapshotMod("darkArtsTears", 0)
        if tmpTreeMod ~= 0 and PST.specialNodes.darkArtsTearsTimer > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpTreeMod
        end

        -- Mod: % tears while berserk
        if PST:isBerserk() then
            tmpTreeMod = PST:getTreeSnapshotMod("berserkTears", 0)
            if tmpTreeMod ~= 0 then
                dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpTreeMod
            end
        end

        -- Mod: slowly gain up to + tears while Gello is retracted
        tmpTreeMod = PST:getTreeSnapshotMod("gelloTearsBonus", 0)
        if tmpTreeMod > 0 and PST.specialNodes.gelloTearBonusStep > 0 then
            local tmpMult = PST.specialNodes.gelloTearBonusStep / 150
            dynamicMods.tears = dynamicMods.tears + tmpTreeMod * tmpMult
        end

        -- Marquess of Flies node (T. Keeper's tree)
        if PST:getTreeSnapshotMod("marquessOfFlies", false) then
            tmpTreeMod = PST:getTreeSnapshotMod("marquessFliesCache", 0)
            if tmpTreeMod > 0 then
                dynamicMods.tearsPerc = dynamicMods.tearsPerc - tmpTreeMod
            end
        end

        -- Mod: +% tears for 2 seconds after a locust kills an enemy
        tmpTreeMod = PST:getTreeSnapshotMod("locustKillTears", 0)
        if tmpTreeMod > 0 and PST.specialNodes.locustKillTearsTimer > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpTreeMod
        end
    -- RANGE CACHE
    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        -- Mod: range while dead bird is active
        if PST.specialNodes.deadBirdActive and PST:getTreeSnapshotMod("activeDeadBirdRange", 0) ~= 0 then
            dynamicMods.range = dynamicMods.range + PST:getTreeSnapshotMod("activeDeadBirdRange", 0)
        end

        -- Mod: +% range per held passive item
        tmpTreeMod = PST:getTreeSnapshotMod("obtainedItemRange", 0)
        if tmpTreeMod > 0 then
            dynamicMods.rangePerc = dynamicMods.rangePerc + player:GetCollectibleCount() * tmpTreeMod
        end
    -- SHOTSPEED CACHE
    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        -- Mod: shot speed while dead bird is active
        if PST.specialNodes.deadBirdActive and PST:getTreeSnapshotMod("activeDeadBirdShotspeed", 0) ~= 0 then
            dynamicMods.shotSpeed = dynamicMods.shotSpeed + PST:getTreeSnapshotMod("activeDeadBirdShotspeed", 0)
        end
    end

    -- Ancient starcursed jewel: Crystallized Anamnesis
    if PST:SC_getSnapshotMod("crystallizedAnamnesis", false) and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_PURITY) then
        if player:GetPurityState() == PurityState.RED then dynamicMods.damage = dynamicMods.damage - 2
        elseif player:GetPurityState() == PurityState.BLUE then dynamicMods.tears = dynamicMods.tears - 1
        elseif player:GetPurityState() == PurityState.YELLOW then dynamicMods.speed = dynamicMods.speed - 0.5
        elseif player:GetPurityState() == PurityState.ORANGE then dynamicMods.range = dynamicMods.range - 1.5 end
    end

    -- Ancient starcursed jewel: Embered Azurite
    if PST:SC_getSnapshotMod("emberedAzurite", false) then
        local redItems = 0
        local blueItems = 0
        for itemID, itemAmt in pairs(player:GetCollectiblesList()) do
            if itemAmt > 0 then
                if PST:arrHasValue(PST.ultraSecretPool, itemID) then
                    redItems = redItems + itemAmt
                elseif PST:arrHasValue(PST.blueItemPool, itemID) then
                    blueItems = blueItems + itemAmt
                end
            end
        end
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc - math.min(64, math.abs(redItems - blueItems) * 8)
    end

    -- A True Ending? node (Lazarus' tree)
    if PST:getTreeSnapshotMod("aTrueEnding", false) and player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + PST:getTreeSnapshotMod("aTrueEndingCardUses", 0) * 2
    end

    -- Lazarus stat mods
    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            dynamicMods.damage = dynamicMods.damage + PST:getTreeSnapshotMod("lazarusDamage", 0)
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            dynamicMods.speed = dynamicMods.speed + PST:getTreeSnapshotMod("lazarusSpeed", 0)
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            dynamicMods.range = dynamicMods.range + PST:getTreeSnapshotMod("lazarusRange", 0)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            dynamicMods.tears = dynamicMods.tears + PST:getTreeSnapshotMod("lazarusTears", 0)
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            dynamicMods.luck = dynamicMods.luck + PST:getTreeSnapshotMod("lazarusLuck", 0)
        end
    elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            dynamicMods.damage = dynamicMods.damage + PST:getTreeSnapshotMod("lazarusDamage", 0) / 2
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            dynamicMods.speed = dynamicMods.speed + PST:getTreeSnapshotMod("lazarusSpeed", 0) / 2
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            dynamicMods.range = dynamicMods.range + PST:getTreeSnapshotMod("lazarusRange", 0) / 2
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            dynamicMods.tears = dynamicMods.tears + PST:getTreeSnapshotMod("lazarusTears", 0) / 2
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            dynamicMods.luck = dynamicMods.luck + PST:getTreeSnapshotMod("lazarusLuck", 0) / 2
        end
    end

    -- Locust buff nodes
    for _, tmpLocust in ipairs(PST.locustTrinkets) do
        local tmpLocustNum = player:GetSmeltedTrinkets()[tmpLocust &~ TrinketType.TRINKET_GOLDEN_FLAG].trinketAmount
        for i=0,1 do
            if player:GetTrinket(i) == tmpLocust then
                tmpLocustNum = tmpLocustNum + 1
            end
        end
        if tmpLocust == TrinketType.TRINKET_LOCUST_OF_CONQUEST then
            tmpTreeMod = math.min(15, PST:getTreeSnapshotMod("conquestLocustSpeed", 0))
            if tmpTreeMod > 0 then
                dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod * tmpLocustNum
            end
        elseif tmpLocust == TrinketType.TRINKET_LOCUST_OF_DEATH then
            tmpTreeMod = math.min(15, PST:getTreeSnapshotMod("deathLocustTears", 0))
            if tmpTreeMod > 0 then
                dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpTreeMod * tmpLocustNum
            end
        elseif tmpLocust == TrinketType.TRINKET_LOCUST_OF_FAMINE then
            tmpTreeMod = math.min(15, PST:getTreeSnapshotMod("famineLocustRangeShotspeed", 0))
            if tmpTreeMod > 0 then
                dynamicMods.rangePerc = dynamicMods.rangePerc + tmpTreeMod * tmpLocustNum
                dynamicMods.shotSpeedPerc = dynamicMods.shotSpeedPerc + tmpTreeMod * tmpLocustNum
            end
        elseif tmpLocust == TrinketType.TRINKET_LOCUST_OF_PESTILENCE then
            tmpTreeMod = math.min(12, PST:getTreeSnapshotMod("pestilenceLocustLuck", 0))
            if tmpTreeMod > 0 then
                dynamicMods.luckPerc = dynamicMods.luckPerc + tmpTreeMod * tmpLocustNum
            end
        elseif tmpLocust == TrinketType.TRINKET_LOCUST_OF_WRATH then
            tmpTreeMod = math.min(15, PST:getTreeSnapshotMod("warLocustDamage", 0))
            if tmpTreeMod > 0 then
                dynamicMods.damagePerc = dynamicMods.damagePerc + tmpTreeMod * tmpLocustNum
            end
        end
    end

    -- Heart Link node (Jacob & Esau's tree)
    if PST:getTreeSnapshotMod("heartLink", false) and player:GetOtherTwin() then
        local tmpTwin = player:GetOtherTwin()
        local tmpDiff = tmpTwin:GetHearts() - player:GetHearts()
        if tmpDiff > 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc - tmpDiff
            dynamicMods.tearsPerc = dynamicMods.tearsPerc - tmpDiff
            dynamicMods.rangePerc = dynamicMods.rangePerc - tmpDiff
        end
    end

    -- Mod: +% all stats per item obtained by the opposing brother, up to 15%
    tmpTreeMod = PST:getTreeSnapshotMod("jacobItemAllstats", 0)
    if tmpTreeMod ~= 0 and player:GetOtherTwin() then
        local itemCount = player:GetOtherTwin():GetCollectibleCount()
        if itemCount > 0 then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + math.min(15, tmpTreeMod * itemCount)
        end
    end

    -- Mod: +% all stats per 1 luck you have
    local tmpLuck = math.floor(player.Luck)
    if tmpLuck > 0 then
        tmpTreeMod = PST:getTreeSnapshotMod("mightOfFortune", 0)
        if tmpTreeMod > 0 then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + tmpLuck * tmpTreeMod
        end
    end

    -- Vacuophobia node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("vacuophobia", false) then
        local tmpMax = 8
        local collectibleCount = PST:getTIsaacInvItems()
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + math.min(tmpMax, collectibleCount)

        if player:GetTrinket(0) == 0 and player:GetTrinket(1) == 0 then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc - 4
        end
        if player:GetActiveItem(0) == 0 and player:GetActiveItem(1) == 0 then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc - 4
        end
        if player:GetCard(0) == 0 and player:GetCard(1) == 0 then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc - 4
        end
    end

    -- Tainted Health node (T. Magdalene's tree)
    if PST:getTreeSnapshotMod("taintedHealth", false) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            -- +0.1 damage per 1/2 red heart past 2
            local tmpHearts = player:GetHearts() - 4
            if tmpHearts > 0 then
                dynamicMods.damage = dynamicMods.damage + 0.1 * tmpHearts
            end
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            -- +3% tears per 1/2 soul heart
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + 3 * player:GetSoulHearts()
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            -- -15% speed at 3 or less remaining red hearts
            if player:GetHearts() <= 6 then
                dynamicMods.speedPerc = dynamicMods.speedPerc - 15
            end
        end
    end

    -- Bag of Crafting effects
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
        -- Magic Bag node (T. Cain's tree)
        if PST:getTreeSnapshotMod("magicBag", false) then
            local bagPickups = 0
            for _, tmpBagPickup in ipairs(player:GetBagOfCraftingContent()) do
                if tmpBagPickup ~= 0 then
                    bagPickups = bagPickups + 1
                end
            end
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + bagPickups / 2
        end

        -- Grand Ingredient nodes (T. Cain's tree)
        if PST:grandIngredientNodes(true) <= 2 then
            -- Grand Ingredient: Coins node (T. Cain's tree)
            if PST:getTreeSnapshotMod("grandIngredientCoins", false) then
                if player:GetBagOfCraftingSlot(0) == BagOfCraftingPickup.BOC_PENNY then
                    dynamicMods.luckPerc = dynamicMods.luckPerc + 3
                    dynamicMods.rangePerc = dynamicMods.rangePerc + 3
                elseif player:GetBagOfCraftingSlot(0) == BagOfCraftingPickup.BOC_LUCKY_PENNY then
                    dynamicMods.luckPerc = dynamicMods.luckPerc + 7
                elseif player:GetBagOfCraftingSlot(0) == BagOfCraftingPickup.BOC_GOLD_PENNY then
                    dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + 7
                end
            end

            -- Grand Ingredient: Keys node (T. Cain's tree)
            if PST:getTreeSnapshotMod("grandIngredientKeys", false) then
                if player:GetBagOfCraftingSlot(0) == BagOfCraftingPickup.BOC_KEY then
                    dynamicMods.tearsPerc = dynamicMods.tearsPerc + 3
                end
            end

            -- Grand Ingredient: Bombs node (T. Cain's tree)
            if PST:getTreeSnapshotMod("grandIngredientBombs", false) then
                if player:GetBagOfCraftingSlot(0) == BagOfCraftingPickup.BOC_BOMB then
                    dynamicMods.damagePerc = dynamicMods.damagePerc + 5
                elseif player:GetBagOfCraftingSlot(0) == BagOfCraftingPickup.BOC_GIGA_BOMB then
                    dynamicMods.damagePerc = dynamicMods.damagePerc + 30
                end
            end
        end

        -- Mod: +% stats per pickup of certain types
        for i=0,7 do
            local tmpPickup = player:GetBagOfCraftingSlot(i)
            if tmpPickup ~= 0 then
                -- Bombs, +% damage
                if tmpPickup == BagOfCraftingPickup.BOC_BOMB or tmpPickup == BagOfCraftingPickup.BOC_GIGA_BOMB or tmpPickup == BagOfCraftingPickup.BOC_GOLD_BOMB then
                    local tmpMod = PST:getTreeSnapshotMod("bagBombDamage", 0)
                    if tmpMod > 0 then
                        dynamicMods.damagePerc = dynamicMods.damagePerc + tmpMod
                    end
                -- Keys, +% tears
                elseif tmpPickup == BagOfCraftingPickup.BOC_KEY or tmpPickup == BagOfCraftingPickup.BOC_GOLD_KEY or tmpPickup == BagOfCraftingPickup.BOC_CHARGED_KEY or
                tmpPickup == BagOfCraftingPickup.BOC_CRACKED_KEY then
                    local tmpMod = PST:getTreeSnapshotMod("bagKeyTears", 0)
                    if tmpMod > 0 then
                        dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpMod
                    end
                -- Coins, +% range and luck
                elseif tmpPickup == BagOfCraftingPickup.BOC_PENNY or tmpPickup == BagOfCraftingPickup.BOC_NICKEL or tmpPickup == BagOfCraftingPickup.BOC_DIME or
                tmpPickup == BagOfCraftingPickup.BOC_GOLD_PENNY or tmpPickup == BagOfCraftingPickup.BOC_LUCKY_PENNY then
                    local tmpMod = PST:getTreeSnapshotMod("bagCoinRangeLuck", 0)
                    if tmpMod > 0 then
                        dynamicMods.rangePerc = dynamicMods.rangePerc + tmpMod
                        dynamicMods.luckPerc = dynamicMods.luckPerc + tmpMod
                    end
                -- Hearts, +% speed
                elseif tmpPickup == BagOfCraftingPickup.BOC_RED_HEART or tmpPickup == BagOfCraftingPickup.BOC_SOUL_HEART or tmpPickup == BagOfCraftingPickup.BOC_BLACK_HEART or
                tmpPickup == BagOfCraftingPickup.BOC_BONE_HEART or tmpPickup == BagOfCraftingPickup.BOC_ETERNAL_HEART or tmpPickup == BagOfCraftingPickup.BOC_GOLD_HEART or
                tmpPickup == BagOfCraftingPickup.BOC_ROTTEN_HEART then
                    local tmpMod = PST:getTreeSnapshotMod("bagHeartSpeed", 0)
                    if tmpMod > 0 then
                        dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod
                    end
                end
            end
        end
    end

    local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_HOLD)
    if tmpSlot ~= -1 then
        -- Treasured Waste node (T. Blue Baby's tree)
        if PST:getTreeSnapshotMod("treasuredWaste", false) and PST.specialNodes.poopHeld ~= 0 then
            if PST.specialNodes.poopHeld == PoopSpellType.SPELL_POOP then
                dynamicMods.allstats = dynamicMods.allstats + 2
            elseif PST.specialNodes.poopHeld == PoopSpellType.SPELL_CORNY then
                dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + 2
            elseif PST.specialNodes.poopHeld == PoopSpellType.SPELL_HOLY then
                dynamicMods.damagePerc = dynamicMods.damagePerc + 8
                dynamicMods.tearsPerc = dynamicMods.tearsPerc + 8
            elseif PST.specialNodes.poopHeld == PoopSpellType.SPELL_LIQUID then
                dynamicMods.speedPerc = dynamicMods.speedPerc + 6
            end

            -- Mod: +% luck while Hold is not empty
            tmpTreeMod = PST:getTreeSnapshotMod("holdFullLuck", 0)
            if tmpTreeMod ~= 0 then
                dynamicMods.luckPerc = dynamicMods.luckPerc + tmpTreeMod
            end
        elseif PST.specialNodes.poopHeld == 0 then
            -- Mod: +% speed while Hold is empty
            tmpTreeMod = PST:getTreeSnapshotMod("holdEmptySpeed", 0)
            if tmpTreeMod ~= 0 then
                dynamicMods.speedPerc = dynamicMods.speedPerc + tmpTreeMod
            end
        end
    end

    -- Mod: +% stats every X kills with the current form (T. Lazarus)
    tmpTreeMod = PST:getTreeSnapshotMod("lazFormKillStat", 0)
    if tmpTreeMod ~= 0 then
        local tmpStatCache = {}
        if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B then
            tmpStatCache = PST:getTreeSnapshotMod("lazFormStatCache", {})
        elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
            tmpStatCache = PST:getTreeSnapshotMod("lazFormDeadStatCache", {})
        end
        for tmpStat, statVal in pairs(tmpStatCache) do
            if dynamicMods[tmpStat] ~= nil then
                dynamicMods[tmpStat] = dynamicMods[tmpStat] + statVal
            end
        end
    end

    -- Mod: +% all stats per held familiar item
    tmpTreeMod = PST:getTreeSnapshotMod("familiarItemAllstats", 0)
    if tmpTreeMod ~= 0 then
        for itemID, itemAmt in ipairs(player:GetCollectiblesList()) do
            if itemAmt > 0 and PST:arrHasValue(PST.deliriumFamiliarItems, itemID) then
                dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + tmpTreeMod
            end
        end
    end

    -- Cosmic Realignment node
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache")
    local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPERB
    if PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
        -- The Forgotten, Keeper debuff
        if isKeeper then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + cosmicRCache.forgottenKeeperDebuff
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB) then
        -- Jacob & Esau, damage and tears debuff
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            dynamicMods.damagePerc = dynamicMods.damagePerc - 25 / (2 ^ cosmicRCache.jacobProcs)
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc - 25 / (2 ^ cosmicRCache.jacobProcs)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC_B) then
        -- Tainted Isaac, -4% all stats per item obtained after the 8th one, up to 40%
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + math.max(-40, cosmicRCache.TIsaacItems * -4)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
        -- Tainted Samson, all stats buffer (-20% to 10%)
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + math.max(-20, math.min(10, cosmicRCache.TSamsonBuffer))
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EDEN_B) then
        -- Tainted Eden, shuffle stat reduction
        for stat, val in pairs(dynamicMods) do
            if cosmicRCache.TEdenDebuff[stat] ~= nil then
                dynamicMods[stat] = val + cosmicRCache.TEdenDebuff[stat]
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON_B) then
        -- Tainted Apollyon, -4% damage, tears and luck per active locust, or -8% all stats if no locusts
        if cosmicRCache.TApollyonLocusts > 0 then
            local locustsVal = 4 * cosmicRCache.TApollyonLocusts
            dynamicMods.damagePerc = dynamicMods.damagePerc - locustsVal
            dynamicMods.tearsPerc = dynamicMods.tearsPerc - locustsVal
            dynamicMods.luckPerc = dynamicMods.luckPerc - locustsVal
        else
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc - 8
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
        -- Tainted Forgotten, Keeper debuff
        if isKeeper and not cosmicRCache.TForgottenTracker.keeperCoin then
            dynamicMods.allstatsPerc = dynamicMods.allstatsPerc - 8
        end
    end

    local allstats = PST:getTreeSnapshotMod("allstats", 0) + dynamicMods.allstats
    local allstatsPerc = PST:getTreeSnapshotMod("allstatsPerc", 0) + dynamicMods.allstatsPerc
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- DAMAGE
        local tmpMod = PST:getTreeSnapshotMod("damage", 0) + dynamicMods.damage + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("damagePerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.damagePerc / 100

        local baseDmg = player.Damage
        -- Ancient starcursed jewel: Saturnian Luminite
        if PST:SC_getSnapshotMod("saturnianLuminite", false) then
            baseDmg = 0.25
        end
        player.Damage = (baseDmg + tmpMod) * math.max(0.05, tmpMult)

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                player.Damage = (player.Damage + otherForm.Damage) / 2
            end
        end

        -- Glass Specter node (T. Lost's tree)
        if PST:getTreeSnapshotMod("glassSpecter", false) and player.MoveSpeed > 1 then
            local shieldMult = 1
            if PST:TLostHasAnyShield() then
                shieldMult = 0.5
            end
            player.Damage = player.Damage + (player.Damage * (player.MoveSpeed - 1)) * shieldMult
        end

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- TEARS (MaxFireDelay)
        local tmpMod = PST:getTreeSnapshotMod("tears", 0) + dynamicMods.tears + allstats
        local tmpMult = 1 - allstatsPerc / 100
        tmpMult = tmpMult - PST:getTreeSnapshotMod("tearsPerc", 0) / 100
        tmpMult = tmpMult - dynamicMods.tearsPerc / 100
        player.MaxFireDelay = tearsUp(player.MaxFireDelay, tmpMod) * math.max(0.05, tmpMult)

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                player.MaxFireDelay = (player.MaxFireDelay + otherForm.MaxFireDelay) / 2
            end
        end

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        -- LUCK
        local tmpMod = PST:getTreeSnapshotMod("luck", 0) + dynamicMods.luck
        local tmpMult = 1 + PST:getTreeSnapshotMod("luckPerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.luckPerc / 100
        player.Luck = (player.Luck + tmpMod) * math.max(0.05, tmpMult)

        -- Fickle Fortune node (Cain's tree)
        if PST:getTreeSnapshotMod("fickleFortune", false) and (player:GetTrinket(0) ~= 0 or player:GetTrinket(1) ~= 0) then
            -- Prevent luck from going below 1 while holding a trinket
            if player.Luck < 1 then
                player.Luck = 1
            end
        end

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                player.Luck = (player.Luck + otherForm.Luck) / 2
            end
        end

        -- Mod: minimum luck
        if PST:getTreeSnapshotMod("minLuckSet", false) and player.Luck < PST:getTreeSnapshotMod("minLuck", -1) then
            player.Luck = PST:getTreeSnapshotMod("minLuck", -1)
        end

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        -- RANGE
        local tmpMod = PST:getTreeSnapshotMod("range", 0) + dynamicMods.range + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("rangePerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.rangePerc / 100
        player.TearRange = (player.TearRange + tmpMod * 40) * math.max(0.05, tmpMult)

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                player.TearRange = (player.TearRange + otherForm.TearRange) / 2
            end
        end

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        -- SHOT SPEED
        local tmpMod = PST:getTreeSnapshotMod("shotSpeed", 0) + dynamicMods.shotSpeed + allstats
        local tmpMult = 1 + allstatsPerc / 200
        tmpMult = tmpMult + PST:getTreeSnapshotMod("shotSpeedPerc", 0) / 200
        tmpMult = tmpMult + dynamicMods.shotSpeedPerc / 200
        player.ShotSpeed = (player.ShotSpeed + tmpMod / 2) * math.max(0.05, tmpMult)

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                player.ShotSpeed = (player.ShotSpeed + otherForm.ShotSpeed) / 2
            end
        end

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        -- MOVEMENT SPEED
        local tmpMod = PST:getTreeSnapshotMod("speed", 0) + dynamicMods.speed + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("speedPerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.speedPerc / 100
        local baseSpeed = player.MoveSpeed

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE) then
            -- Magdalene, set base movement speed to 0.85
            baseSpeed = 0.85
        end
        player.MoveSpeed = (baseSpeed + tmpMod / 2) * math.max(0.05, tmpMult)

        -- Entanglement node (T. Lazarus' tree)
        if PST:getTreeSnapshotMod("entanglement", false) then
            local otherForm = PST:getTLazOtherForm()
            if otherForm then
                player.MoveSpeed = (player.MoveSpeed + otherForm.MoveSpeed) / 2
            end
        end

        -- Stealth Tactics node (T. Judas' tree)
        if PST:getTreeSnapshotMod("stealthTactics", false) then
            if player.MoveSpeed > 1.2 and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS) then
                player.MoveSpeed = 1.2
            end
        end

        -- Mod: -maxspeed while berserk
        tmpMod = PST:getTreeSnapshotMod("berserkSpdTradeoff", 0)
        if tmpMod ~= 0 then
            local maxSpeed = 2 - tmpMod / 100
            if player.MoveSpeed > maxSpeed then
                player.MoveSpeed = maxSpeed
            end
        end

        -- Ancient starcursed jewel: Cursed Auric Shard
	    if PST:getTreeSnapshotMod("SC_cursedAuricSpeedProc", false) and player.MoveSpeed < 1.6 and PST:getRoom():GetAliveEnemiesCount() == 0 then
            -- Minimum speed becomes 1.6 in cleared rooms after defeating floor boss
            player.MoveSpeed = 1.6
        end

        -- Glass Specter node (T. Lost's tree)
        if PST:getTreeSnapshotMod("glassSpecter", false) and player.MoveSpeed > 1 and (PST.delayedCacheFlags & CacheFlag.CACHE_SPEED) == 0 then
            PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
        end
    end
end