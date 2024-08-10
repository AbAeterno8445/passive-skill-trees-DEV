local json = require("json")
PST.SkillTreesAPI.AddCharacterTree("Cain", json.decode([[
{
"3": "{\"pos\":[2,2],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[4,167]}",
"4": "{\"pos\":[3,2],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[3,5]}",
"5": "{\"pos\":[4,2],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[4,6]}",
"6": "{\"pos\":[5,2],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[5,7]}",
"7": "{\"pos\":[6,2],\"type\":73,\"size\":\"Med\",\"name\":\"Random Trinket Spawn\",\"description\":[\"5% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":5},\"adjacent\":[6,21,8,9,10,152]}",
"8": "{\"pos\":[6,1],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[7]}",
"9": "{\"pos\":[7,2],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[7]}",
"10": "{\"pos\":[6,3],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[7]}",
"21": "{\"pos\":[8,0],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[7,22]}",
"22": "{\"pos\":[9,-1],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[21,23]}",
"23": "{\"pos\":[9,-2],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[22,24]}",
"24": "{\"pos\":[9,-3],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[23,25]}",
"25": "{\"pos\":[9,-4],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[24,26]}",
"26": "{\"pos\":[9,-5],\"type\":73,\"size\":\"Med\",\"name\":\"Random Trinket Spawn\",\"description\":[\"5% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":5},\"adjacent\":[25,27,28,29,153,195]}",
"27": "{\"pos\":[8,-5],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[26]}",
"28": "{\"pos\":[9,-6],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[26]}",
"29": "{\"pos\":[10,-5],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[26]}",
"31": "{\"pos\":[6,-7],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[195]}",
"32": "{\"pos\":[7,-8],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[195]}",
"82": "{\"pos\":[1,3],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[83,167]}",
"83": "{\"pos\":[1,4],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[82,84]}",
"84": "{\"pos\":[1,5],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[83,85]}",
"85": "{\"pos\":[1,6],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[84,86]}",
"86": "{\"pos\":[1,7],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[85,92]}",
"87": "{\"pos\":[1,9],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[92,88]}",
"88": "{\"pos\":[1,10],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[87,89]}",
"89": "{\"pos\":[1,11],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[88,90]}",
"90": "{\"pos\":[1,12],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[89,91]}",
"91": "{\"pos\":[1,13],\"type\":74,\"size\":\"Small\",\"name\":\"Free Machine Use\",\"description\":[\"1% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":1},\"adjacent\":[90,93]}",
"92": "{\"pos\":[1,8],\"type\":75,\"size\":\"Med\",\"name\":\"Free Machine Use\",\"description\":[\"4% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":4},\"adjacent\":[86,155,94,87]}",
"93": "{\"pos\":[1,14],\"type\":75,\"size\":\"Med\",\"name\":\"Free Machine Use\",\"description\":[\"4% chance for machines that use coins to cost nothing on use.\"],\"modifiers\":{\"freeMachinesChance\":4},\"adjacent\":[91,139,96]}",
"94": "{\"pos\":[2,8],\"type\":76,\"size\":\"Small\",\"name\":\"Arcade Reveal\",\"description\":[\"8% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":8},\"adjacent\":[92,95]}",
"95": "{\"pos\":[3,8],\"type\":76,\"size\":\"Small\",\"name\":\"Arcade Reveal\",\"description\":[\"8% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":8},\"adjacent\":[94,98]}",
"96": "{\"pos\":[2,14],\"type\":76,\"size\":\"Small\",\"name\":\"Arcade Reveal\",\"description\":[\"8% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":8},\"adjacent\":[93,97]}",
"97": "{\"pos\":[3,14],\"type\":76,\"size\":\"Small\",\"name\":\"Arcade Reveal\",\"description\":[\"8% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":8},\"adjacent\":[96,99]}",
"98": "{\"pos\":[4,8],\"type\":77,\"size\":\"Med\",\"name\":\"Arcade Reveal\",\"description\":[\"20% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":20},\"adjacent\":[95]}",
"99": "{\"pos\":[4,14],\"type\":77,\"size\":\"Med\",\"name\":\"Arcade Reveal\",\"description\":[\"20% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":20},\"adjacent\":[97,158]}",
"104": "{\"pos\":[-2,14],\"type\":68,\"size\":\"Large\",\"name\":\"Impromptu Gambler\",\"description\":[\"Spawn a crane game in treasure rooms. These can grant any unlocked item, but cost 8 coins to use.\",\"Interacting with the crane game removes the room's regular item.\",\"Grabbing the regular item removes the crane game.\"],\"modifiers\":{\"impromptuGambler\":true},\"adjacent\":[140,106]}",
"106": "{\"pos\":[-2,13],\"type\":76,\"size\":\"Small\",\"name\":\"Arcade Reveal\",\"description\":[\"8% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":8},\"adjacent\":[104,107]}",
"107": "{\"pos\":[-2,12],\"type\":77,\"size\":\"Med\",\"name\":\"Arcade Reveal\",\"description\":[\"20% chance to reveal the arcade room's location if it's present on a floor.\"],\"modifiers\":{\"arcadeReveal\":20},\"adjacent\":[106]}",
"127": "{\"pos\":[1,-1],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[128,168]}",
"128": "{\"pos\":[1,-2],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[127,129]}",
"129": "{\"pos\":[1,-3],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[128,130,132]}",
"130": "{\"pos\":[2,-3],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[129,131]}",
"131": "{\"pos\":[3,-3],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[130,141]}",
"132": "{\"pos\":[1,-4],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[129,133]}",
"133": "{\"pos\":[1,-5],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[132,134,148]}",
"134": "{\"pos\":[0,-5],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[133,135]}",
"135": "{\"pos\":[-1,-5],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[134,145]}",
"139": "{\"pos\":[0,14],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[93,140]}",
"140": "{\"pos\":[-1,14],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[139,104]}",
"141": "{\"pos\":[4,-3],\"type\":78,\"size\":\"Small\",\"name\":\"Shop Reveal\",\"description\":[\"8% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":8},\"adjacent\":[131,142]}",
"142": "{\"pos\":[4,-4],\"type\":78,\"size\":\"Small\",\"name\":\"Shop Reveal\",\"description\":[\"8% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":8},\"adjacent\":[141,144]}",
"144": "{\"pos\":[4,-5],\"type\":79,\"size\":\"Med\",\"name\":\"Shop Reveal\",\"description\":[\"20% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":20},\"adjacent\":[142]}",
"145": "{\"pos\":[-2,-5],\"type\":78,\"size\":\"Small\",\"name\":\"Shop Reveal\",\"description\":[\"8% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":8},\"adjacent\":[135,146]}",
"146": "{\"pos\":[-2,-6],\"type\":78,\"size\":\"Small\",\"name\":\"Shop Reveal\",\"description\":[\"8% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":8},\"adjacent\":[145,147]}",
"147": "{\"pos\":[-2,-7],\"type\":79,\"size\":\"Med\",\"name\":\"Shop Reveal\",\"description\":[\"20% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":20},\"adjacent\":[146]}",
"148": "{\"pos\":[1,-6],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[133,149]}",
"149": "{\"pos\":[1,-7],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[148,150]}",
"150": "{\"pos\":[1,-8],\"type\":78,\"size\":\"Small\",\"name\":\"Shop Reveal\",\"description\":[\"8% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":8},\"adjacent\":[149,151]}",
"151": "{\"pos\":[1,-9],\"type\":79,\"size\":\"Med\",\"name\":\"Shop Reveal\",\"description\":[\"20% chance to reveal the shop room's location if it's present on a floor.\"],\"modifiers\":{\"shopReveal\":20},\"adjacent\":[150]}",
"152": "{\"pos\":[7,3],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[7]}",
"153": "{\"pos\":[10,-6],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[26]}",
"154": "{\"pos\":[6,-8],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[195]}",
"155": "{\"pos\":[0,8],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[92,156]}",
"156": "{\"pos\":[-1,8],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[155,157]}",
"157": "{\"pos\":[-2,8],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[156]}",
"158": "{\"pos\":[4,13],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[99,159]}",
"159": "{\"pos\":[4,12],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[158]}",
"162": "{\"pos\":[-6,0],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[181]}",
"163": "{\"pos\":[-2,2],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[185]}",
"164": "{\"pos\":[-7,5],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[190]}",
"167": "{\"pos\":[1,1],\"type\":72,\"size\":\"Small\",\"name\":\"Random Trinket Spawn\",\"description\":[\"1% chance to spawn a random trinket at the beginning of a floor.\",\"Doesn't apply in first floor.\"],\"modifiers\":{\"trinketSpawn\":1},\"adjacent\":[168,3,82]}",
"168": "{\"pos\":[0,0],\"type\":80,\"size\":\"Small\",\"name\":\"Room Clear Nickel\",\"description\":[\"0.2% chance to spawn an additional nickel when clearing a room.\",\"Double the chance on boss rooms.\"],\"modifiers\":{\"nickelOnClear\":0.2},\"adjacent\":[127,167,194],\"alwaysAvailable\":true}",
"175": "{\"pos\":[6,-6],\"type\":25,\"size\":\"Med\",\"name\":\"Luck\",\"description\":[\"+0.1 luck\"],\"modifiers\":{\"luck\":0.1},\"adjacent\":[195]}",
"176": "{\"pos\":[8,-8],\"type\":25,\"size\":\"Med\",\"name\":\"Luck\",\"description\":[\"+0.1 luck\"],\"modifiers\":{\"luck\":0.1},\"adjacent\":[195]}",
"177": "{\"pos\":[-2,-2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[178,194]}",
"178": "{\"pos\":[-3,-2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[177,179]}",
"179": "{\"pos\":[-4,-2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[178,180]}",
"180": "{\"pos\":[-5,-2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[179,181]}",
"181": "{\"pos\":[-6,-1],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[180,182,162]}",
"182": "{\"pos\":[-5,0],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[181,183]}",
"183": "{\"pos\":[-4,0],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[182,184]}",
"184": "{\"pos\":[-3,0],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[183,185]}",
"185": "{\"pos\":[-2,1],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[184,186,163]}",
"186": "{\"pos\":[-3,2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[185,187]}",
"187": "{\"pos\":[-4,2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[186,188]}",
"188": "{\"pos\":[-5,2],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[187,189]}",
"189": "{\"pos\":[-6,3],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[188,190]}",
"190": "{\"pos\":[-6,4],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[189,192,164,191,193]}",
"191": "{\"pos\":[-7,4],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[190]}",
"192": "{\"pos\":[-6,5],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[190]}",
"193": "{\"pos\":[-5,4],\"type\":71,\"size\":\"Small\",\"name\":\"Stealing Chance\",\"description\":[\"+2% chance to steal items from the shop instead of purchasing.\"],\"modifiers\":{\"stealChance\":2},\"adjacent\":[190]}",
"194": "{\"pos\":[-1,-1],\"type\":69,\"size\":\"Large\",\"name\":\"Thievery\",\"description\":[\"+30% chance to steal items from the shop instead of purchasing.\",\"If you steal an item, Greed will have a chance to show up\",\"after the floor's boss is defeated.\",\"Each stolen item increases Greed's chance to show up based on its price (price * 3)%.\"],\"modifiers\":{\"stealChance\":30,\"thievery\":true},\"adjacent\":[168,177]}",
"195": "{\"pos\":[7,-7],\"type\":70,\"size\":\"Large\",\"name\":\"Fickle Fortune\",\"description\":[\"+7% luck while holding a trinket.\",\"Minimum luck is 1 while holding a trinket.\",\"7% chance when hit for your trinket to be dropped.\",\"7% chance for dropped trinkets to vanish.\"],\"modifiers\":{\"fickleFortune\":true},\"adjacent\":[26,175,31,154,32,176]}"
}
]])
)