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
    -- Intermittent Conceptions node (Isaac's tree)
    if PST:getTreeSnapshotMod("intermittentConceptions", false) then
        if type ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            else
                player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, 0, false)
            end
        end
    end

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
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
        -- Tainted Bethany, convert passive collectibles to Lemegeton wisps
        if charge == 0 then
            player:RemoveCollectible(type)
            player:AddItemWisp(type, player.Position)
        end
    end
end

function PST:onUseItem(itemType, RNG, player, useFlags, slot, customVarData)
    -- D6 use
    if itemType == CollectibleType.COLLECTIBLE_D6 then
        -- Magic Die node (Isaac's tree)
        if PST:getTreeSnapshotMod("magicDie", false) then
            local magicDieData = PST:getTreeSnapshotMod("magicDieData", nil)
            if magicDieData then
                local tmpRoomType = Game():GetRoom():GetType()
                if tmpRoomType == RoomType.ROOM_BOSS and magicDieData.source ~= "none" then
                    -- Boss room with existing buff, augment it by 3
                    magicDieData.value = magicDieData.value + 3
                else
                    if tmpRoomType == RoomType.ROOM_ANGEL then
                        -- Angel room buff
                        magicDieData.source = "angel"
                        magicDieData.value = 7
                    elseif tmpRoomType == RoomType.ROOM_DEVIL then
                        -- Devil room buff
                        magicDieData.source = "devil"
                        magicDieData.value = 6
                    elseif tmpRoomType == RoomType.ROOM_TREASURE or tmpRoomType == RoomType.ROOM_SHOP then
                        -- Treasure/Shop room buff
                        magicDieData.source = "treasure"
                        magicDieData.value = 7
                    elseif tmpRoomType == RoomType.ROOM_BOSS then
                        -- Boss room buff
                        magicDieData.source = "boss"
                        magicDieData.value = 3
                    else
                        -- Any other room buff
                        magicDieData.source = "boss"
                        magicDieData.value = 2
                    end
                end
                PST:save()
                Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_ALL, true)
            end
        end

        -- Mod: chance to spawn pickup when using D6
        if 100 * math.random() < PST:getTreeSnapshotMod("d6Pickup", 0) then
            local pickupType = { PickupVariant.PICKUP_COIN, PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB, PickupVariant.PICKUP_HEART }
            local randPickup = pickupType[math.random(#pickupType)]
            local tmpSubtype = 1
            if randPickup == PickupVariant.PICKUP_HEART then
                if 100 * math.random() < 70 then
                    tmpSubtype = HeartSubType.HEART_HALF
                elseif 100 * math.random() < 10 then
                    if 100 * math.random() < 70 then
                        tmpSubtype = HeartSubType.HEART_HALF_SOUL
                    else
                        tmpSubtype = HeartSubType.HEART_SOUL
                    end
                end
            end
            -- Very rarely spawn a chest/locked chest
            if 100 * math.random() < 5 then
                if 100 * math.random() < 90 then
                    randPickup = PickupVariant.PICKUP_CHEST
                else
                    randPickup = PickupVariant.PICKUP_LOCKEDCHEST
                end
            end
            Game():Spawn(EntityType.ENTITY_PICKUP, randPickup, player.Position, Vector.Zero, nil, tmpSubtype, Random() + 1)
        end

        -- Mod: chance to keep half the charge when using D6
        if 100 * math.random() < PST:getTreeSnapshotMod("d6HalfCharge", 0) then
            if player:GetBatteryCharge(slot) == 0 then
                SFXManager():Play(SoundEffect.SOUND_BEEP, 1)
                player:SetActiveCharge(player:GetActiveCharge(slot) + math.ceil(player:GetActiveMaxCharge(slot) / 2), slot)
            end
        end
    end

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
        -- Tainted Cain, detect craft from Bag of Crafting
        if itemType == CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING then
            local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
            if cosmicRCache.TCainBag then
                cosmicRCache.TCainUses = cosmicRCache.TCainUses + 1
                PST:save()
            end
        end
    end

    -- Cosmic Realignment tainted unlock on red key home
    if itemType == CollectibleType.COLLECTIBLE_RED_KEY and Game():GetLevel():GetStage() == LevelStage.STAGE8 then
        local cosmicRChar = PST:getTreeSnapshotMod("cosmicRealignment", false)
        if type(cosmicRChar) == "number" and Isaac.GetPlayer():GetPlayerType() ~= cosmicRChar then
            local taintedUnlock = PST.cosmicRData.characters[cosmicRChar].unlocks.tainted
            if taintedUnlock ~= nil then
                PST:cosmicRTryUnlock("tainted")
            end
        end
    end
end