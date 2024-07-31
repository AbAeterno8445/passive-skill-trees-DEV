local json = require("json")

PST.trees = {}
PST.nodeLinks = {}

-- Include tree node banks
include("scripts.tree_data.globalTreeBank")
include("scripts.tree_data.isaacTreeBank")
include("scripts.tree_data.magdaleneTreeBank")
include("scripts.tree_data.cainTreeBank")
include("scripts.tree_data.judasTreeBank")
include("scripts.tree_data.bluebabyTreeBank")
include("scripts.tree_data.eveTreeBank")
include("scripts.tree_data.samsonTreeBank")
include("scripts.tree_data.azazelTreeBank")

-- Sanitize json data in banks
for treeID, tree in pairs(PST.trees) do
    local tmpTreeData = {}
    for nodeID, nodeStr in pairs(tree) do
        local node = json.decode(nodeStr)
        node.pos = Vector(node.pos[1], node.pos[2])
        tmpTreeData[tonumber(nodeID)] = node
    end
    PST.trees[treeID] = tmpTreeData;
end

-- Initial extra setup for nodes
function PST:initTreeNodes(tree)
    for nodeID, node in pairs(PST.trees[tree]) do
        node.id = nodeID
        node.sprite = Sprite("gfx/ui/skilltrees/nodes/tree_nodes.anm2", true)
        node.sprite:Play(node.type, true)
        node.allocatedSprite = Sprite("gfx/ui/skilltrees/nodes/tree_nodes.anm2", true)
        node.allocatedSprite:Play("Allocated " .. node.size, true)

        -- Setup node links
        local nodeConnections = {}
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
                    local adjacentNode = PST.trees[tree][adjacentID]
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
                                sprite = Sprite("gfx/ui/skilltrees/nodes/node_links.anm2", true),
                                origScale = Vector.One
                            }
                            if (adjacentNode.pos.X <= node.pos.X and adjacentNode.pos.Y > node.pos.Y) or (adjacentNode.pos.X > node.pos.X and adjacentNode.pos.Y <= node.pos.Y) then
                                newLink.sprite.Scale.X = -1
                            end
                            if linkType == "Diagonal" and math.abs(dirX) == 2 then
                                newLink.sprite.Scale.X = newLink.sprite.Scale.X * 2
                            end
                            if math.abs(dirX) == 2 or math.abs(dirY) == 2 then
                                newLink.sprite.Scale.Y = newLink.sprite.Scale.Y * 2
                            end
                            newLink.origScale = Vector(newLink.sprite.Scale.X, newLink.sprite.Scale.Y)
                            table.insert(PST.nodeLinks[tree], newLink)
                        end
                    end
                end
            end
        end
    end
end
for tree, _ in pairs(PST.trees) do
    PST:initTreeNodes(tree)
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
        local treeRef = PST.modData.treeMods
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
        if addToSnapshot and tmpFlags ~= CacheFlag.CACHE_ALL then
            if modName == "allstats" or modName == "allstatsPerc" then
                tmpFlags = CacheFlag.CACHE_ALL
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
        Isaac.GetPlayer():AddCacheFlags(tmpFlags, true)
    end
    PST:save()
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
        if not node.available then
            node.sprite.Color = Color(0.4, 0.4, 0.4, 1)
        else
            node.sprite.Color = Color(1, 1, 1, 1)
        end

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
        node.sprite.Color = Color(1, 1, 1, 1)
    end
end

-- Check if node is allocated
function PST:isNodeAllocated(tree, nodeID)
    return PST.modData.treeNodes[tree][nodeID]
end

-- Check if node can be allocated/unallocated, checks for skill/respec point availability of the given tree
function PST:isNodeAllocatable(tree, nodeID, allocation)
    local infSP = PST.debugOptions.infSP
    local infRespec = PST.debugOptions.infRespec
    
    if allocation then
        if not infSP then
            if tree == "global" and PST.modData.skillPoints <= 0 then
                return false
            elseif tree ~= "global" and PST.modData.charData[tree] ~= nil then
                if PST.modData.charData[tree].skillPoints <= 0 then
                    return false
                end
            end
        end
        return PST.trees[tree][nodeID].available and not PST:isNodeAllocated(tree, nodeID)
    else
        if not PST:isNodeAllocated(tree, nodeID) or
        (PST.modData.respecPoints <= 0 and not infRespec) then
            return false
        end

        -- If deallocating, check that adjacent nodes that require this one are not allocated
        local adjacentNodes = PST.trees[tree][nodeID].adjacent
        if adjacentNodes ~= nil then
            for _, adjacentID in ipairs(adjacentNodes) do
                local requiredNodes = PST.trees[tree][adjacentID].requires
                if PST:isNodeAllocated(tree, adjacentID) and requiredNodes ~= nil then
                    for _, requiredID in ipairs(requiredNodes) do
                        if requiredID == nodeID then
                            return false
                        end
                    end
                end
            end
        end
    end
    return true
end

-- Allocates a node
function PST:allocateNodeID(tree, nodeID, allocation)
    if allocation == nil then
        allocation = false
    end

    PST.modData.treeNodes[tree][nodeID] = allocation
    PST:updateNodes(tree)
    PST:save()
end