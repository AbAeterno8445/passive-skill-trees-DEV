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
            if tmpItem == CollectibleType.COLLECTIBLE_BREAKFAST and not PST:getTreeSnapshotMod("hallowedGroundProc", false) then
                tmpItem = CollectibleType.COLLECTIBLE_HALLOWED_GROUND
                PST:addModifiers({ hallowedGroundProc = true }, true)
            end
            if tmpItem ~= CollectibleType.COLLECTIBLE_BREAKFAST then
                return tmpItem
            end
        end
    end
end

---@param player EntityPlayer
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

    -- Ancient starcursed jewel: Crystallized Anamnesis
    if PST:SC_getSnapshotMod("crystallizedAnamnesis", false) and PST.specialNodes.SC_anamnesisItemPicked > 0 and charge == 0 then
        local tmpListType = "Other"
        if PST:poolHasCollectible(ItemPoolType.POOL_TREASURE, itemType) then
            tmpListType = "Treasure"
        elseif PST:poolHasCollectible(ItemPoolType.POOL_DEVIL, itemType) then
            tmpListType = "Devil"
        elseif PST:poolHasCollectible(ItemPoolType.POOL_ANGEL, itemType) then
            tmpListType = "Angel"
        end
        local tmpList = PST:getTreeSnapshotMod("SC_anamnesis" .. tmpListType, nil)
        if tmpList then
            table.insert(tmpList, itemType)

            -- Switch to grabbed item's state
            if PST.specialNodes.SC_anamnesisResetTimer == 0 then
                for pState, stateType in pairs(PST.anamnesisListTypes) do
                    if stateType == tmpListType then
                        PST:switchPurityState(pState)
                        break
                    end
                end
            end

            -- Grant a random passive angel item when collecting a devil item, and vice versa
            local tmpTypes = {
                {"Devil", ItemPoolType.POOL_ANGEL, "SC_anamnesisAngel"},
                {"Angel", ItemPoolType.POOL_DEVIL, "SC_anamnesisDevil"}
            }
            for _, typeCheck in ipairs(tmpTypes) do
                if tmpListType == typeCheck[1] then
                    local otherList = PST:getTreeSnapshotMod(typeCheck[3], nil)
                    if otherList then
                        local newItem = Game():GetItemPool():GetCollectible(typeCheck[2])
                        local newItemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                        local failsafe = 0
                        while ((newItemCfg and newItemCfg.Type ~= ItemType.ITEM_PASSIVE) or not newItemCfg or PST:arrHasValue(otherList, newItem) or newItem == CollectibleType.COLLECTIBLE_PURITY) and
                        failsafe < 200 do
                            newItem = Game():GetItemPool():GetCollectible(typeCheck[2])
                            newItemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                            failsafe = failsafe + 1
                        end
                        if newItem > 0 and failsafe < 200 then
                            table.insert(otherList, newItem)
                        end
                    end
                end
            end
        end
        PST.specialNodes.SC_anamnesisItemPicked = 0
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
    local tmpMod = PST:getTreeSnapshotMod("poopItemLuck", 0)
    if tmpMod > 0 and PST:arrHasValue(PST.poopItems, itemType) then
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
        tmpMod = PST:getTreeSnapshotMod("SC_chroniclerDebuff", 0)
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
    tmpMod = PST:getTreeSnapshotMod("jacobItemAllstats", 0)
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

    -- Chimeric Amalgam node (T. Lilith's tree)
    if PST:getTreeSnapshotMod("chimericAmalgam", false) and itemType == CollectibleType.COLLECTIBLE_BIRTHRIGHT and firstTime then
        PST:addModifiers({ damagePerc = -40, chimericAmalgamDmgBonus = { value = -40, set = true } }, true)

        for itemID, itemAmt in pairs(player:GetCollectiblesList()) do
            if itemAmt > 0 and PST:arrHasValue(PST.deliriumFamiliarItems, itemID) then
                for _=1,itemAmt do
                    player:RemoveCollectible(itemID)
                    player:AddCollectible(CollectibleType.COLLECTIBLE_LIL_DELIRIUM)
                end
            end
        end
    end

    -- Mod: +% all stats per familiar item
    tmpMod = PST:getTreeSnapshotMod("familiarItemAllstats", 0)
    if tmpMod > 0 and PST:arrHasValue(PST.deliriumFamiliarItems, itemType) then
        PST:updateCacheDelayed()
    end

    -- Reaper Wraiths node (T. Jacob's tree)
    if PST:getTreeSnapshotMod("reaperWraiths", false) and itemType == CollectibleType.COLLECTIBLE_BIRTHRIGHT then
        local darkEsauQuery = Isaac.FindByType(EntityType.ENTITY_DARK_ESAU, 0)
        if #darkEsauQuery == 1 then
            local tmpDarkEsau = darkEsauQuery[1]
            if tmpDarkEsau.SubType == 0 then
                local tmpDarkEsauAlt = Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, tmpDarkEsau.Position + Vector(10, 0), Vector.Zero, PST:getPlayer(), 1, Random() + 1)
                tmpDarkEsauAlt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
            end
        end
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
    local tmpMod = PST:getTreeSnapshotMod("poopItemLuck", 0)
    if tmpMod > 0 and PST:arrHasValue(PST.poopItems, type) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
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
    -- Recall
    elseif itemType == CollectibleType.COLLECTIBLE_RECALL then
        -- Recall! node (T. Forgotten's tree)
        if PST:getTreeSnapshotMod("forgRecall", false) then
            return currentMaxCharge + math.floor(math.min(4, PST:getTreeSnapshotMod("forgRecallUses", 0) * 0.4) * 30)
        end
    -- Anima Sola
    elseif itemType == CollectibleType.COLLECTIBLE_ANIMA_SOLA then
        -- Mod: +- Anima Sola's cooldown
        local tmpMod = PST:getTreeSnapshotMod("animaSolaCooldown", 0)
        if tmpMod ~= 0 then
            return currentMaxCharge + math.floor(tmpMod * 30)
        end
    end
end