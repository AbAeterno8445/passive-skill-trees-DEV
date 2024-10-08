-- Mod data initialization
PST.modName = "Passive Skill Trees"
PST.modVersion = "v0.3.21"
PST.isNewVersion = false -- Gets set to true when the mod updates, then remains false until next update
PST.modData = {}
PST.saveSlot = 1
PST.selectedMenuChar = -1
PST.startXPRequired = 34
PST.charNames = {
	"Isaac", "Magdalene", "Cain", "Judas", "???", "Eve",
	"Samson", "Azazel", "Lazarus", "Eden", "The Lost", "Lazarus",
	"Judas", "Lilith", "Keeper", "Apollyon", "The Forgotten", "The Forgotten",
	"Bethany", "Jacob & Esau", "Jacob & Esau",
	"T. Isaac", "T. Magdalene", "T. Cain", "T. Judas", "T. ???", "T. Eve",
	"T. Samson", "T. Azazel", "T. Lazarus", "T. Eden", "T. Lost", "T. Lilith",
	"T. Keeper", "T. Apollyon", "T. Forgotten", "T. Bethany", "T. Jacob", "T. Lazarus",
	"T. Jacob", "T. Forgotten"
}
PST.allstatsCache = CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_LUCK
PST.player = nil
PST.room = nil
PST.level = nil

-- For custom mod images
PST.customNodeImages = {}

-- For saving when entering a room
PST.savePending = false

-- Initialization performed on the first menu render call
function PST:firstRenderInit()
	-- Init mod char names here
	if Isaac.GetPlayerTypeByName("Siren") ~= -1 then
		PST.charNames[1 + Isaac.GetPlayerTypeByName("Siren")] = "Siren"
	end
	if Isaac.GetPlayerTypeByName("Siren", true) ~= -1 then
		PST.charNames[1 + Isaac.GetPlayerTypeByName("Siren", true)] = "T. Siren"
	end
end

