-- On item use
---@param itemType CollectibleType
---@param RNG RNG
---@param player EntityPlayer
---@param useFlags UseFlag
---@param slot ActiveSlot
---@param customVarData any
function PST:onUseItem(itemType, RNG, player, useFlags, slot, customVarData)
    -- Mod: % chance to remove Birthright when using any active item (Serendipitous Soul - T. Eden's tree)
    if PST:getTreeSnapshotMod("serendipitousSoul", false) and itemType ~= CollectibleType.COLLECTIBLE_EDENS_SOUL then
        local tmpMod = PST:getTreeSnapshotMod("birthrightActiveRemoveChance", 0)
        if tmpMod > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 100 * math.random() < tmpMod then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        end
    end

    -- Mod: +% to a random stat when using an active item while having a holy mantle/wooden cross shield
    local tmpMod = PST:getTreeSnapshotMod("shieldActiveStat", 0)
    if tmpMod > 0 and not PST:getTreeSnapshotMod("shieldActiveStatProc", false) and PST:getRoom():GetAliveEnemiesCount() > 0 then
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) or player:GetEffects():HasTrinketEffect(TrinketType.TRINKET_WOODEN_CROSS) then
            local randomStat = PST:getRandomStat()
            local randomStatCache = PST:getTreeSnapshotMod("shieldActiveStatList", {})
            if not randomStatCache[randomStat .. "Perc"] then
                randomStatCache[randomStat .. "Perc"] = 0
            end
            randomStatCache[randomStat .. "Perc"] = randomStatCache[randomStat .. "Perc"] + tmpMod
            PST:addModifiers({ [randomStat .. "Perc"] = tmpMod, shieldActiveStatProc = true }, true)
        end
    end

    -- D6
    if itemType == CollectibleType.COLLECTIBLE_D6 then
        -- Magic Die node (Isaac's tree)
        if PST:getTreeSnapshotMod("magicDie", false) then
            local magicDieData = PST:getTreeSnapshotMod("magicDieData", nil)
            if magicDieData then
                local tmpRoomType = PST:getRoom():GetType()
                if tmpRoomType == RoomType.ROOM_BOSS and magicDieData.source ~= "none" then
                    -- Boss room with existing buff, augment it by 3
                    magicDieData.value = magicDieData.value + 3
                else
                    if tmpRoomType == RoomType.ROOM_ANGEL then
                        -- Angel room buff
                        magicDieData.source = "angel"
                        magicDieData.value = 7
                    elseif tmpRoomType == RoomType.ROOM_DEVIL then
                        -- Devil room buff
                        magicDieData.source = "devil"
                        magicDieData.value = 6
                    elseif tmpRoomType == RoomType.ROOM_TREASURE or tmpRoomType == RoomType.ROOM_SHOP then
                        -- Treasure/Shop room buff
                        magicDieData.source = "treasure"
                        magicDieData.value = 7
                    elseif tmpRoomType == RoomType.ROOM_BOSS then
                        -- Boss room buff
                        magicDieData.source = "boss"
                        magicDieData.value = 3
                    else
                        -- Any other room buff
                        magicDieData.source = "boss"
                        magicDieData.value = 2
                    end
                end
                PST:save()
                player:AddCacheFlags(PST.allstatsCache, true)
            end
        end

        -- Mod: chance to spawn pickup when using D6
        if 100 * math.random() < PST:getTreeSnapshotMod("d6Pickup", 0) then
            local pickupType = { PickupVariant.PICKUP_COIN, PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB, PickupVariant.PICKUP_HEART }
            local randPickup = pickupType[math.random(#pickupType)]
            local tmpSubtype = 1
            if randPickup == PickupVariant.PICKUP_HEART then
                if 100 * math.random() < 70 then
                    tmpSubtype = HeartSubType.HEART_HALF
                elseif 100 * math.random() < 10 then
                    if 100 * math.random() < 70 then
                        tmpSubtype = HeartSubType.HEART_HALF_SOUL
                    else
                        tmpSubtype = HeartSubType.HEART_SOUL
                    end
                end
            end
            -- Very rarely spawn a chest/locked chest
            if 100 * math.random() < 5 then
                if 100 * math.random() < 90 then
                    randPickup = PickupVariant.PICKUP_CHEST
                else
                    randPickup = PickupVariant.PICKUP_LOCKEDCHEST
                end
            end
            Game():Spawn(EntityType.ENTITY_PICKUP, randPickup, player.Position, Vector.Zero, nil, tmpSubtype, Random() + 1)
        end

        -- Mod: chance to keep half the charge when using D6
        if 100 * math.random() < PST:getTreeSnapshotMod("d6HalfCharge", 0) then
            if player:GetBatteryCharge(slot) == 0 then
                player:AddActiveCharge(math.ceil(player:GetActiveMaxCharge(slot) / 2), slot, true, true, false)
            end
        end
    -- Yum Heart
    elseif itemType == CollectibleType.COLLECTIBLE_YUM_HEART then
        -- Crystal Heart node (Magdalene's tree)
        if PST:getTreeSnapshotMod("crystalHeart", false) then
            player:AddHearts(1)
            if player:GetMaxHearts() > 2 and 100 * math.random() < 7 then
                player:AddMaxHearts(-2)
                player:AddBoneHearts(1)
                player:AddHearts(2)
            end
        end

        -- Mod: chance for Yum Heart to heal an additional 1/2 red heart
        if 100 * math.random() < PST:getTreeSnapshotMod("yumHeartHealHalf", 0) then
            player:AddHearts(1)
        end
    -- Book of Belial
    elseif itemType == CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL then
        -- Dark Heart node (Judas' tree)
        if PST:getTreeSnapshotMod("darkHeart", false) and not PST:getTreeSnapshotMod("darkHeartBelial", false) then
            PST:addModifiers({ darkHeartBelial = true }, true)
        end
    -- The Poop
    elseif itemType == CollectibleType.COLLECTIBLE_POOP then
        -- Brown Blessing node (Blue Baby's tree)
        if PST:getTreeSnapshotMod("brownBlessing", false) and not PST:isFirstOrigStage() and 100 * math.random() < 7 then
            local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
            local tmpPoopItem = Game():GetItemPool():GetCollectibleFromList(PST.poopItems, Random() + 1, CollectibleType.COLLECTIBLE_BREAKFAST, true, false)
            if tmpPoopItem == CollectibleType.COLLECTIBLE_BREAKFAST and not PST:getTreeSnapshotMod("hallowedGroundProc", false) then
                tmpPoopItem = CollectibleType.COLLECTIBLE_HALLOWED_GROUND
                PST:addModifiers({ hallowedGroundProc = true }, true)
            end
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, tmpPoopItem, Random() + 1)
        end

        -- Mod: +all stats when using the poop (once per room)
        local poopAllStats = PST:getTreeSnapshotMod("thePoopAllStats", 0)
        local poopAllStatsPerc = PST:getTreeSnapshotMod("thePoopAllStatsPerc", 0)
        if (poopAllStats > 0 or poopAllStatsPerc > 0) and not PST:getTreeSnapshotMod("poopAllStatsProc") then
            PST:addModifiers({
                allstats = poopAllStats,
                allstatsPerc = poopAllStatsPerc,
                poopAllStatsProc = true
            }, true)
        end
    -- Eternal D6
    elseif itemType == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
        -- Mod: chance for Eternal D6 to not consume charges on use
        if 100 * math.random() < PST:getTreeSnapshotMod("eternalD6Charge", 0) then
            player:AddActiveCharge(player:GetActiveMaxCharge(slot), slot, true, true, false)
        end
    -- Box of Friends
    elseif itemType == CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS then
        -- Minion Maneuvering node (Lilith's tree)
        if PST:getTreeSnapshotMod("minionManeuvering", false) then
            PST.specialNodes.minionManeuveringMaxBonus = 30
            player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
        end

        -- Mod: chance for Box of Friends to keep 1 charge on use
        if 100 * math.random() < PST:getTreeSnapshotMod("boxOfFriendsCharge", 0) then
            if player:GetBatteryCharge(slot) == 0 then
                player:AddActiveCharge(1, slot, true, true, false)
            end
        end

        -- Mod: +all stats when using Box of Friends
        local tmpStats = PST:getTreeSnapshotMod("boxOfFriendsAllStats", 0)
        if tmpStats > 0 and not PST:getTreeSnapshotMod("boxOfFriendsAllStatsProc", 0) then
            PST:addModifiers({ allstats = tmpStats, boxOfFriendsAllStatsProc = true }, true)
        end
    -- Wooden Nickel
    elseif itemType == CollectibleType.COLLECTIBLE_WOODEN_NICKEL then
        -- Keeper's Blessing node (Keeper's tree)
        if PST:getTreeSnapshotMod("keeperBlessing", false) and 100 * math.random() < 20 then
            local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_PENNY, Random() + 1)
        end
    -- Void
    elseif itemType == CollectibleType.COLLECTIBLE_VOID then
        -- Apollyon's Blessing node (Apollyon's tree)
        if PST:getTreeSnapshotMod("apollyonBlessing", false) and 100 * math.random() < 40 then
            if player:GetBatteryCharge(slot) == 0 then
                player:AddActiveCharge(math.ceil(player:GetActiveMaxCharge(slot) / 2), slot, true, true, false)
            end
        end

        -- Harbinger Locusts node (Apollyon's tree)
        if PST:getTreeSnapshotMod("harbingerLocusts", false) then
            local consumedLocust = false
            for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_TRINKET then
                    if PST:arrHasValue(PST.locustTrinkets, tmpEntity.SubType &~ TrinketType.TRINKET_GOLDEN_FLAG) then
                        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, 0)
                        tmpEntity:Remove()
                        player:AddSmeltedTrinket(tmpEntity.SubType)
                        PST:addModifiers({ luck = PST:getTreeSnapshotMod("locustConsumedLuck", 0) }, true)
                        consumedLocust = true
                    end
                end
            end
            if consumedLocust then
                player:AddCacheFlags(PST.allstatsCache, true)
            end
        end

        -- Mod: chance for Void to spawn 4 blue flies on use
        if 100 * math.random() < PST:getTreeSnapshotMod("voidBlueFlies", 0) then
            for _=1,4 do
                Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, nil, 0, Random() + 1)
            end
        end

        -- Mod: chance for Void to spawn 3 blue spiders on use
        if 100 * math.random() < PST:getTreeSnapshotMod("voidBlueSpiders", 0) then
            for _=1,3 do
                Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, player.Position, Vector.Zero, nil, 0, Random() + 1)
            end
        end

        -- Mod: chance for Void to instantly kill a random non-boss enemy in the room
        if 100 * math.random() < PST:getTreeSnapshotMod("voidAnnihilation", 0) then
            local tmpEnemies = {}
            for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() and not tmpEntity:IsBoss() then
                    table.insert(tmpEnemies, tmpEntity)
                end
            end
            if #tmpEnemies > 0 then
                tmpEnemies[math.random(#tmpEnemies)]:Die()
            end
        end
    -- Siren's Song
    elseif itemType == Isaac.GetItemIdByName("Siren Song") then
        -- Dark Songstress node (Siren's tree)
        if PST:getTreeSnapshotMod("darkSongstress", false) and not PST:getTreeSnapshotMod("darkSongstressActive", false) then
            PST:addModifiers({ damagePerc = 8, speedPerc = 8, darkSongstressActive = true }, true)
        end

        -- Song of Fortune node (Siren's tree) [Harmonic modifier]
        if PST:getTreeSnapshotMod("songOfFortune", false) and PST:songNodesAllocated(true) <= 2 and 100 * math.random() < 15 then
            PST:addModifiers({ luck = 0.05 }, true)
        end

        -- Song of Awe node (Siren's tree)
        if PST:getTreeSnapshotMod("songOfAwe", false) then
            if not PST:getTreeSnapshotMod("songOfAweActive", false) then
                PST:addModifiers({ allstatsPerc = 4, songOfAweActive = true }, true)
            end

            -- Slow enemies [Harmonic modifier]
            if PST:songNodesAllocated(true) <= 2 then
                for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                    if tmpEntity:IsActiveEnemy() and tmpEntity:IsVulnerableEnemy() then
                        tmpEntity:AddSlowing(EntityRef(player), 60, 0.1, Color(0.8, 0.8, 0.8, 1, 0, 0))
                    end
                end
            end
        end

        -- Overwhelming Voice node (Siren's tree)
        if PST:getTreeSnapshotMod("overwhelmingVoice", false) then
            PST.specialNodes.overwhelmingVoiceProc = true
        end
    -- D12
    elseif itemType == CollectibleType.COLLECTIBLE_D12 then
        local staticEntCache = PST:getTreeSnapshotMod("staticEntitiesCache", {})
        for entID, _ in pairs(staticEntCache) do
            local level = PST:getLevel()
            local stage = level:GetStage()
            local roomID = level:GetCurrentRoomDesc().SafeGridIndex
            if PST:strStartsWith(entID, tostring(stage) .. "." .. tostring(roomID)) then
                staticEntCache[entID] = -1
            end
        end
    -- D7
    elseif itemType == CollectibleType.COLLECTIBLE_D7 then
        PST:addModifiers({ d7Proc = true }, true)
    -- Red Key
    elseif itemType == CollectibleType.COLLECTIBLE_RED_KEY then
        local room = PST:getRoom()
        -- Mod: chance to turn adjacent curse room spiked door into a regular one
        if PST:getTreeSnapshotMod("curseRoomSpikesOutProc", false) then
            for i=0,7 do
                local tmpDoor = room:GetDoor(i)
                if tmpDoor then
                    if room:GetType() == RoomType.ROOM_CURSE then
                        tmpDoor:SetRoomTypes(RoomType.ROOM_DEFAULT, tmpDoor.TargetRoomType)
                    elseif tmpDoor.TargetRoomType == RoomType.ROOM_CURSE then
                        tmpDoor:SetRoomTypes(room:GetType(), RoomType.ROOM_DEFAULT)
                    end
                end
            end
        end
    -- Anarchist's Cookbook
    elseif itemType == CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK then
        PST.specialNodes.trollBombDisarmDebuffTimer = 45
    -- Bag of Crafting
    elseif itemType == CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING then
        PST.specialNodes.craftBagSnapshot = player:GetBagOfCraftingContent()
    -- Dark Arts
    elseif itemType == CollectibleType.COLLECTIBLE_DARK_ARTS then
        -- Dark Expertise node (T. Judas' tree)
        if PST:getTreeSnapshotMod("darkExpertise", false) then
            Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
        end

        -- Anarchy node (T. Judas' tree)
        if PST:getTreeSnapshotMod("anarchy", false) then
            PST.specialNodes.trollBombDisarmDebuffTimer = 45
        end

        -- Mod: +% tears for 2 seconds after using Dark Arts
        tmpMod = PST:getTreeSnapshotMod("darkArtsTears", 0)
        if tmpMod > 0 and PST.specialNodes.darkArtsTearsTimer == 0 then
            PST.specialNodes.darkArtsTearsTimer = 75
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        end

        PST.specialNodes.darkArtsBossHitProc = false
    -- How to Jump
    elseif itemType == CollectibleType.COLLECTIBLE_HOW_TO_JUMP then
        -- Mod: dark pulse when landing with How to Jump
        tmpMod = PST:getTreeSnapshotMod("howToJumpPulse", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            PST.specialNodes.howToJumpPulseTimer = 15
        end
    -- Hold
    elseif itemType == CollectibleType.COLLECTIBLE_HOLD then
        local poopHeld = player:GetActiveItemDesc(slot).VarData
        local poopRegainProc = false

        -- Mod: chance to regain the held poop on use
        local tmpMod = PST:getTreeSnapshotMod("holdPoopRegain", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod and PST.specialNodes.poopHeld > 0 then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_HOLD)
            player:AddCollectible(CollectibleType.COLLECTIBLE_HOLD, 0, false, slot, PST.specialNodes.poopHeld)
            SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE)
            poopRegainProc = true
        end

        -- Emptying Hold i.e. triggering poop usage
        if poopHeld == 0 then
            -- Mod: chance to trigger Brown Nugget's effect when using Hold
            tmpMod = PST:getTreeMod("holdBrownNugget", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("holdBrownNuggetProcs", 0) < 5 and 100 * math.random() < tmpMod then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_BROWN_NUGGET, UseFlag.USE_NOANIM)
                PST:addModifiers({ holdBrownNuggetProcs = 1 }, true)
            end
        end

        if not poopRegainProc then
            PST.specialNodes.poopHeld = poopHeld

            -- Cache-updating hold nodes
            if PST:getTreeSnapshotMod("treasuredWaste", false) or PST:getTreeSnapshotMod("holdEmptySpeed", 0) > 0 or PST:getTreeSnapshotMod("holdFullLuck", 0) > 0 then
                PST:updateCacheDelayed()
            end
        end
    -- Sumptorium
    elseif itemType == CollectibleType.COLLECTIBLE_SUMPTORIUM then
        -- Mod: +% damage per absorbed red clot for the current room
        local tmpMod = PST:getTreeSnapshotMod("redClotAbsorbDmg", 0)
        if tmpMod > 0 then
            local redClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0)
            if #redClots > 0 then
                local totalBuff = tmpMod * #redClots
                PST:addModifiers({ damagePerc = totalBuff, redClotAbsorbBuff = totalBuff }, true)
            end
        end

        -- Mod: +% tears per absorbed soul clot for the current room
        tmpMod = PST:getTreeSnapshotMod("soulClotAbsorbTears", 0)
        if tmpMod > 0 then
            local soulClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 1)
            if #soulClots > 0 then
                local totalBuff = tmpMod * #soulClots
                PST:addModifiers({ tearsPerc = totalBuff, soulClotAbsorbBuff = totalBuff }, true)
            end
        end
    -- Suplex!
    elseif itemType == CollectibleType.COLLECTIBLE_SUPLEX then
        if not PST:getTreeSnapshotMod("absoluteRage", false) and PST:isBerserk() then
            local berserkEffect = player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		    if berserkEffect and berserkEffect.Cooldown <= 60 then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_SUPLEX)
                PST:addModifiers({ violentMarauderRemoved = true }, true)
            end
        end
    -- Flip
    elseif itemType == CollectibleType.COLLECTIBLE_FLIP then
        -- Manual usage
        local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_FLIP)
        if tmpSlot ~= -1 and (useFlags & UseFlag.USE_OWNED) > 0 then
            -- Great Overlap node (T. Lazarus' tree)
            if PST:getTreeSnapshotMod("greatOverlap", false) then
                if 100 * math.random() < 30 then
                    player:AddActiveCharge(2, tmpSlot, true, false, false)
                elseif 100 * math.random() < 50 then
                    player:AddActiveCharge(1, tmpSlot, true, false, false)
                end
            end

            -- Mod: -% to all room monsters' HP when using Flip, up to 4 times per room
            local tmpMod = PST:getTreeSnapshotMod("flipMobHPDown", 0)
            local tmpProcs = PST:getTreeSnapshotMod("flipMobHPDownProcs", 0)
            if tmpMod > 0 and tmpProcs < 4 then
                local foundMob = false
                for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                    local tmpNPC = tmpEntity:ToNPC()
                    if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and tmpNPC.Type ~= EntityType.ENTITY_GIDEON and
                    not EntityRef(tmpNPC).IsFriendly then
                        tmpNPC.HitPoints = math.max(1, tmpNPC.HitPoints - tmpNPC.MaxHitPoints * (tmpMod / 100))
                        foundMob = true
                    end
                end
                if foundMob then
                    PST:addModifiers({ flipMobHPDownProcs = 1 }, true)
                end
            end
        end
    -- Eden's Soul
    elseif itemType == CollectibleType.COLLECTIBLE_EDENS_SOUL then
        -- Serendipitous Soul node (T. Eden's tree)
        if PST:getTreeSnapshotMod("serendipitousSoul", false) and not PST:getTreeSnapshotMod("serendSoulUsed", false) then
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            end
            PST:addModifiers({ serendSoulUsed = true }, true)
        end
    -- Spindown dice
    elseif itemType == CollectibleType.COLLECTIBLE_SPINDOWN_DICE then
        -- Spindown node (T. Lost's tree)
        if PST:getTreeSnapshotMod("spindown", false) then
            PST:addModifiers({ spindownUses = 1 }, true)
            if PST:getTreeSnapshotMod("spindownUses", 0) >= 2 then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_SPINDOWN_DICE)
            end

            if PST:getTreeSnapshotMod("spindownDebuff", 0) < 0.35 then
                for _, tmpEntity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
                    if tmpEntity.SubType ~= 0 then
                        local tmpDebuff = PST:getTreeSnapshotMod("spindownDebuff", 0)
                        if tmpDebuff < 0.35 then
                            local tmpAdd = math.min(0.05, 0.35 - tmpDebuff)
                            PST:addModifiers({ speed = -tmpAdd * 2, spindownDebuff = tmpAdd }, true)
                        else break end
                    end
                end
            end
        end
    -- Coupon
    elseif itemType == CollectibleType.COLLECTIBLE_COUPON then
        -- Strange Coupon node (T. Keeper's tree)
        if PST:getTreeSnapshotMod("strangeCoupon", false) then
            PST:addModifiers({ strangeCouponUses = 1 }, true)
            if PST:getTreeSnapshotMod("strangeCouponUses", 0) == 4 then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_COUPON)
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
                    player:AddCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
                    PST:createFloatTextFX("Coupon -> Steam Sale", Vector.Zero, Color(1, 1, 1, 1), 0.12, 90, true)
                end
            end
        end
    -- Recall
    elseif itemType == CollectibleType.COLLECTIBLE_RECALL then
        -- Recall! node (T. Forgotten's tree)
        if PST:getTreeSnapshotMod("forgRecall", false) and PST:getTreeSnapshotMod("forgRecallUses", 0) < 10 then
            PST:addModifiers({ forgRecallUses = 1 }, true)
        end

        -- Mod: +% damage for 2 seconds after using Recall
        tmpMod = PST:getTreeSnapshotMod("recallDmg", 0)
        if tmpMod > 0 then
            if PST.specialNodes.recallDamageTimer == 0 then
                PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
            end
            PST.specialNodes.recallDamageTimer = 60
        end
    end

    -- Self-used items
    if (useFlags & UseFlag.USE_OWNED) > 0 then
        -- Mod: chance to spawn a regular wisp when using your active item
        if 100 * math.random() < PST:getTreeSnapshotMod("activeItemWisp", 0) then
            Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, player.Position, Vector.Zero, nil, 0, Random() + 1)
        end

        -- Chaos Take The World node (T. Eden's tree)
        if PST:getTreeSnapshotMod("chaosTakeTheWorld", false) then
            local itemCfg = Isaac.GetItemConfig():GetCollectible(itemType)
            if itemCfg and itemCfg.MaxCharges >= 2 then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS, UseFlag.USE_NOANIM)
            end
        end

        -- Mod: % chance for wisps to fire a small homing tear towards you when you use an active item
        tmpMod = PST:getTreeSnapshotMod("wispActiveTears", 0)
        if tmpMod > 0 then
            local tmpWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP)
            for _, tmpWisp in ipairs(tmpWisps) do
                if 100 * math.random() < tmpMod then
                    local tmpVel = (player.Position - tmpWisp.Position):Normalized() * 7
                    local newTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, tmpWisp.Position, tmpVel, tmpWisp, 0, Random() + 1)
                    newTear:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING)
                    newTear:ToTear().Height = player.TearHeight
                    newTear:ToTear().FallingSpeed = -player.TearFallingSpeed * 2
                    newTear.SpriteScale = Vector(0.8, 0.8)
                    newTear.CollisionDamage = player.Damage * 0.3 + 2 * player:GetActiveMinUsableCharge(slot)
                    newTear.Color = PST:RGBColor(120, 30, 182)
                end
            end
        end
    end

    -- Cosmic Realignment tainted unlock on red key home
    if itemType == CollectibleType.COLLECTIBLE_RED_KEY and PST:getLevel():GetStage() == LevelStage.STAGE8 then
        local cosmicRChar = PST:getTreeSnapshotMod("cosmicRealignment", false)
        if type(cosmicRChar) == "number" and player:GetPlayerType() ~= cosmicRChar then
            local taintedUnlock = PST.cosmicRData.characters[cosmicRChar].unlocks.tainted
            if taintedUnlock ~= nil then
                PST:cosmicRTryUnlock("tainted")
            end
        end
    end
end