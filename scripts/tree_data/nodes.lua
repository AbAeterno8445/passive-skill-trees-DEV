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
            requires = nil
        },
        -------- XP NODES --------
        [2] = {
            pos = Vector(0, -64),
            type = "Small XP",
            size = "Small",
            name = "XP gain",
            description = { "+2% XP gain" },
            modifiers = { xpgain = 2 },
            requires = { 1 }
        },
        [3] = {
            pos = Vector(0, -102),
            type = "Small XP",
            size = "Small",
            name = "XP gain",
            description = { "+2% XP gain" },
            modifiers = { xpgain = 2 },
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
    for nodeID, node in pairs(SkillTrees.nodeData.global) do
        -- Available/unavailable nodes
        local meetsRequirement = true
        if node.requires ~= nil then
            for _, subNodeID in ipairs(node.requires) do
                if not SkillTrees.modData.treeNodes[subNodeID] then
                    meetsRequirement = false
                    break
                end
            end
        end

        node.available = meetsRequirement
        if meetsRequirement then
            node.sprite.Color.A = 1
        else
            node.sprite.Color.A = 0.4
        end

        -- Update total modifiers
        if SkillTrees.modData.treeNodes[nodeID] then
            SkillTrees:addModifier(node.modifiers)
        end
    end
end

-- Allocates a node
function SkillTrees:allocateNodeID(nodeID, allocation)
    SkillTrees.modData.treeNodes[nodeID] = allocation
    SkillTrees:updateNodes()
    SkillTrees:save()
end