PST.babyFamiliarItems = {
    CollectibleType.COLLECTIBLE_BROTHER_BOBBY, CollectibleType.COLLECTIBLE_HARLEQUIN_BABY,
    CollectibleType.COLLECTIBLE_HEADLESS_BABY, CollectibleType.COLLECTIBLE_LITTLE_STEVEN,
    CollectibleType.COLLECTIBLE_MONGO_BABY, CollectibleType.COLLECTIBLE_ROTTEN_BABY,
    CollectibleType.COLLECTIBLE_SISTER_MAGGY, CollectibleType.COLLECTIBLE_ABEL,
    CollectibleType.COLLECTIBLE_ACID_BABY, CollectibleType.COLLECTIBLE_BOILED_BABY,
    CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX, CollectibleType.COLLECTIBLE_CUBE_BABY,
    CollectibleType.COLLECTIBLE_DEMON_BABY, CollectibleType.COLLECTIBLE_DRY_BABY,
    CollectibleType.COLLECTIBLE_FARTING_BABY, CollectibleType.COLLECTIBLE_FREEZER_BABY,
    CollectibleType.COLLECTIBLE_GHOST_BABY, CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    CollectibleType.COLLECTIBLE_INCUBUS, CollectibleType.COLLECTIBLE_KING_BABY,
    CollectibleType.COLLECTIBLE_LIL_ABADDON, CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
    CollectibleType.COLLECTIBLE_LIL_LOKI, CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,
    CollectibleType.COLLECTIBLE_QUINTS, CollectibleType.COLLECTIBLE_RAINBOW_BABY,
    CollectibleType.COLLECTIBLE_ROBO_BABY, CollectibleType.COLLECTIBLE_ROBO_BABY_2,
    CollectibleType.COLLECTIBLE_SERAPHIM, CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
    CollectibleType.COLLECTIBLE_TWISTED_PAIR
}
PST.deliriumFamiliarItems = {
	CollectibleType.COLLECTIBLE_BBF, CollectibleType.COLLECTIBLE_BOBS_BRAIN, CollectibleType.COLLECTIBLE_HUSHY,
	CollectibleType.COLLECTIBLE_LIL_GURDY, CollectibleType.COLLECTIBLE_LIL_HAUNT, CollectibleType.COLLECTIBLE_LIL_MONSTRO,
	CollectibleType.COLLECTIBLE_LITTLE_CHUBBY, CollectibleType.COLLECTIBLE_LITTLE_GISH, CollectibleType.COLLECTIBLE_CUBE_OF_MEAT,
	CollectibleType.COLLECTIBLE_BIG_CHUBBY, CollectibleType.COLLECTIBLE_FRUITY_PLUM,
	table.unpack(PST.babyFamiliarItems)
}
PST.poopItems = {
	CollectibleType.COLLECTIBLE_FLUSH, CollectibleType.COLLECTIBLE_POOP,
	CollectibleType.COLLECTIBLE_BROWN_NUGGET, CollectibleType.COLLECTIBLE_E_COLI,
	CollectibleType.COLLECTIBLE_BUTT_BOMBS, CollectibleType.COLLECTIBLE_DIRTY_MIND,
	CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE, CollectibleType.COLLECTIBLE_SKATOLE,
	CollectibleType.COLLECTIBLE_NUMBER_TWO
}
PST.poopTrinkets = {
	TrinketType.TRINKET_PETRIFIED_POOP, TrinketType.TRINKET_BUTT_PENNY, TrinketType.TRINKET_MECONIUM,
	TrinketType.TRINKET_BROWN_CAP, TrinketType.TRINKET_USED_DIAPER, TrinketType.TRINKET_DINGLE_BERRY,
	TrinketType.TRINKET_GIGANTE_BEAN, TrinketType.TRINKET_MYSTERIOUS_CANDY, TrinketType.TRINKET_LIL_LARVA
}
PST.evilTrinkets = {
	TrinketType.TRINKET_GOAT_HOOF, TrinketType.TRINKET_BLACK_LIPSTICK, TrinketType.TRINKET_DAEMONS_TAIL,
	TrinketType.TRINKET_LEFT_HAND, TrinketType.TRINKET_BLACK_FEATHER, TrinketType.TRINKET_MECONIUM,
	TrinketType.TRINKET_SIGIL_OF_BAPHOMET
}
PST.demonFamiliars = {
	CollectibleType.COLLECTIBLE_DARK_BUM, CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
	CollectibleType.COLLECTIBLE_INCUBUS, CollectibleType.COLLECTIBLE_LIL_ABADDON,
	CollectibleType.COLLECTIBLE_TWISTED_PAIR, CollectibleType.COLLECTIBLE_SUCCUBUS
}
PST.heartUpItems = {
	[CollectibleType.COLLECTIBLE_IMMACULATE_HEART] = 1,
	[CollectibleType.COLLECTIBLE_VENUS] = 1,
	[CollectibleType.COLLECTIBLE_JUPITER] = 2,
	[CollectibleType.COLLECTIBLE_BLOOD_BOMBS] = 1,
	[CollectibleType.COLLECTIBLE_SUPPER] = 1,
	[CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM] = 1,
	[CollectibleType.COLLECTIBLE_HEART] = 1,
	[CollectibleType.COLLECTIBLE_RAW_LIVER] = 2,
	[CollectibleType.COLLECTIBLE_LUNCH] = 1,
	[CollectibleType.COLLECTIBLE_DINNER] = 1,
	[CollectibleType.COLLECTIBLE_DESSERT] = 1,
	[CollectibleType.COLLECTIBLE_BREAKFAST] = 1,
	[CollectibleType.COLLECTIBLE_ROTTEN_MEAT] = 1,
	[CollectibleType.COLLECTIBLE_SUPER_BANDAGE] = 3,
	[CollectibleType.COLLECTIBLE_HALO] = 1,
	[CollectibleType.COLLECTIBLE_BLOOD_BAG] = 1,
	[CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE] = 1,
	[CollectibleType.COLLECTIBLE_BUCKET_OF_LARD] = 2,
	[CollectibleType.COLLECTIBLE_STIGMATA] = 1,
	[CollectibleType.COLLECTIBLE_STEM_CELLS] = 1,
	[CollectibleType.COLLECTIBLE_HOLY_GRAIL] = 1,
	[CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = 1,
	[CollectibleType.COLLECTIBLE_MEAT] = 1,
	[CollectibleType.COLLECTIBLE_PLACENTA] = 1,
	[CollectibleType.COLLECTIBLE_OLD_BANDAGE] = 1,
	[CollectibleType.COLLECTIBLE_BLACK_LOTUS] = 3,
	[CollectibleType.COLLECTIBLE_MAGIC_SCAB] = 1,
	[CollectibleType.COLLECTIBLE_CANCER] = 3,
	[CollectibleType.COLLECTIBLE_CAPRICORN] = 1,
	[CollectibleType.COLLECTIBLE_MAGGYS_BOW] = 1,
	[CollectibleType.COLLECTIBLE_THUNDER_THIGHS] = 1,
	[CollectibleType.COLLECTIBLE_BLUE_CAP] = 1,
	[CollectibleType.COLLECTIBLE_SNACK] = 1,
	[CollectibleType.COLLECTIBLE_CRACK_JACKS] = 1,
	[CollectibleType.COLLECTIBLE_MIDNIGHT_SNACK] = 1,
	[CollectibleType.COLLECTIBLE_MARROW] = 1,
	[CollectibleType.COLLECTIBLE_SOCKS] = 2,
	[CollectibleType.COLLECTIBLE_REVELATION] = 2,
	[CollectibleType.COLLECTIBLE_ROSARY] = 3,
	[CollectibleType.COLLECTIBLE_MARK] = 1,
	[CollectibleType.COLLECTIBLE_SUPER_BANDAGE] = 2,
	[CollectibleType.COLLECTIBLE_SOUL] = 2,
	[CollectibleType.COLLECTIBLE_LATCH_KEY] = 1,
	[CollectibleType.COLLECTIBLE_MOMS_PEARLS] = 1,
	[CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = 2,
	[CollectibleType.COLLECTIBLE_PJS] = 4,
	[CollectibleType.COLLECTIBLE_BINKY] = 1,
	[CollectibleType.COLLECTIBLE_METAL_PLATE] = 1,
	[CollectibleType.COLLECTIBLE_CONE_HEAD] = 1,
	[CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE] = 2,
	[CollectibleType.COLLECTIBLE_BOZO] = 1,
	[CollectibleType.COLLECTIBLE_BLANKET] = 1,
	[CollectibleType.COLLECTIBLE_FALSE_PHD] = 1,
	[CollectibleType.COLLECTIBLE_PACT] = 2,
	[CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES] = 3,
	[CollectibleType.COLLECTIBLE_ABADDON] = 2,
	[CollectibleType.COLLECTIBLE_BLACK_CANDLE] = 1,
	[CollectibleType.COLLECTIBLE_MISSING_PAGE_2] = 1,
	[CollectibleType.COLLECTIBLE_SAFETY_PIN] = 1,
	[CollectibleType.COLLECTIBLE_MATCH_BOOK] = 1,
	[CollectibleType.COLLECTIBLE_EMPTY_VESSEL] = 2,
	[CollectibleType.COLLECTIBLE_DIVORCE_PAPERS] = 1,
	[CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION] = 1,
	[CollectibleType.COLLECTIBLE_FATE] = 1,
	[CollectibleType.COLLECTIBLE_SACRED_HEART] = 1,
	[CollectibleType.COLLECTIBLE_BODY] = 3
}
PST.locustTrinkets = {
	TrinketType.TRINKET_LOCUST_OF_DEATH, TrinketType.TRINKET_LOCUST_OF_FAMINE, TrinketType.TRINKET_LOCUST_OF_PESTILENCE,
	TrinketType.TRINKET_LOCUST_OF_WRATH, TrinketType.TRINKET_LOCUST_OF_CONQUEST,
	TrinketType.TRINKET_LOCUST_OF_DEATH | TrinketType.TRINKET_GOLDEN_FLAG,
	TrinketType.TRINKET_LOCUST_OF_FAMINE | TrinketType.TRINKET_GOLDEN_FLAG,
	TrinketType.TRINKET_LOCUST_OF_PESTILENCE | TrinketType.TRINKET_GOLDEN_FLAG,
	TrinketType.TRINKET_LOCUST_OF_WRATH | TrinketType.TRINKET_GOLDEN_FLAG,
	TrinketType.TRINKET_LOCUST_OF_CONQUEST | TrinketType.TRINKET_GOLDEN_FLAG
}
PST.locustTrinketsNonGold = {
	TrinketType.TRINKET_LOCUST_OF_DEATH, TrinketType.TRINKET_LOCUST_OF_FAMINE, TrinketType.TRINKET_LOCUST_OF_PESTILENCE,
	TrinketType.TRINKET_LOCUST_OF_WRATH, TrinketType.TRINKET_LOCUST_OF_CONQUEST
}
PST.deadlySinBosses = {
	EntityType.ENTITY_ENVY, EntityType.ENTITY_GLUTTONY, EntityType.ENTITY_WRATH,
	EntityType.ENTITY_PRIDE, EntityType.ENTITY_LUST, EntityType.ENTITY_GREED,
	EntityType.ENTITY_SLOTH
}
PST.bookItems = {
	CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK, CollectibleType.COLLECTIBLE_BIBLE,
	CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS,
	CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS, CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
	CollectibleType.COLLECTIBLE_BOOK_OF_SIN, CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD,
	CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, CollectibleType.COLLECTIBLE_NECRONOMICON,
	CollectibleType.COLLECTIBLE_HOW_TO_JUMP, CollectibleType.COLLECTIBLE_SATANIC_BIBLE,
	CollectibleType.COLLECTIBLE_TELEPATHY_BOOK, CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
	CollectibleType.COLLECTIBLE_LEMEGETON
}
PST.progressionItems = {
	0, CollectibleType.COLLECTIBLE_KEY_PIECE_1, CollectibleType.COLLECTIBLE_KEY_PIECE_2,
	CollectibleType.COLLECTIBLE_POLAROID, CollectibleType.COLLECTIBLE_NEGATIVE,
	CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1, CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_2,
	CollectibleType.COLLECTIBLE_DADS_NOTE, CollectibleType.COLLECTIBLE_DOGMA,
	CollectibleType.COLLECTIBLE_KNIFE_PIECE_1, CollectibleType.COLLECTIBLE_KNIFE_PIECE_2
}
PST.regularChests = {
	PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_REDCHEST, PickupVariant.PICKUP_SPIKEDCHEST,
	PickupVariant.PICKUP_MIMICCHEST, PickupVariant.PICKUP_WOODENCHEST, PickupVariant.PICKUP_HAUNTEDCHEST
}
PST.lockedChests = {
	PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_MEGACHEST
}
PST.noChampionMobs = {
	EntityType.ENTITY_ARMYFLY, EntityType.ENTITY_ATTACKFLY, EntityType.ENTITY_BEGOTTEN, EntityType.ENTITY_DIP,
	EntityType.ENTITY_BIGSPIDER, EntityType.ENTITY_BISHOP, {EntityType.ENTITY_KNIGHT, 3}, EntityType.ENTITY_DEATHS_HEAD,
	{EntityType.ENTITY_SUCKER, 5}, EntityType.ENTITY_BUTTLICKER, EntityType.ENTITY_ROCK_SPIDER, EntityType.ENTITY_STONEY,
	EntityType.ENTITY_SQUIRT, EntityType.ENTITY_DART_FLY, EntityType.ENTITY_DINGA, EntityType.ENTITY_DRIP,
	EntityType.ENTITY_CHARGER_L2, EntityType.ENTITY_EMBRYO, EntityType.ENTITY_ETERNALFLY, EntityType.ENTITY_FISSURE,
	EntityType.ENTITY_GRUB, EntityType.ENTITY_HENRY, EntityType.ENTITY_HOMUNCULUS, EntityType.ENTITY_HUSH_FLY,
	EntityType.ENTITY_WILLO, EntityType.ENTITY_WILLO_L2, EntityType.ENTITY_PORTAL, EntityType.ENTITY_MASK,
	EntityType.ENTITY_HEART, EntityType.ENTITY_MOMS_HAND, EntityType.ENTITY_MOMS_DEAD_HAND, EntityType.ENTITY_MOTER,
	EntityType.ENTITY_MRMAW, EntityType.ENTITY_MR_MINE, EntityType.ENTITY_NEEDLE, EntityType.ENTITY_NERVE_ENDING,
	EntityType.ENTITY_POOFER, EntityType.ENTITY_RED_GHOST, EntityType.ENTITY_RING_OF_FLIES, EntityType.ENTITY_SHADY,
	EntityType.ENTITY_SMALL_MAGGOT, EntityType.ENTITY_SMALL_LEECH, {EntityType.ENTITY_WALL_CREEP, 1}, EntityType.ENTITY_SPIDER,
	EntityType.ENTITY_SPLURT, EntityType.ENTITY_STRIDER, EntityType.ENTITY_SWARM, EntityType.ENTITY_SWARM_SPIDER,
	EntityType.ENTITY_SWINGER, EntityType.ENTITY_WIZOOB, EntityType.ENTITY_BLOOD_PUPPY,
	-- Tainted variants
	{EntityType.ENTITY_BOOMFLY, 6}, {EntityType.ENTITY_FACELESS, 1}, {EntityType.ENTITY_HOPPER, 3}, {EntityType.ENTITY_MOLE, 1},
	{EntityType.ENTITY_MULLIGAN, 3}, {EntityType.ENTITY_POOTER, 2}, {EntityType.ENTITY_ROUND_WORM, 2}, {EntityType.ENTITY_WALL_CREEP, 3},
	{EntityType.ENTITY_SPITTY, 1}, {EntityType.ENTITY_SUB_HORF, 1}, {EntityType.ENTITY_SUCKER, 7}, {EntityType.ENTITY_ROUND_WORM, 3}
}
PST.noChampionMobsJewel = {
	EntityType.ENTITY_BISHOP, EntityType.ENTITY_BLOOD_PUPPY
}
PST.noChampionBosses = {
	EntityType.ENTITY_FALLEN, EntityType.ENTITY_HEADLESS_HORSEMAN, EntityType.ENTITY_GEMINI, EntityType.ENTITY_DINGLE,
	EntityType.ENTITY_GURGLING, EntityType.ENTITY_BABY_PLUM, EntityType.ENTITY_LIL_BLUB, {EntityType.ENTITY_PIN, 3},
	EntityType.ENTITY_RAINMAKER, EntityType.ENTITY_MIN_MIN, EntityType.ENTITY_CLOG, EntityType.ENTITY_COLOSTOMIA,
	EntityType.ENTITY_TURDLET, {EntityType.ENTITY_CHUB, 1}, {EntityType.ENTITY_WIDOW, 1}, EntityType.ENTITY_DARK_ONE,
	EntityType.ENTITY_BIG_HORN, EntityType.ENTITY_RAG_MEGA, EntityType.ENTITY_BUMBINO, EntityType.ENTITY_REAP_CREEP,
	{EntityType.ENTITY_LARRYJR, 2}, EntityType.ENTITY_HORNFEL, EntityType.ENTITY_GIDEON, {EntityType.ENTITY_POLYCEPHALUS, 1},
	{EntityType.ENTITY_LARRYJR, 3}, EntityType.ENTITY_SINGE, EntityType.ENTITY_CLUTCH, EntityType.ENTITY_LOKI,
	{EntityType.ENTITY_MONSTRO2, 1}, EntityType.ENTITY_ADVERSARY, EntityType.ENTITY_SISTERS_VIS, EntityType.ENTITY_SIREN,
	EntityType.ENTITY_HERETIC, EntityType.ENTITY_VISAGE, EntityType.ENTITY_HORNY_BOYS, EntityType.ENTITY_BLASTOCYST_BIG,
	EntityType.ENTITY_BLASTOCYST_MEDIUM, EntityType.ENTITY_BLASTOCYST_SMALL, EntityType.ENTITY_MAMA_GURDY, EntityType.ENTITY_MR_FRED,
	EntityType.ENTITY_DADDYLONGLEGS, {EntityType.ENTITY_FISTULA_BIG, 1}, EntityType.ENTITY_MATRIARCH, {EntityType.ENTITY_WAR, 1},
	EntityType.ENTITY_MOMS_HEART, EntityType.ENTITY_HUSH, EntityType.ENTITY_ROTGUT, EntityType.ENTITY_CHIMERA,
	EntityType.ENTITY_SCOURGE, EntityType.ENTITY_MOTHER, EntityType.ENTITY_SATAN, EntityType.ENTITY_ISAAC,
	EntityType.ENTITY_THE_LAMB, EntityType.ENTITY_MEGA_SATAN, EntityType.ENTITY_MEGA_SATAN_2, EntityType.ENTITY_ULTRA_GREED,
	EntityType.ENTITY_DELIRIUM, EntityType.ENTITY_DOGMA, EntityType.ENTITY_BEAST
}
PST.chroniclerRoomTypes = {
	RoomType.ROOM_DEFAULT, RoomType.ROOM_SHOP, RoomType.ROOM_TREASURE, RoomType.ROOM_BOSS, RoomType.ROOM_MINIBOSS,
	RoomType.ROOM_SECRET, RoomType.ROOM_ARCADE, RoomType.ROOM_CURSE, RoomType.ROOM_CHALLENGE, RoomType.ROOM_LIBRARY,
	RoomType.ROOM_SACRIFICE, RoomType.ROOM_CHEST, RoomType.ROOM_DICE, RoomType.ROOM_PLANETARIUM
}
PST.noSplitMobs = {
	EntityType.ENTITY_GIDEON, EntityType.ENTITY_BLOOD_PUPPY, EntityType.ENTITY_GRUB, EntityType.ENTITY_CHUB, EntityType.ENTITY_SCOURGE,
	EntityType.ENTITY_SWINGER
}
PST.allRunes = {
	Card.RUNE_ALGIZ, Card.RUNE_ANSUZ, Card.RUNE_BERKANO, Card.RUNE_BLACK, Card.RUNE_BLANK, Card.RUNE_DAGAZ, Card.RUNE_EHWAZ, Card.RUNE_HAGALAZ,
	Card.RUNE_JERA, Card.RUNE_PERTHRO, Card.RUNE_SHARD
}
PST.blueGambitCards = {
	Card.CARD_ACE_OF_CLUBS, Card.CARD_ACE_OF_DIAMONDS, Card.CARD_ACE_OF_HEARTS, Card.CARD_ACE_OF_SPADES, Card.CARD_ANCIENT_RECALL, Card.CARD_CHARIOT,
	Card.CARD_CLUBS_2, Card.CARD_DEATH, Card.CARD_DEVIL, Card.CARD_DIAMONDS_2, Card.CARD_EMERGENCY_CONTACT, Card.CARD_EMPEROR, Card.CARD_EMPRESS,
	Card.CARD_ERA_WALK, Card.CARD_FOOL, Card.CARD_GET_OUT_OF_JAIL, Card.CARD_HANGED_MAN, Card.CARD_HEARTS_2, Card.CARD_HERMIT, Card.CARD_HIEROPHANT,
	Card.CARD_HIGH_PRIESTESS, Card.CARD_HOLY, Card.CARD_HUMANITY, Card.CARD_JOKER, Card.CARD_JUDGEMENT, Card.CARD_JUSTICE, Card.CARD_LOVERS,
	Card.CARD_MAGICIAN, Card.CARD_MOON, Card.CARD_QUEEN_OF_HEARTS, Card.CARD_QUESTIONMARK, Card.CARD_RULES, Card.CARD_SPADES_2, Card.CARD_STARS,
	Card.CARD_STRENGTH, Card.CARD_SUN, Card.CARD_TEMPERANCE, Card.CARD_TOWER, Card.CARD_WHEEL_OF_FORTUNE, Card.CARD_WILD, Card.CARD_WORLD
}
PST.playerDamagingCreep = {
	EffectVariant.PLAYER_CREEP_GREEN, EffectVariant.PLAYER_CREEP_HOLYWATER, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL,
	EffectVariant.PLAYER_CREEP_LEMON_MISHAP, EffectVariant.PLAYER_CREEP_LEMON_PARTY, EffectVariant.PLAYER_CREEP_RED
}
PST.craftBagPickups = {
	[BagOfCraftingPickup.BOC_RED_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF},
	[BagOfCraftingPickup.BOC_SOUL_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL},
	[BagOfCraftingPickup.BOC_BLACK_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK},
	[BagOfCraftingPickup.BOC_ETERNAL_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL},
	[BagOfCraftingPickup.BOC_GOLD_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN},
	[BagOfCraftingPickup.BOC_BONE_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE},
	[BagOfCraftingPickup.BOC_ROTTEN_HEART] = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN},
	[BagOfCraftingPickup.BOC_PENNY] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
	[BagOfCraftingPickup.BOC_NICKEL] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL},
	[BagOfCraftingPickup.BOC_DIME] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME},
	[BagOfCraftingPickup.BOC_LUCKY_PENNY] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_LUCKYPENNY},
	[BagOfCraftingPickup.BOC_KEY] = {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
	[BagOfCraftingPickup.BOC_GOLD_KEY] = {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN},
	[BagOfCraftingPickup.BOC_CHARGED_KEY] = {PickupVariant.PICKUP_KEY, KeySubType.KEY_CHARGED},
	[BagOfCraftingPickup.BOC_BOMB] = {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
	[BagOfCraftingPickup.BOC_GOLD_BOMB] = {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN},
	[BagOfCraftingPickup.BOC_GIGA_BOMB] = {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GIGA},
	[BagOfCraftingPickup.BOC_MINI_BATTERY] = {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MICRO},
	[BagOfCraftingPickup.BOC_BATTERY] = {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL},
	[BagOfCraftingPickup.BOC_MEGA_BATTERY] = {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MEGA},
	[BagOfCraftingPickup.BOC_CARD] = {PickupVariant.PICKUP_TAROTCARD, -1},
	[BagOfCraftingPickup.BOC_PILL] = {PickupVariant.PICKUP_PILL, 0},
	[BagOfCraftingPickup.BOC_RUNE] = {PickupVariant.PICKUP_TAROTCARD, Card.RUNE_SHARD},
	[BagOfCraftingPickup.BOC_DICE_SHARD] = {PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD},
	[BagOfCraftingPickup.BOC_CRACKED_KEY] = {PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY},
	[BagOfCraftingPickup.BOC_GOLD_PENNY] = {PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN},
	[BagOfCraftingPickup.BOC_GOLD_PILL] = {PickupVariant.PICKUP_PILL, 0},
	[BagOfCraftingPickup.BOC_GOLD_BATTERY] = {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_GOLDEN}
}
PST.causeConverterBossBlacklist = {
	EntityType.ENTITY_FISTULA_BIG, EntityType.ENTITY_FISTULA_MEDIUM, EntityType.ENTITY_FISTULA_SMALL,
	EntityType.ENTITY_LARRYJR, EntityType.ENTITY_HORNFEL, EntityType.ENTITY_GIDEON,
	EntityType.ENTITY_MASK_OF_INFAMY, EntityType.ENTITY_MOM, EntityType.ENTITY_MOMS_HEART,
	EntityType.ENTITY_BLASTOCYST_BIG, EntityType.ENTITY_BLASTOCYST_MEDIUM, EntityType.ENTITY_BLASTOCYST_SMALL,
	EntityType.ENTITY_MAMA_GURDY, EntityType.ENTITY_ROTGUT, EntityType.ENTITY_MOTHER,
	EntityType.ENTITY_MOTHERS_SHADOW, EntityType.ENTITY_HUSH, EntityType.ENTITY_SATAN,
	EntityType.ENTITY_THE_LAMB, EntityType.ENTITY_ISAAC, EntityType.ENTITY_MEGA_SATAN,
	EntityType.ENTITY_DELIRIUM, EntityType.ENTITY_DOGMA, EntityType.ENTITY_BEAST,
	EntityType.ENTITY_ULTRA_GREED, EntityType.ENTITY_GEMINI, EntityType.ENTITY_PIN
}
PST.planetariumItems = {
	CollectibleType.COLLECTIBLE_JUPITER, CollectibleType.COLLECTIBLE_LUNA, CollectibleType.COLLECTIBLE_MARS,
	CollectibleType.COLLECTIBLE_MERCURIUS, CollectibleType.COLLECTIBLE_NEPTUNUS, CollectibleType.COLLECTIBLE_PLUTO,
	CollectibleType.COLLECTIBLE_SATURNUS, CollectibleType.COLLECTIBLE_SOL, CollectibleType.COLLECTIBLE_TERRA,
	CollectibleType.COLLECTIBLE_URANUS, CollectibleType.COLLECTIBLE_VENUS
}
PST.pennyTrinkets = {
	TrinketType.TRINKET_BUTT_PENNY, TrinketType.TRINKET_FLAT_PENNY, TrinketType.TRINKET_BURNT_PENNY,
	TrinketType.TRINKET_BLOODY_PENNY, TrinketType.TRINKET_CURSED_PENNY, TrinketType.TRINKET_ROTTEN_PENNY,
	TrinketType.TRINKET_BLESSED_PENNY, TrinketType.TRINKET_CHARGED_PENNY, TrinketType.TRINKET_SWALLOWED_PENNY,
	TrinketType.TRINKET_COUNTERFEIT_PENNY
}
PST.anamnesisListTypes = {
	[PurityState.RED] = "Devil",
	[PurityState.BLUE] = "Angel",
	[PurityState.YELLOW] = "Treasure",
	[PurityState.ORANGE] = "Other"
}
PST.playerSoulstones = {
	[PlayerType.PLAYER_APOLLYON] = Card.CARD_SOUL_APOLLYON,
	[PlayerType.PLAYER_APOLLYON_B] = Card.CARD_SOUL_APOLLYON,
	[PlayerType.PLAYER_AZAZEL] = Card.CARD_SOUL_AZAZEL,
	[PlayerType.PLAYER_AZAZEL_B] = Card.CARD_SOUL_AZAZEL,
	[PlayerType.PLAYER_BETHANY] = Card.CARD_SOUL_BETHANY,
	[PlayerType.PLAYER_BETHANY_B] = Card.CARD_SOUL_BETHANY,
	[PlayerType.PLAYER_BLUEBABY] = Card.CARD_SOUL_BLUEBABY,
	[PlayerType.PLAYER_BLUEBABY_B] = Card.CARD_SOUL_BLUEBABY,
	[PlayerType.PLAYER_CAIN] = Card.CARD_SOUL_CAIN,
	[PlayerType.PLAYER_CAIN_B] = Card.CARD_SOUL_CAIN,
	[PlayerType.PLAYER_EDEN] = Card.CARD_SOUL_EDEN,
	[PlayerType.PLAYER_EDEN_B] = Card.CARD_SOUL_EDEN,
	[PlayerType.PLAYER_EVE] = Card.CARD_SOUL_EVE,
	[PlayerType.PLAYER_EVE_B] = Card.CARD_SOUL_EVE,
	[PlayerType.PLAYER_ISAAC] = Card.CARD_SOUL_ISAAC,
	[PlayerType.PLAYER_ISAAC_B] = Card.CARD_SOUL_ISAAC,
	[PlayerType.PLAYER_JACOB] = Card.CARD_SOUL_JACOB,
	[PlayerType.PLAYER_JACOB_B] = Card.CARD_SOUL_JACOB,
	[PlayerType.PLAYER_JUDAS] = Card.CARD_SOUL_JUDAS,
	[PlayerType.PLAYER_JUDAS_B] = Card.CARD_SOUL_JUDAS,
	[PlayerType.PLAYER_BLACKJUDAS] = Card.CARD_SOUL_JUDAS,
	[PlayerType.PLAYER_KEEPER] = Card.CARD_SOUL_KEEPER,
	[PlayerType.PLAYER_KEEPER_B] = Card.CARD_SOUL_KEEPER,
	[PlayerType.PLAYER_LAZARUS] = Card.CARD_SOUL_LAZARUS,
	[PlayerType.PLAYER_LAZARUS_B] = Card.CARD_SOUL_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2] = Card.CARD_SOUL_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = Card.CARD_SOUL_LAZARUS,
	[PlayerType.PLAYER_LILITH] = Card.CARD_SOUL_LILITH,
	[PlayerType.PLAYER_LILITH_B] = Card.CARD_SOUL_LILITH,
	[PlayerType.PLAYER_MAGDALENE] = Card.CARD_SOUL_MAGDALENE,
	[PlayerType.PLAYER_MAGDALENE_B] = Card.CARD_SOUL_MAGDALENE,
	[PlayerType.PLAYER_SAMSON] = Card.CARD_SOUL_SAMSON,
	[PlayerType.PLAYER_SAMSON_B] = Card.CARD_SOUL_SAMSON,
	[PlayerType.PLAYER_THEFORGOTTEN] = Card.CARD_SOUL_FORGOTTEN,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = Card.CARD_SOUL_FORGOTTEN,
	[PlayerType.PLAYER_THELOST] = Card.CARD_SOUL_LOST,
	[PlayerType.PLAYER_THELOST_B] = Card.CARD_SOUL_LOST
}
PST.sirenMelodies = {"Empty Notes", "Mini Melody", "Middling Melody", "Mighty Melody", "Manifest Melody"}
PST.songOfTheFewFamiliars = {
	CollectibleType.COLLECTIBLE_BROTHER_BOBBY, CollectibleType.COLLECTIBLE_SISTER_MAGGY, CollectibleType.COLLECTIBLE_LITTLE_CHUBBY,
	CollectibleType.COLLECTIBLE_ROBO_BABY, CollectibleType.COLLECTIBLE_LITTLE_CHAD, CollectibleType.COLLECTIBLE_LITTLE_GISH,
	CollectibleType.COLLECTIBLE_LITTLE_STEVEN, CollectibleType.COLLECTIBLE_DEMON_BABY, CollectibleType.COLLECTIBLE_DEAD_BIRD,
	CollectibleType.COLLECTIBLE_GHOST_BABY, CollectibleType.COLLECTIBLE_HARLEQUIN_BABY, CollectibleType.COLLECTIBLE_DADDY_LONGLEGS,
	CollectibleType.COLLECTIBLE_RAINBOW_BABY, CollectibleType.COLLECTIBLE_DRY_BABY, CollectibleType.COLLECTIBLE_ROBO_BABY_2,
	CollectibleType.COLLECTIBLE_ROTTEN_BABY, CollectibleType.COLLECTIBLE_HEADLESS_BABY, CollectibleType.COLLECTIBLE_LEECH,
	CollectibleType.COLLECTIBLE_BBF, CollectibleType.COLLECTIBLE_BOBS_BRAIN, CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
	CollectibleType.COLLECTIBLE_ISAACS_HEART, CollectibleType.COLLECTIBLE_LIL_HAUNT, CollectibleType.COLLECTIBLE_MONGO_BABY,
	CollectibleType.COLLECTIBLE_INCUBUS, CollectibleType.COLLECTIBLE_FATES_REWARD, CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
	CollectibleType.COLLECTIBLE_LIL_GURDY, CollectibleType.COLLECTIBLE_SERAPHIM, CollectibleType.COLLECTIBLE_FARTING_BABY,
	CollectibleType.COLLECTIBLE_SUCCUBUS, CollectibleType.COLLECTIBLE_PAPA_FLY, CollectibleType.COLLECTIBLE_LIL_LOKI,
	CollectibleType.COLLECTIBLE_FINGER, CollectibleType.COLLECTIBLE_DEPRESSION, CollectibleType.COLLECTIBLE_LIL_MONSTRO,
	CollectibleType.COLLECTIBLE_KING_BABY, CollectibleType.COLLECTIBLE_BIG_CHUBBY, CollectibleType.COLLECTIBLE_ACID_BABY,
	CollectibleType.COLLECTIBLE_BLOODSHOT_EYE, CollectibleType.COLLECTIBLE_7_SEALS, CollectibleType.COLLECTIBLE_LIL_SPEWER,
	CollectibleType.COLLECTIBLE_HALLOWED_GROUND, CollectibleType.COLLECTIBLE_BOILED_BABY, CollectibleType.COLLECTIBLE_FREEZER_BABY,
	CollectibleType.COLLECTIBLE_BOT_FLY, CollectibleType.COLLECTIBLE_FRUITY_PLUM, CollectibleType.COLLECTIBLE_LIL_ABADDON,
	CollectibleType.COLLECTIBLE_LIL_PORTAL, CollectibleType.COLLECTIBLE_TWISTED_PAIR, CollectibleType.COLLECTIBLE_BIRD_CAGE
}
PST.grandConsonanceWhitelist = {
	FamiliarVariant.BROTHER_BOBBY, FamiliarVariant.SISTER_MAGGY, FamiliarVariant.LITTLE_CHUBBY, FamiliarVariant.SACK_OF_PENNIES,
	FamiliarVariant.ROBO_BABY, FamiliarVariant.LITTLE_CHAD, FamiliarVariant.RELIC, FamiliarVariant.LITTLE_GISH,
	FamiliarVariant.LITTLE_STEVEN, FamiliarVariant.DEMON_BABY, FamiliarVariant.DEAD_BIRD, FamiliarVariant.BOMB_BAG,
	FamiliarVariant.BUM_FRIEND, FamiliarVariant.GHOST_BABY, FamiliarVariant.HARLEQUIN_BABY, FamiliarVariant.DADDY_LONGLEGS,
	FamiliarVariant.RAINBOW_BABY, FamiliarVariant.HOLY_WATER, FamiliarVariant.GUPPYS_HAIRBALL, FamiliarVariant.DRY_BABY,
	FamiliarVariant.JUICY_SACK, FamiliarVariant.ROBO_BABY_2, FamiliarVariant.ROTTEN_BABY, FamiliarVariant.HEADLESS_BABY,
	FamiliarVariant.LEECH, FamiliarVariant.MYSTERY_SACK, FamiliarVariant.BBF, FamiliarVariant.BOBS_BRAIN,
	FamiliarVariant.LIL_BRIMSTONE, FamiliarVariant.ISAACS_HEART, FamiliarVariant.LIL_HAUNT, FamiliarVariant.DARK_BUM,
	FamiliarVariant.CAINS_OTHER_EYE, FamiliarVariant.SAMSONS_CHAINS, FamiliarVariant.MONGO_BABY, FamiliarVariant.INCUBUS,
	FamiliarVariant.FATES_REWARD, FamiliarVariant.LIL_CHEST, FamiliarVariant.CHARGED_BABY,
	FamiliarVariant.LIL_GURDY, FamiliarVariant.CENSER, FamiliarVariant.KEY_BUM, FamiliarVariant.RUNE_BAG,
	FamiliarVariant.SERAPHIM, FamiliarVariant.SPIDER_MOD, FamiliarVariant.FARTING_BABY, FamiliarVariant.GB_BUG,
	FamiliarVariant.SUCCUBUS, FamiliarVariant.PAPA_FLY, FamiliarVariant.LIL_LOKI, FamiliarVariant.MILK,
	FamiliarVariant.FINGER, FamiliarVariant.DEPRESSION, FamiliarVariant.LIL_MONSTRO, FamiliarVariant.KING_BABY,
	FamiliarVariant.BIG_CHUBBY, FamiliarVariant.ACID_BABY, FamiliarVariant.SACK_OF_SACKS, FamiliarVariant.MOMS_RAZOR,
	FamiliarVariant.BLOODSHOT_EYE, FamiliarVariant.LIL_HARBINGERS, FamiliarVariant.LIL_SPEWER, FamiliarVariant.MYSTERY_EGG,
	FamiliarVariant.HALLOWED_GROUND, FamiliarVariant.JAW_BONE, FamiliarVariant.ISAACS_HEAD,
	FamiliarVariant.BOILED_BABY, FamiliarVariant.FREEZER_BABY, FamiliarVariant.BOT_FLY,
	FamiliarVariant.FRUITY_PLUM, FamiliarVariant.LIL_ABADDON, FamiliarVariant.LIL_PORTAL, FamiliarVariant.TWISTED_BABY,
	131 -- My Shadow
}
-- Generated when relevant
PST.ultraSecretPool = {}
PST.blueItemPool = {}
PST.ItemPoolType = {
	---@diagnostic disable-next-line: undefined-field
    POOL_BLUE = Isaac.GetPoolIdByName("blueItems")
}

