PST.crimConvergenceBuffs = {
    mundaneSlaughter = {
        name = "Mundane Slaughter",
        desc = {
            "Per Crimson Starcore: +1% damage dealt to normal monsters."
        }
    },
    giantSlaughter = {
        name = "Giant Slaughter",
        desc = {
            "Per Crimson Starcore: +1% damage dealt to champions and non-final bosses."
        }
    },
    titanSlaughter = {
        name = "Titan Slaughter",
        desc = {
            "Per Crimson Starcore: +2% damage dealt to final bosses."
        }
    },
    blightseeking = {
        name = "Blightseeking",
        desc = {
            "Per Crimson Starcore: +1% damage dealt to enemies affected by any status effect."
        }
    },
    celerity = {
        name = "Celerity",
        desc = {
            "Your minimum speed in cleared rooms becomes 1 + 0.04 per Crimson Starcore."
        }
    },
    bloodshield = {
        name = "Bloodshield",
        desc = {
            "When entering a room with monsters, become invulnerable for 1.5 seconds.",
            "+0.1 seconds to the invulnerability duration per Crimson Starcore."
        }
    },
    abundanceGoods = {
        name = "Abundance: Goods",
        desc = {
            "Per Crimson Starcore: Whenever a coin/key/bomb first appears, 1% chance to duplicate it.",
            "Triple this chance for vanishing pickups."
        }
    },
    abundanceVitality = {
        name = "Abundance: Vitality",
        desc = {
            "Per Crimson Starcore: Whenever a heart first appears, 1% chance to duplicate it.",
            "Double this chance for vanishing hearts."
        }
    },
    sanguineCharges = {
        name = "Sanguine Charges",
        desc = {
            "Per Crimson Starcore: When using an active item with at least 2 charges, 10% chance to",
            "regain 1 charge. Above 100% total chance, roll for multiple charge regain.",
            "Can overcharge."
        }
    },
    fortuna = {
        name = "Fortuna",
        desc = {
            "Per Crimson Starcore: 1% of your luck stat gets added to your damage."
        }
    },
    starstruck = {
        name = "Starstruck",
        desc = {
            "Per Crimson Starcore: +3% obols found."
        }
    }
}
PST.crimConvBuffsLen = 0
for _ in pairs(PST.crimConvergenceBuffs) do
    PST.crimConvBuffsLen = PST.crimConvBuffsLen + 1
end
PST.crimConvBuffOrder = {
    "mundaneSlaughter", "giantSlaughter", "titanSlaughter", "blightseeking", "celerity",
    "bloodshield", "abundanceGoods", "abundanceVitality", "sanguineCharges", "fortuna",
    "starstruck"
}