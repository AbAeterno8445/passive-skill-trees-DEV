---@type PSTExpedition[]
PST.expeditionsData = { [0] = {} }
PST.expedMinLevel = 60

PST.uberExpeditionsData = { [0] = {} }
PST.uberExpedMinLevel = 90

PST.expedObolDropValues = {2, 5, 10, 25, 50, 100, 500, 1000}

PST.siderealVicinityCost = 5
PST.siderealRegionCost = 50
PST.siderealExpanseCost = 150

function PST:getExpedObolToGSPRate(totalTrades)
    local cost = math.ceil(30 + totalTrades * (2 ^ (1 + totalTrades / 12)))
    return math.min(220, cost)
end

---@enum PSTExpNodeRewardType
PSTExpNodeRewardType = {
    NONE = 0,
    EXP = 1,
    OBOLS = 2,
    ITEM = 3,
    ATTEMPTS = 4,
    BOON = 5,
    C_STARCORE = 6,
    ORDER = 7,
    STARBLESS_WEP = 8,
    STARBLESS_PRISM = 9,
    GLOBAL_SP = 10,
    UBER_CHOICE = 11
}

---@enum PSTExpNodeType
PSTExpNodeType = {
    NORMAL = 0,
    CURSED = 1,
    FINAL = 2,
    BOONUPGRADE = 3,
    ASTROLABE = 4,
    COMPLETED = 6,
    REWARD = 9
}

-- Expedition node class
---@class PSTExpNode
---@field nodeType PSTExpNodeType
---@field col number
---@field row number
---@field accessible? boolean
---@field selectable? boolean
---@field objective? table
---@field curse? integer
---@field rewardType PSTExpNodeRewardType
---@field rewardData? any
---@field deathState? number -- 1: inaccessible - for 'dead' nodes when losing and resetting expedition
---@field connections number[]
---@field entropyMods? number[]

-- Selected node class
---@class PSTSelectedExpNode
---@field col number
---@field row number
---@field objProgress number

-- Expedition class
---@class PSTExpedition
---@field depth number
---@field nodes PSTExpNode[][]
---@field selectedNode PSTSelectedExpNode|nil
---@field seed integer
---@field version integer
---@field implicits? table
---@field startAttempts number
---@field attempts number
---@field boons number[]
---@field upgradedBoons number[]
---@field boonUpgradePoints number
---@field curses number[]
---@field items CollectibleType[]
---@field uber? boolean
---@field entropy? number
---@field order? number
---@field entropyEffects? table
---@field dsMods? number[] -- Deep-Space distortion modifiers (uber)
---@field modifiers? table
---@field endRewards? boolean -- Whether reward nodes were placed at the end for choice rewards

-- Expedition save class (expedition data that gets stored in savefile)
---@class PSTExpeditionSave
---@field seed integer
---@field version integer
---@field selNode? PSTSelectedExpNode|nil
---@field compNodes? number[]
---@field deadNodes? number[]
---@field noRwNodes? number[]
---@field boons? number[]
---@field upgBoons? number[]
---@field upgBoonPts? number
---@field curses? number[]
---@field usedAttempts? number
---@field modifiers? table
---@field uber? boolean
---@field entropy? number
---@field order? number
---@field entropyEffects? table
---@field dsMods? number[]
---@field endRewards? boolean

