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
        [PlayerType.PLAYER_SAMSON] = {},
        [PlayerType.PLAYER_AZAZEL] = {},
        [PlayerType.PLAYER_LAZARUS] = {},
        [PlayerType.PLAYER_EDEN] = {},
        [PlayerType.PLAYER_THELOST] = {},
        [PlayerType.PLAYER_LILITH] = {},
        [PlayerType.PLAYER_KEEPER] = {},
        [PlayerType.PLAYER_APOLLYON] = {},
        [PlayerType.PLAYER_THEFORGOTTEN] = {},
        [PlayerType.PLAYER_BETHANY] = {},
        [PlayerType.PLAYER_JACOB] = {},
        [PlayerType.PLAYER_ISAAC_B] = {},
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