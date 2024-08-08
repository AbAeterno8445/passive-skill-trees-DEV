local json = require("json")

PST.nodeLinks["Eve"] = {}
PST.trees["Eve"] = json.decode([[
{
"2": "{\"pos\":[0,0],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[100,164],\"alwaysAvailable\":true}",
"20": "{\"pos\":[0,-17],\"type\":104,\"size\":\"Large\",\"name\":\"Carrion Avian\",\"description\":[\"+0.15 damage when dead bird kills an enemy, up to +3. Resets every floor.\",\"If dead bird kills a boss, gain a permanent +0.6 damage instead.\"],\"modifiers\":{\"carrionAvian\":true},\"adjacent\":[178]}",
"45": "{\"pos\":[-1,-16],\"type\":107,\"size\":\"Small\",\"name\":\"Active Dead Bird Damage\",\"description\":[\"+0.02 damage while dead bird is active\"],\"modifiers\":{\"activeDeadBirdDamage\":0.02},\"adjacent\":[46,49]}",
"46": "{\"pos\":[-2,-15],\"type\":107,\"size\":\"Small\",\"name\":\"Active Dead Bird Damage\",\"description\":[\"+0.02 damage while dead bird is active\"],\"modifiers\":{\"activeDeadBirdDamage\":0.02},\"adjacent\":[45,47,50]}",
"47": "{\"pos\":[-3,-14],\"type\":107,\"size\":\"Small\",\"name\":\"Active Dead Bird Damage\",\"description\":[\"+0.02 damage while dead bird is active\"],\"modifiers\":{\"activeDeadBirdDamage\":0.02},\"adjacent\":[46,48]}",
"48": "{\"pos\":[-3,-13],\"type\":107,\"size\":\"Small\",\"name\":\"Active Dead Bird Damage\",\"description\":[\"+0.02 damage while dead bird is active\"],\"modifiers\":{\"activeDeadBirdDamage\":0.02},\"adjacent\":[47,124]}",
"49": "{\"pos\":[-1,-15],\"type\":107,\"size\":\"Small\",\"name\":\"Active Dead Bird Damage\",\"description\":[\"+0.02 damage while dead bird is active\"],\"modifiers\":{\"activeDeadBirdDamage\":0.02},\"adjacent\":[45]}",
"50": "{\"pos\":[-2,-14],\"type\":107,\"size\":\"Small\",\"name\":\"Active Dead Bird Damage\",\"description\":[\"+0.02 damage while dead bird is active\"],\"modifiers\":{\"activeDeadBirdDamage\":0.02},\"adjacent\":[46]}",
"57": "{\"pos\":[-1,-12],\"type\":109,\"size\":\"Small\",\"name\":\"Active Dead Bird Tears\",\"description\":[\"+0.02 tears while dead bird is active\"],\"modifiers\":{\"activeDeadBirdTears\":0.02},\"adjacent\":[59,58,173]}",
"58": "{\"pos\":[-1,-11],\"type\":109,\"size\":\"Small\",\"name\":\"Active Dead Bird Tears\",\"description\":[\"+0.02 tears while dead bird is active\"],\"modifiers\":{\"activeDeadBirdTears\":0.02},\"adjacent\":[57]}",
"59": "{\"pos\":[-2,-11],\"type\":109,\"size\":\"Small\",\"name\":\"Active Dead Bird Tears\",\"description\":[\"+0.02 tears while dead bird is active\"],\"modifiers\":{\"activeDeadBirdTears\":0.02},\"adjacent\":[57,61,60]}",
"60": "{\"pos\":[-2,-10],\"type\":109,\"size\":\"Small\",\"name\":\"Active Dead Bird Tears\",\"description\":[\"+0.02 tears while dead bird is active\"],\"modifiers\":{\"activeDeadBirdTears\":0.02},\"adjacent\":[59]}",
"61": "{\"pos\":[-3,-10],\"type\":109,\"size\":\"Small\",\"name\":\"Active Dead Bird Tears\",\"description\":[\"+0.02 tears while dead bird is active\"],\"modifiers\":{\"activeDeadBirdTears\":0.02},\"adjacent\":[59,62]}",
"62": "{\"pos\":[-3,-9],\"type\":109,\"size\":\"Small\",\"name\":\"Active Dead Bird Tears\",\"description\":[\"+0.02 tears while dead bird is active\"],\"modifiers\":{\"activeDeadBirdTears\":0.02},\"adjacent\":[61,123]}",
"63": "{\"pos\":[1,-12],\"type\":110,\"size\":\"Small\",\"name\":\"Active Dead Bird Range\",\"description\":[\"+0.02 range while dead bird is active\"],\"modifiers\":{\"activeDeadBirdRange\":0.02},\"adjacent\":[65,64,173]}",
"64": "{\"pos\":[1,-11],\"type\":110,\"size\":\"Small\",\"name\":\"Active Dead Bird Range\",\"description\":[\"+0.02 range while dead bird is active\"],\"modifiers\":{\"activeDeadBirdRange\":0.02},\"adjacent\":[63]}",
"65": "{\"pos\":[2,-11],\"type\":110,\"size\":\"Small\",\"name\":\"Active Dead Bird Range\",\"description\":[\"+0.02 range while dead bird is active\"],\"modifiers\":{\"activeDeadBirdRange\":0.02},\"adjacent\":[63,67,66]}",
"66": "{\"pos\":[2,-10],\"type\":110,\"size\":\"Small\",\"name\":\"Active Dead Bird Range\",\"description\":[\"+0.02 range while dead bird is active\"],\"modifiers\":{\"activeDeadBirdRange\":0.02},\"adjacent\":[65]}",
"67": "{\"pos\":[3,-10],\"type\":110,\"size\":\"Small\",\"name\":\"Active Dead Bird Range\",\"description\":[\"+0.02 range while dead bird is active\"],\"modifiers\":{\"activeDeadBirdRange\":0.02},\"adjacent\":[65,68]}",
"68": "{\"pos\":[3,-9],\"type\":110,\"size\":\"Small\",\"name\":\"Active Dead Bird Range\",\"description\":[\"+0.02 range while dead bird is active\"],\"modifiers\":{\"activeDeadBirdRange\":0.02},\"adjacent\":[67,120]}",
"69": "{\"pos\":[-1,-6],\"type\":111,\"size\":\"Small\",\"name\":\"Active Dead Bird Shot Speed\",\"description\":[\"+0.02 shot speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdShotspeed\":0.02},\"adjacent\":[71,70,168]}",
"70": "{\"pos\":[-1,-5],\"type\":111,\"size\":\"Small\",\"name\":\"Active Dead Bird Shot Speed\",\"description\":[\"+0.02 shot speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdShotspeed\":0.02},\"adjacent\":[69]}",
"71": "{\"pos\":[-2,-5],\"type\":111,\"size\":\"Small\",\"name\":\"Active Dead Bird Shot Speed\",\"description\":[\"+0.02 shot speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdShotspeed\":0.02},\"adjacent\":[69,73,72]}",
"72": "{\"pos\":[-2,-4],\"type\":111,\"size\":\"Small\",\"name\":\"Active Dead Bird Shot Speed\",\"description\":[\"+0.02 shot speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdShotspeed\":0.02},\"adjacent\":[71]}",
"73": "{\"pos\":[-3,-4],\"type\":111,\"size\":\"Small\",\"name\":\"Active Dead Bird Shot Speed\",\"description\":[\"+0.02 shot speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdShotspeed\":0.02},\"adjacent\":[71,74]}",
"74": "{\"pos\":[-3,-3],\"type\":111,\"size\":\"Small\",\"name\":\"Active Dead Bird Shot Speed\",\"description\":[\"+0.02 shot speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdShotspeed\":0.02},\"adjacent\":[73,122]}",
"91": "{\"pos\":[1,-6],\"type\":108,\"size\":\"Small\",\"name\":\"Active Dead Bird Speed\",\"description\":[\"+0.02 speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdSpeed\":0.02},\"adjacent\":[93,92,168]}",
"92": "{\"pos\":[1,-5],\"type\":108,\"size\":\"Small\",\"name\":\"Active Dead Bird Speed\",\"description\":[\"+0.02 speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdSpeed\":0.02},\"adjacent\":[91]}",
"93": "{\"pos\":[2,-5],\"type\":108,\"size\":\"Small\",\"name\":\"Active Dead Bird Speed\",\"description\":[\"+0.02 speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdSpeed\":0.02},\"adjacent\":[91,95,94]}",
"94": "{\"pos\":[2,-4],\"type\":108,\"size\":\"Small\",\"name\":\"Active Dead Bird Speed\",\"description\":[\"+0.02 speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdSpeed\":0.02},\"adjacent\":[93]}",
"95": "{\"pos\":[3,-4],\"type\":108,\"size\":\"Small\",\"name\":\"Active Dead Bird Speed\",\"description\":[\"+0.02 speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdSpeed\":0.02},\"adjacent\":[93,96]}",
"96": "{\"pos\":[3,-3],\"type\":108,\"size\":\"Small\",\"name\":\"Active Dead Bird Speed\",\"description\":[\"+0.02 speed while dead bird is active\"],\"modifiers\":{\"activeDeadBirdSpeed\":0.02},\"adjacent\":[95,121]}",
"100": "{\"pos\":[0,2],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[2,101]}",
"101": "{\"pos\":[-1,3],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[100,117,126]}",
"103": "{\"pos\":[1,3],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[117,104,142]}",
"104": "{\"pos\":[0,4],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[103,111]}",
"111": "{\"pos\":[0,6],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[104,115]}",
"113": "{\"pos\":[-1,7],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[118,114]}",
"114": "{\"pos\":[0,8],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[113,116]}",
"115": "{\"pos\":[1,7],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[111,118]}",
"116": "{\"pos\":[0,10],\"type\":102,\"size\":\"Large\",\"name\":\"Heartless\",\"description\":[\"Every room you clear grants +0.5% all stats, up to 10%.\",\"Picking up any heart halves your current bonus.\"],\"modifiers\":{\"heartless\":true},\"adjacent\":[114]}",
"117": "{\"pos\":[0,3],\"type\":113,\"size\":\"Small\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.01 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.01},\"adjacent\":[101,103]}",
"118": "{\"pos\":[0,7],\"type\":114,\"size\":\"Med\",\"name\":\"Luck On Room Clear Below Full\",\"description\":[\"+0.05 luck when clearing a room below full red hearts.\"],\"modifiers\":{\"luckOnClearBelowFull\":0.05},\"adjacent\":[115,113]}",
"120": "{\"pos\":[4,-8],\"type\":26,\"size\":\"Med\",\"name\":\"Range\",\"description\":[\"+0.1 range\"],\"modifiers\":{\"range\":0.1},\"adjacent\":[68]}",
"121": "{\"pos\":[4,-2],\"type\":29,\"size\":\"Med\",\"name\":\"Speed\",\"description\":[\"+0.04 speed\"],\"modifiers\":{\"speed\":0.04},\"adjacent\":[96]}",
"122": "{\"pos\":[-4,-2],\"type\":27,\"size\":\"Med\",\"name\":\"Shot Speed\",\"description\":[\"+0.05 shot speed\"],\"modifiers\":{\"shotSpeed\":0.05},\"adjacent\":[74]}",
"123": "{\"pos\":[-4,-8],\"type\":32,\"size\":\"Med\",\"name\":\"Tears\",\"description\":[\"+0.05 tears\"],\"modifiers\":{\"tears\":0.05},\"adjacent\":[62]}",
"124": "{\"pos\":[-4,-12],\"type\":30,\"size\":\"Med\",\"name\":\"Damage\",\"description\":[\"+0.05 damage\"],\"modifiers\":{\"damage\":0.05},\"adjacent\":[48]}",
"126": "{\"pos\":[-3,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[101,129]}",
"127": "{\"pos\":[-4,4],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[128,130]}",
"128": "{\"pos\":[-4,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[129,127]}",
"129": "{\"pos\":[-4,2],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[126,128]}",
"130": "{\"pos\":[-5,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[127,131]}",
"131": "{\"pos\":[-7,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[130,132]}",
"132": "{\"pos\":[-8,4],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[131,133]}",
"133": "{\"pos\":[-8,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[132,134]}",
"134": "{\"pos\":[-8,2],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[133,135]}",
"135": "{\"pos\":[-9,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[134,138]}",
"138": "{\"pos\":[-11,3],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[135,139]}",
"139": "{\"pos\":[-12,2],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[138,140]}",
"140": "{\"pos\":[-12,4],\"type\":50,\"size\":\"Small\",\"name\":\"All Stats - One Heart\",\"description\":[\"+0.01 all stats while you have only 1 red heart.\"],\"modifiers\":{\"allstatsOneRed\":0.01},\"adjacent\":[139,141]}",
"141": "{\"pos\":[-13,3],\"type\":103,\"size\":\"Large\",\"name\":\"Dark Protection\",\"description\":[\"When first reaching 1 heart or less, gain a black heart.\",\"Resets when defeating Mom's Heart.\"],\"modifiers\":{\"darkProtection\":true},\"adjacent\":[140]}",
"142": "{\"pos\":[3,3],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[103,143]}",
"143": "{\"pos\":[4,3],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[142,144]}",
"144": "{\"pos\":[5,3],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[143,145]}",
"145": "{\"pos\":[6,3],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[144,147]}",
"146": "{\"pos\":[7,3],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[147,148]}",
"147": "{\"pos\":[7,2],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[145,146]}",
"148": "{\"pos\":[7,4],\"type\":19,\"size\":\"Small\",\"name\":\"Luck\",\"description\":[\"+0.01 luck\"],\"modifiers\":{\"luck\":0.01},\"adjacent\":[146,149]}",
"149": "{\"pos\":[8,3],\"type\":25,\"size\":\"Med\",\"name\":\"Luck\",\"description\":[\"+0.1 luck\"],\"modifiers\":{\"luck\":0.1},\"adjacent\":[148]}",
"164": "{\"pos\":[0,-2],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[2,165]}",
"165": "{\"pos\":[0,-3],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[164,166]}",
"166": "{\"pos\":[0,-4],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[165,167]}",
"167": "{\"pos\":[0,-5],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[166,168]}",
"168": "{\"pos\":[0,-6],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[167,174,69,91]}",
"169": "{\"pos\":[0,-8],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[174,170]}",
"170": "{\"pos\":[0,-9],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[169,171]}",
"171": "{\"pos\":[0,-10],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[170,172]}",
"172": "{\"pos\":[0,-11],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[171,173]}",
"173": "{\"pos\":[0,-12],\"type\":105,\"size\":\"Small\",\"name\":\"Dead Bird Shield\",\"description\":[\"2% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":2},\"adjacent\":[172,175,57,63]}",
"174": "{\"pos\":[0,-7],\"type\":106,\"size\":\"Med\",\"name\":\"Dead Bird Shield\",\"description\":[\"10% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":10},\"adjacent\":[168,169]}",
"175": "{\"pos\":[0,-13],\"type\":106,\"size\":\"Med\",\"name\":\"Dead Bird Shield\",\"description\":[\"10% chance for the hit that wakes dead bird to be nullified.\"],\"modifiers\":{\"deadBirdNullify\":10},\"adjacent\":[173,176]}",
"176": "{\"pos\":[0,-14],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[175,177]}",
"177": "{\"pos\":[0,-15],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[176,178]}",
"178": "{\"pos\":[0,-16],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[177,20,179]}",
"179": "{\"pos\":[1,-16],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[178,180]}",
"180": "{\"pos\":[1,-15],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[179,181]}",
"181": "{\"pos\":[2,-15],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[180,182]}",
"182": "{\"pos\":[2,-14],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[181,183]}",
"183": "{\"pos\":[3,-14],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[182,184]}",
"184": "{\"pos\":[3,-13],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[183,185]}",
"185": "{\"pos\":[4,-12],\"type\":112,\"size\":\"Small\",\"name\":\"Dead Bird Damage\",\"description\":[\"Dead bird deals an additional 1% of your damage per tick.\"],\"modifiers\":{\"deadBirdInheritDamage\":1},\"adjacent\":[184]}"
}
]])