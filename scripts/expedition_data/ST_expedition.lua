include("scripts.expedition_data.ST_expedition_init")
include("scripts.expedition_data.ST_expedition_generator")

function PST:expedGetNodeAt(depth, col, row)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        local tmpCol = tmpExpedition.nodes[col]
        if tmpCol then
            local tmpNode = tmpCol[row]
            if tmpNode then return tmpNode end
        end
    end
    return nil
end

---@param depth number
---@param nodeData PSTExpNode
function PST:expedNodeIsObjectiveDone(depth, nodeData)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and nodeData and tmpExpedition.selectedNode and nodeData.objective then
        return tmpExpedition.selectedNode.objProgress >= nodeData.objective.req
    end
    return false
end

function PST:resetExpedition(depth)
    PST.expeditionsData[depth] = PST:generateExpedition(depth)
    PST:updateExpedAccess(depth)
    return PST.expeditionsData[depth]
end

-- For testing - reset expedition depth and switch to it in the expedition screen menu
function PST:resetExpeditionDebug(depth)
    PST:resetExpedition(depth)
    PST.treeScreen.modules.menuScreensModule.menus[PSTTreeScreenMenu.EXPEDITION].currentDepth = depth
end

-- Add boon to expedition, or upgrade it if already present
function PST:expedAddBoon(depth, boonID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and boonID <= #PST.expeditionBoons then
        if not PST:arrHasValue(tmpExpedition.boons, boonID) then
            table.insert(tmpExpedition.boons, boonID)
        elseif not PST:arrHasValue(tmpExpedition.upgradedBoons, boonID) then
            table.insert(tmpExpedition.upgradedBoons, boonID)
        end
    end
end

-- Remove boon from expedition
function PST:expedRemoveBoon(depth, boonID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        PST:tableRemoveFirst(tmpExpedition.boons, boonID)
        PST:tableRemoveFirst(tmpExpedition.upgradedBoons, boonID)
    end
end

-- Add curse to expedition
function PST:expedAddCurse(depth, curseID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and curseID <= #PST.expeditionCurses and not PST:arrHasValue(tmpExpedition.curses, curseID) then
        table.insert(tmpExpedition.curses, curseID)
    end
end

-- Remove curse from expedition
function PST:expedRemoveCurse(depth, curseID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        PST:tableRemoveFirst(tmpExpedition.curses, curseID)
    end
end

-- Add item to expedition
---@param itemID CollectibleType
function PST:expedAddItem(depth, itemID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and not PST:arrHasValue(tmpExpedition.items, itemID) then
        table.insert(tmpExpedition.items, itemID)
    end
end

-- Remove item from expedition
function PST:expedRemoveItem(depth, itemID)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition then
        PST:tableRemoveFirst(tmpExpedition.items, itemID)
    end
end

-- Add progress to an expedition's current objective, and check for node completion
function PST:expedAddProgress(depth, prog)
    local tmpExpedition = PST.expeditionsData[depth]
    if tmpExpedition and tmpExpedition.selectedNode then
        local tgtCol = tmpExpedition.nodes[tmpExpedition.selectedNode.col]
        if tgtCol then
            local tgtNode = tgtCol[tmpExpedition.selectedNode.row]
            if tgtNode and tmpExpedition.selectedNode.objProgress < tgtNode.objective.req then
                tmpExpedition.selectedNode.objProgress = math.min(tgtNode.objective.req, tmpExpedition.selectedNode.objProgress + prog)
            end
        end
    end
end

function PST:completeExpedNode(depth, col, row, giveReward)
    local tmpExpedition = PST.expeditionsData[depth]
    local tmpNode = PST:expedGetNodeAt(depth, col, row)
    if tmpExpedition and tmpNode then
        -- Give node reward
        if giveReward then
            -- Expedition attempts
            if tmpNode.rewardType == PSTExpNodeRewardType.ATTEMPTS then
                tmpExpedition.startAttempts = tmpExpedition.startAttempts + tmpNode.rewardData
                tmpExpedition.attempts = tmpExpedition.attempts + tmpNode.rewardData
            -- Boon
            elseif tmpNode.rewardType == PSTExpNodeRewardType.BOON and not PST:arrHasValue(tmpExpedition.boons, tmpNode.rewardData) then
                PST:expedAddBoon(depth, tmpNode.rewardData)
            -- Exp
            elseif tmpNode.rewardType == PSTExpNodeRewardType.EXP then
                PST:addXP(tmpNode.rewardData, false)
            -- Item
            elseif tmpNode.rewardType == PSTExpNodeRewardType.ITEM and not PST:arrHasValue(tmpExpedition.items, tmpNode.rewardData) then
                PST:expedAddItem(depth, tmpNode.rewardData)
            -- Arcane obols
            elseif tmpNode.rewardType == PSTExpNodeRewardType.OBOLS then
                PST.modData.arcaneObols = PST.modData.arcaneObols + tmpNode.rewardData
            end
            -- Boon upgrade point reward
            if tmpNode.nodeType == PSTExpNodeType.BOONUPGRADE then
                tmpExpedition.boonUpgradePoints = tmpExpedition.boonUpgradePoints + 1
            end
        end

        -- Final node completion
        local resetExped = false
        if tmpNode.nodeType == PSTExpNodeType.FINAL then
            -- Unlock next depth
            if depth + 1 > PST.modData.expeditionDepth then
                PST.modData.expeditionDepth = depth + 1
            end
            resetExped = true
        end

        tmpNode.nodeType = PSTExpNodeType.COMPLETED
        if tmpExpedition.selectedNode.col == col and tmpExpedition.selectedNode.row == row then
            tmpExpedition.selectedNode = nil
        end

        if resetExped then
            PST:resetExpedition(depth)
        else
            PST:updateExpedAccess(depth)
        end
    end
end

---@param nodeData PSTExpNode
---@param expData PSTExpedition
function PST:getExpNodeObjectiveDesc(nodeData, expData)
    if not nodeData.objective then return {} end

    local tmpDescription = {}
    local objectiveData = PST.expeditionObjectives[nodeData.objective.name]
    if not objectiveData then
        objectiveData = PST.expeditionObjectivesFinal[nodeData.objective.name]
    end
    if objectiveData then
        local tmpColor = PST:RGBKColor(57, 150, 255)
        if nodeData.accessible == false then tmpColor = KColor(0.5, 0.5, 0.5, 1) end

        local objProgress = 0
        if nodeData.nodeType == PSTExpNodeType.COMPLETED then
            objProgress = nodeData.objective.req
            tmpColor = PST:RGBKColor(80, 255, 255)
        elseif expData.selectedNode then
            if expData.selectedNode.col == nodeData.col and expData.selectedNode.row == nodeData.row then
                objProgress = expData.selectedNode.objProgress
                if expData.selectedNode.objProgress >= nodeData.objective.req then
                    tmpColor = PST:RGBKColor(80, 255, 255)
                end
            end
        end

        local progressStr = tostring(objProgress) .. "/" .. tostring(nodeData.objective.req)
        table.insert(tmpDescription, {"Objective:", tmpColor})
        if type(objectiveData.description) == "table" then
            for _, tmpLine in ipairs(objectiveData.description) do
                local formattedLine = PST:formatString(tmpLine, { progress = progressStr })
                table.insert(tmpDescription, {"   " .. formattedLine, tmpColor})
            end
        else
            local formattedLine = PST:formatString(objectiveData.description, { progress = progressStr })
            table.insert(tmpDescription, {"   " .. formattedLine, tmpColor})
        end
    end
    return tmpDescription
end

function PST:getExpedResetCost(depth)
    return depth * 40
end

---@param nodeData PSTExpNode
---@param expData PSTExpedition
function PST:getExpNodeDescription(nodeData, expData)
    local tmpDescription = {}

    -- Objective
    if nodeData.objective and nodeData.objective.name then
        for _, tmpLine in ipairs(PST:getExpNodeObjectiveDesc(nodeData, expData)) do
            table.insert(tmpDescription, tmpLine)
        end
    end

    -- Curse
    if nodeData.curse then
        local curseData = PST.expeditionCurses[nodeData.curse]
        if curseData then
            local tmpColor = PST:RGBKColor(255, 80, 93)
            if nodeData.accessible == false then tmpColor = KColor(0.5, 0.5, 0.5, 1) end
            table.insert(tmpDescription, {"Curse of " .. curseData.name .. ":", tmpColor})
            if type(curseData.description) == "table" then
                for _, tmpLine in ipairs(curseData.description) do
                    local formattedDesc = PST:formatString(tmpLine, curseData.modsFunc(expData.depth))
                    table.insert(tmpDescription, {"   " .. formattedDesc, tmpColor})
                end
            else
                local formattedDesc = PST:formatString(curseData.description, curseData.modsFunc(expData.depth))
                table.insert(tmpDescription, {"   " .. formattedDesc, tmpColor})
            end
        end
    end

    -- Reward
    local tmpColor = PST:RGBKColor(129, 255, 129)
    if nodeData.accessible == false then tmpColor = KColor(0.5, 0.5, 0.5, 1) end
    table.insert(tmpDescription, {"Reward:", tmpColor})

    -- Reward: Boon
    if nodeData.rewardType == PSTExpNodeRewardType.BOON then
        local boonData = PST.expeditionBoons[nodeData.rewardData]
        if boonData then
            table.insert(tmpDescription, {"   Gain Boon of " .. boonData.name .. ":", tmpColor})
            if type(boonData.description) == "table" then
                for _, tmpLine in ipairs(boonData.description) do
                    local formattedDesc = PST:formatString(tmpLine, boonData.mods)
                    table.insert(tmpDescription, {"      " .. formattedDesc, tmpColor})
                end
            else
                local formattedDesc = PST:formatString(boonData.description, boonData.mods)
                table.insert(tmpDescription, {"      " .. formattedDesc, tmpColor})
            end
        end
    -- Reward: Obols
    elseif nodeData.rewardType == PSTExpNodeRewardType.OBOLS then
        table.insert(tmpDescription, {"   " .. tostring(nodeData.rewardData) .. " Arcane Obols", tmpColor})
    -- Reward: Exp
    elseif nodeData.rewardType == PSTExpNodeRewardType.EXP then
        table.insert(tmpDescription, {"   " .. tostring(nodeData.rewardData) .. " EXP", tmpColor})
    -- Reward: Attempts
    elseif nodeData.rewardType == PSTExpNodeRewardType.ATTEMPTS then
        table.insert(tmpDescription, {"   " .. tostring(nodeData.rewardData) .. " Expedition Attempt(s)", tmpColor})
    -- Reward: Item
    elseif nodeData.rewardType == PSTExpNodeRewardType.ITEM then
        local shownItem = false
        local itemCfg = Isaac.GetItemConfig():GetCollectible(nodeData.rewardData)
        if itemCfg then
            local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
			if itemName ~= "StringTable::InvalidKey" then
				table.insert(tmpDescription, {"   Add " .. itemName .. " to this Expedition", tmpColor})
                shownItem = true
			end
        end
        if not shownItem then
            table.insert(tmpDescription, {"   Add shown item to this Expedition", tmpColor})
        end
    end
    -- Boon Upgrade node
    if nodeData.nodeType == PSTExpNodeType.BOONUPGRADE then
        table.insert(tmpDescription, {"   +1 Boon upgrade point", tmpColor})
    -- Completed node
    elseif nodeData.nodeType == PSTExpNodeType.COMPLETED then
        table.insert(tmpDescription, {"Completed node.", KColor(0.5, 1, 1, 1)})
    end

    return tmpDescription
end

---@param expData PSTExpedition
function PST:getExpedCurseMods(expData)
    local curseMods = {}
    for _, curseID in ipairs(expData.curses) do
        local tmpCurse = PST.expeditionCurses[curseID]
        if tmpCurse then
            local tmpMods = tmpCurse.modsFunc(expData.depth)
            for tmpModName, tmpModVal in pairs(tmpMods) do
                if curseMods[tmpModName] == nil then
                    curseMods[tmpModName] = tmpModVal
                elseif type(curseMods[tmpModName]) == "number" then
                    curseMods[tmpModName] = curseMods[tmpModName] + tmpModVal
                end
            end
        end
    end
    return curseMods
end

include("scripts.expedition_data.ST_expedition_save")