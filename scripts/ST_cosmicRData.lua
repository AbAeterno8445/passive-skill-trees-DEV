-- Init Cosmic Realignment node data
PST.cosmicRData = {
    charSprite = Sprite("gfx/ui/skilltrees/cosmic_realignment_chars.anm2", true),
    lockedCharSprite = Sprite("gfx/ui/skilltrees/cosmic_realignment_chars.anm2", true),
    characters = {
        [PlayerType.PLAYER_ISAAC] = {
            curseDesc = { "-0.1 all stats" },
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.ISAACS_HEAD,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.LOST_BABY,
                [CompletionType.SATAN] = Achievement.MOMS_KNIFE,
                [CompletionType.ISAAC] = Achievement.ISAACS_TEARS,
                [CompletionType.LAMB] = Achievement.MISSING_POSTER,
                [CompletionType.BLUE_BABY] = Achievement.D20,
                [CompletionType.ULTRA_GREED] = Achievement.LIL_CHEST,
                [CompletionType.ULTRA_GREEDIER] = Achievement.D1,
                [CompletionType.HUSH] = Achievement.FARTING_BABY,
                [CompletionType.MEGA_SATAN] = Achievement.CRY_BABY,
                [CompletionType.DELIRIUM] = Achievement.D_INFINITY,
                [CompletionType.MOTHER] = Achievement.MEAT_CLEAVER,
                [CompletionType.BEAST] = Achievement.OPTIONS,
                tainted = Achievement.TAINTED_ISAAC,
                allHardMarks = Achievement.BUDDY_BABY
            }
        },
        [PlayerType.PLAYER_MAGDALENE] = {
            curseDesc = { "Starting speed is set to 0.85." },
            unlockReq = Achievement.MAGDALENE,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.MAGGYS_BOW,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.CUTE_BABY,
                [CompletionType.SATAN] = Achievement.GUARDIAN_ANGEL,
                [CompletionType.ISAAC] = Achievement.RELIC,
                [CompletionType.LAMB] = Achievement.MAGGYS_FAITH,
                [CompletionType.BLUE_BABY] = Achievement.CELTIC_CROSS,
                [CompletionType.ULTRA_GREED] = Achievement.CENSER,
                [CompletionType.ULTRA_GREEDIER] = Achievement.GLYPH_OF_BALANCE,
                [CompletionType.HUSH] = Achievement.PURITY,
                [CompletionType.MEGA_SATAN] = Achievement.RED_BABY,
                [CompletionType.DELIRIUM] = Achievement.EUCHARIST,
                [CompletionType.MOTHER] = Achievement.YUCK_HEART,
                [CompletionType.BEAST] = Achievement.CANDY_HEART,
                tainted = Achievement.TAINTED_MAGDALENE,
                allHardMarks = Achievement.COLORFUL_BABY
            }
        },
        [PlayerType.PLAYER_CAIN] = {
            curseDesc = { "-0.5 luck" },
            unlockReq = Achievement.CAIN,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.CAINS_OTHER_EYE,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.GLASS_BABY,
                [CompletionType.SATAN] = Achievement.BAG_OF_BOMBS,
                [CompletionType.ISAAC] = Achievement.BAG_OF_PENNIES,
                [CompletionType.LAMB] = Achievement.ABEL,
                [CompletionType.BLUE_BABY] = Achievement.CAINS_EYE,
                [CompletionType.ULTRA_GREED] = Achievement.EVIL_EYE,
                [CompletionType.ULTRA_GREEDIER] = Achievement.SACK_OF_SACKS,
                [CompletionType.HUSH] = Achievement.D12,
                [CompletionType.MEGA_SATAN] = Achievement.GREEN_BABY,
                [CompletionType.DELIRIUM] = Achievement.SILVER_DOLLAR,
                [CompletionType.MOTHER] = Achievement.GUPPYS_EYE,
                [CompletionType.BEAST] = Achievement.POUND_OF_FLESH,
                tainted = Achievement.TAINTED_CAIN,
                allHardMarks = Achievement.PICKY_BABY
            }
        },
        [PlayerType.PLAYER_JUDAS] = {
            curseDesc = { "-10% damage" },
            unlockReq = Achievement.JUDAS,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.JUDAS_SHADOW,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.SHADOW_BABY,
                [CompletionType.SATAN] = Achievement.JUDAS_TONGUE,
                [CompletionType.ISAAC] = Achievement.GUILLOTINE,
                [CompletionType.LAMB] = Achievement.CURVED_HORN,
                [CompletionType.BLUE_BABY] = Achievement.LEFT_HAND,
                [CompletionType.ULTRA_GREED] = Achievement.MY_SHADOW,
                [CompletionType.ULTRA_GREEDIER] = Achievement.EYE_OF_BELIAL,
                [CompletionType.HUSH] = Achievement.BETRAYAL,
                [CompletionType.MEGA_SATAN] = Achievement.BROWN_BABY,
                [CompletionType.DELIRIUM] = Achievement.SHADE,
                [CompletionType.MOTHER] = Achievement.AKELDAMA,
                [CompletionType.BEAST] = Achievement.REDEMPTION,
                tainted = Achievement.TAINTED_JUDAS,
                allHardMarks = Achievement.BELIAL_BABY
            }
        },
        [PlayerType.PLAYER_BLUEBABY] = {
            curseDesc = { "The first 2 non-soul heart pickups you collect vanish.", "This effect resets every floor." },
            unlockReq = Achievement.BLUE_BABY,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.BLUE_BABYS_ONLY_FRIEND,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.DEAD_BABY,
                [CompletionType.SATAN] = Achievement.FORGET_ME_NOW,
                [CompletionType.ISAAC] = Achievement.ISAAC_HOLDS_THE_D6,
                [CompletionType.LAMB] = Achievement.BLUE_BABYS_SOUL,
                [CompletionType.BLUE_BABY] = Achievement.FATE,
                [CompletionType.ULTRA_GREED] = Achievement.CRACKED_DICE,
                [CompletionType.ULTRA_GREEDIER] = Achievement.MECONIUM,
                [CompletionType.HUSH] = Achievement.FATES_REWARD,
                [CompletionType.MEGA_SATAN] = Achievement.BLUE_BABY,
                [CompletionType.DELIRIUM] = Achievement.KING_BABY,
                [CompletionType.MOTHER] = Achievement.ETERNAL_D6,
                [CompletionType.BEAST] = Achievement.MONTEZUMAS_REVENGE,
                tainted = Achievement.TAINTED_BLUE_BABY,
                allHardMarks = Achievement.HIVE_BABY
            }
        },
        [PlayerType.PLAYER_EVE] = {
            curseDesc = { "-8% all stats if you have 1 remaining red heart or less." },
            unlockReq = Achievement.EVE,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.EVES_MASCARA,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.CROW_BABY,
                [CompletionType.SATAN] = Achievement.RAZOR,
                [CompletionType.ISAAC] = Achievement.EVES_BIRD_FOOT,
                [CompletionType.LAMB] = Achievement.BLACK_LIPSTICK,
                [CompletionType.BLUE_BABY] = Achievement.SACRIFICIAL_DAGGER,
                [CompletionType.ULTRA_GREED] = Achievement.BLACK_FEATHER,
                [CompletionType.ULTRA_GREEDIER] = Achievement.CROW_HEART,
                [CompletionType.HUSH] = Achievement.ATHAME,
                [CompletionType.MEGA_SATAN] = Achievement.LIL_BABY,
                [CompletionType.DELIRIUM] = Achievement.DULL_RAZOR,
                [CompletionType.MOTHER] = Achievement.BIRD_CAGE,
                [CompletionType.BEAST] = Achievement.CRACKED_ORB,
                tainted = Achievement.TAINTED_EVE,
                allHardMarks = Achievement.WHORE_BABY
            }
        },
        [PlayerType.PLAYER_SAMSON] = {
            curseDesc = { "-0.15 damage when you are hit, up to -0.9. Resets every room." },
            unlockReq = Achievement.SAMSON,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.SAMSONS_CHAINS,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.FIGHTING_BABY,
                [CompletionType.SATAN] = Achievement.BLOOD_RIGHTS,
                [CompletionType.ISAAC] = Achievement.BLOODY_LUST,
                [CompletionType.LAMB] = Achievement.SAMSONS_LOCK,
                [CompletionType.BLUE_BABY] = Achievement.BLOODY_PENNY,
                [CompletionType.ULTRA_GREED] = Achievement.LUSTY_BLOOD,
                [CompletionType.ULTRA_GREEDIER] = Achievement.STEM_CELL,
                [CompletionType.HUSH] = Achievement.BLIND_RAGE,
                [CompletionType.MEGA_SATAN] = Achievement.RAGE_BABY,
                [CompletionType.DELIRIUM] = Achievement.BLOODY_CROWN,
                [CompletionType.MOTHER] = Achievement.BLOODY_GUST,
                [CompletionType.BEAST] = Achievement.EMPTY_HEART,
                tainted = Achievement.TAINTED_SAMSON,
                allHardMarks = Achievement.REVENGE_BABY
            }
        },
        [PlayerType.PLAYER_AZAZEL] = {
            curseDesc = { "-20% range" },
            unlockReq = Achievement.AZAZEL,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.NAIL,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.BEGOTTEN_BABY,
                [CompletionType.SATAN] = Achievement.DAEMONS_TAIL,
                [CompletionType.ISAAC] = Achievement.SATANIC_BIBLE,
                [CompletionType.LAMB] = Achievement.DEMON_BABY,
                [CompletionType.BLUE_BABY] = Achievement.ABADDON,
                [CompletionType.ULTRA_GREED] = Achievement.LILITH,
                [CompletionType.ULTRA_GREEDIER] = Achievement.BAT_WING,
                [CompletionType.HUSH] = Achievement.MAW_OF_THE_VOID,
                [CompletionType.MEGA_SATAN] = Achievement.BLACK_BABY,
                [CompletionType.DELIRIUM] = Achievement.DARK_PRINCES_CROWN,
                [CompletionType.MOTHER] = Achievement.DEVILS_CROWN,
                [CompletionType.BEAST] = Achievement.LIL_ABADDON,
                tainted = Achievement.TAINTED_AZAZEL,
                allHardMarks = Achievement.SUCKY_BABY
            }
        },
        [PlayerType.PLAYER_LAZARUS] = {
            curseDesc = { "Items that grant extra lives no longer show up." },
            unlockReq = Achievement.LAZARUS,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.MISSING_NO,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.WRAPPED_BABY,
                [CompletionType.SATAN] = Achievement.BROKEN_ANKH,
                [CompletionType.ISAAC] = Achievement.LAZARUS_RAGS,
                [CompletionType.LAMB] = Achievement.PANDORAS_BOX,
                [CompletionType.BLUE_BABY] = Achievement.STORE_CREDIT,
                [CompletionType.ULTRA_GREED] = Achievement.KEY_BUM,
                [CompletionType.ULTRA_GREEDIER] = Achievement.PLAN_C,
                [CompletionType.HUSH] = Achievement.EMPTY_VESSEL,
                [CompletionType.MEGA_SATAN] = Achievement.LONG_BABY,
                [CompletionType.DELIRIUM] = Achievement.COMPOUND_FRACTURE,
                [CompletionType.MOTHER] = Achievement.TINYTOMA,
                [CompletionType.BEAST] = Achievement.ASTRAL_PROJECTION,
                tainted = Achievement.TAINTED_LAZARUS,
                allHardMarks = Achievement.DRIPPING_BABY
            }
        },
        [PlayerType.PLAYER_EDEN] = {
            curseDesc = { "-0.1 to a random stat when entering a floor, from floor 2 onwards." },
            unlockReq = Achievement.EDEN,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.UNDEFINED,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.GLITCH_BABY,
                [CompletionType.SATAN] = Achievement.BOOK_OF_SECRETS,
                [CompletionType.ISAAC] = Achievement.BLANK_CARD,
                [CompletionType.LAMB] = Achievement.MYSTERY_SACK,
                [CompletionType.BLUE_BABY] = Achievement.MYSTERIOUS_PAPER,
                [CompletionType.ULTRA_GREED] = Achievement.GB_BUG,
                [CompletionType.ULTRA_GREEDIER] = Achievement.METRONOME,
                [CompletionType.HUSH] = Achievement.EDENS_BLESSING,
                [CompletionType.MEGA_SATAN] = Achievement.YELLOW_BABY,
                [CompletionType.DELIRIUM] = Achievement.EDENS_SOUL,
                [CompletionType.MOTHER] = Achievement.M,
                [CompletionType.BEAST] = Achievement.EVERYTHING_JAR,
                tainted = Achievement.TAINTED_EDEN,
                allHardMarks = Achievement.CRACKED_BABY
            }
        },
        [PlayerType.PLAYER_THELOST] = {
            curseDesc = {
                "You may not have more than 2 red/coin hearts, and non-red hearts vanish on pickup.",
                "If Holy Mantle is unlocked with The Lost, start with Wafer."
            },
            unlockReq = Achievement.LOST,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.D100,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.ZERO_BABY,
                [CompletionType.SATAN] = Achievement.MIND,
                [CompletionType.ISAAC] = Achievement.ISAACS_HEART,
                [CompletionType.LAMB] = Achievement.SOUL,
                [CompletionType.BLUE_BABY] = Achievement.BODY,
                [CompletionType.ULTRA_GREED] = Achievement.ZODIAC,
                [CompletionType.ULTRA_GREEDIER] = Achievement.DADS_LOST_COIN,
                [CompletionType.HUSH] = Achievement.SWORN_PROTECTOR,
                [CompletionType.MEGA_SATAN] = Achievement.WHITE_BABY,
                [CompletionType.DELIRIUM] = Achievement.HOLY_CARD,
                [CompletionType.MOTHER] = Achievement.LOST_SOUL,
                [CompletionType.BEAST] = Achievement.HUNGRY_SOUL,
                tainted = Achievement.TAINTED_LOST,
                allHardMarks = Achievement.GODHEAD
            }
        },
        [PlayerType.PLAYER_LILITH] = {
            curseDesc = {
                "Baby familiar items have a 75% chance to be rerolled when spawned.",
                "Incubus can no longer show up.",
                "-8% all stats while you don't have a baby familiar."
            },
            unlockReq = Achievement.LILITH,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.IMMACULATE_CONCEPTION,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.GOAT_HEAD_BABY,
                [CompletionType.SATAN] = Achievement.SERPENTS_KISS,
                [CompletionType.ISAAC] = Achievement.RUNE_BAG,
                [CompletionType.LAMB] = Achievement.SUCCUBUS,
                [CompletionType.BLUE_BABY] = Achievement.CAMBION_CONCEPTION,
                [CompletionType.ULTRA_GREED] = Achievement.BOX_OF_FRIENDS,
                [CompletionType.ULTRA_GREEDIER] = Achievement.DUALITY,
                [CompletionType.HUSH] = Achievement.INCUBUS,
                [CompletionType.MEGA_SATAN] = Achievement.BIG_BABY,
                [CompletionType.DELIRIUM] = Achievement.EUTHANASIA,
                [CompletionType.MOTHER] = Achievement.BLOOD_PUPPY,
                [CompletionType.BEAST] = Achievement.C_SECTION,
                tainted = Achievement.TAINTED_LILITH,
                allHardMarks = Achievement.DARK_BABY
            }
        },
        [PlayerType.PLAYER_KEEPER] = {
            curseDesc = {
                "Coins have a 50% chance to vanish when collected.",
                "25% chance to take 1/2 heart damage when a coin vanishes.",
                "When entering a new floor, if less than 5 coins were picked up in the previous",
                "floor, halve your coin count."
            },
            unlockReq = Achievement.KEEPER,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.STICKY_NICKELS,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.SUPER_GREED_BABY,
                [CompletionType.SATAN] = Achievement.KEEPER_HOLDS_STORE_KEY,
                [CompletionType.ISAAC] = Achievement.KEEPER_HOLDS_WOODEN_NICKEL,
                [CompletionType.LAMB] = Achievement.KARMA,
                [CompletionType.BLUE_BABY] = Achievement.DEEP_POCKETS,
                [CompletionType.ULTRA_GREED] = Achievement.RIB_OF_GREED,
                [CompletionType.ULTRA_GREEDIER] = Achievement.EYE_OF_GREED,
                [CompletionType.HUSH] = Achievement.KEEPER_HOLDS_A_PENNY,
                [CompletionType.MEGA_SATAN] = Achievement.NOOSE_BABY,
                [CompletionType.DELIRIUM] = Achievement.CROOKED_CARD,
                [CompletionType.MOTHER] = Achievement.KEEPERS_SACK,
                [CompletionType.BEAST] = Achievement.KEEPERS_BOX,
                tainted = Achievement.TAINTED_KEEPER,
                allHardMarks = Achievement.SALE_BABY
            }
        },
        [PlayerType.PLAYER_APOLLYON] = {
            curseDesc = {
                "-0.04 to a random stat (except speed) when picking up a passive item."
            },
            unlockReq = Achievement.APOLLYON,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.LOCUST_OF_CONQUEST,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.SMELTER,
                [CompletionType.SATAN] = Achievement.LOCUST_OF_PESTILENCE,
                [CompletionType.ISAAC] = Achievement.LOCUST_OF_WRATH,
                [CompletionType.LAMB] = Achievement.LOCUST_OF_DEATH,
                [CompletionType.BLUE_BABY] = Achievement.LOCUST_OF_FAMINE,
                [CompletionType.ULTRA_GREED] = Achievement.BROWN_NUGGET,
                [CompletionType.ULTRA_GREEDIER] = Achievement.BLACK_RUNE,
                [CompletionType.HUSH] = Achievement.HUSHY,
                [CompletionType.MEGA_SATAN] = Achievement.MORT_BABY,
                [CompletionType.DELIRIUM] = Achievement.VOID,
                [CompletionType.MOTHER] = Achievement.LIL_PORTAL,
                [CompletionType.BEAST] = Achievement.WORM_FRIEND,
                tainted = Achievement.TAINTED_APOLLYON,
                allHardMarks = Achievement.APOLLYON_BABY
            }
        },
        [PlayerType.PLAYER_THEFORGOTTEN] = {
            curseDesc = {
                "Convert all starting hearts to bone hearts.",
                "When entering a new floor, convert a red/bone heart container into a full soul heart.",
                {"As Keeper: -4% all stats per active blue fly, up to -40%. This effect stays", KColor(1, 1, 0.6, 1)},
                {"until clearing the room, even if blue flies are killed.", KColor(1, 1, 0.6, 1)}
            },
            unlockReq = Achievement.FORGOTTEN,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.DIVORCE_PAPERS,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.MARROW,
                [CompletionType.SATAN] = Achievement.POINTY_RIB,
                [CompletionType.ISAAC] = Achievement.SLIPPED_RIB,
                [CompletionType.LAMB] = Achievement.BRITTLE_BONES,
                [CompletionType.BLUE_BABY] = Achievement.JAW_BONE,
                [CompletionType.ULTRA_GREED] = Achievement.FINGER_BONE,
                [CompletionType.ULTRA_GREEDIER] = Achievement.DADS_RING,
                [CompletionType.HUSH] = Achievement.HALLOWED_GROUND,
                [CompletionType.MEGA_SATAN] = Achievement.BOUND_BABY,
                [CompletionType.DELIRIUM] = Achievement.BOOK_OF_THE_DEAD,
                [CompletionType.MOTHER] = Achievement.BONE_SPURS,
                [CompletionType.BEAST] = Achievement.SPIRIT_SHACKLES,
                tainted = Achievement.TAINTED_FORGOTTEN,
                allHardMarks = Achievement.BONE_BABY
            }
        },
        [PlayerType.PLAYER_BETHANY] = {
            curseDesc = {
                "Soul and Black hearts are halved once collected.",
                "-0.02 luck when picking up a soul or black heart.",
                {"As Keeper: Permanent -0.01 luck whenever a blue fly spawns, up to -2.", KColor(1, 1, 0.6, 1)}
            },
            unlockReq = Achievement.BETHANY,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.BETHS_FAITH,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.WISP_BABY,
                [CompletionType.SATAN] = Achievement.URN_OF_SOULS,
                [CompletionType.ISAAC] = Achievement.BOOK_OF_VIRTUES,
                [CompletionType.LAMB] = Achievement.ALABASTER_BOX,
                [CompletionType.BLUE_BABY] = Achievement.BLESSED_PENNY,
                [CompletionType.ULTRA_GREED] = Achievement.SOUL_LOCKET,
                [CompletionType.ULTRA_GREEDIER] = Achievement.VADE_RETRO,
                [CompletionType.HUSH] = Achievement.DIVINE_INTERVENTION,
                [CompletionType.MEGA_SATAN] = Achievement.GLOWING_BABY,
                [CompletionType.DELIRIUM] = Achievement.STAR_OF_BETHLEHEM,
                [CompletionType.MOTHER] = Achievement.REVELATION,
                [CompletionType.BEAST] = Achievement.JAR_OF_WISPS,
                tainted = Achievement.TAINTED_BETHANY,
                allHardMarks = Achievement.HOPE_BABY
            }
        },
        [PlayerType.PLAYER_JACOB] = {
            curseDesc = {
                "Start with -25% damage and tears.",
                "-50% xp gain.",
                "Halve these reductions when first obtaining an item, up to 8 times.",
            },
            unlockReq = Achievement.JACOB_AND_ESAU,
            unlocks = {
                [CompletionType.BOSS_RUSH] = Achievement.ROCK_BOTTOM,
                [CompletionType.MOMS_HEART .. "hard"] = Achievement.DOUBLE_BABY,
                [CompletionType.SATAN] = Achievement.RED_STEW,
                [CompletionType.ISAAC] = Achievement.STAIRWAY,
                [CompletionType.LAMB] = Achievement.DAMOCLES,
                [CompletionType.BLUE_BABY] = Achievement.BIRTHRIGHT,
                [CompletionType.ULTRA_GREED] = Achievement.INNER_CHILD,
                [CompletionType.ULTRA_GREEDIER] = Achievement.GENESIS,
                [CompletionType.HUSH] = Achievement.VANISHING_TWIN,
                [CompletionType.MEGA_SATAN] = Achievement.ILLUSION_BABY,
                [CompletionType.DELIRIUM] = Achievement.SUPLEX,
                [CompletionType.MOTHER] = Achievement.MAGIC_SKIN,
                [CompletionType.BEAST] = Achievement.FRIEND_FINDER,
                tainted = Achievement.TAINTED_JACOB,
                allHardMarks = Achievement.SOLOMONS_BABY
            }
        },
        [PlayerType.PLAYER_ISAAC_B] = {
            curseDesc = {
                "Items are removed from the first treasure room you enter.",
                "-4% all stats per item obtained after the 8th one, up to -40%."
            },
            unlockReq = Achievement.TAINTED_ISAAC,
            unlocks = {
                -- Isaac + ??? + Satan + Lamb
                tainted1 = Achievement.MOMS_LOCK,
                -- Hush + Bossrush
                tainted2 = Achievement.SOUL_OF_ISAAC,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_STARS,
                [CompletionType.MEGA_SATAN] = Achievement.MEGA_CHEST,
                [CompletionType.DELIRIUM] = Achievement.SPINDOWN_DICE,
                [CompletionType.MOTHER] = Achievement.DICE_BAG,
                [CompletionType.BEAST] = Achievement.GLITCHED_CROWN
            }
        },
        [PlayerType.PLAYER_MAGDALENE_B] = {
            curseDesc = {
                "When entering a room with monsters, if you are above 2 red hearts,",
                "take 1/2 heart damage.",
                "Coins, bombs, keys and chests have a 15% chance to be replaced with a half red heart."
            },
            unlockReq = Achievement.TAINTED_MAGDALENE,
            unlocks = {
                tainted1 = Achievement.HOLY_CROWN,
                tainted2 = Achievement.SOUL_OF_MAGDALENE,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_LOVERS,
                [CompletionType.MEGA_SATAN] = Achievement.QUEEN_OF_HEARTS,
                [CompletionType.DELIRIUM] = Achievement.HYPERCOAGULATION,
                [CompletionType.MOTHER] = Achievement.MOTHERS_KISS,
                [CompletionType.BEAST] = Achievement.BELLY_JELLY
            }
        },
        [PlayerType.PLAYER_CAIN_B] = {
            curseDesc = {
                "Begin with Bag of Crafting if you have it unlocked.",
                "-2 luck while not holding the Bag of Crafting.",
                "100% chance to be cursed with Curse of the Blind when entering a floor.",
                "Crafting an item with Bag of Crafting reduces this chance by 10%."
            },
            unlockReq = Achievement.TAINTED_CAIN,
            unlocks = {
                tainted1 = Achievement.GILDED_KEY,
                tainted2 = Achievement.SOUL_OF_CAIN,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_WHEEL_OF_FORTUNE,
                [CompletionType.MEGA_SATAN] = Achievement.GOLDEN_PILLS,
                [CompletionType.DELIRIUM] = Achievement.BAG_OF_CRAFTING,
                [CompletionType.MOTHER] = Achievement.LUCKY_SACK,
                [CompletionType.BEAST] = Achievement.BLUE_KEY
            }
        },
        [PlayerType.PLAYER_JUDAS_B] = {
            curseDesc = {
                "Starting health is set to 2 black hearts.",
                "Soul hearts are converted to black hearts when spawned.",
                "Take 1 heart of damage when picking up a black heart.",
                "Black hearts grant +0.4 damage on pickup for the current room, up to +1.2.",
                {"As Keeper: Coins have a 50% chance to grant 0.2 damage for the current room", KColor(1, 1, 0.6, 1)},
                {"instead of healing, up to +1.", KColor(1, 1, 0.6, 1)}
            },
            unlockReq = Achievement.TAINTED_JUDAS,
            unlocks = {
                tainted1 = Achievement.YOUR_SOUL,
                tainted2 = Achievement.SOUL_OF_JUDAS,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_MAGICIAN,
                [CompletionType.MEGA_SATAN] = Achievement.BLACK_SACK,
                [CompletionType.DELIRIUM] = Achievement.DARK_ARTS,
                [CompletionType.MOTHER] = Achievement.NUMBER_MAGNET,
                [CompletionType.BEAST] = Achievement.SANGUINE_BOND
            }
        },
        [PlayerType.PLAYER_BLUEBABY_B] = {
            curseDesc = {
                "All starting hearts are converted to soul hearts.",
                "First floor's treasure room is guaranteed to have a poop item.",
                "Further floors' treasure room item has a 50% chance to be replaced with a poop item."
            },
            unlockReq = Achievement.TAINTED_BLUE_BABY,
            unlocks = {
                tainted1 = Achievement.DINGLE_BERRY,
                tainted2 = Achievement.SOUL_OF_BLUE_BABY,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_EMPEROR,
                [CompletionType.MEGA_SATAN] = Achievement.CHARMING_POOP,
                [CompletionType.DELIRIUM] = Achievement.IBS,
                [CompletionType.MOTHER] = Achievement.RING_CAP,
                [CompletionType.BEAST] = Achievement.SWARM
            }
        },
        [PlayerType.PLAYER_EVE_B] = {
            curseDesc = {
                "-33% tears."
            },
            unlockReq = Achievement.TAINTED_EVE,
            unlocks = {
                tainted1 = Achievement.STRANGE_KEY,
                tainted2 = Achievement.SOUL_OF_EVE,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_EMPRESS,
                [CompletionType.MEGA_SATAN] = Achievement.HORSE_PILLS,
                [CompletionType.DELIRIUM] = Achievement.SUMPTORIUM,
                [CompletionType.MOTHER] = Achievement.LIL_CLOT,
                [CompletionType.BEAST] = Achievement.HEARTBREAK
            }
        },
        [PlayerType.PLAYER_SAMSON_B] = {
            curseDesc = {
                "-5% all stats when hit, up to -20%.",
                "+2% all stats when killing a monster, up to 10%.",
                "Resets when clearing a room. If the final bonus was negative, take up to 1 heart damage",
                "if you can survive it."
            },
            unlockReq = Achievement.TAINTED_SAMSON,
            unlocks = {
                tainted1 = Achievement.TEMPORARY_TATTOO,
                tainted2 = Achievement.SOUL_OF_SAMSON,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_STRENGTH,
                [CompletionType.MEGA_SATAN] = Achievement.CRANE_GAME,
                [CompletionType.DELIRIUM] = Achievement.BERSERK,
                [CompletionType.MOTHER] = Achievement.SWALLOWED_M80,
                [CompletionType.BEAST] = Achievement.LARYNX
            }
        },
        [PlayerType.PLAYER_AZAZEL_B] = {
            curseDesc = {
                "-40% damage dealt to enemies far away from you, based on your range stat."
            },
            unlockReq = Achievement.TAINTED_AZAZEL,
            unlocks = {
                tainted1 = Achievement.WICKED_CROWN,
                tainted2 = Achievement.SOUL_OF_AZAZEL,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_DEVIL,
                [CompletionType.MEGA_SATAN] = Achievement.HELL_GAME,
                [CompletionType.DELIRIUM] = Achievement.HEMOPTYSIS,
                [CompletionType.MOTHER] = Achievement.AZAZELS_STUMP,
                [CompletionType.BEAST] = Achievement.AZAZELS_RAGE
            }
        },
        [PlayerType.PLAYER_LAZARUS_B] = {
            curseDesc = {
                "You now have 2 health banks, which switch when clearing a room.",
                "First health bank is your character's starting health. Second bank starts at 2 soul hearts.",
                "Permanent health modifiers will only affect the current bank.",
                {"As Keeper: 33% chance for coins to spawn a blue fly instead of healing you.", KColor(1, 1, 0.6, 1)},
                {"As Keeper: Cannot heal while you have blue flies.", KColor(1, 1, 0.6, 1)}
            },
            unlockReq = Achievement.TAINTED_LAZARUS,
            unlocks = {
                tainted1 = Achievement.TORN_POCKET,
                tainted2 = Achievement.SOUL_OF_LAZARUS,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_JUDGEMENT,
                [CompletionType.MEGA_SATAN] = Achievement.WOODEN_CHEST,
                [CompletionType.DELIRIUM] = Achievement.FLIP,
                [CompletionType.MOTHER] = Achievement.TORN_CARD,
                [CompletionType.BEAST] = Achievement.SALVATION
            }
        },
        [PlayerType.PLAYER_EDEN_B] = {
            curseDesc = {
                "Start with -0.15 all stats.",
                "When hit, shuffle the total reduction randomly across all stats. Additionally",
                "receive 0 ~ -25% to a random stat."
            },
            unlockReq = Achievement.TAINTED_EDEN,
            unlocks = {
                tainted1 = Achievement.NUH_UH,
                tainted2 = Achievement.SOUL_OF_EDEN,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_WORLD,
                [CompletionType.MEGA_SATAN] = Achievement.WILD_CARD,
                [CompletionType.DELIRIUM] = Achievement.CORRUPTED_DATA,
                [CompletionType.MOTHER] = Achievement.MODELING_CLAY,
                [CompletionType.BEAST] = Achievement.TMTRAINER
            }
        },
        [PlayerType.PLAYER_THELOST_B] = {
            curseDesc = {
                "You may not have more than 1 heart of each type (soul and black count as the same type).",
                "Eternal hearts can no longer show up.",
                "Wafer and Holy Mantle can no longer show up.",
                {"As Keeper: coins will only heal you up to 3 times per floor.", KColor(1, 1, 0.6, 1)}
            },
            unlockReq = Achievement.TAINTED_LOST,
            unlocks = {
                tainted1 = Achievement.KIDS_DRAWING,
                tainted2 = Achievement.SOUL_OF_LOST,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_FOOL,
                [CompletionType.MEGA_SATAN] = Achievement.HAUNTED_CHEST,
                [CompletionType.DELIRIUM] = Achievement.GHOST_BOMBS,
                [CompletionType.MOTHER] = Achievement.CRYSTAL_KEY,
                [CompletionType.BEAST] = Achievement.SACRED_ORB
            }
        },
        [PlayerType.PLAYER_LILITH_B] = {
            curseDesc = {
                "-1 tears, range and shot speed.",
                "This reduction is halved for each baby familiar you have."
            },
            unlockReq = Achievement.TAINTED_LILITH,
            unlocks = {
                tainted1 = Achievement.THE_TWINS,
                tainted2 = Achievement.SOUL_OF_LILITH,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_HIGH_PRIESTESS,
                [CompletionType.MEGA_SATAN] = Achievement.FOOLS_GOLD,
                [CompletionType.DELIRIUM] = Achievement.GELLO,
                [CompletionType.MOTHER] = Achievement.ADOPTION_PAPERS,
                [CompletionType.BEAST] = Achievement.TWISTED_PAIR
            }
        },
        [PlayerType.PLAYER_KEEPER_B] = {
            curseDesc = {
                "Converts heart pickups, bombs, keys and chests into coins.",
                "Start with Restock.",
                "When entering a new floor, if your coin count is less than 15, lose a heart",
                "container. Otherwise, halve your coin count."
            },
            unlockReq = Achievement.TAINTED_KEEPER,
            unlocks = {
                tainted1 = Achievement.KEEPERS_BARGAIN,
                tainted2 = Achievement.SOUL_OF_KEEPER,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_HANGED_MAN,
                [CompletionType.MEGA_SATAN] = Achievement.GOLDEN_PENNY,
                [CompletionType.DELIRIUM] = Achievement.KEEPERS_KIN,
                [CompletionType.MOTHER] = Achievement.CURSED_PENNY,
                [CompletionType.BEAST] = Achievement.STRAWMAN
            }
        },
        [PlayerType.PLAYER_APOLLYON_B] = {
            curseDesc = {
                "Spawn a locust familiar when first picking up an item, up to 10.",
                "When entering a new floor, a locust will vanish.",
                "-4% damage, tears and luck per active locust.",
                "-8% all stats while no locusts are active."
            },
            unlockReq = Achievement.TAINTED_APOLLYON,
            unlocks = {
                tainted1 = Achievement.CRICKET_LEG,
                tainted2 = Achievement.SOUL_OF_APOLLYON,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_TOWER,
                [CompletionType.MEGA_SATAN] = Achievement.ROTTEN_BEGGAR,
                [CompletionType.DELIRIUM] = Achievement.ABYSS,
                [CompletionType.MOTHER] = Achievement.APOLLYONS_BEST_FRIEND,
                [CompletionType.BEAST] = Achievement.ECHO_CHAMBER
            }
        },
        [PlayerType.PLAYER_THEFORGOTTEN_B] = {
            curseDesc = {
                "Convert one of your starting hearts to a bone heart.",
                "Cannot have more than 1 soul/black heart or bone hearts.",
                "Bosses drop an additional soul or bone heart on death.",
                "-15% range, shot speed and luck if you don't have a soul heart.",
                "-15% damage, tears and speed if you don't have a bone heart.",
                {"As Keeper: The first coin you pick up in a room can't heal you.", KColor(1, 1, 0.6, 1)},
                {"As Keeper: -8% all stats while you haven't picked up a coin. Resets each room.", KColor(1, 1, 0.6, 1)}
            },
            unlockReq = Achievement.TAINTED_FORGOTTEN,
            unlocks = {
                tainted1 = Achievement.POLISHED_BONE,
                tainted2 = Achievement.SOUL_OF_FORGOTTEN,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_DEATH,
                [CompletionType.MEGA_SATAN] = Achievement.GOLDEN_BATTERY,
                [CompletionType.DELIRIUM] = Achievement.DECAP_ATTACK,
                [CompletionType.MOTHER] = Achievement.HOLLOW_HEART,
                [CompletionType.BEAST] = Achievement.ISAACS_TOMB
            }
        },
        [PlayerType.PLAYER_BETHANY_B] = {
            curseDesc = {
                "Passive items you pick up become Lemegeton wisps.",
                "These wisps receive 70% less damage from hits.",
                "Fully heal wisps when entering a new floor.",
                "Permanent -4% all stats when a wisp dies, up to -20%."
            },
            unlockReq = Achievement.TAINTED_BETHANY,
            unlocks = {
                tainted1 = Achievement.EXPANSION_PACK,
                tainted2 = Achievement.SOUL_OF_BETHANY,
                [CompletionType.ULTRA_GREEDIER] = Achievement.RESERVED_HEIROPHANT,
                [CompletionType.MEGA_SATAN] = Achievement.CONFESSIONAL,
                [CompletionType.DELIRIUM] = Achievement.LEMEGETON,
                [CompletionType.MOTHER] = Achievement.BETHS_ESSENCE,
                [CompletionType.BEAST] = Achievement.VENGEFUL_SPIRIT
            }
        },
        [PlayerType.PLAYER_JACOB_B] = {
            curseDesc = {
                "You are chased by Dark Esau, who spawns once you first enter a room with monsters.",
                "Contact with Dark Esau will deal 1.5 hearts of damage to you."
            },
            unlockReq = Achievement.TAINTED_JACOB,
            unlocks = {
                tainted1 = Achievement.RC_REMOTE,
                tainted2 = Achievement.SOUL_OF_JACOB,
                [CompletionType.ULTRA_GREEDIER] = Achievement.REVERSED_SUN_AND_MOON,
                [CompletionType.MEGA_SATAN] = Achievement.GOLDEN_TRINKET,
                [CompletionType.DELIRIUM] = Achievement.ANIMA_SOLA,
                [CompletionType.MOTHER] = Achievement.FOUND_SOUL,
                [CompletionType.BEAST] = Achievement.ESAU_JR
            }
        }
    }
}
PST.cosmicRData.lockedCharSprite:ReplaceSpritesheet(0, "gfx/ui/skilltrees/cosmic_realignment_chars_locked.png", true)