-- Expedition items pool
PST.expeditionItems = {
    CollectibleType.COLLECTIBLE_SAD_ONION, CollectibleType.COLLECTIBLE_INNER_EYE,
    CollectibleType.COLLECTIBLE_SPOON_BENDER, CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
    CollectibleType.COLLECTIBLE_MY_REFLECTION, CollectibleType.COLLECTIBLE_NUMBER_ONE,
    CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR, CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
    CollectibleType.COLLECTIBLE_HALO_OF_FLIES, CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    CollectibleType.COLLECTIBLE_VIRUS, CollectibleType.COLLECTIBLE_ROID_RAGE,
    CollectibleType.COLLECTIBLE_HEART, CollectibleType.COLLECTIBLE_BOOM,
    CollectibleType.COLLECTIBLE_LUCKY_FOOT, CollectibleType.COLLECTIBLE_CUPIDS_ARROW,
    CollectibleType.COLLECTIBLE_DR_FETUS, CollectibleType.COLLECTIBLE_MAGNETO,
    CollectibleType.COLLECTIBLE_MOMS_EYE, CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION,
    CollectibleType.COLLECTIBLE_CHARM_VAMPIRE, CollectibleType.COLLECTIBLE_SISTER_MAGGY,
    CollectibleType.COLLECTIBLE_TECHNOLOGY, CollectibleType.COLLECTIBLE_CHOCOLATE_MILK,
    CollectibleType.COLLECTIBLE_MINI_MUSH, CollectibleType.COLLECTIBLE_ROSARY,
    CollectibleType.COLLECTIBLE_QUARTER, CollectibleType.COLLECTIBLE_PHD,
    CollectibleType.COLLECTIBLE_XRAY_VISION, CollectibleType.COLLECTIBLE_LOKIS_HORNS,
    CollectibleType.COLLECTIBLE_LITTLE_CHUBBY, CollectibleType.COLLECTIBLE_SPIDER_BITE,
    CollectibleType.COLLECTIBLE_SPELUNKER_HAT, CollectibleType.COLLECTIBLE_SUPER_BANDAGE,
    CollectibleType.COLLECTIBLE_SACK_OF_PENNIES, CollectibleType.COLLECTIBLE_ROBO_BABY,
    CollectibleType.COLLECTIBLE_LITTLE_CHAD, CollectibleType.COLLECTIBLE_RELIC,
    CollectibleType.COLLECTIBLE_LITTLE_GISH, CollectibleType.COLLECTIBLE_LITTLE_STEVEN,
    CollectibleType.COLLECTIBLE_HALO, CollectibleType.COLLECTIBLE_COMMON_COLD,
    CollectibleType.COLLECTIBLE_PARASITE, CollectibleType.COLLECTIBLE_WAFER,
    CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER, CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
    CollectibleType.COLLECTIBLE_DEMON_BABY, CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_OUIJA_BOARD, CollectibleType.COLLECTIBLE_DEAD_BIRD,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN, CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
    CollectibleType.COLLECTIBLE_BOBBY_BOMB, CollectibleType.COLLECTIBLE_FOREVER_ALONE,
    CollectibleType.COLLECTIBLE_BUCKET_OF_LARD, CollectibleType.COLLECTIBLE_BOMB_BAG,
    CollectibleType.COLLECTIBLE_BEST_FRIEND, CollectibleType.COLLECTIBLE_STIGMATA,
    CollectibleType.COLLECTIBLE_BOBS_CURSE, CollectibleType.COLLECTIBLE_SCAPULAR,
    CollectibleType.COLLECTIBLE_SPEED_BALL, CollectibleType.COLLECTIBLE_BUM_FRIEND,
    CollectibleType.COLLECTIBLE_INFESTATION, CollectibleType.COLLECTIBLE_IPECAC,
    CollectibleType.COLLECTIBLE_TOUGH_LOVE, CollectibleType.COLLECTIBLE_MULLIGAN,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_2, CollectibleType.COLLECTIBLE_MUTANT_SPIDER,
    CollectibleType.COLLECTIBLE_CHEMICAL_PEEL, CollectibleType.COLLECTIBLE_PEEPER,
    CollectibleType.COLLECTIBLE_BLOODY_LUST, CollectibleType.COLLECTIBLE_ANKH,
    CollectibleType.COLLECTIBLE_CELTIC_CROSS, CollectibleType.COLLECTIBLE_GHOST_BABY,
    CollectibleType.COLLECTIBLE_HARLEQUIN_BABY, CollectibleType.COLLECTIBLE_EPIC_FETUS,
    CollectibleType.COLLECTIBLE_POLYPHEMUS, CollectibleType.COLLECTIBLE_DADDY_LONGLEGS,
    CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER, CollectibleType.COLLECTIBLE_MITRE,
    CollectibleType.COLLECTIBLE_RAINBOW_BABY, CollectibleType.COLLECTIBLE_STEM_CELLS,
    CollectibleType.COLLECTIBLE_HOLY_WATER, CollectibleType.COLLECTIBLE_BLACK_BEAN,
    CollectibleType.COLLECTIBLE_BLOOD_RIGHTS, CollectibleType.COLLECTIBLE_ABEL,
    CollectibleType.COLLECTIBLE_SMB_SUPER_FAN, CollectibleType.COLLECTIBLE_PYRO,
    CollectibleType.COLLECTIBLE_3_DOLLAR_BILL, CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
    CollectibleType.COLLECTIBLE_IRON_BAR, CollectibleType.COLLECTIBLE_MIDAS_TOUCH,
    CollectibleType.COLLECTIBLE_BUTT_BOMBS, CollectibleType.COLLECTIBLE_GNAWED_LEAF,
    CollectibleType.COLLECTIBLE_SPIDERBABY, CollectibleType.COLLECTIBLE_LOST_CONTACT,
    CollectibleType.COLLECTIBLE_ANEMIC, CollectibleType.COLLECTIBLE_MOMS_WIG,
    CollectibleType.COLLECTIBLE_SAD_BOMBS, CollectibleType.COLLECTIBLE_RUBBER_CEMENT,
    CollectibleType.COLLECTIBLE_ANTI_GRAVITY, CollectibleType.COLLECTIBLE_PYROMANIAC,
    CollectibleType.COLLECTIBLE_CRICKETS_BODY, CollectibleType.COLLECTIBLE_GIMPY,
    CollectibleType.COLLECTIBLE_PIGGY_BANK, CollectibleType.COLLECTIBLE_MOMS_PERFUME,
    CollectibleType.COLLECTIBLE_MONSTROS_LUNG, CollectibleType.COLLECTIBLE_BALL_OF_TAR,
    CollectibleType.COLLECTIBLE_TINY_PLANET, CollectibleType.COLLECTIBLE_INFESTATION_2,
    CollectibleType.COLLECTIBLE_E_COLI, CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
    CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT, CollectibleType.COLLECTIBLE_INFAMY,
    CollectibleType.COLLECTIBLE_TECH_5, CollectibleType.COLLECTIBLE_20_20,
    CollectibleType.COLLECTIBLE_HOT_BOMBS, CollectibleType.COLLECTIBLE_FIRE_MIND,
    CollectibleType.COLLECTIBLE_PROPTOSIS, CollectibleType.COLLECTIBLE_SMART_FLY,
    CollectibleType.COLLECTIBLE_DRY_BABY, CollectibleType.COLLECTIBLE_JUICY_SACK,
    CollectibleType.COLLECTIBLE_ROBO_BABY_2, CollectibleType.COLLECTIBLE_ROTTEN_BABY,
    CollectibleType.COLLECTIBLE_HEADLESS_BABY, CollectibleType.COLLECTIBLE_LEECH,
    CollectibleType.COLLECTIBLE_MYSTERY_SACK, CollectibleType.COLLECTIBLE_BBF,
    CollectibleType.COLLECTIBLE_BOBS_BRAIN, CollectibleType.COLLECTIBLE_BEST_BUD,
    CollectibleType.COLLECTIBLE_LIL_BRIMSTONE, CollectibleType.COLLECTIBLE_ISAACS_HEART,
    CollectibleType.COLLECTIBLE_LIL_HAUNT, CollectibleType.COLLECTIBLE_DARK_BUM,
    CollectibleType.COLLECTIBLE_BIG_FAN, CollectibleType.COLLECTIBLE_SISSY_LONGLEGS,
    CollectibleType.COLLECTIBLE_PUNCHING_BAG, CollectibleType.COLLECTIBLE_TAURUS,
    CollectibleType.COLLECTIBLE_ARIES, CollectibleType.COLLECTIBLE_CANCER,
    CollectibleType.COLLECTIBLE_LEO, CollectibleType.COLLECTIBLE_VIRGO,
    CollectibleType.COLLECTIBLE_LIBRA, CollectibleType.COLLECTIBLE_SCORPIO,
    CollectibleType.COLLECTIBLE_SAGITTARIUS, CollectibleType.COLLECTIBLE_CAPRICORN,
    CollectibleType.COLLECTIBLE_AQUARIUS, CollectibleType.COLLECTIBLE_PISCES,
    CollectibleType.COLLECTIBLE_EVES_MASCARA, CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
    CollectibleType.COLLECTIBLE_MAGGYS_BOW, CollectibleType.COLLECTIBLE_HOLY_MANTLE,
    CollectibleType.COLLECTIBLE_THUNDER_THIGHS, CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR,
    CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID, CollectibleType.COLLECTIBLE_GEMINI,
    CollectibleType.COLLECTIBLE_CAINS_OTHER_EYE, CollectibleType.COLLECTIBLE_BLUE_BABYS_ONLY_FRIEND,
    CollectibleType.COLLECTIBLE_SAMSONS_CHAINS, CollectibleType.COLLECTIBLE_MONGO_BABY,
    CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE, CollectibleType.COLLECTIBLE_SOY_MILK,
    CollectibleType.COLLECTIBLE_LAZARUS_RAGS, CollectibleType.COLLECTIBLE_MIND,
    CollectibleType.COLLECTIBLE_BODY, CollectibleType.COLLECTIBLE_SOUL,
    CollectibleType.COLLECTIBLE_DEAD_ONION, CollectibleType.COLLECTIBLE_TOXIC_SHOCK,
    CollectibleType.COLLECTIBLE_BOMBER_BOY, CollectibleType.COLLECTIBLE_THE_WIZ,
    CollectibleType.COLLECTIBLE_8_INCH_NAILS, CollectibleType.COLLECTIBLE_FATES_REWARD,
    CollectibleType.COLLECTIBLE_LIL_CHEST, CollectibleType.COLLECTIBLE_FRIEND_ZONE,
    CollectibleType.COLLECTIBLE_LOST_FLY, CollectibleType.COLLECTIBLE_SCATTER_BOMBS,
    CollectibleType.COLLECTIBLE_STICKY_BOMBS, CollectibleType.COLLECTIBLE_EPIPHORA,
    CollectibleType.COLLECTIBLE_CONTINUUM, CollectibleType.COLLECTIBLE_DEAD_EYE,
    CollectibleType.COLLECTIBLE_HOLY_LIGHT, CollectibleType.COLLECTIBLE_HOST_HAT,
    CollectibleType.COLLECTIBLE_BURSTING_SACK, CollectibleType.COLLECTIBLE_NUMBER_TWO,
    CollectibleType.COLLECTIBLE_PUPULA_DUPLEX, CollectibleType.COLLECTIBLE_EDENS_BLESSING,
    CollectibleType.COLLECTIBLE_FRIEND_BALL, CollectibleType.COLLECTIBLE_LIL_GURDY,
    CollectibleType.COLLECTIBLE_BUMBO, CollectibleType.COLLECTIBLE_KEY_BUM,
    CollectibleType.COLLECTIBLE_RUNE_BAG, CollectibleType.COLLECTIBLE_SERAPHIM,
    CollectibleType.COLLECTIBLE_BETRAYAL, CollectibleType.COLLECTIBLE_ZODIAC,
    CollectibleType.COLLECTIBLE_SERPENTS_KISS, CollectibleType.COLLECTIBLE_TECH_X,
    CollectibleType.COLLECTIBLE_TRACTOR_BEAM, CollectibleType.COLLECTIBLE_GODS_FLESH,
    CollectibleType.COLLECTIBLE_EXPLOSIVO, CollectibleType.COLLECTIBLE_FARTING_BABY,
    CollectibleType.COLLECTIBLE_GB_BUG, CollectibleType.COLLECTIBLE_PURITY,
    CollectibleType.COLLECTIBLE_EVIL_EYE, CollectibleType.COLLECTIBLE_LUSTY_BLOOD,
    CollectibleType.COLLECTIBLE_FRUIT_CAKE, CollectibleType.COLLECTIBLE_OBSESSED_FAN,
    CollectibleType.COLLECTIBLE_PAPA_FLY, CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,
    CollectibleType.COLLECTIBLE_GLITTER_BOMBS, CollectibleType.COLLECTIBLE_LIL_LOKI,
    CollectibleType.COLLECTIBLE_MILK, CollectibleType.COLLECTIBLE_KIDNEY_STONE,
    CollectibleType.COLLECTIBLE_APPLE, CollectibleType.COLLECTIBLE_LEAD_PENCIL,
    CollectibleType.COLLECTIBLE_DOG_TOOTH, CollectibleType.COLLECTIBLE_DEAD_TOOTH,
    CollectibleType.COLLECTIBLE_LINGER_BEAN, CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,
    CollectibleType.COLLECTIBLE_METAL_PLATE, CollectibleType.COLLECTIBLE_VARICOSE_VEINS,
    CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE, CollectibleType.COLLECTIBLE_CONE_HEAD,
    CollectibleType.COLLECTIBLE_SINUS_INFECTION, CollectibleType.COLLECTIBLE_GLAUCOMA,
    CollectibleType.COLLECTIBLE_PARASITOID, CollectibleType.COLLECTIBLE_SULFURIC_ACID,
    CollectibleType.COLLECTIBLE_ANALOG_STICK, CollectibleType.COLLECTIBLE_CONTAGION,
    CollectibleType.COLLECTIBLE_FINGER, CollectibleType.COLLECTIBLE_DEPRESSION,
    CollectibleType.COLLECTIBLE_HUSHY, CollectibleType.COLLECTIBLE_LIL_MONSTRO,
    CollectibleType.COLLECTIBLE_BIG_CHUBBY, CollectibleType.COLLECTIBLE_METRONOME,
    CollectibleType.COLLECTIBLE_ACID_BABY, CollectibleType.COLLECTIBLE_YO_LISTEN,
    CollectibleType.COLLECTIBLE_ADRENALINE, CollectibleType.COLLECTIBLE_JACOBS_LADDER,
    CollectibleType.COLLECTIBLE_GHOST_PEPPER, CollectibleType.COLLECTIBLE_EUTHANASIA,
    CollectibleType.COLLECTIBLE_CAMO_UNDIES, CollectibleType.COLLECTIBLE_LARGE_ZIT,
    CollectibleType.COLLECTIBLE_BROWN_NUGGET, CollectibleType.COLLECTIBLE_BACKSTABBER,
    CollectibleType.COLLECTIBLE_MOMS_RAZOR, CollectibleType.COLLECTIBLE_BLOODSHOT_EYE,
    CollectibleType.COLLECTIBLE_ANGRY_FLY, CollectibleType.COLLECTIBLE_BOZO,
    CollectibleType.COLLECTIBLE_FAST_BOMBS, CollectibleType.COLLECTIBLE_TELEKINESIS,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO, CollectibleType.COLLECTIBLE_LEPROSY,
    CollectibleType.COLLECTIBLE_POP, CollectibleType.COLLECTIBLE_HAEMOLACRIA,
    CollectibleType.COLLECTIBLE_LACHRYPHAGY, CollectibleType.COLLECTIBLE_LIL_SPEWER,
    CollectibleType.COLLECTIBLE_MYSTERY_EGG, CollectibleType.COLLECTIBLE_FLAT_STONE,
    CollectibleType.COLLECTIBLE_SLIPPED_RIB, CollectibleType.COLLECTIBLE_HALLOWED_GROUND,
    CollectibleType.COLLECTIBLE_POINTY_RIB, CollectibleType.COLLECTIBLE_JAW_BONE,
    CollectibleType.COLLECTIBLE_BRITTLE_BONES, CollectibleType.COLLECTIBLE_TREASURE_MAP,
    CollectibleType.COLLECTIBLE_STEAM_SALE, CollectibleType.COLLECTIBLE_9_VOLT,
    CollectibleType.COLLECTIBLE_HABIT, CollectibleType.COLLECTIBLE_BLUE_MAP,
    CollectibleType.COLLECTIBLE_BFFS, CollectibleType.COLLECTIBLE_THERES_OPTIONS,
    CollectibleType.COLLECTIBLE_BOGO_BOMBS, CollectibleType.COLLECTIBLE_LITTLE_BAGGY,
    CollectibleType.COLLECTIBLE_CAR_BATTERY, CollectibleType.COLLECTIBLE_CHARGED_BABY,
    CollectibleType.COLLECTIBLE_CHAOS, CollectibleType.COLLECTIBLE_MORE_OPTIONS,
    CollectibleType.COLLECTIBLE_DEEP_POCKETS, CollectibleType.COLLECTIBLE_SACK_HEAD,
    CollectibleType.COLLECTIBLE_TAROT_CLOTH, CollectibleType.COLLECTIBLE_KING_BABY,
    CollectibleType.COLLECTIBLE_SACK_OF_SACKS, CollectibleType.COLLECTIBLE_BROKEN_MODEM,
    CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX, CollectibleType.COLLECTIBLE_SCHOOLBAG,
    CollectibleType.COLLECTIBLE_BLANKET, CollectibleType.COLLECTIBLE_1UP,
    CollectibleType.COLLECTIBLE_MUCORMYCOSIS, CollectibleType.COLLECTIBLE_EYE_SORE,
    CollectibleType.COLLECTIBLE_120_VOLT, CollectibleType.COLLECTIBLE_IT_HURTS,
    CollectibleType.COLLECTIBLE_ALMOND_MILK, CollectibleType.COLLECTIBLE_NANCY_BOMBS,
    CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE, CollectibleType.COLLECTIBLE_INTRUDER,
    CollectibleType.COLLECTIBLE_DIRTY_MIND, CollectibleType.COLLECTIBLE_PSY_FLY,
    CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR, CollectibleType.COLLECTIBLE_BOILED_BABY,
    CollectibleType.COLLECTIBLE_FREEZER_BABY, CollectibleType.COLLECTIBLE_BIRD_CAGE,
    CollectibleType.COLLECTIBLE_LOST_SOUL, CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
    CollectibleType.COLLECTIBLE_LIL_DUMPY, CollectibleType.COLLECTIBLE_BIRDS_EYE,
    CollectibleType.COLLECTIBLE_LODESTONE, CollectibleType.COLLECTIBLE_ROTTEN_TOMATO,
    CollectibleType.COLLECTIBLE_BOT_FLY, CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,
    CollectibleType.COLLECTIBLE_AKELDAMA, CollectibleType.COLLECTIBLE_TINYTOMA,
    CollectibleType.COLLECTIBLE_FRUITY_PLUM, CollectibleType.COLLECTIBLE_CUBE_BABY,
    CollectibleType.COLLECTIBLE_VASCULITIS, CollectibleType.COLLECTIBLE_GIANT_CELL,
    CollectibleType.COLLECTIBLE_QUINTS, CollectibleType.COLLECTIBLE_TOOTH_AND_NAIL,
    CollectibleType.COLLECTIBLE_CANDY_HEART, CollectibleType.COLLECTIBLE_CRACKED_ORB,
    CollectibleType.COLLECTIBLE_EMPTY_HEART, CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION,
    CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE, CollectibleType.COLLECTIBLE_LIL_PORTAL,
    CollectibleType.COLLECTIBLE_WORM_FRIEND, CollectibleType.COLLECTIBLE_BONE_SPURS,
    CollectibleType.COLLECTIBLE_JELLY_BELLY, CollectibleType.COLLECTIBLE_SWARM,
    CollectibleType.COLLECTIBLE_BLOODY_GUST, CollectibleType.COLLECTIBLE_KEEPERS_KIN,
    CollectibleType.COLLECTIBLE_HYPERCOAGULATION, CollectibleType.COLLECTIBLE_IBS,
    CollectibleType.COLLECTIBLE_HEMOPTYSIS, CollectibleType.COLLECTIBLE_GHOST_BOMBS,
    CollectibleType.COLLECTIBLE_VOODOO_HEAD, CollectibleType.COLLECTIBLE_DREAM_CATCHER,
    CollectibleType.COLLECTIBLE_OPTIONS, CollectibleType.COLLECTIBLE_4_5_VOLT,
    CollectibleType.COLLECTIBLE_KEEPERS_SACK
}

