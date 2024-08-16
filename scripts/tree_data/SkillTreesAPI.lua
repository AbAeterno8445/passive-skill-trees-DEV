local json = require("json")
PST.SkillTreesAPI = {
    -- Attempts to associate a tree to the given character name. Returns true if successful, false otherwise.
    ---@param charName string Character name to associate with the tree
    ---@param replace boolean If true, replace existing trees associated to the given name
    ---@param treeData any JSON string or decoded object with tree data (ideally from the skilltreegen app)
    AddCharacterTree = function(charName, replace, treeData)
        if PST.trees[charName] ~= nil and not replace then
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
    GetSnapshotMod = function(mod, default)
        return PST:getTreeSnapshotMod(mod, default)
    end,

    -- Initialize an image containing custom nodes
    ---@param customID string "Custom Identifier" field that matching nodes should have
    ---@param sprite Sprite Target sprite to get the nodes from
    InitCustomNodeImage = function(customID, sprite)
        if PST.customNodeImages[customID] ~= nil then
            Console.PrintWarning("Passive Skill Trees: WARNING - Initialized custom node images with existing custom ID " .. customID .. ".")
        end
        PST.customNodeImages[customID] = sprite
    end,

    -- Initialize a category for modifiers, to be displayed in the tree's "Active Modifiers" view
    ---@param categoryName string Name of the category value, to be referenced later when using this category
    ---@param displayText string Text to be displayed as the category's title in the Active Modifiers view
    ---@param color KColor Text color for the category and its mods
    AddModifierCategory = function(categoryName, displayText, color)
        PST.treeModDescriptionCategories[categoryName] = {
            name = displayText,
            color = color
        }
    end,

    -- Add a description to the given modifier, to be displayed in the tree's "Active Modifiers" view
    ---@param modName string Modifier value name
    ---@param modCategory string Category value name
    ---@param descriptionFormat string | string[] String or list of formatted strings to be processed by string.format()
    ---@param addPlus boolean If true, send a "+" string before the mod value to the description's string.format() call, only if the mod value is positive. Useful for mods that can go negative
    ---@param sortValue number Number used for sorting, the higher it is, the lower the text's order of appearance
    AddModifierDescription = function(modName, modCategory, descriptionFormat, addPlus, sortValue)
        PST.treeModDescriptions[modName] = {
            str = descriptionFormat,
            addPlus = addPlus,
            category = modCategory,
            sort = 10000 + sortValue
        }
    end
}