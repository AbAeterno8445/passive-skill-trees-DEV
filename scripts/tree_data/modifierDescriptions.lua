PST.treeModDescriptionCategories = {
    stats = { name = "Global stat alterations:", color = KColor(0.9, 1, 0.9, 1) },
    condStats = { name = "Conditional stat alterations:", color = KColor(0.8, 1, 0.8, 1) },
    xp = { name = "XP and respecs:", color = KColor(0.9, 0.9, 0.9, 1) },
    extra = { name = "Miscellaneous:", color = KColor(0.9, 0.9, 0.7, 1) },
    charTree = { name = "", color = KColor(1, 0.8, 1, 1) }
}

PST.treeModDescriptions = {
    ---- STATS CATEGORY ----
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

    ---- CONDITIONAL STATS CATEGORY ----
    beggarLuck = {
        str = "%.2f luck gained when helping any beggar",
        category = "condStats", sort = 10
    },
    cardFloorLuck = {
        str = "%d%% increased luck for the current floor when you use a card",
        category = "condStats", sort = 11
    },
    pillFloorLuck = {
        str = "%d%% increased luck for the current floor when you use a pill",
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

    ---- XP CATEGORY ----
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
    quickWit = {
        str = {
            "Gain more xp for the first 8 seconds of a room. Afterwards, this bonus",
            "gradually decreases for the following 10 seconds"
        },
        category = "xp", sort = 104
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

    ---- EXTRA CATEGORY ----
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
            "    Spawn a crane game in treasure rooms. These can grant any unlocked item, but cost 8 coins to use",
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
            "    When this happens, halve this chance and receive -0.1 luck"
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
            "    -5%% all stats while not Lazarus Risen"
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
            "    Start with BFFS!"
        },
        category = "charTree", sort = 2551
    },
    daemonArmy = {
        str = {
            "Daemon Army:",
            "    Start with an additional Incubus",
            "    Mom drops an additional Incubus on defeat",
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
            "    Healing from a coin grants you an additional 2 coins, up to 4 times per room",
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
            "    Jacob gains +7%% all stats while close to transformed Esau"
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
        category = "charTree", sort = 2852
    },
    songOfCelerity = {
        str = {
            "Song of Celerity:",
            "    +7%% tears",
            "    [Harmonic] +7%% speed",
            "    [Harmonic] +1%% tears when hitting a charmed enemy, up to 15%%. Effect resets every room"
        },
        category = "charTree", sort = 2853
    },
    songOfAwe = {
        str = {
            "Song of Awe:",
            "    +4%% all stats when using Siren's Song, once per room. Effect resets every room",
            "    [Harmonic] Siren's Song additionally slows enemies by 90%% for 2 seconds on use",
            "    [Harmonic] Siren's Song gains an additional charge when clearing a room"
        },
        category = "charTree", sort = 2854
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
    
    ---- STARMIGHT ----
    SC_SMMightyChance = {
        str = "%2.f%% chance for found Starcursed Jewels to be mighty",
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