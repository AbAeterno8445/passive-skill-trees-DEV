function SkillTrees:onNewRun(isContinued)
    if isContinued then
        return
    end

    -- Get snapshot of tree modifiers
    SkillTrees:resetMods()
    for nodeID, node in pairs(SkillTrees.trees["global"]) do
        if SkillTrees.modData.treeNodes["global"][nodeID] then
            SkillTrees:addModifier(node.modifiers)
        end
    end
    local currentChar = SkillTrees.charNames[1 + SkillTrees.selectedMenuChar]
    if SkillTrees.trees[currentChar] ~= nil then
        for nodeID, node in pairs(SkillTrees.trees[currentChar]) do
            if SkillTrees.modData.treeNodes[currentChar][nodeID] then
                SkillTrees:addModifier(node.modifiers)
            end
        end
    end

    SkillTrees.modData.treeModSnapshot = SkillTrees.modData.treeMods
    Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_ALL)
    Isaac.GetPlayer():EvaluateItems()
    SkillTrees:save()
end