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
        if player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER and
        player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B then
            local totalHP = player:GetMaxHearts() + player:GetSoulHearts() + player:GetBlackHearts() + player:GetRottenHearts()
            player:AddMaxHearts(-player:GetMaxHearts())
            player:AddSoulHearts(-player:GetSoulHearts())
            player:AddBlackHearts(-player:GetBlackHearts())
            player:AddRottenHearts(-player:GetRottenHearts())
            player:AddBoneHearts(math.floor(totalHP / 2))
            player:SetFullHearts()
        end
    end

    PST:closeTreeMenu(true)
end