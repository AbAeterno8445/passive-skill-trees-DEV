local json = require("json")

PST.trees = {}
PST.nodeLinks = {}

include("scripts.tree_data.modifierDescriptions")

-- Check if node is allocated
function PST:isNodeAllocated(tree, nodeID)
    if not PST.modData.treeNodes[tree] then return false end
    return PST.modData.treeNodes[tree][nodeID]
end

-- Check if node with given name is allocated
function PST:isNodeNameAllocated(tree, nodeName)
    if not PST.modData.treeNodes[tree] then return false end
    for nodeID, allocated in pairs(PST.modData.treeNodes[tree]) do
        local targetNode = PST.trees[tree][nodeID]
        if allocated and targetNode and targetNode.name == nodeName then
            return true
        end
    end
    return false
end

-- Update the state for the given tree
---@param tree? string|number Which tree to update. If nil, update all trees
---@param noReset? boolean Whether to reset player mods prior to update
function PST:updateNodes(tree, noReset)
    if tree == nil then
        for subTree, _ in pairs(PST.trees) do
            PST:updateNodes(subTree, true)
        end
        return
    end

    if not noReset then
        PST:resetMods()
    end

    local tmpAvailableNodes = {}
    for nodeID, node in pairs(PST.trees[tree]) do
        local allocated = PST:isNodeAllocated(tree, nodeID)

        -- Count allocated nodes as available
        node.available = allocated or node.alwaysAvailable == true or PST.debugOptions.allAvailable

        if node.adjacent ~= nil and allocated then
            -- If allocated, make adjacent nodes available
            for _, subNodeID in ipairs(node.adjacent) do
                tmpAvailableNodes[subNodeID] = PST.trees[tree][subNodeID]
            end
        end
    end

    -- Update availability
    for _, node in pairs(tmpAvailableNodes) do
        node.available = true
    end
end

-- Initial setup for tree & nodes
function PST:initTreeNodes(tree)
    -- Sanitize json data in tree bank
    local tmpTreeData = {}
    for nodeID, nodeStr in pairs(PST.trees[tree]) do
        local node
        if type(nodeStr) == "string" then
            node = json.decode(nodeStr)
        else
            node = nodeStr
        end
        node.pos = Vector(node.pos[1], node.pos[2])
        tmpTreeData[tonumber(nodeID)] = node

        node.id = tonumber(nodeID)
        node.sprite = tonumber(node.type)

        -- Nodes using custom images have their type set to 5000+
        if node.customID ~= nil then
            node.sprite = node.sprite % 1000
        end
    end

    -- Setup node links after they've been initialized
    local nodeConnections = {}
    for nodeID, node in pairs(tmpTreeData) do
        if node.adjacent ~= nil then
            for _, adjacentID in ipairs(node.adjacent) do
                -- Check connection hasn't been made already
                local connectionDone = false
                for _, connection in ipairs(nodeConnections) do
                    if (connection[1] == nodeID and connection[2] == adjacentID) or
                    (connection[1] == adjacentID and connection[2] == nodeID) then
                        connectionDone = true
                    end
                end

                if not connectionDone then
                    local adjacentNode = tmpTreeData[adjacentID]
                    if adjacentNode ~= nil then
                        local linkType = nil
                        local dirX = adjacentNode.pos.X - node.pos.X
                        local dirY = adjacentNode.pos.Y - node.pos.Y

                        if math.abs(dirX) <= 2 and math.abs(dirY) <= 2 then
                            if node.pos.X == adjacentNode.pos.X then
                                linkType = "Vertical"
                            elseif node.pos.Y == adjacentNode.pos.Y then
                                linkType = "Horizontal"
                            elseif math.abs(dirX) == math.abs(dirY) then
                                linkType = "Diagonal"
                            end
                        end

                        -- If still nil then there's no visual connection possible
                        if linkType ~= nil then
                            table.insert(nodeConnections, {nodeID, adjacentID})

                            local newLink = {
                                pos = node.pos,
                                type = linkType,
                                dirX = dirX,
                                dirY = dirY,
                                node1 = nodeID,
                                node2 = adjacentID,
                                origScale = Vector.One
                            }
                            local newLinkScale = Vector.One
                            if (adjacentNode.pos.X <= node.pos.X and adjacentNode.pos.Y > node.pos.Y) or (adjacentNode.pos.X > node.pos.X and adjacentNode.pos.Y <= node.pos.Y) then
                                newLinkScale.X = -1
                            end
                            if linkType == "Diagonal" and math.abs(dirX) == 2 then
                                newLinkScale.X = newLinkScale.X * 2
                            end
                            if math.abs(dirX) == 2 or math.abs(dirY) == 2 then
                                newLinkScale.Y = newLinkScale.Y * 2
                            end
                            newLink.origScale = newLinkScale
                            table.insert(PST.nodeLinks[tree], newLink)
                        end
                    end
                end
            end
        end
    end
    PST.trees[tree] = tmpTreeData;
    PST:resetNodes(tree)
	PST:updateNodes(tree, true)
