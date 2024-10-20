include("scripts.expedition_data.ST_expedition_init")

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
local function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
end

-- Implicit modifiers applied to Astral Expeditions 
function PST:getExpeditionImplicits(depth)
    local implicits = {}

    -- Starmight requirement
    implicits.starmightReq = math.min(900, depth * 40)
    -- Depths 2+ monster HP
    if depth >= 2 then
        implicits.mobHP = depth * 2
    end
    -- Depths 3+ monster speed
    if depth >= 3 then
        implicits.mobSpeed = math.min(30, math.floor(depth / 3) * 2)
    end
    -- Depths 4+ chance to receive a curse when entering a floor
    if depth >= 4 then
        implicits.floorCurse = math.min(30, depth - 3)
    end
    -- Depths 6+ coin, key, bomb, heart scarcity
    if depth >= 6 then
        implicits.pickupScarcity = math.min(33, depth - 3)
    end
    -- Depths 8+ remove random quality 4 items from the pool when starting a run
    if depth >= 8 then
        implicits.quality4Remove = math.min(28, depth - 7)
    end
    -- Depths 10 & 20, start with an additional broken heart, and heartbreak can no longer show up
    if depth >= 10 then
        implicits.heartbreak = 1
        if depth >= 20 then implicits.heartbreak = 2 end
    end
    -- -expedition starting attempts
    local lessAttemptsList = {5, 10, 15, 25, 40}
    for _, tmpThreshold in ipairs(lessAttemptsList) do
        if depth >= tmpThreshold then
            if not implicits.lessAttempts then implicits.lessAttempts = 0 end
            implicits.lessAttempts = implicits.lessAttempts + 1
        end
    end
    -- Depths 15+ monster damage reduction
    if depth >= 15 then
        implicits.mobDmgRed = math.min(60, math.floor((depth - 14) * 1.5))
    end
    return implicits
end

