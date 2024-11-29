-- Mod compatibility helper
local initMods = {}
function PST:initModCompat()
	-- Epiphany
	if Epiphany and not initMods.epiphany then
		initMods.epiphany = true

		-- Tarnished Keeper blacklisted pickups
		Epiphany.Character.KEEPER.DisallowedPickUpVariants[Isaac.GetEntityVariantByName("Sidereal Cache")] = 0
		if not Epiphany.Character.KEEPER.DisallowedPickUpVariants[PickupVariant.PICKUP_TRINKET] then
			Epiphany.Character.KEEPER.DisallowedPickUpVariants[PickupVariant.PICKUP_TRINKET] = {}
		end
		local tmpBlacklist = Epiphany.Character.KEEPER.DisallowedPickUpVariants[PickupVariant.PICKUP_TRINKET]
		tmpBlacklist[Isaac.GetTrinketIdByName("Azure Starcursed Jewel")] = 0
		tmpBlacklist[Isaac.GetTrinketIdByName("Crimson Starcursed Jewel")] = 0
		tmpBlacklist[Isaac.GetTrinketIdByName("Viridian Starcursed Jewel")] = 0
		tmpBlacklist[Isaac.GetTrinketIdByName("Ancient Starcursed Jewel")] = 0
		for i=1,8 do
			tmpBlacklist[Isaac.GetTrinketIdByName("Arcane Obols " .. tostring(i))] = 0
		end
		local wepPrefix = "Astral weapon: "
		for _, wepData in pairs(PST.astralWepData) do
			tmpBlacklist[Isaac.GetTrinketIdByName(wepPrefix .. wepData.name)] = 0
			tmpBlacklist[Isaac.GetTrinketIdByName(wepPrefix .. wepData.name .. " (magic)")] = 0
			for _, tmpAncient in ipairs(wepData.ancients) do
				tmpBlacklist[Isaac.GetTrinketIdByName(wepPrefix .. tmpAncient.name)] = 0
			end
		end

        -- HP Up items
        if Epiphany.Item.WARM_COAT.ID then
            PST.heartUpItems[Epiphany.Item.WARM_COAT.ID] = 1
        end

        -- Progression items
        table.insert(PST.progressionItems, Epiphany.Item.DIMENSIONAL_KEY.ID)
        table.insert(PST.progressionItems, Epiphany.Item.BLIGHTED_PHOTO.ID)
        table.insert(PST.progressionItems, Epiphany.Item.BLIGHTED_PHOTO.CHILDS_DRAWING)
        table.insert(PST.progressionItems, Epiphany.Item.BLEEDING_HEART.ID)
        table.insert(PST.progressionItems, Epiphany.Item.SHARP_ROCK.ID)
        table.insert(PST.progressionItems, Epiphany.Item.DELILAHS_RAZOR.ID)
        table.insert(PST.progressionItems, Epiphany.Item.GlitchedPhotoID)
        table.insert(PST.progressionItems, Epiphany.Item.BROKEN_ORB.ID)
        table.insert(PST.progressionItems, Epiphany.Item.KAEK.ID)
        table.insert(PST.progressionItems, Epiphany.Item.KAEK.ID2)

        -- Locked chests
        table.insert(PST.lockedChests, Epiphany.Pickup.DUSTY_CHEST.ID)

        -- Non-championable mobs
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.KNIGHT.ID, Epiphany.Npc.REVOLT.KNIGHT.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.GRUNT.ID, Epiphany.Npc.REVOLT.GRUNT.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.BRUTE.ID, Epiphany.Npc.REVOLT.BRUTE.Variant})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.REVOLT.COMMANDER.ID, Epiphany.Npc.REVOLT.COMMANDER.Variant})
        table.insert(PST.noChampionMobs, {EntityType.ENTITY_GAPER, Epiphany.Npc.EDEN_GLITCH.ID})
        table.insert(PST.noChampionMobs, {Epiphany.Npc.ABEL.ID, Epiphany.Npc.ABEL.SHEEP_VAR})

        -- Non-championable bosses
        table.insert(PST.noChampionBosses, Epiphany.Npc.ABEL.ID)

        -- Blue Gambit cards
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_QUEEN_OF_HEARTS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_SPADES.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_CLUBS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_DIAMONDS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.HOUSE_TWO_OF_HEARTS.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.DRAW_ONE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.REVERSE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.MINUS_ONE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.INVERSE.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.DRAWN_CARD.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.GO_TO_JAIL.ID)
        table.insert(PST.blueGambitCards, Epiphany.Card.EXCLAMATION_MARK.ID)

        -- Cause converter blacklist
        table.insert(PST.causeConverterBossBlacklist, Epiphany.Npc.ABEL.ID)

        -- Song of the Few node familiars
        table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.LIL_GUPPY.ID)
        table.insert(PST.songOfTheFewFamiliars, Epiphany.Item.OLD_KNIFE.ID)

        -- Grand Consonance node whitelist
        table.insert(PST.grandConsonanceWhitelist, Isaac.GetEntityVariantByName("Old Knife"))
	end
end