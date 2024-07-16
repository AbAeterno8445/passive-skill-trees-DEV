function SkillTrees:onNewRun(isContinued)
    if isContinued then
        return
    end

    -- Get snapshot of tree modifiers
    SkillTrees.modData.treeModSnapshot = SkillTrees.modData.treeMods
    Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_ALL)
    Isaac.GetPlayer():EvaluateItems()
    SkillTrees:save()
end