end

-- Reset node allocation for the given tree
---@param tree? string|number Which tree to reset. If nil, reset all trees
function PST:resetNodes(tree)
    if tree == nil then
        for subTree, _ in pairs(PST.trees) do
            PST:resetNodes(subTree)
        end
        return
    end

    if PST.modData.treeNodes[tree] == nil then
        PST.modData.treeNodes[tree] = { [0] = false }
    end
end

-- Add a table of modifiers into tree data.
-- Number modifiers are added to the tree value by default. To set a number value instead of adding, the modifier can arrive as a table {value = (number), set = true}.
---@param modList table Table with modifiers and their values to be added/set
---@param addToSnapshot? boolean If true, add to the tree snapshot modifiers instead (should be true if modifying current run mods)
function PST:addModifiers(modList, addToSnapshot)
    local tmpFlags = 0
    for modName, val in pairs(modList) do
        local treeRef = PST.treeMods
        if addToSnapshot then
            treeRef = PST.modData.treeModSnapshot
        end
        if not treeRef then
            Console.PrintWarning("Error in PST:addModifier, treeRef is nil.")
            break
        end

        if type(val) == "table" and val.set ~= nil and val.value ~= nil then
            -- Force set
            treeRef[modName] = val.value
        else
            if treeRef[modName] ~= nil and type(treeRef[modName]) == "number" and type(val) == "number" then
                treeRef[modName] = treeRef[modName] + val
            else
                treeRef[modName] = val
            end
        end

        -- Determine flags to check
        if addToSnapshot and tmpFlags ~= PST.allstatsCache then
            if modName == "allstats" or modName == "allstatsPerc" then
                tmpFlags = PST.allstatsCache
            elseif modName == "damage" or modName == "damagePerc" then
                tmpFlags = tmpFlags | CacheFlag.CACHE_DAMAGE
            elseif modName == "speed" or modName == "speedPerc" then
                tmpFlags = tmpFlags | CacheFlag.CACHE_SPEED
            elseif modName == "range" or modName == "rangePerc" then
                tmpFlags = tmpFlags | CacheFlag.CACHE_RANGE
            elseif modName == "tears" or modName == "tearsPerc" then
                tmpFlags = tmpFlags | CacheFlag.CACHE_FIREDELAY
            elseif modName == "shotSpeed" or modName == "shotSpeedPerc" then
                tmpFlags = tmpFlags | CacheFlag.CACHE_SHOTSPEED
            elseif modName == "luck" or modName == "luckPerc" then
                tmpFlags = tmpFlags | CacheFlag.CACHE_LUCK
            end
        end
    end
    if tmpFlags ~= 0 and addToSnapshot then
        PST:updateCacheDelayed(tmpFlags)
    end
    PST:save()
end

-- Check if node can be allocated/unallocated, checks for skill/respec point availability of the given tree
function PST:isNodeAllocatable(tree, nodeID, allocation)
    local infSP = PST.debugOptions.infSP
    local infRespec = PST.debugOptions.infRespec

    if allocation then
        -- Allocation
        if not infSP then
            if (tree == "global" or tree == "starTree") and PST.modData.skillPoints <= 0 then
                return false
            elseif tree ~= "global" and tree ~= "starTree" and PST.modData.charData[tree] ~= nil then
                if PST.modData.charData[tree].skillPoints <= 0 then
                    return false
                end
            end
        end
        if PST.trees[tree][nodeID].name == "Star Tree" and not PST:SC_isStarTreeUnlocked() then
            return false
        end
        return PST.trees[tree][nodeID].available and not PST:isNodeAllocated(tree, nodeID)
    else
        -- Deallocation (e.g. respec)
        if not PST:isNodeAllocated(tree, nodeID) or
        (PST.modData.respecPoints <= 0 and not infRespec) then
            return false
        end

        -- Check that adjacent nodes remain reachable from root nodes after deallocation
        local adjacentNodes = PST.trees[tree][nodeID].adjacent
        if adjacentNodes ~= nil then
            local adjacentReachable = true
            for _, adjacentID in ipairs(adjacentNodes) do
                if PST:isNodeAllocated(tree, adjacentID) then
                    if PST.trees[tree][nodeID].alwaysAvailable or not PST:isNodeReachable(tree, adjacentID, {nodeID}) then
                        adjacentReachable = false
                        break
                    end
                end
            end
            if not adjacentReachable then
                return false
            end
        end
    end
    return true
