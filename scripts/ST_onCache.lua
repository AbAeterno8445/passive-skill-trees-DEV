local function tearsUp(firedelay, newValue)
    local newTears = 30 / (firedelay + 1) + newValue
    return math.max((30 / newTears) - 1, -0.75)
end

-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function PST:onCache(player, cacheFlag)
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

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- TEARS (MaxFireDelay)
        local tmpMod = PST:getTreeSnapshotMod("tears", 0) + dynamicMods.tears + allstats
        local tmpMult = 1 - allstatsPerc / 100
        tmpMult = tmpMult - PST:getTreeSnapshotMod("tearsPerc", 0) / 100
        tmpMult = tmpMult - dynamicMods.tearsPerc / 100
        player.MaxFireDelay = tearsUp(player.MaxFireDelay, tmpMod) * math.max(0.05, tmpMult)

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

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        -- RANGE
        local tmpMod = PST:getTreeSnapshotMod("range", 0) + dynamicMods.range + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("rangePerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.rangePerc / 100
        player.TearRange = (player.TearRange + tmpMod * 40) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        -- SHOT SPEED
        local tmpMod = PST:getTreeSnapshotMod("shotSpeed", 0) + dynamicMods.shotSpeed + allstats
        local tmpMult = 1 + allstatsPerc / 200
        tmpMult = tmpMult + PST:getTreeSnapshotMod("shotSpeedPerc", 0) / 200
        tmpMult = tmpMult + dynamicMods.shotSpeedPerc / 200
        player.ShotSpeed = (player.ShotSpeed + tmpMod / 2) * math.max(0.05, tmpMult)

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

        -- Ancient starcursed jewel: Cursed Auric Shard
	    if PST:getTreeSnapshotMod("SC_cursedAuricSpeedProc", false) and player.MoveSpeed < 1.6 and PST:getRoom():GetAliveEnemiesCount() == 0 then
            -- Minimum speed becomes 1.6 in cleared rooms after defeating floor boss
            player.MoveSpeed = 1.6
        end
    end
end