-- First update when entering a new floor
PST.floorFirstUpdate = false

-- For cache updates that need to happen a couple frames later
PST.delayedCacheUpdate = 0
PST.delayedCacheFlags = 0

function PST:copyTable(dataTable)
	local tmpTable = {}
	if type(dataTable) == "table" then
	  	for k, v in pairs(dataTable) do
			tmpTable[k] = PST:copyTable(v)
		end
	else
	  	tmpTable = dataTable
	end
	return tmpTable
end

function PST:resetMods()
	-- List of available tree modifiers
	PST.treeMods = {
		allstats = 0, -- Flat addition to damage, luck, speed, tears, shot speed and range
		damage = 0,
		luck = 0,
		speed = 0,
		tears = 0,
		shotSpeed = 0,
		range = 0,
		xpgain = 0,
		respecChance = 30, -- Chance to gain respec on floor clear
		secretXP = 0, -- Flat xp granted when entering a secret room
		challengeXP = 0, -- Flat xp granted when completing a challenge room round
		challengeXPgain = 0, -- Extra XP gain % within a challenge room
		bossChallengeXP = false, -- Whether challenge room XP mods apply to boss challenge rooms
		xpgainNormalMob = 0, -- Extra XP gain for normal mobs
		xpgainBoss = 0, -- Extra XP gain for bosses
		beggarLuck = 0, -- Flat luck granted when offering to a beggar
		devilChance = 0, -- Extra chance to spawn devil/angel room, overrides stage penalty similar to goat's head/eucharist
		coinDupe = 0, -- Chance to gain an extra coin when picking one up
		keyDupe = 0, -- Chance to gain an extra key when picking one up
		bombDupe = 0, -- Chance to gain an extra bomb when picking one up
		grabBag = 0, -- Chance to spawn a grab bag when picking up a coin/key/bomb
		mapChance = 0, -- Chance to reveal the map on floor beginning (applied from floor 2 onwards)

		allstatsPerc = 0, -- Multiplier version of allstats
		damagePerc = 0,
		rangePerc = 0,
		tearsPerc = 0,
		speedPerc = 0,
		shotSpeedPerc = 0,
		luckPerc = 0,

		floorLuckPerc = 0,
		floorLuck = 0,

		staticEntitiesCache = {}, -- For storing the state of 'static entities' such as fireplaces, poop and tinted rocks
		roomClearProc = false,

		roomGotHitByMob = false,
		floorGotHit = false,
		runGotHit = false,

		firstRoomID = 0,

		luckyPennyChance = 0,
		cardFloorLuck = 0,
		pillFloorLuck = 0,
		secretRoomFloorLuck = 0,
		fireXP = 0,
		poopXP = 0,
		tintedRockXP = 0,
		tintedRockAllstats = 0,
		planetariumChance = 0,
		planetariumAllstats = 0,
		planetariumAllstatsProc = false,
		secretRoomRandomStat = 0,
		firstItemDamage = 0,
		firstItemTears = 0,
		firstItemRange = 0,
		firstItemSpeed = 0,
		firstItemShotspeed = 0,
		firstItemLuck = 0,
		cardAgainstHumanityProc = false,
		bossChallengeUnlock = 0,
		bossChallengeUnlockProc = false,
		floorSmeltTrinket = 0,
		shopSaving = 0,
		shopSavingCache = {},
		beggarLuckTotal = 0,
		vurpProc = false,

		curseAllstats = 0,
		curseAllstatsActive = false,
		curseRoomSpikesOut = 0,
		curseRoomSpikesOutProc = false,
		goldenKeyConvert = 0,
		goldenKeyConvertProc = false,
		sacrificeRoomHearts = 0,
		sacrificeRoomHeartsSpawned = 0,
		naturalCurseCleanse = 0,
		naturalCurseCleanseProc = false,
		goldenTrinkets = 0,
		championChance = 0,
		activeItemReroll = 0,
		activeItemRerolled = 0,
		d7Proc = false,
		spiderMod = false,
		eldritchMapping = false,
		eldritchMappingDebuffs = 0,
		trollBombDisarm = 0,

		craftingBagFull = false,

		causeCurse = false, -- If true, causes a curse when entering the next floor then flips back to false. Skipped by items like black candle

		updateTrackers = {
			playerTypeTracker = 0,
			jacobHeartDiffTracker = 0,
			luckTracker = 0,
			familiarsTracker = 0,
			coinTracker = 0,
			holyMantleTracker = 0,
			lvlCurseTracker = 0,
			charTracker = "",
			pocketTracker = 0,
			craftBagPickups = 0,
			isBerserk = false,
			bloodCharges = 0
		},

		-- 'Keystone' nodes
		relearning = false,
		relearningFloors = 0,
		expertSpelunker = 0,
		hellFavour = false,
		heavenFavour = false,
		-- If set to a character's PlayerType, achievements can be unlocked as if playing that character while playing a different one.
		-- e.g. If set to PlayerType.PLAYER_CAIN, killing ??? in the chest will unlock Cain's Eye.
		cosmicRealignment = false, ---@type boolean|PlayerType
		-- Helper vars for Cosmic Realignment effects
		cosmicRCache = {
			lazarusHasDied = false,
			blueBabyHearts = 0,
			eveActive = false,
			samsonDmg = 0,
			lilithActive = false,
			keeperFloorCoins = 0,
			forgottenKeeperDebuff = 0,
			bethanyKeeperLuck = 0,
			jacobProcs = 0,
			TIsaacProc = false,
			TIsaacItems = 0,
			TCainActive = false,
			TCainUses = 0,
			TJudasDmgUps = 0,
			TSamsonBuffer = 0,
			TLazarusBank1 = { active = true, red = 0, max = 0, soul = 0, black = 0, bone = 0, rotten = 0, broken = 0, eternal = 0 },
			TLazarusBank2 = { red = 0, max = 0, soul = 4, black = 0, bone = 0, rotten = 0, broken = 0, eternal = 0 },
			TEdenDebuff = {
				damage = -0.15, luck = -0.15, speed = -0.15, tears = -0.15, shotSpeed = -0.15, range = -0.15,
				damagePerc = 0, luckPerc = 0, speedPerc = 0, tearsPerc = 0, shotSpeedPerc = 0, rangePerc = 0
			},
			TLostKeeperCoins = 0,
			TApollyonLocusts = 0,
			TForgottenTracker = { soul = false, bone = false, keeperCoin = false, keeperHeal = false },
			TBethanyDeadWisps = 0
		},

		--#region CHARACTER TREE MODS --
        ---- Isaac's tree ----
        isaacBlessing = 0, -- Mom Heart Proc
        magicDie = false,
        magicDieData = {
            source = "none", -- Can be: "none" (not procced yet), "any" (unspecified room), "angel", "devil", "boss", "treasure" (for both treasure room and shop)
            value = 0
        },
        intermittentConceptions = false,
		intermittentProc = 0,
        allstatsBirthright = 0,
        allstatsRoom = 0,
        allstatsRoomProc = false,
        d6Pickup = 0,
        d6HalfCharge = 0,
        ---- Magdalene's tree ----
        allstatsFullRed = 0,
        allstatsFullRedProc = false,
        magdaleneBlessing = false,
        crystalHeart = false,
        bloodDonor = false,
        yumHeartHealHalf = 0,
        bloodMachineSpawn = 0,
        bloodDonationLuck = 0,
		bloodDonationLuckBuff = 0,
        bloodDonationNickel = 0,
        healOnClear = 0,
		---- Cain's tree ----
		impromptuGambler = false,
		impromptuGamblerProc = false,
		impromptuGamblerItemRemoved = false,
		thievery = false,
		thieveryGreedProc = false,
		fickleFortune = false,
		fickleFortuneActive = false,
		stealChance = 0,
		trinketSpawn = 0,
		freeMachinesChance = 0,
		arcadeReveal = 0,
		shopReveal = 0,
		nickelOnClear = 0,
		---- Judas' Tree ----
		darkHeart = false,
		darkHeartActive = false,
		darkHeartBelial = false,
		innerDemon = false,
		innerDemonActive = false,
		sacrificeDarkness = false,
		blackHeartSacrifices = 0,
		darkJudasSpeed = 0,
		darkJudasShotspeedRange = 0,
		belialBossHitCharge = 0,
		belialChargesGained = 0,
		lostBlackHeartsLuck = 0,
		lostBlackHeartsLuckBuff = 0,
		---- Blue Baby's Tree ----
		blueGambit = false,
		blueGambitPillSwap = { old = nil, new = nil },
		blueGambitCardProc = false,
		blueGambitPillProc = false,
		brownBlessing = false,
		slippingEssence = false,
		slippingEssenceLost = 0,
		soulOnCardPill = 0,
		poopItemLuck = 0,
		poopTrinketLuck = 0,
		poopTrinketLuckActive = false,
		thePoopAllStats = 0,
		thePoopAllStatsPerc = 0,
		poopAllStatsProc = false,
		soulHeartTearsRange = 0,
		soulHeartTearsRangeTotal = 0,
		hallowedGroundProc = false,
		---- Eve's Tree ----
		heartless = false,
		heartlessTotal = 0,
		darkProtection = false,
		darkProtectionProc = false,
		carrionAvian = false,
		carrionAvianBossProc = 0,
		carrionAvianTempBonus = 0,
		deadBirdNullify = 0,
		activeDeadBirdDamage = 0,
		activeDeadBirdSpeed = 0,
		activeDeadBirdTears = 0,
		activeDeadBirdRange = 0,
		activeDeadBirdShotspeed = 0,
		deadBirdInheritDamage = 0,
		luckOnClearBelowFull = 0,
		luckOnClearBelowFullBuff = 0,
		allStatsOneRed = 0,
		allStatsOneRedActive = false,
		---- Samson's Tree ----
		hasted = false,
		hastedHits = 0,
		rageBuildup = false,
		rageBuildupTotal = 0,
		hearty = false,
		samsonTempDamage = 0,
		samsonTempSpeed = 0,
		samsonTempActive = false,
		samsonTempTime = 0,
		speedWhenHit = 0,
		speedWhenHitTotal = 0,
		bossCulling = 0,
		bossQuickKillLuck = 0,
		bossQuickKillLuckBuff = 0,
		bossFlawlessLuck = 0,
		bossFlawlessLuckBuff = 0,
		---- Azazel's Tree ----
		demonicSouvenirs = false,
		demonicSouvenirsProc = false,
		demonicSouvenirsTrinket = false,
		demonHelpers = false,
		demonHelpersBeggarChance = 5,
		heartsToBlack = 0,
		blackHeartOnDeals = 0,
		evilTrinketLuck = 0,
		devilBeggarBlackHeart = 0,
		cardFloorDamage = 0,
		cardFloorDamageTotal = 0,
		cardFloorTears = 0,
		cardFloorTearsTotal = 0,
		---- Lazarus' Tree ----
		soulfulAwakening = false,
		kingCurse = false,
		kingCurseActive = false,
		aTrueEnding = false,
		aTrueEndingCardUses = 0,
		lazarusDamage = 0,
		lazarusSpeed = 0,
		lazarusTears = 0,
		lazarusRange = 0,
		lazarusLuck = 0,
		luckyAllStats = 0,
		luckyAllStatsActive = false,
		momPlanC = 0,
		lazarusClearHearts = 0,
		---- Eden's Tree ----
		chaoticTreasury = false,
		sporadicGrowth = false,
		starblessed = false,
		starblessedProc = false,
		treasureShopItemStat = 0,
		treasureShopItemStatPerc = 0,
		devilAngelBossItemStat = 0,
		devilAngelBossItemStatPerc = 0,
		itemRandLuck = 0,
		itemRandLuckPerc = 0,
		trinketRandLuck = 0,
		startCoinKeyBomb = 0,
		edenBlessingSpawn = 0,
		edenBlessingSpawned = false,
		---- The Lost's Tree ----
		spectralAdvantage = false,
		spectralAdvantageHearts = 0,
		sacredAegis = false,
		heartseekerPhantasm = false,
		heartseekerPhantasmCollected = 0,
		killingHitNegation = 0,
		noHolyMantleAllStats = 0,
		noHolyMantleAllStatsActive = false,
		soulHeartTears = 0,
		soulHeartTearsTotal = 0,
		blackHeartDamage = 0,
		blackHeartDamageTotal = 0,
		eternalD6Charge = 0,
		soulHeartOnClear = 0,
		---- Lilith's Tree ----
		minionManeuvering = false,
		totalFamiliars = 0,
		heavyFriends = false,
		daemonArmy = false,
		familiarKillSoulHeart = 0,
		activeFamiliarsLuck = 0,
		activeIncubusDamage = 0,
		activeIncubusTears = 0,
		boxOfFriendsCharge = 0,
		boxOfFriendsAllStats = 0,
		boxOfFriendsAllStatsProc = false,
		---- Keeper's Tree ----
		keeperBlessing = false,
		keeperBlessingHeals = 0,
		gulp = false,
		gulpActive = false,
		avidShopper = false,
		coinShield = 0,
		itemPurchaseLuck = 0,
		itemPurchaseLuckBuff = 0,
		purchaseKeepCoins = 0,
		firstBossGreed = 0,
		firstBossGreedProc = false,
		greedLowerHealth = 0,
		greedNickelDrop = 0,
		greedDimeDrop = 0,
		blueFlyDeathDamage = 0,
		blueFlyDeathDamageTotal = 0,
		---- Apollyon's Tree ----
		apollyonBlessing = false,
		null = false,
		nullActiveAbsorbed = false,
		nullAppliedBonus = 0,
		nullDebuff = false,
		harbingerLocusts = false,
		harbingerLocustsFloorProc = false,
		harbingerLocustsChampDrop = false,
		voidBlueFlies = 0,
		voidBlueSpiders = 0,
		voidAnnihilation = 0,
		eraserSecondFloor = 0,
		eraserSecondFloorProc = false,
		locustHeldLuck = 0,
		locustConsumedLuck = 0,
		conquestLocustSpeed = 0,
		deathLocustTears = 0,
		famineLocustRangeShotspeed = 0,
		pestilenceLocustLuck = 0,
		warLocustDamage = 0,
		---- The Forgotten's Tree ----
		soulful = false,
		spiritEbb = false,
		innerFlare = false,
		innerFlareProc = false,
		forgottenMeleeTearBuff = 0,
		forgottenSoulDamage = 0,
		forgottenSoulTears = 0,
		theSoulBoneDamage = 0,
		theSoulBoneTears = 0,
		innerFlareSlowDuration = 2,
		---- Bethany's Tree ----
		willOTheWisp = false,
		willOTheWispDmgBuff = 0,
		soulTrickle = false,
		soulTrickleWispDrops = 0,
		fatePendulum = false,
		fatePendulumDebuffActive = false,
		activeItemWisp = 0,
		chargeOnClear = 0,
		soulChargeOnClear = 0,
		wispDestroyedLuck = 0,
		wispDestroyedLuckTotal = 0,
		wispFloorBuff = 0,
		wispFloorBuffTotal = 0,
		redHeartsSoulCharge = 0,
		---- Jacob & Esau's Tree ----
		heartLink = false,
		statuePilgrimage = false,
		coordination = false,
		brotherHitNegation = 0,
		jacobHeartLuck = 0,
		jacobBirthright = 0,
		jacobBirthrightProc = false,
		jacobHeartOnKill = 0,
		jacobHeartOnKillProc = false,
		esauSoulOnKill = 0,
		esauSoulOnKillProc = false,
		jacobItemAllstats = 0,
		---- Siren's Tree ----
		darkSongstress = false,
		darkSongstressActive = false,
		songOfDarkness = false,
		songOfDarknessChance = 2,
		songOfFortune = false,
		songOfCelerity = false,
		songOfCelerityBuff = 0,
		songOfAwe = false,
		songOfAweActive = false,
		overwhelmingVoice = false,
		overwhelmingVoiceBuff = 0,
		luckOnCharmedKill = 0,
		mightOfFortune = 0,
		charmedRetaliation = 0,
		charmedHitNegation = 0,
		charmedHitNegationProc = false,
		charmExplosions = 0,
		--#endregion

		--#region TAINTED CHARACTER TREE MODS --
		---- General Tainted ----
		coalescingSoulChance = 0,
		coalescingSoulProcs = 1,
		warpedCoalescence = false,
		coalSoulRoomClearChance = 0,
		coalSoulHitChance = 0,
		soulStoneAllstats = 0,
		soulStoneAllstatsProc = false,
		soulStoneUnusedAllstats = 0,

		---- T. Isaac ----
		vacuophobia = false,
		consumingVoid = false,
		consumingVoidSpawned = false,
		consumingVoidConsumed = 0,
		fracturedRemains = false,
		obtainedItemDamage = 0,
		obtainedItemTears = 0,
		obtainedItemRange = 0,
		flawlessBossLuck = 0,
		voidConsumeLuck = 0,
		diceShardRuneShard = 0,
		runicSpeed = 0,
		runicSpeedBuff = 0,
		runeshardStacking = false,
		runeshardStacks = 0,
		runeshardStacksReq = 0,
		blackRuneAssembly = 0,
		blackRuneAbsorb = 0,
		blackRuneInnateItems = {},
		sinistralRunemaster = false,
		dextralRunemaster = false,
		ehwazAllstatsProc = false,
		dagazBuff = 0,
		ansuzMapreveal = 0,
		algizBuffTimer = 0,
		algizBuffProc = false,
		---- T. Magdalene ----
		taintedHealth = false,
		testOfTemperance = false,
		bloodful = false,
		bloodfulBuff = 0,
		bloodfulDebuffProc = false,
		lingeringMalice = false,
		remainingHeartsSpeed = 0,
		remainingHeartsDmg = 0,
		remainingHeartsTears = 0,
		temporaryHeartTime = 0,
		temporaryHeartDmg = 0,
		temporaryHeartTears = 0,
		temporaryHeartLuck = 0,
		temporaryHeartLuckBuff = 0,
		creepDamage = 0,
		halfHeartPickupToFull = 0,
		bloodDonoTempHeart = 0,
		---- T. Cain ----
		ransacking = false,
		ransackingRoomPickups = 0,
		magicBag = false,
		opportunist = false,
		grandIngredientCoins = false,
		grandIngredientKeys = false,
		grandIngredientBombs = false,
		grandIngredientHearts = false,
		craftBagMeleeDmgInherit = 0,
		craftPickupRecovery = 0,
		randPickupOnClear = 0,
		droppedSpecialPickups = 0,
		itemCraftingLuck = 0,
		bagBombDamage = 0,
		bagKeyTears = 0,
		bagCoinRangeLuck = 0,
		bagHeartSpeed = 0,
		additionalPedestalPickup = 0,
		---- T. Judas ----
		darkExpertise = false,
		stealthTactics = false,
		lightlessBounty = false,
		lightlessBountyLuck = 0,
		annihilation = false,
		anarchy = false,
		howToJumpPulse = 0,
		darkArtsCDReset = 0,
		darkArtsDmg = 0,
		darkArtsCD = 0,
		darkArtsTears = 0,
		nonDarkArtsDmg = 0,
		darkArtsKillStat = 0,
		darkArtsKills = 0,
		darkArtsKillStatBuffs = {},
		trollBombProtection = 0,
		trollBombKillLuck = 0,
		---- T. Blue Baby ----
		alacritousPurpose = false,
		alacritousTearBuff = 0,
		alacritousLuckBuff = 0,
		alacritousFlyProc = false,
		treasuredWaste = false,
		treasuredWasteOldPoop = 0,
		asceticSoul = false,
		asceticSoulDrops = 0,
		slothLegacy = false,
		slothLegacyProc = false,
		holdPoopRegain = 0,
		holdEmptySpeed = 0,
		holdFullLuck = 0,
		poopDamageBuff = 0,
		poopPickupEnlarge = 0,
		poopTransmutation = 0,
		bobHeadFlySpawn = 0,
		bobHeadFliesSpawned = 0,
		holdBrownNugget = 0,
		holdBrownNuggetProcs = 0,
		specialPoopFind = 0,
		specialPoopFindReplaced = 0,
		rainbowPoopLuck = 0,
		rainbowPoopLuckBuff = 0,
		rainbowPoopSoul = 0,
		---- T. Eve ----
		bloodwrath = false,
		resilientBlood = false,
		blessedBlood = false,
		congealedBuddy = false,
		mysticVampirism = false,
		mysticVampirismKills = 0,
		mysticVampirismProcs = 0,
		clotHeartDrop = 0,
		clotHitPulse = false,
		clotPulseDmgInherit = 0,
		lilClotDmg = 0,
		redClotAbsorbDmg = 0,
		redClotAbsorbBuff = 0,
		soulClotAbsorbTears = 0,
		soulClotAbsorbBuff = 0,
		clotDmg = 0,
		redClotHeartDmg = 0,
		soulClotHeartDmg = 0,
		blackClotBabylon = 0,
		clotDestroyedLuck = 0,
		---- T. Samson ----
		balancedApproach = false,
		tempered = false,
		temperedBuff = 0,
		violentMarauder = false,
		violentMarauderRemoved = false,
		absoluteRage = false,
		absoluteRageCharge = 150,
		absoluteRageBirthright = false,
		meleeDmg = 0,
		nonMeleeDmg = 0,
		berserkHitChargeGain = 0,
		berserkDuration = 0,
		berserkDmg = 0,
		berserkSpeed = 0,
		berserkTears = 0,
		suplexCooldown = 0,
		berserkSize = 0,
		berserkKillTempHeart = 0,
		redHeartLuckSamson = 0,
		redHeartLuckBuff = 0,
		berserkSpdTradeoff = 0,
		---- T. Azazel ----
		curseborne = false,
		gildedRegrowth = false,
		gildedRegrowthDebuff = false,
		gildedRegrowthKills = 0,
		brimsoul = false,
		brimsoulProc = false,
		darkBestowal = false,
		darkBestowalKills = 0,
		darkBestowalItem = 0,
		darkBestowalClears = 0,
		hemoptysisSlowChance = 0,
		cursedKillTears = 0,
		cursedKillTearsBuff = 0,
		proximityDamage = 0,
		hemoptysisSpeed = 0,
		brimstoneDmg = 0,
		brimstoneDmgApplied = false,
		flightlessDevilDeal = 0,
		flightlessDevilCache = {},
		hemoptysisKillLuck = 0,
		---- T. Lazarus ----
		ephemeralBond = 0,
		ephemeralBondForm = 0,
		ephemeralBondItems = {},
		greatOverlap = false,
		entanglement = false,
		entanglementProc = false,
		spiritus = false,
		ephBondBossHitless = 0,
		ephBondFloor = 0,
		gainedTempEphBond = 0,
		flipBossHitCharge = 0,
		flipSpecialRoomCharge = 0,
		flipMobHPDown = 0,
		flipMobHPDownProcs = 0,
		floorWoodenChest = 0,
		lazFormKillStat = 0,
		lazFormKillStatProcs = 0,
		lazFormKills = 0,
		lazFormDeadKills = 0,
		lazFormStatCache = {},
		lazFormDeadStatCache = {},
		formHeartDiffLuck = 0,
		---- T. Eden ----
		serendipitousSoul = false,
		serendSoulUsed = false,
		blessedCrucifix = false,
		normalizedVitality = false,
		chaosTakeTheWorld = false,
		chaosTakeTheWorldProc = false,
		rerollAvoidance = 0,
		devilActiveOnHit = 0,
		devilActiveOnHitProc = false,
		angelActiveOnHit = 0,
		angelActiveOnHitProc = false,
		birthrightActiveRemoveChance = 0,
		shieldActiveStat = 0,
		shieldActiveStatProc = false,
		shieldActiveStatList = {},
		treasureItemOnHit = 0,
		treasureItemOnHitItem = 0,
		higherQualityReroll = 0,
		higherQualityRerollProcs = 0,
		minLuckSet = false,
		minLuck = 0,
		---- T. Lost ----
		glassSpecter = false,
		glassSpecterShieldClears = 0,
		helpingHands = false,
		helpingHandsMomProc = false,
		holyCardStacks = 0,
		deferredAegis = false,
		deferredAegisCardUses = 0,
		spindown = false,
		spindownUses = 0,
		spindownDebuff = 0,
		quality0Upgrade = 0,
		quality1Upgrade = 0,
		quality2Upgrade = 0,
		roomEnterSpd = 0,
		roomEnterSpdDecayDur = 0,
		shieldlessBossSpeed = 0,
		shieldlessBossProc = false,
		shieldlessBossDone = false,
		shieldlessBossSpeedApplied = false,
		champHolyCardDrop = 0,
		champHolyCardDropFloors = 0,
		stairwayBoon = 0,
		deathTrial = 0,
		deathTrialProc = false,
		deathTrialActive = false,
		holyCardLuck = 0,
		holyCardLuckBuff = 0,
		---- T. Lilith ----
		chargingBehemoth = false,
		mightyGestation = false,
		coordinatedDemons = false,
		chimericAmalgam = false,
		chimericAmalgamFloors = 0,
		chimericAmalgamDmgBonus = 0,
		whipDmg = 0,
		nonWhipDmg = 0,
		gelloPulseDmg = 0,
		pulseKillBlackHeart = 0,
		pulseKillBlackHeartProc = false,
		whipSpeed = 0,
		gelloTearsBonus = 0,
		cordDamage = 0,
		cordBleed = 0,
		tLilithTreasureBaby = 0,
		nearbyKillLuck = 0,
		nearbyKillLuckBuff = 0,
		familiarItemAllstats = 0,
		---- T. Keeper ----
		fortunateSpender = false,
		fortunateSpenderLuckActive = false,
		fortunatePurchases = 0,
		fortunateSpenderBuff = 0,
		marquessOfFlies = false,
		marquessOfFliesHive = false,
		marquessFliesCache = 0,
		strangeCoupon = false,
		strangeCouponCharges = 0,
		strangeCouponUses = 0,
		strangeCouponSteam = 0,
		blessedPennies = false,
		blessedPenniesSoldTrinket = 0,
		voodooTrick = false,
		voodooTrickHits = 0,
		couponNullifyChance = 0,
		vanishCoinTimer = 0,
		coinTearsChance = 0,
		gildMonsters = 0,
		gildMonsterPenny = 0,
		gildMonsterLuck = 0,
		gildMonsterLuckBuff = 0,
		gildMonsterSpeed = 0,
		gildMonsterSpeedBuff = 0,
		gildMonsterPennyUpgrade = 0,
		voodooCurseNickel = 0,
		blueFlyDamage = 0,
		steamSaleKeep = 0,
		---- T. Apollyon ----
		electrifiedSwarm = false,
		closeKeeper = false,
		carrionLocusts = false,
		carrionLocustStats = {},
		carrionLocustKills = 0,
		greatDevourer = false,
		greatDevourerBoost = 0,
		locustDmg = 0,
		extCordDmgInherit = 0,
		extCordSlow = 0,
		locustTears = 0,
		locustTearDmgInherit = 0,
		locustTearSpectral = 0,
		locustKillPickup = 0,
		locustKillPickupProcs = 0,
		locustKillTears = 0,
		killCricketLeg = 0,
		killCricketLegProc = false,
		cricketLegSpeed = 0,
		locustKillLuck = 0,
		locustKillLuckBuff = 0,
		---- T. Forgotten ----
		forgRecall = false,
		forgRecallUses = 0,
		harmonizedSpecters = false,
		ballistosseous = false,
		magnetizedShell = false,
		magnetizedShellBuff = 0,
		forgHoldSpeed = 0,
		forgNoHoldSpeed = 0,
		forgIsHeld = false,
		forgBoneTearDmg = 0,
		forgBoneTearPara = 0,
		forgBoneTearSlow = 0,
		paraEnemyDmg = 0,
		recallDmg = 0,
		forgTelekinesis = 0,
		flawlessClearPBone = 0,
		flawlessPBoneProc = false,
		forgBoneTearKillLuck = 0,
		forgBoneTearLuckBuff = 0,
		---- T. Bethany ----
		bloodHarvest = false,
		bloodHarvestDrops = 0,
		bloodHarvestBossDrops = 0,
		resilientFlickers = false,
		othersideSeeker = false,
		othersideSeekerBuff = 0,
		inheritedChaos = false,
		inheritedChaosDebuff = 0,
		redHeartRoomDmg = 0,
		redHeartRoomDmgBuff = 0,
		wispHomingTearRetal = 0,
		wispActiveTears = 0,
		destroyedWispItem = 0,
		destroyedWispItemList = {},
		blueKeyRedClear = 0,
		blueKeyRedClearProc = false,
		bloodChargeStat = 0,
		bloodChargeStatList = {},
		bloodChargeStatProcs = 0,
		wispKillSoul = 0,
		wispKillSoulDrops = 0,
		tBethHomingTear = 0,
		tBethHomingTearFear = 0,
		tBethKillLuck = 0,
		---- T. Jacob ----
		reaperWraiths = false,
		reaperWraithsSpawned = false,
		wrathfulChains = false,
		spiritualCovenant = false,
		kineticVengeance = false,
		chainedEnemyDmg = 0,
		darkEsauProxDmgSpeed = 0,
		darkEsauDmg = 0,
		animaSolaCooldown = 0,
		animaSolaKillTears = 0,
		animaSolaKillTearsBuff = 0,
		heartEternalConv = 0,
		slowEnemyDmg = 0,
		animaSolaDuration = 0,
		darkEsauKillLuck = 0,
		darkEsauKillLuckBuff = 0,
		animaAddChains = 0,
		---- T. Siren ----
		shadowmeld = false,
		darkArpeggio = false,
		chromaticBlessing = false,
		chromBlessingBuffs = {},
		grandConsonance = false,
		grandConsonanceDmg = 0,
		grandConsonanceCache = {},
		songOfTheFew = false,
		songOfTheFewItems = 0,
		fearedDmg = 0,
		fearedTearBurst = 0,
		acridGaze = 0,
		sirenMinionDmg = 0,
		darkArpeggioTearDelay = 0,
		shadowmeldExplosion = 0,
		shadowmeldExplosionDmg = 0,
		blackHeartFearKill = 0,
		blackHeartFearKillGiven = 0,
		fearedKillLuck = 0,
		fearedKillLuckBuff = 0,
		soulOfTheSiren = false,
		sirenOldMelody = -1,
		--#endregion

		--#region STAR TREE --
		azureStarSockets = 0,
		crimsonStarSockets = 0,
		viridianStarSockets = 0,
		ancientStarSockets = 0,
		azureStarmight = 0,
		crimsonStarmight = 0,
		viridianStarmight = 0,
		ancientStarmight = 0,

		---- Starcursed jewel helpers ----
		starmight = 0,
		enableSCJewels = false,
		SC_bossrushJewel = false,
		SC_jewelDropOnClear = 0,
		SC_SMMightyChance = 0,
		SC_SMAncientChance = 0,
		SC_firstFloorXPHalvedProc = false,
		SC_circadianStatsDown = 0,
		SC_umbraStatsDown = 0,
		SC_umbraNightLightSpawn = false,
		SC_cursedStarpieceDebuff = false,
		SC_opalescentProc = false,
		SC_iridescentItems = {},
		SC_levelHasChall = false,
		SC_challDebuff = false,
		SC_challClear = false,
		SC_challStairwayProc = false,
		SC_luminescentUsedCard = false,
		SC_luminescentDebuff = 0,
		SC_baubleSeekerBuff = 0,
		SC_chroniclerRooms = 0,
		SC_chroniclerDebuff = 0,
		SC_martianDebuff = 0,
		SC_saturnianSpeedDown = false,
		SC_nullstoneEnemies = {},
		SC_nullstoneProc = false,
		SC_nullstoneClear = false,
		SC_sanguinisProc = false,
		SC_sanguinisTookDmg = false,
		SC_nightProjProc = false,
		SC_empHeirloomActive = false,
		SC_empHeirloomDebuff = 0,
		SC_empHeirloomProc = false,
		SC_empHeirloomUsedCard = false,
		SC_empHeirloomRoomID = -1,
		SC_cursedAuricTimer = 0,
		SC_cursedAuricSpeedProc = false,
		SC_causeConvBoss = nil,
		SC_causeConvBossVariant = 0,
		SC_glowingGlassDebuff = 0,
		SC_glowingGlassProcs = 0,
		SC_tellurianBuff = 0,
		SC_astralInsigniaLevel = 0,
		SC_astralInsigniaDebuff = 0,
		SC_astralInsigniaItem = 0,
		SC_mightstoneProcs = 0,
		SC_anamnesisDisabled = false,
		SC_anamnesisAuraCache = -1,
		SC_anamnesisCursedRoom = -1,
		SC_anamnesisDevil = {},
		SC_anamnesisAngel = {},
		SC_anamnesisTreasure = {},
		SC_anamnesisOther = {},
		SC_emberAzuriteItems = {},
		--#endregion
	}
	PST.defaultTreeMods = PST:copyTable(PST.treeMods)
	-- Holds temporary data for allocated special nodes
	PST.specialNodes = {
		TJacobEsauSpawned = false,
		impromptuGamblerItems = {}, -- Hold natural items in treasure room
		fickleFortuneVanish = false,
		deadBirdActive = false,
		bossHits = 0,
		bossRoomHitsFrom = 0,
		momDeathProc = false,
		momHeartDeathProc = false,
		sacredAegis = { hitTime = 0, proc = false, hitsTaken = 0 },
		minionManeuveringMaxBonus = 15,
		bossGreedSpawned = false,
		spiritEbbHits = { soul = 0, forgotten = 0 },
		forgottenMeleeTearBuff = 0,
		esauIsStatue = false,
		jacobNearEsauBuff = false,
		coordinationHits = { jacob = 0, esau = 0 },
		jacobHeartLuckVal = 0,
		oneShotProtectedMobs = {},
		mobFirstHitsBlocked = {},
		mobPeriodicShield = false,
		mobHitReduceDmg = 0,
		mobHitRoomExtraDmg = { hits = 0, proc = false },
		itemRemovalProtected = {},
		jeraUseFrame = 0,
		perthroProc = false,
		testOfTemperanceCD = 0,
		lingMaliceCreepList = {},
		temporaryHearts = {},
		temporaryHeartDmgStacks = 0,
		temporaryHeartTearStacks = 0,
		temporaryHeartBuffTimer = 0,
		trollBombDisarmDebuffTimer = 0,
		overwhelmingVoiceProc = false,
		craftBagSnapshot = {},
		darkArtsBossHitProc = false,
		annihilationHitList = {},
		annihilationProcs = 0,
		anarchyBombProcs = 0,
		howToJumpPulseTimer = 0,
		darkArtsTearsTimer = 0,
		levelMazeCurseProc = false,
		poopHeld = 0,
		poopDestroyBuffTimer = 0,
		bloodwrathFlipTimer = 0,
		berserkHitCooldown = 0,
		bossJewelDropProc = 0,
		hemoptysisFired = 0,
		hemoptysisSpeedTimer = 0,
		activeOnHitProc = {
			proc = false,
			pool = ItemPoolType.POOL_DEVIL,
			procMod = ""
		},
		treasureItemOnHitProc = false,
		higherQualityRerollProc = false,
		roomEnterSpdTimer = 0,
		gelloFired = 0,
		gelloEntity = nil,
		coordinatedDemonsDelay = 0,
		coordinatedDemonsWait = 0,
		gelloPulseDmgFlag = false,
		whipSpeedTimer = 0,
		gelloTearBonusStep = 0,
		temporaryCoins = {},
		activeLocusts = {},
		locustKillTearsTimer = 0,
		ballistosseousTimer = 0,
		recallDamageTimer = 0,
		tBethHomingTearTimer = 0,
		animaChainedMobs = {},
		animaNewChains = {},
		checkAnimaChain = false,
		darkEsauChained = false,
		animaUseProcs = false,
		spiritCovenantTarget = nil,
		darkEsauProxBuffTimer = 0,
		sirenUpdateFunc = nil,
		darkArpeggioTimer = 0,
		chromBlessingBuffer = {},
		sirenUsedMelody = -1,
		consonanceLilHauntTimer = 0,
		consonanceLilHauntOut = false,
		consonanceLilHauntBuffTimer = 0,
		acridGazeTimer = 0,
		shadowmeldExplosionFX = {
			sprite = Sprite("gfx/effect_siren_ring.anm2", true),
			position = Vector.Zero
		},

		SC_circadianSpawnTime = 0,
		SC_circadianSpawnProc = false,
		SC_circadianExplImmune = 0,
		SC_soulEaterMobs = {},
		SC_hoveringTears = {},
		SC_exploderTears = {},
		SC_glaceDebuff = 0,
		SC_martianTimer = 0,
		SC_martianProc = false,
		SC_martianTears = {},
		SC_martianFX = {},
		SC_crimsonWarpDebuff = 0,
		SC_crimsonWarpKeyDrop = 0,
		SC_crimsonWarpKeyStacks = 0,
		SC_nullstonePoofFX = {
			sprite = Sprite("gfx/1000.016_poof02_bloodcloud.anm2", true),
			stoneSprite = Sprite("gfx/items/starcursed_jewels.anm2", true),
			x = 0, y = 0
		},
		SC_nullstoneSpawned = 0,
		SC_nullstoneCurrentSpawn = nil,
		SC_nullstoneHPThreshold = 0,
		SC_nightProjTimer = 3600,
		SC_causeConvBossEnt = nil,
		SC_causeConvRespawnTimer = 0,
		SC_glowingGlassProc = false,
		SC_anamnesisResetTimer = 0,
		SC_anamnesisItemPicked = 0,
		SC_anamnesisJustReset = false,
	}
	-- Temporary data for misc custom effects
	PST.specialFX = {
		-- Shadowmeld item
		shadowmeldTransition = false,
		shadowmeldStartFX = Sprite("gfx/effect_shadowmeld_player.anm2", true),
		shadowmeldEndFX = Sprite("gfx/effect_shadowmeld_player.anm2", true),
		shadowmeldStep = 0,
		shadowmeldStartPos = Vector.Zero,
		shadowmeldEndPos = Vector.Zero,
		-- Soul of the Siren effect
		sirenSoulUses = {},
	}
	-- Init sprites
	PST.specialNodes.SC_nullstonePoofFX.sprite.Color = Color(0.04, 0.04, 0.04, 1, 0.04, 0.04, 0.04)
	PST.specialNodes.SC_nullstonePoofFX.sprite.PlaybackSpeed = 0.5
	PST.specialNodes.SC_nullstonePoofFX.stoneSprite:SetFrame("Ancients", 17)
	PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color = Color(1, 1, 1, 0)

	PST.specialNodes.shadowmeldExplosionFX.sprite.Scale = Vector(0.8, 0.8)
	PST.specialNodes.shadowmeldExplosionFX.sprite.Color = Color(0.1, 0.1, 0.1, 1)
	PST.specialNodes.shadowmeldExplosionFX.sprite.PlaybackSpeed = 1.4

	PST.specialFX.shadowmeldStartFX.Scale = Vector(0.8, 0.8)
	PST.specialFX.shadowmeldStartFX.PlaybackSpeed = 0.8
	PST.specialFX.shadowmeldEndFX.Scale = Vector(0.8, 0.8)
	PST.specialFX.shadowmeldEndFX.PlaybackSpeed = 0.8

    PST.modData.firstHeartUpdate = false
	PST.floorFirstUpdate = false
