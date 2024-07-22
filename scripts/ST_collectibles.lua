function PST:onRollCollectible(selected, itemPoolType, decrease, seed)
    local itemPool = Game():GetItemPool()

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
        -- Lilith, 75% chance to reroll follower items
        if 100 * math.random() <= 75 then
            if PST:arrHasValue(PST.babyFamiliarItems, selected) then
                return itemPool:GetCollectible(itemPool:GetLastPool())
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY_B) then
        -- Tainted ???, first floor treasure room guarantees a poop item, second floor onwards is a 50% chance
        local floor = Game():GetLevel():GetStage()
        local room = Game():GetRoom()
        if room:GetType() == RoomType.ROOM_TREASURE and (floor == 1 or (floor > 1 and 100 * math.random() < 50)) then
            local tmpItem = itemPool:GetCollectibleFromList(PST.poopItems, Random(), CollectibleType.COLLECTIBLE_BREAKFAST, true, false)
            if tmpItem ~= CollectibleType.COLLECTIBLE_BREAKFAST then
                return tmpItem
            end
        end
    end
end

function PST:onGrabCollectible(type, charge, firstTime, slot, varData, player)
    -- Cosmic Realignment node
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
    if PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON) then
        -- Apollyon, -0.04 to a random stat (except speed) when picking up a passive item
        if charge == 0 then
            local randomStat = PST:getRandomStat({"speed"})
            PST:addModifiers({ [randomStat] = -0.04 }, true)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB) then
        -- Jacob & Esau, reduce debuff when first obtaining an item, up to 8 times
        if firstTime then
            if cosmicRCache.jacobProcs < 8 then
                cosmicRCache.jacobProcs = cosmicRCache.jacobProcs + 1
            end
            PST:addModifiers({ xpgain = 50 / (2 ^ cosmicRCache.jacobProcs) }, true)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH_B) then
        -- Tainted Lilith, reduce debuff when obtaining a baby familiar
        if PST:arrHasValue(PST.babyFamiliarItems, type) then
            local playerCollectibles = player:GetCollectiblesList()
            local familiarCount = 0
            for _, tmpType in ipairs(PST.babyFamiliarItems) do
                familiarCount = familiarCount + playerCollectibles[tmpType]
            end
            if familiarCount > 0 then
                local tmpMod = 1 / (2 ^ familiarCount)
                PST:addModifiers({ tears = tmpMod, range = tmpMod, shotSpeed = tmpMod }, true)
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON_B) then
        -- Tainted Apollyon, spawn a locust familiar tied to the grabbed collectible
        if firstTime then
            player:AddLocust(type, player.Position)
            cosmicRCache.TApollyonLocusts = cosmicRCache.TApollyonLocusts + 1
            PST:save()
            player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        end
    end
end

function PST:onUseItem(type)
    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
        -- Tainted Cain, detect craft from Bag of Crafting
        if type == CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING then
            local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
            if cosmicRCache.TCainBag then
                cosmicRCache.TCainUses = cosmicRCache.TCainUses + 1
                PST:save()
            end
        end
    end
end