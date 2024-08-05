local json = require("json")

PST.nodeLinks["Eden"] = {}
PST.trees["Eden"] = json.decode([[
{
"2": "{\"pos\":[-1,-1],\"type\":24,\"size\":\"Small\",\"name\":\"Damage\",\"description\":[\"+0.01 damage\"],\"modifiers\":{\"damage\":0.01},\"adjacent\":[42,3],\"requires\":[42]}",
"3": "{\"pos\":[-2,-2],\"type\":24,\"size\":\"Small\",\"name\":\"Damage\",\"description\":[\"+0.01 damage\"],\"modifiers\":{\"damage\":0.01},\"adjacent\":[2,4],\"requires\":[2]}",
"4": "{\"pos\":[-3,-3],\"type\":30,\"size\":\"Med\",\"name\":\"Damage\",\"description\":[\"+0.05 damage\"],\"modifiers\":{\"damage\":0.05},\"adjacent\":[3],\"requires\":[3]}",
"5": "{\"pos\":[0,-1],\"type\":20,\"size\":\"Small\",\"name\":\"Range\",\"description\":[\"+0.02 range\"],\"modifiers\":{\"range\":0.02},\"adjacent\":[42,6],\"requires\":[42]}",
"6": "{\"pos\":[0,-2],\"type\":20,\"size\":\"Small\",\"name\":\"Range\",\"description\":[\"+0.02 range\"],\"modifiers\":{\"range\":0.02},\"adjacent\":[5,7],\"requires\":[5]}",
"7": "{\"pos\":[0,-3],\"type\":20,\"size\":\"Small\",\"name\":\"Range\",\"description\":[\"+0.02 range\"],\"modifiers\":{\"range\":0.02},\"adjacent\":[6,29],\"requires\":[6]}",
"10": "{\"pos\":[1,-1],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[42,11],\"requires\":[42]}",
"11": "{\"pos\":[2,-2],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[10,12],\"requires\":[10]}",
"12": "{\"pos\":[3,-3],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[11,13],\"requires\":[11]}",
"13": "{\"pos\":[4,-4],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[12,14],\"requires\":[12]}",
"14": "{\"pos\":[5,-5],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[13,28],\"requires\":[13]}",
"16": "{\"pos\":[-2,2],\"type\":21,\"size\":\"Small\",\"name\":\"Shot Speed\",\"description\":[\"+0.01 shot speed\"],\"modifiers\":{\"shotSpeed\":0.01},\"adjacent\":[26,34],\"requires\":[26]}",
"21": "{\"pos\":[0,1],\"type\":23,\"size\":\"Small\",\"name\":\"Speed\",\"description\":[\"+0.01 speed\"],\"modifiers\":{\"speed\":0.01},\"adjacent\":[42,22],\"requires\":[42]}",
"22": "{\"pos\":[0,2],\"type\":23,\"size\":\"Small\",\"name\":\"Speed\",\"description\":[\"+0.01 speed\"],\"modifiers\":{\"speed\":0.01},\"adjacent\":[21,23],\"requires\":[21]}",
"23": "{\"pos\":[0,3],\"type\":23,\"size\":\"Small\",\"name\":\"Speed\",\"description\":[\"+0.01 speed\"],\"modifiers\":{\"speed\":0.01},\"adjacent\":[22,24],\"requires\":[22]}",
"24": "{\"pos\":[0,4],\"type\":23,\"size\":\"Small\",\"name\":\"Speed\",\"description\":[\"+0.01 speed\"],\"modifiers\":{\"speed\":0.01},\"adjacent\":[23,25],\"requires\":[23]}",
"25": "{\"pos\":[0,5],\"type\":29,\"size\":\"Med\",\"name\":\"Speed\",\"description\":[\"+0.04 speed\"],\"modifiers\":{\"speed\":0.04},\"adjacent\":[24],\"requires\":[24]}",
"26": "{\"pos\":[-1,1],\"type\":21,\"size\":\"Small\",\"name\":\"Shot Speed\",\"description\":[\"+0.01 shot speed\"],\"modifiers\":{\"shotSpeed\":0.01},\"adjacent\":[42,16],\"requires\":[42]}",
"28": "{\"pos\":[6,-6],\"type\":25,\"size\":\"Med\",\"name\":\"Luck\",\"description\":[\"+0.1 luck\"],\"modifiers\":{\"luck\":0.1},\"adjacent\":[14,113,65,77,49],\"requires\":[14]}",
"29": "{\"pos\":[0,-4],\"type\":26,\"size\":\"Med\",\"name\":\"Range\",\"description\":[\"+0.1 range\"],\"modifiers\":{\"range\":0.1},\"adjacent\":[7],\"requires\":[7]}",
"30": "{\"pos\":[1,1],\"type\":31,\"size\":\"Small\",\"name\":\"Tears\",\"description\":[\"+0.01 tears\"],\"modifiers\":{\"tears\":0.01},\"adjacent\":[42,33],\"requires\":[42]}",
"33": "{\"pos\":[2,2],\"type\":32,\"size\":\"Med\",\"name\":\"Tears\",\"description\":[\"+0.05 tears\"],\"modifiers\":{\"tears\":0.05},\"adjacent\":[30],\"requires\":[30]}",
"34": "{\"pos\":[-3,3],\"type\":21,\"size\":\"Small\",\"name\":\"Shot Speed\",\"description\":[\"+0.01 shot speed\"],\"modifiers\":{\"shotSpeed\":0.01},\"adjacent\":[16,35],\"requires\":[16]}",
"35": "{\"pos\":[-4,4],\"type\":27,\"size\":\"Med\",\"name\":\"Shot Speed\",\"description\":[\"+0.05 shot speed\"],\"modifiers\":{\"shotSpeed\":0.05},\"adjacent\":[34],\"requires\":[34]}",
"36": "{\"pos\":[-1,0],\"type\":22,\"size\":\"Small\",\"name\":\"Devil/Angel Rooms\",\"description\":[\"+0.25% chance for the devil/angel room to show up\"],\"modifiers\":{\"devilChance\":0.25},\"adjacent\":[42,37],\"requires\":[42]}",
"37": "{\"pos\":[-2,0],\"type\":22,\"size\":\"Small\",\"name\":\"Devil/Angel Rooms\",\"description\":[\"+0.25% chance for the devil/angel room to show up\"],\"modifiers\":{\"devilChance\":0.25},\"adjacent\":[36,38],\"requires\":[36]}",
"38": "{\"pos\":[-3,0],\"type\":22,\"size\":\"Small\",\"name\":\"Devil/Angel Rooms\",\"description\":[\"+0.25% chance for the devil/angel room to show up\"],\"modifiers\":{\"devilChance\":0.25},\"adjacent\":[37,39],\"requires\":[37]}",
"39": "{\"pos\":[-4,0],\"type\":22,\"size\":\"Small\",\"name\":\"Devil/Angel Rooms\",\"description\":[\"+0.25% chance for the devil/angel room to show up\"],\"modifiers\":{\"devilChance\":0.25},\"adjacent\":[38,40],\"requires\":[38]}",
"40": "{\"pos\":[-5,0],\"type\":22,\"size\":\"Small\",\"name\":\"Devil/Angel Rooms\",\"description\":[\"+0.25% chance for the devil/angel room to show up\"],\"modifiers\":{\"devilChance\":0.25},\"adjacent\":[39,41],\"requires\":[39]}",
"41": "{\"pos\":[-6,0],\"type\":28,\"size\":\"Med\",\"name\":\"Devil/Angel Rooms\",\"description\":[\"+1% chance for the devil/angel room to show up\"],\"modifiers\":{\"devilChance\":1},\"adjacent\":[40],\"requires\":[40]}",
"42": "{\"pos\":[0,0],\"type\":24,\"size\":\"Small\",\"name\":\"Damage\",\"description\":[\"+0.01 damage\"],\"modifiers\":{\"damage\":0.01},\"adjacent\":[36,26,21,30,5,2,43,10],\"requires\":[],\"alwaysAvailable\":true}",
"43": "{\"pos\":[1,0],\"type\":33,\"size\":\"Small\",\"name\":\"Mapping Chance\",\"description\":[\"+1% chance for the map to be revealed upon entering a floor\",\"Works from the second floor onwards\"],\"modifiers\":{\"mapChance\":1},\"adjacent\":[42,44],\"requires\":[42]}",
"44": "{\"pos\":[2,0],\"type\":33,\"size\":\"Small\",\"name\":\"Mapping Chance\",\"description\":[\"+1% chance for the map to be revealed upon entering a floor\",\"Works from the second floor onwards\"],\"modifiers\":{\"mapChance\":1},\"adjacent\":[43,45],\"requires\":[43]}",
"45": "{\"pos\":[3,0],\"type\":33,\"size\":\"Small\",\"name\":\"Mapping Chance\",\"description\":[\"+1% chance for the map to be revealed upon entering a floor\",\"Works from the second floor onwards\"],\"modifiers\":{\"mapChance\":1},\"adjacent\":[44,48],\"requires\":[44]}",
"47": "{\"pos\":[5,0],\"type\":34,\"size\":\"Med\",\"name\":\"Mapping Chance\",\"description\":[\"+4% chance for the map to be revealed upon entering a floor\",\"Works from the second floor onwards\"],\"modifiers\":{\"mapChance\":4},\"adjacent\":[48],\"requires\":[48]}",
"48": "{\"pos\":[4,0],\"type\":33,\"size\":\"Small\",\"name\":\"Mapping Chance\",\"description\":[\"+1% chance for the map to be revealed upon entering a floor\",\"Works from the second floor onwards\"],\"modifiers\":{\"mapChance\":1},\"adjacent\":[45,47],\"requires\":[45]}",
"49": "{\"pos\":[5,-7],\"type\":35,\"size\":\"Small\",\"name\":\"Coin Dupe Chance\",\"description\":[\"+0.5% chance for coin pickups to grant an additional coin\"],\"modifiers\":{\"coinDupe\":0.5},\"adjacent\":[28,55,50],\"requires\":[28]}",
"50": "{\"pos\":[4,-8],\"type\":35,\"size\":\"Small\",\"name\":\"Coin Dupe Chance\",\"description\":[\"+0.5% chance for coin pickups to grant an additional coin\"],\"modifiers\":{\"coinDupe\":0.5},\"adjacent\":[49,51],\"requires\":[49]}",
"51": "{\"pos\":[3,-9],\"type\":35,\"size\":\"Small\",\"name\":\"Coin Dupe Chance\",\"description\":[\"+0.5% chance for coin pickups to grant an additional coin\"],\"modifiers\":{\"coinDupe\":0.5},\"adjacent\":[50,60,52],\"requires\":[50]}",
"52": "{\"pos\":[2,-10],\"type\":35,\"size\":\"Small\",\"name\":\"Coin Dupe Chance\",\"description\":[\"+0.5% chance for coin pickups to grant an additional coin\"],\"modifiers\":{\"coinDupe\":0.5},\"adjacent\":[51,53],\"requires\":[51]}",
"53": "{\"pos\":[1,-11],\"type\":35,\"size\":\"Small\",\"name\":\"Coin Dupe Chance\",\"description\":[\"+0.5% chance for coin pickups to grant an additional coin\"],\"modifiers\":{\"coinDupe\":0.5},\"adjacent\":[52,54,90],\"requires\":[52]}",
"54": "{\"pos\":[0,-12],\"type\":36,\"size\":\"Med\",\"name\":\"Coin Dupe Chance\",\"description\":[\"+1% chance for coin pickups to grant an additional coin\"],\"modifiers\":{\"coinDupe\":1},\"adjacent\":[53],\"requires\":[53]}",
"55": "{\"pos\":[5,-8],\"type\":37,\"size\":\"Small\",\"name\":\"Key Dupe Chance\",\"description\":[\"+0.25% chance for key pickups to grant an additional key\"],\"modifiers\":{\"keyDupe\":0.25},\"adjacent\":[49,56],\"requires\":[49]}",
"56": "{\"pos\":[5,-9],\"type\":37,\"size\":\"Small\",\"name\":\"Key Dupe Chance\",\"description\":[\"+0.25% chance for key pickups to grant an additional key\"],\"modifiers\":{\"keyDupe\":0.25},\"adjacent\":[55,57],\"requires\":[55]}",
"57": "{\"pos\":[5,-10],\"type\":37,\"size\":\"Small\",\"name\":\"Key Dupe Chance\",\"description\":[\"+0.25% chance for key pickups to grant an additional key\"],\"modifiers\":{\"keyDupe\":0.25},\"adjacent\":[56,58],\"requires\":[56]}",
"58": "{\"pos\":[5,-11],\"type\":37,\"size\":\"Small\",\"name\":\"Key Dupe Chance\",\"description\":[\"+0.25% chance for key pickups to grant an additional key\"],\"modifiers\":{\"keyDupe\":0.25},\"adjacent\":[57,59],\"requires\":[57]}",
"59": "{\"pos\":[5,-12],\"type\":38,\"size\":\"Med\",\"name\":\"Key Dupe Chance\",\"description\":[\"+1% chance for key pickups to grant an additional key\"],\"modifiers\":{\"keyDupe\":1},\"adjacent\":[58],\"requires\":[58]}",
"60": "{\"pos\":[2,-9],\"type\":39,\"size\":\"Small\",\"name\":\"Bomb Dupe Chance\",\"description\":[\"+0.25% chance for bomb pickups to grant an additional bomb\"],\"modifiers\":{\"bombDupe\":0.25},\"adjacent\":[51,61],\"requires\":[51]}",
"61": "{\"pos\":[1,-9],\"type\":39,\"size\":\"Small\",\"name\":\"Bomb Dupe Chance\",\"description\":[\"+0.25% chance for bomb pickups to grant an additional bomb\"],\"modifiers\":{\"bombDupe\":0.25},\"adjacent\":[60,62],\"requires\":[60]}",
"62": "{\"pos\":[0,-9],\"type\":39,\"size\":\"Small\",\"name\":\"Bomb Dupe Chance\",\"description\":[\"+0.25% chance for bomb pickups to grant an additional bomb\"],\"modifiers\":{\"bombDupe\":0.25},\"adjacent\":[61,63],\"requires\":[61]}",
"63": "{\"pos\":[-1,-9],\"type\":39,\"size\":\"Small\",\"name\":\"Bomb Dupe Chance\",\"description\":[\"+0.25% chance for bomb pickups to grant an additional bomb\"],\"modifiers\":{\"bombDupe\":0.25},\"adjacent\":[62,64],\"requires\":[62]}",
"64": "{\"pos\":[-2,-9],\"type\":40,\"size\":\"Med\",\"name\":\"Bomb Dupe Chance\",\"description\":[\"+1% chance for bomb pickups to grant an additional bomb\"],\"modifiers\":{\"bombDupe\":1},\"adjacent\":[63],\"requires\":[63]}",
"65": "{\"pos\":[7,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[28,66],\"requires\":[28]}",
"66": "{\"pos\":[8,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[65,67],\"requires\":[65]}",
"67": "{\"pos\":[9,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[66,68],\"requires\":[66]}",
"68": "{\"pos\":[10,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[67,69],\"requires\":[67]}",
"69": "{\"pos\":[11,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[68,70],\"requires\":[68]}",
"70": "{\"pos\":[12,-6],\"type\":170,\"size\":\"Med\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+1% to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStatPerc\":1},\"adjacent\":[69,130],\"requires\":[69]}",
"77": "{\"pos\":[7,-7],\"type\":164,\"size\":\"Small\",\"name\":\"Devil/Angel/Boss Item Stat\",\"description\":[\"+0.02 to a random stat when first obtaining a devil, angel or boss room item.\"],\"modifiers\":{\"devilAngelBossItemStat\":0.02},\"adjacent\":[28,78],\"requires\":[28]}",
"78": "{\"pos\":[8,-8],\"type\":164,\"size\":\"Small\",\"name\":\"Devil/Angel/Boss Item Stat\",\"description\":[\"+0.02 to a random stat when first obtaining a devil, angel or boss room item.\"],\"modifiers\":{\"devilAngelBossItemStat\":0.02},\"adjacent\":[77,79],\"requires\":[77]}",
"79": "{\"pos\":[9,-9],\"type\":164,\"size\":\"Small\",\"name\":\"Devil/Angel/Boss Item Stat\",\"description\":[\"+0.02 to a random stat when first obtaining a devil, angel or boss room item.\"],\"modifiers\":{\"devilAngelBossItemStat\":0.02},\"adjacent\":[78,81],\"requires\":[78]}",
"81": "{\"pos\":[10,-10],\"type\":164,\"size\":\"Small\",\"name\":\"Devil/Angel/Boss Item Stat\",\"description\":[\"+0.02 to a random stat when first obtaining a devil, angel or boss room item.\"],\"modifiers\":{\"devilAngelBossItemStat\":0.02},\"adjacent\":[79,82],\"requires\":[79]}",
"82": "{\"pos\":[11,-11],\"type\":164,\"size\":\"Small\",\"name\":\"Devil/Angel/Boss Item Stat\",\"description\":[\"+0.02 to a random stat when first obtaining a devil, angel or boss room item.\"],\"modifiers\":{\"devilAngelBossItemStat\":0.02},\"adjacent\":[81,83],\"requires\":[81]}",
"83": "{\"pos\":[12,-12],\"type\":171,\"size\":\"Med\",\"name\":\"Devil/Angel/Boss Item Stat\",\"description\":[\"+1% to a random stat when first obtaining a devil, angel or boss room item.\"],\"modifiers\":{\"devilAngelBossItemStatPerc\":1},\"adjacent\":[82],\"requires\":[82]}",
"90": "{\"pos\":[1,-12],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[53,91],\"requires\":[53]}",
"91": "{\"pos\":[1,-13],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[90,92],\"requires\":[90]}",
"92": "{\"pos\":[1,-14],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[91,93],\"requires\":[91]}",
"93": "{\"pos\":[1,-15],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[92,94],\"requires\":[92]}",
"94": "{\"pos\":[1,-16],\"type\":168,\"size\":\"Med\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"60% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":60},\"adjacent\":[93,95,103],\"requires\":[93]}",
"95": "{\"pos\":[0,-16],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[94,100],\"requires\":[94]}",
"96": "{\"pos\":[-1,-16],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[100,102],\"requires\":[100]}",
"100": "{\"pos\":[-1,-15],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[95,96],\"requires\":[95]}",
"101": "{\"pos\":[-2,-16],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[102,112],\"requires\":[102]}",
"102": "{\"pos\":[-1,-17],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[96,101],\"requires\":[96]}",
"103": "{\"pos\":[2,-16],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[94,104],\"requires\":[94]}",
"104": "{\"pos\":[3,-17],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[103,105],\"requires\":[103]}",
"105": "{\"pos\":[3,-16],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[104,106],\"requires\":[104]}",
"106": "{\"pos\":[3,-15],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[105,107],\"requires\":[105]}",
"107": "{\"pos\":[4,-16],\"type\":166,\"size\":\"Small\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"10% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":10},\"adjacent\":[106,171],\"requires\":[106]}",
"112": "{\"pos\":[-3,-16],\"type\":168,\"size\":\"Med\",\"name\":\"Additional Coin/Key/Bomb\",\"description\":[\"60% chance to start with an additional coin, key or bomb.\"],\"modifiers\":{\"startCoinKeyBomb\":60},\"adjacent\":[101],\"requires\":[101]}",
"113": "{\"pos\":[7,-5],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[28,114],\"requires\":[28]}",
"114": "{\"pos\":[8,-4],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[113,115],\"requires\":[113]}",
"115": "{\"pos\":[9,-3],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[114,116],\"requires\":[114]}",
"116": "{\"pos\":[10,-2],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[115,117],\"requires\":[115]}",
"117": "{\"pos\":[11,-1],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[116,118],\"requires\":[116]}",
"118": "{\"pos\":[12,0],\"type\":172,\"size\":\"Med\",\"name\":\"Passive Item Luck\",\"description\":[\"-1% to +1% luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuckPerc\":1},\"adjacent\":[117,141],\"requires\":[117]}",
"130": "{\"pos\":[13,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[70,135],\"requires\":[70]}",
"135": "{\"pos\":[14,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[130,136],\"requires\":[130]}",
"136": "{\"pos\":[15,-7],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[135,138],\"requires\":[135]}",
"137": "{\"pos\":[15,-5],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[138,146],\"requires\":[138]}",
"138": "{\"pos\":[16,-6],\"type\":163,\"size\":\"Small\",\"name\":\"Treasure/Shop Item Stat\",\"description\":[\"+0.01 to a random stat when first obtaining a treasure room or shop item.\"],\"modifiers\":{\"treasureShopItemStat\":0.01},\"adjacent\":[136,137],\"requires\":[136]}",
"140": "{\"pos\":[16,0],\"type\":161,\"size\":\"Large\",\"name\":\"Sporadic Growth\",\"description\":[\"When starting a run, apply +1% to a random stat 6 times.\",\"When entering a floor past the first, apply +1% to a random stat 2 times.\"],\"modifiers\":{\"sporadicGrowth\":true},\"adjacent\":[145,153],\"requires\":[145]}",
"141": "{\"pos\":[13,0],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[118,142],\"requires\":[118]}",
"142": "{\"pos\":[14,-1],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[141,143],\"requires\":[141]}",
"143": "{\"pos\":[14,0],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[142,144],\"requires\":[142]}",
"144": "{\"pos\":[14,1],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[143,145],\"requires\":[143]}",
"145": "{\"pos\":[15,0],\"type\":165,\"size\":\"Small\",\"name\":\"Passive Item Luck\",\"description\":[\"-0.02 to +0.02 luck when first obtaining any passive item.\"],\"modifiers\":{\"itemRandLuck\":0.02},\"adjacent\":[144,140],\"requires\":[144]}",
"146": "{\"pos\":[15,-6],\"type\":162,\"size\":\"Large\",\"name\":\"Starblessed\",\"description\":[\"Start with an additional random item from the treasure room pool.\",\"First floor's boss drops an additional XVII - The Stars card.\"],\"modifiers\":{\"starblessed\":true},\"adjacent\":[137],\"requires\":[137]}",
"148": "{\"pos\":[17,0],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[153,154],\"requires\":[153]}",
"149": "{\"pos\":[18,-1],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[154,155],\"requires\":[154]}",
"150": "{\"pos\":[18,0],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[151],\"requires\":[151]}",
"151": "{\"pos\":[18,1],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[156,150],\"requires\":[156]}",
"152": "{\"pos\":[19,0],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[155,156],\"requires\":[155]}",
"153": "{\"pos\":[17,1],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[140,148],\"requires\":[140]}",
"154": "{\"pos\":[17,-1],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[148,149],\"requires\":[148]}",
"155": "{\"pos\":[19,-1],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[149,152],\"requires\":[149]}",
"156": "{\"pos\":[19,1],\"type\":173,\"size\":\"Small\",\"name\":\"Trinket Luck\",\"description\":[\"-0.01 to +0.01 luck when first obtaining any trinket.\"],\"modifiers\":{\"trinketRandLuck\":0.01},\"adjacent\":[152,151],\"requires\":[152]}",
"166": "{\"pos\":[6,-16],\"type\":167,\"size\":\"Small\",\"name\":\"Eden's Blessing Spawn\",\"description\":[\"1% chance for Eden's Blessing to spawn at the beginning of a floor, starting from the second floor.\",\"Can only happen once per run.\"],\"modifiers\":{\"edenBlessingSpawn\":1},\"adjacent\":[167,171],\"requires\":[171]}",
"167": "{\"pos\":[7,-17],\"type\":167,\"size\":\"Small\",\"name\":\"Eden's Blessing Spawn\",\"description\":[\"1% chance for Eden's Blessing to spawn at the beginning of a floor, starting from the second floor.\",\"Can only happen once per run.\"],\"modifiers\":{\"edenBlessingSpawn\":1},\"adjacent\":[166,168],\"requires\":[166]}",
"168": "{\"pos\":[8,-16],\"type\":167,\"size\":\"Small\",\"name\":\"Eden's Blessing Spawn\",\"description\":[\"1% chance for Eden's Blessing to spawn at the beginning of a floor, starting from the second floor.\",\"Can only happen once per run.\"],\"modifiers\":{\"edenBlessingSpawn\":1},\"adjacent\":[167,169],\"requires\":[167]}",
"169": "{\"pos\":[7,-15],\"type\":167,\"size\":\"Small\",\"name\":\"Eden's Blessing Spawn\",\"description\":[\"1% chance for Eden's Blessing to spawn at the beginning of a floor, starting from the second floor.\",\"Can only happen once per run.\"],\"modifiers\":{\"edenBlessingSpawn\":1},\"adjacent\":[168,170],\"requires\":[168]}",
"170": "{\"pos\":[7,-16],\"type\":169,\"size\":\"Med\",\"name\":\"Eden's Blessing Spawn\",\"description\":[\"4% chance for Eden's Blessing to spawn at the beginning of a floor, starting from the second floor.\",\"Can only happen once per run.\"],\"modifiers\":{\"edenBlessingSpawn\":4},\"adjacent\":[169],\"requires\":[169]}",
"171": "{\"pos\":[5,-16],\"type\":160,\"size\":\"Large\",\"name\":\"Chaotic Treasury\",\"description\":[\"First floor's treasure room contains an additional Chaos item pedestal.\",\"While you have Chaos, treasure rooms spawn an additional item.\",\"Grabbing an item in a treasure room removes all other items in the room.\"],\"modifiers\":{\"chaoticTreasury\":true},\"adjacent\":[107,166],\"requires\":[107]}"
}
]])