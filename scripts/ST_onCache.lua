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
    if tmpTreeMod and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
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
            local hasTrinket = false
            for _, tmpTrinket in ipairs(PST.poopTrinkets) do
                if player:GetTrinket(0) == tmpTrinket or player:GetTrinket(1) == tmpTrinket then
                    hasTrinket = true
                    break
                end
            end
            if hasTrinket then
                dynamicMods.luck = dynamicMods.luck + tmpTreeMod
            end
        end
    elseif cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- Hearty node (Samson's tree)
        if PST:getTreeSnapshotMod("hearty", false) then
            dynamicMods.damagePerc = dynamicMods.damagePerc - 1.5 * player:GetHearts()
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
        player.Damage = (player.Damage + tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- TEARS (MaxFireDelay)
        local tmpMod = PST:getTreeSnapshotMod("tears", 0) + dynamicMods.tears + allstats
        local tmpMult = 1 - allstatsPerc / 100
        tmpMult = tmpMult - PST:getTreeSnapshotMod("tearsPerc", 0) / 100
        tmpMult = tmpMult - dynamicMods.tearsPerc / 100
        player.MaxFireDelay = (player.MaxFireDelay - tmpMod * 3.5) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        -- LUCK
        local tmpMod = PST:getTreeSnapshotMod("luck", 0) + dynamicMods.luck + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("luckPerc", 0) / 100
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
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + PST:getTreeSnapshotMod("shotSpeedPerc", 0) / 100
        tmpMult = tmpMult + dynamicMods.shotSpeedPerc / 100
        player.ShotSpeed = (player.ShotSpeed + tmpMod) * math.max(0.05, tmpMult)

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
        player.MoveSpeed = (baseSpeed + tmpMod) * math.max(0.05, tmpMult)
    end
end