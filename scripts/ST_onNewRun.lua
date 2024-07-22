function PST:onNewRun(isContinued)
    if isContinued then
        return
    end

    -- Mods that are mutable before beginning a run should be set here
    local keptMods = {
        ["Cosmic Realignment"] = { cosmicRealignment = PST.modData.treeMods.cosmicRealignment }
    }
    -- Get snapshot of tree modifiers
    PST:resetMods()
    for nodeID, node in pairs(PST.trees["global"]) do
        if PST.modData.treeNodes["global"][nodeID] then
            local kept = false
            for keptName, keptVal in pairs(keptMods) do
                if node.name == keptName then
                    PST:addModifiers(keptVal)
                    kept = true
                    break
                end
            end
            if not kept then
                PST:addModifiers(node.modifiers)
            end
        end
    end
    local currentChar = PST.charNames[1 + PST.selectedMenuChar]
    if PST.trees[currentChar] ~= nil then
        for nodeID, node in pairs(PST.trees[currentChar]) do
            if PST.modData.treeNodes[currentChar][nodeID] then
                PST:addModifiers(node.modifiers)
            end
        end
    end

    local player = Isaac.GetPlayer()

    PST.modData.treeModSnapshot = PST.modData.treeMods
    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    PST:save()

    local itemPool = Game():GetItemPool()
    local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC) then
        -- Isaac, -0.1 all stats
        PST:addModifiers({ allstats = -0.1 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN) then
        -- Cain, -0.5 luck
        PST:addModifiers({ luck = -0.5 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS) then
        -- Judas, -10% damage
        PST:addModifiers({ damagePerc = -10 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_AZAZEL) then
        -- Azazel, -20% range
        PST:addModifiers({ rangePerc = -20 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS) then
        -- Lazarus, remove items that give extra lives
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_1UP)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_DEAD_CAT)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_INNER_CHILD)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_GUPPYS_COLLAR)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_ANKH)
        itemPool:RemoveTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
        itemPool:RemoveTrinket(TrinketType.TRINKET_MISSING_POSTER)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST) then
        -- The Lost, if Holy Mantle is unlocked, start with Wafer
        if Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_WAFER)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
        -- Lilith, remove incubus
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_INCUBUS)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
        -- The Forgotten, convert starting hearts to bone hearts (not on Keepers)
        if not isKeeper then
            local totalHP = player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts()
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddBoneHearts(math.floor(totalHP / 2))
            player:SetFullHearts()
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB) then
        -- Jacob & Esau, apply -50% xp gain
        PST:addModifiers({ xpgain = -50 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
        -- Tainted Cain, begin with Bag of Crafting if unlocked
        if Isaac.GetPersistentGameData():Unlocked(Achievement.BAG_OF_CRAFTING) then
            player:AddCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
        -- Tainted Judas, set starting health to 2 black hearts
        if not isKeeper then
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddBoneHearts(-player:GetBoneHearts())
            player:AddBlackHearts(4)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY_B) then
        -- Tainted ???, convert starting hearts to soul hearts
        if not isKeeper then
            local totalHP = player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetBoneHearts() * 2
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddSoulHearts(totalHP)
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_EVE_B) then
        -- Tainted Eve, -33% fire rate
        PST:addModifiers({ tearsPerc = -33 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
        -- Tainted Lazarus, setup first health bank
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
        cosmicRCache.TLazarusBank1.red = player:GetHearts()
        cosmicRCache.TLazarusBank1.max = player:GetMaxHearts()
        cosmicRCache.TLazarusBank1.soul = player:GetSoulHearts()
        cosmicRCache.TLazarusBank1.black = player:GetBlackHearts()
        cosmicRCache.TLazarusBank1.bone = player:GetBoneHearts()
        cosmicRCache.TLazarusBank1.rotten = player:GetRottenHearts()
        cosmicRCache.TLazarusBank1.broken = player:GetBrokenHearts()
        cosmicRCache.TLazarusBank1.eternal = player:GetEternalHearts()
        PST:save()
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
        -- Tainted Lost, remove Wafer and Holy Mantle
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_WAFER)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH_B) then
        -- Tainted Lilith, -1 tears, range and shot speed
        PST:addModifiers({ tears = -1, range = -1, shotSpeed = -1 }, true)
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
        -- Tainted Keeper, start with Restock
        player:AddCollectible(CollectibleType.COLLECTIBLE_RESTOCK)
    end

    PST:closeTreeMenu(true)
end