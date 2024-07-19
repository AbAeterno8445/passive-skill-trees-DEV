function PST:onNewRun(isContinued)
    if isContinued then
        return
    end

    -- Get snapshot of tree modifiers
    PST:resetMods()
    for nodeID, node in pairs(PST.trees["global"]) do
        if PST.modData.treeNodes["global"][nodeID] then
            PST:addModifiers(node.modifiers)
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

    PST:closeTreeMenu()
end