-- List of available expedition boons
PST.expeditionBoons = {
    { -- 1
        name = "Wellbeing",
        description = "+{{allstatsPerc}}% all stats.",
        spriteFrame = 0,
        mods = { allstatsPerc = 7 },
        upgradedMods = { allstatsPerc = 12 }
    },
    { -- 2
        name = "Damage",
        description = "+{{damagePerc}}% damage.",
        spriteFrame = 1,
        mods = { damagePerc = 10 },
        upgradedMods = { damagePerc = 16 }
    },
    { -- 3
        name = "Celerity",
        description = "+{{speedPerc}}% speed.",
        spriteFrame = 2,
        mods = { speedPerc = 10 },
        upgradedMods = { speedPerc = 16 }
    },
    { -- 4
        name = "Tears",
        description = "+{{tearsPerc}}% tears.",
        spriteFrame = 3,
        mods = { tearsPerc = 10 },
        upgradedMods = { tearsPerc = 16 }
    },
    { -- 5
        name = "Distance",
        description = "+{{rangePerc}}% range.",
        spriteFrame = 4,
        mods = { rangePerc = 10 },
        upgradedMods = { rangePerc = 16 }
    },
    { -- 6
        name = "Fortune",
        description = "+{{luckPerc}}% luck.",
        spriteFrame = 5,
        mods = { luckPerc = 10 },
        upgradedMods = { luckPerc = 16 }
    },
    { -- 7
        name = "Abundant Obols",
        description = "Obols are twice as likely to drop within runs. +{{boonAbundantObols}}% dropped obols.",
        spriteFrame = 6,
        mods = { boonAbundantObols = 20 },
        upgradedMods = { boonAbundantObols = 50 }
    },
    { -- 8
        name = "Intangibility",
        description = "When hit by a monster, {{boonIntangibility}}% chance for the invincibility frames to last 2.5x as long.",
        spriteFrame = 7,
        mods = { boonIntangibility = 50 },
        upgradedMods = { boonIntangibility = 80 }
    },
    { -- 9
        name = "Mercy",
        description = {
            "When hitting monsters and bosses affected by any status effect, {{boonMercyChance}}% chance to execute them if",
            "their HP is below {{boonMercyHP}}%.",
            "Hitting a boss halves their current status effect cooldown."
        },
        spriteFrame = 8,
        mods = { boonMercyChance = 12, boonMercyHP = 15 },
        upgradedMods = { boonMercyChance = 20, boonMercyHP = 20 }
    },
    { -- 10
        name = "the Aegis",
        description = "Block the first {{boonAegis}} hits you receive every floor.",
        spriteFrame = 9,
        mods = { boonAegis = 2 },
        upgradedMods = { boonAegis = 3 }
    },
    { -- 11
        name = "Generosity",
        description = "The first item or deal you purchase in the run costs 1 coin.",
        upgradedDescription = "The first {{boonGenerosity}} items or deals you purchase in the run cost 1 coin.",
        spriteFrame = 10,
        mods = { boonGenerosity = 1 },
        upgradedMods = { boonGenerosity = 2 }
    },
    { -- 12
        name = "Protection",
        description = "Gain a Holy Mantle shield every 2 floors. +10% speed while holy mantle is active.",
        upgradedDescription = "Gain a Holy Mantle shield every floor. +15% speed while holy mantle is active.",
        spriteFrame = 11,
        mods = { boonProtection = 2 },
        upgradedMods = { boonProtection = 1 }
    },
    { -- 13
        name = "Lethargy",
        description = {
            "{{boonLethargyChance}}% chance to slow enemies for {{boonLethargyLen}} seconds on hit.",
            "Your minimum speed is now {{boonLethargyMinSpd}}."
        },
        spriteFrame = 12,
        mods = { boonLethargyChance = 7, boonLethargyLen = 2, boonLethargyMinSpd = 0.8 },
        upgradedMods = { boonLethargyChance = 12, boonLethargyLen = 3, boonLethargyMinSpd = 1 },
    },
    { -- 14
        name = "Horror",
        description = {
            "{{boonHorrorChance}}% chance to fear enemies for {{boonHorrorLen}} seconds on hit.",
            "Feared enemies receive {{boonHorrorDmg}}% more damage."
        },
        spriteFrame = 13,
        mods = { boonHorrorChance = 7, boonHorrorLen = 3, boonHorrorDmg = 10 },
        upgradedMods = { boonHorrorChance = 12, boonHorrorLen = 4, boonHorrorDmg = 10 }
    },
    { -- 15
        name = "Hypnosis",
        description = {
            "{{boonHypnoChance}}% chance to charm enemies for {{boonHypnoLen}} seconds on hit.",
            "Charmed enemies receive {{boonHypnoDmg}}% more damage."
        },
        spriteFrame = 14,
        mods = { boonHypnoChance = 7, boonHypnoLen = 3, boonHypnoDmg = 10 },
        upgradedMods = { boonHypnoChance = 12, boonHypnoLen = 4, boonHypnoDmg = 10 }
    },
    { -- 16
        name = "Paralysis",
        description = {
            "{{boonParaChance}}% chance to paralyze enemies for {{boonParaLen}} seconds on hit.",
            "Paralyzed enemies take 30% more damage from explosions."
        },
        spriteFrame = 15,
        mods = { boonParaChance = 7, boonParaLen = 2 },
        upgradedMods = { boonParaChance = 12, boonParaLen = 3 }
    },
    { -- 17
        name = "Activity",
        description = "When using an active item with at least 2 charges, become invulnerable for {{boonActivity}} seconds.",
        spriteFrame = 16,
        mods = { boonActivity = 1.5 },
        upgradedMods = { boonActivity = 2.5 }
    },
    { -- 18
        name = "Plentiful Emptiness",
        description = {
            "+{{boonEmptinessDmg}}% damage while the active item slot is empty.",
            "+{{boonEmptinessTears}}% tears while the trinket slot is empty."
        },
        spriteFrame = 17,
        mods = { boonEmptinessDmg = 20, boonEmptinessTears = 20 },
        upgradedMods = { boonEmptinessDmg = 35, boonEmptinessTears = 35 }
    },
    { -- 19
        name = "Volatility",
        description = {
            "Enemies take {{boonVolatilityDmg}}% more damage from explosions.",
            "Start with an additional {{boonVolatilityBombs}} bombs."
        },
        spriteFrame = 18,
        mods = { boonVolatilityDmg = 30, boonVolatilityBombs = 2 },
        upgradedMods = { boonVolatilityDmg = 50, boonVolatilityBombs = 4 }
    },
    { -- 20
        name = "Improvised Charges",
        description = "Consuming a Card, Pill or Rune on use grants all your active items 1 charge.",
        upgradedDescription = "Consuming a Card, Pill or Rune on use grants all your active items {{boonImpCharges}} charges.",
        spriteFrame = 19,
        mods = { boonImpCharges = 1 },
        upgradedMods = { boonImpCharges = 2 }
    },
    { -- 21
        name = "the Champion Slayer",
        description = "+{{boonChampSlayDmg}}% damage for the current floor when killing a champion monster, up to {{boonChampSlayMax}}%",
        spriteFrame = 20,
        mods = { boonChampSlayDmg = 1, boonChampSlayMax = 15 },
        upgradedMods = { boonChampSlayDmg = 2, boonChampSlayMax = 25 }
    },
    { -- 22
        name = "Meek Giants",
        description = "Bosses start with {{boonMeekGiants}}% of their HP missing.",
        spriteFrame = 21,
        mods = { boonMeekGiants = 12 },
        upgradedMods = { boonMeekGiants = 18 }
    },
    { -- 23
        name = "the Last Gasp",
        description = "Dying in any of the final boss floors no longer consumes expedition attempts.",
        upgradedDescription = "Dying at any point at or past Womb II (or alternates) no longer consumes expedition attempts.",
        spriteFrame = 22,
        mods = { boonLastGasp = 1 },
        upgradedMods = { boonLastGasp = 2 }
    },
    { -- 24
        name = "the Blessed Expedition",
        description = "You can no longer gain Expedition Curses.",
        upgradedDescription = {
            "You can no longer gain Expedition Curses.",
            "For each existing Expedition Curse you have, gain +4% all stats, up to +20%"
        },
        spriteFrame = 23,
        mods = { boonBlessedExp = 1 },
        upgradedMods = { boonBlessedExp = 2 }
    },
    { -- 25
        name = "Wisdom",
        description = "+{{xpgain}}% XP gain within expedition runs.",
        spriteFrame = 24,
        mods = { xpgain = 20 },
        upgradedMods = { xpgain = 40 }
    },
    { -- 26
        name = "Unexpected Gift",
        description = {
            "A random treasure room within the first 6 you visit will contain an additional passive item",
            "from the treasure or shop item pool."
        },
        upgradedDescription = {
            "A random treasure room within the first 6 you visit will contain an additional passive item",
            "from the angel or devil item pool."
        },
        spriteFrame = 25,
        mods = { boonUnexGift = 1 },
        upgradedMods = { boonUnexGift = 2 }
    }
}

