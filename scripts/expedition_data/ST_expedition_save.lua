-- Get an expedition's save data
---@param expData PSTExpedition
---@return PSTExpeditionSave
function PST:getExpedSave(expData)
    ---@type PSTExpeditionSave
    local tmpExpSave = {seed = expData.seed, version = expData.version or 1}
    -- Save special node states
    for _, tmpCol in ipairs(expData.nodes) do
        for _, tmpNode in ipairs(tmpCol) do
            -- Completed nodes
            if tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                if not tmpExpSave.compNodes then
                    tmpExpSave.compNodes = {}
                end
                table.insert(tmpExpSave.compNodes, {tmpNode.col, tmpNode.row})
            -- Reward-less nodes
            elseif tmpNode.rewardType == PSTExpNodeRewardType.NONE then
                if not tmpExpSave.noRwNodes then
                    tmpExpSave.noRwNodes = {}
                end
                table.insert(tmpExpSave.noRwNodes, {tmpNode.col, tmpNode.row})
            end
            -- Dead nodes
            if tmpNode.deathState then
                if not tmpExpSave.deadNodes then
                    tmpExpSave.deadNodes = {}
                end
                table.insert(tmpExpSave.deadNodes, {tmpNode.col, tmpNode.row})
            end
        end
    end
    -- Selected node
    if expData.selectedNode then
        tmpExpSave.selNode = expData.selectedNode
    end
    -- Attempts
    if expData.attempts < expData.startAttempts then
        tmpExpSave.usedAttempts = expData.startAttempts - expData.attempts
    end
    -- Boons
    if #expData.boons > 0 then
        tmpExpSave.boons = expData.boons
    end
    -- Upgraded boons
    if #expData.upgradedBoons > 0 then
        tmpExpSave.upgBoons = expData.upgradedBoons
    end
    -- Boon upgrade points
    if expData.boonUpgradePoints > 0 then
        tmpExpSave.upgBoonPts = expData.boonUpgradePoints
    end
    -- Curses
    if #expData.curses > 0 then
        tmpExpSave.curses = expData.curses
    end
    -- Node queue
    if expData.nodeQueue then
        tmpExpSave.nodeQueue = PST:copyTable(expData.nodeQueue)
    end
    -- Uber flag
    if expData.uber then tmpExpSave.uber = true end
    -- Order/Entropy
    if expData.order then tmpExpSave.order = expData.order end
    if expData.entropy then tmpExpSave.entropy = expData.entropy end
    if expData.entropyEffects then tmpExpSave.entropyEffects = expData.entropyEffects end
    -- Deep-Space distortion mods
    if expData.dsMods then tmpExpSave.dsMods = expData.dsMods end
    -- Expedition modifiers
    if expData.modifiers then tmpExpSave.modifiers = expData.modifiers end
    -- End rewards created
    if expData.endRewards then tmpExpSave.endRewards = expData.endRewards end
    return tmpExpSave
end

-- Load an expedition from its save data
---@param expSave PSTExpeditionSave
function PST:loadExpedition(depth, expSave, uber)
    ---@type PSTExpedition
    local tmpExped = PST:generateExpedition(depth, expSave.seed, expSave.version or 1, uber, expSave.modifiers)

    -- Completed nodes
    if expSave.compNodes then
        for _, tmpCompNode in ipairs(expSave.compNodes) do
            local tmpCol = tmpExped.nodes[tmpCompNode[1]]
            if tmpCol then
                local tmpNode = tmpCol[tmpCompNode[2]]
                if tmpNode then
                    tmpNode.nodeType = PSTExpNodeType.COMPLETED
                    -- Curse
                    if tmpNode.curse then table.insert(tmpExped.curses, tmpNode.curse) end
                    -- Boon
                    if tmpNode.rewardType == PSTExpNodeRewardType.BOON and PST.expeditionBoons[tmpNode.rewardData] then
                        table.insert(tmpExped.boons, tmpNode.rewardData)
                    end
                    -- Item
                    if tmpNode.rewardType == PSTExpNodeRewardType.ITEM then
                        table.insert(tmpExped.items, tmpNode.rewardData)
                    end
                end
            end
        end
        PST:updateExpedAccess(depth)
    end
    -- Reward-less nodes
    if expSave.noRwNodes then
        for _, tmpRwNode in ipairs(expSave.noRwNodes) do
            local tmpCol = tmpExped.nodes[tmpRwNode[1]]
            if tmpCol then
                local tmpNode = tmpCol[tmpRwNode[2]]
                if tmpNode then
                    tmpNode.rewardType = PSTExpNodeRewardType.NONE
                end
            end
        end
    end
    -- Dead nodes
    if expSave.deadNodes then
        for _, tmpDeadNode in ipairs(expSave.deadNodes) do
            local tmpCol = tmpExped.nodes[tmpDeadNode[1]]
            if tmpCol then
                local tmpNode = tmpCol[tmpDeadNode[2]]
                if tmpNode then
                    tmpNode.deathState = 1
                end
            end
        end
    end
    -- Selected node
    if expSave.selNode then
        tmpExped.selectedNode = expSave.selNode
        -- Selected node curse
        local tmpCol = tmpExped.nodes[tmpExped.selectedNode.col]
        if tmpCol then
            local selNode = tmpCol[tmpExped.selectedNode.row]
            if selNode and selNode.curse and selNode.curse > 0 then
                table.insert(tmpExped.curses, selNode.curse)
            end
        end
    end
    -- Attempts
    if expSave.usedAttempts and expSave.usedAttempts > 0 then
        tmpExped.attempts = tmpExped.attempts - expSave.usedAttempts
    end
    -- Boons
    if expSave.boons then
        for _, tmpBoon in ipairs(expSave.boons) do
            if not PST:arrHasValue(tmpExped.boons, tmpBoon) then
                table.insert(tmpExped.boons, tmpBoon)
            end
        end
    end
    -- Upgraded boons
    if expSave.upgBoons then tmpExped.upgradedBoons = expSave.upgBoons end
    -- Boon upgrade points
    if expSave.upgBoonPts then tmpExped.boonUpgradePoints = expSave.upgBoonPts end
    -- Curses
    if expSave.curses then
        for _, tmpCurse in ipairs(expSave.curses) do
            if not PST:arrHasValue(tmpExped.curses, tmpCurse) then
                table.insert(tmpExped.curses, tmpCurse)
            end
        end
    end
    -- Node queue
    if expSave.nodeQueue then
        tmpExped.nodeQueue = PST:copyTable(expSave.nodeQueue)
    end
    -- Order/Entropy
    if expSave.order then tmpExped.order = expSave.order end
    if expSave.entropy then tmpExped.entropy = expSave.entropy end
    if expSave.entropyEffects then tmpExped.entropyEffects = expSave.entropyEffects end
    -- Deep-Space distortion mods
    if expSave.dsMods then tmpExped.dsMods = expSave.dsMods end

    if not uber then
        PST.expeditionsData[depth] = tmpExped
    else
        PST.uberExpeditionsData[depth] = tmpExped
        if tmpExped.entropyEffects then
            PST:expedApplyEntropy(tmpExped)
        end
    end

    -- Regenerate end rewards if created
    if expSave.endRewards then
        PST:expedCreateEndRewards(depth, uber)
    end

    PST:updateExpedAccess(depth, uber)
end