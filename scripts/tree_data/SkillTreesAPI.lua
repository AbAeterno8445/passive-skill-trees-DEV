local json = require("json")
PST.SkillTreesAPI = {
    -- Attempts to associate a tree to the given character name. Returns true if successful, false otherwise.
    ---@param charName string Character name to associate with the tree
    ---@param treeData any JSON string or decoded object with tree data (ideally from the skilltreegen app)
    AddCharacterTree = function(charName, treeData)
        if PST.trees[charName] ~= nil then
            Console.PrintWarning("Passive Skill Trees: could not initialize tree for " .. charName ..", character name already initialized!")
            return false
        end
        PST.nodeLinks[charName] = {}

        local tmpTreeData
        if type(treeData) == "string" then
            tmpTreeData = json.decode(treeData)
        else
            tmpTreeData = treeData
        end
        PST.trees[charName] = tmpTreeData

        PST:initTreeNodes(charName)
        return true
    end,

    -- Check if a node with the given name is allocated in the given tree
    ---@param tree string Name of the target tree, usually equal to the character's name. Non-character trees include "global" and "starTree"
    ---@param nodeName string Name of the target node
    IsNodeAllocated = function(tree, nodeName)
        return PST:isNodeNameAllocated(tree, nodeName)
    end,

    -- Get a mod's current value within a run (runs use a snapshot of all trees it began with)
    ---@param mod string Name of the modifier applied by an allocated node
    ---@param default any Default value to be returned if the modifier is not found
    GetTreeSnapshotMod = function(mod, default)
        return PST:getTreeSnapshotMod(mod, default)
    end
}