end
function PST:resetData()
	-- Mod data table that's stored in the savefile
	PST.modData = {
		xpObtained = 0,
		level = 1,
		xp = 0,
		xpRequired = PST.startXPRequired,
		skillPoints = 0,
		respecPoints = 4,
		spawnKills = 0,
		treeDisabled = false,

        -- Used for first update on heart-related functions
        firstHeartUpdate = false,
        -- Holds relevant vars, which start at true, are set to false when a new run begins, and become true again once you defeat Mom's Heart
        momHeartProc = {},
		-- List of trees with nodes and whether they're allocated
		treeNodes = {},
		-- List of applied modifiers that stays fixed during a run
		treeModSnapshot = {},

		-- Cosmic Realignment node: false if not allocated, true if allocated without character, char ID if character selected
		cosmicRealignment = false,
		-- Completion tracker for Cosmic Realignment unlocks
		cosmicRCompletions = { [0] = {} },
		charData = {},

		-- Star Tree
		starTreeInventory = {
			Crimson = {},
			Azure = {},
			Viridian = {},
			Ancient = {}
		},
		-- Ancient starcursed jewels identified so far
		identifiedAncients = {},
		-- Collected ancient jewel rewards (e.g. skill points when killing X boss)
		ancientRewards = {},

		-- For initializing new unsupported characters, so they can gain XP
		newChars = {},
		newCharsTainted = {},

		-- Last mod version installed
		lastVersion = ""
	}
	PST:resetMods()
