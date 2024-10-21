-- Get an expedition's save data
---@param expData PSTExpedition
---@return PSTExpeditionSave
function PST:getExpedSave(expData)
    ---@type PSTExpeditionSave
    local tmpExpSave = {seed = expData.seed}
    -- Completed nodes
    for _, tmpCol in ipairs(expData.nodes) do
        for _, tmpNode in ipairs(tmpCol) do
            if tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                if not tmpExpSave.compNodes then
                    tmpExpSave.compNodes = {}
                end
                table.insert(tmpExpSave.compNodes, {tmpNode.col, tmpNode.row})
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
    -- Upgraded boons
    if #expData.upgradedBoons > 0 then
        tmpExpSave.upgBoons = expData.upgradedBoons
    end
    -- Boon upgrade points
    if expData.boonUpgradePoints > 0 then
        tmpExpSave.upgBoonPts = expData.boonUpgradePoints
    end
    return tmpExpSave
end

-- Load an expedition from its save data
---@param expSave PSTExpeditionSave
function PST:loadExpedition(depth, expSave)
    ---@type PSTExpedition
    local tmpExped = PST:generateExpedition(depth, expSave.seed)

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
    -- Upgraded boons
    if expSave.upgBoons then tmpExped.upgradedBoons = expSave.upgBoons end
    -- Boon upgrade points
    if expSave.upgBoonPts then tmpExped.boonUpgradePoints = expSave.upgBoonPts end

    PST.expeditionsData[depth] = tmpExped
end