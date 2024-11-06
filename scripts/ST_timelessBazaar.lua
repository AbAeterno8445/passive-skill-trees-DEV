local failsafeCap = 1000

local itemCosts = {
    [0] = { SP = 1, obols = 40 },
    [1] = { SP = 2, obols = 90 },
    [2] = { SP = 3, obols = 160 },
    [3] = { SP = 4, obols = 400 },
    refresh = { SP = 3, obols = 120, respecs = 5 }
}
function PST:bazaarGetCost(targetCost)
    return itemCosts[targetCost] or itemCosts[3]
end

function PST:bazaarCanAffordCost(targetCost)
    if PST.debugOptions.freeBazaar then return true end

    local tmpCost = PST:bazaarGetCost(targetCost)
    -- Global SP
    if PST.modData.skillPoints < tmpCost.SP then return false end
    -- Arcane obols
    local charData = PST:getCurrentCharData()
    if not charData or (charData and not charData.arcaneObols) or (charData and charData.arcaneObols and charData.arcaneObols < tmpCost.obols) then
        return false
    end
    -- Respecs
    if tmpCost.respecs and PST.modData.respecPoints < tmpCost.respecs then return false end

    return true
end

function PST:bazaarTryPurchase(itemID)
    local charData = PST:getCurrentCharData()
    if charData then
        local tmpItem = charData.bazaarSelection[itemID]
        if tmpItem and PST:bazaarCanAffordCost(tmpItem) then
            local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
            if itemCfg then
                local siderealMods = PST:getAllTreeMods("sidereal")
                local tmpMod = siderealMods["bazaarSelKeep"]
                -- Mod: % chance to keep other item choices after purchasing one item
                local keepItems = tmpMod and 100 * math.random() < tmpMod

                local tmpCosts = PST:bazaarGetCost(itemCfg.Quality)
                if not keepItems then
                    charData.bazaarSelection = {}
                else
                    for i, _ in ipairs(charData.bazaarSelection) do
                        if i == itemID then
                            table.remove(charData.bazaarSelection, i)
                        end
                    end
                end
                if not PST.debugOptions.freeBazaar then
                    PST.modData.skillPoints = PST.modData.skillPoints - tmpCosts.SP
                    charData.arcaneObols = charData.arcaneObols - tmpCosts.obols
                end

                if not charData.bazaarPurchased then charData.bazaarPurchased = {} end
                table.insert(charData.bazaarPurchased, tmpItem)
                return true
            end
        end
    end
    return false
end

function PST:bazaarTryRefresh()
    if PST:bazaarCanAffordCost("refresh") then
        local charData = PST:getCurrentCharData()
        if charData then
            local refreshCosts = PST:bazaarGetCost("refresh")
            if not PST.debugOptions.freeBazaar then
                PST.modData.skillPoints = PST.modData.skillPoints - refreshCosts.SP
                charData.arcaneObols = charData.arcaneObols - refreshCosts.obols
                PST.modData.respecPoints = PST.modData.respecPoints - refreshCosts.respecs
            end

            local siderealMods = PST:getAllTreeMods("sidereal")
            local bazaarDone = true
            -- Mod: % chance for the refresh button to stay
            local tmpMod = siderealMods["bazaarRefreshKeep"]
            if tmpMod and 100 * math.random() < tmpMod then
                bazaarDone = false
            end
            if bazaarDone then charData.bazaarDone = true
            else charData.bazaarDone = nil end

            PST:bazaarGenSelection()
            if charData.bazaarPurchased then
                charData.bazaarPurchased = {}
            end
            return true
        end
    end
    return false
end

-- Generate a selection of items for the currently selected character's Timeless Bazaar.
-- Takes into account sidereal tree modifiers that affect this generation.
function PST:bazaarGenSelection()
    local charData = PST:getCurrentCharData()
    if charData then
        local gamePool = Game():GetItemPool()
        local gameCfg = Isaac.GetItemConfig()

        charData.bazaarSelection = {}
        local siderealMods = PST:getAllTreeMods("sidereal")

        local maxItems = 3
        -- Mod: % chance on refresh to include additional item choices
        local tmpMod = siderealMods["bazaarExtraItem"]
        if tmpMod then
            while tmpMod > 0 do
                if 100 * math.random() < tmpMod then
                    maxItems = maxItems + 1
                end
                tmpMod = tmpMod - 100
            end
        end

        for _=1,maxItems do
            local tmpItemQual = 0
            if math.random() < 0.2 then
                tmpItemQual = 1
            end
            -- Mod: % chance to upgrade quality
            for i=0,2 do
                tmpMod = siderealMods["bazaarQual" .. tostring(i + 1)]
                if tmpMod and 100 * math.random() < tmpMod and tmpItemQual == i then
                    tmpItemQual = i + 1
                end
            end

            local tmpItemPool = ItemPoolType.POOL_TREASURE
            if math.random() < 0.5 then
                tmpItemPool = ItemPoolType.POOL_SHOP
            end
            -- Mod: % chance for offered items to be from the Devil pool
            tmpMod = siderealMods["bazaarDevil"]
            if tmpMod and 100 * math.random() < tmpMod then
                tmpItemPool = ItemPoolType.POOL_DEVIL
            else
                -- Mod: % chance for offered items to be from the Angel pool
                tmpMod = siderealMods["bazaarAngel"]
                if tmpMod and 100 * math.random() < tmpMod then
                    tmpItemPool = ItemPoolType.POOL_ANGEL
                end
            end

            local newItem = gamePool:GetCollectible(tmpItemPool)
            local newItemCfg = gameCfg:GetCollectible(newItem)
            local failsafe = 0
            while (PST:arrHasValue(charData.bazaarSelection, newItem) or not newItemCfg or (newItemCfg and (newItemCfg.Quality ~= tmpItemQual or newItemCfg.Type ~= ItemType.ITEM_PASSIVE))) and
            failsafe < failsafeCap do
                newItem = gamePool:GetCollectible(tmpItemPool)
                newItemCfg = gameCfg:GetCollectible(newItem)
                failsafe = failsafe + 1
            end
            if failsafe < failsafeCap and newItem ~= CollectibleType.COLLECTIBLE_NULL then
                table.insert(charData.bazaarSelection, newItem)
            end
        end
    end
end