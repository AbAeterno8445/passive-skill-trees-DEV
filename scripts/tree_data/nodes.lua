include("scripts.tree_data.globalTreeBank")

-- Initial extra setup for nodes
for nodeID, node in pairs(SkillTrees.nodeData.global) do
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
                local adjacentNode = SkillTrees.nodeData.global[adjacentID]
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
                    if math.abs(dirX) == 2 then
                        newLink.sprite.Scale.X = 2
                    elseif math.abs(dirY) == 2 then
                        newLink.sprite.Scale.Y = 2
                    end
                    table.insert(SkillTrees.nodeData.nodeLinks, newLink)
                end
            end
        end
    end
end

function SkillTrees:resetNodes()
    for nodeID, _ in pairs(SkillTrees.nodeData.global) do
        SkillTrees.modData.treeNodes[nodeID] = false
    end
end

-- Add a table of modifiers into tree data
function SkillTrees:addModifier(modList)
    for modName, val in pairs(modList) do
        SkillTrees.modData.treeMods[modName] = SkillTrees.modData.treeMods[modName] + val
    end
end

-- Update tree state
function SkillTrees:updateNodes()
    SkillTrees:resetMods()

    local tmpAvailableNodes = {}
    for nodeID, node in pairs(SkillTrees.nodeData.global) do
        local allocated = SkillTrees:isNodeAllocated(nodeID)

        -- Count allocated nodes as available
        node.available = allocated or node.alwaysAvailable == true
        if not node.available then
            node.sprite.Color = Color(0.4, 0.4, 0.4, 1)
        else
            node.sprite.Color = Color(1, 1, 1, 1)
        end

        if node.adjacent ~= nil and allocated then
            -- If allocated, make adjacent nodes available
            for _, subNodeID in ipairs(node.adjacent) do
                tmpAvailableNodes[subNodeID] = SkillTrees.nodeData.global[subNodeID]
            end
        end

        -- Update total modifiers
        if SkillTrees:isNodeAllocated(nodeID) then
            SkillTrees:addModifier(node.modifiers)
        end
    end

    -- Update availability
    for _, node in pairs(tmpAvailableNodes) do
        node.available = true
        node.sprite.Color = Color(1, 1, 1, 1)
    end
end

-- Check if node is allocated
function SkillTrees:isNodeAllocated(nodeID)
    return SkillTrees.modData.treeNodes[nodeID]
end

-- Check if node can be allocated/unallocated
function SkillTrees:isNodeAllocatable(nodeID, allocation)
    if allocation then
        return SkillTrees.nodeData.global[nodeID].available and not SkillTrees:isNodeAllocated(nodeID)
    else
        if not SkillTrees:isNodeAllocated(nodeID) then
            return false
        end

        -- If deallocating, check that adjacent nodes that require this one are not allocated
        for _, adjacentID in ipairs(SkillTrees.nodeData.global[nodeID].adjacent) do
            local requiredNodes = SkillTrees.nodeData.global[adjacentID].requires
            if SkillTrees:isNodeAllocated(adjacentID) and requiredNodes ~= nil then
                for _, requiredID in ipairs(requiredNodes) do
                    if requiredID == nodeID then
                        return false
                    end
                end
            end
        end
    end
    return true
end

-- Allocates a node
function SkillTrees:allocateNodeID(nodeID, allocation)
    if allocation == nil then
        allocation = false
    end

    SkillTrees.modData.treeNodes[nodeID] = allocation
    SkillTrees:updateNodes()
    SkillTrees:save()
end