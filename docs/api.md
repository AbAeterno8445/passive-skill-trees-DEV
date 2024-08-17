# SkillTreesAPI

The mod once loaded exposes a PST.SkillTreesAPI object that grants some helper functions:

### **PST.SkillTreesAPI.AddCharacterTree(charName: string, treeData: string | table)**

Attempts to create a tree and associate it to the given character name.

- **charName:** case-sensitive name of the target character, e.g. "Isaac" or "Jacob & Esau".
- **treeData:** JSON string or parsed object containing the tree's data, ideally generated using the isaac-skilltreegen app ([found here](https://github.com/AbAeterno8445/isaac-skilltreegen)).

- **Example usage:**

  ```lua
  function initBobSkillTree()
      if PST == nil then
          return
      end

      PST.SkillTreesAPI.AddCharacterTree("Bob", false, [[
          ...Generated tree JSON data...
      ]])
  end
  ```

### **PST.SkillTreesAPI.IsNodeAllocated(tree: string, nodeName: string)**

Returns whether the target node is allocated in the given tree. Bear in mind this state can change in the middle of a run, e.g. if you open the tree then allocate/respec this node.

- **tree:** name of the target tree, usually equal to the character's name. Non-character trees include "global" and "starTree".
- **nodeName:** Name of the target node.

### **PST.SkillTreesAPI.GetSnapshotMod(mod: string, default: any)**

Get a mod's current value within a run. Runs use a 'snapshot' table that contains all global and character tree mods, and isn't changed by node allocation changes in the tree mid-run.

- **mod:** Name of the modifier applied by an allocated node.
- **default:** Default value to be returned if the modifier is not found.

### **PST.SkillTreesAPI.InitCustomNodeImage(customID: string, sprite: Sprite)**

Initialize an image containing custom nodes.

- **customID:** "Custom Identifier" field that matching nodes should have.
- **sprite:** Target sprite to get the nodes from. Should have a "Default" animation where each frame is an isolated, centered node sprite.

### **PST.SkillTreesAPI.AddModifierCategory(categoryName: string, displayText: string, color: KColor):**

Initialize a category for modifiers, to be displayed in the tree's "Active Modifiers" view.

- **categoryName:** Name of the category value, to be referenced later when using this category.
- **displayText:** Text to be displayed as the category's title in the Active Modifiers view.
- **color:** Text color for the category and its mods.

### **PST.SkillTreesAPI.AddModifierDescription(modName: string, modCategory: string, descriptionFormat: string | string[], addPlus: boolean, sortValue: number)**

Add a description to the given modifier, to be displayed in the tree's "Active Modifiers" view.

- **modName:** Modifier value name.
- **modCategory:** Category value name.
- **descriptionFormat:** String or list of formatted strings to be processed by string.format(). The latter is fed the modifier value when displaying the text.
- **addPlus:** If true, send a "+" string before the mod value to the description's string.format() call, only if the mod value is positive. Useful for mods that can go negative.
- **sortValue:** Number used for sorting, the higher it is, the lower the text's order of appearance.

# Example Mod

Small mod that showcases usage of this API with a simple use case:

https://github.com/AbAeterno8445/isaac-custom-skilltree-example
