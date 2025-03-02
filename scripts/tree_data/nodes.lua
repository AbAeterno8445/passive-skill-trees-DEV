local json = require("json")

PST.trees = {}
PST.nodeLinks = {}

include("scripts.tree_data.modifierDescriptions")

function PST:getCurrentSiderealNodes()
    local charData = PST:getCurrentCharData()
    if charData and not charData.siderealNodes then charData.siderealNodes = { [0] = false } end
    if charData then
        return charData.siderealNodes
    end
    return nil
end

-- Check if node is allocated
function PST:isNodeAllocated(tree, nodeID)
    if tree == "sidereal" then
        local siderealNodes = PST:getCurrentSiderealNodes()
        if siderealNodes then return siderealNodes[nodeID] == 1 end
        return false
    end
    if not PST.modData.treeNodes[tree] then return false end
    return PST.modData.treeNodes[tree][nodeID] == 1
end

-- Check if node with given name is allocated
function PST:isNodeNameAllocated(tree, nodeName)
    local tmpNodes = PST.modData.treeNodes[tree]
    if tree == "sidereal" then
        tmpNodes = PST:getCurrentSiderealNodes()
    end
    if not tmpNodes then return false end
    for nodeID, _ in pairs(tmpNodes) do
        local targetNode = PST.trees[tree][nodeID]
        if PST:isNodeAllocated(tree, nodeID) and targetNode and targetNode.name == nodeName then
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

    if tree == "sidereal" then
        local siderealNodes = PST:getCurrentSiderealNodes()
        if siderealNodes == nil then
            local currentChar = PST:getCurrentCharData()
            if currentChar then currentChar.siderealNodes = { [0] = false } end
        end
    elseif PST.modData.treeNodes[tree] == nil then
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
    if addToSnapshot then
        if tmpFlags ~= 0 then
            PST:updateCacheDelayed(tmpFlags)
        end
        PST.savePending = true
    end
end

-- 'Subtract' a list of modifiers from the tree snapshot, adding or setting their reversed values
function PST:subtractModifiers(modList)
    local tmpMods = {}
    for modName, modVal in pairs(modList) do
        if type(modVal) == "boolean" then
            tmpMods[modName] = not modVal
        elseif type(modVal) == "number" then
            tmpMods[modName] = -modVal
        else
            tmpMods[modName] = { value = modVal, set = true }
        end
    end
    PST:addModifiers(tmpMods, true)
end

local siderealTravelNodes = {"Sidereal Vicinity", "Sidereal Region", "Sidereal Expanse"}
-- Nodes with names included here can't be respecced
local respecBans = {
    "Sidereal Universalization", "Additional Septentrional Choice"
}

