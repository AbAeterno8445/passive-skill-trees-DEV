PST.SkillTreesAPI = {
    -- Attempts to associate a tree to the given character name. Returns true if successful, false otherwise
    ---@param charName string Character name to associate with the tree
    ---@param treeData any JSON decoded object with tree data
    AddCharacterTree = function(charName, treeData)
        if PST.trees[charName] ~= nil then
            Console.PrintWarning("Passive Skill Trees: could not initialize tree for " .. charName ..", character name already initialized!")
            return false
        end
        PST.nodeLinks[charName] = {}
        PST.trees[charName] = treeData

        PST:initTreeNodes(charName)
        return true
    end
}