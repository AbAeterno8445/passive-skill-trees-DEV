local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
local function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
end

local generatorVersion = 1
-- Generate a set of nodes for an astral expedition
---@param depth number
---@param seed? integer
---@return PSTExpedition
function PST:generateUberExpeditionV1(depth, seed, expModifiers)
    local expSeed = seed or math.random(100000000)

    local uberDepth = (15 + depth) * 2

    -- Create RNG objects for each 'category' of randomization
    local expRNG = RNG(expSeed) -- starter RNG
    local nodeRNG = RNG(expRNG:Next()) -- node generation RNG (node type decisions)
    local uberRNG = RNG(expRNG:Next()) -- uber features RNG
    local curseRNG = RNG(expRNG:Next()) -- node curse RNG
    local rewardRNG = RNG(expRNG:Next()) -- node reward RNG
    local modsRNG = RNG(expRNG:Next()) -- modifiers RNG

    -- Uber: fixed length of 8 nodes, 7 at depth 5+
    local expLength = 8
    if depth >= 5 then expLength = 7 end

    local startOrder = 0
    -- Bring The Order node (Deep-Space tree)
    if expModifiers and expModifiers.bringTheOrder then
        startOrder = 50
    end

    -- Reward type weights (starting value, addition per advanced column, min or max value)
    local rewardWeights = {
        [PSTExpNodeRewardType.OBOLS] = { val = 100, add = 5 },
        [PSTExpNodeRewardType.EXP] = { val = 100, add = -5 },
        [PSTExpNodeRewardType.ATTEMPTS] = { val = 3 + depth / 5, add = 0.1 },
        [PSTExpNodeRewardType.ORDER] = { val = 9, add = 0.2 },
        -- Very rare
        [PSTExpNodeRewardType.C_STARCORE] = { val = 0.6 + depth / 10, add = 0 },
        [PSTExpNodeRewardType.GLOBAL_SP] = { val = 0.5 + depth / 10, add = 0 },
        [PSTExpNodeRewardType.STARBLESS_WEP] = { val = 0.4 + depth / 10, add = 0 }
    }
    local rewardWeightVals = {
        PSTExpNodeRewardType.OBOLS, PSTExpNodeRewardType.EXP, PSTExpNodeRewardType.ATTEMPTS,
        PSTExpNodeRewardType.ORDER, PSTExpNodeRewardType.C_STARCORE, PSTExpNodeRewardType.GLOBAL_SP,
        PSTExpNodeRewardType.STARBLESS_WEP
    }
    local pickedCurses = {}

    -- Curse node chance
    local curseChance = 0.12 + (depth - 1) / 100

    -- Create layout of columns & nodes
    ---@type PSTExpNode[][]
    local expNodes = {}
    for col=1,expLength do
        ---@type PSTExpNode[]
        local expColumn = {}
        local minNodes = 3
        local maxNodes = 6

        local nodeAmt = nodeRNG:RandomInt(minNodes, maxNodes)
        if col == 1 then nodeAmt = 3 end
        if col == expLength then nodeAmt = 1 end

        -- Max curse nodes per column (past second col)
        local colCurses = 3

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

            -- Guarantee curses in 6th column and every 4 columns thereafter
            if not isFinal then
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
                    end
                end
            end

            -- Assign objective
            local newObjective = {
                name = "winRun",
                req = PST.expeditionObjectives.winRun.reqFunc()
            }
            newNode.objective = newObjective

            -- Assign curse
            if newNode.nodeType == PSTExpNodeType.CURSED then
                local newCurseID = curseRNG:RandomInt(1, #PST.expeditionCurses)
                local failsafe = 0
                while (PST:arrHasValue(pickedCurses, newCurseID)) and failsafe < 400 do
                    newCurseID = curseRNG:RandomInt(1, #PST.expeditionCurses)
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
            local randWeight = totalWeight * rewardRNG:RandomFloat()
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

            -- Entropy modifiers
            local entropyMods = {}
            local maxEntropyMods = 1
            if col >= 5 then maxEntropyMods = 2 end
            if col == expLength then maxEntropyMods = 3 end

            for i=1,maxEntropyMods do
                local newEntMod = uberRNG:RandomInt(1, #PST.expedEntropyModList)
                local origMod = PST.expedEntropyMods[PST.expedEntropyModList[newEntMod]]
                local failsafe = 0
                while (PST:arrHasValue(entropyMods, newEntMod) or not origMod or (origMod and origMod.auxiliary and i == 1)) and
                failsafe < 200 do
                    newEntMod = uberRNG:RandomInt(1, #PST.expedEntropyModList)
                    origMod = PST.expedEntropyMods[PST.expedEntropyModList[newEntMod]]
                    failsafe = failsafe + 1
                end
                if failsafe < 200 then
                    table.insert(entropyMods, newEntMod)
                end
            end
            if #entropyMods > 0 then
                newNode.entropyMods = entropyMods
            end

            -- Final node rewards
            if col == expLength then
                -- Guarantee choice in depths 5+
                if depth >= 5 then
                    newNode.rewardType = PSTExpNodeRewardType.UBER_CHOICE
                else
                    local rewardList = {
                        [PSTExpNodeRewardType.C_STARCORE] = 0.25,
                        [PSTExpNodeRewardType.UBER_CHOICE] = 0.25,
                        [PSTExpNodeRewardType.STARBLESS_WEP] = 0.2,
                        [PSTExpNodeRewardType.STARBLESS_PRISM] = 0.1
                    }
                    PST:shuffleList(rewardList, rewardRNG)
                    local gotReward = false
                    for rewardType, tmpChance in pairs(rewardList) do
                        if rewardRNG:RandomFloat() <= tmpChance then
                            newNode.rewardType = rewardType
                            newNode.rewardData = 1
                            gotReward = true
                            break
                        end
                    end
                    -- Global SP default reward
                    if not gotReward then
                        newNode.rewardType = PSTExpNodeRewardType.GLOBAL_SP
                        newNode.rewardData = rewardRNG:RandomInt(3, 5)
                    end
                end
            else
                -- Assign reward data for non-final nodes
                local rewardFunc = PST.expeditionRewardData[newNode.rewardType]
                if rewardFunc ~= nil then
                    local rewardCol = col
                    -- Make final nodes more rewarding
                    if newNode.nodeType == PSTExpNodeType.FINAL then
                        rewardCol = rewardCol + 8 + (depth - 1) * 2
                    end
                    newNode.rewardData = rewardFunc(rewardRNG, uberDepth, col)

                    -- Mod: % order gained from nodes
                    if newNode.rewardType == PSTExpNodeRewardType.ORDER then
                        if expModifiers and expModifiers.orderGain and expModifiers.orderGain > 0 then
                            newNode.rewardData = math.ceil(newNode.rewardData * (1 + expModifiers.orderGain / 100))
                        end
                    end
                end
            end

            -- Uber choice reward data
            if newNode.rewardType == PSTExpNodeRewardType.UBER_CHOICE then
                newNode.rewardData = {}
                local avChoices = {
                    { type = PSTExpNodeRewardType.C_STARCORE, chance = 0.25, amt = 1 },
                    { type = PSTExpNodeRewardType.GLOBAL_SP, chance = 0.3, amt = 4 },
                    { type = PSTExpNodeRewardType.STARBLESS_PRISM, chance = 0.2, amt = 1 },
                    { type = PSTExpNodeRewardType.OBOLS, chance = 0.3, amt = 400 + depth * 50 }
                }
                local totalChoices = 3
                -- Mod: % chance to add an additional choice
                if expModifiers and expModifiers.expedChoiceAdd and 100 * modsRNG:RandomFloat() < expModifiers.expedChoiceAdd then
                    totalChoices = totalChoices + 1
                end

                local failsafe = 0
                while totalChoices > 0 and failsafe < 1000 do
                    PST:shuffleList(avChoices, rewardRNG)
                    for _, rwData in ipairs(avChoices) do
                        if rewardRNG:RandomFloat() < rwData.chance then
                            newNode.rewardData[rwData.type] = rwData.amt
                            totalChoices = totalChoices - 1
                            if totalChoices == 0 then break end
                        end
                    end
                    failsafe = failsafe + 1
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
        curseChance = curseChance + 0.03
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
    local expImplicits = PST:getExpeditionImplicits(uberDepth)
    -- Uber expeditions: 4 attempts
    local expAttempts = 4
    expImplicits.lessAttempts = nil

    -- Eldritch Exchange node (Deep-Space tree)
    if expModifiers and expModifiers.eldritchExchange then
        expAttempts = expAttempts + 2
    end

    ---@type PSTExpedition
    local newExped = {
        depth = depth,
        nodes = expNodes,
        seed = expSeed,
        version = generatorVersion,
        implicits = expImplicits,
        startAttempts = expAttempts,
        attempts = expAttempts,
        boons = {},
        upgradedBoons = {},
        boonUpgradePoints = 0,
        curses = {},
        items = {},
        uber = true,
        modifiers = expModifiers
    }
    if startOrder > 0 then newExped.order = startOrder end

    -- Entropic Tradeoff node (Deep-Space tree)
    if expModifiers and expModifiers.entropicTradeoff then
        PST:expedObjAddEntropy(newExped, 40, true)
    end

    return newExped
end