# SkillTreesAPI

The mod once loaded exposes a PST.SkillTreesAPI object that grants some helper functions:

#### **PST.SkillTreesAPI.AddCharacterTree(charName: string, treeData: string | table):** Attempts to create a tree and associate it to the given character name.

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

#### **PST.SkillTreesAPI.IsNodeAllocated(tree: string, nodeName: string):** Returns whether the target node is allocated in the given tree. Bear in mind this state can change in the middle of a run, e.g. if you open the tree then allocate/respec this node.

- **tree:** name of the target tree, usually equal to the character's name. Non-character trees include "global" and "starTree".
- **nodeName:** Name of the target node.

#### **PST.SkillTreesAPI.GetTreeSnapshotMod(mod: string, default: any):** Get a mod's current value within a run. Runs use a 'snapshot' table that contains all global and character tree mods, and isn't changed by node allocation changes in the tree mid-run.

- **mod:** Name of the modifier applied by an allocated node.
- **default:** Default value to be returned if the modifier is not found.