-- List of available expedition curses
PST.expeditionCurses = {
    { -- 1
        name = "Enfeeblement",
        description = "{{damagePerc}}% damage.",
        spriteFrame = 0,
        modsFunc = function(depth)
            return { damagePerc = -math.min(70, 25 + depth) }
        end
    },
    { -- 2
        name = "Lethargy",
        description = "{{speedPerc}}% speed.",
        spriteFrame = 1,
        modsFunc = function(depth)
            return { speedPerc = -math.min(70, 25 + depth) }
        end
    },
    { -- 3
        name = "Tear Deprivation",
        description = "{{tearsPerc}}% tears.",
        spriteFrame = 2,
        modsFunc = function(depth)
            return { tearsPerc = -math.min(70, 25 + depth) }
        end
    },
    { -- 4
        name = "the Unfortunate",
        description = "{{luckPerc}}% luck.",
        spriteFrame = 3,
        modsFunc = function(depth)
            return { luckPerc = -math.min(70, 25 + depth) }
        end
    },
    { -- 5
        name = "the Inverse Fortune",
        description = {
            "If your luck is positive, apply {{curseInvFortune}}% of it as an all stats down percentage, up to -{{curseInvFortuneMax}}%.",
            "(e.g. 4 luck would apply -12% all stats, 10 luck would apply -30%, etc.)"
        },
        spriteFrame = 4,
        modsFunc = function(depth)
            return { curseInvFortune = 300, curseInvFortuneMax = 30 }
        end,
        minDepth = 6
    },
    { -- 6
        name = "Resilience",
        description = "+{{curseResilience}}% monster HP",
        spriteFrame = 5,
        modsFunc = function(depth)
            return { curseResilience = math.min(60, 25 + depth) }
        end
    },
    { -- 7
        name = "Ephemeral Pieces",
        description = "All non-vanishing pickup drops now vanish after {{curseEphPieces}} seconds.",
        spriteFrame = 6,
        modsFunc = function(depth)
            local secs = 4
            if depth >= 10 then secs = 3 end
            if depth >= 25 then secs = 2 end
            return { curseEphPieces = secs }
        end
    },
    { -- 8
        name = "Power Demand",
        description = {
            "When clearing a room, {{cursePowerDemandCharges}}% chance to lose a charge from active items.",
            "Double this chance if you took damage within the room.",
            "+{{cursePowerDemandScarcity}}% battery scarcity."
        },
        spriteFrame = 7,
        modsFunc = function(depth)
            local tmpCharges, tmpScarcity = 25, 35
            if depth >= 15 then
                tmpCharges = 35
                tmpScarcity = 45
            end
            return { cursePowerDemandCharges = tmpCharges, cursePowerDemandScarcity = tmpScarcity }
        end
    },
    { -- 9
        name = "Giants' Fortification",
        description = "Bosses block the first {{curseGiantsFort}} hits they receive.",
        spriteFrame = 8,
        modsFunc = function(depth)
            return { curseGiantsFort = 7 + math.floor(depth / 3) }
        end
    },
    { -- 10
        name = "Greater Expenses",
        description = "Non-pickup shop items are {{curseGreaterExpenses}}% more expensive.",
        spriteFrame = 9,
        modsFunc = function(depth)
            return { curseGreaterExpenses = 20 + depth }
        end
    },
    { -- 11
        name = "Flimsy Gadgets",
        description = {
            "When hit, {{curseFlimGadgDrop}}% chance to drop held trinkets.",
            "{{curseFlimGadgVanish}}% chance for dropped trinkets to vanish instead. This includes",
            "trinkets dropped manually by players."
        },
        spriteFrame = 10,
        modsFunc = function(depth)
            return {
                curseFlimGadgDrop = 15 + depth,
                curseFlimGadgVanish = 10 + math.floor(depth / 2)
            }
        end
    },
    { -- 12
        name = "Abundant Might",
        description = {
            "+{{curseAbundantMightChance}}% chance for monsters to be champions.",
            "Champion monsters gain {{curseAbundantMightDmgRed}}% damage reduction."
        },
        spriteFrame = 11,
        modsFunc = function(depth)
            return {
                curseAbundantMightChance = 20,
                curseAbundantMightDmgRed = math.min(70, 30 + math.floor(depth / 3))
            }
        end
    },
    { -- 13
        name = "Vanishing Wealth",
        description = "When entering a floor, lose {{curseVanishingWealth}} coins.",
        spriteFrame = 12,
        modsFunc = function(depth)
            return { curseVanishingWealth = math.min(20, 6 + depth) }
        end
    },
    { -- 14
        name = "Precariousness",
        description = "When first entering a shop room, remove {{cursePrecarious}} random sold items.",
        spriteFrame = 13,
        modsFunc = function(depth)
            local rem = 2
            if depth >= 12 then rem = 3 end
            return { cursePrecarious = rem }
        end
    },
    { -- 15
        name = "Unexpected Taxation",
        description = "When first entering a room with monsters, lose {{curseUnexpectedTax}} coin(s).",
        spriteFrame = 14,
        modsFunc = function(depth)
            local tax = 1
            if depth >= 15 then tax = 2 end
            return { curseUnexpectedTax = tax }
        end
    },
    { -- 16
        name = "Fading Keys",
        description = "Whenever you spend a key, spend {{curseFadingKeys}} additional key(s).",
        spriteFrame = 15,
        modsFunc = function(depth)
            local keys = 1
            if depth >= 25 then keys = 2 end
            return { curseFadingKeys = keys }
        end
    },
    { -- 17
        name = "Punishment",
        description = "Take 1/2 heart damage every {{cursePunishment}} rooms cleared. This cannot kill you.",
        spriteFrame = 16,
        modsFunc = function(depth)
            local clears = 9
            if depth >= 10 then clears = 8 end
            if depth >= 25 then clears = 7 end
            return { cursePunishment = clears }
        end
    },
    { -- 18
        name = "Mortality",
        description = "Extra life items can no longer show up.",
        spriteFrame = 17,
        modsFunc = function(depth)
            return { curseMortality = true }
        end
    },
    { -- 19
        name = "Ancient Stars",
        description = "Expedition runs now require an Ancient Starcursed Jewel to be socketed.",
        spriteFrame = 18,
        modsFunc = function(depth)
            return { curseAncientStars = true }
        end
    },
    { -- 20
        name = "Diminished Powers",
        description = {
            "Your lasers deal -{{curseDimPowerLaser}}% damage.",
            "Explosions deal -{{curseDimPowerExpl}}% damage."
        },
        spriteFrame = 19,
        modsFunc = function(depth)
            return {
                curseDimPowerLaser = math.min(50, 15 + depth),
                curseDimPowerExpl = math.min(60, 25 + depth)
            }
        end
    },
    { -- 21
        name = "Shrouding",
        description = "Expedition node rewards and curses are no longer known.",
        spriteFrame = 20,
        modsFunc = function(depth)
            return { curseShrouding = true }
        end,
        minDepth = 5
    },
    { -- 22
        name = "the Boonless",
        description = "You can no longer gain Expedition boons.",
        spriteFrame = 21,
        modsFunc = function(depth)
            return { curseBoonless = true }
        end,
        minDepth = 5
    },
    { -- 23
        name = "the Heartbroken",
        description = "Start with {{curseHeartbroken}} additional broken heart(s).",
        spriteFrame = 22,
        modsFunc = function(depth)
            local broken = 1
            if depth >= 25 then broken = 2 end
            return { curseHeartbroken = broken }
        end,
        minDepth = 8
    },
    { -- 24
        name = "the Witless",
        description = "{{xpgain}}% XP gain within expedition runs.",
        spriteFrame = 23,
        modsFunc = function(depth)
            return { xpgain = -math.min(60, 40 + math.floor(depth / 2)) }
        end,
        minDepth = 5
    },
    { -- 25
        name = "Urgency",
        description = {
            "{{bossRushTimer}} minutes to the Boss Rush door timer.",
            "{{hushTimer}} minutes to Hush's door timer."
        },
        spriteFrame = 24,
        modsFunc = function(depth)
            local mins = 2
            if depth >= 10 then mins = 3 end
            if depth >= 20 then mins = 4 end
            return { bossRushTimer = -mins, hushTimer = -mins }
        end
    }
}

