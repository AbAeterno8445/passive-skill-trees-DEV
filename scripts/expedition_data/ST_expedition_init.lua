---@type PSTExpedition[]
PST.expeditionsData = {}
PST.expedMinLevel = 70

PST.expedObolDropValues = {2, 5, 10, 25, 50, 100, 500, 1000}

---@enum PSTExpNodeRewardType
PSTExpNodeRewardType = {
    NONE = 0,
    EXP = 1,
    OBOLS = 2,
    ITEM = 3,
    ATTEMPTS = 4,
    BOON = 5
}

---@enum PSTExpNodeType
PSTExpNodeType = {
    NORMAL = 0,
    CURSED = 1,
    FINAL = 2,
    BOONUPGRADE = 3,
    ASTROLABE = 4,
    COMPLETED = 6
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
---@field implicits? table
---@field startAttempts number
---@field attempts number
---@field boons number[]
---@field upgradedBoons number[]
---@field boonUpgradePoints number
---@field curses number[]
---@field items CollectibleType[]

-- Expedition save class (expedition data that gets stored in savefile)
---@class PSTExpeditionSave
---@field seed integer
---@field selNode? PSTSelectedExpNode|nil
---@field compNodes? number[]
---@field deadNodes? number[]
---@field noRwNodes? number[]
---@field upgBoons? number[]
---@field upgBoonPts? number
---@field usedAttempts? number
---@field modifiers? table

-- List of available expedition boons
PST.expeditionBoons = {
    {
        name = "Wellbeing",
        description = "+{{allstatsPerc}}% all stats.",
        spriteFrame = 0,
        mods = { allstatsPerc = 7 },
        upgradedMods = { allstatsPerc = 12 }
    },
    {
        name = "Damage",
        description = "+{{damagePerc}}% damage.",
        spriteFrame = 1,
        mods = { damagePerc = 10 },
        upgradedMods = { damagePerc = 16 }
    },
    {
        name = "Speed",
        description = "+{{speedPerc}}% speed.",
        spriteFrame = 2,
        mods = { speedPerc = 10 },
        upgradedMods = { speedPerc = 16 }
    },
    {
        name = "Tears",
        description = "+{{tearsPerc}}% tears.",
        spriteFrame = 3,
        mods = { tearsPerc = 10 },
        upgradedMods = { tearsPerc = 16 }
    },
    {
        name = "Range",
        description = "+{{rangePerc}}% range.",
        spriteFrame = 4,
        mods = { rangePerc = 10 },
        upgradedMods = { rangePerc = 16 }
    },
    {
        name = "Luck",
        description = "+{{luckPerc}}% luck.",
        spriteFrame = 5,
        mods = { luckPerc = 10 },
        upgradedMods = { luckPerc = 16 }
    },
    {
        name = "Abundant Obols",
        description = "Obols are twice as likely to drop within runs. +{{boonAbundantObols}}% dropped obols.",
        spriteFrame = 6,
        mods = { boonAbundantObols = 20 },
        upgradedMods = { boonAbundantObols = 50 }
    },
    {
        name = "Intangibility",
        description = "When taking damage, {{boonIntangibility}}% chance for the invincibility frames to last 3x as long.",
        spriteFrame = 7,
        mods = { boonIntangibility = 50 },
        upgradedMods = { boonIntangibility = 80 }
    },
    {
        name = "Mercy",
        description = {
            "When hitting monsters and bosses affected by any status effect, {{boonMercyChance}}% chance to execute them if",
            "their HP is below {{boonMercyHP}}%."
        },
        spriteFrame = 8,
        mods = { boonMercyChance = 12, boonMercyHP = 15 },
        upgradedMods = { boonMercyChance = 20, boonMercyHP = 20 }
    },
    {
        name = "the Aegis",
        description = "Block the first {{boonAegis}} hits you receive every floor.",
        spriteFrame = 9,
        mods = { boonAegis = 2 },
        upgradedMods = { boonAegis = 3 }
    },
    {
        name = "Generosity",
        description = "The first item you purchase in the run is free, including devil deals.",
        upgradedDescription = "The first {{boonGenerosity}} items you purchase in the run are free, including devil deals.",
        spriteFrame = 10,
        mods = { boonGenerosity = 1 },
        upgradedMods = { boonGenerosity = 2 }
    },
    {
        name = "Protection",
        description = "Gain a Holy Mantle shield every 2 floors. +10% speed while holy mantle is active.",
        upgradedDescription = "Gain a Holy Mantle shield every floor. +15% speed while holy mantle is active.",
        spriteFrame = 11,
        mods = { boonProtection = 1 },
        upgradedMods = { boonProtection = 2 }
    },
    {
        name = "Lethargy",
        description = {
            "{{boonLethargyChance}}% chance to slow enemies for {{boonLethargyLen}} seconds on hit.",
            "Your minimum speed is now {{boonLethargyMinSpd}}."
        },
        spriteFrame = 12,
        mods = { boonLethargyChance = 7, boonLethargyLen = 2, boonLethargyMinSpd = 0.8 },
        upgradedMods = { boonLethargyChance = 12, boonLethargyLen = 3, boonLethargyMinSpd = 1 },
    },
    {
        name = "Horror",
        description = {
            "{{boonHorrorChance}}% chance to fear enemies for {{boonHorrorLen}} seconds on hit.",
            "Feared enemies receive {{boonHorrorDmg}}% more damage."
        },
        spriteFrame = 13,
        mods = { boonHorrorChance = 7, boonHorrorLen = 3, boonHorrorDmg = 10 },
        upgradedMods = { boonHorrorChance = 12, boonHorrorLen = 4, boonHorrorDmg = 10 }
    },
    {
        name = "Hypnosis",
        description = {
            "{{boonHypnoChance}}% chance to charm enemies for {{boonHypnoLen}} seconds on hit.",
            "Charmed enemies receive {{boonHypnoDmg}}% more damage."
        },
        spriteFrame = 14,
        mods = { boonHypnoChance = 7, boonHypnoLen = 3, boonHypnoDmg = 10 },
        upgradedMods = { boonHypnoChance = 12, boonHypnoLen = 4, boonHypnoDmg = 10 }
    },
    {
        name = "Paralysis",
        description = {
            "{{boonParaChance}}% chance to paralyze enemies for {{boonParaLen}} seconds on hit.",
            "Paralyzed enemies take twice as much damage from explosions."
        },
        spriteFrame = 15,
        mods = { boonParaChance = 7, boonParaLen = 2 },
        upgradedMods = { boonParaChance = 12, boonParaLen = 3 }
    },
    {
        name = "Activity",
        description = "When using an active item with at least 1 charge, become invulnerable for {{boonActivity}} seconds.",
        spriteFrame = 16,
        mods = { boonActivity = 1.5 },
        upgradedMods = { boonActivity = 2.5 }
    },
    {
        name = "Plentiful Emptiness",
        description = {
            "+{{boonEmptinessDmg}}% damage while the active item slot is empty.",
            "+{{boonEmptinessTears}}% tears while the trinket slot is empty."
        },
        spriteFrame = 17,
        mods = { boonEmptinessDmg = 20, boonEmptinessTears = 20 },
        upgradedMods = { boonEmptinessDmg = 35, boonEmptinessTears = 35 }
    },
    {
        name = "Volatility",
        description = {
            "Enemies take {{boonVolatilityDmg}}% more damage from explosions.",
            "Start with an additional {{boonVolatilityBombs}} bombs."
        },
        spriteFrame = 18,
        mods = { boonVolatilityDmg = 30, boonVolatilityBombs = 2 },
        upgradedMods = { boonVolatilityDmg = 50, boonVolatilityBombs = 4 }
    },
    {
        name = "Improvised Charges",
        description = "Consuming a Card, Pill or Rune on use grants all your active items 1 charge.",
        upgradedDescription = "Consuming a Card, Pill or Rune on use grants all your active items {{boonImpCharges}} charges.",
        spriteFrame = 19,
        mods = { boonImpCharges = 1 },
        upgradedMods = { boonImpCharges = 2 }
    },
    {
        name = "the Champion Slayer",
        description = "+{{boonChampSlayDmg}}% damage for the current floor when killing a champion monster, up to {{boonChampSlayMax}}%",
        spriteFrame = 20,
        mods = { boonChampSlayDmg = 1, boonChampSlayMax = 15 },
        upgradedMods = { boonChampSlayDmg = 2, boonChampSlayMax = 25 }
    },
    {
        name = "Meek Giants",
        description = "Bosses start with {{boonMeekGiants}}% of their HP missing.",
        spriteFrame = 21,
        mods = { boonMeekGiants = 12 },
        upgradedMods = { boonMeekGiants = 18 }
    },
    {
        name = "the Last Gasp",
        description = "Dying to any of the final bosses no longer consumes expedition attempts.",
        upgradedDescription = "Dying at any point past Womb II (or alternates) no longer consumes expedition attempts.",
        spriteFrame = 22,
        mods = { boonLastGasp = 1 },
        upgradedMods = { boonLastGasp = 2 }
    },
    {
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
    {
        name = "Wisdom",
        description = "+{{xpgain}}% XP gain within expedition runs.",
        spriteFrame = 24,
        mods = { xpgain = 20 },
        upgradedMods = { xpgain = 40 }
    },
    {
        name = "Unexpected Gifts",
        description = {
            "A random treasure room within the first 6 you visit will contain an additional passive item",
            "from the treasure item pool."
        },
        upgradedDescription = {
            "2 random treasure rooms within the first 6 you visit will contain an additional passive item",
            "from a random item pool."
        },
        spriteFrame = 25,
        mods = { boonUnexGifts = 1 },
        upgradedMods = { boonUnexGifts = 2 }
    }
}

-- List of available expedition curses
PST.expeditionCurses = {
    {
        name = "Enfeeblement",
        description = "{{damagePerc}}% damage.",
        spriteFrame = 0,
        modsFunc = function(depth)
            return { damagePerc = -math.min(70, 25 + depth) }
        end
    },
    {
        name = "Lethargy",
        description = "{{speedPerc}}% speed.",
        spriteFrame = 1,
        modsFunc = function(depth)
            return { speedPerc = -math.min(70, 25 + depth) }
        end
    },
    {
        name = "Tear Deprivation",
        description = "{{tearsPerc}}% tears.",
        spriteFrame = 2,
        modsFunc = function(depth)
            return { tearsPerc = -math.min(70, 25 + depth) }
        end
    },
    {
        name = "the Unfortunate",
        description = "{{luckPerc}}% luck.",
        spriteFrame = 3,
        modsFunc = function(depth)
            return { luckPerc = -math.min(70, 25 + depth) }
        end
    },
    {
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
    {
        name = "Resilience",
        description = "+{{curseResilience}}% monster HP",
        spriteFrame = 5,
        modsFunc = function(depth)
            return { curseResilience = math.min(60, 25 + depth) }
        end
    },
    {
        name = "Ephemeral Pieces",
        description = "All non-vanishing pickup drops now vanish after {{curseEphPieces}} seconds.",
        spriteFrame = 6,
        modsFunc = function(depth)
            local secs = 4
            if depth >= 10 then secs = 5 end
            if depth >= 25 then secs = 2 end
            return { curseEphPieces = secs }
        end
    },
    {
        name = "Power Demand",
        description = {
            "+{{cursePowerDemandCharges}} required charges to non-charging active items.",
            "+{{cursePowerDemandCD}} cooldown seconds to charging active items."
        },
        spriteFrame = 7,
        modsFunc = function(depth)
            local reqCharges, CDsecs = 2, 4
            if depth >= 12 then
                reqCharges = 3
                CDsecs = 5
            end
            return { cursePowerDemandCharges = reqCharges, cursePowerDemandCD = CDsecs }
        end
    },
    {
        name = "Giants' Fortification",
        description = "Bosses block the first {{curseGiantsFort}} hits they receive.",
        spriteFrame = 8,
        modsFunc = function(depth)
            return { curseGiantsFort = 7 + math.floor(depth / 3) }
        end
    },
    {
        name = "Greater Expenses",
        description = "Non-pickup shop items are {{curseGreaterExpenses}}% more expensive.",
        spriteFrame = 9,
        modsFunc = function(depth)
            return { curseGreaterExpenses = 20 + depth }
        end
    },
    {
        name = "Flimsy Gadgets",
        description = {
            "When hit, {{curseFlimGadgDrop}}% chance to drop held trinkets.",
            "{{curseFlimGadgVanish}}% chance for dropped trinkets to vanish instead."
        },
        spriteFrame = 10,
        modsFunc = function(depth)
            return {
                curseFlimGadgDrop = 15 + depth,
                curseFlimGadgVanish = 10 + math.floor(depth / 2)
            }
        end
    },
    {
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
    {
        name = "Vanishing Wealth",
        description = "When entering a floor, lose {{curseVanishingWealth}} coins.",
        spriteFrame = 12,
        modsFunc = function(depth)
            return { curseVanishingWealth = math.min(20, 6 + depth) }
        end
    },
    {
        name = "Precariousness",
        description = "When first entering a shop room, remove {{cursePrecarious}} random sold items.",
        spriteFrame = 13,
        modsFunc = function(depth)
            local rem = 2
            if depth >= 12 then rem = 3 end
            return { cursePrecarious = rem }
        end
    },
    {
        name = "Unexpected Taxation",
        description = "When first entering a room with monsters, lose {{curseUnexpectedTax}} coin(s).",
        spriteFrame = 14,
        modsFunc = function(depth)
            local tax = 1
            if depth >= 15 then tax = 2 end
            return { curseUnexpectedTax = tax }
        end
    },
    {
        name = "Fading Keys",
        description = "Whenever you spend a key, spend {{curseFadingKeys}} additional key(s).",
        spriteFrame = 15,
        modsFunc = function(depth)
            local keys = 1
            if depth >= 25 then keys = 2 end
            return { curseFadingKeys = keys }
        end
    },
    {
        name = "Punishment",
        description = "Take 1/2 heart damage every {{cursePunishment}} rooms cleared. This cannot kill you.",
        spriteFrame = 16,
        modsFunc = function(depth)
            local clears = 8
            if depth >= 10 then clears = 7 end
            if depth >= 25 then clears = 6 end
            return { cursePunishment = clears }
        end
    },
    {
        name = "Mortality",
        description = "Extra life items can no longer show up.",
        spriteFrame = 17,
        modsFunc = function(depth)
            return { curseMortality = true }
        end
    },
    {
        name = "Ancient Stars",
        description = "Expedition runs now require an Ancient Starcursed Jewel to be socketed.",
        spriteFrame = 18,
        modsFunc = function(depth)
            return { curseAncientStars = true }
        end
    },
    {
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
    {
        name = "Shrouding",
        description = "Expedition node rewards and curses are no longer known.",
        spriteFrame = 20,
        modsFunc = function(depth)
            return { curseShrouding = true }
        end,
        minDepth = 5
    },
    {
        name = "the Boonless",
        description = "You can no longer gain Expedition boons.",
        spriteFrame = 21,
        modsFunc = function(depth)
            return { curseBoonless = true }
        end,
        minDepth = 5
    },
    {
        name = "the Heartbroken",
        description = "Start with an additional {{curseHeartbroken}} broken heart(s).",
        spriteFrame = 22,
        modsFunc = function(depth)
            local broken = 1
            if depth >= 25 then broken = 2 end
            return { curseHeartbroken = broken }
        end,
        minDepth = 8
    },
    {
        name = "the Witless",
        description = "XP gain is halved within expedition runs.",
        spriteFrame = 23,
        modsFunc = function(depth)
            return { curseWitless = true }
        end,
        minDepth = 5
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
            local req = 500 + depth * 150 + column * 100
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
        end
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
            local req = 4 + math.floor(depth / 2) + math.floor(column / 3)
            return req
        end
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
    }
}
PST.expeditionObjectiveList = {}
for objName, _ in pairs(PST.expeditionObjectives) do
    table.insert(PST.expeditionObjectiveList, objName)
end

-- Final node objectives
PST.expeditionObjectivesFinal = {
    bossRush = { -- TODO
        description = "Complete {{progress}} boss rush encounter(s).",
        reqFunc = function(depth, column)
            local req = 1 + math.floor(depth / 15)
            return req
        end
    },
    hush = { -- TODO
        description = "Defeat Hush.",
        weight = 5,
        variants = {
            noDmgTwice = {
                description = "Defeat Hush without taking damage more than twice.",
                minDepth = 6,
                weight = 100
            },
            noDmgOnce = {
                description = "Defeat Hush without taking damage more than once.",
                minDepth = 14,
                weight = 40
            }
        },
        reqFunc = function() return 1 end
    },
    finalBoss = { -- TODO
        description = {
            "Defeat any final boss {{progress}} time(s).",
            "Final bosses include Delirium, ???, The Lamb, Mega Satan, The Beast, Mother and Ultra Greed."
        },
        reqFunc = function(depth, column)
            local req = 1 + math.floor(depth / 10)
            return req
        end
    },
    floorNoDmgTwice = { -- TODO
        description = "Clear {{progress}} floors without taking damage more than twice.",
        weight = 100,
        variants = {
            noDmgOnce = {
                description = "Clear {{progress}} floors without taking damage more than once.",
                minDepth = 10,
                weight = 50
            }
        },
        reqFunc = function(depth, column)
            local req = 4 + math.floor(depth / 3)
            return req
        end
    },
    bossesNoDmg = { -- TODO
        description = "Clear {{progress}} boss rooms past Chapter 3 (Womb and beyond) without taking damage.",
        reqFunc = function(depth, column)
            local req = math.min(12, 3 + math.floor(depth / 6))
            return req
        end
    },
    winItemPools = { -- TODO
        description = {
            "Complete a run while possessing at least one item for each of these item pools:",
            "Treasure, Shop, Angel, Devil"
        },
        reqFunc = function() return 1 end
    },
    beastDeliNoDmg = { -- TODO
        description = "Defeat The Beast or Delirium without taking damage more than once.",
        reqFunc = function() return 1 end,
        minDepth = 12
    }
}
PST.expeditionObjectiveFinalList = {}
for objName, _ in pairs(PST.expeditionObjectivesFinal) do
    table.insert(PST.expeditionObjectiveFinalList, objName)
end

-- Node reward data
PST.expeditionRewardData = {
    -- Arcane obols
    [PSTExpNodeRewardType.OBOLS] = function(RNG, depth, column)
        local baseAmt = 2 + RNG:RandomInt(1, 3)
        return baseAmt + depth * 4 + column * 2
    end,
    -- EXP
    [PSTExpNodeRewardType.EXP] = function(RNG, depth, column)
        local baseAmt = math.floor(100 + 200 * RNG:RandomFloat())
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
}

-- Expedition-specific modifier descriptions
PST.expedDescriptions = {
    mobHP = "+%d%% monster HP.",
    mobSpeed = "+%d%% monster speed.",
    floorCurse = "+%d%% chance to receive a curse when entering a floor.",
    pickupScarcity = "+%d%% coin, key, bomb and heart scarcity.",
    quality4Remove = "Remove %d random quality 4 items from the pool when starting a run.",
    heartbreak = {
        "Start with %d additional broken heart(s).",
        "Heartbreak can no longer show up."
    },
    lessAttempts = "-%d max expedition attempt(s).",
    mobDmgRed = "+%d%% monster damage reduction."
}

-- Obol-rewarding event quantities
PST.obolEvents = {
    -- On champion mob kill
    championKill = function(depth, chanceMod)
        local chance = 0.06 + (chanceMod or 0)
        if math.random() < chance then
            return 4 + 2 * (depth - 1)
        end
        return 0
    end,
    -- On boss kill
    bossKill = function(depth, chanceMod)
        local chance = 0.1 + (chanceMod or 0)
        if math.random() < chance then
            return 2 + PST:getLevel():GetStage() * 2 + 3 * (depth - 1)
        end
        return 0
    end,
    -- On challenge room clear
    challClear = function(depth, chanceMod)
        local chance = 0.35 + (chanceMod or 0)
        if math.random() < chance then
            return 5 + PST:getLevel():GetStage() * 3 + 3 * (depth - 1)
        end
        return 0
    end,
    -- On fully helping beggar (teleports away)
    beggarHelp = function(depth, chanceMod)
        local chance = 0.7 + (chanceMod or 0)
        if math.random() < chance then
            return 10 + 3 * (depth - 1)
        end
        return 0
    end,
    -- On boss rush clear
    bossRush = function(depth)
        return 10 + 5 * (depth - 1)
    end
}