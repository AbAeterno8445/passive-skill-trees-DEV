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
    end
}