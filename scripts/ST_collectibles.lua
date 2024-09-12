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
        local floor = PST:getLevel():GetStage()
        if PST:getRoom():GetType() == RoomType.ROOM_TREASURE and (floor == 1 or (floor > 1 and 100 * math.random() < 50)) then
            local tmpItem = itemPool:GetCollectibleFromList(PST.poopItems, Random() + 1, CollectibleType.COLLECTIBLE_BREAKFAST, true, false)
            if tmpItem ~= CollectibleType.COLLECTIBLE_BREAKFAST then
                return tmpItem
            end
        end
    end
end

function PST:onGrabCollectible(itemType, charge, firstTime, slot, varData, player)
    if not PST.gameInit then return end

    -- Ancient starcursed jewel: Umbra
    if PST:SC_getSnapshotMod("umbra", false) and itemType == CollectibleType.COLLECTIBLE_NIGHT_LIGHT then
        local tmpMod = PST:getTreeSnapshotMod("SC_umbraStatsDown", 0)
        if tmpMod > 0 then
            PST:addModifiers({ allstatsPerc = tmpMod, SC_umbraStatsDown = { value = 0, set = true } }, true)
        end
    end

    -- Ancient starcursed jewel: Iridescent Purity
    if PST:SC_getSnapshotMod("iridescentPurity", false) then
        if not PST:arrHasValue(PST.progressionItems) then
            local iridescentItems = PST:getTreeSnapshotMod("SC_iridescentItems", nil)
            if iridescentItems then
                table.insert(iridescentItems, itemType)
            end
        end
    end

    -- Intermittent Conceptions node (Isaac's tree)
    if PST:getTreeSnapshotMod("intermittentConceptions", false) then
        if itemType ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT and charge == 0 then
            PST:addModifiers({ intermittentProc = 1 }, true)
            if PST:getTreeSnapshotMod("intermittentProc", 0) >= 2 then
                PST:addModifiers({ intermittentProc = { value = 0, set = true }}, true)
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                    player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                end
            end
        end
    end

    -- Mod: +luck per held poop item - update player
    if PST:arrHasValue(PST.poopItems, itemType) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
    end

    -- Mod: +random stat when collecting a treasure/shop room item
    if firstTime then
        local roomType = PST:getRoom():GetType()
        local tmpBonus = PST:getTreeSnapshotMod("treasureShopItemStat", 0)
        local tmpBonusPerc = PST:getTreeSnapshotMod("treasureShopItemStatPerc", 0)
        if (roomType == RoomType.ROOM_TREASURE or roomType == RoomType.ROOM_SHOP) and (tmpBonus ~= 0 or tmpBonusPerc ~= 0) then
            local tmpStat = PST:getRandomStat()
            PST:addModifiers({
                [tmpStat] = tmpBonus,
                [tmpStat .. "Perc"] = tmpBonusPerc
            }, true)
        -- Mod: +random stat when collecting a devil/angel/boss room item
        elseif roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_ANGEL or roomType == RoomType.ROOM_BOSS then
            tmpBonus = PST:getTreeSnapshotMod("devilAngelBossItemStat", 0)
            tmpBonusPerc = PST:getTreeSnapshotMod("devilAngelBossItemStatPerc", 0)
            if tmpBonus ~= 0 or tmpBonusPerc ~= 0 then
                local tmpStat = PST:getRandomStat()
                PST:addModifiers({
                    [tmpStat] = tmpBonus,
                    [tmpStat .. "Perc"] = tmpBonusPerc
                }, true)
            end
        end

        -- Mod: +- luck when first obtaining any passive item
        tmpBonus = PST:getTreeSnapshotMod("itemRandLuck", 0)
        if tmpBonus ~= 0 then
            PST:addModifiers({ luck = -tmpBonus + tmpBonus * 2 * math.random() }, true)
        end

        -- Ancient starcursed jewel: Chronicler Stone (halve debuff when first grabbing a book item)
        local tmpMod = PST:getTreeSnapshotMod("SC_chroniclerDebuff", 0)
        if tmpMod > 0 and PST:arrHasValue(PST.bookItems, itemType) then
            PST:addModifiers({ allstatsPerc = tmpMod / 2, SC_chroniclerDebuff = -tmpMod / 2 }, true)
        end
    end

    -- Spectral Advantage node (The Lost's tree)
    if PST:getTreeSnapshotMod("spectralAdvantage", false) then
        if itemType == CollectibleType.COLLECTIBLE_BIRTHRIGHT then
            PST:addModifiers({ tearsPerc = 8 }, true)
        else
            local tmpTotal = PST:getTreeSnapshotMod("spectralAdvantageHearts", 0)
            if tmpTotal < 20 then
                for tmpItemType, heartsGiven in pairs(PST.heartUpItems) do
                    if itemType == tmpItemType then
                        PST:addModifiers({
                            damagePerc = math.min(2 * heartsGiven, 40 - tmpTotal * 2),
                            luck = math.min(0.15 * heartsGiven, 3 - tmpTotal * 0.15),
                            spectralAdvantageHearts = 1
                        }, true)
                        break
                    end
                end
            end
        end
    end

    -- Mod: +% all stats per item obtained by the opposing brother, up to 15%
    local tmpMod = PST:getTreeSnapshotMod("jacobItemAllstats", 0)
    if tmpMod ~= 0 and player:GetOtherTwin() then
        player:AddCacheFlags(PST.allstatsCache, true)
        player:GetOtherTwin():AddCacheFlags(PST.allstatsCache, true)
    end

    -- Mod: +stat when first obtaining an item
    local itemConfig = Isaac.GetItemConfig():GetCollectible(itemType)
    if firstTime and itemConfig and itemConfig.Type ~= ItemType.ITEM_ACTIVE then
        local tmpAdd = {}
        tmpMod = PST:getTreeSnapshotMod("firstItemDamage", 0)
        if tmpMod ~= 0 then tmpAdd["damage"] = tmpMod end

        tmpMod = PST:getTreeSnapshotMod("firstItemTears", 0)
        if tmpMod ~= 0 then tmpAdd["tears"] = tmpMod end

        tmpMod = PST:getTreeSnapshotMod("firstItemRange", 0)
        if tmpMod ~= 0 then tmpAdd["range"] = tmpMod end

        tmpMod = PST:getTreeSnapshotMod("firstItemSpeed", 0)
        if tmpMod ~= 0 then tmpAdd["speed"] = tmpMod end

        tmpMod = PST:getTreeSnapshotMod("firstItemShotspeed", 0)
        if tmpMod ~= 0 then tmpAdd["shotSpeed"] = tmpMod end

        tmpMod = PST:getTreeSnapshotMod("firstItemLuck", 0)
        if tmpMod ~= 0 then tmpAdd["luck"] = tmpMod end

        if next(tmpAdd) ~= nil then
            PST:addModifiers(tmpAdd, true)
        end
    end

    -- Consuming Void node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("consumingVoid", false) and charge == 0 then
        if PST:isTIsaacInvFull() and not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and not PST:getTreeSnapshotMod("consumingVoidSpawned", false) then
            local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
            local voidItem = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_VOID, Random() + 1)
            ---@diagnostic disable-next-line: undefined-field
            voidItem:ToPickup():RemoveCollectibleCycle()
            PST:addModifiers({ consumingVoidSpawned = true }, true)
        end
    end

    -- Vacuophobia node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("vacuophobia", false) then
        PST:updateCacheDelayed()
    end

    -- Absolute Rage node (T. Samson's tree)
    if PST:getTreeSnapshotMod("absoluteRage", false) and itemType == CollectibleType.COLLECTIBLE_BIRTHRIGHT and not PST:getTreeSnapshotMod("absoluteRageBirthright", false) then
        PST:addModifiers({ berserkDmg = 35, berserkSpeed = 25, absoluteRageBirthright = true }, true)
    end

    -- Cosmic Realignment node
    local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
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
        if PST:arrHasValue(PST.babyFamiliarItems, itemType) then
            local playerCollectibles = player:GetCollectiblesList()
            local familiarCount = 0
            for _, tmpType in ipairs(PST.babyFamiliarItems) do
                familiarCount = familiarCount + playerCollectibles[tmpType]
            end
            if familiarCount > 0 then
                tmpMod = 1 / (2 ^ familiarCount)
                PST:addModifiers({ tears = tmpMod, range = tmpMod, shotSpeed = tmpMod }, true)
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON_B) then
        -- Tainted Apollyon, spawn a locust familiar tied to the grabbed collectible
        if firstTime then
            player:AddLocust(itemType, player.Position)
            cosmicRCache.TApollyonLocusts = cosmicRCache.TApollyonLocusts + 1
            PST:save()
            player:AddCacheFlags(PST.allstatsCache, true)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY_B) then
        -- Tainted Bethany, convert passive collectibles to Lemegeton wisps
        if charge == 0 then
            player:RemoveCollectible(itemType)
            player:AddItemWisp(itemType, player.Position)
        end
    end
