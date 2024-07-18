local json = require("json")

SkillTrees.nodeLinks.global = {}
SkillTrees.trees.global = json.decode([[
    {
        "1": {
          "pos": [0, 0],
          "type": "Central",
          "size": "Large",
          "name": "Leveling of Isaac",
          "description": ["+0.05 all stats"],
          "modifiers": {
            "allstats": 0.05
          },
          "alwaysAvailable": true,
          "adjacent": [2, 66, 171, 212],
          "requires": []
        },
        "2": {
          "pos": [0, -2],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [1, 3],
          "requires": [1]
        },
        "3": {
          "pos": [0, -3],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [2, 4, 10],
          "requires": [2]
        },
        "4": {
          "pos": [1, -3],
          "type": "Small Respec",
          "size": "Small",
          "name": "Respec Chance",
          "description": [
            "+5% chance to gain a respec point",
            "when completing a floor."
          ],
          "modifiers": {
            "respecChance": 5
          },
          "alwaysAvailable": false,
          "adjacent": [3, 5],
          "requires": [3]
        },
        "5": {
          "pos": [2, -3],
          "type": "Small Respec",
          "size": "Small",
          "name": "Respec Chance",
          "description": [
            "+5% chance to gain a respec point",
            "when completing a floor."
          ],
          "modifiers": {
            "respecChance": 5
          },
          "alwaysAvailable": false,
          "adjacent": [4, 6],
          "requires": [4]
        },
        "6": {
          "pos": [3, -3],
          "type": "Small Respec",
          "size": "Small",
          "name": "Respec Chance",
          "description": [
            "+5% chance to gain a respec point",
            "when completing a floor."
          ],
          "modifiers": {
            "respecChance": 5
          },
          "alwaysAvailable": false,
          "adjacent": [5, 7],
          "requires": [5]
        },
        "7": {
          "pos": [4, -3],
          "type": "Small Respec",
          "size": "Small",
          "name": "Respec Chance",
          "description": [
            "+5% chance to gain a respec point",
            "when completing a floor."
          ],
          "modifiers": {
            "respecChance": 5
          },
          "alwaysAvailable": false,
          "adjacent": [6, 8],
          "requires": [6]
        },
        "8": {
          "pos": [5, -3],
          "type": "Med Respec",
          "size": "Med",
          "name": "Respec Chance",
          "description": [
            "+15% chance to gain a respec point",
            "when completing a floor."
          ],
          "modifiers": {
            "respecChance": 15
          },
          "alwaysAvailable": false,
          "adjacent": [7, 9],
          "requires": [7]
        },
        "9": {
          "pos": [5, -4],
          "type": "Large Respec",
          "size": "Large",
          "name": "Relearning",
          "description": [
            "Can no longer gain respec points from completing floors.",
            "Gain 3 respec points when winning a run, and",
            "additionally gain 1 respec point per completed floor in that run."
          ],
          "modifiers": {
            "relearning": true
          },
          "alwaysAvailable": false,
          "adjacent": [8],
          "requires": [8]
        },
        "10": {
          "pos": [0, -4],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [3, 11],
          "requires": [3]
        },
        "11": {
          "pos": [0, -5],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [10, 12, 18],
          "requires": [10]
        },
        "12": {
          "pos": [1, -5],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [11, 13],
          "requires": [11]
        },
        "13": {
          "pos": [2, -5],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [12, 14],
          "requires": [12]
        },
        "14": {
          "pos": [3, -5],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [13, 15],
          "requires": [13]
        },
        "15": {
          "pos": [3, -6],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [14, 16],
          "requires": [14]
        },
        "16": {
          "pos": [3, -7],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [15, 17],
          "requires": [15]
        },
        "17": {
          "pos": [4, -7],
          "type": "Med XP",
          "size": "Med",
          "name": "XP gain",
          "description": ["+7% XP gain"],
          "modifiers": {
            "xpgain": 7
          },
          "alwaysAvailable": false,
          "adjacent": [16],
          "requires": [16]
        },
        "18": {
          "pos": [0, -6],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [11, 19, 24],
          "requires": [11]
        },
        "19": {
          "pos": [-1, -6],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [18, 20],
          "requires": [18]
        },
        "20": {
          "pos": [-2, -6],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [19, 21],
          "requires": [19]
        },
        "21": {
          "pos": [-3, -6],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [20, 28, 29, 36],
          "requires": [20]
        },
        "23": {
          "pos": [1, -8],
          "type": "Unholy Growth",
          "size": "Large",
          "name": "Unholy Growth",
          "description": [
            "+15% XP gain",
            "Starting stats are 5% lower for all characters."
          ],
          "modifiers": {
            "xpgain": 15,
            "unholyGrowth": true
          },
          "alwaysAvailable": false,
          "adjacent": [25],
          "requires": [25]
        },
        "24": {
          "pos": [0, -7],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [18, 25],
          "requires": [18]
        },
        "25": {
          "pos": [0, -8],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [24, 23, 26],
          "requires": [24]
        },
        "26": {
          "pos": [0, -9],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [25, 27],
          "requires": [25]
        },
        "27": {
          "pos": [0, -10],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [26, 62, 52, 42],
          "requires": [26]
        },
        "28": {
          "pos": [-5, -6],
          "type": "Quick Wit",
          "size": "Large",
          "name": "Quick Wit",
          "description": [
            "+15% XP earned for the first 8 seconds upon entering a room.",
            "Afterwards, this bonus gradually lowers down to -20% over 10 seconds.",
            "Does not apply in boss rooms."
          ],
          "modifiers": {
            "quickWit": [15, -20]
          },
          "alwaysAvailable": false,
          "adjacent": [21],
          "requires": [21]
        },
        "29": {
          "pos": [-4, -5],
          "type": "Small Secret XP",
          "size": "Small",
          "name": "Secret XP",
          "description": [
            "Gain 30 XP upon first entering a secret or",
            "super secret room."
          ],
          "modifiers": {
            "secretXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [21, 30],
          "requires": [21]
        },
        "30": {
          "pos": [-4, -4],
          "type": "Small Secret XP",
          "size": "Small",
          "name": "Secret XP",
          "description": [
            "Gain 30 XP upon first entering a secret or",
            "super secret room."
          ],
          "modifiers": {
            "secretXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [29, 31],
          "requires": [29]
        },
        "31": {
          "pos": [-5, -4],
          "type": "Small Secret XP",
          "size": "Small",
          "name": "Secret XP",
          "description": [
            "Gain 30 XP upon first entering a secret or",
            "super secret room."
          ],
          "modifiers": {
            "secretXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [30, 32],
          "requires": [30]
        },
        "32": {
          "pos": [-6, -4],
          "type": "Small Secret XP",
          "size": "Small",
          "name": "Secret XP",
          "description": [
            "Gain 30 XP upon first entering a secret or",
            "super secret room."
          ],
          "modifiers": {
            "secretXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [31, 33],
          "requires": [31]
        },
        "33": {
          "pos": [-7, -4],
          "type": "Small Secret XP",
          "size": "Small",
          "name": "Secret XP",
          "description": [
            "Gain 30 XP upon first entering a secret or",
            "super secret room."
          ],
          "modifiers": {
            "secretXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [32, 34],
          "requires": [32]
        },
        "34": {
          "pos": [-7, -5],
          "type": "Med Secret XP",
          "size": "Med",
          "name": "Secret XP",
          "description": [
            "Gain 100 XP upon first entering a secret or",
            "super secret room."
          ],
          "modifiers": {
            "secretXP": 100
          },
          "alwaysAvailable": false,
          "adjacent": [33, 35],
          "requires": [33]
        },
        "35": {
          "pos": [-8, -5],
          "type": "Large Secret XP",
          "size": "Large",
          "name": "Expert Spelunker",
          "description": [
            "Gain no XP when first entering a secret room.",
            "Gain 350 XP when first entering a super secret room."
          ],
          "modifiers": {
            "expertSpelunker": 350
          },
          "alwaysAvailable": false,
          "adjacent": [34],
          "requires": [34]
        },
        "36": {
          "pos": [-4, -7],
          "type": "Small Challenge XP",
          "size": "Small",
          "name": "Challenge XP",
          "description": ["Gain 30 XP upon completing a challenge room round."],
          "modifiers": {
            "challengeXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [21, 37],
          "requires": [21]
        },
        "37": {
          "pos": [-4, -8],
          "type": "Small Challenge XP",
          "size": "Small",
          "name": "Challenge XP",
          "description": ["Gain 30 XP upon completing a challenge room round."],
          "modifiers": {
            "challengeXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [36, 38],
          "requires": [36]
        },
        "38": {
          "pos": [-5, -8],
          "type": "Small Challenge XP",
          "size": "Small",
          "name": "Challenge XP",
          "description": ["Gain 30 XP upon completing a challenge room round."],
          "modifiers": {
            "challengeXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [37, 39],
          "requires": [37]
        },
        "39": {
          "pos": [-6, -8],
          "type": "Small Challenge XP",
          "size": "Small",
          "name": "Challenge XP",
          "description": ["Gain 30 XP upon completing a challenge room round."],
          "modifiers": {
            "challengeXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [38, 40],
          "requires": [38]
        },
        "40": {
          "pos": [-7, -8],
          "type": "Small Challenge XP",
          "size": "Small",
          "name": "Challenge XP",
          "description": ["Gain 30 XP upon completing a challenge room round."],
          "modifiers": {
            "challengeXP": 30
          },
          "alwaysAvailable": false,
          "adjacent": [39, 41],
          "requires": [39]
        },
        "41": {
          "pos": [-7, -7],
          "type": "Med Challenge XP",
          "size": "Med",
          "name": "Challenge XP",
          "description": [
            "Gain 70 XP upon completing a challenge room round.",
            "+10% XP gain in challenge rooms."
          ],
          "modifiers": {
            "challengeXP": 70,
            "challengeXPgain": 10
          },
          "alwaysAvailable": false,
          "adjacent": [40],
          "requires": [40]
        },
        "42": {
          "pos": [1, -10],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [27, 43],
          "requires": [27]
        },
        "43": {
          "pos": [2, -10],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [42, 44],
          "requires": [42]
        },
        "44": {
          "pos": [3, -10],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [43, 45],
          "requires": [43]
        },
        "45": {
          "pos": [3, -11],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [44, 46],
          "requires": [44]
        },
        "46": {
          "pos": [3, -12],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [45, 50, 47],
          "requires": [45]
        },
        "47": {
          "pos": [3, -13],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [46, 48],
          "requires": [46]
        },
        "48": {
          "pos": [3, -14],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [47, 49],
          "requires": [47]
        },
        "49": {
          "pos": [2, -14],
          "type": "Small Monster XP",
          "size": "Small",
          "name": "Monster XP",
          "description": ["+4% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 4
          },
          "alwaysAvailable": false,
          "adjacent": [48, 51],
          "requires": [48]
        },
        "50": {
          "pos": [4, -12],
          "type": "Med Monster XP",
          "size": "Med",
          "name": "Monster XP",
          "description": ["+10% XP from slain normal monsters."],
          "modifiers": {
            "xpgainNormalMob": 10
          },
          "alwaysAvailable": false,
          "adjacent": [46],
          "requires": [46]
        },
        "51": {
          "pos": [2, -15],
          "type": "Large Monster XP",
          "size": "Large",
          "name": "Swarm Challenger",
          "description": [
            "+25% XP from slain normal monsters.",
            "-15% XP from slain bosses."
          ],
          "modifiers": {
            "xpgainNormalMob": 25,
            "xpgainBoss": -15
          },
          "alwaysAvailable": false,
          "adjacent": [49],
          "requires": [49]
        },
        "52": {
          "pos": [-1, -10],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [27, 53],
          "requires": [27]
        },
        "53": {
          "pos": [-2, -10],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [52, 54],
          "requires": [52]
        },
        "54": {
          "pos": [-3, -10],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [53, 55],
          "requires": [53]
        },
        "55": {
          "pos": [-3, -11],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [54, 56],
          "requires": [54]
        },
        "56": {
          "pos": [-3, -12],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [55, 60, 57],
          "requires": [55]
        },
        "57": {
          "pos": [-3, -13],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [56, 58],
          "requires": [56]
        },
        "58": {
          "pos": [-3, -14],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [57, 59],
          "requires": [57]
        },
        "59": {
          "pos": [-2, -14],
          "type": "Small Boss XP",
          "size": "Small",
          "name": "Boss XP",
          "description": ["+4% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 4
          },
          "alwaysAvailable": false,
          "adjacent": [58, 61],
          "requires": [58]
        },
        "60": {
          "pos": [-4, -12],
          "type": "Med Boss XP",
          "size": "Med",
          "name": "Boss XP",
          "description": ["+10% XP from slain bosses."],
          "modifiers": {
            "xpgainBoss": 10
          },
          "alwaysAvailable": false,
          "adjacent": [56],
          "requires": [56]
        },
        "61": {
          "pos": [-2, -15],
          "type": "Large Boss XP",
          "size": "Large",
          "name": "Beast Challenger",
          "description": [
            "+25% XP from slain bosses.",
            "-15% XP from slain normal monsters."
          ],
          "modifiers": {
            "xpgainBoss": 25,
            "xpgainNormalMob": -15
          },
          "alwaysAvailable": false,
          "adjacent": [59],
          "requires": [59]
        },
        "62": {
          "pos": [0, -11],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [27, 63],
          "requires": [27]
        },
        "63": {
          "pos": [0, -12],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [62, 64],
          "requires": [62]
        },
        "64": {
          "pos": [0, -13],
          "type": "Small XP",
          "size": "Small",
          "name": "XP gain",
          "description": ["+2% XP gain"],
          "modifiers": {
            "xpgain": 2
          },
          "alwaysAvailable": false,
          "adjacent": [63, 65],
          "requires": [63]
        },
        "65": {
          "pos": [0, -14],
          "type": "Med XP",
          "size": "Med",
          "name": "XP gain",
          "description": ["+7% XP gain"],
          "modifiers": {
            "xpgain": 7
          },
          "alwaysAvailable": false,
          "adjacent": [64],
          "requires": [64]
        },
        "66": {
          "pos": [-2, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [1, 67],
          "requires": [1]
        },
        "67": {
          "pos": [-3, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [66, 68],
          "requires": [66]
        },
        "68": {
          "pos": [-4, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [67, 71, 69],
          "requires": [67]
        },
        "69": {
          "pos": [-5, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [68, 70],
          "requires": [68]
        },
        "70": {
          "pos": [-6, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [69, 77],
          "requires": [69]
        },
        "71": {
          "pos": [-4, 1],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [68, 72],
          "requires": [68]
        },
        "72": {
          "pos": [-4, 2],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [71, 73],
          "requires": [71]
        },
        "73": {
          "pos": [-3, 3],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [72, 74],
          "requires": [72]
        },
        "74": {
          "pos": [-4, 4],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [73, 76],
          "requires": [73]
        },
        "76": {
          "pos": [-5, 3],
          "type": "Med Luck",
          "size": "Med",
          "name": "Luck",
          "description": ["+0.05 luck"],
          "modifiers": {
            "luck": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [74],
          "requires": [74]
        },
        "77": {
          "pos": [-7, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [70, 78],
          "requires": [70]
        },
        "78": {
          "pos": [-8, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [77, 79],
          "requires": [77]
        },
        "79": {
          "pos": [-9, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [78, 80],
          "requires": [78]
        },
        "80": {
          "pos": [-10, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [79, 82, 111, 81],
          "requires": [79]
        },
        "81": {
          "pos": [-11, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [80, 91],
          "requires": [80]
        },
        "82": {
          "pos": [-10, -1],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [80, 83],
          "requires": [80]
        },
        "83": {
          "pos": [-10, -2],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [82, 84],
          "requires": [82]
        },
        "84": {
          "pos": [-9, -3],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [83, 85],
          "requires": [83]
        },
        "85": {
          "pos": [-10, -4],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [84, 86],
          "requires": [84]
        },
        "86": {
          "pos": [-11, -3],
          "type": "Med Luck",
          "size": "Med",
          "name": "Luck",
          "description": ["+0.05 luck"],
          "modifiers": {
            "luck": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [85],
          "requires": [85]
        },
        "91": {
          "pos": [-12, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [81, 92],
          "requires": [81]
        },
        "92": {
          "pos": [-13, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [91, 94, 161, 165],
          "requires": [91]
        },
        "94": {
          "pos": [-14, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [92, 108],
          "requires": [92]
        },
        "108": {
          "pos": [-15, 0],
          "type": "Med Beggar Luck",
          "size": "Med",
          "name": "Good Deeds",
          "description": ["Helping a beggar grants +0.03 luck"],
          "modifiers": {
            "beggarLuck": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [94, 151, 147, 143],
          "requires": [94]
        },
        "111": {
          "pos": [-10, 1],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [80, 112],
          "requires": [80]
        },
        "112": {
          "pos": [-10, 2],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [111, 113],
          "requires": [111]
        },
        "113": {
          "pos": [-10, 3],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [112, 114],
          "requires": [112]
        },
        "114": {
          "pos": [-10, 4],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [113, 115, 127],
          "requires": [113]
        },
        "115": {
          "pos": [-11, 5],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [114, 116],
          "requires": [114]
        },
        "116": {
          "pos": [-11, 6],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [115, 117],
          "requires": [115]
        },
        "117": {
          "pos": [-11, 7],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [116, 118],
          "requires": [116]
        },
        "118": {
          "pos": [-11, 8],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [117, 128, 119],
          "requires": [117]
        },
        "119": {
          "pos": [-10, 9],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [118, 120],
          "requires": [118]
        },
        "120": {
          "pos": [-9, 9],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [119, 121],
          "requires": [119]
        },
        "121": {
          "pos": [-8, 9],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [120, 122],
          "requires": [120]
        },
        "122": {
          "pos": [-7, 9],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [121, 129, 123],
          "requires": [121]
        },
        "123": {
          "pos": [-6, 8],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [122, 124],
          "requires": [122]
        },
        "124": {
          "pos": [-6, 7],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [123, 125],
          "requires": [123]
        },
        "125": {
          "pos": [-7, 6],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [124, 126],
          "requires": [124]
        },
        "126": {
          "pos": [-8, 6],
          "type": "Small Devil Chance",
          "size": "Small",
          "name": "Devil/Angel Rooms",
          "description": ["+0.25% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [125, 130],
          "requires": [125]
        },
        "127": {
          "pos": [-9, 5],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [114],
          "requires": [114]
        },
        "128": {
          "pos": [-12, 9],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [118],
          "requires": [118]
        },
        "129": {
          "pos": [-6, 10],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [122],
          "requires": [122]
        },
        "130": {
          "pos": [-9, 7],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [126, 280, 281],
          "requires": [126]
        },
        "143": {
          "pos": [-15, 1],
          "type": "Small Bomb Dupe Chance",
          "size": "Small",
          "name": "Bomb Dupe Chance",
          "description": [
            "+0.25% chance for bomb pickups to grant an additional bomb"
          ],
          "modifiers": {
            "bombDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [108, 144],
          "requires": [108]
        },
        "144": {
          "pos": [-15, 2],
          "type": "Small Bomb Dupe Chance",
          "size": "Small",
          "name": "Bomb Dupe Chance",
          "description": [
            "+0.25% chance for bomb pickups to grant an additional bomb"
          ],
          "modifiers": {
            "bombDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [143, 145],
          "requires": [143]
        },
        "145": {
          "pos": [-15, 3],
          "type": "Small Bomb Dupe Chance",
          "size": "Small",
          "name": "Bomb Dupe Chance",
          "description": [
            "+0.25% chance for bomb pickups to grant an additional bomb"
          ],
          "modifiers": {
            "bombDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [144, 146],
          "requires": [144]
        },
        "146": {
          "pos": [-15, 4],
          "type": "Small Bomb Dupe Chance",
          "size": "Small",
          "name": "Bomb Dupe Chance",
          "description": [
            "+0.25% chance for bomb pickups to grant an additional bomb"
          ],
          "modifiers": {
            "bombDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [145, 160, 207],
          "requires": [145]
        },
        "147": {
          "pos": [-16, 0],
          "type": "Small Key Dupe Chance",
          "size": "Small",
          "name": "Key Dupe Chance",
          "description": ["+0.25% chance for key pickups to grant an additional key"],
          "modifiers": {
            "keyDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [108, 148],
          "requires": [108]
        },
        "148": {
          "pos": [-17, 0],
          "type": "Small Key Dupe Chance",
          "size": "Small",
          "name": "Key Dupe Chance",
          "description": ["+0.25% chance for key pickups to grant an additional key"],
          "modifiers": {
            "keyDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [147, 149],
          "requires": [147]
        },
        "149": {
          "pos": [-18, 0],
          "type": "Small Key Dupe Chance",
          "size": "Small",
          "name": "Key Dupe Chance",
          "description": ["+0.25% chance for key pickups to grant an additional key"],
          "modifiers": {
            "keyDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [148, 150],
          "requires": [148]
        },
        "150": {
          "pos": [-19, 0],
          "type": "Small Key Dupe Chance",
          "size": "Small",
          "name": "Key Dupe Chance",
          "description": ["+0.25% chance for key pickups to grant an additional key"],
          "modifiers": {
            "keyDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [149, 159],
          "requires": [149]
        },
        "151": {
          "pos": [-15, -1],
          "type": "Small Coin Dupe Chance",
          "size": "Small",
          "name": "Coin Dupe Chance",
          "description": [
            "+0.25% chance for coin pickups to grant an additional coin"
          ],
          "modifiers": {
            "coinDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [108, 152],
          "requires": [108]
        },
        "152": {
          "pos": [-15, -2],
          "type": "Small Coin Dupe Chance",
          "size": "Small",
          "name": "Coin Dupe Chance",
          "description": [
            "+0.25% chance for coin pickups to grant an additional coin"
          ],
          "modifiers": {
            "coinDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [151, 153],
          "requires": [151]
        },
        "153": {
          "pos": [-15, -3],
          "type": "Small Coin Dupe Chance",
          "size": "Small",
          "name": "Coin Dupe Chance",
          "description": [
            "+0.25% chance for coin pickups to grant an additional coin"
          ],
          "modifiers": {
            "coinDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [152, 154],
          "requires": [152]
        },
        "154": {
          "pos": [-15, -4],
          "type": "Small Coin Dupe Chance",
          "size": "Small",
          "name": "Coin Dupe Chance",
          "description": [
            "+0.25% chance for coin pickups to grant an additional coin"
          ],
          "modifiers": {
            "coinDupe": 0.25
          },
          "alwaysAvailable": false,
          "adjacent": [153, 155],
          "requires": [153]
        },
        "155": {
          "pos": [-15, -5],
          "type": "Med Coin Dupe Chance",
          "size": "Med",
          "name": "Coin Dupe Chance",
          "description": ["+1% chance for coin pickups to grant an additional coin"],
          "modifiers": {
            "coinDupe": 1
          },
          "alwaysAvailable": false,
          "adjacent": [154, 156],
          "requires": [154]
        },
        "156": {
          "pos": [-15, -6],
          "type": "Med Grab Bag",
          "size": "Med",
          "name": "Grab Bags",
          "description": [
            "+0.1% chance to turn regular coins/keys/bombs",
            "into a grab-bag"
          ],
          "modifiers": {
            "grabBag": 0.1
          },
          "alwaysAvailable": false,
          "adjacent": [155],
          "requires": [155]
        },
        "157": {
          "pos": [-21, 0],
          "type": "Med Grab Bag",
          "size": "Med",
          "name": "Grab Bags",
          "description": [
            "+0.1% chance to turn regular coins/keys/bombs",
            "into a grab-bag"
          ],
          "modifiers": {
            "grabBag": 0.1
          },
          "alwaysAvailable": false,
          "adjacent": [159],
          "requires": [159]
        },
        "158": {
          "pos": [-15, 6],
          "type": "Med Grab Bag",
          "size": "Med",
          "name": "Grab Bags",
          "description": [
            "+0.1% chance to turn regular coins/keys/bombs",
            "into a grab-bag"
          ],
          "modifiers": {
            "grabBag": 0.1
          },
          "alwaysAvailable": false,
          "adjacent": [160, 207],
          "requires": [160, 207]
        },
        "159": {
          "pos": [-20, 0],
          "type": "Med Key Dupe Chance",
          "size": "Med",
          "name": "Key Dupe Chance",
          "description": ["+1% chance for key pickups to grant an additional key"],
          "modifiers": {
            "keyDupe": 1
          },
          "alwaysAvailable": false,
          "adjacent": [150, 157],
          "requires": [150]
        },
        "161": {
          "pos": [-13, -2],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [92, 162],
          "requires": [92]
        },
        "162": {
          "pos": [-13, -3],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [161, 163],
          "requires": [161]
        },
        "163": {
          "pos": [-13, -4],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [162, 164],
          "requires": [162]
        },
        "164": {
          "pos": [-13, -5],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [163, 169],
          "requires": [163]
        },
        "165": {
          "pos": [-13, 2],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [92, 166],
          "requires": [92]
        },
        "166": {
          "pos": [-13, 3],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [165, 167],
          "requires": [165]
        },
        "167": {
          "pos": [-13, 4],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [166, 168],
          "requires": [166]
        },
        "168": {
          "pos": [-13, 5],
          "type": "Small Map Chance",
          "size": "Small",
          "name": "Mapping Chance",
          "description": [
            "+1% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [167, 170],
          "requires": [167]
        },
        "169": {
          "pos": [-13, -6],
          "type": "Med Map Chance",
          "size": "Med",
          "name": "Mapping Chance",
          "description": [
            "+4% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 4
          },
          "alwaysAvailable": false,
          "adjacent": [164],
          "requires": [164]
        },
        "170": {
          "pos": [-13, 6],
          "type": "Med Map Chance",
          "size": "Med",
          "name": "Mapping Chance",
          "description": [
            "+4% chance for the map to be revealed upon entering a floor",
            "Works from the second floor onwards"
          ],
          "modifiers": {
            "mapChance": 4
          },
          "alwaysAvailable": false,
          "adjacent": [168],
          "requires": [168]
        },
        "171": {
          "pos": [0, 2],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [1, 172],
          "requires": [1]
        },
        "172": {
          "pos": [0, 3],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [171, 173],
          "requires": [171]
        },
        "173": {
          "pos": [0, 4],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [172, 174],
          "requires": [172]
        },
        "174": {
          "pos": [0, 5],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [173, 175],
          "requires": [173]
        },
        "175": {
          "pos": [0, 6],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [174, 176],
          "requires": [174]
        },
        "176": {
          "pos": [0, 7],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [175, 177],
          "requires": [175]
        },
        "177": {
          "pos": [0, 8],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [176, 178],
          "requires": [176]
        },
        "178": {
          "pos": [1, 9],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [177, 179],
          "requires": [177]
        },
        "179": {
          "pos": [2, 10],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [178, 180],
          "requires": [178]
        },
        "180": {
          "pos": [3, 11],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [179, 181],
          "requires": [179]
        },
        "181": {
          "pos": [4, 12],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [180, 182, 202],
          "requires": [180]
        },
        "182": {
          "pos": [3, 13],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [181, 183],
          "requires": [181]
        },
        "183": {
          "pos": [2, 14],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [182, 184],
          "requires": [182]
        },
        "184": {
          "pos": [1, 15],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [183, 185],
          "requires": [183]
        },
        "185": {
          "pos": [0, 16],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [184, 186, 203],
          "requires": [184]
        },
        "186": {
          "pos": [-1, 15],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [185, 187],
          "requires": [185]
        },
        "187": {
          "pos": [-2, 14],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [186, 188],
          "requires": [186]
        },
        "188": {
          "pos": [-3, 13],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [187, 189],
          "requires": [187]
        },
        "189": {
          "pos": [-4, 12],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [188, 190, 204],
          "requires": [188]
        },
        "190": {
          "pos": [-3, 11],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [189, 191],
          "requires": [189]
        },
        "191": {
          "pos": [-2, 10],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [190, 192],
          "requires": [190]
        },
        "192": {
          "pos": [-1, 9],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [191, 193],
          "requires": [191]
        },
        "193": {
          "pos": [0, 10],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [192, 194, 205],
          "requires": [192]
        },
        "194": {
          "pos": [1, 11],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [193, 195],
          "requires": [193]
        },
        "195": {
          "pos": [2, 12],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [194, 196],
          "requires": [194]
        },
        "196": {
          "pos": [1, 13],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [195, 197],
          "requires": [195]
        },
        "197": {
          "pos": [0, 14],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [196, 198, 206],
          "requires": [196]
        },
        "198": {
          "pos": [-1, 13],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [197, 199],
          "requires": [197]
        },
        "199": {
          "pos": [-2, 12],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [198, 200],
          "requires": [198]
        },
        "200": {
          "pos": [-1, 11],
          "type": "Small Luck Down",
          "size": "Small",
          "name": "Luck Down",
          "description": ["-0.03 luck"],
          "modifiers": {
            "luck": -0.03
          },
          "alwaysAvailable": false,
          "adjacent": [199, 201],
          "requires": [199]
        },
        "201": {
          "pos": [0, 12],
          "type": "Cosmic Realignment",
          "size": "Large",
          "name": "Cosmic Realignment",
          "description": [
            "Allocate to choose an unlocked character different to the currently selected one.",
            "Once selected, you may earn that character's completion marks by",
            "playing the currently selected character.",
            "Beware, however, the cosmic curse each character comes with..."
          ],
          "modifiers": {
            "cosmicRealignment": true
          },
          "alwaysAvailable": false,
          "adjacent": [200],
          "requires": [200]
        },
        "202": {
          "pos": [5, 13],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [181],
          "requires": [181]
        },
        "203": {
          "pos": [-1, 17],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [185],
          "requires": [185]
        },
        "204": {
          "pos": [-5, 11],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [189],
          "requires": [189]
        },
        "205": {
          "pos": [0, 11],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [193],
          "requires": [193]
        },
        "206": {
          "pos": [0, 13],
          "type": "Med Devil Chance",
          "size": "Med",
          "name": "Devil/Angel Rooms",
          "description": ["+1% chance for the devil/angel room to show up"],
          "modifiers": {
            "devilChance": 1
          },
          "alwaysAvailable": false,
          "adjacent": [197],
          "requires": [197]
        },
        "207": {
          "pos": [-15, 5],
          "type": "Med Bomb Dupe Chance",
          "size": "Med",
          "name": "Bomb Dupe Chance",
          "description": ["+1% chance for bomb pickups to grant an additional bomb"],
          "modifiers": {
            "bombDupe": 1
          },
          "alwaysAvailable": false,
          "adjacent": [146, 158],
          "requires": [146]
        },
        "212": {
          "pos": [2, 0],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [1, 213],
          "requires": [1]
        },
        "213": {
          "pos": [3, 0],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [212, 214],
          "requires": [212]
        },
        "214": {
          "pos": [4, 0],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [213, 215],
          "requires": [213]
        },
        "215": {
          "pos": [5, 0],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [214, 216],
          "requires": [214]
        },
        "216": {
          "pos": [6, 0],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [215, 217],
          "requires": [215]
        },
        "217": {
          "pos": [7, 0],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [216, 218],
          "requires": [216]
        },
        "218": {
          "pos": [8, 0],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [217, 219],
          "requires": [217]
        },
        "219": {
          "pos": [9, 0],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [218, 220],
          "requires": [218]
        },
        "220": {
          "pos": [10, 0],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [219, 221],
          "requires": [219]
        },
        "221": {
          "pos": [11, 0],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [220, 222],
          "requires": [220]
        },
        "222": {
          "pos": [12, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [221, 239, 223],
          "requires": [221]
        },
        "223": {
          "pos": [13, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [222, 245, 224],
          "requires": [222]
        },
        "224": {
          "pos": [14, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [223, 251, 225],
          "requires": [223]
        },
        "225": {
          "pos": [15, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [224, 257, 269],
          "requires": [224]
        },
        "239": {
          "pos": [13, -1],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [222, 240],
          "requires": [222]
        },
        "240": {
          "pos": [13, -2],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [239, 241],
          "requires": [239]
        },
        "241": {
          "pos": [13, -3],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [240, 242],
          "requires": [240]
        },
        "242": {
          "pos": [13, -4],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [241, 243],
          "requires": [241]
        },
        "243": {
          "pos": [13, -5],
          "type": "Small Damage",
          "size": "Small",
          "name": "Damage",
          "description": ["+0.02 damage"],
          "modifiers": {
            "damage": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [242, 244],
          "requires": [242]
        },
        "244": {
          "pos": [13, -6],
          "type": "Med Damage",
          "size": "Med",
          "name": "Damage",
          "description": ["+0.1 damage"],
          "modifiers": {
            "damage": 0.1
          },
          "alwaysAvailable": false,
          "adjacent": [243],
          "requires": [243]
        },
        "245": {
          "pos": [14, 1],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [223, 246],
          "requires": [223]
        },
        "246": {
          "pos": [14, 2],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [245, 247],
          "requires": [245]
        },
        "247": {
          "pos": [14, 3],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [246, 248],
          "requires": [246]
        },
        "248": {
          "pos": [14, 4],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [247, 249],
          "requires": [247]
        },
        "249": {
          "pos": [14, 5],
          "type": "Small Tears",
          "size": "Small",
          "name": "Tears",
          "description": ["+0.03 tears"],
          "modifiers": {
            "tears": 0.03
          },
          "alwaysAvailable": false,
          "adjacent": [248, 250],
          "requires": [248]
        },
        "250": {
          "pos": [14, 6],
          "type": "Med Tears",
          "size": "Med",
          "name": "Tears",
          "description": ["+0.1 tears"],
          "modifiers": {
            "tears": 0.1
          },
          "alwaysAvailable": false,
          "adjacent": [249],
          "requires": [249]
        },
        "251": {
          "pos": [15, -1],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [224, 252],
          "requires": [224]
        },
        "252": {
          "pos": [15, -2],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [251, 253],
          "requires": [251]
        },
        "253": {
          "pos": [15, -3],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [252, 254],
          "requires": [252]
        },
        "254": {
          "pos": [15, -4],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [253, 255],
          "requires": [253]
        },
        "255": {
          "pos": [15, -5],
          "type": "Small Shot Speed",
          "size": "Small",
          "name": "Shot Speed",
          "description": ["+0.02 shot speed"],
          "modifiers": {
            "shotSpeed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [254, 256],
          "requires": [254]
        },
        "256": {
          "pos": [15, -6],
          "type": "Med Shot Speed",
          "size": "Med",
          "name": "Shot Speed",
          "description": ["+0.1 shot speed"],
          "modifiers": {
            "shotSpeed": 0.1
          },
          "alwaysAvailable": false,
          "adjacent": [255],
          "requires": [255]
        },
        "257": {
          "pos": [16, 1],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [225, 258],
          "requires": [225]
        },
        "258": {
          "pos": [16, 2],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [257, 259],
          "requires": [257]
        },
        "259": {
          "pos": [16, 3],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [258, 260],
          "requires": [258]
        },
        "260": {
          "pos": [16, 4],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [259, 261],
          "requires": [259]
        },
        "261": {
          "pos": [16, 5],
          "type": "Small Speed",
          "size": "Small",
          "name": "Speed",
          "description": ["+0.02 speed"],
          "modifiers": {
            "speed": 0.02
          },
          "alwaysAvailable": false,
          "adjacent": [260, 262],
          "requires": [260]
        },
        "262": {
          "pos": [16, 6],
          "type": "Med Speed",
          "size": "Med",
          "name": "Speed",
          "description": ["+0.08 speed"],
          "modifiers": {
            "speed": 0.08
          },
          "alwaysAvailable": false,
          "adjacent": [261],
          "requires": [261]
        },
        "263": {
          "pos": [17, -1],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [269, 264],
          "requires": [269]
        },
        "264": {
          "pos": [17, -2],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [263, 265],
          "requires": [263]
        },
        "265": {
          "pos": [17, -3],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [264, 266],
          "requires": [264]
        },
        "266": {
          "pos": [17, -4],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [265, 267],
          "requires": [265]
        },
        "267": {
          "pos": [17, -5],
          "type": "Small Range",
          "size": "Small",
          "name": "Range",
          "description": ["+0.05 range"],
          "modifiers": {
            "range": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [266, 268],
          "requires": [266]
        },
        "268": {
          "pos": [17, -6],
          "type": "Med Range",
          "size": "Med",
          "name": "Range",
          "description": ["+0.2 range"],
          "modifiers": {
            "range": 0.2
          },
          "alwaysAvailable": false,
          "adjacent": [267],
          "requires": [267]
        },
        "269": {
          "pos": [16, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [225, 263, 270],
          "requires": [225]
        },
        "270": {
          "pos": [17, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [269, 271, 279],
          "requires": [269]
        },
        "271": {
          "pos": [18, 1],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [270, 272],
          "requires": [270]
        },
        "272": {
          "pos": [18, 2],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [271, 273],
          "requires": [271]
        },
        "273": {
          "pos": [18, 3],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [272, 274],
          "requires": [272]
        },
        "274": {
          "pos": [18, 4],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [273, 275],
          "requires": [273]
        },
        "275": {
          "pos": [18, 5],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [274, 276],
          "requires": [274]
        },
        "276": {
          "pos": [18, 6],
          "type": "Med Luck",
          "size": "Med",
          "name": "Luck",
          "description": ["+0.05 luck"],
          "modifiers": {
            "luck": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [275],
          "requires": [275]
        },
        "278": {
          "pos": [19, 0],
          "type": "Med Luck",
          "size": "Med",
          "name": "Luck",
          "description": ["+0.05 luck"],
          "modifiers": {
            "luck": 0.05
          },
          "alwaysAvailable": false,
          "adjacent": [279],
          "requires": [279]
        },
        "279": {
          "pos": [18, 0],
          "type": "Small Luck",
          "size": "Small",
          "name": "Luck",
          "description": ["+0.01 luck"],
          "modifiers": {
            "luck": 0.01
          },
          "alwaysAvailable": false,
          "adjacent": [270, 278],
          "requires": [270]
        },
        "280": {
          "pos": [-10, 8],
          "type": "Hell Favour",
          "size": "Large",
          "name": "Hell's Favour",
          "description": [
            "Adds 0 to 2 to a random stat upon entering a devil room.",
            "Lose 0 to 2 of a random stat upon entering an angel room.",
            "-1 to a random stat if you leave a devil room without",
            "making a deal (if available)."
          ],
          "modifiers": {
            "hellFavour": true
          },
          "alwaysAvailable": false,
          "adjacent": [130],
          "requires": [130]
        },
        "281": {
          "pos": [-8, 8],
          "type": "Heaven Favour",
          "size": "Large",
          "name": "Heaven's Favour",
          "description": [
            "+1 to a random stat upon entering an angel room.",
            "-1 to a random stat upon entering a devil room."
          ],
          "modifiers": {
            "heavenFavour": true
          },
          "alwaysAvailable": false,
          "adjacent": [130],
          "requires": [130]
        }
    }
]]);