-- List of node objectives
PST.expeditionObjectives = {
    defeatMonsters = {
        description = "Defeat {{progress}} monsters.",
        reqFunc = function(depth, column)
            local req = 50 + depth * 2 + column * 2
            return req
        end
    },
    defeatChampions = {
        description = "Defeat {{progress}} champion monsters.",
        reqFunc = function(depth, column)
            local req = 20 + math.floor(depth * 1.2) + math.floor(column * 1.25)
            return req
        end
    },
    defeatBosses = {
        description = "Defeat {{progress}} bosses.",
        reqFunc = function(depth, column)
            local req = 4 + math.floor(depth / 3) + math.floor(column / 2)
            return req
        end
    },
    challengeRooms = {
        description = "Clear {{progress}} challenge rooms.",
        reqFunc = function(depth, column)
            local req = 2 + math.floor(depth / 5) + math.floor(column / 6)
            return req
        end
    },
    experience = {
        description = "Earn {{progress}} experience within runs.",
        reqFunc = function(depth, column)
            local req = 1500 + depth * 450 + column * 250
            return req
        end
    },
    obols = {
        description = "Gather {{progress}} Arcane Obols.",
        reqFunc = function(depth, column)
            local req = 20 + depth * 5 + column * 2
            return req
        end
    },
    coins = {
        description = "Collect {{progress}} coins.",
        reqFunc = function(depth, column)
            local req = 30 + depth * 5 + column * 3
            return req
        end
    },
    purchases = {
        description = "Purchase {{progress}} items from shops or deals.",
        reqFunc = function(depth, column)
            local req = 7 + depth + math.floor(column / 3)
            return req
        end
    },
    devilDeals = {
        description = "Make {{progress}} deals with the devil.",
        reqFunc = function(depth, column)
            local req = math.min(15, 2 + math.floor(depth / 3) + math.floor(column / 6))
            return req
        end
    },
    keys = {
        description = "Spend {{progress}} keys.",
        reqFunc = function(depth, column)
            local req = 7 + math.floor(depth / 2) + math.floor(column / 2)
            return req
        end
    },
    beggars = {
        description = "Assist any type of beggar {{progress}} times.",
        reqFunc = function(depth, column)
            local req = 10 + depth + math.floor(column / 2)
            return req
        end
    },
    explosions = {
        description = "Kill {{progress}} enemies with explosions.",
        reqFunc = function(depth, column)
            local req = 10 + depth * 2 + column
            return req
        end,
        minDepth = 4,
    },
    chests = {
        description = "Open {{progress}} chests of any type.",
        reqFunc = function(depth, column)
            local req = 12 + depth + math.floor(column / 2)
            return req
        end
    },
    goldChests = {
        description = "Open {{progress}} golden chests.",
        reqFunc = function(depth, column)
            local req = 7 + math.floor(depth / 2) + math.floor(column / 2)
            return req
        end
    },
    redChests = {
        description = "Open {{progress}} red chests.",
        reqFunc = function(depth, column)
            local req = 6 + math.floor(depth / 2) + math.floor(column / 3)
            return req
        end
    },
    stoneChests = {
        description = "Open {{progress}} stone chests.",
        reqFunc = function(depth, column)
            local req = 2 + math.floor(depth / 4) + math.floor(column / 5)
            return req
        end
    },
    rooms = {
        description = "Clear {{progress}} rooms containing at least 5 monsters.",
        reqFunc = function(depth, column)
            local req = 10 + depth * 2 + column
            return req
        end
    },
    bossRoomsNoDmg = {
        description = "Clear {{progress}} boss rooms without taking damage.",
        reqFunc = function(depth, column)
            local req = 3 + math.floor(depth / 2) + math.floor(column / 3)
            return req
        end,
        minDepth = 5
    },
    cardsPillsRunes = {
        description = "Use {{progress}} cards, pills or runes.",
        reqFunc = function(depth, column)
            local req = 10 + depth + column
            return req
        end
    },
    secretRooms = {
        description = "Enter {{progress}} secret, super secret or ultra secret rooms.",
        reqFunc = function(depth, column)
            local req = 4 + math.floor(depth / 3) + math.floor(column / 4)
            return req
        end
    },
    hearts = {
        description = "Pick up {{progress}} hearts of any type.",
        reqFunc = function(depth, column)
            local req = 14 + math.floor(depth / 2) + math.floor(column / 2)
            return req
        end
    },
    shopDonation = {
        description = "Donate {{progress}} coins to the shop/greed donation machine.",
        reqFunc = function(depth, column)
            local req = math.min(99, 15 + depth + math.floor(column / 2))
            return req
        end
    },
    curseRooms = {
        description = "Enter {{progress}} curse rooms.",
        reqFunc = function(depth, column)
            local req = 5 + math.floor(depth / 3) + math.floor(column / 5)
            return req
        end
    },
    activeItems = {
        description = "Use an active item with at least 3 charges {{progress}} times.",
        reqFunc = function(depth, column)
            local req = 12 + math.floor(depth / 2) + math.floor(column / 2)
            return req
        end
    },
    tintedRocks = {
        description = "Destroy {{progress}} tinted rocks.",
        reqFunc = function(depth, column)
            local req = 4 + math.floor(depth / 4) + math.floor(column / 4)
            return req
        end
    },
    winRun = {
        description = "Win a run having defeated at least 1 final boss.",
        reqFunc = function() return 1 end
    }
}
-- Objective names list, make sure order is consistent as seeded generation depends on it
PST.expeditionObjectiveList = {
    "defeatMonsters", "defeatChampions", "defeatBosses", "challengeRooms", "experience",
    "obols", "coins", "purchases", "devilDeals", "keys", "beggars", "explosions",
    "chests", "goldChests", "redChests", "stoneChests", "rooms", "bossRoomsNoDmg",
    "cardsPillsRunes", "secretRooms", "hearts", "shopDonation", "curseRooms",
    "activeItems", "tintedRocks"
}