-- Generate a set of nodes for an astral expedition
---@param depth number
---@param seed? integer
---@return PSTExpedition
function PST:generateExpedition(depth, seed)
    local expSeed = seed or math.random(100000000)
    local expRNG = RNG(expSeed)
    local expLength = math.min(15, 5 + math.floor(depth / 3))

    -- Reward type weights (starting value, addition per advanced column, min or max value)
    local rewardWeights = {
        [PSTExpNodeRewardType.OBOLS] = { val = 500, add = -40, min = 200 },
        [PSTExpNodeRewardType.EXP] = { val = 100, add = -1, min = 60 },
        [PSTExpNodeRewardType.ITEM] = { val = 50, add = 0.1, max = 80 },
        [PSTExpNodeRewardType.BOON] = { val = 20, add = 0.2, max = 35 },
        [PSTExpNodeRewardType.ATTEMPTS] = { val = 15, add = 0, max = 15}
    }
    local pickedItems = {}

    -- Curse node chance
    local curseChance = 0.1

    -- Boon upgrade node chance & total maximum
    local boonUpgradeChance = 0.04
    local boonUpgrades = 2

    -- Create layout of columns & nodes
    ---@type PSTExpNode[][]
    local expNodes = {}
    for col=1,expLength do
        ---@type PSTExpNode[]
        local expColumn = {}
        local minNodes = 3
        local maxNodes = 5
        if depth >= 8 then maxNodes = 6 end

        local nodeAmt = expRNG:RandomInt(minNodes, maxNodes)
        if col == 1 then nodeAmt = 3 end
        if col == expLength then nodeAmt = 1 end

        -- Max curse nodes per column (past second col)
        local colCurses = 2
        if depth >= 10 then colCurses = 3 end

        for row=1,nodeAmt do
            ---@type PSTExpNode
            local newNode = {
                nodeType = PSTExpNodeType.NORMAL,
                col = col + 1, -- Account for astrolabe column
                row = row,
                rewardType = PSTExpNodeRewardType.OBOLS,
                connections = {},
            }
            -- Final node
            if col == expLength then newNode.nodeType = PSTExpNodeType.FINAL end

            -- Guarantee expedition curses in second column
            if col == 2 then newNode.nodeType = PSTExpNodeType.CURSED end

            -- Past second column
            if col > 2 then
                if newNode.nodeType == PSTExpNodeType.NORMAL then
                    -- Chance for curse nodes
                    if colCurses > 0 and expRNG:RandomFloat() < curseChance then
                        newNode.nodeType = PSTExpNodeType.CURSED
                        colCurses = colCurses - 1
                    -- Chance for boon upgrade nodes
                    elseif boonUpgrades > 0 and expRNG:RandomFloat() < boonUpgradeChance then
                        newNode.nodeType = PSTExpNodeType.BOONUPGRADE
                        boonUpgrades = boonUpgrades - 1
                    end
                end
            end

            -- Assign objective
            local newObjective = { name = "", req = 0 }
            local tmpSrcTable = PST.expeditionObjectiveList
            local tmpTargetTable = PST.expeditionObjectives
            if newNode.nodeType == PSTExpNodeType.FINAL then
                tmpSrcTable = PST.expeditionObjectiveFinalList
                tmpTargetTable = PST.expeditionObjectivesFinal
            end
            -- Check for min depth requirement
            local tmpObjectiveName = tmpSrcTable[expRNG:RandomInt(1, #tmpSrcTable)]
            local tmpObjective = tmpTargetTable[tmpObjectiveName]
            while tmpObjective.minDepth and depth < tmpObjective.minDepth do
                tmpObjectiveName = tmpSrcTable[expRNG:RandomInt(1, #tmpSrcTable)]
                tmpObjective = tmpTargetTable[tmpObjectiveName]
            end
            -- Objective variants
            if tmpObjective.variants ~= nil then
                local tmpVariants = {}
                local totalWeight = 0
                for variantName, tmpVariant in pairs(tmpObjective.variants) do
                    if not tmpVariant.minDepth or (tmpVariant.minDepth and depth >= tmpVariant.minDepth) then
                        table.insert(tmpVariant, variantName)
                        totalWeight = totalWeight + (tmpVariant.weight or 1)
                    end
                end
                -- Pick variant based on weight
                if totalWeight > 0 then
                    local randWeight = expRNG:RandomInt(totalWeight)
                    for _, tmpVariantName in ipairs(tmpVariants) do
                        local tmpVariant = tmpObjective.variants[tmpVariantName]
                        randWeight = randWeight - tmpVariant.weight
                        if randWeight <= 0 then
                            -- Replace objective attributes with picked variant's
                            for k, v in pairs(tmpVariant) do
                                tmpObjective[k] = v
                            end
                            break
                        end
                    end
                end
            end

            -- Objective requirements & assignment
            if tmpObjective.reqFunc then
                newObjective.req = tmpObjective.reqFunc(depth, col)
                newObjective.name = tmpObjectiveName
                newNode.objective = newObjective
            end

            -- Assign curse
            if newNode.nodeType == PSTExpNodeType.CURSED then
                local newCurseID = expRNG:RandomInt(1, #PST.expeditionCurses)
                local newCurse = PST.expeditionCurses[newCurseID]
                while newCurse.minDepth and depth < newCurse.minDepth do
                    newCurseID = expRNG:RandomInt(1, #PST.expeditionCurses)
                    newCurse = PST.expeditionCurses[newCurseID]
                end
                newNode.curse = newCurseID
            end

            -- Assign reward type
            local totalWeight = 0
            for _, tmpWeight in pairs(rewardWeights) do
                totalWeight = totalWeight + tmpWeight.val
            end
            local randWeight = expRNG:RandomInt(math.floor(totalWeight))
            for rewardType, tmpWeight in pairs(rewardWeights) do
                randWeight = randWeight - tmpWeight.val
                if randWeight <= 0 then
                    newNode.rewardType = rewardType
                    break
                end
            end

            -- No item rewards in first or last column
            if (col == 1 or col == expLength) and newNode.rewardType == PSTExpNodeRewardType.ITEM then
                newNode.rewardType = PSTExpNodeRewardType.OBOLS
            end

            -- Assign reward data
            local rewardFunc = PST.expeditionRewardData[newNode.rewardType]
            if rewardFunc ~= nil then
                newNode.rewardData = rewardFunc(expRNG, depth, col)
            end

            -- Item reward type, pick an item
            if newNode.rewardType == PSTExpNodeRewardType.ITEM then
                local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false, expRNG:RandomInt(100000))
                local failsafe = 0
                while PST:arrHasValue(pickedItems, newItem) and failsafe < 200 do
                    newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false, expRNG:RandomInt(100000))
                    failsafe = failsafe + 1
                end
                newNode.rewardData = newItem
                table.insert(pickedItems, newItem)
            end

            table.insert(expColumn, newNode)
        end
        table.insert(expNodes, expColumn)

        -- Affect reward weights as we go deeper into expedition
        for _, tmpReward in pairs(rewardWeights) do
            tmpReward.val = tmpReward.val + tmpReward.add
            if tmpReward.min and tmpReward.val < tmpReward.min then
                tmpReward.val = tmpReward.min
            elseif tmpReward.max and tmpReward.val > tmpReward.max then
                tmpReward.val = tmpReward.max
            end
        end
        -- Node curse chance as we go deeper
        curseChance = curseChance + 0.01
        -- Boon upgrade node chance as we go deeper
        boonUpgradeChance = boonUpgradeChance + 0.005
    end

    -- Create shuffled list of all nodes
    local nodeList = {}
    for colID, tmpColumn in ipairs(expNodes) do
        for nodeID, _ in ipairs(tmpColumn) do
            table.insert(nodeList, {colID, nodeID})
        end
    end
    PST:shuffleList(nodeList, expRNG)

    -- Node connections
    local madeConnections = {}
    for _, nodeData in ipairs(nodeList) do
        local nodeColID = nodeData[1]
        local nodeCol = expNodes[nodeColID]
        local nextCol = expNodes[nodeColID + 1]

        local nodeID = nodeData[2]
        local tmpNode = nodeCol[nodeID]

        if nextCol then
            -- Connect all top nodes with each other, or if next column has only 1 node, connect to it directly
            if nodeID == 1 or #nextCol == 1 then
                table.insert(tmpNode.connections, 1)
            -- Connect all bottom nodes with each other
            elseif nodeID == #nodeCol then
                table.insert(tmpNode.connections, #nextCol)
            end

            -- Middle connections
            if #nextCol > 1 then
                -- Randomly loop reachable nodes forwards or backwards to prevent bias towards top-to-down connections
                local flip = expRNG:RandomFloat() < 0.5
                local tmpIter = ipairs
                if flip then tmpIter = reversedipairs end

                for nextNodeID, _ in tmpIter(nextCol) do
                    -- Determine if next node is close enough to form connection (up to 3), and that no connections block access to it
                    local myHeight = #nodeCol - (nodeID - 1) * 2
                    local nextHeight = #nextCol - (nextNodeID - 1) * 2
                    if math.abs(myHeight - nextHeight) <= 3 and #tmpNode.connections < 3 then
                        local connectionPossible = true

                        -- Determine if a connection here would collide with previous connections
                        for _, connData in ipairs(madeConnections) do
                            if connData.col == nodeColID then
                                -- Prevent connection if node above this one connects to node below target, or node below this one connects to node above target
                                if (connData.startHeight > myHeight and connData.endHeight < nextHeight) or
                                (connData.startHeight < myHeight and connData.endHeight > nextHeight) then
                                    connectionPossible = false
                                    break
                                end
                            end
                        end
                        if connectionPossible then
                            table.insert(madeConnections, { col = nodeColID, startHeight = myHeight, endHeight = nextHeight })
                            table.insert(tmpNode.connections, nextNodeID)
                        end
                    end
                end
            end
        end
    end
    -- Add astrolabe first column
    table.insert(expNodes, 1, {{
        nodeType = PSTExpNodeType.ASTROLABE,
        rewardType = PSTExpNodeRewardType.NONE,
        connections = {1, 2, 3}
    }})

    -- Expedition implicit modifiers
    local expImplicits = PST:getExpeditionImplicits(depth)
    -- Expedition starting attempts
    local lessAttempts = expImplicits.lessAttempts or 0
    local expAttempts = 8 - lessAttempts

    ---@type PSTExpedition
    return {
        depth = depth,
        nodes = expNodes,
        seed = expSeed,
        implicits = expImplicits,
        startAttempts = expAttempts,
        attempts = expAttempts,
        boons = {},
        upgradedBoons = {},
        boonUpgradePoints = 0,
        curses = {},
        items = {}
    }
end

-- Update nodes' accessibility in expedition
function PST:updateExpedAccess(depth)
    local tmpExpedition = PST.modData.expeditionsData[depth]
    if tmpExpedition then
        -- Set all incomplete nodes as inaccessible, and track completed nodes
        local completed = 0
        local completedCols = {}
        for col, tmpCol in ipairs(tmpExpedition.nodes) do
            for _, tmpNode in ipairs(tmpCol) do
                if tmpNode.nodeType ~= PSTExpNodeType.COMPLETED and tmpNode.nodeType ~= PSTExpNodeType.ASTROLABE and
                tmpNode.nodeType ~= PSTExpNodeType.FINAL then
                    tmpNode.accessible = false
                elseif tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                    completed = completed + 1
                    table.insert(completedCols, col)
                    tmpNode.accessible = nil
                end
                tmpNode.selectable = nil
            end
        end

        if completed == 0 then
            -- No completed nodes, set everything back to accessible
            for col, tmpCol in ipairs(tmpExpedition.nodes) do
                for _, tmpNode in ipairs(tmpCol) do
                    tmpNode.accessible = nil
                    if col == 2 then
                        -- Selectable nodes after astrolabe
                        tmpNode.selectable = true
                    end
                end
            end
        else
            -- Travel through completed nodes, setting connected nodes as accessible
            local nodeCheckList = {}
            for col, tmpCol in ipairs(tmpExpedition.nodes) do
                for row, tmpNode in ipairs(tmpCol) do
                    local isCheckNode = false
                    for _, tmpCheck in ipairs(nodeCheckList) do
                        if tmpCheck[1] == col and tmpCheck[2] == row then
                            isCheckNode = true
                            break
                        end
                    end
                    if tmpNode.nodeType ~= PSTExpNodeType.ASTROLABE and (tmpNode.nodeType == PSTExpNodeType.COMPLETED or isCheckNode) then
                        tmpNode.accessible = nil
                        if not PST:arrHasValue(completedCols, col + 1) then
                            for _, adjNode in ipairs(tmpNode.connections) do
                                local targetNode = tmpExpedition.nodes[col + 1][adjNode]
                                if targetNode then
                                    if tmpNode.nodeType == PSTExpNodeType.COMPLETED then
                                        targetNode.selectable = true
                                    end
                                    table.insert(nodeCheckList, {col + 1, adjNode})
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function PST:completeExpedNode(depth, col, row, giveReward)
    local tmpExpedition = PST.modData.expeditionsData[depth]
    if tmpExpedition then
        for _, tmpNode in ipairs(tmpExpedition.nodes[col]) do
            if tmpNode.row == row then
                -- Give node reward
                if giveReward then
                    -- Expedition attempts
                    if tmpNode.rewardType == PSTExpNodeRewardType.ATTEMPTS then
                        tmpExpedition.startAttempts = tmpExpedition.startAttempts + tmpNode.rewardData
                        tmpExpedition.attempts = tmpExpedition.attempts + tmpNode.rewardData
                    -- Boon
                    elseif tmpNode.rewardType == PSTExpNodeRewardType.BOON and not PST:arrHasValue(tmpExpedition.boons, tmpNode.rewardData) then
                        table.insert(tmpExpedition.boons, tmpNode.rewardData)
                    -- Exp
                    elseif tmpNode.rewardType == PSTExpNodeRewardType.EXP then
                        PST:addXP(tmpNode.rewardData, false)
                    -- Item
                    elseif tmpNode.rewardType == PSTExpNodeRewardType.ITEM and not PST:arrHasValue(tmpExpedition.items, tmpNode.rewardData) then
                        table.insert(tmpExpedition.items, tmpNode.rewardData)
                    -- Arcane obols
                    elseif tmpNode.rewardType == PSTExpNodeRewardType.OBOLS then
                        PST.modData.arcaneObols = PST.modData.arcaneObols + tmpNode.rewardData
                    end
                    -- Boon upgrade point reward
                    if tmpNode.nodeType == PSTExpNodeType.BOONUPGRADE or tmpNode.nodeType == PSTExpNodeType.MIXED then
                        tmpExpedition.boonUpgradePoints = tmpExpedition.boonUpgradePoints + 1
                    end
                end

                tmpNode.nodeType = PSTExpNodeType.COMPLETED
                if tmpExpedition.selectedNode.col == col and tmpExpedition.selectedNode.row == row then
                    tmpExpedition.selectedNode = nil
                end
                break
            end
        end
        PST:updateExpedAccess(depth)
    end
end

function PST:resetExpedition(depth)
    PST.modData.expeditionsData[depth] = PST:generateExpedition(depth)
    PST:updateExpedAccess(depth)
    return PST.modData.expeditionsData[depth]
end

-- For testing - reset expedition depth and switch to it in the expedition screen menu
function PST:resetExpeditionDebug(depth)
    PST:resetExpedition(depth)
    PST.treeScreen.modules.menuScreensModule.menus[PSTTreeScreenMenu.EXPEDITION].currentDepth = depth
end

-- Add boon to expedition, or upgrade it if already present
function PST:expedAddBoon(depth, boonID)
    local tmpExpedition = PST.modData.expeditionsData[depth]
    if tmpExpedition and boonID <= #PST.expeditionBoons then
        if not PST:arrHasValue(tmpExpedition.boons, boonID) then
            table.insert(tmpExpedition.boons, boonID)
        elseif not PST:arrHasValue(tmpExpedition.upgradedBoons, boonID) then
            table.insert(tmpExpedition.upgradedBoons, boonID)
        end
    end
end

-- Add curse to expedition
function PST:expedAddCurse(depth, curseID)
    local tmpExpedition = PST.modData.expeditionsData[depth]
    if tmpExpedition and curseID <= #PST.expeditionCurses and not PST:arrHasValue(tmpExpedition.curses, curseID) then
        table.insert(tmpExpedition.curses, curseID)
    end
end

-- Add item to expedition
---@param itemID CollectibleType
function PST:expedAddItem(depth, itemID)
    local tmpExpedition = PST.modData.expeditionsData[depth]
    if tmpExpedition and not PST:arrHasValue(tmpExpedition.items, itemID) then
        table.insert(tmpExpedition.items, itemID)
    end
end

---@param nodeData PSTExpNode
---@param expData PSTExpedition
function PST:getExpNodeObjectiveDesc(nodeData, expData)
    local tmpDescription = {}
    local objectiveData = PST.expeditionObjectives[nodeData.objective.name]
    if not objectiveData then
        objectiveData = PST.expeditionObjectivesFinal[nodeData.objective.name]
    end
    if objectiveData then
        local tmpColor = PST:RGBKColor(57, 150, 255)
        if nodeData.accessible == false then tmpColor = KColor(0.5, 0.5, 0.5, 1) end

        local objProgress = 0
        if expData.selectedNode then objProgress = expData.selectedNode.objProgress end

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

---@param nodeData PSTExpNode
---@param expData PSTExpedition
function PST:getExpNodeDescription(nodeData, expData)
    local tmpDescription = {}

    -- Completed node
    if nodeData.nodeType == PSTExpNodeType.COMPLETED then
        tmpDescription = {
            {"Completed node.", KColor(0.5, 1, 1, 1)}
        }
        return tmpDescription
    end

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
    if nodeData.nodeType == PSTExpNodeType.BOONUPGRADE or nodeData.nodeType == PSTExpNodeType.MIXED then
        table.insert(tmpDescription, {"   +1 Boon upgrade point", tmpColor})
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