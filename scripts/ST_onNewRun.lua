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

    PST.modData.treeModSnapshot = PST.modData.treeMods
    Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_ALL)
    Isaac.GetPlayer():EvaluateItems()
    PST:save()

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
    end

    PST:closeTreeMenu(true)
end