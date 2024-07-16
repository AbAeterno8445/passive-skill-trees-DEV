-- Can check modifier types in main.lua, under SkillTrees.modData.treeMods defaults
SkillTrees.nodeData = {
    global = {
        -- Center node
        [1] = {
            pos = Vector(0, 0),
            type = "Central",
            size = "Large",
            name = "Leveling of Isaac",
            description = { "+0.05 all stats" },
            modifiers = {
                allstats = 0.05
            },
            adjacent = { 2 },
            requires = nil,
            alwaysAvailable = true
        },
        -------- TOP BRANCH: XP NODES --------
        [2] = {
            pos = Vector(0, -2),
            type = "Small XP",
            size = "Small",
            name = "XP gain",
            description = { "+2% XP gain" },
            modifiers = { xpgain = 2 },
            adjacent = { 1, 3 },
            requires = { 1 }
        },
        [3] = {
            pos = Vector(0, -3),
            type = "Small XP",
            size = "Small",
            name = "XP gain",
            description = { "+2% XP gain" },
            modifiers = { xpgain = 2 },
            adjacent = { 2 },
            requires = { 2 }
        }
    }
}

for nodeID, node in pairs(SkillTrees.nodeData.global) do
    node.id = nodeID
    node.sprite = Sprite("gfx/ui/skilltrees/nodes/tree_nodes.anm2")
    node.sprite:Play(node.type, true)
    node.allocatedSprite = Sprite("gfx/ui/skilltrees/nodes/tree_nodes.anm2")
    node.allocatedSprite:Play("Allocated " .. node.size, true)
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
            node.sprite.Color.A = 0.4
        else
            node.sprite.Color.A = 1
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
        node.sprite.Color.A = 1
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