-- Check if node can be allocated/unallocated, checks for skill/respec point availability of the given tree
function PST:isNodeAllocatable(tree, nodeID, allocation)
    local infSP = PST.debugOptions.infSP
    local infRespec = PST.debugOptions.infRespec
    local nodeData = PST.trees[tree][nodeID]
    if not nodeData then return false end

    if allocation then
        -- Allocation
        if not infSP then
            local reqs = nodeData.reqs
            local noSP = (reqs and reqs.noSP)
            if (tree == "global" or tree == "starTree") and PST.modData.skillPoints <= 0 and not noSP then
                return false
            elseif tree ~= "global" and tree ~= "starTree" and PST.modData.charData[tree] ~= nil then
                if PST.modData.charData[tree].skillPoints <= 0 and not noSP then
                    return false
                end
            end

            -- Special node requirements
            if reqs then
                local currentChar = PST:getCurrentCharData()
                -- Arcane obols requirement
                local obolReq = reqs.obols
                if type(obolReq) == "table" and obolReq.var and PST[obolReq.var] then
                    obolReq = PST[obolReq.var]
                end
                if obolReq and currentChar and (currentChar.arcaneObols or 0) < obolReq then
                    return false
                end

                -- Expedition depth requirement
                local expReq = reqs.expeditionDepth
                if expReq and PST.modData.expeditionDepth <= expReq then
                    return false
                end

                -- Uber expedition depth requirement
                local uberReq = reqs.uberDepth
                if uberReq and PST.modData.uberExpedDepth <= uberReq then
                    return false
                end

                -- Character level requirement
                local charlvlReq = reqs.charLevel
                if charlvlReq and currentChar and currentChar.level < charlvlReq then
                    return false
                end

                -- Crimson starcores requirement
                local crimsonStarcoreReq = reqs.crimsonStarcore
                if crimsonStarcoreReq and currentChar and (not currentChar.crimsonStarcores or
                (currentChar.crimsonStarcores and currentChar.crimsonStarcores < crimsonStarcoreReq)) then
                    return false
                end

                -- Sidereal Artifact objectives
                local sideArtiReq = reqs.sideArti
                if sideArtiReq then
                    -- Objective unlocked
                    local sideArtiName
                    for tmpMod, _ in pairs(nodeData.modifiers) do
                        if PST.sideArtiData[tmpMod] then
                            sideArtiName = tmpMod
                            if not PST:isSideArtiUnlocked(tmpMod) then
                                return false
                            end
                            break
                        end
                    end
                    -- Artifact selection limit
                    local charData = PST:getCurrentCharData()
                    if charData and sideArtiName then
                        if string.find(nodeData.name, "Septentrion") ~= nil then
                            if #charData.northArtis >= charData.maxNorthArtis then
                                return false
                            end
                        elseif string.find(nodeData.name, "Meridion") ~= nil then
                            if #charData.southArtis >= charData.maxSouthArtis then
                                return false
                            end
                        end
                    end
                end

                -- Deep-Space nodes
                if reqs.deepSpaceNode and PST.modData.deepSpaceSP == 0 then
                    return false
                end
            end

            -- Sidereal tree: non-travel nodes require 1 global SP
            if tree == "sidereal" and not PST:arrHasValue(siderealTravelNodes, nodeData.name) and PST.modData.skillPoints <= 0 and not noSP then
                return false
            end

            -- Forgotten tree: Spiritful nodes
            if tree == "The Forgotten" and PST:strStartsWith(nodeData.name, "Spirit-") and PST:spiritfulNodesAllocated(false) > 0 then
                return false
            end
        end
        if nodeData.name == "Star Tree" and not PST:SC_isStarTreeUnlocked() then
            return false
        end
        return nodeData.available and not PST:isNodeAllocated(tree, nodeID)
    else
        -- Deallocation (e.g. respec)
        if not PST:isNodeAllocated(tree, nodeID) or
        (PST.modData.respecPoints <= 0 and not infRespec) then
            return false
        end

        if PST:arrHasValue(respecBans, nodeData.name) and not infRespec then
            return false
        end

        -- Check that adjacent nodes remain reachable from root nodes after deallocation
        local adjacentNodes = nodeData.adjacent
        if adjacentNodes ~= nil then
            local adjacentReachable = true
            for _, adjacentID in ipairs(adjacentNodes) do
                if PST:isNodeAllocated(tree, adjacentID) then
                    if nodeData.alwaysAvailable or not PST:isNodeReachable(tree, adjacentID, {nodeID}) then
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
        allocation = 0
    end
    if tree == "sidereal" then
        local siderealNodes = PST:getCurrentSiderealNodes()
        if siderealNodes then siderealNodes[nodeID] = allocation end
    else
        PST.modData.treeNodes[tree][nodeID] = allocation
    end
    -- Dynamic Tree Mode - update tree snapshot
    if Isaac.IsInGame() and PST:getTreeSnapshotMod("dynamicMode", false) then
        local tmpNode = PST.trees[tree][nodeID]
        if tmpNode and tmpNode.modifiers and tmpNode.name ~= "Dynamic Tree Mode" then
            local tmpMods = tmpNode.modifiers
            if allocation == 0 then
                PST:subtractModifiers(tmpMods)
            else
                PST:addModifiers(tmpMods, true)
            end
        end
    end

    PST:updateNodes(tree, true)
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
                    PST:isNodeReachable(tree, targetNodeID, exclude, tmpNodeID, tmpVisited)
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
include("scripts.tree_data.siderealTreeBank")
-- Character Trees
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
include("scripts.tree_data.tainted.taintedBlueBabyTreeBank")
include("scripts.tree_data.tainted.taintedEveTreeBank")
include("scripts.tree_data.tainted.taintedSamsonTreeBank")
include("scripts.tree_data.tainted.taintedAzazelTreeBank")
include("scripts.tree_data.tainted.taintedLazarusTreeBank")
include("scripts.tree_data.tainted.taintedEdenTreeBank")
include("scripts.tree_data.tainted.taintedLostTreeBank")
include("scripts.tree_data.tainted.taintedLilithTreeBank")
include("scripts.tree_data.tainted.taintedKeeperTreeBank")
include("scripts.tree_data.tainted.taintedApollyonTreeBank")
include("scripts.tree_data.tainted.taintedForgottenTreeBank")
include("scripts.tree_data.tainted.taintedBethanyTreeBank")
include("scripts.tree_data.tainted.taintedJacobTreeBank")
-- Custom chars
include("scripts.tree_data.sirenTreeBank")
include("scripts.tree_data.tainted.taintedSirenTreeBank")
PST.loadingBaseTrees = false