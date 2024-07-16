SkillTrees.nodeLinks.global = {}
SkillTrees.trees.global = {
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
        adjacent = { 2, 4, 10 },
        requires = { 2 }
    },
    ---- Sub-branch: respec nodes ----
    [4] = {
        pos = Vector(1, -3),
        type = "Small Respec",
        size = "Small",
        name = "Respec Chance",
        description = {
            "+5% chance to gain a respec point",
            "when completing a floor."
        },
        modifiers = { respecChance = 5 },
        adjacent = { 3, 5 },
        requires = { 3 }
    },
    [5] = {
        pos = Vector(2, -3),
        type = "Small Respec",
        size = "Small",
        name = "Respec Chance",
        description = {
            "+5% chance to gain a respec point",
            "when completing a floor."
        },
        modifiers = { respecChance = 5 },
        adjacent = { 4, 6 },
        requires = { 4 }
    },
    [6] = {
        pos = Vector(3, -3),
        type = "Small Respec",
        size = "Small",
        name = "Respec Chance",
        description = {
            "+5% chance to gain a respec point",
            "when completing a floor."
        },
        modifiers = { respecChance = 5 },
        adjacent = { 5, 7 },
        requires = { 5 }
    },
    [7] = {
        pos = Vector(4, -3),
        type = "Small Respec",
        size = "Small",
        name = "Respec Chance",
        description = {
            "+5% chance to gain a respec point",
            "when completing a floor."
        },
        modifiers = { respecChance = 5 },
        adjacent = { 6, 8 },
        requires = { 6 }
    },
    [8] = {
        pos = Vector(5, -3),
        type = "Med Respec",
        size = "Med",
        name = "Respec Chance",
        description = {
            "+15% chance to gain a respec point",
            "when completing a floor."
        },
        modifiers = { respecChance = 15 },
        adjacent = { 7, 9 },
        requires = { 7 }
    },
    [9] = {
        pos = Vector(5, -4),
        type = "Large Respec",
        size = "Large",
        name = "Relearning",
        description = {
            "Can no longer gain respec points from completing floors.",
            "Gain 3 respec points when winning a run, and",
            "additionally gain 1 respec point per completed floor in that run."
        },
        modifiers = { respecChance = 15 },
        adjacent = { 8 },
        requires = { 8 }
    },
    ---- End of sub-branch ----
    [10] = {
        pos = Vector(0, -4),
        type = "Small XP",
        size = "Small",
        name = "XP gain",
        description = { "+2% XP gain" },
        modifiers = { xpgain = 2 },
        adjacent = { 3, 11 },
        requires = { 3 }
    },
    [11] = {
        pos = Vector(0, -5),
        type = "Small XP",
        size = "Small",
        name = "XP gain",
        description = { "+2% XP gain" },
        modifiers = { xpgain = 2 },
        adjacent = { 10 },
        requires = { 10 }
    },
}