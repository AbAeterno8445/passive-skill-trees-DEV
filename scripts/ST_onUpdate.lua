---@diagnostic disable: param-type-mismatch
local sfx = SFXManager()

local inDeathCertificate = false

local causeConvMultiBosses = {
	[EntityType.ENTITY_CHUB] = 3
}
local function PST_causeConvBossSpawn()
	local player = PST:getPlayer()
	local tmpBoss = PST:getTreeSnapshotMod("SC_causeConvBoss", nil)
	if tmpBoss then
		local iter = 1
		if causeConvMultiBosses[tmpBoss] ~= nil then
			iter = causeConvMultiBosses[tmpBoss]
		end
		for _=1,iter do
			local bossVariant = PST:getTreeSnapshotMod("SC_causeConvBossVariant", 0)
			PST.specialNodes.SC_causeConvBossEnt = Isaac.Spawn(
				tmpBoss,
				bossVariant, 0,
				player.Position,
				Vector.Zero,
				player
			)
			PST.specialNodes.SC_causeConvBossEnt:AddCharmed(EntityRef(player), -1)
		end
	end
end

local hasDarkArtsEffect = false
local isFiring = false

-- On update
function PST:onUpdate()
	local doUpdate = true
	if Epiphany and Epiphany.character_menu_visible then
		doUpdate = false
	end
	if doUpdate then PST:frameUpdate() end
end