-- Final node objectives
PST.expeditionObjectivesFinal = {
    bossRush = {
        description = "Complete {{progress}} boss rush encounter(s).",
        reqFunc = function(depth, column)
            local req = 1 + math.floor(depth / 12)
            return req
        end
    },
    hush = {
        description = "Defeat Hush.",
        maxDepth = 8,
        reqFunc = function() return 1 end
    },
    hushNoDmgTwice = {
        description = "Defeat Hush without taking damage more than twice during the fight.",
        minDepth = 6,
        reqFunc = function() return 1 end
    },
    hushNoDmgOnce = {
        description = "Defeat Hush without taking damage more than once during the fight.",
        minDepth = 14,
        reqFunc = function() return 1 end
    },
    finalBoss = {
        description = {
            "Defeat any final boss {{progress}} time(s).",
            "Final bosses include Delirium, ???, The Lamb, Mega Satan, The Beast, Mother and Ultra Greed."
        },
        reqFunc = function(depth, column)
            local req = 1 + math.floor(depth / 10)
            return req
        end
    },
    floorNoDmgTwice = {
        description = "Clear {{progress}} floors without taking damage more than twice.",
        reqFunc = function(depth, column)
            local req = 2 + math.floor(depth / 6)
            return req
        end
    },
    floorNoDmgOnce = {
        description = "Clear {{progress}} floors without taking damage more than once.",
        minDepth = 8,
        reqFunc = function(depth, column)
            local req = 2 + math.floor(depth / 6)
            return req
        end
    },
    bossesNoDmgC3 = {
        description = "Clear {{progress}} boss room(s) past Chapter 3 (Womb and beyond) without taking damage.",
        reqFunc = function(depth, column)
            local req = math.min(10, 2 + math.floor(depth / 6))
            if depth <= 2 then req = 1 end
            return req
        end
    },
    --[[winItemPools = {
        description = {
            "Complete a run while possessing at least one item for each of these item pools:",
            "Treasure, Shop, Angel, Devil"
        },
        reqFunc = function() return 1 end
    },]]
    beastDeliNoDmg = {
        description = "Defeat The Beast or Delirium without taking damage more than once.",
        reqFunc = function() return 1 end,
        minDepth = 14
    }
}
PST.expeditionObjectiveFinalList = {
    "bossRush", "hush", "finalBoss", "floorNoDmgTwice", "bossesNoDmgC3", "beastDeliNoDmg"
}