end

-- External Item Descriptions init
if EID then
	-- Starcursed jewel trinkets
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Azure Starcursed Jewel"),
		"Rolls mods that affect monsters' might in a run.#Gets added unidentified to your Star Tree inventory once picked up."
	)
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Crimson Starcursed Jewel"),
		"Rolls mods that affect monsters' defense in a run.#Gets added unidentified to your Star Tree inventory once picked up."
	)
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Viridian Starcursed Jewel"),
		"Rolls mods that can affect a run directly.#Gets added unidentified to your Star Tree inventory once picked up."
	)
	EID:addTrinket(
		Isaac.GetTrinketIdByName("Ancient Starcursed Jewel"),
		"Can feature unique challenge-like run modifiers.#Gets added unidentified to your Star Tree inventory once picked up."
	)

	-- Soul of the Siren soul stone
	if Isaac.GetCardIdByName("SoulOfTheSiren") ~= -1 then
		EID:addCard(
			Isaac.GetCardIdByName("SoulOfTheSiren"),
			"Charms all monsters in the room for 10 seconds.#For the next 60 seconds, gain 3 random baby familiars, a smelted Friendship Necklace, and charm all monsters for 10 seconds when entering a room."
		)
	end

	-- Grand Consonance node (T. Siren's tree)
	local GC_EID_Data = {
		[CollectibleType.COLLECTIBLE_LITTLE_CHUBBY] = "Launched from you",
		[CollectibleType.COLLECTIBLE_DEAD_BIRD] = "After getting hit, launch short lived small dead birds while firing",
		[CollectibleType.COLLECTIBLE_BUM_FRIEND] = "Triggers Bum Friend's reward every 12 coins picked up",
		[CollectibleType.COLLECTIBLE_HOLY_WATER] = "Launched from you",
		[CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL] = "Launched from you, stays active while firing",
		[CollectibleType.COLLECTIBLE_DRY_BABY] = "25% chance to block hits, up to 3 per room. 25% chance on block to trigger Necronomicon",
		[CollectibleType.COLLECTIBLE_LEECH] = "5% chance on kill to gain a 1/2 red heart. If this triggers at full health, 25% chance to gain a 1/2 black heart, up to 3",
		[CollectibleType.COLLECTIBLE_BBF] = "50% chance when hit to trigger an explosion at your position, once per room",
		[CollectibleType.COLLECTIBLE_BOBS_BRAIN] = "Launched from you. On enemy collision, slows down to a halt then explodes after a delay",
		[CollectibleType.COLLECTIBLE_7_SEALS] = "Locusts spawn from you. War locusts no longer explode while you're close",
		[CollectibleType.COLLECTIBLE_LIL_HAUNT] = "When entering a room with monsters, fade away from vision for 3 seconds or until you shoot, confusing monsters",
		[CollectibleType.COLLECTIBLE_DARK_BUM] = "Triggers Dark Bum's reward every 4 total red hearts picked up",
		[CollectibleType.COLLECTIBLE_SAMSONS_CHAINS] = "Launched from you, stays active while firing",
		[CollectibleType.COLLECTIBLE_LIL_GURDY] = "Launched from you",
		[CollectibleType.COLLECTIBLE_CENSER] = "Aura projected from you",
		[CollectibleType.COLLECTIBLE_SUCCUBUS] = "Aura projected from you",
		[CollectibleType.COLLECTIBLE_DEPRESSION] = "Creates puddle from you. Chance when hit to retaliate with a Crack the Sky beam",
		[CollectibleType.COLLECTIBLE_BIG_CHUBBY] = "Launched from you",
		[CollectibleType.COLLECTIBLE_MOMS_RAZOR] = "All familiar damage gains a small chance to cause Bleed for 4 seconds",
		[CollectibleType.COLLECTIBLE_BLOODSHOT_EYE] = "Eye tears gain homing and a chance to inflict fear on hit",
		[CollectibleType.COLLECTIBLE_JAW_BONE] = "Launched from you",
		[CollectibleType.COLLECTIBLE_LIL_PORTAL] = "Launched from you",
		[CollectibleType.COLLECTIBLE_MY_SHADOW] = "Shadow is centered on you, grows while firing and shrinks otherwise, and deals contact damage with a chance to spawn chargers"
	}
	local GC_conditionFunc = function(descObj)
		if PST:getTreeSnapshotMod("grandConsonance", false) and descObj.ObjType == EntityType.ENTITY_PICKUP and
		descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and GC_EID_Data[descObj.ObjSubType] ~= nil then
			return true
		end
	end
	local GC_callbackFunc = function(descObj)
		EID:appendToDescription(descObj, "#Grand Consonance: " .. GC_EID_Data[descObj.ObjSubType])
		return descObj
	end
	EID:addDescriptionModifier("PST Grand Consonance", GC_conditionFunc, GC_callbackFunc)
end