local modResetUpdate = false
function PST:frameUpdate()
	local level = PST:getLevel()
	local room = PST:getRoom()
	local player = PST:getPlayer()

	local roomFrame = room:GetFrameCount()
	local gameFrame = Game():GetFrameCount()

	-- Dynamically init specific characters
	if PST:getCurrentCharName() == nil then
		local plType = player:GetPlayerType()
		-- Epiphany: Tarnished Judas phases support
		if Epiphany and Epiphany.Character.JUDAS:IsJudas(player) then
			PST:initUnknownChar("Tr. Judas", false, 1 + plType)
		end
		if yandereWaifu then
			if plType == Isaac.GetPlayerTypeByName("Red Rebekah") then
				PST:initUnknownChar("Red Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Soul Rebekah", false) then
				PST:initUnknownChar("Soul Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Evil Rebekah", false) then
				PST:initUnknownChar("Evil Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Eternal Rebekah", false) then
				PST:initUnknownChar("Eternal Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Gold Rebekah", false) then
				PST:initUnknownChar("Gold Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Bone Rebekah", false) then
				PST:initUnknownChar("Bone Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Rotten Rebekah", false) then
				PST:initUnknownChar("Rotten Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Broken Rebekah", false) then
				PST:initUnknownChar("Broken Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Immortal Rebekah", false) then
				PST:initUnknownChar("Immortal Rebekah", false)
			elseif plType == Isaac.GetPlayerTypeByName("Deborah", true) then
				PST:initUnknownChar("Deborah", true)
			elseif plType == Isaac.GetPlayerTypeByName("Deborah", true) then
				PST:initUnknownChar("Deborah", true)
			end
		end
		if Reverie then
			if plType == Isaac.GetPlayerTypeByName("Hourai") then
				PST:initUnknownChar("Hourai", false)
			elseif plType == Isaac.GetPlayerTypeByName("Hourai", true) then
				PST:initUnknownChar("Hourai", true)
			end
		end
		if FiendFolio then
			if plType == Isaac.GetPlayerTypeByName("China") then
				PST:initUnknownChar("China", false)
			elseif plType == Isaac.GetPlayerTypeByName("Slippy", true) then
				PST:initUnknownChar("Slippy", true)
			elseif plType == Isaac.GetPlayerTypeByName("Fend", true) then
				PST:initUnknownChar("Fend", true)
			elseif plType == Isaac.GetPlayerTypeByName("Fient", true) then
				PST:initUnknownChar("Fient", true)
			elseif plType == Isaac.GetPlayerTypeByName("Peat", true) then
				PST:initUnknownChar("Peat", true)
			end
		end
		if Retribution then
			if plType == Isaac.GetPlayerTypeByName("Persephone") then
				PST:initUnknownChar("Persephone", false)
			end
		end
		if RedBaby then
			if plType == Isaac.GetPlayerTypeByName("...") then
				PST:initUnknownChar("...", false)
			end
		end
		if _wakaba then
			if plType == Isaac.GetPlayerTypeByName("Shima") then
				PST:initUnknownChar("Shima", false)
			elseif plType == Isaac.GetPlayerTypeByName("Cecilia") then
				PST:initUnknownChar("Cecilia", false)
			elseif plType == Isaac.GetPlayerTypeByName("Anna") then
				PST:initUnknownChar("Anna", false)
			elseif plType == Isaac.GetPlayerTypeByName("Koron") then
				PST:initUnknownChar("Koron", false)
			elseif plType == Isaac.GetPlayerTypeByName("Ciel") then
				PST:initUnknownChar("Ciel", false)
			end
		end
	end

	if inDeathCertificate and level:GetDimension() ~= Dimension.DEATH_CERTIFICATE then
		-- Left death certificate dimension, re-update level
		PST.floorFirstUpdate = true
	end
	inDeathCertificate = level:GetDimension() == Dimension.DEATH_CERTIFICATE

	local inMineshaftPuzzle = PST:inMineshaftPuzzle()

	local updateTrackers = PST:getTreeSnapshotMod("updateTrackers", PST.treeMods.updateTrackers)

	if PST.floorFirstUpdate or not modResetUpdate then
		updateTrackers.charTracker = PST:getCurrentCharName()
		updateTrackers.bloodCharges = player:GetEffectiveBloodCharge()
		updateTrackers.keyTracker = player:GetNumKeys()
		if updateTrackers.isBerserk == nil then updateTrackers.isBerserk = PST:isBerserk() end
		PST:resetHeartUpdater()
		isFiring = false
		modResetUpdate = true

		-- Locusts tracking (T. Apollyon)
		if player:GetPlayerType() == PlayerType.PLAYER_APOLLYON_B and #PST.specialNodes.activeLocusts == 0 then
			PST.specialNodes.activeLocusts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST)
		end
	end

	-- First update when entering floor
	if PST.floorFirstUpdate then
		PST.floorFirstUpdate = false
		PST:updateCacheDelayed()
		updateTrackers.jacobHeartDiffTracker = 0
		updateTrackers.luckTracker = 0
		updateTrackers.familiarsTracker = 0
		updateTrackers.lvlCurseTracker = -1
		updateTrackers.pocketTracker = 0
		PST.specialNodes.jacobHeartLuckVal = 0
		PST.specialNodes.SC_causeConvBossEnt = nil

		PST:addModifiers({ firstRoomID = { value = level:GetCurrentRoomDesc().SafeGridIndex, set = true } }, true)

		-- Ancient starcursed jewel: Sanguinis
		if PST:SC_getSnapshotMod("sanguinis", false) and not PST:isFirstOrigStage() and player:GetBrokenHearts() < 4 then
			player:AddBrokenHearts(1)
		end

		-- Ancient starcursed jewel: Luminescent Die
		if PST:SC_getSnapshotMod("luminescentDie", false) and not level:IsAscent() then
			if PST:getTreeSnapshotMod("SC_luminescentUsedCard", false) then
				PST:addModifiers({ SC_luminescentUsedCard = false }, true)
			else
				local tmpMod = PST:getTreeSnapshotMod("SC_luminescentDebuff", 0)
				if tmpMod < 40 then
					local tmpAdd = math.min(10, 40 - tmpMod)
					PST:addModifiers({ allstatsPerc = -tmpAdd, SC_luminescentDebuff = tmpAdd }, true)
				end
			end
		end

		-- Ancient starcursed jewel: Chronicler Stone
		if PST:SC_getSnapshotMod("chroniclerStone", false) then
			if inDeathCertificate then
				PST:addModifiers({ SC_chroniclerRooms = { value = 0, set = true } }, true)
			else
				tmpMod = PST:getTreeSnapshotMod("SC_chroniclerRooms", 0)
				if tmpMod > 0 and PST:getTreeSnapshotMod("SC_chroniclerDebuff", 0) < 50 then
					local tmpAdd = math.min(tmpMod * 4, 50 - PST:getTreeSnapshotMod("SC_chroniclerDebuff", 0))
					PST:addModifiers({ allstatsPerc = -tmpAdd, SC_chroniclerDebuff = tmpAdd }, true)
				end
				local countedRooms = 0
				local countedSpecial = 0
				local levelRooms = level:GetRooms()
				for i=0,levelRooms.Size-1 do
					local roomData = levelRooms:Get(i).Data
					if roomData and PST:arrHasValue(PST.chroniclerRoomTypes, roomData.Type) then
						local tmpSub = roomData.Subtype
						if tmpSub ~= RoomSubType.DEATH_CERTIFICATE_ENTRANCE and tmpSub ~= RoomSubType.DEATH_CERTIFICATE_NORMAL then
							local tmpType = roomData.Type
							if tmpType == RoomType.ROOM_SHOP or tmpType == RoomType.ROOM_TREASURE or
							tmpType == RoomType.ROOM_ARCADE or tmpType == RoomType.ROOM_LIBRARY or tmpType == RoomType.ROOM_DICE or
							tmpType == RoomType.ROOM_PLANETARIUM or tmpType == RoomType.ROOM_SECRET then
								-- Chance to count special/locked rooms towards counter
								countedSpecial = countedSpecial + 1

								local tmpChance = (level:GetStage() - 1) * 15 + countedSpecial * 15
								if tmpChance >= 100 or 100 * math.random() < tmpChance then
									countedRooms = countedRooms + 1
								end
							else
								countedRooms = countedRooms + 1
							end
						end
					end
				end
				PST:addModifiers({ SC_chroniclerRooms = { value = countedRooms, set = true } }, true)
			end
		end

		-- Ancient starcursed jewel: Glace
		if PST:SC_getSnapshotMod("glace", false) then
			local tmpDebuff = 50 - PST:getTreeSnapshotMod("SC_glaceDebuff", 0)
			PST:addModifiers({ tearsPerc = -tmpDebuff, speedPerc = -tmpDebuff, SC_glaceDebuff = tmpDebuff }, true)
		end

		-- Ancient starcursed jewel: Crimson Warpstone
		if PST:SC_getSnapshotMod("crimsonWarpstone", false) and level:GetDimension() ~= Dimension.DEATH_CERTIFICATE then
			local debuffAmt = 30
			local tmpDebuff = debuffAmt - PST:getTreeSnapshotMod("SC_crimsonWarpDebuff", 0)
			PST:addModifiers({ allstatsPerc = -tmpDebuff, SC_crimsonWarpDebuff = tmpDebuff }, true)
		end

		-- Expedition run first popup
		if PST:isFirstOrigStage() and PST:getTreeSnapshotMod("isExpedRun", false) then
			local depth = PST:getTreeSnapshotMod("expedDepth", 1)
			if not PST:getTreeSnapshotMod("isExpedUber", false) then
				PST:createFloatTextFX(PST:getLocalizedFormatStr("ftxt_expedBegin", {depth = depth}), player.Position - Vector(0, 10), Color(0, 0.57, 1, 1), 0.13, 300, false)
			else
				PST:createFloatTextFX(PST:getLocalizedFormatStr("ftxt_uberExpedBegin", {depth = depth}), player.Position - Vector(0, 10), Color(1, 0.2, 0.2, 1), 0.13, 300, false)
			end
		end

		-- Mod: chance to reveal the arcade room's location if it is present
		local tmpMod = PST:getTreeSnapshotMod("arcadeReveal", 0)
		if tmpMod > 0 and 100 * math.random() < tmpMod then
			local arcadeIdx = level:QueryRoomTypeIndex(RoomType.ROOM_ARCADE, false, RNG())
			local arcadeRoom = level:GetRoomByIdx(arcadeIdx)
			if arcadeRoom and arcadeRoom.Data.Type == RoomType.ROOM_ARCADE then
				arcadeRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Mod: chance to reveal the shop room's location if it is present
		tmpMod = PST:getTreeSnapshotMod("shopReveal", 0)
		if tmpMod > 0 and 100 * math.random() < tmpMod then
			local shopIdx = level:QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG())
			local shopRoom = level:GetRoomByIdx(shopIdx)
			if shopRoom and shopRoom.Data.Type == RoomType.ROOM_SHOP then
				shopRoom.DisplayFlags = 1 << 2
				level:UpdateVisibility()
			end
		end

		-- Demonic Souvenirs node (Azazel's tree)
		if PST:getTreeSnapshotMod("demonicSouvenirs", false) then
			-- Spawn The Empress card every other floor, and spawn a random unlocked evil trinket on the second floor you enter
			if not PST:getTreeSnapshotMod("demonicSouvenirsProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_EMPRESS, Random() + 1)
				PST:addModifiers({ demonicSouvenirsProc = true }, true)
			else
				PST:addModifiers({ demonicSouvenirsProc = false }, true)
			end
		end

		-- Gulp! node (Keeper's tree)
		if PST:getTreeSnapshotMod("gulp") and level:GetStage() % 2 ~= 0 then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
       		Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, TrinketType.TRINKET_SWALLOWED_PENNY, Random() + 1)
		end

		-- Mod: chance to cleanse natural curses (proc)
		if PST:getTreeSnapshotMod("naturalCurseCleanseProc", false) then
			PST:createFloatTextFX(PST:getLocalized("ftxt_natCurseCleanse"), Vector.Zero, Color(), 0.12, 70, true)
		end

		-- Mod: +luck when clearing a room below full red hearts (reset)
		local tmpLuckBuff = PST:getTreeSnapshotMod("luckOnClearBelowFullBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff, luckOnClearBelowFullBuff = { value = 0, set = true } }, true)
		end

		-- Mod: +luck whenever you lose black hearts (reset)
		tmpLuckBuff = PST:getTreeSnapshotMod("lostBlackHeartsLuckBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff, lostBlackHeartsLuckBuff = -tmpLuckBuff }, true)
		end

		-- Mod: +luck when purchasing an item (halve on entering floor)
		tmpLuckBuff = PST:getTreeSnapshotMod("itemPurchaseLuckBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff / 2, itemPurchaseLuckBuff = -tmpLuckBuff / 2 }, true)
		end

		-- Mod: +luck when donating to a blood machine (halve on entering floor)
		tmpLuckBuff = PST:getTreeSnapshotMod("bloodDonationLuckBuff", 0)
		if tmpLuckBuff > 0 then
			PST:addModifiers({ luck = -tmpLuckBuff / 2, bloodDonationLuckBuff = -tmpLuckBuff / 2 }, true)
		end

		-- Blessed Blood node (T. Eve's tree)
		if PST:getTreeSnapshotMod("blessedBlood", false) then
			local tmpClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 3)
			if #tmpClots == 0 then
				local newClot = Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, player.Position, Vector.Zero, nil, 3, Random() + 1)
				newClot:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			end
		end

		-- Violent Marauder node (T. Samson's tree)
		if PST:getTreeSnapshotMod("violentMarauderRemoved", false) then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
			Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, Random() + 1)
			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_SUPLEX, Random() + 1)
			PST:addModifiers({ violentMarauderRemoved = false }, true)
		end

		-- Death's Trial nodes (T. Lost's tree)
		if PST:getTreeSnapshotMod("deathTrialActive", false) then
			PST:createFloatTextFX(PST:getLocalized("ftxt_deathTrial"), Vector.Zero, Color(), 0.13, 90, true)
		end

		-- Mod: remove The Stairway once it triggers when entering a floor
		if PST:getTreeSnapshotMod("stairwayBoon", 0) > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_STAIRWAY) then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_STAIRWAY)
		end

		-- Chimeric Amalgam node (T. Lilith's tree)
		if PST:getTreeSnapshotMod("chimericAmalgam", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
			PST:addModifiers({ chimericAmalgamFloors = 1 }, true)
			if PST:getTreeSnapshotMod("chimericAmalgamFloors", 0) >= 2 then
				local tmpPos = Isaac.GetFreeNearPosition(PST:getRoom():GetCenterPos() + Vector(-60, 60), 40)
				local tmpItem = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_BIRTHRIGHT, Random() + 1)
				tmpItem:ToPickup().Wait = 30
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				PST:addModifiers({ chimericAmalgamFloors = { value = 0, set = true } }, true)
			end
		end

		-- Inherited Chaos node (T. Bethany's tree)
		if PST:getTreeSnapshotMod("inheritedChaos", false) then
			local chaosWisps = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, CollectibleType.COLLECTIBLE_CHAOS)
			if chaosWisps == 0 then
				player:AddItemWisp(CollectibleType.COLLECTIBLE_CHAOS, player.Position)
			end
		end

		-- Reaper Wraiths node (T. Jacob's tree)
		if PST:getTreeSnapshotMod("reaperWraiths", false) then
			if player:GetPlayerType() == PlayerType.PLAYER_JACOB_B then
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, player.Position, Vector.Zero, nil, 0, Random() + 1)
				SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 0.9, 2, false, 1.15)
				player:ChangePlayerType(PlayerType.PLAYER_JACOB2_B)
			end
			if player:GetEternalHearts() == 0 then
				player:AddEternalHearts(1)
			end
		end

		-- Consuming Void node (T. Isaac's tree)
		if PST:getTreeSnapshotMod("consumingVoid", false) then
			if PST:isTIsaacInvFull() and not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
				local tmpPos = Isaac.GetFreeNearPosition(PST:getRoom():GetCenterPos(), 40)
				local voidItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_VOID, tmpPos, Vector.Zero, nil)
				---@diagnostic disable-next-line: undefined-field
				voidItem:ToPickup():RemoveCollectibleCycle()
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, Random() + 1)
			end
		end

		-- King's Curse node (Lazarus' tree)
		if PST:getTreeSnapshotMod("kingCurse", false) then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
				player:AddCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
			else
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)
			end
		end

		-- Re-open sidereal caches just in case
		if PST:isRunSidereal() then
			local sideCaches = Isaac.FindByType(EntityType.ENTITY_PICKUP, Isaac.GetEntityVariantByName("Sidereal Cache"), 1)
			for _, tmpCache in ipairs(sideCaches) do
				tmpCache:ToPickup():Morph(tmpCache.Type, tmpCache.Variant, 0)
			end
		end

		-- Mod: % chance for treasure rooms to additionally contain a double red heart pickup
		tmpMod = PST:getTreeSnapshotMod("treasureDoubleHeart", 0)
		if tmpMod > 0 and room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() and 100 * math.random() < tmpMod then
			local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos() + Vector(40, 40), 20)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, tmpPos, Vector.Zero, nil)
		end

		-- Blood-Crowned node (Samson's tree)
		if PST:getTreeSnapshotMod("bloodcrowned", false) and (level:GetStage() >= 7 or PST:LJ_inMortis()) and not PST:getTreeSnapshotMod("bloodcrownedProc", false) then
			local tmpPos = Isaac.GetFreeNearPosition(player.Position + Vector(60, 60), 20)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_DEVILS_CROWN, tmpPos, Vector.Zero, nil)
			PST:addModifiers({ bloodcrownedProc = true }, true)
		end

		-- Mod: % chance to gain Myosotis when clearing a room without taking damage
		if PST:getTreeSnapshotMod("myosotisOnClearProc", 0) then
			player:TryRemoveTrinket(TrinketType.TRINKET_MYOSOTIS)
			PST:addModifiers({ myosotisOnClearProc = false }, true)
		end

		-- Spirit-gambler node (Forgotten's tree)
		if PST:getTreeSnapshotMod("spiritGambler", false) then
			local spiritNodes = {"spiritBringer", "spiritTaker", "spiritReaper", "spiritProtector"}
			local newNode = spiritNodes[math.random(#spiritNodes)]
			-- New node application
			if not PST:getTreeSnapshotMod(newNode, false) then
				-- Old node removal
				for _, tmpNode in ipairs(spiritNodes) do
					if tmpNode ~= newNode and PST:getTreeSnapshotMod(tmpNode, false) then
						if tmpNode == "spiritBringer" then
							player:AddInnateCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS, -1)
							player:AddInnateCollectible(CollectibleType.COLLECTIBLE_QUINTS, -1)
						elseif tmpNode == "spiritTaker" then
							player:AddInnateCollectible(CollectibleType.COLLECTIBLE_VADE_RETRO, -1)
						elseif tmpNode == "spiritReaper" then
							player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PURGATORY, -1)
							player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HUNGRY_SOUL, -1)
						elseif tmpNode == "spiritProtector" then
							player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LOST_SOUL, -1)
							player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL)
							player:TryRemoveTrinket(TrinketType.TRINKET_FOUND_SOUL)
						end
						PST:addModifiers({ [tmpNode] = false }, true)
					end
				end
				PST:addModifiers({ [newNode] = true }, true)
			end
			PST:createFloatTextFX(PST:getLocalized("ftxt_spiritGambler"), Vector.Zero, Color(0.75, 0.75, 0.2, 1), 0.13, 120, true)
		end

		-- First update - After first floor
		if not PST:isFirstOrigStage() then
			-- Ancient starcursed jewel: Challenger Starpiece
			if PST:SC_getSnapshotMod("challengerStarpiece", false) then
				local tmpRoomIdx = level:QueryRoomTypeIndex(RoomType.ROOM_CHALLENGE, false, RNG())
				local challRoom = level:GetRoomByIdx(tmpRoomIdx)
				if challRoom and challRoom.Data.Type == RoomType.ROOM_CHALLENGE then
					PST:addModifiers({ SC_levelHasChall = true }, true)

					-- Check for curse of maze before teleport
					if (level:GetCurses() & LevelCurse.CURSE_OF_MAZE) > 0 then
						level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
						PST.specialNodes.levelMazeCurseProc = true
					end
					if player:HasCollectible(CollectibleType.COLLECTIBLE_STAIRWAY) then
						PST:addModifiers({ SC_challStairwayProc = true }, true)
					end
					Game():StartRoomTransition(tmpRoomIdx, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
				else
					PST:addModifiers({ SC_levelHasChall = false }, true)
				end
			end

			-- Ancient starcursed jewel: Cursed Starpiece
			if PST:SC_getSnapshotMod("cursedStarpiece", false) and not PST:isFirstOrigStage() then
				if not PST:getTreeSnapshotMod("SC_cursedStarpieceDebuff", false) then
					-- Halve debuff if no treasure room in level
					local tmpRoomIdx = level:QueryRoomTypeIndex(RoomType.ROOM_TREASURE, false, RNG())
					local treasureRoom = level:GetRoomByIdx(tmpRoomIdx)
					if treasureRoom and treasureRoom.Data.Type == RoomType.ROOM_TREASURE then
						PST:addModifiers({ allstatsPerc = -12, SC_cursedStarpieceDebuff = true }, true)
					else
						PST:addModifiers({ allstatsPerc = -6, SC_cursedStarpieceDebuff = true }, true)
					end
				end
			end

			-- Ancient starcursed jewel: Twisted Emperor's Heirloom
			if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
       			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_REVERSE_EMPEROR, Random() + 1)
				if not PST:getTreeSnapshotMod("SC_empHeirloomActive", false) then
					PST:addModifiers({ SC_empHeirloomActive = true }, true)
				end
			end

			-- Ancient starcursed jewel: Glowing Glass Piece
			if PST:SC_getSnapshotMod("glowingGlassPiece", false) then
				if PST:getTreeSnapshotMod("SC_glowingGlassProcs", 0) < 3 and PST:getTreeSnapshotMod("SC_glowingGlassDebuff", 0) < 30 then
					PST:addModifiers({ allstatsPerc = -6, SC_glowingGlassDebuff = 6 }, true)
				end
				PST:addModifiers({ SC_glowingGlassProcs = { value = 0, set = true } }, true)
			end

			-- Mod: chance to reveal map
			if PST:getTreeSnapshotMod("mapRevealed", false) then
				level:ShowMap()
				PST:createFloatTextFX(PST:getLocalized("ftxt_mapReveal"), Vector.Zero, Color(), 0.12, 70, true)
			end

			-- Mod: chance to smelt currently held trinkets
			tmpMod = PST:getTreeSnapshotMod("floorSmeltTrinket", 0)
			if not inDeathCertificate and tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpTrinket = player:GetTrinket(0)
				if tmpTrinket and tmpTrinket > 0 then
					if player:AddSmeltedTrinket(tmpTrinket) then
						player:TryRemoveTrinket(tmpTrinket)
						PST:createFloatTextFX(PST:getLocalized("ftxt_trinketSmelt"), Vector.Zero, Color(), 0.12, 70, true)
					end
				end
			end

			-- Mod: chance to spawn a Blood Donation Machine at the start of a floor
			tmpMod = PST:getTreeSnapshotMod("bloodMachineSpawn", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = room:GetCenterPos()
				tmpPos.Y = tmpPos.Y - 40
				Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.BLOOD_DONATION_MACHINE, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND, 0.7)
			end

			-- Mod: chance to spawn a random trinket at the start of a floor
			tmpMod = PST:getTreeSnapshotMod("trinketSpawn", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
       			Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, Game():GetItemPool():GetTrinket(), Random() + 1)
			end

			-- Demonic Souvenirs node (Azazel's tree)
			if PST:getTreeSnapshotMod("demonicSouvenirs", false) and not PST:getTreeSnapshotMod("demonicSouvenirsTrinket", false) then
				-- Spawn random evil trinket on the second floor you enter
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local tmpTrinket = PST.evilTrinkets[math.random(#PST.evilTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpTrinket, Random() + 1)
				PST:addModifiers({ demonicSouvenirsTrinket = true }, true)
			end

			-- Demon Helpers node (Azazel's tree)
			if PST:getTreeSnapshotMod("demonHelpers", false) then
				-- Chance to spawn devil beggar at the beginning of the floor
				local tmpChance = PST:getTreeSnapshotMod("demonHelpersBeggarChance", 0)
				if 100 * math.random() < tmpChance then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, Random() + 1)
					Game():Spawn(EntityType.ENTITY_SLOT, SlotVariant.DEVIL_BEGGAR, tmpPos, Vector.Zero, nil, 0, Random() + 1)
					PST:addModifiers({ demonHelpersBeggarChance = { value = 5, set = true } }, true)
				elseif tmpChance < 40 then
					PST:addModifiers({ demonHelpersBeggarChance = math.min(tmpChance, 40 - tmpChance) }, true)
				end
			end

			-- Mod: chance to spawn Eden's Blessing at the beginning of the floor
			tmpMod = PST:getTreeSnapshotMod("edenBlessingSpawn", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod and not PST:getTreeSnapshotMod("edenBlessingSpawned", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_EDENS_BLESSING, Random() + 1)
				PST:addModifiers({ edenBlessingSpawned = true }, true)
			end

			-- Harbinger Locusts node (Apollyon's tree)
			if PST:getTreeSnapshotMod("harbingerLocusts", false) and not PST:isFirstOrigStage() and not PST:getTreeSnapshotMod("harbingerLocustsFloorProc", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local tmpLocust = PST.locustTrinketsNonGold[math.random(#PST.locustTrinketsNonGold)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpLocust, Random() + 1)
				PST:addModifiers({ harbingerLocustsFloorProc = true }, true)
			end

			-- Coalescing Soul node
			tmpMod = PST:getTreeSnapshotMod("coalescingSoulChance", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod and PST:getTreeSnapshotMod("coalescingSoulProcs", 0) > 0 then
				local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos())
				local tmpPlayerType = player:GetPlayerType()
				if PST:getTreeSnapshotMod("warpedCoalescence", false) and 100 * math.random() < 40 then
					tmpPlayerType = -1
				end
				local stoneType = PST:getMatchingSoulstone(tmpPlayerType)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, stoneType, Random() + 1)
				PST:addModifiers({ coalescingSoulProcs = -1 }, true)
			end

			-- Ephemeral Bond node (T. Lazarus' tree)
			tmpMod = PST:getTreeSnapshotMod("ephemeralBond", 0)
			if tmpMod > 0 then
				local otherForm = PST:getTLazOtherForm()
				if otherForm then
					-- Build list of player items (no actives or birthright)
					local plItems = {}
					for itemID, itemAmt in pairs(player:GetCollectiblesList()) do
						if itemAmt > 0 and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT and Isaac.GetItemConfig():GetCollectible(itemID).Type ~= ItemType.ITEM_ACTIVE then
							table.insert(plItems, itemID)
						end
					end
					if #plItems > 0 then
						-- Get ephemeral bond items list, and remove items from the form that received these items if set
						local ephItems = PST:getTreeSnapshotMod("ephemeralBondItems", {})
						if #ephItems > 0 then
							local formWithEphItems = player
							if otherForm:GetPlayerType() == PST:getTreeSnapshotMod("ephemeralBondForm", 0) then
								formWithEphItems = otherForm
							end
							for _, tmpItem in ipairs(ephItems) do
								formWithEphItems:RemoveCollectible(tmpItem)
							end
							PST:addModifiers({ ephemeralBondItems = { value = {}, set = true } }, true)
						end
						PST:addModifiers({ ephemeralBondForm = { value = otherForm:GetPlayerType(), set = true } }, true)
						-- Copy a random item per Ephemeral Bond to the opposite form
						for _=1,math.min(#plItems, tmpMod) do
							local copied = false
							local failsafe = 0
							while not copied and failsafe < 200 do
								local randItem = math.random(#plItems)
								if not otherForm:HasCollectible(plItems[randItem]) then
									otherForm:AddCollectible(plItems[randItem], 0, false)
									table.insert(ephItems, plItems[randItem])
									copied = true

									local itemName = Isaac.GetLocalizedString("Items", Isaac.GetItemConfig():GetCollectible(plItems[randItem]).Name, Options.Language)
									if itemName ~= "StringTable::InvalidKey" then
										PST:createFloatTextFX(PST:getLocalized("ui_ephBond") .. ": " .. itemName, Vector.Zero, Color(0.8, 0.8, 1, 1), 0.14, 90, true)
									end
									table.remove(plItems, randItem)
								end
								failsafe = failsafe + 1
							end
						end
					end
				end

				-- Remove temporary Ephemeral Bonds
				tmpMod = PST:getTreeSnapshotMod("gainedTempEphBond", 0)
				if tmpMod > 0 then
					PST:addModifiers({ ephemeralBond = -tmpMod, gainedTempEphBond = { value = 0, set = true } }, true)
				end
			end

			-- Mod: chance to spawn a Wooden Chest when entering a floor
			tmpMod = PST:getTreeSnapshotMod("floorWoodenChest", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40, true)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_WOODENCHEST, tmpPos, Vector.Zero, nil, 0, Random() + 1)
			end

			-- Normalized Vitality node (T. Eden's tree)
			if PST:getTreeSnapshotMod("normalizedVitality", false) then
				local moddedHearts = false
				local tmpColor = Color(0.6, 0.6, 0.6, 1)
				if player:GetMaxHearts() < 6 then
					player:AddMaxHearts(2)
					moddedHearts = true
					tmpColor.R = 1
				elseif player:GetMaxHearts() > 10 then
					player:AddMaxHearts(-2)
					moddedHearts = true
					tmpColor.R = 1
				end
				if player:GetSoulHearts() < 4 then
					player:AddSoulHearts(2)
					moddedHearts = true
					tmpColor.B = 1
				elseif player:GetSoulHearts() > 8 then
					player:AddSoulHearts(-2)
					moddedHearts = true
					tmpColor.B = 1
				end
				if player:GetBrokenHearts() > 0 then
					player:AddBrokenHearts(-1)
					moddedHearts = true
					tmpColor.G = 1
				end
				if moddedHearts then
					PST:createFloatTextFX(PST:getLocalized("ftxt_normalizedVit"), Vector.Zero, tmpColor, 0.12, 100, true)
				end
			end

			-- Golden Gimmick node (Cain's tree)
			if PST:getTreeSnapshotMod("goldenGimmick", false) and PST:getTreeSnapshotMod("goldenGimmickProcs", 0) < 2 and
			100 * math.random() < 15 then
				local validMachines = {
					SlotVariant.FORTUNE_TELLING_MACHINE, SlotVariant.SLOT_MACHINE, SlotVariant.CRANE_GAME
				}
				local newMachineVariant = validMachines[math.random(#validMachines)]
				local newMachine = Isaac.Spawn(EntityType.ENTITY_SLOT, newMachineVariant, 0, Isaac.GetFreeNearPosition(player.Position + Vector(60, 60), 20), Vector.Zero, nil)
				table.insert(PST:getTreeSnapshotMod("gildedMachineInit", {}), newMachine.InitSeed)
				table.insert(PST:getTreeSnapshotMod("gildedMachineList", {}), newMachine.InitSeed)
				PST:addModifiers({ goldenGimmickProcs = 1 }, true)
			end

			-- Early Bird node (Azazel's tree)
			if PST:getTreeSnapshotMod("earlyBird", false) and not PST:getTreeSnapshotMod("earlyBirdProc", false) then
				local maxHP = player:GetMaxHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetBoneHearts()
				if maxHP >= 2 then
					player:AddSoulHearts(-2)
					PST:addModifiers({ earlyBirdProc = true }, true)
				end
			end

			-- Vagrant Soul node (The Lost's tree)
			if PST:getTreeSnapshotMod("vagrantSoul", false) and player:HasCollectible(CollectibleType.COLLECTIBLE_SOUL) and 100 * math.random() < 10 then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_SOUL)
			end

			-- Mod: % chance to spawn a Red Stew per room cleared in the previous floor without taking damage
			tmpMod = PST:getTreeSnapshotMod("redStewBoon", 0)
			if tmpMod > 0 then
				local tmpChance = tmpMod * PST:getTreeSnapshotMod("redStewBoonRooms", 0)
				if tmpChance > 0 and 100 * math.random() < tmpChance then
					local tmpPos = Isaac.GetFreeNearPosition(player.Position + Vector(60, 60), 20)
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_RED_STEW, tmpPos, Vector.Zero, nil)
				end
				PST:addModifiers({ redStewBoonRooms = { value = 0, set = true } }, true)
			end

			-- Osteomancy node (Forgotten's tree)
			if PST:getTreeSnapshotMod("osteomancy", false) then
				local osteoItems = PST:getTreeSnapshotMod("osteomancyItems", {})
				if #osteoItems > 0 then
					for _, tmpItem in ipairs(osteoItems) do
						player:AddInnateCollectible(tmpItem, -1)
					end
					PST.modData.treeModSnapshot.osteomancyItems = {}
				end

				local availableItems = {}
				for _, tmpBoneItem in ipairs(PST.boneItems) do
					if not player:HasCollectible(tmpBoneItem) then
						table.insert(availableItems, tmpBoneItem)
					end
				end
				local maxItems = 1
				if PST:getTreeSnapshotMod("osteomancyDouble", false) then
					maxItems = 2
					PST:addModifiers({ osteomancyDouble = false }, true)
				end
				for _=1,maxItems do
					if #availableItems > 0 then
						local newItem = math.random(#availableItems)
						player:AddInnateCollectible(availableItems[newItem])
						table.remove(availableItems, newItem)
					end
				end
				PST:createFloatTextFX(PST:getLocalized("node_osteomancy_name"), Vector.Zero, Color(1, 1, 1, 1), 0.13, 120, true)
			end

			-- Uber expedition entropy mod
			if PST:getTreeSnapshotMod("expedEnt_noPickups", false) then
				local zeroPickups = 0
				if player:GetNumCoins() == 0 then zeroPickups = zeroPickups + 1 end
				if player:GetNumKeys() == 0 then zeroPickups = zeroPickups + 1 end
				if player:GetNumBombs() == 0 then zeroPickups = zeroPickups + 1 end
				if zeroPickups > 0 then
					PST:expedAddEntropy(
						PST:getTreeSnapshotMod("expedDepth", 1),
						PST.expedEntropyMods.expedEnt_noPickups.entropy * zeroPickups
					)
				end
			end
		end
	end

	-- Detect character change (e.g. using Clicker)
	local tmpCharName = PST:getCurrentCharName()
	if tmpCharName ~= updateTrackers.charTracker then
		-- Unapply old character's tree
		if updateTrackers.charTracker ~= nil and PST.trees[updateTrackers.charTracker] ~= nil then
			for nodeID, node in pairs(PST.trees[updateTrackers.charTracker]) do
				if PST:isNodeAllocated(updateTrackers.charTracker, nodeID) then
					local modsTable = {}
					for modName, modVal in pairs(node.modifiers) do
						if type(modVal) == "number" then
							modsTable[modName] = -modVal
						elseif type(modVal) == "boolean" then
							modsTable[modName] = not modVal
						end
					end
					PST:addModifiers(modsTable, true)
				end
            end
		end
		-- Apply new character's tree if it exists
		if tmpCharName ~= nil and PST.trees[tmpCharName] then
			for nodeID, node in pairs(PST.trees[tmpCharName]) do
				if PST:isNodeAllocated(tmpCharName, nodeID) then
					PST:addModifiers(node.modifiers, true)
				end
            end
		end
		PST:updateCacheDelayed()
		updateTrackers.charTracker = tmpCharName
	end

	-- First update per room
	if roomFrame == 1 then
		-- Update familiars
		local tmpFamiliars = PST:getRoomFamiliars()
		if tmpFamiliars ~= PST:getTreeSnapshotMod("totalFamiliars", 0) then
			PST:addModifiers({ totalFamiliars = { value = tmpFamiliars, set = true } }, true)
		end

		-- Ancient starcursed jewel: Martian Ultimatum
		if PST:SC_getSnapshotMod("martianUltimatum", false) and PST.specialNodes.SC_martianTimer == 0 then
			PST.specialNodes.SC_martianTimer = 30 * (3 + math.random(5))
		end

		-- Ancient starcursed jewel: Saturnian Luminite
		if PST:SC_getSnapshotMod("saturnianLuminite", false) then
			if not inMineshaftPuzzle then
				player:SetCanShoot(false)
			else
				player:SetCanShoot(true)
			end
			if not player:IsFlying() then
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_TRANSCENDENCE, false)
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_FATE)
				if not PST:getTreeSnapshotMod("SC_saturnianSpeedDown", false) then
					PST:addModifiers({ speedPerc = -15, SC_saturnianSpeedDown = true }, true)
				end
			elseif PST:getTreeSnapshotMod("SC_saturnianSpeedDown", false) then
				PST:addModifiers({ speedPerc = 15, SC_saturnianSpeedDown = false }, true)
			end
		end

		-- Ancient starcursed jewel: Nullstone
		if PST:SC_getSnapshotMod("nullstone", false) then
			-- Spawn first nullified enemy in boss room
			if room:GetType() == RoomType.ROOM_BOSS and room:GetAliveBossesCount() > 0 and
			not PST:getTreeSnapshotMod("SC_nullstoneClear", false) then
				local nullstoneList = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
				local currentSpawn = PST.specialNodes.SC_nullstoneCurrentSpawn
				if nullstoneList and #nullstoneList > 0 and not currentSpawn then
					local spawnEntry = nullstoneList[1]
					local centerPos = room:GetCenterPos()
					local newX = centerPos.X - (player.Position.X - centerPos.X)
					local newY = centerPos.Y - (player.Position.Y - centerPos.Y)
					local tmpPos = Isaac.GetFreeNearPosition(Vector(newX, newY), 10)
					local newSpawn = Game():Spawn(spawnEntry.type, spawnEntry.variant, tmpPos, Vector.Zero, nil, spawnEntry.subtype, Random() + 1)
					if spawnEntry.champion >= 0 then
						newSpawn:ToNPC():MakeChampion(Random() + 1, spawnEntry.champion, true)
					end
					newSpawn.Color = Color(0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1)
					PST.specialNodes.SC_nullstoneCurrentSpawn = newSpawn
					PST.specialNodes.SC_nullstoneSpawned = 2
				end
			end
		end

		-- Ancient starcursed jewel: Unusually Small Starstone
		if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
			for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
				local tmpNPC = tmpEntity:ToNPC()
				if tmpNPC then
					local noSplit = PST:arrHasValue(PST.noSplitMobs, tmpNPC.Type)
					if not noSplit then
						for _, tmpSplit in ipairs(PST.noSplitMobsSpec) do
							if tmpNPC.Type == tmpSplit[1] and tmpNPC.Variant == tmpSplit[2] then
								noSplit = true
								break
							end
						end
					end
					if tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly and
					not noSplit and not PST:arrHasValue(PST.causeConverterBossBlacklist, tmpNPC.Type) and
					not tmpNPC.Parent and not tmpNPC.Child then
						---@diagnostic disable-next-line: undefined-field
						tmpNPC:TrySplit(0, EntityRef(player))
					end
				end
			end
		end

		-- Ancient starcursed jewel: Cause Converter
		PST_causeConvBossSpawn()

		-- Mod: % chance to restore the donation machine when first entering a shop, if it's jammed
		tmpMod = PST:getTreeSnapshotMod("donoEntranceRestore", 0)
		if tmpMod > 0 and room:GetType() == RoomType.ROOM_SHOP and room:IsFirstVisit() and Game():GetStateFlag(GameStateFlag.STATE_DONATION_SLOT_JAMMED) and
		100 * math.random() < tmpMod then
			PST:restoreDonoMachine()
		end

		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
			-- Tainted Magdalene, if room has monsters and you have more than 2 red hearts, take 1/2 heart damage
			if room:GetAliveEnemiesCount() > 0 and player:GetHearts() > 4 then
				player:TakeDamage(1, 0, EntityRef(player), 0)
			end
		end

		-- Crimson Convergence buff: Gain a shield when entering a room with monsters
		local charData = PST:getCurrentCharData()
		if charData and PST:getTreeSnapshotMod("crimConvBuff", "") == "bloodshield" and room:GetAliveEnemiesCount() > 0 then
			player:SetMinDamageCooldown(90 + 6 * charData.crimsonStarcores)
		end

		-- Mod: % chance to trigger Chaotic Epiphany when entering a Curse Room
		tmpMod = PST:getTreeSnapshotMod("curseRoomCEpiphany", 0)
		if tmpMod > 0 and room:IsFirstVisit() and room:GetType() == RoomType.ROOM_CURSE and 100 * math.random() < tmpMod then
			PST:edenChaoticEpiphany(player)
		end

		-- Keep Them At Bay node (Jacob and Esau's tree)
		if PST:getTreeSnapshotMod("keepThemAtBay", false) and room:IsFirstVisit() and room:GetAliveEnemiesCount() > 0 and
		(player:GetHearts() >= 6 or (player:GetOtherTwin() and player:GetOtherTwin():GetHearts() >= 6)) then
			local tmpChance = 15 * (2 ^ PST:getTreeSnapshotMod("keepThemAtBayFails", 0))
			if 100 * math.random() < tmpChance then
				player:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, UseFlag.USE_NOANIM)
				PST:addModifiers({ keepThemAtBayFails = { value = 0, set = true } }, true)
			else
				PST:addModifiers({ keepThemAtBayFails = 1 }, true)
			end
		end

		-- Mod: % tears per active wisp
        tmpMod = PST:getTreeSnapshotMod("soulWispTears", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("totalFamiliars", 0) > 0 then
            PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
        end
	end

	-- First heart-related functions update
	if not PST.modData.firstHeartUpdate then
		PST:onHeartUpdate(true)
		PST.modData.firstHeartUpdate = true
	end

	-- Boss jewel drop proc
	if PST.specialNodes.bossJewelDropProc > 0 and gameFrame >= PST.specialNodes.bossJewelDropProc + 20 then
		local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40)
		PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.boss(level:GetStage()).ancient)
		PST.specialNodes.bossJewelDropProc = 0
	end

	-- Starcursed mod: monster status cleanse every X seconds
	local tmpMod = PST:SC_getSnapshotMod("statusCleanse", 0)
	if tmpMod > 0 and roomFrame % (tmpMod * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly and not tmpNPC:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) then
				tmpNPC:RemoveStatusEffects()
				tmpNPC:SetColor(Color(0.5, 0.8, 1, 1), 30, 1, true, false)
			end
		end
	end
	-- Starcursed mod: normal monsters regen X HP every Y seconds
	tmpMod = PST:SC_getSnapshotMod("mobRegen", {0, 0})
	if tmpMod[1] > 0 and tmpMod[2] > 0 and roomFrame % (tmpMod[2] * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				tmpNPC.HitPoints = math.min(tmpNPC.MaxHitPoints, tmpNPC.HitPoints + tmpMod[1])
				tmpNPC:SetColor(Color(1, 0.5, 0.5, 1), 30, 1, true, false)
			end
		end
	end
	-- Starcursed mod: boss monsters regen X HP every Y seconds
	tmpMod = PST:SC_getSnapshotMod("bossRegen", {0, 0})
	if tmpMod[1] > 0 and tmpMod[2] > 0 and roomFrame % (tmpMod[2] * 30) == 0 then
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsBoss() and not tmpNPC:HasFullHealth() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				tmpNPC.HitPoints = math.min(tmpNPC.MaxHitPoints, tmpNPC.HitPoints + tmpMod[1])
				tmpNPC:SetColor(Color(1, 0.5, 0.5, 1), 30, 1, true, false)
			end
		end
	end
	-- Starcursed mod: champions heal 15% HP to nearby non-champion monsters every X seconds
	tmpMod = PST:SC_getSnapshotMod("championHealers", {0, 0})
	if type(tmpMod) == "table" and tmpMod[1] > 0 and tmpMod[2] > 0 and roomFrame % (tmpMod * 30) == 0 then
		local tmpEntities = Isaac.GetRoomEntities()
		local tmpChamps = {}
		for _, tmpEntity in ipairs(tmpEntities) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsChampion() then
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpNPC.Position, Vector.Zero, nil, 1, Random() + 1)
				table.insert(tmpChamps, tmpNPC)
			end
		end
		for _, tmpEntity in ipairs(tmpEntities) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not tmpNPC:IsChampion() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				for _, tmpChamp in ipairs(tmpChamps) do
					local dist = PST:distBetweenPoints(tmpNPC.Position, tmpChamp.Position)
					if dist <= 80 then
						tmpNPC.HitPoints = math.min(tmpNPC.MaxHitPoints, tmpNPC.HitPoints + tmpNPC.MaxHitPoints * 0.15)
						tmpNPC:SetColor(Color(1, 0.5, 0.5, 1), 30, 1, true, false)
						break
					end
				end
			end
		end
	end
	-- Starcursed mod: monsters receive no damage for 2 seconds every 10 seconds
	tmpMod = PST:SC_getSnapshotMod("mobPeriodicShield", nil)
	if tmpMod ~= nil then
		if roomFrame % 300 >= 240 and roomFrame % 300 <= 300 then
			PST.specialNodes.mobPeriodicShield = true
		else
			PST.specialNodes.mobPeriodicShield = false
		end
	end
	-- Starcursed mod: monsters have a chance to reduce your damage by 20% for 3 seconds
	if PST.specialNodes.mobHitReduceDmg > 0 then
		PST.specialNodes.mobHitReduceDmg = PST.specialNodes.mobHitReduceDmg - 1
		if PST.specialNodes.mobHitReduceDmg == 0 then
			PST:addModifiers({ damagePerc = 20 }, true)
		end
	end
	-- Ancient starcursed jewel: Circadian Destructor
	if PST:SC_getSnapshotMod("circadianDestructor", false) then
		PST.specialNodes.SC_circadianSpawnTime = PST.specialNodes.SC_circadianSpawnTime + 1
		if PST.specialNodes.SC_circadianSpawnTime >= 1440 then
			if room:GetAliveEnemiesCount() > 0 then
				-- Special FX
				local tmpSprite = PST.specialFX.ancientJewelSpr
				tmpSprite:SetFrame("Ancients", 0)
				PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.1, 50, true, true)

				player:UseCard(Card.CARD_TOWER, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
				PST.specialNodes.SC_circadianExplImmune = 120
			end
			PST.specialNodes.SC_circadianSpawnTime = 0
		end
		if PST.specialNodes.SC_circadianExplImmune > 0 then
			PST.specialNodes.SC_circadianExplImmune = PST.specialNodes.SC_circadianExplImmune - 1
		end
	end
	-- Ancient starcursed jewel: Soul Watcher
	if PST:SC_getSnapshotMod("soulWatcher", false) then
		if roomFrame % 300 == 0 and #PST.specialNodes.SC_soulEaterMobs > 0 then
			for _, tmpSoulEater in ipairs(PST.specialNodes.SC_soulEaterMobs) do
				if not EntityRef(tmpSoulEater.mob).IsFriendly and tmpSoulEater.mob:IsBoss()
				and tmpSoulEater.mob.Type ~= EntityType.ENTITY_GIDEON then
					Game():Spawn(EntityType.ENTITY_ATTACKFLY, 0, tmpSoulEater.mob.Position, Vector.Zero, nil, 0, Random() + 1)
					break
				end
			end
		end
	end
	-- Ancient starcursed jewel: Martian Ultimatum
	if PST:SC_getSnapshotMod("martianUltimatum", false) and not inMineshaftPuzzle then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_MARS) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
			if player:GetOtherTwin() and not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_MARS) then
				player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
			end
		end
		if roomFrame > 1 then
			if PST.specialNodes.SC_martianTimer > 0 then
				PST.specialNodes.SC_martianTimer = PST.specialNodes.SC_martianTimer - 1
				for _, tmpTear in ipairs(PST.specialNodes.SC_martianTears) do
					if tmpTear then
						tmpTear.Color = Color(1, 0.25, 0.25, tmpTear.Color.A + 0.01)
					end
				end
				for _, tmpSprite in ipairs(PST.specialNodes.SC_martianFX) do
					if not tmpSprite.sprite:IsFinished() then
						tmpSprite.sprite:Render(room:WorldToScreenPosition(tmpSprite.pos))
						tmpSprite.sprite:Update()
					end
				end
			elseif not PST.specialNodes.SC_martianProc and room:GetAliveEnemiesCount() > 0 then
				PST.specialNodes.SC_martianTimer = 60
				PST.specialNodes.SC_martianProc = true
				local tearAmt = 2 + math.random(7)
				local tearDist = 140
				for i=1,tearAmt do
					local tmpFXSprite = Sprite("gfx/items/martian_ultimatum_fx.anm2", true)
					tmpFXSprite:Play("Default", true)
					local tearAng = (2 * math.pi) / tearAmt * (i - 1)
					local tearX = player.Position.X + tearDist * math.cos(tearAng)
					local tearY = player.Position.Y + tearDist * math.sin(tearAng)
					local newTear = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, Vector(tearX, tearY), Vector.Zero, nil, 0, Random() + 1)
					newTear:ToProjectile().FallingAccel = -0.1
					newTear:ToProjectile():AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
					newTear.Color = Color(1, 0.25, 0.25, 0.1)
					table.insert(PST.specialNodes.SC_martianTears, newTear)
					table.insert(PST.specialNodes.SC_martianFX, {
						sprite = tmpFXSprite,
						pos = Vector(tearX, tearY)
					})
				end
				SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 0.85, 2, false, 0.8)
			end
		end
	end
	-- Ancient starcursed jewel: Nightmare Projector
	if PST:SC_getSnapshotMod("nightmareProjector", false) and PST:getTreeSnapshotMod("SC_nightProjProc", false) then
		if PST.specialNodes.SC_nightProjTimer > 0 then
			PST.specialNodes.SC_nightProjTimer = PST.specialNodes.SC_nightProjTimer - 1
		else
			player:UseCard(Card.CARD_REVERSE_HIGH_PRIESTESS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
			SFXManager():Play(SoundEffect.SOUND_REVERSE_HIGH_PRIESTESS)
			PST.specialNodes.SC_nightProjTimer = 3600
		end
	end

	if PST.specialNodes.SC_martianProc and PST.specialNodes.SC_martianTimer == 0 then
		if room:GetAliveEnemiesCount() > 0 then
			PST.specialNodes.SC_martianTimer = 30 * (3 + math.random(5))
		end
		PST.specialNodes.SC_martianProc = false
		PST.specialNodes.SC_martianFX = {}

		local tearSpeed = 7
		for _, tmpTear in ipairs(PST.specialNodes.SC_martianTears) do
			if tmpTear:Exists() then
				local tearVel = (player.Position - tmpTear.Position):Normalized() * tearSpeed
				local newTear = Game():Spawn(
					EntityType.ENTITY_PROJECTILE,
					ProjectileVariant.PROJECTILE_TEAR,
					tmpTear.Position,
					tearVel,
					nil,
					0,
					Random() + 1
				)
				newTear.Color = tmpTear.Color
				tmpTear:Remove()
			end
		end
		SFXManager():Play(SoundEffect.SOUND_TEARS_FIRE)
		PST.specialNodes.SC_martianTears = {}
	end

	-- Ancient starcursed jewel: Saturnian Luminite
	if PST:SC_getSnapshotMod("saturnianLuminite", false) and room:GetAliveEnemiesCount() > 0 then
		local tmpDelay = 120
		if roomFrame % tmpDelay == 0 then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_SATURNUS)
			player:AddCollectible(CollectibleType.COLLECTIBLE_SATURNUS)
		end
	end

	-- Ancient starcursed jewel: Cursed Auric Shard
	if PST:SC_getSnapshotMod("cursedAuricShard", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_CARD_READING) and not inMineshaftPuzzle then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CARD_READING)
	end
	local tmpTimer = PST:getTreeSnapshotMod("SC_cursedAuricTimer", 0)
	if tmpTimer > 0 and gameFrame >= tmpTimer + 15 then
		PST:addModifiers({ SC_cursedAuricTimer = { value = 0, set = true } }, true)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT_2, UseFlag.USE_NOANIM)
	end

	-- Ancient starcursed jewel: Unusually Small Starstone
	if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_PLUTO) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLUTO)
		if player:GetOtherTwin() and not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_PLUTO) then
			player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_MARS)
		end
	end

	-- Ancient starcursed jewel: Primordial Kaleidoscope
	if PST:SC_getSnapshotMod("primordialKaleidoscope", false) and not inMineshaftPuzzle then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
		end
		if player:GetOtherTwin() then
			if not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE) then
				player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
			end
			if not player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE) then
				player:GetOtherTwin():AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
			end
		end
	end

	-- Ancient starcursed jewel: Teprucord Tenican Eljwe
	if PST:SC_getSnapshotMod("teprucordTenicanEljwe", false) then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_NO) then
			player:AddCollectible(CollectibleType.COLLECTIBLE_MISSING_NO)
		end
	end

	-- Ancient starcursed jewel: Cause Converter
	if PST.specialNodes.SC_causeConvRespawnTimer > 0 then
		PST.specialNodes.SC_causeConvRespawnTimer = PST.specialNodes.SC_causeConvRespawnTimer - 1
		if PST.specialNodes.SC_causeConvRespawnTimer == 0 then
			PST_causeConvBossSpawn()
		end
	else
		if PST.specialNodes.SC_causeConvBossEnt and not PST.specialNodes.SC_causeConvBossEnt:Exists() and PST.specialNodes.SC_causeConvRespawnTimer == 0 then
			PST.specialNodes.SC_causeConvRespawnTimer = 300
		end
	end

	-- Ancient starcursed jewel: Glowing Glass Piece
	if PST.specialNodes.SC_glowingGlassProc then
		local foundNPC = false
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly
			and tmpNPC.Type ~= EntityType.ENTITY_GIDEON then
				foundNPC = true
				local levelStageBonus = (level:GetStage() - 1) * 2
				if not PST:isFirstOrigStage() and level:GetStage() == LevelStage.STAGE1_1 then
					levelStageBonus = levelStageBonus + 1
				end
				tmpNPC.MaxHitPoints = (tmpNPC.MaxHitPoints + 5 + levelStageBonus) * (1.05 + levelStageBonus / 100)
				tmpNPC.HitPoints = tmpNPC.MaxHitPoints
			end
		end
		if foundNPC then
			SFXManager():Play(SoundEffect.SOUND_GLASS_BREAK, 0.9, 2, false, 0.7 + math.random(5) * 0.1)
			PST:addModifiers({ SC_glowingGlassProcs = 1 }, true)

			local tmpColor = Color(0.8, 0.8, 1, 1)
			local tmpProcs = PST:getTreeSnapshotMod("SC_glowingGlassProcs", 0)
			if tmpProcs <= 3 then
				if tmpProcs == 3 then
					tmpColor = Color(0.7, 1, 1, 1)
				end
				PST:createFloatTextFX(PST:getLocalized("ftxt_glassPiece") .. ": " .. tmpProcs .. "/3", Vector.Zero, tmpColor, 0.12, 100, true)
			end
		end
		PST.specialNodes.SC_glowingGlassProc = false
	end

	-- Ancient starcursed jewel: Crystallized Anamnesis
	if PST:SC_getSnapshotMod("crystallizedAnamnesis", false) then
		if not inMineshaftPuzzle then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) then
				player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CHAOS)
			end

			if not player:HasCollectible(CollectibleType.COLLECTIBLE_PURITY, true) and (level:GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_CURSED_MIST) == 0 then
				player:AddCollectible(CollectibleType.COLLECTIBLE_PURITY)
			end

			local triggerItemCheck = false
			local hasPurity = player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_PURITY)

			if not PST.specialNodes.SC_anamnesisJustReset then
				if not PST:getTreeSnapshotMod("SC_anamnesisDisabled", false) and not hasPurity then
					level:GetCurrentRoomDesc().Flags = level:GetCurrentRoomDesc().Flags | RoomDescriptor.FLAG_CURSED_MIST
					PST.specialNodes.SC_anamnesisResetTimer = 211
					SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH)
					PST:addModifiers({
						SC_anamnesisCursedRoom = { value = level:GetCurrentRoomIndex(), set = true },
						SC_anamnesisDisabled = true
					}, true)
				elseif PST:getTreeSnapshotMod("SC_anamnesisDisabled", false) and hasPurity then
					PST:addModifiers({ SC_anamnesisDisabled = false }, true)
					triggerItemCheck = true
				end
			elseif PST.specialNodes.SC_anamnesisJustReset then
				PST.specialNodes.SC_anamnesisJustReset = false
				PST:switchPurityState(player:GetPurityState())
			end

			local auraCache = PST:getTreeSnapshotMod("SC_anamnesisAuraCache", -1)
			if hasPurity and auraCache ~= -1 and auraCache ~= player:GetPurityState() then
				triggerItemCheck = true
			end

			if triggerItemCheck then
				local currentType = PST.anamnesisListTypes[player:GetPurityState()]
				local currentList = PST:getTreeSnapshotMod("SC_anamnesis" .. currentType, nil)
				if currentList then
					local otherItems = {}
					for tmpType, targetType in pairs(PST.anamnesisListTypes) do
						if tmpType ~= currentType then
							local otherList = PST:getTreeSnapshotMod("SC_anamnesis" .. targetType, nil)
							if otherList then
								for _, tmpItem in ipairs(otherList) do
									if tmpItem ~= CollectibleType.COLLECTIBLE_PURITY then
										table.insert(otherItems, tmpItem)
									end
								end
							end
						end
					end
					for _, tmpItem in ipairs(otherItems) do
						player:RemoveCollectible(tmpItem)
					end
					for _, tmpItem in ipairs(currentList) do
						if not player:HasCollectible(tmpItem) then
							player:AddCollectible(tmpItem, 0, false)
						end
					end
					player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
				end
			end

			if hasPurity and auraCache ~= player:GetPurityState() then
				PST:addModifiers({ SC_anamnesisAuraCache = { value = player:GetPurityState(), set = true } }, true)
			end

			if PST.specialNodes.SC_anamnesisResetTimer > 0 then
				PST.specialNodes.SC_anamnesisResetTimer = PST.specialNodes.SC_anamnesisResetTimer - 1
				if PST.specialNodes.SC_anamnesisResetTimer == 0 then
					level:GetCurrentRoomDesc().Flags = level:GetCurrentRoomDesc().Flags &~ RoomDescriptor.FLAG_CURSED_MIST
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_PURITY)
					player:AddCollectible(CollectibleType.COLLECTIBLE_PURITY)
					SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH)
					PST.specialNodes.SC_anamnesisJustReset = true
					PST:addModifiers({ SC_anamnesisCursedRoom = { value = -1, set = true } }, true)
				end
			end
		end
	end

	-- Ancient starcursed jewel: Shiftstone
	if PST:SC_getSnapshotMod("shiftstone", false) then
		local roomCenterX = room:GetCenterPos().X
		if room:GetGridWidth() > 15 then
			roomCenterX = 600
		end
		if player.Position.X <= roomCenterX and room:GetBrokenWatchState() ~= 2 then
			-- Speed up
			room:SetBrokenWatchState(2)
		elseif player.Position.X > roomCenterX then
			-- Slow down
			room:SetSlowDown(2)
			if room:GetBrokenWatchState() ~= 1 then
				room:SetBrokenWatchState(1)
			end
		end
	end

	-- Eldritch Mapping node
    if PST:getTreeSnapshotMod("eldritchMapping", false) and roomFrame % 20 == 0 then
		if (level:GetCurses() & LevelCurse.CURSE_OF_THE_LOST) > 0 and PST:getTreeSnapshotMod("eldritchMappingDebuffs", 0) < 3 then
			PST:addModifiers({ eldritchMappingDebuffs = 1, allstatsPerc = -4 }, true)
			local curDebuffs = PST:getTreeSnapshotMod("eldritchMappingDebuffs")
			level:RemoveCurses(LevelCurse.CURSE_OF_THE_LOST)
			PST:createFloatTextFX(PST:getLocalized("node_eldritchmapping_name") .. " " .. curDebuffs .. "/3", Vector.Zero, Color(0.2, 0.1, 0.21, 1), 0.12, 90, true)
			SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
		end
    end

	-- Fickle Fortune node (Cain's tree)
	if PST:getTreeSnapshotMod("fickleFortune", false) then
		-- +7% luck while holding a trinket
		local hasTrinket = player:GetTrinket(0) ~= 0 or player:GetTrinket(1) ~= 0
		if not PST:getTreeSnapshotMod("fickleFortuneActive", false) and hasTrinket then
			PST:addModifiers({ luckPerc = 7, fickleFortuneActive = true }, true)
		elseif PST:getTreeSnapshotMod("fickleFortuneActive", false) and not hasTrinket then
			PST:addModifiers({ luckPerc = -7, fickleFortuneActive = false }, true)
		end
	end

	-- Dark Heart node (Judas' tree)
	if PST:getTreeSnapshotMod("darkHeart", false) then
		-- -6% all stats while you have no black hearts. Book of Belial removes this reduction for the current room
		if not PST:getTreeSnapshotMod("darkHeartActive", false) and not PST:getTreeSnapshotMod("darkHeartBelial", false) and player:GetBlackHearts() == 0 then
			PST:addModifiers({ allstatsPerc = -6, darkHeartActive = true }, true)
		elseif PST:getTreeSnapshotMod("darkHeartActive", false) and (player:GetBlackHearts() > 0 or PST:getTreeSnapshotMod("darkHeartBelial", false)) then
			PST:addModifiers({ allstatsPerc = 6, darkHeartActive = false }, true)
		end
	end

	-- Inner Demon node (Judas' tree)
	if PST:getTreeSnapshotMod("innerDemon", false) then
		-- -45% damage as Dark Judas
		if not PST:getTreeSnapshotMod("innerDemonActive") and player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS then
			PST:addModifiers({ damagePerc = -45, innerDemonActive = true }, true)
		end
	end

	-- Heart updates
	PST:onHeartUpdate()

	-- Samson temp mods
	local tmpTime = PST:getTreeSnapshotMod("samsonTempTime", 0)
	if tmpTime ~= 0 then
		-- Mod: +damage or +speed for 2.5 seconds after killing an enemy, or hitting a boss 8 times
		if os.clock() - tmpTime > 2.5 and PST:getTreeSnapshotMod("samsonTempActive", false) then
			PST:addModifiers({
                damagePerc = -PST:getTreeSnapshotMod("samsonTempDamage", 0),
                speedPerc = -PST:getTreeSnapshotMod("samsonTempSpeed", 0),
                samsonTempActive = false,
				samsonTempTime = { value = 0, set = true}
            }, true)
		end
	end

	-- King's Curse node (Lazarus' tree)
	if PST:getTreeSnapshotMod("kingCurse", false) then
		if not PST:getTreeSnapshotMod("kingCurseActive", false) and player:GetPlayerType() ~= PlayerType.PLAYER_LAZARUS2 then
			PST:addModifiers({ allstatsPerc = -10, luck = -1, kingCurseActive = true }, true)
		elseif PST:getTreeSnapshotMod("kingCurseActive", false) and player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
			PST:addModifiers({ allstatsPerc = 10, luck = 1, kingCurseActive = false }, true)
		end
	end

	-- Mod: +all stats while luck is positive
	local tmpStats = PST:getTreeSnapshotMod("luckyAllStats", 0)
	if tmpStats > 0 then
		if player.Luck > 0 and not PST:getTreeSnapshotMod("luckyAllStatsActive", false) then
			PST:addModifiers({ allstats = tmpStats, luckyAllStatsActive = true }, true)
		elseif player.Luck <= 0 and PST:getTreeSnapshotMod("luckyAllStatsActive", false) then
			PST:addModifiers({ allstats = -tmpStats, luckyAllStatsActive = false }, true)
		end
	end

	-- Holy mantle broken
	local plHasHolyMantle = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
	if plHasHolyMantle == nil and updateTrackers.holyMantleTracker then
		updateTrackers.holyMantleTracker = false

		-- Sacred Aegis node (The Lost's tree)
		if PST:getTreeSnapshotMod("sacredAegis", false) then
			-- Regenerate holy mantle after 7 seconds in this room
			PST.specialNodes.sacredAegis.hitTime = roomFrame

			if PST.specialNodes.sacredAegis.hitsTaken < 2 then
				PST:addModifiers({ allstatsPerc = -7 }, true)
				PST.specialNodes.sacredAegis.hitsTaken = PST.specialNodes.sacredAegis.hitsTaken + 1
			end
		end

		-- Mod: all stats while not having holy mantle
		tmpStats = PST:getTreeSnapshotMod("noHolyMantleAllStats", 0)
		if tmpStats ~= 0 and not PST:getTreeSnapshotMod("noHolyMantleAllStatsActive", false) then
			PST:addModifiers({ allstats = tmpStats, noHolyMantleAllStatsActive = true }, true)
		end
	elseif plHasHolyMantle ~= nil and not updateTrackers.holyMantleTracker then
		updateTrackers.holyMantleTracker = true

		tmpStats = PST:getTreeSnapshotMod("noHolyMantleAllStats", 0)
		if tmpStats ~= 0 and PST:getTreeSnapshotMod("noHolyMantleAllStatsActive", false) then
			PST:addModifiers({ allstats = -tmpStats, noHolyMantleAllStatsActive = false }, true)
		end
	end

	-- Sacred Aegis node (The Lost's tree)
	if PST:getTreeSnapshotMod("sacredAegis", false) and roomFrame - PST.specialNodes.sacredAegis.hitTime >= 210 and
	PST.specialNodes.sacredAegis.hitTime ~= 0 and not PST.specialNodes.sacredAegis.proc then
		-- Regenerate holy mantle
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
		sfx:Play(SoundEffect.SOUND_BEEP)
		Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, player.Position, Vector.Zero, nil, 0, Random() + 1)
		PST.specialNodes.sacredAegis.proc = true
	end

	-- Familiar quantity update
	local tmpTotal = PST:getTreeSnapshotMod("totalFamiliars", 0)
	if tmpTotal ~= updateTrackers.familiarsTracker then
		player:AddCacheFlags(PST.allstatsCache, true)
		updateTrackers.familiarsTracker = tmpTotal
	end

	-- Gulp! node (Keeper's tree)
	if PST:getTreeSnapshotMod("gulp", false) then
		-- +1.5 luck while holding swallowed penny
		local hasTrinket = player:GetTrinket(0) == TrinketType.TRINKET_SWALLOWED_PENNY or player:GetTrinket(1) == TrinketType.TRINKET_SWALLOWED_PENNY
		if hasTrinket and not PST:getTreeSnapshotMod("gulpActive", false) then
			PST:addModifiers({ luck = 1.5, gulpActive = true }, true)
		elseif not hasTrinket and PST:getTreeSnapshotMod("gulpActive", false) then
			PST:addModifiers({ luck = -1.5, gulpActive = false }, true)
		end
	end

	-- Null node (Apollyon's tree)
	if PST:getTreeSnapshotMod("null", false) then
		-- Set whether an active item has been absorbed
		if not PST:getTreeSnapshotMod("nullActiveAbsorbed", false) and #player:GetVoidedCollectiblesList() > 0 then
			PST:addModifiers({ nullActiveAbsorbed = true }, true)
		end

		-- -10% all stats while not holding void
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and not PST:getTreeSnapshotMod("nullDebuff", false) then
			PST:addModifiers({ allstatsPerc = -10, nullDebuff = true }, true)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and PST:getTreeSnapshotMod("nullDebuff", false) then
			PST:addModifiers({ allstatsPerc = 10, nullDebuff = false }, true)
		end
	end

	-- Player type changes
	if updateTrackers.playerTypeTracker ~= player:GetPlayerType() then
		-- Inner Flare node (The Forgotten's tree)
		if PST:getTreeSnapshotMod("innerFlare", false) then
			-- Slow room enemies when switching to The Soul
			if not PST:getTreeSnapshotMod("innerFlareProc", false) and updateTrackers.playerTypeTracker == PlayerType.PLAYER_THEFORGOTTEN and
			player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
				for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
					if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() then
						tmpEntity:AddSlowing(EntityRef(player), math.floor(PST:getTreeSnapshotMod("innerFlareSlowDuration", 2) * 30), 0.7, Color(0.7, 0.7, 1, 1, 0, 0))
					end
				end
				PST:addModifiers({ innerFlareProc = true }, true)
			end
		end

		-- Spirit-taker node (Forgotten's tree)
		if PST:getTreeSnapshotMod("spiritTaker", false) and updateTrackers.playerTypeTracker ~= player:GetPlayerType() then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_VADE_RETRO, UseFlag.USE_NOANIM)
		end

		updateTrackers.playerTypeTracker = player:GetPlayerType()
	end

	-- Fate Pendulum node (Bethany's tree)
	if PST:getTreeSnapshotMod("fatePendulum", false) then
		-- -50% all stats while not holding Metronome
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_METRONOME) and not PST:getTreeSnapshotMod("fatePendulumDebuffActive", false) then
			PST:addModifiers({ allstatsPerc = -50, fatePendulumDebuffActive = true }, true)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_METRONOME) and PST:getTreeSnapshotMod("fatePendulumDebuffActive", false) then
			PST:addModifiers({ allstatsPerc = 50, fatePendulumDebuffActive = false }, true)
		end
	end

	-- Player twin checks
	local tmpTwin = player:GetOtherTwin()
	if tmpTwin then
		-- Heart Link node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("heartLink", false) then
			if (player:GetHearts() - tmpTwin:GetHearts()) ~= updateTrackers.jacobHeartDiffTracker then
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE, true)
				tmpTwin:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE, true)
				updateTrackers.jacobHeartDiffTracker = player:GetHearts() - tmpTwin:GetHearts()
			end
		end

		-- Statue Pilgrimage node (Jacob & Esau's tree)
		if PST:getTreeSnapshotMod("statuePilgrimage", false) then
			---@diagnostic disable-next-line: undefined-field
			tmpTimer = tmpTwin:GetGnawedLeafTimer()
			if tmpTimer >= 60 and not PST.specialNodes.esauIsStatue then
				PST.specialNodes.esauIsStatue = true
			elseif tmpTimer < 60 and PST.specialNodes.esauIsStatue then
				PST.specialNodes.esauIsStatue = false
			end

			local tmpDist = PST:distBetweenPoints(player.Position, tmpTwin.Position)
			if PST.specialNodes.esauIsStatue and tmpDist < tmpTwin.TearRange / 3 and not PST.specialNodes.jacobNearEsauBuff then
				PST:addModifiers({ allstatsPerc = 12 }, true)
				PST.specialNodes.jacobNearEsauBuff = true
			elseif (not PST.specialNodes.esauIsStatue or tmpDist > tmpTwin.TearRange / 3) and PST.specialNodes.jacobNearEsauBuff then
				PST:addModifiers({ allstatsPerc = -12 }, true)
				PST.specialNodes.jacobNearEsauBuff = false
			end
		end

		-- Mod: +luck per 1/2 heart of any type with the brother with lower total health
		local tmpBonus = PST:getTreeSnapshotMod("jacobHeartLuck", 0)
		if tmpBonus ~= 0 then
			local tmpHP = player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() / 2
			local twinHP = tmpTwin:GetHearts() + tmpTwin:GetSoulHearts() + tmpTwin:GetBoneHearts() + tmpTwin:GetRottenHearts() / 2
			if twinHP < tmpHP then
				tmpHP = twinHP
			end
			if tmpHP ~= PST.specialNodes.jacobHeartLuckVal then
				PST.specialNodes.jacobHeartLuckVal = tmpHP
				player:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
				tmpTwin:AddCacheFlags(CacheFlag.CACHE_LUCK, true)
			end
		end

		-- T. Forgotten
		if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
			local isHeld = tmpTwin:IsHoldingItem() and player.Position:Distance(tmpTwin.Position) <= 10
			if isHeld and not PST:getTreeSnapshotMod("forgIsHeld", false) then
				PST:addModifiers({ speedPerc = tmpMod, forgIsHeld = true }, true)
			elseif not isHeld and PST:getTreeSnapshotMod("forgIsHeld", false) then
				PST:addModifiers({ speedPerc = tmpMod, forgIsHeld = false }, true)

				-- Mod: % chance to trigger Telekinesis' effect when launching T. Forgotten
				tmpMod = PST:getTreeSnapshotMod("forgTelekinesis", 0)
				if tmpMod > 0 and 100 * math.random() < tmpMod then
					tmpTwin:UseActiveItem(CollectibleType.COLLECTIBLE_TELEKINESIS, UseFlag.USE_NOANIM)
				end
			end
		end
	end

	-- Luck changes
	if player.Luck ~= updateTrackers.luckTracker then
		-- Mod: +% all stats when luck changes
		tmpStats = PST:getTreeSnapshotMod("mightOfFortune", 0)
		if tmpStats ~= 0 then
			player:AddCacheFlags(PST.allstatsCache, true)
		end
		updateTrackers.luckTracker = player.Luck
	end

	-- Coin changes
	if player:GetNumCoins() ~= updateTrackers.coinTracker then
		-- Lost coins
		if player:GetNumCoins() < updateTrackers.coinTracker then
			-- Starcursed mod: when losing or spending coins, X% chance to additionally lose Y coins
			tmpMod = PST:SC_getSnapshotMod("loseCoinsOnSpend", {0, 0})
			if tmpMod[1] > 0 and tmpMod[2] > 0 and 100 * math.random() < tmpMod[1] then
				player:AddCoins(-tmpMod[2])
			end

			-- Wealthsmith node (Cain's tree)
			if PST:getTreeSnapshotMod("wealthsmith", false) then
				local diff = updateTrackers.coinTracker - player:GetNumCoins()
				local buffTotal = PST:getTreeSnapshotMod("wealthsmithBuff", 0)
				local tmpAdd = math.min(12 - buffTotal, 0.2 * diff)
				if tmpAdd > 0 then
					PST:addModifiers({ tearsPerc = tmpAdd, wealthsmithBuff = tmpAdd }, true)
				end
			end
		-- Gained coins
		elseif player:GetNumCoins() > updateTrackers.coinTracker then
			-- Marquess of Flies node (T. Keeper's tree)
			if PST:getTreeSnapshotMod("marquessOfFlies", false) then
				local tmpFlies = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY)
				if tmpFlies < 20 and 100 * math.random() < 50 then
					Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, player, 0, Random() + 1)
				end
			end
		end
		-- Ancient weapon mod: Auric persecutor
		if PST:getSnapAstralWepMod("auricPersecutor") then
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
		-- Ancient starcursed jewel: Glittering Starstone
		if PST:SC_getSnapshotMod("glitteringStarstone", false) then
			local tmpCap = 50 + PST:getTreeSnapshotMod("SC_glitterStoneCoinCap", 0)
			if player:GetNumCoins() > tmpCap then
				player:AddCoins(tmpCap - player:GetNumCoins())
			end
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
		-- Deep-Space Distortion mod: Limit coins
		if PST:getTreeSnapshotMod("dsdMod_pickupLimit", false) and player:GetNumCoins() > 35 then
			player:AddCoins(35 - player:GetNumCoins())
		end
		updateTrackers.coinTracker = player:GetNumCoins()
	end

	-- Key changes
	if player:GetNumKeys() ~= updateTrackers.keyTracker then
		local diff = player:GetNumKeys() - updateTrackers.keyTracker
		-- Spent/lost keys
		if diff < 0 then
			-- Expedition objective: spend keys
			PST:expedAddProgInRun("keys", math.abs(diff))

			-- Expedition curse: fading keys
			tmpMod = PST:getTreeSnapshotMod("curseFadingKeys", 0)
			if tmpMod > 0 then
				player:AddKeys(-tmpMod)
			end
		end
		-- Deep-Space Distortion mod: Limit keys
		if PST:getTreeSnapshotMod("dsdMod_pickupLimit", false) and player:GetNumKeys() > 8 then
			player:AddKeys(8 - player:GetNumKeys())
		end
		updateTrackers.keyTracker = player:GetNumKeys()
	end

	-- Deep-Space Distortion mod: Limit bombs
	if PST:getTreeSnapshotMod("dsdMod_pickupLimit", false) and player:GetNumBombs() > 8 then
		player:AddBombs(8 - player:GetNumBombs())
	end

	-- Level curse changes
	local tmpCurses = level:GetCurses()
	if tmpCurses ~= updateTrackers.lvlCurseTracker then
		-- Mod: all stats while a level curse is present
		tmpMod = PST:getTreeSnapshotMod("curseAllstats", 0)
		if tmpMod ~= 0 then
			if tmpCurses ~= 0 and not PST:getTreeSnapshotMod("curseAllstatsActive", false) then
				PST:addModifiers({ allstatsPerc = tmpMod, curseAllstatsActive = true }, true)
			elseif tmpCurses == 0 and PST:getTreeSnapshotMod("curseAllstatsActive", false) then
				PST:addModifiers({ allstatsPerc = -tmpMod, curseAllstatsActive = false }, true)
			end
		end
		updateTrackers.lvlCurseTracker = tmpCurses
	end

	-- Pocket item changes
	local pocketItemSum = player:GetCard(0) + player:GetCard(1)
	if pocketItemSum ~= updateTrackers.pocketTracker then
		-- Vacuophobia node (T. Isaac's tree)
		if PST:getTreeSnapshotMod("vacuophobia", false) then
			PST:updateCacheDelayed()
		end
		updateTrackers.pocketTracker = pocketItemSum
	end

	-- Blood charge changes
	if player:GetEffectiveBloodCharge() ~= updateTrackers.bloodCharges then
		if updateTrackers.bloodCharges ~= nil then
			local tmpDiff = player:GetEffectiveBloodCharge() - updateTrackers.bloodCharges
			if tmpDiff ~= 0 then
				-- Mod: % chance to gain +% to a random stat when consuming a blood charge, up to 30x per floor
				local tmpStatList = PST:getTreeSnapshotMod("bloodChargeStatList", nil)
				if tmpDiff < 0 and tmpStatList and PST:getTreeSnapshotMod("bloodChargeStatProcs", 0) < 30 then
					tmpMod = PST:getTreeSnapshotMod("bloodChargeStat", 0)
					if tmpMod > 0 then
						local tmpStatMods = { bloodChargeStatProcs = 0 }
						for _=1,math.abs(tmpDiff) do
							if 100 * math.random() < tmpMod then
								local randStat = PST:getRandomStat() .. "Perc"
								if not tmpStatList[randStat] then
									tmpStatList[randStat] = 0
								end
								tmpStatList[randStat] = tmpStatList[randStat] + 0.4

								if not tmpStatMods[randStat] then
									tmpStatMods[randStat] = 0
								end
								tmpStatMods[randStat] = tmpStatMods[randStat] + 0.4
								tmpStatMods.bloodChargeStatProcs = tmpStatMods.bloodChargeStatProcs + 1
							end
						end
						PST:addModifiers(tmpStatMods, true)
					end
				end
			end
		end
		updateTrackers.bloodCharges = player:GetEffectiveBloodCharge()
	end

	-- Mod: every X total seconds spent firing, shoot an additional piercing/homing tear
	tmpMod = PST:getTreeSnapshotMod("tBethHomingTear", 0)
	if tmpMod > 0 then
		local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
		if isShooting then
			if PST.specialNodes.tBethHomingTearTimer <= 0 then
				PST.specialNodes.tBethHomingTearTimer = tmpMod * 30
			elseif PST.specialNodes.tBethHomingTearTimer > 0 then
				PST.specialNodes.tBethHomingTearTimer = PST.specialNodes.tBethHomingTearTimer - 1
				if PST.specialNodes.tBethHomingTearTimer <= 0 then
					local newTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BALLOON_BRIMSTONE, player.Position, plInput * 6, player, 0, Random() + 1)
					newTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_HOMING)
					newTear:ToTear().Height = -60
					newTear:ToTear().FallingSpeed = -PST:getPlayer().TearFallingSpeed * 5
					newTear.SpriteScale = Vector(1.2, 1.2)
					newTear.Color = PST:RGBColor(120, 30, 182)
					newTear.CollisionDamage = player.Damage * 1.5

					local tmpFearChance = PST:getTreeSnapshotMod("tBethHomingTearFear", 0)
					if tmpFearChance > 0 and 100 * math.random() < tmpFearChance then
						newTear:ToTear():AddTearFlags(TearFlags.TEAR_FEAR)
					end
				end
			end
		end
	end

	-- Strange Coupon node (T. Keeper's tree)
	if PST:getTreeSnapshotMod("strangeCoupon", false) then
		local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_COUPON)
		if tmpSlot ~= -1 then
			local couponCharges = player:GetActiveCharge(tmpSlot)
			local chargesCache = PST:getTreeSnapshotMod("strangeCouponCharges", 0)
			if couponCharges ~= chargesCache then
				if 100 * math.random() < PST:getTreeSnapshotMod("couponNullifyChance", 0) and couponCharges > chargesCache then
					player:AddActiveCharge(chargesCache - couponCharges, tmpSlot, true, false, false)
				else
					PST:addModifiers({ strangeCouponCharges = { value = couponCharges, set = true } }, true)
				end
			end
		end
	end

	-- Spider Mod node
	if PST:getTreeSnapshotMod("spiderMod", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD) and not inMineshaftPuzzle then
        player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD)
	end

	-- Overwhelming Voice node (Siren's tree)
	if PST.specialNodes.overwhelmingVoiceProc then
		local dmgMult = 1
		if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
			dmgMult = 0.5
		end
		-- Convert friendly enemies back to enemies & deal damage
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC then
				if EntityRef(tmpNPC).IsFriendly and (not PST.specialNodes.SC_causeConvBossEnt or
				(PST.specialNodes.SC_causeConvBossEnt and tmpNPC.InitSeed ~= PST.specialNodes.SC_causeConvBossEnt.InitSeed)) then
					tmpNPC:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
					if PST:getTreeSnapshotMod("overwhelmingVoiceBuff", 0) < 20 then
						PST:addModifiers({ damagePerc = 5, overwhelmingVoiceBuff = 5 }, true)
					end
				end
				if EntityRef(tmpNPC).IsCharmed then
					tmpNPC:TakeDamage((6 + level:GetStage() - 1) * dmgMult, 0, EntityRef(player), 0)
				end
			end
		end
		PST.specialNodes.overwhelmingVoiceProc = false
	end

	-- Mod: innate items absorbed by Black Rune
	tmpMod = PST:getTreeSnapshotMod("blackRuneInnateItems", {})
	if #tmpMod > 0 and not inMineshaftPuzzle then
		for _, tmpItem in ipairs(tmpMod) do
			if not player:HasCollectible(tmpItem) then
				player:AddInnateCollectible(tmpItem)
			end
		end
	end

	-- Dextral Runemaster: Berkano innate Hive Mind
	if PST:getTreeSnapshotMod("berkanoHivemind", false) and roomFrame > 1 and not player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
	end
	-- Dextral Runemaster: Algiz buff
	if PST:getTreeSnapshotMod("algizBuffProc", false) and roomFrame % 30 == 0 then
		tmpMod = PST:getTreeSnapshotMod("algizBuffTimer", 0)
		if tmpMod > 0 then
			PST:addModifiers({ algizBuffTimer = -1 }, true)
		else
			PST:addModifiers({ damagePerc = -7, tearsPerc = -7, algizBuffProc = false }, true)
		end
	end

	-- Lingering Malice, creep damage against flying enemies
	if #PST.specialNodes.lingMaliceCreepList > 0 and roomFrame % 15 == 0 then
		for i = #PST.specialNodes.lingMaliceCreepList, 1, -1 do
			local tmpCreep = PST.specialNodes.lingMaliceCreepList[i]
			if tmpCreep.Timeout > 0 then
				local tmpEnemies = Isaac.FindInRadius(tmpCreep.Position, tmpCreep.Size, EntityPartition.ENEMY)
				for _, tmpEntity in ipairs(tmpEnemies) do
					local tmpNPC = tmpEntity:ToNPC()
					if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsFlying() then
						local tmpDamage = (player.Damage / 2) * (1 + PST:getTreeSnapshotMod("creepDamage", false) / 100)
						tmpNPC:TakeDamage(tmpDamage, 0, EntityRef(player), 0)
					end
				end
			else
				table.remove(PST.specialNodes.lingMaliceCreepList, i)
			end
		end
	end

	-- Mod: +% damage/tears when picking up temporary hearts
	if PST.specialNodes.temporaryHeartBuffTimer > 0 then
		PST.specialNodes.temporaryHeartBuffTimer = PST.specialNodes.temporaryHeartBuffTimer - 1
		if PST.specialNodes.temporaryHeartBuffTimer == 0 then
			PST.specialNodes.temporaryHeartDmgStacks = 0
			PST.specialNodes.temporaryHeartTearStacks = 0
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
		end
	end

	-- Troll bomb disarm debuff timer
	if PST.specialNodes.trollBombDisarmDebuffTimer > 0 then
		PST.specialNodes.trollBombDisarmDebuffTimer = PST.specialNodes.trollBombDisarmDebuffTimer - 1
	end

	-- Mod: +% damage for 2 seconds after destroying poop
	if PST.specialNodes.poopDestroyBuffTimer > 0 then
		PST.specialNodes.poopDestroyBuffTimer = PST.specialNodes.poopDestroyBuffTimer - 1
		if PST.specialNodes.poopDestroyBuffTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Bloodwrath node (T. Eve's tree)
	if PST.specialNodes.bloodwrathFlipTimer > 0 then
		PST.specialNodes.bloodwrathFlipTimer = PST.specialNodes.bloodwrathFlipTimer - 1
		if PST.specialNodes.bloodwrathFlipTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Chaos Take The World node (T. Eden's tree)
	if PST:getTreeSnapshotMod("chaosTakeTheWorld", false) and not player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_CHAOS)
	end

	-- Mod: random devil/angel active effect when hit
	if PST.specialNodes.activeOnHitProc.proc then
		local tmpItem = Game():GetItemPool():GetCollectible(PST.specialNodes.activeOnHitProc.pool, true)
		local tmpItemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
		local failsafe = 0
		while ((tmpItemCfg and tmpItemCfg.Type ~= ItemType.ITEM_ACTIVE) or not tmpItemCfg) and failsafe < 200 do
			tmpItem = Game():GetItemPool():GetCollectible(PST.specialNodes.activeOnHitProc.pool, true)
			tmpItemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
			failsafe = failsafe + 1
		end
		if tmpItem > 0 and failsafe < 200 then
			player:UseActiveItem(tmpItem, UseFlag.USE_NOANIM)
			PST:addModifiers({ [PST.specialNodes.activeOnHitProc.procMod] = true }, true)

			local tmpColor = Color(0.7, 0.9, 1, 1)
			if PST.specialNodes.activeOnHitProc.pool == ItemPoolType.POOL_DEVIL then
				tmpColor = Color(1, 0.6, 0.6, 1)
			end
			local itemName = Isaac.GetLocalizedString("Items", tmpItemCfg.Name, Options.Language)
			if itemName ~= "StringTable::InvalidKey" then
				PST:createFloatTextFX(itemName, Vector.Zero, tmpColor, 0.13, 70, true)
			end
		end
		PST.specialNodes.activeOnHitProc.proc = false
	end

	-- Mod: random passive treasure item on hit
	if PST.specialNodes.treasureItemOnHitProc then
		local tmpItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true)
		local tmpItemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
		local failsafe = 0
		while ((tmpItemCfg and tmpItemCfg.Type ~= ItemType.ITEM_PASSIVE) or not tmpItemCfg or PST:arrHasValue(PST.heartUpItems, tmpItem)
		or player:HasCollectible(tmpItem)) and failsafe < 200 do
			tmpItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true)
			tmpItemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
			failsafe = failsafe + 1
		end
		if tmpItem > 0 and failsafe < 200 then
			player:AddInnateCollectible(tmpItem)
			PST:addModifiers({ treasureItemOnHitItem = tmpItem }, true)

			local itemName = Isaac.GetLocalizedString("Items", tmpItemCfg.Name, Options.Language)
			if itemName ~= "StringTable::InvalidKey" then
				PST:createFloatTextFX("+" .. itemName, Vector.Zero, Color(1, 1, 0.7, 1), 0.13, 70, true)
			end
		end
		PST.specialNodes.treasureItemOnHitProc = false
	end

	-- Mod: % chance for one of the resulting rerolled items to be 1 quality higher
	if PST.specialNodes.higherQualityRerollProc then
		local tmpItemList = {}
		for _, histItem in ipairs(player:GetHistory():GetCollectiblesHistory()) do
			local itemID = histItem:GetItemID()
			local itemCfg = Isaac.GetItemConfig():GetCollectible(itemID)
			if itemCfg and itemCfg.Type == ItemType.ITEM_PASSIVE and itemCfg.Quality < 4 and not histItem:IsTrinket() then
				table.insert(tmpItemList, { item = itemID, pool = histItem:GetItemPoolType() })
			end
		end
		if #tmpItemList > 0 then
			local randItem = tmpItemList[math.random(#tmpItemList)]
			local randItemCfg = Isaac.GetItemConfig():GetCollectible(randItem.item)

			local newItem = Game():GetItemPool():GetCollectible(randItem.pool, true)
			local newItemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
			local failsafe = 0
			while ((newItemCfg and (newItemCfg.Type ~= ItemType.ITEM_PASSIVE or newItemCfg.Quality ~= randItemCfg.Quality + 1)) or not newItemCfg or
			player:HasCollectible(newItem)) and failsafe < 500 do
				newItem = Game():GetItemPool():GetCollectible(randItem.pool, true)
				newItemCfg = Isaac.GetItemConfig():GetCollectible(newItem)
				failsafe = failsafe + 1
			end
			if newItem > 0 and failsafe < 500 then
				player:RemoveCollectible(randItem.item)
				player:AddCollectible(newItem)

				local itemName = Isaac.GetLocalizedString("Items", newItemCfg.Name, Options.Language)
				if itemName ~= "StringTable::InvalidKey" then
					PST:createFloatTextFX(PST:getLocalized("ftxt_plusQual") .. ": " .. itemName, Vector.Zero, Color(0.5, 0.9, 1, 1), 0.12, 100, true)
				else
					PST:createFloatTextFX(PST:getLocalized("ftxt_plusQual"), Vector.Zero, Color(0.5, 0.9, 1, 1), 0.12, 100, true)
				end
			end
		end
		PST.specialNodes.higherQualityRerollProc = false
	end

	-- Mod: +% speed that decays to 0 over 4+ seconds when entering a room with monsters
	if PST.specialNodes.roomEnterSpdTimer > 0 then
		PST.specialNodes.roomEnterSpdTimer = PST.specialNodes.roomEnterSpdTimer - 1
		if PST.specialNodes.roomEnterSpdTimer % 15 == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end

	-- Mod: +speed for the next floor when clearing the boss room without having/receiving shields at any point in the fight
	if PST:getTreeSnapshotMod("shieldlessBossSpeed", 0) > 0 and not PST:getTreeSnapshotMod("shieldlessBossProc", false) and room:GetType() == RoomType.ROOM_BOSS then
		if PST:TLostHasAnyShield() then
			PST:addModifiers({ shieldlessBossProc = true }, true)
		end
	end

	-- Ballistosseous node (T. Forgotten's tree)
	if PST:getTreeSnapshotMod("ballistosseous", false) then
		if PST.specialNodes.ballistosseousTimer > 0 then
			PST.specialNodes.ballistosseousTimer = PST.specialNodes.ballistosseousTimer - 1
		end
		if PST.specialNodes.ballistosseousTimer == 0 and room:GetAliveEnemiesCount() > 0 then
			local tmpSoul = player:GetOtherTwin()
			if tmpSoul then
				local tearVel = Vector.Zero
				local isHeld = false
				if player.Position:Distance(tmpSoul.Position) <= 10 then
					local nearbyEnemies = Isaac.FindInRadius(player.Position, 120, EntityPartition.ENEMY)
					if #nearbyEnemies > 0 then
						for _, tmpEnemy in ipairs(nearbyEnemies) do
							if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() then
								tearVel = (tmpEnemy.Position - player.Position):Normalized() * (10 * player.ShotSpeed)
								break
							end
						end
					end
					isHeld = true
				else
					tearVel = (tmpSoul.Position - player.Position):Normalized() * (10 * player.ShotSpeed)
				end
				if tearVel.X ~= 0 or tearVel.Y ~= 0 then
					local tmpTears = 30 / (player.MaxFireDelay + 1)
					if isHeld then
						tmpTears = tmpTears * 0.4
					end
					PST.specialNodes.ballistosseousTimer = math.ceil(30 / tmpTears)

					local newTear = Game():Spawn(
						EntityType.ENTITY_TEAR,
						TearVariant.BONE,
						player.Position,
						tearVel,
						player,
						0,
						Random() + 1
					)
					newTear:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL)
					newTear:ToTear().Height = player.TearHeight
					newTear:ToTear().FallingSpeed = -player.TearFallingSpeed
					newTear.CollisionDamage = player.Damage * (0.5 + PST:getTreeSnapshotMod("forgBoneTearDmg", 0) / 100)

					if not isHeld then
						newTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING)
					end
				end
			end
		end
	end

	-- Mod: +% damage for 2 seconds after using Recall
	if PST.specialNodes.recallDamageTimer > 0 then
		PST.specialNodes.recallDamageTimer = PST.specialNodes.recallDamageTimer - 1
		if PST.specialNodes.recallDamageTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Cosmic Realignment node
	local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
	if PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
		-- Lilith, -8% all stats if you don't currently have a baby familiar
		local hasBabyFamiliar = false
		for _, familiarType in ipairs(PST.babyFamiliarItems) do
			if player:HasCollectible(familiarType) then
				hasBabyFamiliar = true
				break
			end
		end
		if not cosmicRCache.lilithActive and not hasBabyFamiliar then
			PST:addModifiers({ allstatsPerc = -8 }, true)
			cosmicRCache.lilithActive = true
		elseif cosmicRCache.lilithActive and hasBabyFamiliar then
			PST:addModifiers({ allstatsPerc = 8 }, true)
			cosmicRCache.lilithActive = false
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
		-- The Forgotten, Keeper debuff: -4% all stats per active blue fly, up to -40%
		if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or
		player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
			local debuffVal = math.max(-40, math.min(cosmicRCache.forgottenKeeperDebuff, player:GetNumBlueFlies() * -4))
			if cosmicRCache.forgottenKeeperDebuff ~= debuffVal then
				cosmicRCache.forgottenKeeperDebuff = debuffVal
				player:AddCacheFlags(PST.allstatsCache, true)
			end
		end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_ISAAC_B) then
        -- Tainted Isaac, -4% all stats per item obtained after the 8th one, up to -40%
		local tmpItemCount = math.max(0, player:GetCollectibleCount() - 8)
		if tmpItemCount ~= cosmicRCache.TIsaacItems then
        	cosmicRCache.TIsaacItems = tmpItemCount
			player:AddCacheFlags(PST.allstatsCache, true)
		end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
		-- Tainted Cain, -2 luck if not holding Bag of Crafting
		if not cosmicRCache.TCainActive and not player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
			PST:addModifiers({ luck = -2 }, true)
			cosmicRCache.TCainActive = true
		elseif cosmicRCache.TCainActive and player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
			PST:addModifiers({ luck = 2 }, true)
			cosmicRCache.TCainActive = false
		end
	elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JACOB_B) then
		-- Tainted Jacob, spawn Dark Esau if he's not around
		if room:GetAliveEnemiesCount() > 0 and not PST.specialNodes.TJacobEsauSpawned then
			local spawned = #Isaac.FindByType(EntityType.ENTITY_DARK_ESAU) > 0
			if not spawned then
				local tmpDarkEsau = Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, room:GetCenterPos(), Vector.Zero, player, 0, Random() + 1)
            	tmpDarkEsau:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
				PST.specialNodes.TJacobEsauSpawned = true
			end
		end
	end

	-- Bag of Crafting effects
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING) then
		-- Bag of Crafting pickup changes
		local craftBagChecksum = 0
		for _, tmpBagPickup in ipairs(player:GetBagOfCraftingContent()) do
			craftBagChecksum = craftBagChecksum + tmpBagPickup
		end
		if updateTrackers.craftBagPickups ~= craftBagChecksum then
			if craftBagChecksum > 0 then
				local newPickup = 0
				if not PST:getTreeSnapshotMod("craftingBagFull", false) then
					for i=0,6 do
						if player:GetBagOfCraftingSlot(i) ~= 0 and player:GetBagOfCraftingSlot(i + 1) == 0 then
							newPickup = player:GetBagOfCraftingSlot(i)
							break
						end
					end
				end
				if newPickup == 0 then
					newPickup = player:GetBagOfCraftingSlot(7)
				end
				-- New bag pickup
				if newPickup ~= 0 then
					-- Opportunist node (T. Cain's tree)
					if PST:getTreeSnapshotMod("opportunist", false) then
						if newPickup == BagOfCraftingPickup.BOC_RED_HEART and 100 * math.random() < 30 then
							player:AddHearts(1)
						elseif newPickup == BagOfCraftingPickup.BOC_SOUL_HEART and 100 * math.random() < 15 then
							player:AddSoulHearts(1)
						elseif newPickup == BagOfCraftingPickup.BOC_BLACK_HEART and 100 * math.random() < 15 then
							player:AddBlackHearts(1)
						elseif (newPickup == BagOfCraftingPickup.BOC_PENNY or newPickup == BagOfCraftingPickup.BOC_GOLD_PENNY or newPickup == BagOfCraftingPickup.BOC_LUCKY_PENNY)
						and 100 * math.random() < 15 then
							player:AddCoins(1)
						elseif newPickup == BagOfCraftingPickup.BOC_NICKEL and 100 * math.random() < 15 then
							player:AddCoins(5)
						elseif newPickup == BagOfCraftingPickup.BOC_DIME and 100 * math.random() < 15 then
							player:AddCoins(10)
						elseif newPickup == BagOfCraftingPickup.BOC_KEY and 100 * math.random() < 15 then
							player:AddKeys(1)
						elseif newPickup == BagOfCraftingPickup.BOC_GOLD_KEY and 100 * math.random() < 15 then
							player:AddGoldenKey()
						elseif newPickup == BagOfCraftingPickup.BOC_BOMB and 100 * math.random() < 15 then
							player:AddBombs(1)
						elseif newPickup == BagOfCraftingPickup.BOC_GOLD_BOMB and 100 * math.random() < 15 then
							player:AddGoldenBomb()
						elseif newPickup == BagOfCraftingPickup.BOC_GIGA_BOMB and 100 * math.random() < 15 then
							player:AddGigaBombs(1)
						elseif (newPickup == BagOfCraftingPickup.BOC_MINI_BATTERY or newPickup == BagOfCraftingPickup.BOC_BATTERY or newPickup == BagOfCraftingPickup.BOC_MEGA_BATTERY)
						and 100 * math.random() < 15 then
							for _, slot in pairs(ActiveSlot) do
								player:AddActiveCharge(2, slot, true, false, false)
							end
						elseif newPickup == BagOfCraftingPickup.BOC_RUNE then
							player:UseCard(Card.RUNE_SHARD, UseFlag.USE_NOANIM)
						elseif newPickup == BagOfCraftingPickup.BOC_CARD then
							PST:addModifiers({ luckPerc = 0.5 }, true)
						end
					end
				end
			end

			-- Magic Bag node (T. Cain's tree)
			if PST:getTreeSnapshotMod("magicBag", false) or PST:getTreeSnapshotMod("grandIngredientCoins", false) or
			PST:getTreeSnapshotMod("grandIngredientKeys", false) or PST:getTreeSnapshotMod("grandIngredientBombs", false) then
				PST:updateCacheDelayed()
			else
				-- Bag pickup stat boost mods
				if PST:getTreeSnapshotMod("bagBombDamage", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
				end
				if PST:getTreeSnapshotMod("bagKeyTears", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
				end
				if PST:getTreeSnapshotMod("bagCoinRangeLuck", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK)
				end
				if PST:getTreeSnapshotMod("bagHeartSpeed", 0) > 0 then
					PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
				end
			end
			updateTrackers.craftBagPickups = craftBagChecksum
		end

		-- Set bag full status to detect crafting
		local bagStatus = player:GetBagOfCraftingSlot(7) ~= 0
		if bagStatus ~= PST:getTreeSnapshotMod("craftingBagFull", false) then
			-- Crafted item
			if PST:getTreeSnapshotMod("craftingBagFull", false) and #PST.specialNodes.craftBagSnapshot > 0 then
				-- Magic Bag node (T. Cain's tree)
				local spawnExtraPickups = 0
				if PST:getTreeSnapshotMod("magicBag", false) then
					spawnExtraPickups = 1
				end
				-- Mod: chance to spawn one of the consumed pickups when crafting an item
				if 100 * math.random() < PST:getTreeSnapshotMod("craftPickupRecovery", 0) then
					spawnExtraPickups = spawnExtraPickups + 1
				end
				if spawnExtraPickups > 0 then
					for _=1,spawnExtraPickups do
						local craftBagPickup = PST.specialNodes.craftBagSnapshot[math.random(8)]
						if craftBagPickup and PST.craftBagPickups[craftBagPickup] then
							local tmpNewPickup = PST.craftBagPickups[craftBagPickup]
							Game():Spawn(EntityType.ENTITY_PICKUP, tmpNewPickup[1], player.Position, RandomVector() * 3, nil, tmpNewPickup[2], Random() + 1)
						end
					end
				end

				-- Grand Ingredient nodes (T. Cain's tree)
				if PST:grandIngredientNodes(true) <= 2 then
					-- Grand Ingredient: Coins node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientCoins", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_NICKEL then
							player:AddCoins(5)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_DIME then
							player:AddCoins(10)
						end
					end

					-- Grand Ingredient: Bombs node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientBombs", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_GOLD_BOMB then
							PST:addModifiers({ damagePerc = 10 }, true)
						end
					end

					-- Grand Ingredient: Keys node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientKeys", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_GOLD_KEY then
							player:AddKeys(4)
							player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_CHARGED_KEY then
							for _, slot in ipairs(ActiveSlot) do
								player:AddActiveCharge(1, slot, true, false, false)
							end
						end
					end

					-- Grand Ingredient: Hearts node (T. Cain's tree)
					if PST:getTreeSnapshotMod("grandIngredientHearts", false) then
						if PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_RED_HEART then
							player:AddHearts(2)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_SOUL_HEART then
							player:AddSoulHearts(2)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_BLACK_HEART then
							player:AddBlackHearts(2)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_ETERNAL_HEART then
							player:SetFullHearts()
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_GOLD_HEART then
							player:AddCoins(7)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_BONE_HEART then
							player:AddBoneHearts(1)
						elseif PST.specialNodes.craftBagSnapshot[1] == BagOfCraftingPickup.BOC_ROTTEN_HEART then
							local tmpMax = 1 + math.random(3)
							for _=1,tmpMax do
								Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, player.Position, Vector.Zero, nil, 0, Random() + 1)
							end
							tmpMax = 1 + math.random(3)
							for _=1,tmpMax do
								Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, nil, 0, Random() + 1)
							end
						end
					end
				end

				-- Mod: +luck when crafting an item
				tmpMod = PST:getTreeSnapshotMod("itemCraftingLuck", 0)
				if tmpMod > 0 then
					PST:addModifiers({ luck = tmpMod }, true)
				end

				-- Cosmic Realignment node - Tainted Cain
				if PST:cosmicRCharPicked(PlayerType.PLAYER_CAIN_B) then
					if PST:getTreeSnapshotMod("craftingBagFull", false) then
						cosmicRCache.TCainUses = cosmicRCache.TCainUses + 1
					end
				end
			end
			PST:addModifiers({ craftingBagFull = bagStatus }, true)
		end
	end

	-- Stealth Tactics node (T. Judas' tree)
	if PST:getTreeSnapshotMod("stealthTactics", false) then
		local tmpDarkArts = player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS)
		if tmpDarkArts ~= hasDarkArtsEffect then
			player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
			hasDarkArtsEffect = tmpDarkArts
		end
	end

	-- Mod: dark pulse when landing with How to Jump
	if PST.specialNodes.howToJumpPulseTimer > 0 then
		PST.specialNodes.howToJumpPulseTimer = PST.specialNodes.howToJumpPulseTimer - 1
		if PST.specialNodes.howToJumpPulseTimer == 0 then
			local pulseEffect = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, player.Position, Vector.Zero, nil, 0, Random() + 1)
			pulseEffect:GetSprite().Scale = Vector(2, 2)
			pulseEffect.Color = Color(0.38, 0.1, 0.5, 1)
			SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1, 2, false, 1.3)

			for _, tmpEntity in ipairs(Isaac.FindInRadius(player.Position, 80, EntityPartition.ENEMY)) do
				local tmpNPC = tmpEntity:ToNPC()
				if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
					tmpNPC:TakeDamage(player.Damage * 1.5, 0, EntityRef(tmpNPC), 0)
				end
			end
		end
	end

	-- Mod: +% tears when using Dark Arts for 3 seconds
	if PST.specialNodes.darkArtsTearsTimer > 0 then
		PST.specialNodes.darkArtsTearsTimer = PST.specialNodes.darkArtsTearsTimer - 1
		if PST.specialNodes.darkArtsTearsTimer == 0 then
			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
		end
	end

	-- Berserk update
	local isBerserk = PST:isBerserk()
	if updateTrackers.isBerserk ~= nil and updateTrackers.isBerserk ~= isBerserk then
		local berserkEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		if berserkEffect then
			local berserkMaxCharge = PST:getBerserkMaxCharge()
			if berserkMaxCharge > 150 then
				berserkEffect.Item.MaxCooldown = berserkMaxCharge
			end

			if PST:getTreeSnapshotMod("absoluteRage", false) then
				PST:addModifiers({ absoluteRageCharge = { value = PST:getBerserkMaxCharge(), set = true } }, true)
			elseif berserkEffect then
				berserkEffect.Cooldown = PST:getBerserkMaxCharge()
			end

			-- Mod: % character size while berserk
			tmpMod = PST:getTreeSnapshotMod("berserkSize", 0)
			if tmpMod ~= 0 then
				player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
			end
		end

		PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
		updateTrackers.isBerserk = isBerserk
	end

	-- Violent Marauder node (T. Samson's tree)
	if PST:getTreeSnapshotMod("violentMarauder", false) then
		local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_SUPLEX)
		if tmpSlot ~= -1 and not PST:isBerserk() then
			player:SetActiveCharge(0, tmpSlot)
		end
	end

	-- Absolute Rage node (T. Samson's tree)
    if PST:getTreeSnapshotMod("absoluteRage", false) then
		local berserkEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		if berserkEffect then
			player.SamsonBerserkCharge = 0
			local rageCharge = PST:getTreeSnapshotMod("absoluteRageCharge", 0)
			if rageCharge > 0 then
				berserkEffect.Cooldown = rageCharge
			else
				player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
			end
		elseif roomFrame % 30 == 0 then
			player.SamsonBerserkCharge = math.min(100000, player.SamsonBerserkCharge + 5000)
			if player.SamsonBerserkCharge >= 100000 then
				player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
				SFXManager():Play(SoundEffect.SOUND_BERSERK_START)
			end
			PST:updateCacheDelayed(CacheFlag.CACHE_COLOR)
		end
	end
	if PST.specialNodes.berserkHitCooldown > 0 then
		PST.specialNodes.berserkHitCooldown = PST.specialNodes.berserkHitCooldown - 1
	end

	-- Gilded Regrowth node (T. Azazel's tree)
	if PST:getTreeSnapshotMod("gildedRegrowth", false) then
		if not player:IsFlying() and not PST:getTreeSnapshotMod("gildedRegrowthDebuff", false) then
			PST:addModifiers({ speed = -0.2, gildedRegrowthDebuff = true }, true)
		elseif player:IsFlying() and PST:getTreeSnapshotMod("gildedRegrowthDebuff", false) then
			PST:addModifiers({ speed = 0.2, gildedRegrowthDebuff = false }, true)
		end
	end

	-- Hemoptysis fired countdown
	if PST.specialNodes.hemoptysisFired > 0 then
		PST.specialNodes.hemoptysisFired = PST.specialNodes.hemoptysisFired - 1
	end

	-- Hemoptysis speed buff timer
	if PST.specialNodes.hemoptysisSpeedTimer > 0 then
		PST.specialNodes.hemoptysisSpeedTimer = PST.specialNodes.hemoptysisSpeedTimer - 1
		if PST.specialNodes.hemoptysisSpeedTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end

	-- Mod: +% damage while you have brimstone
	tmpMod = PST:getTreeSnapshotMod("brimstoneDmg", 0)
	if tmpMod > 0 then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) and not PST:getTreeSnapshotMod("brimstoneDmgApplied", false) then
			PST:addModifiers({ damagePerc = tmpMod, brimstoneDmgApplied = true }, true)
		elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) and PST:getTreeSnapshotMod("brimstoneDmgApplied", false) then
			PST:addModifiers({ damagePerc = -tmpMod, brimstoneDmgApplied = false }, true)
		end
	end

	-- Serendipitous Soul node (T. Eden's tree)
	if PST:getTreeSnapshotMod("serendipitousSoul", false) then
		if not PST:getTreeSnapshotMod("serendSoulUsed", false) then
			local edenSoulSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_EDENS_SOUL)
			if edenSoulSlot == -1 then
				player:AddCollectible(CollectibleType.COLLECTIBLE_EDENS_SOUL, 0, false, ActiveSlot.SLOT_PRIMARY)
			end
		end
	end

	-- Gello fired countdown
	if PST.specialNodes.gelloFired > 0 then
		PST.specialNodes.gelloFired = PST.specialNodes.gelloFired - 1
	end

	-- Coordinated Demons node (T. Lilith's tree)
	if PST:getTreeSnapshotMod("coordinatedDemons", false) then
		local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
		if isShooting then
			if not PST.specialNodes.gelloEntity or (PST.specialNodes.gelloEntity and not PST.specialNodes.gelloEntity:Exists()) then
				local tmpGelloQuery = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.UMBILICAL_BABY, 0)
				if #tmpGelloQuery > 0 then
					PST.specialNodes.gelloEntity = tmpGelloQuery[1]
				end
			end
			if PST.specialNodes.gelloEntity then
				if PST.specialNodes.coordinatedDemonsDelay > 0 then
					PST.specialNodes.coordinatedDemonsDelay = PST.specialNodes.coordinatedDemonsDelay - 1
					if PST.specialNodes.coordinatedDemonsDelay == 0 then
						local pulseEffect = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, PST.specialNodes.gelloEntity.Position, Vector.Zero, nil, 0, Random() + 1)
						pulseEffect:GetSprite().Scale = Vector(2, 2)
						pulseEffect.Color = Color(1, 0.2, 0.2, 1)
						SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.75, 2, false, 1.5)

						local pulseDmgMult = 0.7 + PST:getTreeSnapshotMod("gelloPulseDmg", 0) / 100
						for _, tmpEntity in ipairs(Isaac.FindInRadius(PST.specialNodes.gelloEntity.Position, 80, EntityPartition.ENEMY)) do
							local tmpNPC = tmpEntity:ToNPC()
							if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
								PST.specialNodes.gelloPulseDmgFlag = true
								tmpNPC:TakeDamage(player.Damage * pulseDmgMult, 0, EntityRef(tmpNPC), 0)
							end
						end
						PST.specialNodes.coordinatedDemonsDelay = math.ceil(player.MaxFireDelay * 3)
					end
				end
			end
			if PST.specialNodes.coordinatedDemonsWait < 60 then
				PST.specialNodes.coordinatedDemonsWait = 0
			end
		elseif PST.specialNodes.coordinatedDemonsWait < 60 then
			PST.specialNodes.coordinatedDemonsWait = PST.specialNodes.coordinatedDemonsWait + 1
			if PST.specialNodes.coordinatedDemonsWait == 60 then
				player:SetColor(Color(1, 1, 1, 1, 0.5, 0.1, 0.1), 15, 1, true, false)
				SFXManager():Play(SoundEffect.SOUND_BEEP, 0.9, 2, false, 1)
			end
		end
		if isFiring ~= isShooting then
			if isShooting then PST:addModifiers({ speed = -0.3 }, true)
			else PST:addModifiers({ speed = 0.3 }, true) end
			isFiring = isShooting
		end
	end

	-- Mod: +% speed for 1 second after using the whip attack (T. Lilith)
	if PST.specialNodes.whipSpeedTimer > 0 then
		PST.specialNodes.whipSpeedTimer = PST.specialNodes.whipSpeedTimer - 1
		if PST.specialNodes.whipSpeedTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end

	-- Mod: slowly gain up to + tears while Gello is retracted
	tmpMod = PST:getTreeSnapshotMod("gelloTearsBonus", 0)
	if tmpMod > 0 and roomFrame % 15 == 0 then
		local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
		if not isShooting then
			if PST.specialNodes.gelloTearBonusStep < 150 then
				PST.specialNodes.gelloTearBonusStep = math.min(150, PST.specialNodes.gelloTearBonusStep + 15)
				PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
			end
		elseif PST.specialNodes.gelloTearBonusStep > 0 then
			PST.specialNodes.gelloTearBonusStep = math.max(0, PST.specialNodes.gelloTearBonusStep - 25)
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
	end

	-- Mod: deal damage to enemies caught in Gello's cord every second
	tmpMod = PST:getTreeSnapshotMod("cordDamage", 0)
	if tmpMod > 0 and roomFrame % 15 == 0 then
		local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
		if isShooting and PST.specialNodes.gelloEntity then
			local tmpCapsule = Capsule(player.Position, PST.specialNodes.gelloEntity.Position, 8)
			for _, tmpEnemy in ipairs(Isaac.FindInCapsule(tmpCapsule, EntityPartition.ENEMY)) do
				if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() then
					tmpEnemy:TakeDamage(player.Damage * (tmpMod / 200), 0, EntityRef(player), 0)

					local tmpBleed = PST:getTreeSnapshotMod("cordBleed", 0)
					if tmpBleed > 0 and 100 * math.random() < tmpBleed then
						tmpEnemy:AddBleeding(EntityRef(player), 120)
					end
				end
			end
		end
	end

	-- Mod: +% tears for 2 seconds when a locust kills an enemy
	if PST.specialNodes.locustKillTearsTimer > 0 then
		PST.specialNodes.locustKillTearsTimer = PST.specialNodes.locustKillTearsTimer - 1
		if PST.specialNodes.locustKillTearsTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
	end

	-- Anima Sola, update chained enemies
	if PST.specialNodes.checkAnimaChain then
		PST.specialNodes.animaChainedMobs = {}

		local darkEsauChained = false
		local animaChains = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ANIMA_CHAIN, 0)
		if #animaChains > 0 then
			for _, tmpChain in ipairs(animaChains) do
				local target = tmpChain.Target
				if target and not PST:arrHasValue(PST.specialNodes.animaChainedMobs, target.InitSeed) then
					table.insert(PST.specialNodes.animaChainedMobs, target.InitSeed)

					if target.Type == EntityType.ENTITY_DARK_ESAU then
						darkEsauChained = true
					end
				end

				-- Mod: +% to Anima Sola's chain duration
				tmpMod = PST:getTreeSnapshotMod("animaSolaDuration", 0)
				if tmpMod > 0 and PST:arrHasValue(PST.specialNodes.animaNewChains, tmpChain.InitSeed) then
					tmpChain:ToEffect():SetTimeout(math.floor(tmpChain:ToEffect().Timeout * (1 + tmpMod / 100)))
				end
			end
			PST.specialNodes.animaNewChains = {}
		end
		PST.specialNodes.checkAnimaChain = false

		-- Dark Esau got unchained
		if not darkEsauChained and PST.specialNodes.darkEsauChained then
			-- Wrathful Chains node (T. Jacob's tree)
			if PST:getTreeSnapshotMod("wrathfulChains", false) then
				for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
					local tmpNPC = tmpEntity:ToNPC()
					if tmpNPC and tmpNPC:IsActiveEnemy(false) and not tmpNPC:IsBoss() and tmpNPC.Type ~= EntityType.ENTITY_DARK_ESAU then
						tmpNPC:AddSlowing(EntityRef(player), 90, 0.9, Color(0.9, 0.9, 0.9, 1))
					end
				end
			end
		end
		PST.specialNodes.darkEsauChained = darkEsauChained
	end

	-- Mod: +% damage and speed while near Dark Esau
	tmpMod = PST:getTreeSnapshotMod("darkEsauProxDmgSpeed", 0)
	if tmpMod > 0 then
		local inProximity = false
		if (roomFrame % 10) == 0 then
			local darkEsauQuery = Isaac.FindByType(EntityType.ENTITY_DARK_ESAU)
			if #darkEsauQuery > 0 then
				for _, tmpDarkEsau in ipairs(darkEsauQuery) do
					if tmpDarkEsau.Position:Distance(player.Position) <= 100 then
						if PST.specialNodes.darkEsauProxBuffTimer == 0 then
							PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
						end
						PST.specialNodes.darkEsauProxBuffTimer = 60
						inProximity = true
						break
					end
				end
			end
		end
		if not inProximity and PST.specialNodes.darkEsauProxBuffTimer > 0 then
			PST.specialNodes.darkEsauProxBuffTimer = PST.specialNodes.darkEsauProxBuffTimer - 1
			if PST.specialNodes.darkEsauProxBuffTimer == 0 then
				PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
			end
		end
	end

	-- Shadowmeld node (T. Siren's tree)
	if PST:getTreeSnapshotMod("shadowmeld", false) then
		local shadowmeldID = Isaac.GetItemIdByName("Shadowmeld")
		local shadowmeldSlot = player:GetActiveItemSlot(shadowmeldID)
		if room:GetAliveEnemiesCount() > 0 and shadowmeldSlot == -1 then
			local tmpSlot = PST:getSirenMelodySlot()
			if tmpSlot ~= -1 then
				local oldMelody = player:GetActiveItem(tmpSlot)
				PST:addModifiers({ sirenOldMelody = { value = oldMelody, set = true } }, true)

				-- Trick Siren mod's update function into thinking we have the melody to avoid it resetting pocket items
				player:AddInnateCollectible(oldMelody)

				player:SetPocketActiveItem(shadowmeldID, tmpSlot, false)
			end
		elseif room:GetAliveEnemiesCount() == 0 and (shadowmeldSlot == ActiveSlot.SLOT_POCKET or shadowmeldSlot == ActiveSlot.SLOT_POCKET2) then
			local oldMelody = PST:getTreeSnapshotMod("sirenOldMelody", Isaac.GetItemIdByName("Empty Notes"))
			player:SetPocketActiveItem(oldMelody, shadowmeldSlot, false)
			player:AddInnateCollectible(oldMelody, -1)

			local tmpMarkers = Isaac.FindByType(EntityType.ENTITY_EFFECT, PST.shadowmeldMarkerEffectID)
			for _, marker in ipairs(tmpMarkers) do
				marker:Remove()
			end
		end
	end

	-- Dark Arpeggio node (T. Siren's tree)
	if PST:getTreeSnapshotMod("darkArpeggio", false) then
		local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
		if isShooting then
			if PST.specialNodes.darkArpeggioTimer <= 0 then
				PST.specialNodes.darkArpeggioTimer = 30 * (4 + PST:getTreeSnapshotMod("darkArpeggioTearDelay", 0))
			elseif PST.specialNodes.darkArpeggioTimer > 0 then
				PST.specialNodes.darkArpeggioTimer = PST.specialNodes.darkArpeggioTimer - 1
				if PST.specialNodes.darkArpeggioTimer == 0 then
					local sirenMinionID = Isaac.GetEntityVariantByName("Siren Minion")
					if sirenMinionID ~= -1 then
						local sirenMinions = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, sirenMinionID)
						for _, tmpMinion in ipairs(sirenMinions) do
							local newTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.DARK_MATTER, tmpMinion.Position, plInput * 7, tmpMinion, 0, Random() + 1)
							newTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_FEAR)
							newTear:ToTear().FallingSpeed = -1
							newTear.Color = PST:RGBColor(120, 30, 182)
						end
					end
				end
			end
		end
	end

	if PST.specialNodes.sirenUsedMelody ~= -1 and player:IsExtraAnimationFinished() then
		PST.specialNodes.sirenUsedMelody = -1
	end

	-- Grand Consonance node (T. Siren's tree)
	if PST:getTreeSnapshotMod("grandConsonance", false) then
		-- Lil Haunt effect
		if PST.specialNodes.consonanceLilHauntTimer > 0 then
			local plInput = player:GetShootingInput()
			local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
			if isShooting then
				PST.specialNodes.consonanceLilHauntTimer = 0
			else
				PST.specialNodes.consonanceLilHauntTimer = PST.specialNodes.consonanceLilHauntTimer - 1
			end
			if PST.specialNodes.consonanceLilHauntTimer == 0 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
				SFXManager():Play(SoundEffect.SOUND_BLACK_POOF)
				PST.specialNodes.consonanceLilHauntOut = true
				player:GetSprite().Color.A = 1

				PST.specialNodes.consonanceLilHauntBuffTimer = 61
				PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
			end
		end
		if PST.specialNodes.consonanceLilHauntBuffTimer > 0 then
			PST.specialNodes.consonanceLilHauntBuffTimer = PST.specialNodes.consonanceLilHauntBuffTimer - 1
			if PST.specialNodes.consonanceLilHauntBuffTimer == 0 then
				PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
			end
		end
	end

	-- Acrid Gaze nodes (T. Siren's tree)
	tmpMod = PST:getTreeSnapshotMod("acridGaze", 0)
	if tmpMod > 0 then
		local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
		if isShooting then
			if PST.specialNodes.acridGazeTimer == 0 then
				PST.specialNodes.acridGazeTimer = 45
			elseif PST.specialNodes.acridGazeTimer > 0 then
				PST.specialNodes.acridGazeTimer = PST.specialNodes.acridGazeTimer - 1
				if PST.specialNodes.acridGazeTimer == 0 then
					local tmpScale = 1.5 + tmpMod / 100
					local tmpPos = player.Position + plInput * 50
					local pulseEffect = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpPos, Vector.Zero, nil, 0, Random() + 1)
                    pulseEffect:GetSprite().Scale = Vector(tmpScale, tmpScale)
                    pulseEffect.Color = PST:RGBColor(48, 25, 52)
                    SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.5, 2, false, 1.4)

                    for _, tmpEntity in ipairs(Isaac.FindInRadius(tmpPos, 30 * tmpScale, EntityPartition.ENEMY)) do
                        local tmpNPC = tmpEntity:ToNPC()
                        if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
                            local tmpDmg = math.min(10, player.Luck * 1.2)
                            tmpNPC:TakeDamage(tmpDmg, 0, EntityRef(player), 0)
							tmpNPC:AddFear(EntityRef(player), 60)
                        end
                    end
				end
			end
		end
	end

	-- Soul of the Siren effect
	if #PST.specialFX.sirenSoulUses > 0 then
		for i=#PST.specialFX.sirenSoulUses, 1, -1 do
			tmpUseData = PST.specialFX.sirenSoulUses[i]
			if tmpUseData.timer > 0 then
				tmpUseData.timer = tmpUseData.timer - 1
				if tmpUseData.timer == 0 then
					for _, tmpFamiliar in ipairs(tmpUseData.familiars) do
						player:AddInnateCollectible(tmpFamiliar, -1)
					end
					player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_FRIENDSHIP_NECKLACE)
					table.remove(PST.specialFX.sirenSoulUses, i)
				end
			end
		end
	end

	-- Astral weapon mod: quickblade implicit
	tmpMod = PST:getTreeSnapshotMod("astralwep_quickbladeImpStacks", nil)
	if tmpMod and #tmpMod > 0 then
		for i=#tmpMod,1,-1 do
			tmpMod[i] = tmpMod[i] - 1
			if tmpMod[i] <= 0 then
				table.remove(tmpMod, i)
				PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
			end
		end
	end

	-- Astral weapon mod: scythe implicit
	if PST.specialNodes.astralwep_scytheCD > 0 then
		PST.specialNodes.astralwep_scytheCD = PST.specialNodes.astralwep_scytheCD - 1
	end

	-- Astral weapon mod: greataxe implicit
	if PST.specialNodes.astralwep_greataxeBuffTimer > 0 then
		PST.specialNodes.astralwep_greataxeBuffTimer = PST.specialNodes.astralwep_greataxeBuffTimer - 1
		if PST.specialNodes.astralwep_greataxeBuffTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Astral weapon mod: +% damage dealt after firing consecutively for 3 seconds
	if PST.specialNodes.astralwep_consecFireBuffTimer > 0 then
		PST.specialNodes.astralwep_consecFireBuffTimer = PST.specialNodes.astralwep_consecFireBuffTimer - 1
	end

	-- Astral weapon mod: + base damage, removed for X secs when you get hit
	if PST.specialNodes.astralwep_baseDmg2Disable > 0 then
		PST.specialNodes.astralwep_baseDmg2Disable = PST.specialNodes.astralwep_baseDmg2Disable - 1
		if PST.specialNodes.astralwep_baseDmg2Disable == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Astral weapon timer mods
	local astralWepTimers = {"redHeal", "soulHeal", "blackHeal", "purchase", "coin"}
	for _, tmpTimerName in ipairs(astralWepTimers) do
		local timerName = "astralwep_" .. tmpTimerName .. "Timer"
		local tgtTimer = PST.specialNodes[timerName]
		if tgtTimer and tgtTimer > 0 then
			PST.specialNodes[timerName] = PST.specialNodes[timerName] - 1
			if PST.specialNodes[timerName] == 0 then
				PST.specialNodes["astralwep_" .. tmpTimerName .. "Buff"] = 0
			end
		end
	end

	-- Astral weapon mod: enemies take % more damage for X seconds after you get hit
	if PST.specialNodes.astralwep_onHitEnemyDmgTimer > 0 then
		PST.specialNodes.astralwep_onHitEnemyDmgTimer = PST.specialNodes.astralwep_onHitEnemyDmgTimer - 1
	end

	-- Astral weapon mod: +% damage dealt for X seconds after a familiar kills an enemy
	if PST.specialNodes.astralwep_famKillTimer > 0 then
		PST.specialNodes.astralwep_famKillTimer = PST.specialNodes.astralwep_famKillTimer - 1
	end

	-- Astral weapon mod: +% damage dealt for X seconds after using an active item
	if PST.specialNodes.astralwep_activeDmgTimer > 0 then
		PST.specialNodes.astralwep_activeDmgTimer = PST.specialNodes.astralwep_activeDmgTimer - 1
	end

	-- Ancient weapon mod: Grey Wind
	if PST.specialNodes.ancwep_greyWindCD > 0 then
		PST.specialNodes.ancwep_greyWindCD = PST.specialNodes.ancwep_greyWindCD - 1
	end

	-- Ancient weapon mod: Maxwell's Thermic Engine
	if PST.specialNodes.ancwep_maxwellBuffTimer > 0 then
		PST.specialNodes.ancwep_maxwellBuffTimer = PST.specialNodes.ancwep_maxwellBuffTimer - 1
		if PST.specialNodes.ancwep_maxwellBuffTimer == 0 then
			PST.specialNodes.ancwep_maxwellBuff = 0
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Consecutive firing timer
	local plInput = player:GetShootingInput()
	local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
	if isShooting then
		PST.specialNodes.consecutiveFire = PST.specialNodes.consecutiveFire + 1
	elseif player:GetMarkedTarget() ~= nil then
		if math.random() < 0.7 then
			PST.specialNodes.consecutiveFire = PST.specialNodes.consecutiveFire + 1
		end
	else
		PST.specialNodes.consecutiveFire = 0
	end

	-- Ancient weapon mod: Arcing Needle
	tmpMod = PST:getSnapAstralWepMod("arcingNeedle")
	if tmpMod and PST.specialNodes.consecutiveFire > 0 and (PST.specialNodes.consecutiveFire % 15) == 0 and not player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) and
	PST.specialNodes.ancwep_arcingNeedleTimer == 0 then
		if 100 * math.random() < tmpMod[1] + math.floor(PST.specialNodes.consecutiveFire / 15)  then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER)
			PST:addModifiers({ ancwep_arcingNeedleProc = true }, true)
			PST.specialNodes.ancwep_arcingNeedleTimer = math.ceil(tmpMod[2] * 30)
		end
	elseif PST:getTreeSnapshotMod("ancwep_arcingNeedleProc", false) then
		if PST.specialNodes.ancwep_arcingNeedleTimer > 0 then
			PST.specialNodes.ancwep_arcingNeedleTimer = PST.specialNodes.ancwep_arcingNeedleTimer - 1
		else
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER, -1)
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) then
				player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER))
			end
			PST:addModifiers({ ancwep_arcingNeedleProc = false }, true)
		end
	end

	-- Ancient weapon mod: Nimble Twins
	if PST.specialNodes.ancwep_nimbleTwinsCD > 0 then
		PST.specialNodes.ancwep_nimbleTwinsCD = PST.specialNodes.ancwep_nimbleTwinsCD - 1
	end
	if PST.specialNodes.ancwep_nimbleBlueTimer > 0 then
		PST.specialNodes.ancwep_nimbleBlueTimer = PST.specialNodes.ancwep_nimbleBlueTimer - 1
		if PST.specialNodes.ancwep_nimbleBlueTimer == 0 then
			PST.specialNodes.ancwep_nimbleBlueBuff = 0
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
	end
	if PST.specialNodes.ancwep_nimbleRedTimer > 0 then
		PST.specialNodes.ancwep_nimbleRedTimer = PST.specialNodes.ancwep_nimbleRedTimer - 1
		if PST.specialNodes.ancwep_nimbleRedTimer == 0 then
			PST.specialNodes.ancwep_nimbleRedBuff = 0
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
		end
	end

	-- Ancient weapon mod: Gravitas
	if PST.specialNodes.ancwep_gravitasCD > 0 then
		PST.specialNodes.ancwep_gravitasCD = PST.specialNodes.ancwep_gravitasCD - 1
	end

	-- Ancient weapon mod: Lost Coral Trident
	if PST:getSnapAstralWepMod("lostCoralTrident") and not player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS)
	end

	-- Ancient weapon mod: Verdant Green
	if PST.specialNodes.ancwep_verdantCD > 0 then
		PST.specialNodes.ancwep_verdantCD = PST.specialNodes.ancwep_verdantCD - 1
	end

	-- Ancient weapon mod: Oceanic Might
	if PST:getSnapAstralWepMod("oceanicMight") and not player:HasCollectible(CollectibleType.COLLECTIBLE_AQUARIUS) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_AQUARIUS)
	end
	if PST.specialNodes.ancwep_oceanicMightCD > 0 then
		PST.specialNodes.ancwep_oceanicMightCD = PST.specialNodes.ancwep_oceanicMightCD - 1
	end

	-- Ancient weapon mod: Ancient Runic Chopper
	if PST.specialNodes.ancwep_runicChopperTimer > 0 then
		PST.specialNodes.ancwep_runicChopperTimer = PST.specialNodes.ancwep_runicChopperTimer - 1
		if PST.specialNodes.ancwep_runicChopperTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
	end

	-- Ancient weapon mod: Frozen Terror
	if PST.specialNodes.ancwep_frozenTerrorCD > 0 then
		PST.specialNodes.ancwep_frozenTerrorCD = PST.specialNodes.ancwep_frozenTerrorCD - 1
	end

	-- Ancient weapon mod: Storm's Advance
	if PST:getSnapAstralWepMod("stormAdvance") and not player:HasCollectible(CollectibleType.COLLECTIBLE_120_VOLT) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_120_VOLT)
	end
	if PST.specialNodes.ancwep_stormAdvanceCD > 0 then
		PST.specialNodes.ancwep_stormAdvanceCD = PST.specialNodes.ancwep_stormAdvanceCD - 1
	end

	-- Ancient weapon mod: Quill Rain
	if PST:getSnapAstralWepMod("quillRain") and not player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)
	end

	-- Ancient weapon mod: Gilded Seeker
	if PST:getSnapAstralWepMod("gildedSeeker") and not player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER)
	end

	-- Ancient weapon mod: Twisted Oakstring
	if PST.specialNodes.ancwep_oakstringCD > 0 then
		PST.specialNodes.ancwep_oakstringCD = PST.specialNodes.ancwep_oakstringCD - 1
	end

	-- Ancient weapon mod: Brute's Onslaught
	if PST.specialNodes.ancwep_bruteOnslaughtBuffTimer > 0 then
		PST.specialNodes.ancwep_bruteOnslaughtBuffTimer = PST.specialNodes.ancwep_bruteOnslaughtBuffTimer - 1
		if PST.specialNodes.ancwep_bruteOnslaughtBuffTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
	end

	-- Ancient weapon mod: Volatile Arbalest
	if PST.specialNodes.ancwep_volatileArbalestCD > 0 then
		PST.specialNodes.ancwep_volatileArbalestCD = PST.specialNodes.ancwep_volatileArbalestCD - 1
	end

	-- Ancient weapon mod: Avelyn
	tmpMod = PST:getSnapAstralWepMod("avelyn")
	if tmpMod and PST.specialNodes.consecutiveFire > 0 and (PST.specialNodes.consecutiveFire % math.floor(tmpMod[1] * 30)) == 0 then
		local nearbyEnem = Isaac.FindInRadius(player.Position, 300, EntityPartition.ENEMY)
		if #nearbyEnem > 0 then
			local dist = 9999
			local closest = nil
			for _, tmpEnemy in ipairs(nearbyEnem) do
				if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
					local tmpDist = player.Position:Distance(tmpEnemy.Position)
					if tmpDist < dist then
						closest = tmpEnemy
						dist = tmpDist
					end
				end
			end
			if closest then
				for i=0,2 do
					local tmpVel = (closest.Position - PST:getPlayer().Position):Normalized() * (8 + i * 3)
					local tmpTear = player:FireTear(player.Position, tmpVel, false, true, false, player)
                    tmpTear:ToTear().Height = PST:getPlayer().TearHeight
                    tmpTear:ToTear().FallingSpeed = 0.5 + i * 0.2
                    tmpTear.CollisionDamage = PST:getPlayer().Damage * (tmpMod[2] / 100)
				end
				SFXManager():Play(SoundEffect.SOUND_STATIC, 0.6, 2, false, 2)
			end
		end
	end

	-- Ancient weapon mod: Precise Seeker
	if (gameFrame % 30) == 0 and PST:getSnapAstralWepMod("preciseSeeker") and room:GetAliveEnemiesCount() > 0 and
	not PST.specialNodes.ancwep_preciseSeekerMarked then
		local validEnemies = {}
		local validBosses = {}
		for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
				if tmpNPC:IsBoss() then
					table.insert(validBosses, tmpNPC)
				else
					table.insert(validEnemies, tmpNPC)
				end
			end
		end
		if #validBosses > 0 then
			PST.specialNodes.ancwep_preciseSeekerMarked = validBosses[math.random(#validBosses)]
		elseif #validEnemies > 0 then
			PST.specialNodes.ancwep_preciseSeekerMarked = validEnemies[math.random(#validEnemies)]
		end
	end
	local tmpMarked = PST.specialNodes.ancwep_preciseSeekerMarked
	if tmpMarked then
		tmpMod = PST:getSnapAstralWepMod("preciseSeeker")
		if tmpMod and tmpMarked:Exists() then
			PST.specialNodes.ancwep_preciseSeekerTimer = PST.specialNodes.ancwep_preciseSeekerTimer + 1
			if PST.specialNodes.ancwep_preciseSeekerTimer >= math.ceil(tmpMod[1] * 30) then
				local tmpVel = (tmpMarked.Position - PST:getPlayer().Position):Normalized() * 15
				local tmpTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, player.Position, tmpVel, player)
				tmpTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL)
				tmpTear:ToTear().Height = PST:getPlayer().TearHeight
				tmpTear:ToTear().FallingSpeed = 0.05
				tmpTear.CollisionDamage = math.min(60, PST:getPlayer().Damage * (tmpMod[2] / 100))
				PST.specialNodes.ancwep_preciseSeekerTimer = 0
			end
		elseif not tmpMarked:Exists() then
			PST.specialNodes.ancwep_preciseSeekerMarked = nil
		end
	end

	-- Ancient weapon mod: Glowing Moonblade
	if PST:getSnapAstralWepMod("glowingMoonblade") and not player:HasCollectible(CollectibleType.COLLECTIBLE_LUNA) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LUNA)
	end

	-- Ancient weapon mod: Glowing Sunblade
	if PST:getSnapAstralWepMod("glowingSunblade") and not player:HasCollectible(CollectibleType.COLLECTIBLE_SOL) and not inMineshaftPuzzle then
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SOL)
	end

	-- Ancient weapon mod: Circuit Splitter
	if #PST.specialNodes.ancwep_circuitEnems > 0 then
		for i=#PST.specialNodes.ancwep_circuitEnems,1,-1 do
			local tmpEnemy = PST.specialNodes.ancwep_circuitEnems[i]
			if tmpEnemy and tmpEnemy.timer > 0 then
				-- Make laser follow enemy
				local enemyExists = tmpEnemy.enemy and tmpEnemy.enemy:Exists()
				if enemyExists and tmpEnemy.laser:Exists() then
					tmpEnemy.laser.Position = tmpEnemy.enemy.Position
				end

				-- Subtract timer
				tmpEnemy.timer = tmpEnemy.timer - 1
				if tmpEnemy.timer == 0 then
					if tmpEnemy.laser:Exists() then
						tmpEnemy.laser:Remove()
					end
					table.remove(PST.specialNodes.ancwep_circuitEnems, i)
				end
			end
		end
	end

	-- Ancient weapon mod: Ivory Vampire
	if PST.specialNodes.ancwep_ivoryVampTimer > 0 and room:GetAliveEnemiesCount() > 0 then
		PST.specialNodes.ancwep_ivoryVampTimer = PST.specialNodes.ancwep_ivoryVampTimer - 1
		if PST.specialNodes.ancwep_ivoryVampTimer == 0 then
			PST.specialNodes.ancwep_ivoryVampStacks = 0
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED)
		end
	end

	-- Astral weapon mod: Great Mace implicit
	if PST.specialNodes.astralwep_greatmaceCD > 0 then
		PST.specialNodes.astralwep_greatmaceCD = PST.specialNodes.astralwep_greatmaceCD - 1
		-- Ancient weapon mod: Colossal Maul
		if PST.specialNodes.astralwep_greatmaceCD == 0 and PST:getSnapAstralWepMod("colossalMaul") then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
		end
	end

	-- Ancient weapon mod: Firestarter
	if PST.specialNodes.ancwep_firestarterBuffTimer > 0 then
		PST.specialNodes.ancwep_firestarterBuffTimer = PST.specialNodes.ancwep_firestarterBuffTimer - 1
		if PST.specialNodes.ancwep_firestarterBuffTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end

	-- Ancient weapon mod: Tolling Bell
	if PST:getSnapAstralWepMod("tollingBell") then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_LEO) and not inMineshaftPuzzle then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LEO)
		end
		if PST.specialNodes.ancwep_tollBellSpeedTimer > 0 then
			PST.specialNodes.ancwep_tollBellSpeedTimer = PST.specialNodes.ancwep_tollBellSpeedTimer - 1
			if PST.specialNodes.ancwep_tollBellSpeedTimer == 0 then
				PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
			end
		end
		if PST.specialNodes.ancwep_tollBellDamageTimer > 0 then
			PST.specialNodes.ancwep_tollBellDamageTimer = PST.specialNodes.ancwep_tollBellDamageTimer - 1
			if PST.specialNodes.ancwep_tollBellDamageTimer == 0 then
				PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
			end
		end
		if PST.specialNodes.ancwep_tollBellTearsTimer > 0 then
			PST.specialNodes.ancwep_tollBellTearsTimer = PST.specialNodes.ancwep_tollBellTearsTimer - 1
			if PST.specialNodes.ancwep_tollBellTearsTimer == 0 then
				PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
			end
		end
	end

	-- Ancient weapon mod: Quicksilver
	tmpMod = PST:getSnapAstralWepMod("quicksilver")
	if tmpMod then
		if PST.specialNodes.ancwep_quicksilverParryCD > 0 then
			PST.specialNodes.ancwep_quicksilverParryCD = PST.specialNodes.ancwep_quicksilverParryCD - 1
		end
		if PST.specialNodes.ancwep_quicksilverParrying > 0 then
			PST.specialNodes.ancwep_quicksilverParrying = PST.specialNodes.ancwep_quicksilverParrying - 1
		end
		if PST.specialNodes.ancwep_quicksilverBuff > 0 then
			PST.specialNodes.ancwep_quicksilverBuff = PST.specialNodes.ancwep_quicksilverBuff - 1
			if PST.specialNodes.ancwep_quicksilverBuff == 0 then
				PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
			end
		end
	end

	-- Segmented boss kill checks
	if #PST.segmentBossKillProcs > 0 then
		local bossData = PST.segmentBossKillProcs[1]
		if bossData and gameFrame > bossData.killFrame + 2 then
			local totalLeft = Isaac.FindByType(bossData.bossType, bossData.bossVariant, bossData.bossSub)
			-- Segmented boss killed
			if #totalLeft == 0 then
				-- Expedition boss kill
                if PST:isRunSidereal() then
					PST:expedAddProgInRun("defeatBosses", 1)
				end
			end
			table.remove(PST.segmentBossKillProcs, 1)
		end
	end

	-- Explosion immunity timer
	if PST.specialNodes.explosionImmunityTimer > 0 then
		PST.specialNodes.explosionImmunityTimer = PST.specialNodes.explosionImmunityTimer - 1
	end

	-- Sidereal Artifact cooldown
	if PST.specialNodes.sideArtiCD > 0 then
		PST.specialNodes.sideArtiCD = PST.specialNodes.sideArtiCD - 1
	end

	-- Sidereal Artifact: Galvanic Meridion buff timer
	if PST.specialNodes.arti_galvanicBuffTimer > 0 then
		PST.specialNodes.arti_galvanicBuffTimer = PST.specialNodes.arti_galvanicBuffTimer - 1
		if PST.specialNodes.arti_galvanicBuffTimer == 0 then
			PST:updateCacheDelayed()
		end
	end

	-- Sidereal Artifact: Executioner Meridion buff timer
	if PST.specialNodes.arti_executionerBuffTimer > 0 then
		PST.specialNodes.arti_executionerBuffTimer = PST.specialNodes.arti_executionerBuffTimer - 1
	end

	-- Sidereal Artifact: Gilded Meridion buff timer
	if PST.specialNodes.arti_gildedTimer > 0 then
		PST.specialNodes.arti_gildedTimer = PST.specialNodes.arti_gildedTimer - 1
	end

	-- Sidereal Artifact: Solar Septentrion buff
	if PST.specialNodes.arti_solarBuffTimer > 0 then
		PST.specialNodes.arti_solarBuffTimer = PST.specialNodes.arti_solarBuffTimer - 1
		if (PST.specialNodes.arti_solarBuffTimer % 30) == 0 then
			PST:sideArtiAddEnergy(PST.sideArtiData.solarSeptentrion.energy)
		end
	end

	-- Sidereal Artifact: Lunar Septentrion buff
	if PST.specialNodes.arti_lunarBuffTimer > 0 then
		PST.specialNodes.arti_lunarBuffTimer = PST.specialNodes.arti_lunarBuffTimer - 1
		if (PST.specialNodes.arti_lunarBuffTimer % 30) == 0 then
			PST:sideArtiAddEnergy(PST.sideArtiData.lunarSeptentrion.energy)
		end
	end

	-- Astral weapon mod: Whip cooldowns/buffs
	if PST.specialNodes.astralwep_whipCD > 0 then
		PST.specialNodes.astralwep_whipCD = PST.specialNodes.astralwep_whipCD - 1
		-- Sacred scourge faster cooldown
		if PST.specialNodes.ancwep_sacScourgeBuff > 0 then
			PST.specialNodes.astralwep_whipCD = math.max(0, PST.specialNodes.astralwep_whipCD - 1)
		end
	end
	if PST.specialNodes.astralwep_whipSpeedTimer > 0 then
		PST.specialNodes.astralwep_whipSpeedTimer = PST.specialNodes.astralwep_whipSpeedTimer - 1
		if PST.specialNodes.astralwep_whipSpeedTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end
	if PST.specialNodes.astralwep_whipTearTimer > 0 then
		PST.specialNodes.astralwep_whipTearTimer = PST.specialNodes.astralwep_whipTearTimer - 1
		if PST.specialNodes.astralwep_whipTearTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
		end
	end
	if PST.specialNodes.ancwep_sacScourgeBuff > 0 then
		PST.specialNodes.ancwep_sacScourgeBuff = PST.specialNodes.ancwep_sacScourgeBuff - 1
	end

	-- Boon of the Ordinary node (Isaac's tree)
	if PST:getTreeSnapshotMod("boonOrdinary", false) then
		if not inMineshaftPuzzle then
			if player:GetNumKeys() >= 12 and not PST:getPlayer():HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS) then
				player:AddCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS)
			elseif player:GetNumKeys() < 12 and PST:getPlayer():HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS) then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS)
			end
		end
	end

	-- Wealthsmith node (Cain's tree)
	if PST:getTreeSnapshotMod("wealthsmith", false) then
		if not inMineshaftPuzzle then
			local hasCoinKeys = (player:GetNumCoins() >= 20 and player:GetNumKeys() < 10)
			if hasCoinKeys and not player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY) then
				player:AddCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY)
			elseif not hasCoinKeys and player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY) then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY)
			end
		end
	end

	-- Demonic Ambition node (Azazel's tree)
	if PST:getTreeSnapshotMod("demonicAmbition", false) then
		if not inMineshaftPuzzle then
			if PST:GetBlackHeartCount(player) >= 4 and not player:HasCollectible(CollectibleType.COLLECTIBLE_GOAT_HEAD) then
				player:AddCollectible(CollectibleType.COLLECTIBLE_GOAT_HEAD)
			elseif PST:GetBlackHeartCount(player) < 4 and player:HasCollectible(CollectibleType.COLLECTIBLE_GOAT_HEAD) then
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_GOAT_HEAD)
			end
		end
	end

	-- Spaghettification node (Eden's tree)
	if PST.specialNodes.spaghettificationTimer > 0 then
		if PST.specialNodes.spaghettificationTimer == 300 then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE)
		elseif PST.specialNodes.spaghettificationTimer == 150 then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE, -1)
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE)
		end
		PST.specialNodes.spaghettificationTimer = PST.specialNodes.spaghettificationTimer - 1
		if PST.specialNodes.spaghettificationTimer == 0 then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE, -1)
		end
	end

	-- Mod: +% speed for 5 seconds after using any Bean active
	if PST.specialNodes.beanSpeedTimer > 0 then
		PST.specialNodes.beanSpeedTimer = PST.specialNodes.beanSpeedTimer - 1
		if PST.specialNodes.beanSpeedTimer == 0 then
			PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
		end
	end

	-- Spirit-bringer node (Forgotten's tree)
	if PST:getTreeSnapshotMod("spiritBringer", false) and not inMineshaftPuzzle then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS)
		end
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL and not player:HasCollectible(CollectibleType.COLLECTIBLE_QUINTS) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_QUINTS)
		elseif player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL and player:HasCollectible(CollectibleType.COLLECTIBLE_QUINTS) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_QUINTS, -1)
		end
	end

	-- Spirit-taker node (Forgotten's tree)
	if PST:getTreeSnapshotMod("spiritTaker", false) and not inMineshaftPuzzle then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_VADE_RETRO) and not PST:getTreeSnapshotMod("spiritTakerProc", false) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_VADE_RETRO)
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_VADE_RETRO) and PST:getTreeSnapshotMod("spiritTakerProc", false) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_VADE_RETRO, -1)
		end
	end

	-- Spirit-reaper node (Forgotten's tree)
	if PST:getTreeSnapshotMod("spiritReaper", false) and not inMineshaftPuzzle then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_PURGATORY) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_PURGATORY)
		end
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_HUNGRY_SOUL) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HUNGRY_SOUL)
		end
	end

	-- Spirit-protector node (Forgotten's tree)
	if PST:getTreeSnapshotMod("spiritProtector", false) and not inMineshaftPuzzle then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_SOUL) then
			player:AddInnateCollectible(CollectibleType.COLLECTIBLE_LOST_SOUL)
		end
		if not player:HasTrinket(TrinketType.TRINKET_FOUND_SOUL) then
			player:AddSmeltedTrinket(TrinketType.TRINKET_FOUND_SOUL)
		end
		if not player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL) then
			player:AddSmeltedTrinket(TrinketType.TRINKET_YOUR_SOUL)
		end
	end

	-- Deep-Space Distortion mod: Final boss temporary immunity on hp thresholds
	if PST.specialNodes.dsdMod_finalImmTimer > 0 then
		PST.specialNodes.dsdMod_finalImmTimer = PST.specialNodes.dsdMod_finalImmTimer - 1
	end

	-- Periodically clean entity data cache
	if roomFrame % 900 == 0 then
		PST.entDataCache = {}
	end

	-- Apollyon locust tears mod
	if PST.specialNodes.locustTearsTimer > 0 then
		PST.specialNodes.locustTearsTimer = PST.specialNodes.locustTearsTimer - 1
	end

	-- Ancient Weapon: Sword of Song cooldown
	if PST.specialNodes.ancwep_swordOfSongCD > 0 then
		PST.specialNodes.ancwep_swordOfSongCD = PST.specialNodes.ancwep_swordOfSongCD - 1
	end

	-- Ancient weapon: Divine Interceptor cooldown
	if PST.specialNodes.ancwep_divineIntCD > 0 then
		PST.specialNodes.ancwep_divineIntCD = PST.specialNodes.ancwep_divineIntCD - 1
	end

	-- Player near Holy Aura (Divine Messenger ancient weapon)
	if roomFrame % 10 == 0 then
		local tmpAuras = Isaac.FindByType(EntityType.ENTITY_EFFECT, PST.holyAuraEffectID)
		local withinAura = false
		for _, tmpRing in ipairs(tmpAuras) do
			if tmpRing.Position:Distance(player.Position) <= 70 then
				withinAura = true
				break
			end
		end
		if withinAura and not PST.specialNodes.inHolyAura then
			PST.specialNodes.inHolyAura = true
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
		elseif not withinAura and PST.specialNodes.inHolyAura then
			PST.specialNodes.inHolyAura = false
			PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
		end
	end

	-- Award pending xp whenever room becomes empty
	if PST.modData.xpObtained > 0 and room:GetAliveEnemiesCount() == 0 then
		-- Convert temp xp to normal xp
		if PST.modData.xpObtained > 0 then
			local xpOverflow = false
			if room:GetType() == RoomType.ROOM_BOSSRUSH then
				xpOverflow = true
			end
			PST:addXP(PST.modData.xpObtained, false, xpOverflow)
			PST.modData.xpObtained = 0
		end
	end

	-- Delayed cache update
	if PST.delayedCacheUpdate > 0 and gameFrame > PST.delayedCacheUpdate + 1 then
		PST.delayedCacheUpdate = 0
		player:AddCacheFlags(PST.delayedCacheFlags, true)
		if player:GetOtherTwin() then
			player:GetOtherTwin():AddCacheFlags(PST.delayedCacheFlags, true)
		end
		PST.delayedCacheFlags = 0
	end
end