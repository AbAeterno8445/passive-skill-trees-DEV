local treeName = SkillTrees.charNames[PlayerType.PLAYER_ISAAC + 1]
SkillTrees.nodeLinks[treeName] = {}
SkillTrees.trees[treeName] = {
    -- Center node
    [1] = {
        pos = Vector(0, 0),
        type = "Central",
        size = "Large",
        name = "Isaac",
        description = { "+0.05 all stats" },
        modifiers = {
            allstats = 0.05
        },
        adjacent = nil,
        requires = nil,
        alwaysAvailable = true
    }
}