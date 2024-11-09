local clearRoomProc = false
---@param level Level
---@param room Room
function PST:onRoomClear(level, room)
    -- On room clear
	if room:GetAliveEnemiesCount() == 0 and (not clearRoomProc or PST.modData.xpObtained > 0) then
		PST.modData.spawnKills = 0

        local player = PST:getPlayer()
        local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B

        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)

		local jewelDrop = false
		-- Challenge rooms
		if room:GetType() == RoomType.ROOM_CHALLENGE then
			-- Final round clear
			if not PST:getTreeSnapshotMod("challRoomClear", false) and
			(Ambush.GetCurrentWave() >= Ambush.GetMaxChallengeWaves() or (level:HasBossChallenge() and Ambush.GetCurrentWave() == 2)) then
				PST:addModifiers({ challRoomClear = true }, true)

				-- Challenge room XP reward
				local challengeXP = PST:getTreeSnapshotMod("challengeXP", 0)
				local bossChallengeXP = PST:getTreeSnapshotMod("bossChallengeXP", false)
				if challengeXP > 0 and (not level:HasBossChallenge() or (level:HasBossChallenge() and bossChallengeXP)) then
					PST:addTempXP(challengeXP, true)
				end

				if not PST:getTreeSnapshotMod("SC_challClear", false) then
					-- Starcursed jewel drop
					if 100 * math.random() < PST.SCDropRates.challenge(level:GetStage()).regular then
						local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
						PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.challenge(level:GetStage()).ancient)
						jewelDrop = true
					end

					-- Ancient starcursed jewel: Challenger's Starpiece
					if PST:SC_getSnapshotMod("challengerStarpiece", false) then
						local tmpVariant = 0
						if level:GetStage() >= 7 then
							tmpVariant = 1
						end
						Game():Spawn(
							PST.deadlySinBosses[math.random(#PST.deadlySinBosses)],
							tmpVariant, room:GetCenterPos(), Vector.Zero, nil, 0, Random() + 1
						)
					end
					PST:addModifiers({ SC_challClear = true }, true)
				end

				-- Expedition objective: clear challenge rooms
				PST:expedAddProgInRun("challengeRooms", 1)

				-- Obols on challenge room clear
				if PST:getTreeSnapshotMod("isExpedRun", false) then
					local tmpObols = PST.obolEvents.challClear(PST:getTreeSnapshotMod("expedDepth", 1))
					if tmpObols > 0 then PST:expedDropObolsAt(room:GetCenterPos(), tmpObols) end
				end

				-- Sidereal Caches on challenge room clear
				local tmpMod = PST:getTreeSnapshotMod("sideCacheChallenge", 0) + PST:getTreeSnapshotMod("sideCacheFloorChanceTotal", 0)
				if tmpMod > 0 and 100 * math.random() < tmpMod then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, Isaac.GetEntityVariantByName("Sidereal Cache"), 0, tmpPos, Vector.Zero, nil)
				end
			end
		-- Boss rooms
		elseif room:GetType() == RoomType.ROOM_BOSS then
			-- Thievery node Greed proc (Cain's tree)
			-- Mod: chance for Greed to spawn after defeating the first floor's boss
			if not PST.specialNodes.bossGreedSpawned and (PST:getTreeSnapshotMod("thieveryGreedProc", false) or
			(level:GetStage() == LevelStage.STAGE1_1 and 100 * math.random() < PST:getTreeSnapshotMod("firstBossGreed", 0))) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpPos, Vector.Zero, nil, 0, 0)
				Game():Spawn(EntityType.ENTITY_GREED, 0, tmpPos, Vector.Zero, nil, 0, Random() + 1)
				SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND)
				PST.specialNodes.bossGreedSpawned = true
			end

			-- Ancient starcursed jewel: Nullstone
			if PST:SC_getSnapshotMod("nullstone", false) then
				PST:addModifiers({ SC_nullstoneClear = true }, true)
			end
		-- Boss rush
		elseif room:GetType() == RoomType.ROOM_BOSSRUSH then
			-- Boss rush clear
			if Ambush.GetCurrentWave() == Ambush.GetMaxBossrushWaves() then
				-- Starcursed jewel drop
				if not PST:getTreeSnapshotMod("SC_bossrushJewel", false) and 100 * math.random() < PST.SCDropRates.bossrush().regular then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					PST:SC_dropRandomJewelAt(tmpPos, PST.SCDropRates.bossrush().ancient)
					PST:addModifiers({ SC_bossrushJewel = true }, true)
					jewelDrop = true
				end

				-- Expedition objective: complete boss rush encounters
				PST:expedAddProgInRun("bossRush", 1)

				-- Obols on boss rush clear
                if PST:getTreeSnapshotMod("isExpedRun", false) then
                    local tmpObols = PST.obolEvents.bossRush(PST:getTreeSnapshotMod("expedDepth", 1))
                    if tmpObols > 0 then PST:expedDropObolsAt(room:GetCenterPos(), tmpObols) end
                end
			end
		end

		-- Death's Trial nodes (T. Lost's tree)
		if PST:getTreeSnapshotMod("deathTrialActive", false) then
			PST:getLevel():GetCurrentRoomDesc().Flags = PST:getLevel():GetCurrentRoomDesc().Flags &~ RoomDescriptor.FLAG_CURSED_MIST
			PST:createFloatTextFX("Death's Trial Complete!", Vector.Zero, Color(), 0.13, 90, true)
			PST:addModifiers({ deathTrialActive = false }, true)
		end

		-- Once-per-clear effects
		if not PST:getTreeSnapshotMod("roomClearProc", false) and PST.modData.xpObtained > 0 then
			PST:addModifiers({ roomClearProc = true }, true)
			local isBossRoom = room:GetType() == RoomType.ROOM_BOSS

			-- Boss room
			if isBossRoom and PST:getTreeSnapshotMod("roomBossKills", 0) > 0 then
				-- Respec chance
				local respecChance = PST:getTreeSnapshotMod("respecChance", 15)
				if not PST:getTreeSnapshotMod("relearning", false) then
					local tmpRespecs = 0
					while (respecChance > 0) do
						if 100 * math.random() < respecChance then
							tmpRespecs = tmpRespecs + 1
						end
						respecChance = respecChance - 100
					end
					if tmpRespecs > 0 then
						PST:createFloatTextFX("+" .. tmpRespecs .. " Respec(s)", Vector.Zero, Color(), 0.12, 90, true)
						SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
						PST.modData.respecPoints = PST.modData.respecPoints + tmpRespecs
					end
				else
					-- Relearning node, count as completed floor
					PST:addModifiers({ relearningFloors = 1 }, true)
				end

				-- Floor clear counter
				PST:addModifiers({ floorClears = 1 }, true)

				-- Ancient starcursed jewel: Luminescent Die
				if PST:SC_getSnapshotMod("luminescentDie", false) then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_REVERSE_WHEEL_OF_FORTUNE, Random() + 1)
				end

				-- Ancient starcursed jewel: Sanguinis
				if PST:SC_getSnapshotMod("sanguinis", false) and not PST:getTreeSnapshotMod("SC_sanguinisTookDmg", false) then
					PST:createFloatTextFX("-- Sanguinis --", Vector.Zero, Color(0.1, 0.85, 0.1, 1), 0.12, 100, true)
					player:AddBrokenHearts(-1)
				end

				-- Ancient starcursed jewel: Twisted Emperor's Heirloom
				if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) then
					if PST:getTreeSnapshotMod("SC_empHeirloomRoomID", -1) == level:GetCurrentRoomDesc().SafeGridIndex then
						PST:addModifiers({ SC_empHeirloomProc = true }, true)
					end
				end

				-- Starcursed jewel drop
				if 100 * math.random() < PST.SCDropRates.boss(level:GetStage()).regular then
					PST.specialNodes.bossJewelDropProc = Game():GetFrameCount()
				end

				-- Boss room + took no damage
				if not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
					-- Mod: +luck when clearing boss room without taking damage
					tmpMod = PST:getTreeSnapshotMod("flawlessBossLuck", 0)
					if tmpMod > 0 then
						PST:addModifiers({ luck = tmpMod }, true)
					end

                    -- Mod: chance to gain 1 Ephemeral Bond when clearing boss room without taking damage
                    tmpMod = PST:getTreeSnapshotMod("ephBondBossHitless", 0)
                    if tmpMod > 0 and 100 * math.random() < tmpMod then
                        PST:addModifiers({ ephemeralBond = 1, gainedTempEphBond = 1 }, true)
                        PST:createFloatTextFX("+1 Ephemeral Bond", Vector.Zero, Color(0.8, 0.8, 1, 1), 0.12, 12, true)
                    end

					-- Expedition objective: clear boss rooms without taking damage
			        PST:expedAddProgInRun("bossRoomsNoDmg", 1)

					-- Expedition objective: clear boss rooms past chapter 3 (womb and beyond) without taking damage
					if level:GetStage() >= 7 then
						PST:expedAddProgInRun("bossesNoDmgC3", 1)
					end
				end

				-- Boss room + took no damage in floor
				if not PST:getTreeSnapshotMod("floorGotHit", false) then
					-- Blessed Pennies node (T. Keeper's tree)
					if PST:getTreeSnapshotMod("blessedPennies", false) then
						for i=1,0,-1 do
							local tmpTrinket = player:GetTrinket(i)
							if PST:arrHasValue(PST.pennyTrinkets, tmpTrinket) then
								player:TryRemoveTrinket(tmpTrinket)
								player:AddSmeltedTrinket(tmpTrinket)
								PST:createFloatTextFX("Smelted penny trinket", Vector.Zero, Color(1, 1, 0.7, 1), 0.12, 90, true)

								local tmpPos = PST:getRoom():FindFreePickupSpawnPosition(player.Position, 40)
								Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_PENNY, Random() + 1)
							end
						end
					end

					-- Expedition objective: clear floors without taking damage more than twice
					if PST:getTreeSnapshotMod("floorHitsReceived", 0) <= 2 then
						PST:expedAddProgInRun("floorNoDmgTwice", 1)
					-- Expedition objective: clear floors without taking damage more than once
					elseif PST:getTreeSnapshotMod("floorHitsReceived", 0) <= 1 then
						PST:expedAddProgInRun("floorNoDmgOnce", 1)
					end
				end

				-- Deferred Aegis node (T. Lost's tree)
				if PST:getTreeSnapshotMod("deferredAegis", false) and PST:getTreeSnapshotMod("deferredAegisCardUses", 0) < 2 then
					if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
						player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
						player:GetEffects():AddNullEffect(NullItemID.ID_HOLY_CARD)
						PST:createFloatTextFX("Deferred Aegis", Vector.Zero, Color(), 0.12, 70, true)
					end
				end

				-- Mod: +speed for the next floor when clearing the boss room without having/receiving shields at any point in the fight
				local tmpMod = PST:getTreeSnapshotMod("shieldlessBossSpeed", 0)
				if tmpMod > 0 and not PST:getTreeSnapshotMod("shieldlessBossProc", false) then
					PST:addModifiers({ shieldlessBossDone = true }, true)
				end

				-- Mod: % chance to receive The Stairway when clearing a boss room
				tmpMod = PST:getTreeSnapshotMod("stairwayBoon", 0)
				if tmpMod > 0 and not player:HasCollectible(CollectibleType.COLLECTIBLE_STAIRWAY) and 100 * math.random() < tmpMod then
					player:AddCollectible(CollectibleType.COLLECTIBLE_STAIRWAY)
					PST:createFloatTextFX("Stairway Boon", Vector.Zero, Color(1, 1, 0.6, 1), 0.12, 90, true)
				end

				-- Sidereal Caches on boss room clear
				tmpMod = PST:getTreeSnapshotMod("sideCacheBoss", 0) + PST:getTreeSnapshotMod("sideCacheFloorChanceTotal", 0)
				if tmpMod > 0 and 100 * math.random() < tmpMod then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, Isaac.GetEntityVariantByName("Sidereal Cache"), 0, tmpPos, Vector.Zero, nil)
				end

				-- Ancient weapon mod: Consecrator
				tmpMod = PST:getTreeSnapshotMod("ancwep_consecratorDmg", 0)
				if tmpMod > 0 then
					PST:addModifiers({ damagePerc = -tmpMod / 2, ancwep_consecratorDmg = -tmpMod / 2 }, true)
				end
				tmpMod = PST:getTreeSnapshotMod("ancwep_consecratorTears", 0)
				if tmpMod > 0 then
					PST:addModifiers({ tearsPerc = -tmpMod / 2, ancwep_consecratorTears = -tmpMod / 2 }, true)
				end

				-- Mod: % chance to spawn a locked chest after clearing the boss room
				local bossChest = false
				tmpMod = PST:getTreeSnapshotMod("bossLockedChest", 0)
				if tmpMod > 0 and 100 * math.random() < tmpMod then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, ChestSubType.CHEST_CLOSED, tmpPos, Vector.Zero, nil)
					bossChest = true
				end

				-- Mod: % chance to spawn a red chest after clearing the boss room
				tmpMod = PST:getTreeSnapshotMod("bossRedChest", 0)
				if not bossChest and tmpMod > 0 and 100 * math.random() < tmpMod then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, ChestSubType.CHEST_CLOSED, tmpPos, Vector.Zero, nil)
					bossChest = true
				end

				-- Mod: % chance to spawn a stone chest after clearing the boss room
				tmpMod = PST:getTreeSnapshotMod("bossStoneChest", 0)
				if not bossChest and tmpMod > 0 and 100 * math.random() < tmpMod then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMBCHEST, ChestSubType.CHEST_CLOSED, tmpPos, Vector.Zero, nil)
					bossChest = true
				end
			end

			-- Starcursed jewel drop
			if not jewelDrop and not PST:isFirstOrigStage() then
				tmpMod = PST:getTreeSnapshotMod("SC_jewelDropOnClear", 0)
				if 100 * math.random() < tmpMod then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					PST:SC_dropRandomJewelAt(tmpPos, 1)
					PST:addModifiers({ SC_jewelDropOnClear = { value = 0, set = true } }, true)
					jewelDrop = true
				elseif 100 * math.random() < 25 and tmpMod < 20 then
					PST:addModifiers({ SC_jewelDropOnClear = 0.5 }, true)
				end
			end

			-- Starcursed mod: chance to spawn an additional troll bomb at the center of the room on clear
			local tmpChance = PST:getTreeSnapshotMod("trollBombOnClear", 0)
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 20)
				Game():Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, tmpPos, Vector.Zero, nil, BombSubType.BOMB_TROLL, Random() + 1)
			end

			-- Ancient starcursed jewel: Umbra
			if PST:SC_getSnapshotMod("umbra", false) then
				if not PST:getTreeSnapshotMod("SC_umbraNightLightSpawn", false) and 100 * math.random() < 16 then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_NIGHT_LIGHT, Random() + 1)
					PST:addModifiers({ SC_umbraNightLightSpawn = true }, true)
				end
			end

			-- Ancient starcursed jewel: Crimson Warpstone
			if PST:SC_getSnapshotMod("crimsonWarpstone", false) then
				tmpChance = PST:getTreeSnapshotMod("SC_crimsonWarpKeyDrop", 0)
				if tmpChance > 0 and 100 * math.random() < tmpChance then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_CRACKED_KEY, Random() + 1)
				end
			end

			-- Ancient starcursed jewel: Cursed Auric Shard
			if PST:SC_getSnapshotMod("cursedAuricShard", false) then
				local roomType = room:GetType()
				if roomType == RoomType.ROOM_BOSS then
					PST:addModifiers({ SC_cursedAuricSpeedProc = true }, true)
				elseif 100 * math.random() < 90 then
					if roomType ~= RoomType.ROOM_BOSS and roomType ~= RoomType.ROOM_BOSSRUSH and roomType ~= RoomType.ROOM_ANGEL and roomType ~= RoomType.ROOM_DEVIL and
					roomType ~= RoomType.ROOM_CURSE and roomType ~= RoomType.ROOM_CHALLENGE then
						PST:addModifiers({ SC_cursedAuricTimer = { value = Game():GetFrameCount(), set = true } }, true)
					end
				end
			end

			-- Mod: chance to heal 1/2 red heart when clearing a room
			tmpChance = PST:getTreeSnapshotMod("healOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				player:AddHearts(1)
				if isBossRoom then
					player:AddHearts(1)
				end
			end

			-- Mod: chance to spawn an additional nickel when clearing a room
			tmpChance = PST:getTreeSnapshotMod("nickelOnClear", 0)
			if isBossRoom then
				tmpChance = tmpChance * 2
			end
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
			end

			-- Heartless node (Eve's tree)
			if PST:getTreeSnapshotMod("heartless", false) then
				-- +0.5% all stats on room clear, up to 10%
				tmpTotal = PST:getTreeSnapshotMod("heartlessTotal", 0)
				if tmpTotal < 10 then
					local tmpAdd = math.min(0.5, 10 - tmpTotal)
					if tmpAdd > 0 then
						PST:addModifiers({ allstatsPerc = tmpAdd, heartlessTotal = tmpAdd }, true)
					end
				end
			end

			-- Mod: +luck when clearing a room below full red hearts
			local tmpLuck = PST:getTreeSnapshotMod("luckOnClearBelowFull", 0)
			if tmpLuck > 0 and player:GetHearts() < player:GetEffectiveMaxHearts() then
				PST:addModifiers({ luck = tmpLuck, luckOnClearBelowFullBuff = tmpLuck }, true)
			end

			-- Mod: +luck if you clear the boss room within 40 seconds
			tmpLuck = PST:getTreeSnapshotMod("bossQuickKillLuck", 0)
			if isBossRoom and tmpLuck > 0 and room:GetFrameCount() <= 900 then
				local tmpTotal = PST:getTreeSnapshotMod("bossQuickKillLuckBuff", 0)
				if tmpTotal < 3 then
					local tmpAdd = math.min(tmpLuck, 3 - tmpTotal)
					PST:addModifiers({ luck = tmpAdd, bossQuickKillLuckBuff = tmpAdd }, true)
				end
			end

			-- Mod: +luck if you clear the boss room without getting hit
			tmpLuck = PST:getTreeSnapshotMod("bossFlawlessLuck", 0)
			if isBossRoom and tmpLuck > 0 and PST.specialNodes.bossRoomHitsFrom == 0 then
				local tmpTotal = PST:getTreeSnapshotMod("bossFlawlessLuckBuff", 0)
				if tmpTotal < 3 then
					local tmpAdd = math.min(tmpLuck, 3 - tmpTotal)
					PST:addModifiers({ luck = tmpAdd, bossFlawlessLuckBuff = tmpAdd }, true)
				end
			end

			-- A True Ending? node (Lazarus' tree)
			if isBossRoom and PST:getTreeSnapshotMod("aTrueEnding", false) and
			(level:GetStage() == LevelStage.STAGE1_1 or level:GetStage() == LevelStage.STAGE3_2 or level:GetStage() == LevelStage.STAGE4_2) then
				-- Drop Suicide King card when defeating first boss, mom, or mom's heart
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_SUICIDE_KING, Random() + 1)
			end

			-- Mod: chance to spawn 1/2 red heard as Lazarus, or 1/2 soul heart as Lazarus Risen
			tmpMod = PST:getTreeSnapshotMod("lazarusClearHearts", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_HALF, Random() + 1)
				elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
				end
			end

			-- Starblessed node (Eden's tree)
			if PST:getTreeSnapshotMod("starblessed", false) and not PST:getTreeSnapshotMod("starblessedProc", false) then
				if isBossRoom and level:GetStage() == LevelStage.STAGE1_1 then
					local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_STARS, Random() + 1)
					PST:addModifiers({ starblessedProc = true }, true)
				end
			end

			-- Mod: chance to spawn a soulheart on room clear
			tmpMod = PST:getTreeSnapshotMod("soulHeartOnClear", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
			end

			-- Null node (Apollyon's tree)
			-- Mod: chance to gain an additional active item charge when clearing a room
			if (PST:getTreeSnapshotMod("null", false) and PST:getTreeSnapshotMod("nullActiveAbsorbed", false) and 100 * math.random() < 50)
			or (100 * math.random() < PST:getTreeSnapshotMod("chargeOnClear", 0)) then
				if player:GetBatteryCharge(0) == 0 then
					player:AddActiveCharge(1, 0, true, false, false)
				end
			end

			-- Mod: chance to gain a soul charge when clearing a room
			tmpMod = PST:getTreeSnapshotMod("soulChargeOnClear", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				player:AddSoulCharge(1)
			end

			-- Song of Darkness node (Siren's tree)
			tmpMod = PST:getTreeSnapshotMod("songOfDarknessChance", 2)
			if PST:getTreeSnapshotMod("songOfDarkness", false) and tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_BLACK, Random() + 1)
			end

			-- Song of Awe node (Siren's tree) [Harmonic modifier]
			if PST:getTreeSnapshotMod("songOfAwe", false) then
				local tmpSlot = player:GetActiveItemSlot(Isaac.GetItemIdByName("Siren Song"))
				if tmpSlot ~= -1 and player:GetActiveCharge(tmpSlot) < player:GetActiveMaxCharge(tmpSlot) then
					SFXManager():Play(SoundEffect.SOUND_BEEP, 0.7)
					player:AddActiveCharge(1, tmpSlot, true, false, false)
				end
			end

			-- Mod: +% coalescing soul trigger chance when clearing a room without taking damage
			tmpMod = PST:getTreeSnapshotMod("coalSoulRoomClearChance", 0)
			if tmpMod > 0 and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
				PST:addModifiers({ coalescingSoulChance = tmpMod }, true)
			end

			-- Fractured Die node (T. Isaac's tree)
			if PST:getTreeSnapshotMod("fracturedRemains", false) and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
				-- Dice shard drop
				tmpChance = 3
				if room:GetType() == RoomType.ROOM_BOSS then
					tmpChance = 75
				end
				if 100 * math.random() < tmpChance then
					local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
					Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_DICE_SHARD, Random() + 1)
				end
				-- Rune shard drop
				if room:GetType() ~= RoomType.ROOM_BOSS then
					tmpChance = 7
					if 100 * math.random() < tmpChance then
						local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
						Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.RUNE_SHARD, Random() + 1)
					end
				else
					for _=1,2 do
						local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20)
						Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.RUNE_SHARD, Random() + 1)
					end
				end
			end

			-- Mod: +luck when clearing a boss room without taking damage
			tmpMod = PST:getTreeSnapshotMod("bossFlawlessLuck", 0)
			if tmpMod > 0 and room:GetType() == RoomType.ROOM_BOSS and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
				PST:addModifiers({ luck = tmpMod }, true)
			end

			-- Test of Temperance node (T. Magdalene's tree)
			if PST.specialNodes.testOfTemperanceCD > 0 then
				PST.specialNodes.testOfTemperanceCD = PST.specialNodes.testOfTemperanceCD - 1
			end

			-- Mod: chance to drop an additional coin/key/bomb/half heart when clearing a room
			tmpChance = PST:getTreeSnapshotMod("randPickupOnClear", 0)
			if tmpChance > 0 and 100 * math.random() < tmpChance then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local newPickup = PST:getTCainRandPickup()
				Game():Spawn(EntityType.ENTITY_PICKUP, newPickup[1], tmpPos, Vector.Zero, nil, newPickup[2], Random() + 1)
			end

			-- Dark Bestowal node (T. Azazel's tree)
			tmpMod = PST:getTreeSnapshotMod("darkBestowalItem", 0)
			if tmpMod > 0 then
				PST:addModifiers({ darkBestowalClears = 1 }, true)
				if PST:getTreeSnapshotMod("darkBestowalClears", 0) >= 4 then
					player:RemoveCollectible(tmpMod)
					PST:addModifiers({
						darkBestowalItem = { value = 0, set = true },
						darkBestowalClears = { value = 0, set = true }
					}, true)
				end
			end

            -- Great Overlap node (T. Lazarus' tree)
            if PST:getTreeSnapshotMod("greatOverlap", false) and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
                local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_FLIP)
                if tmpSlot ~= -1 then
                    player:AddActiveCharge(1, tmpSlot, true, false, false)
                end
            end

			-- Glass Specter node (T. Lost's tree)
			if PST:getTreeSnapshotMod("glassSpecter", false) then
				if PST:TLostHasAnyShield() then
					PST:addModifiers({ glassSpecterShieldClears = 1 }, true)
					local clearThreshold = 4
					if PST:getTreeSnapshotMod("deferredAegis", false) then
						clearThreshold = 8
					end
					if PST:getTreeSnapshotMod("glassSpecterShieldClears", 0) >= clearThreshold then
						PST:removePlayerShields()
						PST:addModifiers({ glassSpecterShieldClears = { value = 0, set = true } }, true)
					end
				end
			end

			-- Mod: % chance to gain a smelted Polished Bone for the rest of the floor when clearing a room without taking damage
			local tmpMod = PST:getTreeSnapshotMod("flawlessClearPBone", 0)
			if tmpMod > 0 and not PST:getTreeSnapshotMod("roomGotHitByMob", false) and not PST:getTreeSnapshotMod("flawlessPBoneProc", false) and
			100 * math.random() < tmpMod then
				player:AddSmeltedTrinket(TrinketType.TRINKET_POLISHED_BONE)
				PST:addModifiers({ flawlessPBoneProc = true }, true)
			end

			-- Red room clear
			if PST:inRedRoom() then
				-- Otherside Seeker node (T. Bethany's tree)
				if PST:getTreeSnapshotMod("othersideSeeker", false) and PST:getTreeSnapshotMod("othersideSeekerBuff", 0) < 10 then
					PST:addModifiers({ allstatsPerc = 1, othersideSeekerBuff = 1 }, true)
				end

				-- Mod: % chance to gain a smelted Blue Key when you clear a red room, if you don't already have one
				tmpMod = PST:getTreeSnapshotMod("blueKeyRedClear", 0)
				if tmpMod > 0 and not player:HasTrinket(TrinketType.TRINKET_BLUE_KEY) and 100 * math.random() < tmpMod then
					player:AddSmeltedTrinket(TrinketType.TRINKET_BLUE_KEY)
					PST:addModifiers({ blueKeyRedClearProc = true }, true)
				end
			end

			-- Reaper Wraiths node (T. Jacob's tree)
			if PST:getTreeSnapshotMod("reaperWraiths", false) and not PST:getTreeSnapshotMod("reaperWraithsSpawned", false) then
				local darkEsauQuery = Isaac.FindByType(EntityType.ENTITY_DARK_ESAU)
				if #darkEsauQuery == 0 then
					local tmpDarkEsau = Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, PST:getRoom():GetCenterPos(), Vector.Zero, player, 0, Random() + 1)
            		tmpDarkEsau:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
				elseif player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and #darkEsauQuery == 1 then
					local tmpDarkEsau = darkEsauQuery[1]
					if tmpDarkEsau.SubType == 0 then
						local tmpDarkEsauAlt = Game():Spawn(EntityType.ENTITY_DARK_ESAU, 0, tmpDarkEsau.Position + Vector(10, 0), Vector.Zero, PST:getPlayer(), 1, Random() + 1)
						tmpDarkEsauAlt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
					end
				end
				PST:addModifiers({ reaperWraithsSpawned = true }, true)
			end

			-- Mod: % chance to drop an additional throwable bomb when clearing a room
			tmpMod = PST:getTreeSnapshotMod("clearThrowableBomb", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_THROWABLEBOMB, 0, tmpPos, Vector.Zero, nil)
			end

			-- Cosmic Realignment node
			if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
				-- Tainted Samson, take up to 1 heart damage if final buff was negative, then reset
				local totalHP = player:GetHearts() + player:GetSoulHearts() + player:GetRottenHearts() + player:GetBrokenHearts() + player:GetBoneHearts()
				if cosmicRCache.TSamsonBuffer < 0 and totalHP - 1 > 0 then
					player:TakeDamage(math.min(2, totalHP - 1), 0, EntityRef(player), 0)
				end
				cosmicRCache.TSamsonBuffer = 0
				player:AddCacheFlags(PST.allstatsCache, true)
			elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
				-- Tainted Lazarus, switch health banks
				if not isKeeper and PST.modData.xpObtained > 0 then
					local newBank = nil
					if cosmicRCache.TLazarusBank1.active then
						newBank = cosmicRCache.TLazarusBank2
						cosmicRCache.TLazarusBank1.active = false
					else
						newBank = cosmicRCache.TLazarusBank1
						cosmicRCache.TLazarusBank1.active = true
					end
					player:AddMaxHearts(-player:GetMaxHearts() + newBank.max)
					player:AddSoulHearts(-player:GetSoulHearts() + newBank.soul)
					---@diagnostic disable-next-line: undefined-field
					player:SetBlackHeart(newBank.black)
					player:AddRottenHearts(-player:GetRottenHearts() + newBank.rotten)
					player:AddBoneHearts(-player:GetBoneHearts() + newBank.bone)
					player:AddBrokenHearts(-player:GetBrokenHearts() + newBank.broken)
					player:AddHearts(-player:GetHearts() + newBank.red)
					player:AddEternalHearts(-player:GetEternalHearts() + newBank.eternal)
				end
			end

			-- Expedition curse: punishment
			tmpMod = PST:getTreeSnapshotMod("cursePunishment", 0)
			if tmpMod > 0 and PST:getTreeSnapshotMod("roomKills", 0) > 0 then
				PST:addModifiers({ cursePunishmentCount = 1 }, true)
				if PST:getTreeSnapshotMod("cursePunishmentCount", 0) >= tmpMod then
					player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL, EntityRef(player), 0)
					PST:addModifiers({ cursePunishmentCount = { value = 0, set = true } }, true)
				end
			end

			-- Ancient weapon mod: Gilded Seeker
			tmpMod = PST:getTreeSnapshotMod("ancwep_gildedSeekerBuff", 0)
			if tmpMod > 0 then
				PST:addModifiers({ damagePerc = -tmpMod / 2, ancwep_gildedSeekerBuff = -tmpMod / 2 }, true)
			end

			-- Consuming Void node (T. Isaac node)
			tmpMod = PST:getTreeSnapshotMod("consumingVoidBuff", 0)
            if tmpMod > 0 then
                PST:addModifiers({ consumingVoidBuff = -tmpMod / 2 }, true)
                PST:updateCacheDelayed(PST.allstatsCache)
            end
		end

		-- Starcursed modifier: static hovering tears when killing mobs (unfreeze)
		if #PST.specialNodes.SC_hoveringTears > 0 then
			for _, tmpTear in ipairs(PST.specialNodes.SC_hoveringTears) do
				if tmpTear then
					tmpTear:SetPauseTime(0)
				end
			end
		end

		-- Ancient starcursed jewel: Crystallized Anamnesis
		if PST.specialNodes.SC_anamnesisResetTimer > 0 then
			PST.specialNodes.SC_anamnesisResetTimer = 1
		end

		-- Cosmic Realignment node
		if PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN) then
			-- The Forgotten, reset Keeper debuff
			if isKeeper then
				local debuffVal = math.max(-40, math.min(0, player:GetNumBlueFlies() * -4))
				if cosmicRCache.forgottenKeeperDebuff ~= debuffVal then
					cosmicRCache.forgottenKeeperDebuff = debuffVal
					player:AddCacheFlags(PST.allstatsCache, true)
				end
			end
		end

		-- Convert temp xp to normal xp
		if PST.modData.xpObtained > 0 then
			PST:addXP(PST.modData.xpObtained, false)

			PST.modData.xpObtained = 0
		end

		-- Expedition objective: clear rooms with at least 5 monsters
		if PST:getTreeSnapshotMod("roomKills", 0) >= 5 then
			PST:expedAddProgInRun("rooms", 1)
		end

		-- Reset room kills
		PST:addModifiers({ roomKills = { value = 0, set = true } }, true)

		clearRoomProc = true
	elseif room:GetAliveEnemiesCount() > 0 then
		clearRoomProc = false
	end
end