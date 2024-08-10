# SkillTreesAPI

The mod once loaded exposes a PST.SkillTreesAPI object that grants some helper functions:

- **PST.SkillTreesAPI.AddCharacterTree(charName: string, treeData: string | table):** Attempts to create a tree and associate it to the given character name.

  - **charName:** case-sensitive name of the target character, e.g. "Isaac" or "Jacob & Esau".
  - **treeData:** JSON string or parsed object containing the tree's data, ideally generated using the isaac-skilltreegen app ([found here](https://github.com/AbAeterno8445/isaac-skilltreegen)).

  - **Example usage:**

    ```lua
    function initBobSkillTree()
        if PST.SkillTreesAPI == nil then
            return
        end

        PST.SkillTreesAPI.AddCharacterTree("Bob", [[
            ...Generated tree JSON data...
        ]])
    end
    ```