-- Node reward data
PST.expeditionRewardData = {
    -- Arcane obols
    [PSTExpNodeRewardType.OBOLS] = function(RNG, depth, column)
        local baseAmt = 2 + RNG:RandomInt(1, 3)
        return baseAmt + depth * 4 + column * 2
    end,
    -- EXP
    [PSTExpNodeRewardType.EXP] = function(RNG, depth, column)
        local baseAmt = math.floor(200 + 200 * RNG:RandomFloat())
        return baseAmt + depth * 50 + column * 40
    end,
    -- Expedition attempts
    [PSTExpNodeRewardType.ATTEMPTS] = function(RNG, depth, column)
        local atts = 1
        if depth >= 6 and column >= 4 and RNG:RandomFloat() < 0.2 then
            atts = 2
        end
        return atts
    end,
    -- Order (uber expeditions)
    [PSTExpNodeRewardType.ORDER] = function(RNG, depth, column)
        local baseAmt = 4 + RNG:RandomInt(1, 7)
        return math.min(20, baseAmt + column)
    end
}

-- Expedition-specific modifier descriptions
PST.expedDescriptions = {
    expedImp_mobHP = "+%d%% monster HP.",
    expedImp_mobSpeed = "+%d%% monster speed.",
    expedImp_floorCurse = "+%d%% chance to receive a curse when entering a floor.",
    expedImp_pickupScarcity = "+%d%% coin, key, bomb and heart scarcity.",
    expedImp_quality4Remove = "Remove %d random quality 4 item(s) from the pool when starting a run.",
    expedImp_heartbreak = {
        "Start with %d additional broken heart(s).",
        "Heartbreak can no longer show up."
    },
    lessAttempts = "-%d max expedition attempt(s).",
    expedImp_mobDmgRed = "+%d%% monster damage reduction.",

    -- Deep-Space Distortion modifier descriptions
    dsdMod_finalDmgRed = "+40% final boss damage reduction.",
    dsdMod_finalDmgImm = "Final bosses gain damage immunity for 5 seconds every 25% HP lost.",
    dsdMod_finalLastStand = "While final bosses are at 12% HP or less, all their hits instantly kill you.",
    dsdMod_pickupLimit = "You cannot have more than 25 coins, 4 keys or 4 bombs.",
    dsdMod_treeEffect = "Tree effects on stats are 35% as effective.",
    dsdMod_heartScarcity = "+50% heart scarcity.",
    dsdMod_pickupScarcity = "+50% coin, key and bomb scarcity."
}