end

-- Allocates a node in the given tree
function PST:allocateNodeID(tree, nodeID, allocation)
    if allocation == nil then
        allocation = false
    end

    PST.modData.treeNodes[tree][nodeID] = allocation
    PST:updateNodes(tree, true)
    PST:save()
end

local nodeReachableFound = false
-- Returns whether the given node can be reached from root nodes through allocated nodes
---@param tree string -- Tree to search in, can be "global" or a character name e.g. "Isaac"
---@param targetNodeID integer -- Node ID to search for
---@param exclude? integer[] -- List of IDs of nodes to exclude in the search, even if allocated
---@param start? integer -- For recursion, should start as nil
---@param visited? any -- For recursion, should start as an empty table
---@return boolean
function PST:isNodeReachable(tree, targetNodeID, exclude, start, visited)
    if PST.debugOptions.allAvailable then
        return true
    end

    if exclude == nil then
        exclude = {}
    end

    if start == targetNodeID then
        return true
    end

    if visited == nil then
        -- First iteration
        local tmpVisited = {}
        nodeReachableFound = false

        -- Start from root nodes (alwaysAvailable set to true)
        for tmpNodeID, node in pairs(PST.trees[tree]) do
            if node.alwaysAvailable then
                table.insert(tmpVisited, tmpNodeID)
                if tmpNodeID == targetNodeID then
                    return true
                elseif PST:isNodeAllocated(tree, tmpNodeID) then
                    return PST:isNodeReachable(tree, targetNodeID, exclude, tmpNodeID, tmpVisited)
                end
            end
        end
    elseif start ~= nil then
        local node = PST.trees[tree][start]
        for _, adjacentNode in ipairs(node.adjacent) do
            if not PST:arrHasValue(visited, adjacentNode) then
                table.insert(visited, adjacentNode)
                if adjacentNode == targetNodeID then
                    nodeReachableFound = true
                elseif PST:isNodeAllocated(tree, adjacentNode) and not PST:arrHasValue(exclude, adjacentNode) then
                    if PST:isNodeReachable(tree, targetNodeID, exclude, adjacentNode, visited) then
                        nodeReachableFound = true
                    end
                end
            end
        end
    end

    return nodeReachableFound
end

-- Include Skill Trees API
PST.loadingBaseTrees = true
include("scripts.tree_data.SkillTreesAPI")
-- Include base tree node banks
include("scripts.tree_data.globalTreeBank")
include("scripts.tree_data.starTreeBank")
include("scripts.tree_data.isaacTreeBank")
include("scripts.tree_data.magdaleneTreeBank")
include("scripts.tree_data.cainTreeBank")
include("scripts.tree_data.judasTreeBank")
include("scripts.tree_data.bluebabyTreeBank")
include("scripts.tree_data.eveTreeBank")
include("scripts.tree_data.samsonTreeBank")
include("scripts.tree_data.azazelTreeBank")
include("scripts.tree_data.lazarusTreeBank")
include("scripts.tree_data.edenTreeBank")
include("scripts.tree_data.theLostTreeBank")
include("scripts.tree_data.lilithTreeBank")
include("scripts.tree_data.keeperTreeBank")
include("scripts.tree_data.apollyonTreeBank")
include("scripts.tree_data.theForgottenTreeBank")
include("scripts.tree_data.bethanyTreeBank")
include("scripts.tree_data.jacobEsauTreeBank")
-- Tainted trees
include("scripts.tree_data.tainted.taintedIsaacTreeBank")
include("scripts.tree_data.tainted.taintedMagdaleneTreeBank")
include("scripts.tree_data.tainted.taintedCainTreeBank")
include("scripts.tree_data.tainted.taintedJudasTreeBank")
-- Custom chars
include("scripts.tree_data.sirenTreeBank")
PST.loadingBaseTrees = false