PST.treeModDescriptionCategories = {
    stats = { name = "Global stat alterations:", color = KColor(0.9, 1, 0.9, 1) },
    condStats = { name = "Conditional stat alterations:", color = KColor(0.8, 1, 0.8, 1) },
    xp = { name = "XP and respecs:", color = KColor(0.9, 0.9, 0.9, 1) },
    extra = { name = "Miscellaneous:", color = KColor(0.9, 0.9, 0.7, 1) },
    charTree = { name = "", color = KColor(1, 0.8, 1, 1) }
}

PST.treeModDescriptions = {
    --#region STATS CATEGORY --
    allstats = {
        str = "%s%.2f all stats",
        addPlus = true,
        category = "stats", sort = 1
    },
    allstatsPerc = {
        str = "%s%.2f%% all stats",
        addPlus = true,
        category = "stats", sort = 1
    },
    damage = {
        str = "%s%.2f damage",
        addPlus = true,
        category = "stats", sort = 2
    },
    damagePerc = {
        str = "%s%.2f%% damage",
        addPlus = true,
        category = "stats", sort = 2
    },
    luck = {
        str = "%s%.2f luck",
        addPlus = true,
        category = "stats", sort = 3
    },
    luckPerc = {
        str = "%s%.2f%% luck",
        addPlus = true,
        category = "stats", sort = 3
    },
    speed = {
        str = "%s%.2f speed",
        addPlus = true,
        category = "stats", sort = 4
    },
    speedPerc = {
        str = "%s%.2f%% speed",
        addPlus = true,
        category = "stats", sort = 4
    },
    tears = {
        str = "%s%.2f tears",
        addPlus = true,
        category = "stats", sort = 5
    },
    tearsPerc = {
        str = "%s%.2f%% tears",
        addPlus = true,
        category = "stats", sort = 5
    },
    shotSpeed = {
        str = "%s%.2f shot speed",
        addPlus = true,
        category = "stats", sort = 6
    },
    shotSpeedPerc = {
        str = "%s%.2f%% shot speed",
        addPlus = true,
        category = "stats", sort = 6
    },
    range = {
        str = "%s%.2f range",
        addPlus = true,
        category = "stats", sort = 7
    },
    rangePerc = {
        str = "%s%.2f%% range",
        addPlus = true,
        category = "stats", sort = 7
    },
    --#endregion

    --#region CONDITIONAL STATS CATEGORY --
    beggarLuck = {
        str = "%.2f luck gained when helping any beggar",
        category = "condStats", sort = 10
    },
    cardFloorLuck = {
        str = "%d%% increased luck for the current floor when you use a card, up to 15%% (shared with pill luck modifiers)",
        category = "condStats", sort = 11
    },
    pillFloorLuck = {
        str = "%d%% increased luck for the current floor when you use a pill, up to 15%% (shared with card luck modifiers)",
        category = "condStats", sort = 11
    },
    secretRoomFloorLuck = {
        str = "%s%.2f luck for the current floor when first entering a secret or super secret room",
        addPlus = true,
        category = "condStats", sort = 12
    },
    secretRoomRandomStat = {
        str = {
            "+0.01 to a random stat when first entering a secret room",
            "    Rolls %d times"
        },
        category = "condStats", sort = 13
    },
    tintedRockAllstats = {
        str = "%s%.2f all stats when blowing up a tinted rock",
        addPlus = true,
        category = "condStats", sort = 13
    },
    planetariumAllStats = {
        str = "%s%.2f all stats when entering a Planetarium for the first time in the run",
        category = "condStats", sort = 14
    },
    firstItemDamage = {
        str = "%s%.2f damage when first obtaining a passive item",
        addPlus = true,
        category = "condStats", sort = 15
    },
    firstItemTears = {
        str = "%s%.2f tears when first obtaining a passive item",
        addPlus = true,
        category = "condStats", sort = 15
    },
    firstItemRange = {
        str = "%s%.2f range when first obtaining a passive item",
        addPlus = true,
        category = "condStats", sort = 15
    },
    firstItemSpeed = {
        str = "%s%.2f speed when first obtaining a passive item",
        addPlus = true,
        category = "condStats", sort = 15
    },
    firstItemShotspeed = {
        str = "%s%.2f shot speed when first obtaining a passive item",
        addPlus = true,
        category = "condStats", sort = 15
    },
    firstItemLuck = {
        str = "%s%.2f luck when first obtaining a passive item",
        addPlus = true,
        category = "condStats", sort = 15
    },
    curseAllstats = {
        str = "%s%.2f%% all stats while a level curse is present.",
        addPlus = true,
        category = "condStats", sort = 16
    },
    --#endregion

    --#region XP CATEGORY --
    xpgain = {
        str = "%s%.2f%% xp gain",
        addPlus = true,
        category = "xp", sort = 100
    },
    secretXP = {
        str = "%d xp gained when first entering a secret room",
        category = "xp", sort = 101
    },
    challengeXP = {
        str = "%d xp gained when completing a challenge room",
        category = "xp", sort = 102
    },
    challengeXPgain = {
        str = "%s%.2f%% xp gain within a challenge room",
        addPlus = true,
        category = "xp", sort = 102
    },
    bossChallengeXP = {
        str = "Challenge room xp bonuses apply to boss challenge rooms",
        category = "xp", sort = 102
    },
    xpgainNormalMob = {
        str = "%s%.2f%% xp gain from normal mobs",
        addPlus = true,
        category = "xp", sort = 103
    },
    xpgainBoss = {
        str = "%s%.2f%% xp gain from bosses",
        addPlus = true,
        category = "xp", sort = 103
    },
    expertSpelunker = {
        str = {
            "Gain no XP when first entering a secret room",
            "Gain %d XP when first entering a super secret rooms"
        },
        category = "xp", sort = 105
    },
    fireXP = {
        str = "Gain %s%d xp when putting out fires",
        addPlus = true,
        category = "xp", sort = 106
    },
    poopXP = {
        str = "Gain %s%d xp when destroying poop",
        addPlus = true,
        category = "xp", sort = 106
    },
    tintedRockXP = {
        str = "Gain %s%d xp when destroying tinted rocks",
        addPlus = true,
        category = "xp", sort = 106
    },

    respecChance = {
        str = {
            "%.2f%% chance to gain respecs on floor clear",
            "Above 100%% chance, respec gains get rolled multiple times"
        },
        category = "xp", sort = 150
    },
    relearning = {
        str = {
            "Can no longer gain respec points from completing floors",
            "Gain 10 respec points when winning a run, and additionally",
            "gain 2 respec points per completed floor in that run"
        },
        category = "xp", sort = 151
    },
    --#endregion

    --#region EXTRA (MISCELLANEOUS) CATEGORY --
    devilChance = {
        str = "%.2f%% extra chance to spawn a devil/angel room",
        category = "extra", sort = 1000
    },
    coinDupe = {
        str = "%.2f%% chance to gain an extra coin when picking one up",
        category = "extra", sort = 1001
    },
    keyDupe = {
        str = "%.2f%% chance to gain an extra key when picking one up",
        category = "extra", sort = 1001
    },
    bombDupe = {
        str = "%.2f%% chance to gain an extra bomb when picking one up",
        category = "extra", sort = 1001
    },
    grabBag = {
        str = "%.2f%% chance to spawn a grab bag when picking up a coin/key/bomb",
        category = "extra", sort = 1002
    },
    mapChance = {
        str = "%.2f%% chance to reveal the map on floor beginning, from second floor onwards",
        category = "extra", sort = 1003
    },
    luckyPennyChance = {
        str = "%.2f%% chance to replace penny drops with a lucky penny",
        category = "extra", sort = 1004
    },
    planetariumChance = {
        str = "%.2f%% increased chance of finding a planetarium",
        category = "extra", sort = 1005
    },
    hellFavour = {
        str = {
            "+1 to a random stat when entering a devil room",
            "-1 to a random stat when entering an angel room",
            "Entering an angel room will trigger a curse on the next floor"
        },
        category = "extra", sort = 1100
    },
    heavenFavour = {
        str = {
            "+1 to a random stat when entering an angel room",
            "-1 to a random stat when entering a devil room",
            "Entering an devil room will trigger a curse on the next floor"
        },
        category = "extra", sort = 1101
    },
    curseRoomSpikesOut = {
        str = "When entering a floor containing curse rooms, %d%% chance to change all spiked doors to regular ones",
        category = "extra", sort = 1102
    },
    goldenKeyConvert = {
        str = "%.2f%% chance for dropped keys to be replaced with a golden key, once per floor",
        category = "extra", sort = 1103
    },
    sacrificeRoomHearts = {
        str = "%d%% chance for a red heart to drop when using a sacrifice room, up to 4 times",
        category = "extra", sort = 1104
    },
    naturalCurseCleanse = {
        str = {
            "When entering a floor, %d%% chance to receive no natural curses",
            "    Does not prevent curses caused by other special effects"
        },
        category = "extra", sort = 1105
    },
    goldenTrinkets = {
        str = {
            "When a trinket drops, %.2f%% additional chance to replace it with its golden version",
            "    Requires having golden trinkets unlocked"
        },
        category = "extra", sort = 1106
    },
    championChance = {
        str = "%.2f%% additional chance for monsters to become champions",
        category = "extra", sort = 1107
    },
    activeItemReroll = {
        str = {
            "When first entering a room, %.2f%% chance to reroll active item pedestals into random passive items",
            "if you are holding an active item",
            "    This effect can reroll up to 2 items per floor"
        },
        category = "extra", sort = 1108
    },
    shopSaving = {
        str = "When first entering a shop, %d%% chance to reduce a random item's price by 2-3 coins",
        category = "extra", sort = 1109
    },
    spiderMod = {
        str = {
            "Begin the game with Spider Mod",
            "    Spider Mod's familiar no longer appears",
            "    Spider Mod can no longer show up naturally"
        },
        category = "extra", sort = 1110
    },
    eldritchMapping = {
        str = {
            "Whenever Curse of the Lost is or becomes present, remove it",
            "    When this happens, receive -6%% all stats for the current floor, up to -12%%",
            "    When removing Curse of the Lost, +15%% chance to receive a curse on the next floor"
        },
        category = "extra", sort = 1111
    },
    trollBombDisarm = {
        str = "%.2f%% chance to turn troll and super troll bombs into regular bomb pickups",
        category = "extra", sort = 1112
    },

    coalescingSoulChance = {
        str = {
            "Coalescing Soul:",
            "    When entering a floor, %.2f%% chance to drop a soul stone corresponding to your character.",
            "    Doesn't trigger on first floor."
        },
        category = "extra", sort = 1150
    },
    coalescingSoulProcs = {
        str = "Coalescing soul can trigger %d time(s) per run.",
        category = "extra", sort = 1151
    },
    warpedCoalescence = {
        str = {
            "40%% chance for Coalescing Soul to drop a random soul stone instead of the one matching",
            "your character.",
        },
        category = "extra", sort = 1152
    },
    coalSoulRoomClearChance = {
        str = "%s%.2f%% Coalescing Soul trigger chance when clearing a room without taking damage.",
        addPlus = true,
        category = "extra", sort = 1153
    },
    coalSoulHitChance = {
        str = "%s%.2f%% Coalescing Soul trigger chance when hit by a monster.",
        addPlus = true,
        category = "extra", sort = 1154
    },
    soulStoneAllstats = {
        str = "%s%.2f%% all stats when using a soul stone matching your character, once per run.",
        addPlus = true,
        category = "extra", sort = 1155
    },
    soulStoneUnusedAllstats = {
        str = "%s%.2f%% all stats while you haven't used a soul stone matching your character.",
        addPlus = true,
        category = "extra", sort = 1156
    },

    -- Starcursed jewels enabled
    enableSCJewels = {
        str = "Starcursed jewels can drop.",
        category = "extra", sort = 1200
    },
    --#endregion

    --#region CHARACTER TREES --
    ---- ISAAC'S TREE ----
    isaacBlessing = {
        str = {
            "Isaac's Blessing:",
            "    Start a run with %s%.2f%% all stats"
        },
        addPlus = true,
        category = "charTree", sort = 2000
    },
    magicDie = {
        str = {
            "Magic Die:",
            "    Using the D6 grants a permanent stat boost. Boosted stats depend on the room you used the D6 in:",
            "    - Angel room: +7%% speed and tears",
            "    - Devil room: +6%% damage and range",
            "    - Treasure room and shop: +7%% shot speed and luck",
            "    - Boss room: if you have a boost, augment it by +3%%, otherwise +3%% all stats",
            "    - Anywhere else: +2%% all stats"
        },
        category = "charTree", sort = 2001
    },
    intermittentConceptions = {
        str = {
            "Intermittent Conceptions:",
            "    Begin the game with Birthright",
            "    When first entering a room containing item pedestals, remove birthright",
            "    After picking up 2 passive items, receive birthright again",
            "    Effect repeats"
        },
        category = "charTree", sort = 2002
    },
    allstatsBirthright = {
        str = "%s%.2f all stats while holding Birthright",
        addPlus = true,
        category = "charTree", sort = 2003
    },
    allstatsRoom = {
        str = "When entering a room with monsters, %d%% chance to gain +4%% all stats for the current room",
        category = "charTree", sort = 2003
    },
    d6Pickup = {
        str = "%d%% chance when using D6 to spawn a random pickup (coin, bomb, key or heart)",
        category = "charTree", sort = 2004
    },
    d6HalfCharge = {
        str = "%d%% chance when using D6 to keep half of its charge",
        category = "charTree", sort = 2004
    },

    ---- MAGDALENE'S TREE ----
    magdaleneBlessing = {
        str = {
            "Magdalene's Blessing:",
            "    -0.02 speed and +0.1 damage for every red heart container after the 4th one"
        },
        category = "charTree", sort = 2050
    },
    crystalHeart = {
        str = {
            "Crystal Heart:",
            "    Yum Heart heals an additional 1/2 heart",
            "    4%% chance for Yum Heart to turn a red heart into a bone heart"
        },
        category = "charTree", sort = 2051
    },
    bloodDonor = {
        str = {
            "Blood Donor:",
            "    Blood donation machines grant 1 charge to your active item",
            "    If using Yum Heart, 50%% chance to gain 2 charges instead"
        },
        category = "charTree", sort = 2052
    },
    yumHeartHealHalf = {
        str = "%.2f%% chance for Yum Heart to heal an additional 1/2 heart",
        category = "charTree", sort = 2053
    },
    allstatsFullRed = {
        str = "%s%.2f all stats while you have at least 1 red heart container and are at full health",
        addPlus = true,
        category = "charTree", sort = 2054
    },
    bloodMachineSpawn = {
        str = {
            "%d%% chance to spawn a Blood Donation Machine at the start of a floor",
            "    Doesn't apply to first floor"
        },
        category = "charTree", sort = 2055
    },
    bloodDonationLuck = {
        str = "%s%.2f luck when using a Blood Donation Machine",
        addPlus = true,
        category = "charTree", sort = 2055
    },
    bloodDonationNickel = {
        str = "%.2f%% chance to spawn an additional nickel when using a Blood Donation Machine",
        category = "charTree", sort = 2055
    },
    healOnClear = {
        str = {
            "%.2f%% chance to heal 1/2 red heart when clearing a room",
            "    Double the chance and healing on boss rooms"
        },
        category = "charTree", sort = 2056
    },

    ---- CAIN'S TREE ----
    impromptuGambler = {
        str = {
            "Impromptu Gambler:",
            "    Spawn a crane game in treasure rooms. These can grant any unlocked item, but take an additional 3 coins on use, if possible",
            "    Interacting with the crane game removes the room's regular items",
            "    Grabbing the regular item removes the crane game"
        },
        category = "charTree", sort = 2100
    },
    thievery = {
        str = {
            "Thievery:",
            "    If you steal an item, Greed will have a chance to show up after the floor's boss is defeated",
            "    Each stolen item increases Greed's chance to show up based on its price (price * 3)%%"
        },
        category = "charTree", sort = 2101
    },
    fickleFortune = {
        str = {
            "Fickle Fortune:",
            "    +7%% luck while holding a trinket",
            "    Minimum luck is 1 while holding a trinket",
            "    7%% chance when hit for your trinket to be dropped",
            "    7%% chance for dropped trinkets to vanish"
        },
        category = "charTree", sort = 2102
    },
    stealChance = {
        str = "%d%% chance to steal an item from the shop instead of purchasing",
        category = "charTree", sort = 2103
    },
    trinketSpawn = {
        str = {
            "%d%% chance to spawn a random trinket at the beginning of a floor",
            "    Doesn't apply to first floor"
        },
        category = "charTree", sort = 2104
    },
    freeMachinesChance = {
        str = "%d%% chance for machines that cost coins to cost nothing on use",
        category = "charTree", sort = 2105
    },
    arcadeReveal = {
        str = "%d%% chance to reveal the arcade room's location if it's present on the floor",
        category = "charTree", sort = 2106
    },
    shopReveal = {
        str = "%d%% chance to reveal the shop room's location if it's present on the floor",
        category = "charTree", sort = 2106
    },
    nickelOnClear = {
        str = {
            "%.2f%% chance to spawn an additional nickel when clearing a room",
            "    Double the chance on boss rooms"
        },
        category = "charTree", sort = 2107
    },

    ---- JUDAS' TREE ----
    darkHeart = {
        str = {
            "Dark Heart:",
            "    Start with an additional black heart",
            "    -6%% damage and speed while you have no black hearts",
            "    Book of Belial removes this reduction for the current room"
        },
        category = "charTree", sort = 2150
    },
    innerDemon = {
        str = {
            "Inner Demon:",
            "    Start with Judas' Shadow",
            "    Dark Judas starts with 1 black heart instead",
            "    -15%% damage as Dark Judas"
        },
        category = "charTree", sort = 2151
    },
    sacrificeDarkness = {
        str = {
            "Sacrifice Darkness:",
            "    When collecting a black heart, trigger it and receive a soul heart instead",
            "    +1%% all stats per sacrificed black heart, up to 6%%. Resets every floor",
            "    35%% chance to convert dropped soul hearts to black hearts"
        },
        category = "charTree", sort = 2152
    },
    darkJudasSpeed = {
        str = "%s%.2f%% speed as Dark Judas",
        addPlus = true,
        category = "charTree", sort = 2153
    },
    darkJudasShotspeedRange = {
        str = "%s%.2f%% shot speed and range as Dark Judas",
        addPlus = true,
        category = "charTree", sort = 2153
    },
    belialBossHitCharge = {
        str = {
            "%.2f%% chance for the Book of Belial to gain a charge when hitting a boss",
            "    Generates a maximum of 12 charges per room"
        },
        category = "charTree", sort = 2154
    },
    lostBlackHeartsLuck = {
        str = "%s%.2f luck whenever you lose black hearts",
        addPlus = true,
        category = "charTree", sort = 2155
    },

    ---- BLUE BABY'S TREE ----
    blueGambit = {
        str = {
            "Blue Gambit:",
            "    The first card you find is guaranteed to be V - The Hierophant",
            "    The first pill you find is guaranteed to be Balls of Steel",
            "    20%% chance to take 1/2 heart damage when using a card or pill that isn't either of the above"
        },
        category = "charTree", sort = 2200
    },
    brownBlessing = {
        str = {
            "Brown Blessing:",
            "    Start with petrified poop",
            "    Using The Poop has a 7%% chance to spawn a poop item. Doesn't apply in first floor"
        },
        category = "charTree", sort = 2201
    },
    slippingEssence = {
        str = {
            "Slipping Essence:",
            "    Losing a soul heart has a 40%% chance to spawn a full soul heart",
            "    When this happens, halve this chance and receive -0.6 luck"
        },
        category = "charTree", sort = 2202
    },
    soulOnCardPill = {
        str = "%.2f%% chance to receive half a soul heart when using a pill or card",
        category = "charTree", sort = 2203
    },
    poopItemLuck = {
        str = "%s%.2f luck per held poop item",
        addPlus = true,
        category = "charTree", sort = 2204
    },
    poopTrinketLuck = {
        str = "%s%.2f luck while holding a poop trinket",
        addPlus = true,
        category = "charTree", sort = 2204
    },
    thePoopAllStats = {
        str = "%s%.2f all stats after using The Poop (once per room). Resets every room",
        addPlus = true,
        category = "charTree", sort = 2205
    },
    thePoopAllStatsPerc = {
        str = "%s%.2f%% all stats after using The Poop (once per room). Resets every room",
        addPlus = true,
        category = "charTree", sort = 2205
    },
    soulHeartTearsRange = {
        str = "%s%.2f%% tears and range whenever you gain soul hearts, up to 10%%. Resets every floor",
        addPlus = true,
        category = "charTree", sort = 2206
    },

    ---- EVE'S TREE ----
    heartless = {
        str = {
            "Heartless:",
            "    Every room you clear grants +0.5%% all stats, up to 10%%",
            "    Picking up any heart halves your current bonus"
        },
        category = "charTree", sort = 2250
    },
    darkProtection = {
        str = {
            "Dark Protection:",
            "    When first reaching 1 heart or less, gain a black heart",
            "    Resets when defeating Mom's Heart"
        },
        category = "charTree", sort = 2251
    },
    carrionAvian = {
        str = {
            "Carrion Avian:",
            "    +0.15 damage when dead bird kills an enemy, up to +3. Resets every floor",
            "    If dead bird kills a boss, gain a permanent +0.6 damage instead"
        },
        category = "charTree", sort = 2252
    },
    deadBirdNullify = {
        str = "%d%% chance for the hit that wakes dead bird to be nullified",
        category = "charTree", sort = 2253
    },
    activeDeadBirdDamage = {
        str = "%s%.2f damage while dead bird is active",
        addPlus = true,
        category = "charTree", sort = 2254
    },
    activeDeadBirdSpeed = {
        str = "%s%.2f speed while dead bird is active",
        addPlus = true,
        category = "charTree", sort = 2254
    },
    activeDeadBirdTears = {
        str = "%s%.2f tears while dead bird is active",
        addPlus = true,
        category = "charTree", sort = 2254
    },
    activeDeadBirdRange = {
        str = "%s%.2f range while dead bird is active",
        addPlus = true,
        category = "charTree", sort = 2254
    },
    activeDeadBirdShotspeed = {
        str = "%s%.2f shot speed while dead bird is active",
        addPlus = true,
        category = "charTree", sort = 2254
    },
    deadBirdInheritDamage = {
        str = "Dead bird deals an additional %d%% of your damage per tick",
        category = "charTree", sort = 2255
    },
    luckOnClearBelowFull = {
        str = "%s%.2f luck when clearing a room below full red hearts",
        addPlus = true,
        category = "charTree", sort = 2256
    },
    allstatsOneRed = {
        str = "%s%.2f all stats while you have only 1 red heart",
        addPlus = true,
        category = "charTree", sort = 2257
    },

    ---- SAMSON'S TREE ----
    hasted = {
        str = {
            "Hasted:",
            "    +10%% tears and shot speed",
            "    Taking damage reduces this bonus by 1.5%%, up to 5 times",
            "    Resets every floor"
        },
        category = "charTree", sort = 2300
    },
    rageBuildup = {
        str = {
            "Rage Buildup:",
            "    +0.02 damage when hitting an enemy, up to +3",
            "    Getting hit resets the bonus"
        },
        category = "charTree", sort = 2301
    },
    hearty = {
        str = {
            "Hearty:",
            "    Start with an additional red heart",
            "    -3%% damage per remaining red heart"
        },
        category = "charTree", sort = 2302
    },
    samsonTempDamage = {
        str = {
            "%s%.2f%% damage for 2.5 seconds after killing an enemy, or",
            "after hitting a boss 8 times. Doesn't stack"
        },
        addPlus = true,
        category = "charTree", sort = 2303
    },
    samsonTempSpeed = {
        str = {
            "%s%.2f%% speed for 2.5 seconds after killing an enemy, or",
            "after hitting a boss 8 times. Doesn't stack"
        },
        addPlus = true,
        category = "charTree", sort = 2303
    },
    speedWhenHit = {
        str = "%s%.2f%% speed when hit, up to 15%%. Resets every room",
        addPlus = true,
        category = "charTree", sort = 2304
    },
    bossCulling = {
        str = "%d%% chance on hit to deal 10x damage to bosses below 10%% HP",
        category = "charTree", sort = 2305
    },
    bossQuickKillLuck = {
        str = "%s%.2f luck if you clear the boss room within 1 minute of entering it",
        addPlus = true,
        category = "charTree", sort = 2306
    },
    bossFlawlessLuck = {
        str = "%s%.2f luck if you clear the boss room without getting hit more than 3 times",
        addPlus = true,
        category = "charTree", sort = 2306
    },

    ---- AZAZEL'S TREE ----
    demonicSouvenirs = {
        str = {
            "Demonic Souvenirs:",
            "    Spawn III - The Empress at the beginning of every other floor, starting from the first",
            "    Spawn a random evil trinket at the beginning of the second floor you enter",
            "    +6%% damage and tears while holding an evil trinket"
        },
        category = "charTree", sort = 2350
    },
    demonHelpers = {
        str = {
            "Demon Helpers:",
            "    33%% chance to receive half a black heart back when helping a Devil Beggar",
            "    Once a Devil Beggar gives a reward, 33%% chance to additionally spawn",
            "    a demon familiar",
            "    5%% chance to spawn a Devil Beggar at the beginning of a floor, starting from the second",
            "    This chance doubles every floor up to 40%%, and resets when one spawns"
        },
        category = "charTree", sort = 2351
    },
    heartsToBlack = {
        str = "%.2f%% chance to replace dropped hearts of any type with black hearts",
        category = "charTree", sort = 2352
    },
    blackHeartOnDeals = {
        str = {
            "%d%% chance to gain an additional black heart when spending hearts for items,",
            "such as devil deals"
        },
        category = "charTree", sort = 2353
    },
    evilTrinketLuck = {
        str = "%s%.2f luck while holding an evil trinket",
        addPlus = true,
        category = "charTree", sort = 2354
    },
    devilBeggarBlackHeart = {
        str = "%.2f%% chance for devil beggars to return half a black heart when helped",
        category = "charTree", sort = 2355
    },
    cardFloorDamage = {
        str = "%s%.2f damage when using a card, up to +3. Resets every floor",
        addPlus = true,
        category = "charTree", sort = 2356
    },
    cardFloorTears = {
        str = "%s%.2f tears when using a card, up to +3. Resets every floor",
        addPlus = true,
        category = "charTree", sort = 2356
    },

    ---- LAZARUS' TREE ----
    soulfulAwakening = {
        str = {
            "Soulful Awakening:",
            "    Spawn a soul heart on death",
            "    +2 luck",
            "    -0.5 luck on death"
        },
        category = "charTree", sort = 2400
    },
    kingCurse = {
        str = {
            "King's Curse:",
            "    Start with Damocles activated",
            "    When entering a new floor, remove Damocles if you have it, or re-add it if you don't",
            "    -10% all stats while not Lazarus Risen",
            "    -1 luck while not Lazarus Risen"
        },
        category = "charTree", sort = 2401
    },
    aTrueEnding = {
        str = {
            "A True Ending?:",
            "    First floor's boss, Mom and Mom's Heart drop a Suicide King card when defeated",
            "    +2%% all stats as Lazarus Risen per Suicide King card used"
        },
        category = "charTree", sort = 2402
    },
    lazarusDamage = {
        str = "%s%.2f damage. Halve this bonus as Lazarus Risen",
        addPlus = true,
        category = "charTree", sort = 2403
    },
    lazarusSpeed = {
        str = "%s%.2f speed. Halve this bonus as Lazarus Risen",
        addPlus = true,
        category = "charTree", sort = 2403
    },
    lazarusTears = {
        str = "%s%.2f tears. Halve this bonus as Lazarus Risen",
        addPlus = true,
        category = "charTree", sort = 2403
    },
    lazarusRange = {
        str = "%s%.2f range. Halve this bonus as Lazarus Risen",
        addPlus = true,
        category = "charTree", sort = 2403
    },
    lazarusLuck = {
        str = "%s%.2f luck. Halve this bonus as Lazarus Risen",
        addPlus = true,
        category = "charTree", sort = 2403
    },
    luckyAllStats = {
        str = "%s%.2f all stats while luck is positive",
        addPlus = true,
        category = "charTree", sort = 2404
    },
    momPlanC = {
        str = "%d%% chance for Mom to drop Plan C when defeated",
        category = "charTree", sort = 2405
    },
    lazarusClearHearts = {
        str = {
            "%.2f%% chance to drop an additional 1/2 red heart on room clear as Lazarus",
            "%.2f%% chance to drop an additional 1/2 soul heart on room clear as Lazarus Risen"
        },
        category = "charTree", sort = 2406
    },

    ---- EDEN'S TREE ----
    chaoticTreasury = {
        str = {
            "Chaotic Treasury:",
            "    First floor's treasure room contains an additional Chaos item pedestal",
            "    While you have Chaos, treasure rooms spawn an additional item",
            "    Grabbing an item in a treasure room removes all other items in the room"
        },
        category = "charTree", sort = 2450
    },
    sporadicGrowth = {
        str = {
            "Sporadic Growth:",
            "    When starting a run, apply +1%% to a random stat 6 times",
            "    When entering a floor past the first, apply +1%% to a random stat 2 times"
        },
        category = "charTree", sort = 2451
    },
    starblessed = {
        str = {
            "Starblessed:",
            "    Start with an additional random item from the treasure room pool",
            "    First floor's boss drops an additional XVII - The Stars card"
        },
        category = "charTree", sort = 2452
    },
    treasureShopItemStat = {
        str = "%s%.2f to a random stat when first obtaining a treasure room or shop item",
        addPlus = true,
        category = "charTree", sort = 2453
    },
    treasureShopItemStatPerc = {
        str = "%s%d%% to a random stat when first obtaining a treasure room or shop item",
        addPlus = true,
        category = "charTree", sort = 2453
    },
    devilAngelBossItemStat = {
        str = "%s%.2f to a random stat when first obtaining a devil, angel or boss room item",
        addPlus = true,
        category = "charTree", sort = 2454
    },
    devilAngelBossItemStatPerc = {
        str = "%s%d%% to a random stat when first obtaining a devil, angel or boss room item",
        addPlus = true,
        category = "charTree", sort = 2454
    },
    itemRandLuck = {
        str = "-%.2f to +%.2f luck when first obtaining any passive item",
        category = "charTree", sort = 2455
    },
    itemRandLuckPerc = {
        str = "-%d%% to +%d%% luck when first obtaining any passive item",
        category = "charTree", sort = 2455
    },
    trinketRandLuck = {
        str = "-%.2f to +%.2f luck when first obtaining any trinket",
        category = "charTree", sort = 2456
    },
    startCoinKeyBomb = {
        str = "%d%% chance to start with an additional coin, key or bomb",
        category = "charTree", sort = 2457
    },
    edenBlessingSpawn = {
        str = {
            "%d%% chance for Eden's Blessing to spawn at the beginning of a floor, starting",
            "from the second floor. Can only happen once per run"
        },
        category = "charTree", sort = 2458
    },

    ---- THE LOST'S TREE ----
    spectralAdvantage = {
        str = {
            "Spectral Advantage:",
            "    +2%% damage and +0.15 luck for each heart you would've gained from",
            "    items you pick up, up to a total 40%% damage, +3 luck",
            "    If you obtain Birthright, gain +8%% tears"
        },
        category = "charTree", sort = 2500
    },
    sacredAegis = {
        str = {
            "Sacred Aegis:",
            "    Holy mantle regenerates after 7 seconds, once per room",
            "    -7%% all stats each time you lose holy mantle, up to 2 times. Resets every room"
        },
        category = "charTree", sort = 2501
    },
    heartseekerPhantasm = {
        str = {
            "Heartseeker Phantasm:",
            "    Dropped red and eternal hearts are converted to soul hearts",
            "    Collecting a soul or black heart grants +0.2 luck",
            "    +1%% all stats for every 3 hearts collected"
        },
        category = "charTree", sort = 2502
    },
    killingHitNegation = {
        str = "%d%% chance to negate an incoming hit if it would've killed you",
        category = "charTree", sort = 2503
    },
    noHolyMantleAllStats = {
        str = "%s%.2f all stats while holy mantle is inactive",
        addPlus = true,
        category = "charTree", sort = 2504
    },
    soulHeartTears = {
        str = "Soul hearts grants %s%.2f tears when collected, up to a total +1",
        addPlus = true,
        category = "charTree", sort = 2505
    },
    blackHeartDamage = {
        str = "Black hearts grant %s%.2f damage when collected, up to a total +3",
        addPlus = true,
        category = "charTree", sort = 2505
    },
    eternalD6Charge = {
        str = "%d%% chance for the Eternal D6 to not consume charges on use",
        category = "charTree", sort = 2506
    },
    soulHeartOnClear = {
        str = "%d%% chance to drop an additional soul heart when clearing a room",
        category = "charTree", sort = 2507
    },

    ---- LILITH'S TREE ----
    minionManeuvering = {
        str = {
            "Minion Maneuvering:",
            "    +3%% speed per active familiar, up to 15%%",
            "    Using the box of friends doubles the maximum bonus for the current room"
        },
        category = "charTree", sort = 2550
    },
    heavyFriends = {
        str = {
            "Heavy Friends:",
            "    Start with BFFS!",
            "    -35% speed",
            "    -45% damage"
        },
        category = "charTree", sort = 2551
    },
    daemonArmy = {
        str = {
            "Daemon Army:",
            "    Start with an additional Incubus",
            "    Mom drops an additional Incubus on defeat if you took no damage throughout the run",
            "    until this point",
            "    Baby familiar items other than Incubus no longer show up"
        },
        category = "charTree", sort = 2552
    },
    familiarKillSoulHeart = {
        str = "%.2f%% chance for enemies killed by familiars to drop an additional 1/2 soul heart",
        category = "charTree", sort = 2553
    },
    activeFamiliarsLuck = {
        str = "%s%.2f luck per currently active familiar",
        addPlus = true,
        category = "charTree", sort = 2554
    },
    activeIncubusDamage = {
        str = "%s%.2f damage per active incubus",
        addPlus = true,
        category = "charTree", sort = 2555
    },
    activeIncubusTears = {
        str = "%s%.2f tears per active incubus",
        addPlus = true,
        category = "charTree", sort = 2555
    },
    boxOfFriendsCharge = {
        str = "%d%% chance for Box of Friends to keep 1 charge on use",
        category = "charTree", sort = 2556
    },
    boxOfFriendsAllStats = {
        str = "%s%.2f all stats after using Box of Friends. Resets every room",
        addPlus = true,
        category = "charTree", sort = 2556
    },

    ---- KEEPER'S TREE ----
    keeperBlessing = {
        str = {
            "Keeper's Blessing:",
            "    Healing from a coin grants you an additional coin, up to 4 times per room",
            "    20%% chance for Wooden Nickel to spawn an additional penny when used"
        },
        category = "charTree", sort = 2600
    },
    gulp = {
        str = {
            "Gulp!:",
            "    Spawn a Swallowed Penny at the start of every other floor, starting from the first",
            "    +1.5 luck while holding Swallowed Penny",
            "    30%% chance to lose the Swallowed Penny when hit, if held",
            "    Gain 1-4 coins when losing the Swallowed Penny this way"
        },
        category = "charTree", sort = 2601
    },
    avidShopper = {
        str = {
            "Avid Shopper:",
            "    Start with Steam Sale",
            "    Start with an additional 5 coins",
            "    Lose 1-3 coins when hit"
        },
        category = "charTree", sort = 2602
    },
    coinShield = {
        str = {
            "%d%% chance to negate a hit that would've killed you, if you have more than 0 coins",
            "Negating a hit removes all your coins and fully discharges your active item"
        },
        category = "charTree", sort = 2603
    },
    itemPurchaseLuck = {
        str = "%s%.2f luck when you purchase an item",
        addPlus = true,
        category = "charTree", sort = 2604
    },
    purchaseKeepCoins = {
        str = "%d%% chance to keep 1-3 coins when purchasing an item",
        category = "charTree", sort = 2604
    },
    firstBossGreed = {
        str = "%d%% chance for Greed to spawn after defeating the first floor's boss",
        category = "charTree", sort = 2605
    },
    greedLowerHealth = {
        str = "Greed has %d%% lower health",
        category = "charTree", sort = 2606
    },
    greedNickelDrop = {
        str = "%d%% chance for Greed to drop an additional nickel",
        category = "charTree", sort = 2607
    },
    greedDimeDrop = {
        str = "%d%% chance for Greed to drop an additional dime",
        category = "charTree", sort = 2607
    },
    blueFlyDeathDamage = {
        str = "%s%.2f damage whenever a blue fly dies, up to +1.2. Resets every floor",
        addPlus = true,
        category = "charTree", sort = 2608
    },

    ---- APOLLYON'S TREE ----
    apollyonBlessing = {
        str = {
            "Apollyon's Blessing:",
            "    40%% chance to keep half of the charge when using Void",
            "    Cannot be cursed with Curse of the Blind"
        },
        category = "charTree", sort = 2650
    },
    null = {
        str = {
            "Null:",
            "    When entering a floor, if Void hasn't absorbed any active items, gain +5%% all stats",
            "    up to 15%%",
            "    If Void has absorbed active items, 50%% chance to gain an extra charge when clearing a room",
            "    -10%% all stats while not holding Void"
        },
        category = "charTree", sort = 2651
    },
    harbingerLocusts = {
        str = {
            "Harbinger Locusts:",
            "    Spawn a random locust trinket in the second floor you enter",
            "    Spawn a random locust trinket after defeating Mom",
            "    2%% chance to replace any non-locust trinket drop with a random locust trinket",
            "    Defeating a boss increases this chance by 1%%, up to 10%%",
            "    Using void consumes all locust trinkets dropped in the room, applying their effects",
            "    to you passively"
        },
        category = "charTree", sort = 2652
    },
    voidBlueFlies = {
        str = "%d%% chance for Void to spawn 4 blue flies on use",
        category = "charTree", sort = 2653
    },
    voidBlueSpiders = {
        str = "%d%% chance for Void to spawn 3 blue spiders on use",
        category = "charTree", sort = 2653
    },
    voidAnnihilation = {
        str = "%d%% chance for Void to instantly kill a random non-boss enemy in the room on use",
        category = "charTree", sort = 2654
    },
    eraserSecondFloor = {
        str = "%d%% chance for the second floor's treasure room to additionally contain an Eraser",
        category = "charTree", sort = 2655
    },
    locustHeldLuck = {
        str = "%s%.2f luck while holding a locust",
        addPlus = true,
        category = "charTree", sort = 2656
    },
    locustConsumedLuck = {
        str = "%s%.2f luck per consumed locusts",
        addPlus = true,
        category = "charTree", sort = 2656
    },
    conquestLocustSpeed = {
        str = "%s%.2f%% speed per Locust of Conquest held/consumed, up to 15%%",
        addPlus = true,
        category = "charTree", sort = 2657
    },
    deathLocustTears = {
        str = "%s%.2f%% tears per Locust of Death held/consumed, up to 15%%",
        addPlus = true,
        category = "charTree", sort = 2657
    },
    famineLocustRangeShotspeed = {
        str = "%s%.2f%% range and shot speed per Locust of Famine held/consumed, up to 15%%",
        addPlus = true,
        category = "charTree", sort = 2657
    },
    pestilenceLocustLuck = {
        str = "%s%.2f%% luck per Locust of Pestilence held/consumed, up to 15%%",
        addPlus = true,
        category = "charTree", sort = 2657
    },
    warLocustDamage = {
        str = "%s%.2f%% damage per Locust of War held/consumed, up to 15%%",
        addPlus = true,
        category = "charTree", sort = 2657
    },

    ---- THE FORGOTTEN'S TREE ----
    soulful = {
        str = {
            "Soulful:",
            "    Losing a bone heart spawns a soul heart",
            "    -0.25 luck when you lose a bone heart"
        },
        category = "charTree", sort = 2700
    },
    spiritEbb = {
        str = {
            "Spirit Ebb and Flow:",
            "    Landing 6 hits as The Soul grants The Forgotten a 10%% damage and tears boost",
            "    Landing 6 hits as The Forgotten grants The Soul a 10%% damage and speed boost",
            "    Boosts are reset every room"
        },
        category = "charTree", sort = 2701
    },
    innerFlare = {
        str = {
            "Inner Flare:",
            "    The Soul deals 15%% more damage against slowed enemies",
            "    Switching to The Soul slows enemies in the room for 2 seconds. Can only happen once per room"
        },
        category = "charTree", sort = 2702
    },
    innerFlareSlowDuration = {
        str = "%s%.2f seconds to Inner Flare slow duration",
        addPlus = true,
        category = "charTree", sort = 2703
    },
    forgottenMeleeTearBuff = {
        str = {
            "Hitting enemies with The Forgotten's melee attack increases damage dealt by your tears by %.2f%%",
            "up to 20%%. Effect resets every room"
        },
        category = "charTree", sort = 2704
    },
    forgottenSoulDamage = {
        str = "%s%.2f damage with The Forgotten per remaining soul/black heart",
        addPlus = true,
        category = "charTree", sort = 2705
    },
    forgottenSoulTears = {
        str = "%s%.2f tears with The Forgotten per remaining soul/black heart",
        addPlus = true,
        category = "charTree", sort = 2705
    },
    theSoulBoneDamage = {
        str = "%s%.2f damage with The Soul per remaining bone heart",
        addPlus = true,
        category = "charTree", sort = 2706
    },
    theSoulBoneTears = {
        str = "%s%.2f tears with The Soul per remaining bone heart",
        addPlus = true,
        category = "charTree", sort = 2706
    },

    ---- BETHANY'S TREE ----
    willOTheWisp = {
        str = {
            "Will-o-the-Wisp:",
            "    Your wisps take 60%% reduced damage",
            "    +0.5 damage for the current room when a wisp is destroyed, up to +2.5"
        },
        category = "charTree", sort = 2750
    },
    soulTrickle = {
        str = {
            "Soul Trickle:",
            "    Collecting a soul or black heart heals 1/2 red heart",
            "    While you are full health, 30%% chance to convert red heart drops into soul hearts",
            "    Wisps have a 5%% chance to drop half a soul heart when damaged. This effect can",
            "    happen twice per room"
        },
        category = "charTree", sort = 2751
    },
    fatePendulum = {
        str = {
            "Fate Pendulum:",
            "    Start with Metronome",
            "    -50%% all stats while not holding Metronome"
        },
        category = "charTree", sort = 2752
    },
    activeItemWisp = {
        str = {
            "%.2f%% chance to generate an additional regular wisp when using an active item",
            "with 2 or more charges"
        },
        category = "charTree", sort = 2753
    },
    chargeOnClear = {
        str = "%.2f%% chance to gain an additional active item charge on room clear",
        category = "charTree", sort = 2754
    },
    soulChargeOnClear = {
        str = "%.2f%% chance to gain a Soul Charge on room clear",
        category = "charTree", sort = 2754
    },
    wispDestroyedLuck = {
        str = "%s%.2f luck when a wisp is destroyed, up to +4",
        addPlus = true,
        category = "charTree", sort = 2755
    },
    wispFloorBuff = {
        str = {
            "When entering a floor, %s%.2f%% all stats per wisp currently orbiting you, up",
            "to a total 15%%"
        },
        addPlus = true,
        category = "charTree", sort = 2756
    },
    redHeartsSoulCharge = {
        str = "%d%% chance to gain a Soul Charge when picking up a red heart",
        category = "charTree", sort = 2757
    },

    ---- JACOB & ESAU'S TREE ----
    heartLink = {
        str = {
            "Heart Link:",
            "    Red heart ups are applied to both brothers",
            "    -1%% damage, tears and range per 1/2 red heart difference for the brother with",
            "    the lower remaining red hearts"
        },
        category = "charTree", sort = 2800
    },
    statuePilgrimage = {
        str = {
            "Statue Pilgrimage:",
            "    Esau starts with Gnawed Leaf",
            "    Esau doesn't shoot while transformed",
            "    Enemies target Jacob instead while Esau is transformed",
            "    Jacob gains +12%% all stats while close to transformed Esau"
        },
        category = "charTree", sort = 2801
    },
    coordination = {
        str = {
            "Coordination:",
            "    Landing 5 hits as Jacob grants Esau +10%% tears",
            "    Landing 5 hits as Esau grants Jacob +10%% damage",
            "    Effect resets every room"
        },
        category = "charTree", sort = 2802
    },
    brotherHitNegation = {
        str = {
            "%d%% chance to negate a killing hit if the opposing brother has more than 1 red heart remaining",
            "    When this happens, set the opposing brother's remaining red hearts to 1"
        },
        category = "charTree", sort = 2803
    },
    jacobHeartLuck = {
        str = {
            "%s%.2f luck per 1/2 heart of any type with the brother that has the lower remaining hearts",
            "    Bonus is given to both brothers"
        },
        addPlus = true,
        category = "charTree", sort = 2804
    },
    jacobBirthright = {
        str = {
            "%.2f%% chance for Mom to additionally drop Birthright when defeated",
            "If Mom doesn't drop Birthright, roll for half the chance again when defeating Mom's Heart"
        },
        category = "charTree", sort = 2805
    },
    jacobHeartOnKill = {
        str = "%.2f%% chance for enemies killed by Jacob to drop an additional 1/2 red heart, once per room",
        category = "charTree", sort = 2806
    },
    esauSoulOnKill = {
        str = "%.2f%% chance for enemies killed by Esau to drop an additional 1/2 soul heart, once per room",
        category = "charTree", sort = 2806
    },
    jacobItemAllstats = {
        str = "%s%.2f%% all stats per item obtained by the opposing brother, up to 15%%",
        addPlus = true,
        category = "charTree", sort = 2807
    },

    ---- SIREN'S TREE ----
    darkSongstress = {
        str = {
            "Dark Songstress:",
            "    Non-charmed enemies receive 8%% less damage",
            "    Killing a charmed enemy has an 8%% chance to grant 1 charge to Siren's Song",
            "    Using Siren's Song removes this effect and grants +8%% damage and speed for the current room"
        },
        category = "charTree", sort = 2850
    },
    songOfDarkness = {
        str = {
            "Song of Darkness:",
            "    2%% chance to drop an additional black heart when clearing a room",
            "    [Harmonic] Charmed enemies you kill increase this chance by 0.4%%, up to 6%%",
            "    [Harmonic] +0.1 damage per 1/2 black heart remaining"
        },
        category = "charTree", sort = 2851
    },
    songOfFortune = {
        str = {
            "Song of Fortune:",
            "    +1 luck",
            "    [Harmonic] Using Siren's Song has a 15%% chance to grant +0.05 luck",
            "    [Harmonic] When below 4 luck, 50%% chance for charmed enemies to grant an additional 0.01 luck on kill",
            "    [Harmonic] When above 4 luck, 25%% chance for charmed enemies to grant no luck on kill",
        },
        category = "charTree", sort = 2851
    },
    songOfCelerity = {
        str = {
            "Song of Celerity:",
            "    +7%% tears",
            "    [Harmonic] +7%% speed",
            "    [Harmonic] +1%% tears when hitting a charmed enemy, up to 15%%. Effect resets every room"
        },
        category = "charTree", sort = 2851
    },
    songOfAwe = {
        str = {
            "Song of Awe:",
            "    +4%% all stats when using Siren's Song, once per room. Effect resets every room",
            "    [Harmonic] Siren's Song additionally slows enemies by 90%% for 2 seconds on use",
            "    [Harmonic] Siren's Song gains an additional charge when clearing a room"
        },
        category = "charTree", sort = 2851
    },
    overwhelmingSong = {
        str = {
            "Overwhelming Song:",
            "    Siren's Song turns friendly monsters back into hostile enemies on use",
            "    +5%% damage for the current room per monster turned this way, up to 20%%",
            "    Siren's Song deals 6 damage to charmed monsters, which increases each floor"
        },
        category = "charTree", sort = 2852
    },
    luckOnCharmedKill = {
        str = "%.2f%% chance for charmed enemies to grant an additional 0.01 luck on kill",
        category = "charTree", sort = 2855
    },
    mightOfFortune = {
        str = "%s%.2f%% all stats except luck for every 1 luck you have",
        addPlus = true,
        category = "charTree", sort = 2856
    },
    charmedRetaliation = {
        str = "When a charmed enemy hits you, return %.2f damage",
        category = "charTree", sort = 2857
    },
    charmedHitNegation = {
        str = {
            "%d%% chance to negate a killing hit from a charmed enemy",
            "    This can only happen once per room"
        },
        category = "charTree", sort = 2858
    },
    charmExplosions = {
        str = {
            "%.2f%% chance for charmed enemies to explode in a cloud of pheromones on death",
            "dealing 4 damage and charming nearby enemies"
        },
        category = "charTree", sort = 2859
    },
    --#endregion

    --#region TAINTED CHARACTER TREES --
    ---- T. ISAAC'S TREE ----
    vacuophobia = {
        str = {
            "Vacuophobia:",
            "    Begin the game with Birthright",
            "    -1%% all stats per missing item in your inventory",
            "    -4%% all stats while you're not holding a trinket",
            "    -4%% all stats while you're not holding an active item",
            "    -4%% all stats while your pocket slots are empty"
        },
        category = "charTree", sort = 3000
    },
    consumingVoid = {
        str = {
            "Consuming Void:",
            "    Once you fill your inventory, spawn a Void item pedestal",
            "    When entering a floor, if your inventory is full and you haven't consumed at least 2 items with Void",
            "    in the previous floor, lose a random item and Void",
            "    During the Ascent, lose no items from this effect"
        },
        category = "charTree", sort = 3001
    },
    fracturedRemains = {
        str = {
            "Fractured Remains:",
            "    Start the game with a Dice Shard",
            "    Clearing a regular room without taking damage has a 3%% chance of spawning a Dice Shard",
            "    Clearing a regular room without taking damage has a 7%% chance of spawning a Rune Shard",
            "    Clearing a boss room without taking damage has a 75%% chance of spawning a Dice Shard",
            "    Clearing a boss room without taking damage spawns two Rune Shards"
        },
        category = "charTree", sort = 3002
    },
    sinistralRunemaster = {
        str = {
            "Sinistral Runemaster:",
            "    Improve rune effects:",
            "    - Hagalaz: additionally trigger Dad's Key's effect",
            "    - Jera: duplicated pickups have an 8%% chance of becoming a special version",
            "    - Ehwaz: +3%% all stats for the next floor if you step into a trapdoor in the current room",
            "    - Dagaz: +3%% all stats for the current floor per cleansed curse",
            "    These effects only have a 75%% chance to trigger if you have Dextral Runemaster allocated"
        },
        category = "charTree", sort = 3003
    },
    dextralRunemaster = {
        str = {
            "Dextral Runemaster:",
            "    Improve rune effects:",
            "    - Ansuz: on use, +15%% chance to trigger a map reveal on the next floor",
            "    - Perthro: a random item pedestal gains an additional item choice from the treasure room pool",
            "    - Berkano: gain Hive Mind innately for the current floor. If you already have it, spawn",
            "    twice as many spiders and flies",
            "    - Algiz: +7%% damage and tears for 20 seconds",
            "    - Blank rune: additionally trigger a Rune Shard's effect",
            "    These effects only have a 75%% chance to trigger if you have Sinistral Runemaster allocated"
        },
        category = "charTree", sort = 3004
    },
    blackRuneAbsorb = {
        str = "%d%% chance for items consumed with Black Runes to be obtained as innate items",
        category = "charTree", sort = 3005
    },
    trinketOnClear = {
        str = "%.2f%% chance to drop a random trinket on room clear while you're not holding one",
        category = "charTree", sort = 3006
    },
    obtainedItemDamage = {
        str = "%s%.2f%% damage per obtained item",
        addPlus = true,
        category = "charTree", sort = 3010
    },
    obtainedItemTears = {
        str = "%s%.2f%% tears per obtained item",
        addPlus = true,
        category = "charTree", sort = 3011
    },
    obtainedItemRange = {
        str = "%s%.2f%% range per obtained item",
        addPlus = true,
        category = "charTree", sort = 3012
    },
    flawlessBossLuck = {
        str = "%s%.2f luck when clearing a boss room without taking damage",
        addPlus = true,
        category = "charTree", sort = 3013
    },
    voidConsumeLuck = {
        str = "%s%.2f luck when consuming an item with Void",
        addPlus = true,
        category = "charTree", sort = 3014
    },
    diceShardRuneShard = {
        str = "%d%% chance to spawn a Rune Shard when using a Dice Shard",
        category = "charTree", sort = 3015
    },
    runicSpeed = {
        str = "%s%.2f%% speed when using a Rune or Rune Shard, up to 22%%. Resets every floor",
        addPlus = true,
        category = "charTree", sort = 3016
    },
    runeshardStacking = {
        str = "You can now stack rune shards. Stacks can be accumulated while holding any rune or rune shard",
        category = "charTree", sort = 3017
    },
    runeshardStacksReq = {
        str = "Reaching %d rune shard stacks drops a random rune",
        category = "charTree", sort = 3018
    },
    ---- T. MAGDALENE'S TREE ----
    taintedHealth = {
        str = {
            "Tainted Health:",
            "    +0.1 damage per 1/2 remaining red heart above 2 hearts",
            "    +3%% tears per 1/2 remaining soul heart",
            "    -15%% speed while you have 3 or less remaining red hearts"
        },
        category = "charTree", sort = 3050
    },
    testOfTemperance = {
        str = {
            "Test of Temperance:",
            "    5%% chance to drop a 1/2 red heart pickup when hitting a boss, which vanishes after 2 seconds",
            "    This effect has a 0.5 second cooldown once triggered",
            "    If you have more than 2 remaining red hearts, receive an additional 1/2 heart damage when",
            "    hit in boss rooms"
        },
        category = "charTree", sort = 3051
    },
    bloodful = {
        str = {
            "Bloodful:",
            "    Start with Blood Oath.",
            "    +1%% all stats per red heart collected in the current room, up to +10%%",
            "    -5%% all stats while you haven't collected any red hearts in the current room"
        },
        category = "charTree", sort = 3052
    },
    lingeringMalice = {
        str = {
            "Lingering Malice:",
            "    Start with a smelted Lost Cork",
            "    Creep left by you can damage flying enemies"
        },
        category = "charTree", sort = 3053
    },
    creepDamage = {
        str = "%s%d%% damage dealt by creep",
        addPlus = true,
        category = "charTree", sort = 3055
    },
    remainingHeartsSpeed = {
        str = "%s%.2f speed per 1/2 remaining red heart past 2",
        addPlus = true,
        category = "charTree", sort = 3056
    },
    remainingHeartsDmg = {
        str = "%s%.2f damage per 1/2 remaining red heart past 2",
        addPlus = true,
        category = "charTree", sort = 3056
    },
    remainingHeartsTears = {
        str = "%s%.2f tears per 1/2 remaining red heart past 2",
        addPlus = true,
        category = "charTree", sort = 3056
    },
    temporaryHeartTime = {
        str = "%s%.2f seconds to temporary red heart pickups before they vanish",
        addPlus = true,
        category = "charTree", sort = 3057
    },
    temporaryHeartDmg = {
        str = {
            "%s%.2f%% damage for 2 seconds after picking up a temporary red heart",
            "    Modifiers that increase temporary heart duration also affect this buff's time"
        },
        addPlus = true,
        category = "charTree", sort = 3058
    },
    temporaryHeartTears = {
        str = {
            "%s%.2f%% tears for 2 seconds after picking up a temporary red heart",
            "    Modifiers that increase temporary heart duration also affect this buff's time"
        },
        addPlus = true,
        category = "charTree", sort = 3058
    },
    temporaryHeartLuck = {
        str = {
            "40%% chance to gain %.2f luck when picking up a temporary red heart while its",
            "lifetime has 1.8 seconds or more remaining",
            "    Total luck bonus from this effect gets halved when entering a new floor"
        },
        category = "charTree", sort = 3059
    },
    halfHeartPickupToFull = {
        str = "%.2f%% chance to convert dropped 1/2 red heart pickups into full red hearts",
        category = "charTree", sort = 3060
    },
    bloodDonoTempHeart = {
        str = {
            "2%% chance to drop a 1/2 red heart when using a Blood Donation Machine, which",
            "vanishes after 2 seconds"
        },
        category = "charTree", sort = 3061
    },
    ---- T. CAIN'S TREE ----
    ransacking = {
        str = {
            "Ransacking:",
            "    Bag of Crafting's melee attack gains an additional 25%% of your damage",
            "    Killing an enemy with Bag of Crafting's melee attack has a 10%% chance to spawn a",
            "    coin/key/bomb/half heart, up to 5 per room",
            "    +0.02 luck when killing an enemy with Bag of Crafting's melee attack"
        },
        category = "charTree", sort = 3100
    },
    magicBag = {
        str = {
            "Magic Bag:",
            "    When crafting an item, additionally drop one of the pickups used to craft it",
            "    +0.5%% all stats per pickup in the crafting bag"
        },
        category = "charTree", sort = 3101
    },
    opportunist = {
        str = {
            "Opportunist:",
            "    When grabbing a pickup with the Bag of Crafting, trigger an effect based on the pickup:",
            "    - Red hearts: 30%% chance to heal 1/2 red heart",
            "    - Soul/black hearts: 15%% chance to add 1/2 of the grabbed heart",
            "    - Coins/keys/bombs: 15%% chance to grant the grabbed pickup as if collected normally",
            "    - Batteries: 15%% chance to add 2 charges to your active items",
            "    - Runes: triggers Rune Shard's effect",
            "    - Cards: permanent +0.5%% luck"
        },
        category = "charTree", sort = 3102
    },
    grandIngredientCoins = {
        str = {
            "Grand Ingredient: Coins",
            "    If the first pickup in the bag is a coin, gain an effect based on its type:",
            "    - Penny: +3%% luck and range",
            "    - Lucky Penny: +7%% luck",
            "    - Nickel: gain 5 coins when crafting an item",
            "    - Dime: gain 10 coins when crafting an item",
            "    - Golden: +7%% all stats",
            "    Having more than 2 Grand Ingredient nodes allocated nullifies these effects"
        },
        category = "charTree", sort = 3103
    },
    grandIngredientKeys = {
        str = {
            "Grand Ingredient: Keys",
            "    If the first pickup in the bag is a key, gain an effect based on its type:",
            "    - Normal: +3%% tears",
            "    - Golden: grants you 4 keys and triggers Dad's Key's effect when crafting an item",
            "    - Charged: grants an additional charge to your active items when clearing a room",
            "    Having more than 2 Grand Ingredient nodes allocated nullifies these effects"
        },
        category = "charTree", sort = 3104
    },
    grandIngredientBombs = {
        str = {
            "Grand Ingredient: Bombs",
            "    If the first pickup in the bag is a bomb, gain an effect based on its type:",
            "    - Normal: +5%% damage",
            "    - Golden: permanent +10%% damage when crafting an item",
            "    - Giga: +30%% damage",
            "    Having more than 2 Grand Ingredient nodes allocated nullifies these effects"
        },
        category = "charTree", sort = 3105
    },
    grandIngredientHearts = {
        str = {
            "Grand Ingredient: Hearts",
            "    If the first pickup in the bag is a heart, gain an effect based on its type:",
            "    - Red: heal 1 red heart when crafting an item",
            "    - Soul: gain a soul heart when crafting an item",
            "    - Black: gain a black heart when crafting an item",
            "    - Eternal: fully heals you when crafting an item",
            "    - Golden: gain 7 coins when crafting an item",
            "    - Bone: gain an empty bone heart when crafting an item",
            "    - Rotten: spawn 2-4 blue spiders and 2-4 blue flies when crafting an item",
            "    Having more than 2 Grand Ingredient nodes allocated nullifies these effects"
        },
        category = "charTree", sort = 3106
    },
    craftBagMeleeDmgInherit = {
        str = "Bag of Crafting's melee attack gains an additional %d%% of your damage",
        category = "charTree", sort = 3107
    },
    craftPickupRecovery = {
        str = "%d%% chance to spawn one of the consumed pickups when crafting an item",
        category = "charTree", sort = 3110
    },
    randPickupOnClear = {
        str = "%d%% chance to spawn an additional coin/key/bomb/half heart when completing a room",
        category = "charTree", sort = 3111
    },
    droppedSpecialPickups = {
        str = {
            "%.2f%% chance for dropped pickups to be a special variant, such as golden/charged keys,",
            "golden bombs, etc"
        },
        category = "charTree", sort = 3112
    },
    itemCraftingLuck = {
        str = "%s%.2f luck when crafting an item",
        addPlus = true,
        category = "charTree", sort = 3113
    },
    bagBombDamage = {
        str = "%s%.2f%% damage per bomb pickup in the crafting bag",
        addPlus = true,
        category = "charTree", sort = 3114
    },
    bagKeyTears = {
        str = "%s%.2f%% tears per key pickup in the crafting bag",
        addPlus = true,
        category = "charTree", sort = 3114
    },
    bagCoinRangeLuck = {
        str = "%s%.2f%% range and luck per coin pickup in the crafting bag",
        addPlus = true,
        category = "charTree", sort = 3114
    },
    bagHeartSpeed = {
        str = "%s%.2f%% speed per heart pickup in the crafting bag",
        addPlus = true,
        category = "charTree", sort = 3114
    },
    additionalPedestalPickup = {
        str = {
            "%d%% chance to spawn an additional coin/key/bomb/half heart pickup when collecting an",
            "item pedestal.",
            "    Rolls multiple times if above 100%% chance"
        },
        category = "charTree", sort = 3115
    },
    ---- T. JUDAS' TREE ----
    darkExpertise = {
        str = {
            "Dark Expertise:",
            "    Trigger How To Jump's effect when using Dark Arts",
            "    +4 seconds to Dark Arts' cooldown",
            "    Reduce Dark Arts' cooldown by 0.5 seconds per non-boss enemy hit with it",
            "    Reduce Dark Arts' cooldown by 2 seconds if it hits a boss"
        },
        category = "charTree", sort = 3150
    },
    stealthTactics = {
        str = {
            "Stealth Tactics:",
            "    Start with 9 Volt",
            "    Speed cannot exceed 1.2 while Dark Arts is active",
            "    -60%% damage with sources that aren't Dark Arts"
        },
        category = "charTree", sort = 3151
    },
    lightlessBounty = {
        str = {
            "Bounty For The Lightless:",
            "    Killing an enemy with Dark Arts has a 15%% chance of granting half a black heart if",
            "    you have less than 4 black hearts",
            "    Killing an enemy with Dark Arts grants +0.03 luck, up to +1 per floor"
        },
        category = "charTree", sort = 3152
    },
    annihilation = {
        str = {
            "Annihilation:",
            "    The first time you hit a boss enemy with Dark Arts, deal an additional 40 damage or",
            "    10%% of its HP as damage, whichever is highest",
            "    Effect can only happen twice per room if multiple bosses are present",
            "    25%% chance to take an additional 1/2 heart damage from bosses if you have 3 or",
            "    more black hearts"
        },
        category = "charTree", sort = 3153
    },
    anarchy = {
        str = {
            "Anarchy:",
            "    Enemies hit by Dark Arts have a 25%% chance to spawn a troll bomb, up to thrice per room",
            "    Enemies take 75%% reduced damage from troll bombs",
            "    Enemies killed by bombs reduce Dark Arts' cooldown by 0.5 seconds"
        },
        category = "charTree", sort = 3154
    },
    howToJumpPulse = {
        str = {
            "%d%% chance to trigger a dark pulse when landing with How to Jump, dealing 150%% of your",
            "damage to nearby enemies"
        },
        category = "charTree", sort = 3160
    },
    darkArtsCDReset = {
        str = "%d%% chance to reset Dark Arts' cooldown when a monster hits you",
        category = "charTree", sort = 3161
    },
    darkArtsDmg = {
        str = "%s%d%% Dark Arts damage",
        addPlus = true,
        category = "charTree", sort = 3162
    },
    darkArtsCD = {
        str = "%s%.2f seconds to Dark Arts' cooldown",
        addPlus = true,
        category = "charTree", sort = 3163
    },
    darkArtsTears = {
        str = "%s%d%% tears for 2.5 seconds after using Dark Arts",
        addPlus = true,
        category = "charTree", sort = 3164
    },
    nonDarkArtsDmg = {
        str = "%s%d%% damage with sources that aren't Dark Arts",
        addPlus = true,
        category = "charTree", sort = 3165
    },
    darkArtsKillStat = {
        str = {
            "For every 10th enemy killed with Dark Arts, gain %s%.2f%% to a random stat",
            "    Resets every floor"
        },
        addPlus = true,
        category = "charTree", sort = 3166
    },
    trollBombProtection = {
        str = "%d%% chance for troll bombs to deal no damage to you",
        category = "charTree", sort = 3167
    },
    trollBombKillLuck = {
        str = "%s%.2f luck whenever a troll bomb kills an enemy",
        addPlus = true,
        category = "charTree", sort = 3168
    },
    ---- T. BLUE BABY'S TREE ----
    alacritousPurpose = {
        str = {
            "Alacritous Purpose:",
            "    +0.04 tears when destroying poop, up to +0.5. Resets every floor",
            "    +0.04 luck when destroying poop, up to +2. Resets every floor",
            "    The first poop you destroy per room spawns 3 blue flies, if you have less than 15",
            "    active blue flies"
        },
        category = "charTree", sort = 3200
    },
    treasuredWaste = {
        str = {
            "Treasured Waste:",
            "    Your currently held poop grants a buff based on its type:",
            "    - Normal: +0.02 all stats",
            "    - Corn: +2%% all stats",
            "    - Flaming: hitting enemies has a 5%% chance of applying burning",
            "    - Stinky: hitting enemies has a 5%% chance of poisoning",
            "    - Black: hitting enemies has a 5%% chance of confusing",
            "    - White: +8%% damage and tears",
            "    - Stone: 8%% chance to receive no damage when hit",
            "    - Fart: 40%% chance to trigger Butter Bean's effect when hit",
            "    - Liquid: +6%% speed"
        },
        category = "charTree", sort = 3201
    },
    asceticSoul = {
        str = {
            "Ascetic Soul:",
            "    While you have 8 or more poop bombs, killing an enemy has a 7%% chance of dropping",
            "    a 1/2 soul heart, up to 5 per floor"
        },
        category = "charTree", sort = 3202
    },
    slothLegacy = {
        str = {
            "Sloth's Legacy:",
            "    Start with Bob's Rotten Head",
            "    Hitting a boss with Bob's Rotten Head spawns 3 friendly chargers, once per floor",
            "    Bob's Rotten Head deals 60%% less damage"
        },
        category = "charTree", sort = 3203
    },
    holdPoopRegain = {
        str = "%d%% chance to regain the used poop when using Hold",
        category = "charTree", sort = 3210
    },
    holdEmptySpeed = {
        str = "%s%.2f%% speed while Hold is empty",
        addPlus = true,
        category = "charTree", sort = 3211
    },
    holdFullLuck = {
        str = "%s%.2f%% luck while Hold is not empty",
        addPlus = true,
        category = "charTree", sort = 3212
    },
    poopDamageBuff = {
        str = "Gain %s%.2f%% damage for 2 seconds after destroying room poops",
        addPlus = true,
        category = "charTree", sort = 3213
    },
    poopTransmutation = {
        str = {
            "%.2f%% chance to transmute a random poop in your bar to a different version when obtaining",
            "a poop pickup, using the following order:",
            "    Poop -> Fart -> Bomb -> Corn -> Stone -> Flaming -> Stinky -> Explosive Diarrhea ->",
            "    Liquid -> Black -> White"
        },
        category = "charTree", sort = 3214
    },
    poopPickupEnlarge = {
        str = "%d%% chance to turn small poop pickups into large poops",
        category = "charTree", sort = 3215
    },
    bobHeadFlySpawn = {
        str = "%d%% chance for Bob's Rotten Head to spawn a blue fly per enemy hit, up to 8 per room",
        category = "charTree", sort = 3216
    },
    holdBrownNugget = {
        str = "%d%% chance to trigger Brown Nugget item's effect when emptying Hold, up to 5 times per room",
        category = "charTree", sort = 3217
    },
    specialPoopFind = {
        str = {
            "%.2f%% chance for poops found in rooms to be replaced with special variants",
            "    Can affect up to 4 poops per room"
        },
        category = "charTree", sort = 3218
    },
    rainbowPoopLuck = {
        str = {
            "%s%.2f%% luck when destroying a rainbow poop, up to +35%%",
            "    Luck buff gets halved when entering a new floor",
        },
        addPlus = true,
        category = "charTree", sort = 3219
    },
    rainbowPoopSoul = {
        str = "%d%% chance to gain a soul heart when destroying a rainbow poop",
        category = "charTree", sort = 3220
    },
    --#endregion

    ---- STARMIGHT ----
    SC_SMMightyChance = {
        str = "%2.f%% chance for found Starcursed Jewels to be Mighty",
        category = "extra", sort = 5000
    },
    SC_SMAncientChance = {
        str = "%.2f%% additional chance to find Ancient Starcursed Jewels",
        category = "extra", sort = 5001
    }
}

function PST:parseModifierLines(modName, modVal)
    local mod = PST.treeModDescriptions[modName]
    if not mod then return {} end

    local parsedLines = {}
    local modStr = mod.str
    if type(modStr) == "table" then
        for _, tmpLine in ipairs(modStr) do
            local tmpStr = ""
            if PST.treeModDescriptions[modName].addPlus then
                tmpStr = string.format(tmpLine, modVal >= 0 and "+" or "", modVal)
            else
                tmpStr = string.format(tmpLine, modVal, modVal, modVal)
            end
            table.insert(parsedLines, tmpStr)
        end
    else
        local tmpStr = ""
        if PST.treeModDescriptions[modName].addPlus then
            tmpStr = string.format(modStr, modVal >= 0 and "+" or "", modVal)
        else
            tmpStr = string.format(modStr, modVal, modVal, modVal)
        end
        table.insert(parsedLines, tmpStr)
    end
    return parsedLines
end