-- List of Deep-Space Distortion modifiers (for uber expeditions)
PST.expedDeepSpaceMods = {
    "dsdMod_finalDmgRed", "dsdMod_finalDmgImm", "dsdMod_finalLastStand", "dsdMod_pickupLimit",
    "dsdMod_treeEffect", "dsdMod_heartScarcity", "dsdMod_pickupScarcity"
}

-- Uber expedition entropy modifiers
PST.expedEntropyMods = {
    expedEnt_actives = { -- 1 TEST
        desc = "Use active items with at least 3 charges: +2 entropy.",
        entropy = 2
    },
    expedEnt_clearTime = { -- 2 TEST
        desc = "Take longer than 10 seconds to clear a regular room past floor 4: +1 entropy.",
        entropy = 1
    },
    expedEnt_bossDmg = { -- 3 TEST
        desc = "Take damage from a champion or boss monster: +3 entropy.",
        entropy = 3
    },
    expedEnt_purchases = { -- 4 TEST
        desc = "Purchase items or make devil deals more than 3 times within a floor: +7 entropy per item/deal.",
        entropy = 7
    },
    expedEnt_passiveItems = { -- 5 TEST
        desc = {
            "Acquire passive items while having at least 12 passive items, excluding progression items:",
            "+4 entropy per new item."
        },
        entropy = 4
    },
    expedEnt_hearts = { -- 6 TEST
        desc = "Pick up non-red hearts while having a total of at least 5 hearts of any type: +3 entropy.",
        entropy = 3
    },
    expedEnt_trinketSwap = { -- 7 TEST
        desc = "After obtaining a trinket, lose or swap it: +4 entropy.",
        entropy = 4
    },
    expedEnt_activeSwap = { -- 8 TEST
        desc = "After obtaining an active item (excluding starter items), lose or swap it: +6 entropy.",
        entropy = 6
    },
    expedEnt_chests = { -- 9 TEST
        desc = {
            "Open a chest after having opened 5 chests within the floor, excluding Sidereal Caches:",
            "+3 entropy per chest."
        },
        entropy = 3
    },
    expedEnt_specialDmg = { -- 10 TEST
        desc = "Take damage from explosions or lasers: +3 entropy.",
        entropy = 3
    },
    expedEnt_tearDmg = { -- 11 TEST
        desc = "Take damage from tears: +2 entropy.",
        entropy = 2
    },
    expedEnt_finalBossDmg = { -- 12 TEST
        desc = "Take damage from a final boss: +4 entropy.",
        entropy = 4
    },
    -- AUXILIARY
    expedEnt_loseRun = { -- 13 TEST
        desc = "Lose a run: +12 entropy.",
        auxiliary = true,
        entropy = 12
    },
    expedEnt_noPickups = { -- 14 TEST
        desc = "Enter a floor past the first with 0 coins, 0 keys or 0 bombs: +5 entropy per pickup at 0.",
        auxiliary = true,
        entropy = 5
    },
    expedEnt_compNode = { -- 15 TEST
        desc = "Complete this expedition node: +10 entropy.",
        auxiliary = true,
        entropy = 10
    }
}
PST.expedEntropyModList = {
    "expedEnt_actives", "expedEnt_clearTime", "expedEnt_bossDmg", "expedEnt_purchases", "expedEnt_passiveItems",
    "expedEnt_hearts", "expedEnt_trinketSwap", "expedEnt_activeSwap", "expedEnt_chests", "expedEnt_specialDmg",
    "expedEnt_tearDmg", "expedEnt_finalBossDmg", "expedEnt_loseRun", "expedEnt_noPickups", "expedEnt_compNode"
}

local obolStageFactor = 0.002
-- Obol-rewarding event quantities
PST.obolEvents = {
    -- On champion mob kill
    championKill = function(depth, chanceMod)
        local chance = 0.07 + (chanceMod or 0) + (PST:getLevel():GetStage() - 1) * obolStageFactor
        local abundantObols = PST:getTreeSnapshotMod("boonAbundantObols", 0)
        if abundantObols > 0 then chance = chance * 2 end
        if math.random() < chance then
            local amt = 4 + 2 * (depth - 1)
            amt = math.ceil(amt * (1 + abundantObols / 100))
            return amt
        end
        return 0
    end,
    -- On boss kill
    bossKill = function(depth, chanceMod)
        local chance = 0.17 + (chanceMod or 0) + (PST:getLevel():GetStage() - 1) * obolStageFactor
        -- Depth chance increase
        chance = chance + (depth - 1) * 0.005
        -- Reduce chance by .5% per boss obol drop
        chance = chance - 0.005 * PST:getTreeSnapshotMod("bossObolDrops", 0)

        local abundantObols = PST:getTreeSnapshotMod("boonAbundantObols", 0)
        if abundantObols > 0 then chance = chance * 2 end
        if math.random() < chance then
            local amt = 2 + PST:getLevel():GetStage() + 3 * (depth - 1)
            amt = math.ceil(amt * (1 + abundantObols / 100))
            return amt
        end
        return 0
    end,
    -- On challenge room clear
    challClear = function(depth, chanceMod)
        local chance = 0.4 + (chanceMod or 0) + (PST:getLevel():GetStage() - 1) * obolStageFactor
        local abundantObols = PST:getTreeSnapshotMod("boonAbundantObols", 0)
        if abundantObols > 0 then chance = chance * 2 end
        if math.random() < chance then
            local amt = 5 + PST:getLevel():GetStage() * 2 + 3 * (depth - 1)
            amt = math.ceil(amt * (1 + abundantObols / 100))
            return amt
        end
        return 0
    end,
    -- On fully helping beggar (teleports away)
    beggarHelp = function(depth, chanceMod)
        local chance = 0.7 + (chanceMod or 0) + (PST:getLevel():GetStage() - 1) * obolStageFactor
        local abundantObols = PST:getTreeSnapshotMod("boonAbundantObols", 0)
        if abundantObols > 0 then chance = chance * 2 end
        if math.random() < chance then
            local amt = 10 + 3 * (depth - 1)
            amt = math.ceil(amt * (1 + abundantObols / 100))
            return amt
        end
        return 0
    end,
    -- On opening non-normal chests
    chests = function(depth, chanceMod)
        local chance = 0.14 + (chanceMod or 0) + (PST:getLevel():GetStage() - 1) * obolStageFactor
        local abundantObols = PST:getTreeSnapshotMod("boonAbundantObols", 0)
        if abundantObols > 0 then chance = chance * 2 end
        if math.random() < chance then
            local amt = 5 + (depth - 1)
            amt = math.ceil(amt * (1 + abundantObols / 100))
            return amt
        end
        return 0
    end,
    -- Sidereal Cache obols
    siderealCache = function(depth)
        local abundantObols = PST:getTreeSnapshotMod("boonAbundantObols", 0)
        local amt = math.ceil((4 + math.random(0, 3) + depth * (1 + 0.25 * math.random())) * (1 + abundantObols / 100))
        return amt
    end,
    -- On boss rush clear
    bossRush = function(depth)
        local amt = 10 + 5 * (depth - 1) + (PST:getLevel():GetStage() - 1) * obolStageFactor
        amt = math.ceil(amt * (1 + PST:getTreeSnapshotMod("boonAbundantObols", 0) / 100))
        return amt
    end
}