end

function PST:onRemoveCollectible(player, type)
    -- Mod: +luck per held poop item - update player
    if PST:arrHasValue(PST.poopItems, type) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
    end
end

function PST:onUseItem(itemType, RNG, player, useFlags, slot, customVarData)
    -- D6
    if itemType == CollectibleType.COLLECTIBLE_D6 then
        -- Magic Die node (Isaac's tree)
        if PST:getTreeSnapshotMod("magicDie", false) then
            local magicDieData = PST:getTreeSnapshotMod("magicDieData", nil)
            if magicDieData then
                local tmpRoomType = PST:getRoom():GetType()
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
                player:AddCacheFlags(PST.allstatsCache, true)
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
                player:AddActiveCharge(math.ceil(player:GetActiveMaxCharge(slot) / 2), slot, true, true, false)
            end
        end
    -- Yum Heart
    elseif itemType == CollectibleType.COLLECTIBLE_YUM_HEART then
        -- Crystal Heart node (Magdalene's tree)
        if PST:getTreeSnapshotMod("crystalHeart", false) then
            player:AddHearts(1)
            if 100 * math.random() < 4 and player:GetMaxHearts() > 2 then
                player:AddMaxHearts(-2)
                player:AddBoneHearts(1)
                player:AddHearts(2)
            end
        end

        -- Mod: chance for Yum Heart to heal an additional 1/2 red heart
        if 100 * math.random() < PST:getTreeSnapshotMod("yumHeartHealHalf", 0) then
            player:AddHearts(1)
        end
    -- Book of Belial
    elseif itemType == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL then
        -- Dark Heart node (Judas' tree)
        if PST:getTreeSnapshotMod("darkHeart", false) and not PST:getTreeSnapshotMod("darkHeartBelial", false) then
            PST:addModifiers({ darkHeartBelial = true }, true)
        end
    -- The Poop
    elseif itemType == CollectibleType.COLLECTIBLE_POOP then
        -- Brown Blessing node (Blue Baby's tree)
        if PST:getTreeSnapshotMod("brownBlessing", false) and not PST:isFirstOrigStage() and 100 * math.random() < 7 then
            local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
            local tmpPoopItem = Game():GetItemPool():GetCollectibleFromList(PST.poopItems, Random() + 1, CollectibleType.COLLECTIBLE_BREAKFAST, true, false)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, tmpPoopItem, Random() + 1)
        end

        -- Mod: +all stats when using the poop (once per room)
        local poopAllStats = PST:getTreeSnapshotMod("thePoopAllStats", 0)
        local poopAllStatsPerc = PST:getTreeSnapshotMod("thePoopAllStatsPerc", 0)
        if (poopAllStats > 0 or poopAllStatsPerc > 0) and not PST:getTreeSnapshotMod("poopAllStatsProc") then
            PST:addModifiers({
                allstats = poopAllStats,
                allstatsPerc = poopAllStatsPerc,
                poopAllStatsProc = true
            }, true)
        end
    -- Eternal D6
    elseif itemType == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
        -- Mod: chance for Eternal D6 to not consume charges on use
        if 100 * math.random() < PST:getTreeSnapshotMod("eternalD6Charge", 0) then
            player:AddActiveCharge(player:GetActiveMaxCharge(slot), slot, true, true, false)
        end
    -- Box of Friends
    elseif itemType == CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS then
        -- Minion Maneuvering node (Lilith's tree)
        if PST:getTreeSnapshotMod("minionManeuvering", false) then
            PST.specialNodes.minionManeuveringMaxBonus = 30
            player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
        end

        -- Mod: chance for Box of Friends to keep 1 charge on use
        if 100 * math.random() < PST:getTreeSnapshotMod("boxOfFriendsCharge", 0) then
            if player:GetBatteryCharge(slot) == 0 then
                player:AddActiveCharge(1, slot, true, true, false)
            end
        end

        -- Mod: +all stats when using Box of Friends
        local tmpStats = PST:getTreeSnapshotMod("boxOfFriendsAllStats", 0)
        if tmpStats > 0 and not PST:getTreeSnapshotMod("boxOfFriendsAllStatsProc", 0) then
            PST:addModifiers({ allstats = tmpStats, boxOfFriendsAllStatsProc = true }, true)
        end
    -- Wooden Nickel
    elseif itemType == CollectibleType.COLLECTIBLE_WOODEN_NICKEL then
        -- Keeper's Blessing node (Keeper's tree)
        if PST:getTreeSnapshotMod("keeperBlessing", false) and 100 * math.random() < 20 then
            local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_PENNY, Random() + 1)
        end
    -- Void
    elseif itemType == CollectibleType.COLLECTIBLE_VOID then
        -- Apollyon's Blessing node (Apollyon's tree)
        if PST:getTreeSnapshotMod("apollyonBlessing", false) and 100 * math.random() < 40 then
            if player:GetBatteryCharge(slot) == 0 then
                player:AddActiveCharge(math.ceil(player:GetActiveMaxCharge(slot) / 2), slot, true, true, false)
            end
        end

        -- Harbinger Locusts node (Apollyon's tree)
        if PST:getTreeSnapshotMod("harbingerLocusts", false) then
            local consumedLocust = false
            for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_TRINKET then
                    if PST:arrHasValue(PST.locustTrinkets, tmpEntity.SubType &~ TrinketType.TRINKET_GOLDEN_FLAG) then
                        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, 0)
                        tmpEntity:Remove()
                        player:AddSmeltedTrinket(tmpEntity.SubType)
                        PST:addModifiers({ luck = PST:getTreeSnapshotMod("locustConsumedLuck", 0) }, true)
                        consumedLocust = true
                    end
                end
            end
            if consumedLocust then
                player:AddCacheFlags(PST.allstatsCache, true)
            end
        end

        -- Mod: chance for Void to spawn 4 blue flies on use
        if 100 * math.random() < PST:getTreeSnapshotMod("voidBlueFlies", 0) then
            for _=1,4 do
                Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, nil, 0, Random() + 1)
            end
        end

        -- Mod: chance for Void to spawn 3 blue spiders on use
        if 100 * math.random() < PST:getTreeSnapshotMod("voidBlueSpiders", 0) then
            for _=1,3 do
                Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, player.Position, Vector.Zero, nil, 0, Random() + 1)
            end
        end

        -- Mod: chance for Void to instantly kill a random non-boss enemy in the room
        if 100 * math.random() < PST:getTreeSnapshotMod("voidAnnihilation", 0) then
            local tmpEnemies = {}
            for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() and not tmpEntity:IsBoss() then
                    table.insert(tmpEnemies, tmpEntity)
                end
            end
            if #tmpEnemies > 0 then
                tmpEnemies[math.random(#tmpEnemies)]:Die()
            end
        end
    -- Siren's Song
    elseif itemType == Isaac.GetItemIdByName("Siren Song") then
        -- Dark Songstress node (Siren's tree)
        if PST:getTreeSnapshotMod("darkSongstress", false) and not PST:getTreeSnapshotMod("darkSongstressActive", false) then
            PST:addModifiers({ damagePerc = 8, speedPerc = 8, darkSongstressActive = true }, true)
        end

        -- Song of Fortune node (Siren's tree) [Harmonic modifier]
        if PST:getTreeSnapshotMod("songOfFortune", false) and PST:songNodesAllocated(true) <= 2 and 100 * math.random() < 15 then
            PST:addModifiers({ luck = 0.05 }, true)
        end

        -- Song of Awe node (Siren's tree)
        if PST:getTreeSnapshotMod("songOfAwe", false) then
            if not PST:getTreeSnapshotMod("songOfAweActive", false) then
                PST:addModifiers({ allstatsPerc = 4, songOfAweActive = true }, true)
            end

            -- Slow enemies [Harmonic modifier]
            if PST:songNodesAllocated(true) <= 2 then
                for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                    if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() then
                        tmpEntity:AddSlowing(EntityRef(player), 60, 0.1, Color(0.8, 0.8, 0.8, 1, 0, 0))
                    end
                end
            end
        end

        -- Overwhelming Voice node (Siren's tree)
        if PST:getTreeSnapshotMod("overwhelmingVoice", false) then
            PST.specialNodes.overwhelmingVoiceProc = true
        end
    -- D12
    elseif itemType == CollectibleType.COLLECTIBLE_D12 then
        local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", {})
        for entID, _ in pairs(staticEntCache) do
            local level = PST:getLevel()
            local stage = level:GetStage()
            local roomID = level:GetCurrentRoomDesc().SafeGridIndex
            if PST:strStartsWith(entID, tostring(stage) .. "." .. tostring(roomID)) then
                staticEntCache[entID] = -1
            end
        end
    -- D7
    elseif itemType == CollectibleType.COLLECTIBLE_D7 then
        PST:addModifiers({ d7Proc = true }, true)
    -- Red Key
    elseif itemType == CollectibleType.COLLECTIBLE_RED_KEY then
        local room = PST:getRoom()
        -- Mod: chance to turn adjacent curse room spiked door into a regular one
        if PST:getTreeSnapshotMod("curseRoomSpikesOutProc", false) then
            for i=0,7 do
                local tmpDoor = room:GetDoor(i)
                if tmpDoor then
                    if room:GetType() == RoomType.ROOM_CURSE then
                        tmpDoor:SetRoomTypes(RoomType.ROOM_DEFAULT, tmpDoor.TargetRoomType)
                    elseif tmpDoor.TargetRoomType == RoomType.ROOM_CURSE then
                        tmpDoor:SetRoomTypes(room:GetType(), RoomType.ROOM_DEFAULT)
                    end
                end
            end
        end
    -- Anarchist's Cookbook
    elseif itemType == CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK then
        PST.specialNodes.trollBombDisarmDebuffTimer = 45
    -- Bag of Crafting
    elseif itemType == CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING then
        PST.specialNodes.craftBagSnapshot = player:GetBagOfCraftingContent()
    -- Dark Arts
    elseif itemType == CollectibleType.COLLECTIBLE_DARK_ARTS then
        -- Dark Expertise node (T. Judas' tree)
        if PST:getTreeSnapshotMod("darkExpertise", false) then
            Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
        end

        -- Anarchy node (T. Judas' tree)
        if PST:getTreeSnapshotMod("anarchy", false) then
            PST.specialNodes.trollBombDisarmDebuffTimer = 45
        end

        -- Mod: +% tears for 2 seconds after using Dark Arts
        local tmpMod = PST:getTreeSnapshotMod("darkArtsTears", 0)
        if tmpMod > 0 and PST.specialNodes.darkArtsTearsTimer == 0 then
            PST.specialNodes.darkArtsTearsTimer = 75
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        end

        PST.specialNodes.darkArtsBossHitProc = false
    -- How to Jump
    elseif itemType == CollectibleType.COLLECTIBLE_HOW_TO_JUMP then
        -- Mod: dark pulse when landing with How to Jump
        local tmpMod = PST:getTreeSnapshotMod("howToJumpPulse", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            PST.specialNodes.howToJumpPulseTimer = 15
        end
    -- Hold
    elseif itemType == CollectibleType.COLLECTIBLE_HOLD then
        local poopHeld = player:GetActiveItemDesc(slot).VarData
        local poopRegainProc = false

        -- Mod: chance to regain the held poop on use
        local tmpMod = PST:getTreeSnapshotMod("holdPoopRegain", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod and PST.specialNodes.poopHeld > 0 then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_HOLD)
            player:AddCollectible(CollectibleType.COLLECTIBLE_HOLD, 0, false, slot, PST.specialNodes.poopHeld)
            SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE)
            poopRegainProc = true
        end

        -- Emptying Hold i.e. triggering poop usage
        if poopHeld == 0 then
            -- Mod: chance to trigger Brown Nugget's effect when using Hold
            tmpMod = PST:getTreeMod("holdBrownNugget", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("holdBrownNuggetProcs", 0) < 5 and 100 * math.random() < tmpMod then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_BROWN_NUGGET, UseFlag.USE_NOANIM)
                PST:addModifiers({ holdBrownNuggetProcs = 1 }, true)
            end
        end

        if not poopRegainProc then
            PST.specialNodes.poopHeld = poopHeld

            -- Cache-updating hold nodes
            if PST:getTreeSnapshotMod("treasuredWaste", false) or PST:getTreeSnapshotMod("holdEmptySpeed", 0) > 0 or PST:getTreeSnapshotMod("holdFullLuck", 0) > 0 then
                PST:updateCacheDelayed()
            end
        end
    -- Sumptorium
    elseif itemType == CollectibleType.COLLECTIBLE_SUMPTORIUM then
        -- Mod: +% damage per absorbed red clot for the current room
        local tmpMod = PST:getTreeSnapshotMod("redClotAbsorbDmg", 0)
        if tmpMod > 0 then
            local redClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0)
            if #redClots > 0 then
                local totalBuff = tmpMod * #redClots
                PST:addModifiers({ damagePerc = totalBuff, redClotAbsorbBuff = totalBuff }, true)
            end
        end

        -- Mod: +% tears per absorbed soul clot for the current room
        tmpMod = PST:getTreeSnapshotMod("soulClotAbsorbTears", 0)
        if tmpMod > 0 then
            local soulClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 1)
            if #soulClots > 0 then
                local totalBuff = tmpMod * #soulClots
                PST:addModifiers({ tearsPerc = totalBuff, soulClotAbsorbBuff = totalBuff }, true)
            end
        end
    -- Suplex!
    elseif itemType == CollectibleType.COLLECTIBLE_SUPLEX then
        if not PST:getTreeSnapshotMod("absoluteRage", false) and PST:isBerserk() then
            local berserkEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		    if berserkEffect and berserkEffect.Cooldown <= 60 then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_SUPLEX)
                PST:addModifiers({ violentMarauderRemoved = true }, true)
            end
        end
    end

    -- Mod: chance to spawn a regular wisp when using your active item
    if 100 * math.random() < PST:getTreeSnapshotMod("activeItemWisp", 0) then
        Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, player.Position, Vector.Zero, nil, 0, Random() + 1)
    end

    -- Cosmic Realignment tainted unlock on red key home
    if itemType == CollectibleType.COLLECTIBLE_RED_KEY and PST:getLevel():GetStage() == LevelStage.STAGE8 then
        local cosmicRChar = PST:getTreeSnapshotMod("cosmicRealignment", false)
        if type(cosmicRChar) == "number" and player:GetPlayerType() ~= cosmicRChar then
            local taintedUnlock = PST.cosmicRData.characters[cosmicRChar].unlocks.tainted
            if taintedUnlock ~= nil then
                PST:cosmicRTryUnlock("tainted")
            end
        end
    end
end

-- Active item charge overrides
function PST:getActiveMaxCharge(itemType, player, varData, currentMaxCharge)
    -- Dark Arts
    if itemType == CollectibleType.COLLECTIBLE_DARK_ARTS then
        -- Mod: +- Dark Arts' cooldown
        local tmpMod = PST:getTreeSnapshotMod("darkArtsCD", 0)
        if tmpMod ~= 0 then
            return currentMaxCharge + math.floor(tmpMod * 30)
        end
    -- Suplex!
    elseif itemType == CollectibleType.COLLECTIBLE_SUPLEX then
        -- Mod: +- Suplex's cooldown
        local tmpMod = PST:getTreeSnapshotMod("suplexCooldown", 0)
        if tmpMod ~= 0 then
            return currentMaxCharge + math.floor(tmpMod * 30)
        end
    end
end