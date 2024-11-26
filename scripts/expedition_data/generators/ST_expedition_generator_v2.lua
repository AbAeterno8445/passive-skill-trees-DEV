local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
local function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
end

-- Generate a set of nodes for an astral expedition (version 2)
---@param depth number
---@param seed? integer
---@return PSTExpedition
function PST:generateExpeditionV2(depth, seed)
    local expSeed = seed or math.random(100000000)

    -- V2: Create RNG objects for each 'category' of randomization
    local expRNG = RNG(expSeed) -- starter RNG
    local nodeRNG = RNG(expRNG:Next()) -- node generation RNG (node type decisions)
    local objectiveRNG = RNG(expRNG:Next()) -- node objective RNG
    local curseRNG = RNG(expRNG:Next()) -- node curse RNG
    local rewardRNG = RNG(expRNG:Next()) -- node reward RNG

    local expLength = math.min(15, 5 + math.floor(depth / 3))

    -- Reward type weights (starting value, addition per advanced column, min or max value)
    local rewardWeights = {
        [PSTExpNodeRewardType.OBOLS] = { val = 400, add = -25, min = 200 },
        [PSTExpNodeRewardType.EXP] = { val = 100, add = -1, min = 60 },
        [PSTExpNodeRewardType.ITEM] = { val = 8, add = 0.1, max = 15, minDepth = 3 },
        [PSTExpNodeRewardType.BOON] = { val = 30, add = 0.2, max = 40 },
        [PSTExpNodeRewardType.ATTEMPTS] = { val = 15, add = 0, max = 15}
    }
    local rewardWeightVals = {
        PSTExpNodeRewardType.OBOLS, PSTExpNodeRewardType.EXP, PSTExpNodeRewardType.ITEM,
        PSTExpNodeRewardType.BOON, PSTExpNodeRewardType.ATTEMPTS
    }
    local pickedItems = {}
    local pickedCurses = {}
    local pickedBoons = {}

    -- Curse node chance
    local curseChance = 0.1

    -- Boon upgrade node chance & total maximum
    local boonUpgradeChance = 0.05
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

        local nodeAmt = nodeRNG:RandomInt(minNodes, maxNodes)
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
            local isFinal = col == expLength
            if isFinal then newNode.nodeType = PSTExpNodeType.FINAL end

            -- Guarantee expedition curses in second column
            if col == 2 then newNode.nodeType = PSTExpNodeType.CURSED end

            -- Past depth 5, guarantee curses in 6th column and every 4 columns thereafter
            if depth >= 5 and not isFinal then
                if ((col - 6) % 4) == 0 then
                    newNode.nodeType = PSTExpNodeType.CURSED
                end
            end

            -- Past second column
            if col > 2 and not isFinal then
                if newNode.nodeType == PSTExpNodeType.NORMAL then
                    -- Chance for curse nodes
                    if colCurses > 0 and nodeRNG:RandomFloat() < curseChance then
                        newNode.nodeType = PSTExpNodeType.CURSED
                        colCurses = colCurses - 1
                    -- Depth 4+, Chance for boon upgrade nodes
                    elseif boonUpgrades > 0 and depth >= 4 and nodeRNG:RandomFloat() < boonUpgradeChance then
                        newNode.nodeType = PSTExpNodeType.BOONUPGRADE
                        boonUpgrades = boonUpgrades - 1
                    end
                end
            end

            -- Assign objective
            local newObjective = { name = "", req = 0, variant = "" }
            local tmpSrcTable = PST.expeditionObjectiveList
            local tmpTargetTable = PST.expeditionObjectives
            if newNode.nodeType == PSTExpNodeType.FINAL then
                tmpSrcTable = PST.expeditionObjectiveFinalList
                tmpTargetTable = PST.expeditionObjectivesFinal
            end
            -- Check for min/max depth requirement
            local tmpObjectiveName = tmpSrcTable[objectiveRNG:RandomInt(1, #tmpSrcTable)]
            local tmpObjective = tmpTargetTable[tmpObjectiveName]
            while (tmpObjective.minDepth and depth < tmpObjective.minDepth) or (tmpObjective.maxDepth and depth > tmpObjective.maxDepth) do
                tmpObjectiveName = tmpSrcTable[objectiveRNG:RandomInt(1, #tmpSrcTable)]
                tmpObjective = tmpTargetTable[tmpObjectiveName]
            end

            -- Objective requirements & assignment
            if tmpObjective.reqFunc then
                newObjective.req = tmpObjective.reqFunc(depth, col)
                newObjective.name = tmpObjectiveName
                newNode.objective = newObjective
            end

            -- Assign curse
            if newNode.nodeType == PSTExpNodeType.CURSED then
                local newCurseID = curseRNG:RandomInt(1, #PST.expeditionCurses)
                local newCurse = PST.expeditionCurses[newCurseID]
                local failsafe = 0
                while ((newCurse.minDepth and depth < newCurse.minDepth) or PST:arrHasValue(pickedCurses, newCurseID)) and failsafe < 400 do
                    newCurseID = curseRNG:RandomInt(1, #PST.expeditionCurses)
                    newCurse = PST.expeditionCurses[newCurseID]
                    failsafe = failsafe + 1
                end
                if failsafe < 400 then
                    newNode.curse = newCurseID
                    table.insert(pickedCurses, newCurseID)
                else
                    newNode.nodeType = PSTExpNodeType.NORMAL
                end
            end

            -- Assign reward type
            local totalWeight = 0
            for _, tmpWeight in pairs(rewardWeights) do
                if not tmpWeight.minDepth or (tmpWeight.minDepth and depth >= tmpWeight.minDepth) then
                    totalWeight = totalWeight + tmpWeight.val
                end
            end
            local randWeight = rewardRNG:RandomInt(math.floor(totalWeight))
            for _, rewardType in ipairs(rewardWeightVals) do
                local tmpWeight = rewardWeights[rewardType]
                if not tmpWeight.minDepth or (tmpWeight.minDepth and depth >= tmpWeight.minDepth) then
                    randWeight = randWeight - tmpWeight.val
                    if randWeight <= 0 then
                        newNode.rewardType = rewardType
                        break
                    end
                end
            end

            -- No item rewards in first or last column
            if (col == 1 or col == expLength) and newNode.rewardType == PSTExpNodeRewardType.ITEM then
                newNode.rewardType = PSTExpNodeRewardType.OBOLS
            end
            -- No attempts reward in last column
            if (col == expLength) and newNode.rewardType == PSTExpNodeRewardType.ATTEMPTS then
                newNode.rewardType = PSTExpNodeRewardType.OBOLS
            end

            -- Chance for crimson starcore on final node past depth 20
            if depth >= 20 and (col == expLength) then
                local starcoreChance = math.min(0.55, 0.2 + (depth - 20) * 0.02)
                if rewardRNG:RandomFloat() < starcoreChance then
                    newNode.rewardType = PSTExpNodeRewardType.C_STARCORE
                end
            end

            -- Assign reward data
            local rewardFunc = PST.expeditionRewardData[newNode.rewardType]
            if rewardFunc ~= nil then
                local rewardCol = col
                -- Make final nodes more rewarding
                if newNode.nodeType == PSTExpNodeType.FINAL then
                    rewardCol = rewardCol + 8 + (depth - 1) * 2
                end
                newNode.rewardData = rewardFunc(rewardRNG, depth, col)
            end

            -- Boon reward type, pick boon
            local rewardTypeRNG = RNG(rewardRNG:Next())
            if newNode.rewardType == PSTExpNodeRewardType.BOON then
                local newBoonID = rewardTypeRNG:RandomInt(1, #PST.expeditionBoons)
                local newBoon = PST.expeditionBoons[newBoonID]
                local failsafe = 0
                while ((newBoon.minDepth and depth < newBoon.minDepth) or PST:arrHasValue(pickedBoons, newBoonID)) and failsafe < 400 do
                    newBoonID = rewardTypeRNG:RandomInt(1, #PST.expeditionBoons)
                    newBoon = PST.expeditionBoons[newBoonID]
                    failsafe = failsafe + 1
                end
                if failsafe < 400 then
                    newNode.rewardData = newBoonID
                    table.insert(pickedBoons, newBoonID)
                else
                    newNode.rewardType = PSTExpNodeType.OBOLS
                end
            -- Item reward type, pick an item
            elseif newNode.rewardType == PSTExpNodeRewardType.ITEM then
                local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false, rewardTypeRNG:RandomInt(100000))
                local itemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                local failsafe = 0
                while (PST:arrHasValue(pickedItems, newItem) or (itemCfg and itemCfg.Type ~= ItemType.ITEM_PASSIVE)) and failsafe < 300 do
                    newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false, rewardTypeRNG:RandomInt(100000))
                    itemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                    failsafe = failsafe + 1
                end
                if failsafe < 300 then
                    newNode.rewardData = newItem
                    table.insert(pickedItems, newItem)
                else
                    newNode.rewardType = PSTExpNodeType.OBOLS
                end
            end

            table.insert(expColumn, newNode)
        end
        table.insert(expNodes, expColumn)

        -- Affect reward weights as we go deeper into expedition
        for _, rewardType in ipairs(rewardWeightVals) do
            local tmpReward = rewardWeights[rewardType]
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
    local expAttempts = 12 - lessAttempts

    ---@type PSTExpedition
    return {
        depth = depth,
        nodes = expNodes,
        seed = expSeed,
        version = 2,
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