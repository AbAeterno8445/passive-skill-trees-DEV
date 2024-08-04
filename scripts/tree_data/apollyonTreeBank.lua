local json = require("json")

PST.nodeLinks["Apollyon"] = {}
PST.trees["Apollyon"] = json.decode([[
{
"1": "{\"pos\":[-1,-1],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[2,178],\"requires\":[178]}",
"2": "{\"pos\":[-2,-2],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[1,3],\"requires\":[1]}",
"3": "{\"pos\":[-2,-3],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[2,9,33],\"requires\":[2,33]}",
"9": "{\"pos\":[-2,-4],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[3,18],\"requires\":[3]}",
"18": "{\"pos\":[-1,-5],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[9,19],\"requires\":[9]}",
"19": "{\"pos\":[-1,-6],\"type\":\"[Apollyon's Tree] Med1\",\"size\":\"Med\",\"name\":\"Void Blue Flies\",\"description\":[\"5% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":5},\"adjacent\":[18,20,46,46,202],\"requires\":[18,46]}",
"20": "{\"pos\":[-1,-7],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[19,21],\"requires\":[19]}",
"21": "{\"pos\":[-2,-8],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[20,22],\"requires\":[20]}",
"22": "{\"pos\":[-2,-9],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[21,23,38],\"requires\":[21,38]}",
"23": "{\"pos\":[-2,-10],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[22,24],\"requires\":[22]}",
"24": "{\"pos\":[-1,-11],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[23,25],\"requires\":[23]}",
"25": "{\"pos\":[-1,-12],\"type\":\"[Apollyon's Tree] Med1\",\"size\":\"Med\",\"name\":\"Void Blue Flies\",\"description\":[\"5% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":5},\"adjacent\":[24,26,47,47,199],\"requires\":[24]}",
"26": "{\"pos\":[-1,-13],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[25,27],\"requires\":[25]}",
"27": "{\"pos\":[-2,-14],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[26,28],\"requires\":[26]}",
"28": "{\"pos\":[-2,-15],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[27,29,43],\"requires\":[27,43]}",
"29": "{\"pos\":[-2,-16],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[28,30],\"requires\":[28]}",
"30": "{\"pos\":[-1,-17],\"type\":\"[Apollyon's Tree] Small1\",\"size\":\"Small\",\"name\":\"Void Blue Flies\",\"description\":[\"1% chance for Void to spawn 4 blue flies on use.\"],\"modifiers\":{\"voidBlueFlies\":1},\"adjacent\":[29,67],\"requires\":[29]}",
"31": "{\"pos\":[0,-1],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[32,178],\"requires\":[178]}",
"32": "{\"pos\":[0,-2],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[31,33],\"requires\":[31]}",
"33": "{\"pos\":[0,-3],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[32,34,3,182],\"requires\":[32]}",
"34": "{\"pos\":[0,-4],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[33,35],\"requires\":[33]}",
"35": "{\"pos\":[0,-5],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[34,46],\"requires\":[34]}",
"36": "{\"pos\":[0,-7],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[46,37],\"requires\":[46]}",
"37": "{\"pos\":[0,-8],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[36,38],\"requires\":[36]}",
"38": "{\"pos\":[0,-9],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[37,39,22,187],\"requires\":[37]}",
"39": "{\"pos\":[0,-10],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[38,40],\"requires\":[38]}",
"40": "{\"pos\":[0,-11],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[39,47],\"requires\":[39]}",
"41": "{\"pos\":[0,-13],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[47,42],\"requires\":[47]}",
"42": "{\"pos\":[0,-14],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[41,43],\"requires\":[41]}",
"43": "{\"pos\":[0,-15],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[42,44,28,192],\"requires\":[42]}",
"44": "{\"pos\":[0,-16],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[43,45],\"requires\":[43]}",
"45": "{\"pos\":[0,-17],\"type\":\"[Apollyon's Tree] Small2\",\"size\":\"Small\",\"name\":\"Void Blue Spiders\",\"description\":[\"1% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":1},\"adjacent\":[44,67],\"requires\":[44]}",
"46": "{\"pos\":[0,-6],\"type\":\"[Apollyon's Tree] Med2\",\"size\":\"Med\",\"name\":\"Void Blue Spiders\",\"description\":[\"5% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":5},\"adjacent\":[35,36,19,19],\"requires\":[35,19]}",
"47": "{\"pos\":[0,-12],\"type\":\"[Apollyon's Tree] Med2\",\"size\":\"Med\",\"name\":\"Void Blue Spiders\",\"description\":[\"5% chance for Void to spawn 3 blue spiders on use.\"],\"modifiers\":{\"voidBlueSpiders\":5},\"adjacent\":[40,41,25,25],\"requires\":[40,25,25]}",
"67": "{\"pos\":[0,-18],\"type\":\"[Apollyon's Tree] Apollyon's Blessing\",\"size\":\"Large\",\"name\":\"Apollyon's Blessing\",\"description\":[\"40% chance to keep half of the charge when using Void.\",\"Cannot be cursed with Curse of the Blind.\"],\"modifiers\":{\"apollyonBlessing\":true},\"adjacent\":[45,30,194],\"requires\":[45,30,194]}",
"104": "{\"pos\":[0,1],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[105,178],\"requires\":[178]}",
"105": "{\"pos\":[0,2],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[104,106],\"requires\":[104]}",
"106": "{\"pos\":[0,3],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[105,114,116,117],\"requires\":[105]}",
"113": "{\"pos\":[-1,1],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[114],\"requires\":[114]}",
"114": "{\"pos\":[-1,2],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[106,113],\"requires\":[106]}",
"115": "{\"pos\":[1,1],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[116],\"requires\":[116]}",
"116": "{\"pos\":[1,2],\"type\":\"[Apollyon's Tree] Small5\",\"size\":\"Small\",\"name\":\"Locusts Luck\",\"description\":[\"+0.02 luck while holding a locust. Consuming a locust grants a permanent +0.01 luck instead.\"],\"modifiers\":{\"locustHeldLuck\":0.02,\"locustConsumedLuck\":0.01},\"adjacent\":[106,115],\"requires\":[106]}",
"117": "{\"pos\":[0,4],\"type\":\"Med Luck\",\"size\":\"Med\",\"name\":\"Luck\",\"description\":[\"+0.1 luck\"],\"modifiers\":{\"luck\":0.1},\"adjacent\":[106,118],\"requires\":[106]}",
"118": "{\"pos\":[0,5],\"type\":\"[Apollyon's Tree] Small6\",\"size\":\"Small\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+0.5% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":0.5},\"adjacent\":[117,128,124],\"requires\":[117]}",
"124": "{\"pos\":[0,7],\"type\":\"[Apollyon's Tree] Small7\",\"size\":\"Small\",\"name\":\"Locust of Death Boon\",\"description\":[\"+0.5% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":0.5},\"adjacent\":[118,135,125],\"requires\":[118]}",
"125": "{\"pos\":[0,9],\"type\":\"[Apollyon's Tree] Small8\",\"size\":\"Small\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+0.5% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":0.5},\"adjacent\":[124,141,126],\"requires\":[124]}",
"126": "{\"pos\":[0,11],\"type\":\"[Apollyon's Tree] Small9\",\"size\":\"Small\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+0.5% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":0.5},\"adjacent\":[125,147,127],\"requires\":[125]}",
"127": "{\"pos\":[0,13],\"type\":\"[Apollyon's Tree] Small10\",\"size\":\"Small\",\"name\":\"Locust of War Boon\",\"description\":[\"+0.5% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":0.5},\"adjacent\":[126,153,163],\"requires\":[126]}",
"128": "{\"pos\":[1,5],\"type\":\"[Apollyon's Tree] Small6\",\"size\":\"Small\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+0.5% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":0.5},\"adjacent\":[118,129],\"requires\":[118]}",
"129": "{\"pos\":[2,5],\"type\":\"[Apollyon's Tree] Small6\",\"size\":\"Small\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+0.5% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":0.5},\"adjacent\":[128,130],\"requires\":[128]}",
"130": "{\"pos\":[3,5],\"type\":\"[Apollyon's Tree] Small6\",\"size\":\"Small\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+0.5% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":0.5},\"adjacent\":[129,131],\"requires\":[129]}",
"131": "{\"pos\":[4,6],\"type\":\"[Apollyon's Tree] Small6\",\"size\":\"Small\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+0.5% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":0.5},\"adjacent\":[130,133],\"requires\":[130]}",
"133": "{\"pos\":[5,6],\"type\":\"[Apollyon's Tree] Small6\",\"size\":\"Small\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+0.5% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":0.5},\"adjacent\":[131,134],\"requires\":[131]}",
"134": "{\"pos\":[6,6],\"type\":\"[Apollyon's Tree] Med5\",\"size\":\"Med\",\"name\":\"Locust of Conquest Boon\",\"description\":[\"+2% speed per Locust of Conquest held/consumed, up to 15%.\"],\"modifiers\":{\"locustConquestSpeed\":2},\"adjacent\":[133,168],\"requires\":[133]}",
"135": "{\"pos\":[-1,7],\"type\":\"[Apollyon's Tree] Small7\",\"size\":\"Small\",\"name\":\"Locust of Death Boon\",\"description\":[\"+0.5% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":0.5},\"adjacent\":[124,136],\"requires\":[124]}",
"136": "{\"pos\":[-2,7],\"type\":\"[Apollyon's Tree] Small7\",\"size\":\"Small\",\"name\":\"Locust of Death Boon\",\"description\":[\"+0.5% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":0.5},\"adjacent\":[135,137],\"requires\":[135]}",
"137": "{\"pos\":[-3,7],\"type\":\"[Apollyon's Tree] Small7\",\"size\":\"Small\",\"name\":\"Locust of Death Boon\",\"description\":[\"+0.5% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":0.5},\"adjacent\":[136,138],\"requires\":[136]}",
"138": "{\"pos\":[-4,8],\"type\":\"[Apollyon's Tree] Small7\",\"size\":\"Small\",\"name\":\"Locust of Death Boon\",\"description\":[\"+0.5% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":0.5},\"adjacent\":[137,139],\"requires\":[137]}",
"139": "{\"pos\":[-5,8],\"type\":\"[Apollyon's Tree] Small7\",\"size\":\"Small\",\"name\":\"Locust of Death Boon\",\"description\":[\"+0.5% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":0.5},\"adjacent\":[138,140],\"requires\":[138]}",
"140": "{\"pos\":[-6,8],\"type\":\"[Apollyon's Tree] Med6\",\"size\":\"Med\",\"name\":\"Locust of Death Boon\",\"description\":[\"+2% tears per Locust of Death held/consumed, up to 15%.\"],\"modifiers\":{\"deathLocustTears\":2},\"adjacent\":[139,174],\"requires\":[139]}",
"141": "{\"pos\":[1,9],\"type\":\"[Apollyon's Tree] Small8\",\"size\":\"Small\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+0.5% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":0.5},\"adjacent\":[125,142],\"requires\":[125]}",
"142": "{\"pos\":[2,9],\"type\":\"[Apollyon's Tree] Small8\",\"size\":\"Small\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+0.5% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":0.5},\"adjacent\":[141,143],\"requires\":[141]}",
"143": "{\"pos\":[3,9],\"type\":\"[Apollyon's Tree] Small8\",\"size\":\"Small\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+0.5% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":0.5},\"adjacent\":[142,144],\"requires\":[142]}",
"144": "{\"pos\":[4,10],\"type\":\"[Apollyon's Tree] Small8\",\"size\":\"Small\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+0.5% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":0.5},\"adjacent\":[143,145],\"requires\":[143]}",
"145": "{\"pos\":[5,10],\"type\":\"[Apollyon's Tree] Small8\",\"size\":\"Small\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+0.5% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":0.5},\"adjacent\":[144,146],\"requires\":[144]}",
"146": "{\"pos\":[6,10],\"type\":\"[Apollyon's Tree] Med7\",\"size\":\"Med\",\"name\":\"Locust of Famine Boon\",\"description\":[\"+2% range and shot speed per Locust of Famine held/consumed, up to 15%.\"],\"modifiers\":{\"famineLocustRangeShotspeed\":2},\"adjacent\":[145,176],\"requires\":[145]}",
"147": "{\"pos\":[-1,11],\"type\":\"[Apollyon's Tree] Small9\",\"size\":\"Small\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+0.5% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":0.5},\"adjacent\":[126,148],\"requires\":[126]}",
"148": "{\"pos\":[-2,11],\"type\":\"[Apollyon's Tree] Small9\",\"size\":\"Small\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+0.5% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":0.5},\"adjacent\":[147,149],\"requires\":[147]}",
"149": "{\"pos\":[-3,11],\"type\":\"[Apollyon's Tree] Small9\",\"size\":\"Small\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+0.5% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":0.5},\"adjacent\":[148,150],\"requires\":[148]}",
"150": "{\"pos\":[-4,12],\"type\":\"[Apollyon's Tree] Small9\",\"size\":\"Small\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+0.5% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":0.5},\"adjacent\":[149,151],\"requires\":[149]}",
"151": "{\"pos\":[-5,12],\"type\":\"[Apollyon's Tree] Small9\",\"size\":\"Small\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+0.5% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":0.5},\"adjacent\":[150,152],\"requires\":[150]}",
"152": "{\"pos\":[-6,12],\"type\":\"[Apollyon's Tree] Med8\",\"size\":\"Med\",\"name\":\"Locust of Pestilence Boon\",\"description\":[\"+2% luck per Locust of Pestilence held/consumed, up to 15%.\"],\"modifiers\":{\"pestilenceLocustLuck\":2},\"adjacent\":[151,172],\"requires\":[151]}",
"153": "{\"pos\":[1,13],\"type\":\"[Apollyon's Tree] Small10\",\"size\":\"Small\",\"name\":\"Locust of War Boon\",\"description\":[\"+0.5% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":0.5},\"adjacent\":[127,154],\"requires\":[127]}",
"154": "{\"pos\":[2,13],\"type\":\"[Apollyon's Tree] Small10\",\"size\":\"Small\",\"name\":\"Locust of War Boon\",\"description\":[\"+0.5% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":0.5},\"adjacent\":[153,155],\"requires\":[153]}",
"155": "{\"pos\":[3,13],\"type\":\"[Apollyon's Tree] Small10\",\"size\":\"Small\",\"name\":\"Locust of War Boon\",\"description\":[\"+0.5% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":0.5},\"adjacent\":[154,156],\"requires\":[154]}",
"156": "{\"pos\":[4,14],\"type\":\"[Apollyon's Tree] Small10\",\"size\":\"Small\",\"name\":\"Locust of War Boon\",\"description\":[\"+0.5% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":0.5},\"adjacent\":[155,157],\"requires\":[155]}",
"157": "{\"pos\":[5,14],\"type\":\"[Apollyon's Tree] Small10\",\"size\":\"Small\",\"name\":\"Locust of War Boon\",\"description\":[\"+0.5% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":0.5},\"adjacent\":[156,158],\"requires\":[156]}",
"158": "{\"pos\":[6,14],\"type\":\"[Apollyon's Tree] Med9\",\"size\":\"Med\",\"name\":\"Locust of War Boon\",\"description\":[\"+2% damage per Locust of War held/consumed, up to 15%.\"],\"modifiers\":{\"warLocustDamage\":2},\"adjacent\":[157,170],\"requires\":[157]}",
"163": "{\"pos\":[0,15],\"type\":\"[Isaac Tree] Small2\",\"size\":\"Small\",\"name\":\"All Stats\",\"description\":[\"+0.01 all stats\"],\"modifiers\":{\"allstats\":0.01},\"adjacent\":[127,167],\"requires\":[127]}",
"164": "{\"pos\":[-1,16],\"type\":\"[Isaac Tree] Small2\",\"size\":\"Small\",\"name\":\"All Stats\",\"description\":[\"+0.01 all stats\"],\"modifiers\":{\"allstats\":0.01},\"adjacent\":[167],\"requires\":[167]}",
"165": "{\"pos\":[0,17],\"type\":\"[Isaac Tree] Small2\",\"size\":\"Small\",\"name\":\"All Stats\",\"description\":[\"+0.01 all stats\"],\"modifiers\":{\"allstats\":0.01},\"adjacent\":[167],\"requires\":[167]}",
"166": "{\"pos\":[1,16],\"type\":\"[Isaac Tree] Small2\",\"size\":\"Small\",\"name\":\"All Stats\",\"description\":[\"+0.01 all stats\"],\"modifiers\":{\"allstats\":0.01},\"adjacent\":[167],\"requires\":[167]}",
"167": "{\"pos\":[0,16],\"type\":\"[Apollyon's Tree] Harbinger Locusts\",\"size\":\"Large\",\"name\":\"Harbinger Locusts\",\"description\":[\"Spawn a random locust trinket in the second floor you enter.\",\"Spawn a random locust trinket after defeating Mom.\",\"2% chance to replace any non-locust trinket drop with a random locust trinket. Defeating a boss\",\"increases this chance by 1%, up to 10%.\",\"Using void consumes all locust trinkets dropped in the room, applying their\",\"effects to you passively.\"],\"modifiers\":{\"harbingerLocusts\":true},\"adjacent\":[163,164,165,166],\"requires\":[163]}",
"168": "{\"pos\":[7,7],\"type\":\"Small Speed\",\"size\":\"Small\",\"name\":\"Speed\",\"description\":[\"+0.01 speed\"],\"modifiers\":{\"speed\":0.01},\"adjacent\":[134,169],\"requires\":[134]}",
"169": "{\"pos\":[8,7],\"type\":\"Med Speed\",\"size\":\"Med\",\"name\":\"Speed\",\"description\":[\"+0.04 speed\"],\"modifiers\":{\"speed\":0.04},\"adjacent\":[168],\"requires\":[168]}",
"170": "{\"pos\":[7,15],\"type\":\"Small Damage\",\"size\":\"Small\",\"name\":\"Damage\",\"description\":[\"+0.01 damage\"],\"modifiers\":{\"damage\":0.01},\"adjacent\":[158,171],\"requires\":[158]}",
"171": "{\"pos\":[8,15],\"type\":\"Med Damage\",\"size\":\"Med\",\"name\":\"Damage\",\"description\":[\"+0.05 damage\"],\"modifiers\":{\"damage\":0.05},\"adjacent\":[170],\"requires\":[170]}",
"172": "{\"pos\":[-7,13],\"type\":\"Small Luck\",\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[152,173],\"requires\":[152]}",
"173": "{\"pos\":[-8,13],\"type\":\"Med Luck\",\"size\":\"Med\",\"name\":\"Luck\",\"description\":[\"+0.1 luck\"],\"modifiers\":{\"luck\":0.1},\"adjacent\":[172],\"requires\":[172]}",
"174": "{\"pos\":[-7,9],\"type\":\"Small Tears\",\"size\":\"Small\",\"name\":\"Tears\",\"description\":[\"+0.01 tears\"],\"modifiers\":{\"tears\":0.01},\"adjacent\":[140,175],\"requires\":[140]}",
"175": "{\"pos\":[-8,9],\"type\":\"Med Tears\",\"size\":\"Med\",\"name\":\"Tears\",\"description\":[\"+0.05 tears\"],\"modifiers\":{\"tears\":0.05},\"adjacent\":[174],\"requires\":[174]}",
"176": "{\"pos\":[7,11],\"type\":\"Small Range\",\"size\":\"Small\",\"name\":\"Range\",\"description\":[\"+0.02 range\"],\"modifiers\":{\"range\":0.02},\"adjacent\":[146,177],\"requires\":[146]}",
"177": "{\"pos\":[8,11],\"type\":\"Med Range\",\"size\":\"Med\",\"name\":\"Range\",\"description\":[\"+0.1 range\"],\"modifiers\":{\"range\":0.1},\"adjacent\":[176],\"requires\":[176]}",
"178": "{\"pos\":[0,0],\"type\":\"Small Luck\",\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[104,1,31,180],\"requires\":[],\"alwaysAvailable\":true}",
"179": "{\"pos\":[8,-14],\"type\":\"[Apollyon's Tree] Null\",\"size\":\"Large\",\"name\":\"Null\",\"description\":[\"When entering a floor, if Void hasn't absorbed any active items, gain +5% all stats, up to 15%.\",\"If Void has absorbed active items, 50% chance to gain an extra charge when clearing a room.\",\"-10% all stats while not holding Void.\"],\"modifiers\":{\"null\":true},\"adjacent\":[214],\"requires\":[214]}",
        "180": "{\"pos\":[1,-1],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[178,181],\"requires\":[178]}",
        "181": "{\"pos\":[2,-2],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[180,182],\"requires\":[180]}",
        "182": "{\"pos\":[2,-3],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[181,183,33],\"requires\":[181,33]}",
        "183": "{\"pos\":[2,-4],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[182,184],\"requires\":[182]}",
        "184": "{\"pos\":[1,-5],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[183,197],\"requires\":[183]}",
        "185": "{\"pos\":[1,-7],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[197,186],\"requires\":[197]}",
        "186": "{\"pos\":[2,-8],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[185,187],\"requires\":[185]}",
        "187": "{\"pos\":[2,-9],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[186,188,38],\"requires\":[186,38]}",
        "188": "{\"pos\":[2,-10],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[187,189],\"requires\":[187]}",
        "189": "{\"pos\":[1,-11],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[188,198],\"requires\":[188]}",
        "190": "{\"pos\":[1,-13],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[198,191],\"requires\":[198]}",
        "191": "{\"pos\":[2,-14],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[190,192],\"requires\":[190]}",
        "192": "{\"pos\":[2,-15],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[191,193,43],\"requires\":[191,43]}",
        "193": "{\"pos\":[2,-16],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[192,194],\"requires\":[192]}",
        "194": "{\"pos\":[1,-17],\"type\":\"[Apollyon's Tree] Small3\",\"size\":\"Small\",\"name\":\"Void Annihilation\",\"description\":[\"4% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":4},\"adjacent\":[193,67],\"requires\":[193]}",
        "197": "{\"pos\":[1,-6],\"type\":\"[Apollyon's Tree] Med3\",\"size\":\"Med\",\"name\":\"Void Annihilation\",\"description\":[\"20% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":20},\"adjacent\":[184,185,205],\"requires\":[184]}",
        "198": "{\"pos\":[1,-12],\"type\":\"[Apollyon's Tree] Med3\",\"size\":\"Med\",\"name\":\"Void Annihilation\",\"description\":[\"20% chance for Void to instantly kill a random non-boss enemy in the room on use.\"],\"modifiers\":{\"voidAnnihilation\":20},\"adjacent\":[189,190,208],\"requires\":[189]}",
        "199": "{\"pos\":[-3,-12],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[25,200],\"requires\":[25]}",
        "200": "{\"pos\":[-4,-12],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[199,201],\"requires\":[199]}",
        "201": "{\"pos\":[-5,-12],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[200,211],\"requires\":[200]}",
        "202": "{\"pos\":[-3,-6],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[19,203],\"requires\":[19]}",
        "203": "{\"pos\":[-4,-6],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[202,204],\"requires\":[202]}",
        "204": "{\"pos\":[-5,-6],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[203,212],\"requires\":[203]}",
        "205": "{\"pos\":[3,-6],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[197,206],\"requires\":[197]}",
        "206": "{\"pos\":[4,-6],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[205,207],\"requires\":[205]}",
        "207": "{\"pos\":[5,-6],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[206,213],\"requires\":[206]}",
        "208": "{\"pos\":[3,-12],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[198,209],\"requires\":[198]}",
        "209": "{\"pos\":[4,-12],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[208,210],\"requires\":[208]}",
        "210": "{\"pos\":[5,-12],\"type\":\"[Apollyon's Tree] Small4\",\"size\":\"Small\",\"name\":\"First Floor Eraser\",\"description\":[\"1% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":1},\"adjacent\":[209,214],\"requires\":[209]}",
        "211": "{\"pos\":[-6,-12],\"type\":\"[Apollyon's Tree] Med4\",\"size\":\"Med\",\"name\":\"First Floor Eraser\",\"description\":[\"5% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":5},\"adjacent\":[201],\"requires\":[201]}",
        "212": "{\"pos\":[-6,-6],\"type\":\"[Apollyon's Tree] Med4\",\"size\":\"Med\",\"name\":\"First Floor Eraser\",\"description\":[\"5% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":5},\"adjacent\":[204],\"requires\":[204]}",
        "213": "{\"pos\":[6,-6],\"type\":\"[Apollyon's Tree] Med4\",\"size\":\"Med\",\"name\":\"First Floor Eraser\",\"description\":[\"5% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":5},\"adjacent\":[207],\"requires\":[207]}",
        "214": "{\"pos\":[6,-12],\"type\":\"[Apollyon's Tree] Med4\",\"size\":\"Med\",\"name\":\"First Floor Eraser\",\"description\":[\"5% chance for the second floor's treasure room to additionally contain an Eraser\",\"item pedestal.\"],\"modifiers\":{\"eraserSecondFloor\":5},\"adjacent\":[210,179],\"requires\":[210]}"
      }
]])