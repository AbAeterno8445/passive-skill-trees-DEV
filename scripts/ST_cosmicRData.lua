-- Init Cosmic Realignment node data
PST.cosmicRData = {
    menuOpen = false,
    menuX = 0,
    menuY = 0,
    charSprite = Sprite("gfx/ui/skilltrees/cosmic_realignment_chars.anm2", true),
    hoveredCharID = nil,
    characters = {
        [PlayerType.PLAYER_ISAAC] = {
            curseDesc = { "-0.1 all stats" }
        },
        [PlayerType.PLAYER_MAGDALENE] = {
            curseDesc = { "Starting speed is set to 0.85." }
        },
        [PlayerType.PLAYER_CAIN] = {
            curseDesc = { "-0.5 luck" }
        },
        [PlayerType.PLAYER_JUDAS] = {
            curseDesc = { "-10% damage" }
        },
        [PlayerType.PLAYER_BLUEBABY] = {
            curseDesc = { "The first 2 non-soul heart pickups you collect vanish.", "This effect resets every floor." }
        },
        [PlayerType.PLAYER_EVE] = {
            curseDesc = { "-8% all stats if you have 1 remaining red heart or less." }
        },
        [PlayerType.PLAYER_SAMSON] = {
            curseDesc = { "-0.15 damage when you are hit, up to -0.9. Resets every room." }
        },
        [PlayerType.PLAYER_AZAZEL] = {
            curseDesc = { "-20% range" }
        },
        [PlayerType.PLAYER_LAZARUS] = {
            curseDesc = { "Items that grant extra lives no longer show up." }
        },
        [PlayerType.PLAYER_EDEN] = {
            curseDesc = { "-0.1 to a random stat when entering a floor, from floor 2 onwards." }
        },
        [PlayerType.PLAYER_THELOST] = {
            curseDesc = {
                "You may not have more than 2 red/coin hearts, and non-red hearts vanish on pickup.",
                "If Holy Mantle is unlocked with The Lost, start with Wafer."
            }
        },
        [PlayerType.PLAYER_LILITH] = {
            curseDesc = {
                "Follower items have a 75% chance to be rerolled when spawned.",
                "Incubus can no longer show up.",
                "-8% all stats while you don't have a follower."
            }
        },
        [PlayerType.PLAYER_KEEPER] = {
            curseDesc = {
                "Coins have a 50% chance to vanish when collected.",
                "25% chance to take 1/2 heart damage when a coin vanishes.",
                "When entering a new floor, if less than 5 coins were picked up in the previous",
                "floor, halve your coin count."
            }
        },
        [PlayerType.PLAYER_APOLLYON] = {
            curseDesc = {
                "-0.04 to a random stat (except speed) when picking up a passive item."
            }
        },
        [PlayerType.PLAYER_THEFORGOTTEN] = {
            curseDesc = {
                "Convert all starting hearts to bone hearts.",
                "When entering a new floor, convert a red/bone heart container into a full soul heart.",
                "As Keeper: -4% all stats per active blue fly, up to -40%. This effect stays",
                "until clearing the room, even if blue flies are killed."
            }
        },
        [PlayerType.PLAYER_BETHANY] = {
            curseDesc = {
                "Soul and Black hearts are halved once collected.",
                "-0.02 luck when picking up a soul or black heart.",
                "As Keeper: Permanent -0.01 luck whenever a blue fly spawns, up to -2."
            }
        },
        [PlayerType.PLAYER_JACOB] = {
            curseDesc = {
                "Start with -25% damage and tears.",
                "-50% xp gain.",
                "Halve these reductions when first obtaining an item, up to 8 times.",
            }
        },
        [PlayerType.PLAYER_ISAAC_B] = {
            curseDesc = {
                "Items are removed from the first treasure room you enter.",
                "-4% all stats per item obtained after the 8th one, up to -40%."
            }
        },
        [PlayerType.PLAYER_MAGDALENE_B] = {},
        [PlayerType.PLAYER_CAIN_B] = {},
        [PlayerType.PLAYER_JUDAS_B] = {},
        [PlayerType.PLAYER_BLUEBABY_B] = {},
        [PlayerType.PLAYER_EVE_B] = {},
        [PlayerType.PLAYER_SAMSON_B] = {},
        [PlayerType.PLAYER_AZAZEL_B] = {},
        [PlayerType.PLAYER_LAZARUS_B] = {},
        [PlayerType.PLAYER_EDEN_B] = {},
        [PlayerType.PLAYER_THELOST_B] = {},
        [PlayerType.PLAYER_LILITH_B] = {},
        [PlayerType.PLAYER_KEEPER_B] = {},
        [PlayerType.PLAYER_APOLLYON_B] = {},
        [PlayerType.PLAYER_THEFORGOTTEN_B] = {},
        [PlayerType.PLAYER_BETHANY_B] = {},
        [PlayerType.PLAYER_JACOB_B] = {}
    }
}