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
        [PlayerType.PLAYER_MAGDALENE_B] = {
            curseDesc = {
                "When entering a room with monsters, if you are above 2 red hearts,",
                "take 1/2 heart damage.",
                "Coins, bombs, keys and chests have a 15% chance to be replaced with a half red heart."
            }
        },
        [PlayerType.PLAYER_CAIN_B] = {
            curseDesc = {
                "Begin with Bag of Crafting if you have it unlocked.",
                "-2 luck while not holding the Bag of Crafting.",
                "100% chance to be cursed with Curse of the Blind when entering a floor.",
                "Crafting an item with Bag of Crafting reduces this chance by 10%."
            }
        },
        [PlayerType.PLAYER_JUDAS_B] = {
            curseDesc = {
                "Starting health is set to 2 black hearts.",
                "Soul hearts are converted to black hearts when spawned.",
                "Take 1 heart of damage when picking up a black heart.",
                "Black hearts grant +0.4 damage on pickup for the current room, up to +1.2.",
                "As Keeper: Coins have a 50% chance to grant 0.2 damage for the current room",
                "instead of healing, up to +1."
            }
        },
        [PlayerType.PLAYER_BLUEBABY_B] = {
            curseDesc = {
                "All starting hearts are converted to soul hearts.",
                "First floor's treasure room is guaranteed to have a poop item.",
                "Further floors' treasure room item has a 50% chance to be replaced with a poop item."
            }
        },
        [PlayerType.PLAYER_EVE_B] = {
            curseDesc = {
                "-33% tears."
            }
        },
        [PlayerType.PLAYER_SAMSON_B] = {
            curseDesc = {
                "-5% all stats when hit, up to -20%.",
                "+2% all stats when killing a monster, up to 10%.",
                "Resets when clearing a room. If the final bonus was negative, take up to 1 heart damage",
                "if you can survive it."
            }
        },
        [PlayerType.PLAYER_AZAZEL_B] = {
            curseDesc = {
                "-40% damage dealt to enemies far away from you, based on your range stat."
            }
        },
        [PlayerType.PLAYER_LAZARUS_B] = {
            curseDesc = {
                "You now have 2 health banks, which switch when clearing a room.",
                "First health bank is your character's starting health. Second bank starts at 2 soul hearts.",
                "Permanent health modifiers will only affect the current bank.",
                "As Keeper: 33% chance for coins to spawn a blue fly instead of healing you.",
                "As Keeper: Cannot heal while you have blue flies."
            }
        },
        [PlayerType.PLAYER_EDEN_B] = {
            curseDesc = {
                "Start with -0.15 all stats.",
                "When hit, shuffle the total reduction randomly across all stats. Additionally",
                "receive -0 ~ 25% to a random stat."
            }
        },
        [PlayerType.PLAYER_THELOST_B] = {},
        [PlayerType.PLAYER_LILITH_B] = {},
        [PlayerType.PLAYER_KEEPER_B] = {},
        [PlayerType.PLAYER_APOLLYON_B] = {},
        [PlayerType.PLAYER_THEFORGOTTEN_B] = {},
        [PlayerType.PLAYER_BETHANY_B] = {},
        [PlayerType.PLAYER_JACOB_B] = {}
    }
}