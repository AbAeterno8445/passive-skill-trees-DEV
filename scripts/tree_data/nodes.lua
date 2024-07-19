local json = require("json")

SkillTrees.trees = {}
SkillTrees.nodeLinks = {}

-- Include tree node banks
include("scripts.tree_data.globalTreeBank")

-- Sanitize json data in banks
for treeID, tree in pairs(SkillTrees.trees) do
    local tmpTreeData = {}
    for nodeID, nodeStr in pairs(tree) do
        local node = json.decode(nodeStr)
        node.pos = Vector(node.pos[1], node.pos[2])
        tmpTreeData[tonumber(nodeID)] = node
    end
    SkillTrees.trees[treeID] = tmpTreeData;
end

-- Initial extra setup for nodes
function SkillTrees:initTreeNodes(tree)
    for nodeID, node in pairs(SkillTrees.trees[tree]) do
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
                    local adjacentNode = SkillTrees.trees[tree][adjacentID]
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
                                sprite = Sprite("gfx/ui/skilltrees/nodes/node_links.anm2", true)
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
                            table.insert(SkillTrees.nodeLinks[tree], newLink)
                        end
                    end
                end
            end
        end
    end
end
for tree, _ in pairs(SkillTrees.trees) do
    SkillTrees:initTreeNodes(tree)
end

-- Reset node allocation for the given tree
---@param tree? string|number Which tree to reset. If nil, reset all trees
function SkillTrees:resetNodes(tree)
    if tree == nil then
        for subTree, _ in pairs(SkillTrees.trees) do
            SkillTrees:resetNodes(subTree)
        end
        return
    end
    
    if SkillTrees.modData.treeNodes[tree] == nil then
        SkillTrees.modData.treeNodes[tree] = {}
    end

    for nodeID, _ in pairs(SkillTrees.trees[tree]) do
        SkillTrees.modData.treeNodes[tree][nodeID] = false
    end
end

-- Add a table of modifiers into tree data
---@param modList table Table with modifiers and their values to be added/set
---@param addToSnapshot? boolean If true, add to the tree snapshot modifiers instead (should be true if modifying current run mods)
function SkillTrees:addModifier(modList, addToSnapshot)
    for modName, val in pairs(modList) do
        local treeRef = SkillTrees.modData.treeMods
        if addToSnapshot then
            treeRef = SkillTrees.modData.treeModSnapshot
        end
        if not treeRef then
            Console.PrintWarning("Error in SkillTrees:addModifier, treeRef is nil.")
            break
        end

        if treeRef[modName] ~= nil and type(treeRef[modName]) == "number" then
            treeRef[modName] = treeRef[modName] + val
        else
            treeRef[modName] = val
        end
    end
    if addToSnapshot then
        Isaac.GetPlayer():AddCacheFlags(CacheFlag.CACHE_ALL)
        Isaac.GetPlayer():EvaluateItems()
    end
end

-- Update the state for the given tree
---@param tree? string|number Which tree to update. If nil, update all trees
---@param noReset? boolean Whether to reset player mods prior to update
function SkillTrees:updateNodes(tree, noReset)
    if tree == nil then
        for subTree, _ in pairs(SkillTrees.trees) do
            SkillTrees:updateNodes(subTree, true)
        end
        return
    end

    if not noReset then
        SkillTrees:resetMods()
    end

    local tmpAvailableNodes = {}
    for nodeID, node in pairs(SkillTrees.trees[tree]) do
        local allocated = SkillTrees:isNodeAllocated(tree, nodeID)

        -- Count allocated nodes as available
        node.available = allocated or node.alwaysAvailable == true or SkillTrees.debugOptions.allAvailable
        if not node.available then
            node.sprite.Color = Color(0.4, 0.4, 0.4, 1)
        else
            node.sprite.Color = Color(1, 1, 1, 1)
        end

        if node.adjacent ~= nil and allocated then
            -- If allocated, make adjacent nodes available
            for _, subNodeID in ipairs(node.adjacent) do
                tmpAvailableNodes[subNodeID] = SkillTrees.trees[tree][subNodeID]
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
function SkillTrees:isNodeAllocated(tree, nodeID)
    return SkillTrees.modData.treeNodes[tree][nodeID]
end

-- Check if node can be allocated/unallocated, checks for skill/respec point availability of the given tree
function SkillTrees:isNodeAllocatable(tree, nodeID, allocation)
    local infSP = SkillTrees.debugOptions.infSP
    local infRespec = SkillTrees.debugOptions.infRespec
    
    if allocation then
        if not infSP then
            if tree == "global" and SkillTrees.modData.skillPoints <= 0 then
                return false
            elseif tree ~= "global" and SkillTrees.modData.charData[tree] ~= nil then
                if SkillTrees.modData.charData[tree].skillPoints <= 0 then
                    return false
                end
            end
        end
        return SkillTrees.trees[tree][nodeID].available and not SkillTrees:isNodeAllocated(tree, nodeID)
    else
        if not SkillTrees:isNodeAllocated(tree, nodeID) or
        (SkillTrees.modData.respecPoints <= 0 and not infRespec) then
            return false
        end

        -- If deallocating, check that adjacent nodes that require this one are not allocated
        local adjacentNodes = SkillTrees.trees[tree][nodeID].adjacent
        if adjacentNodes ~= nil then
            for _, adjacentID in ipairs(adjacentNodes) do
                local requiredNodes = SkillTrees.trees[tree][adjacentID].requires
                if SkillTrees:isNodeAllocated(tree, adjacentID) and requiredNodes ~= nil then
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
function SkillTrees:allocateNodeID(tree, nodeID, allocation)
    if allocation == nil then
        allocation = false
    end

    SkillTrees.modData.treeNodes[tree][nodeID] = allocation
    SkillTrees:updateNodes(tree)
    SkillTrees:save()
end