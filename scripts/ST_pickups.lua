-- Check for the grabBag tree mod, and roll to spawn one on the player
function PST:tryGrabBag()
    local player = PST:getPlayer()
    local grabBagChance = PST:getTreeSnapshotMod("grabBag", 0)
    if grabBagChance > 0 and 100 * math.random() < grabBagChance then
        Game():Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_GRAB_BAG,
            player.Position,
            Vector.Zero,
            nil,
            SackSubType.SACK_NORMAL,
            PST:getRoom():GetSpawnSeed()
        )
    end
end

function PST:isPickupChest(variant)
    return variant == PickupVariant.PICKUP_CHEST or variant == PickupVariant.PICKUP_REDCHEST or
    variant == PickupVariant.PICKUP_LOCKEDCHEST or variant == PickupVariant.PICKUP_SPIKEDCHEST or
    variant == PickupVariant.PICKUP_WOODENCHEST or variant == PickupVariant.PICKUP_BOMBCHEST
end

function PST:vanishPickup(pickup)
    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, pickup.Position, Vector.Zero, nil, 1, 0)
    pickup:Remove()
end

local jewelCollisionTimer = 0
function PST:prePickup(pickup, collider, low)
    local player = collider:ToPlayer()
    local variant = pickup.Variant
    local subtype = pickup.SubType

    if player ~= nil then
        -- Collectibles
        if variant == PickupVariant.PICKUP_COLLECTIBLE then
            local removeOtherRoomItems = false
            -- Ancient starcursed jewel: Opalescent Purity
            if player ~= nil and PST:SC_getSnapshotMod("opalescentPurity", false) and not PST:getTreeSnapshotMod("SC_opalescentProc", false) and
            not pickup:IsShopItem() then
                if variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, subtype) then
                    removeOtherRoomItems = true
                    PST:addModifiers({ SC_opalescentProc = true }, true)
                end
            end

            -- Impromptu Gambler node (Cain's tree)
            if PST:getTreeSnapshotMod("impromptuGambler", false) and PST:getRoom():GetType() == RoomType.ROOM_TREASURE then
                -- Remove crane games
                for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                    if tmpEntity.Type == EntityType.ENTITY_SLOT and tmpEntity.Variant == SlotVariant.CRANE_GAME then
                        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, 0)
                        tmpEntity:Remove()
                    end
                end
            end

            -- Chaotic Treasury node (Eden's tree)
            if PST:getTreeSnapshotMod("chaoticTreasury", false) and not PST:arrHasValue(PST.progressionItems, subtype)
            and PST:getRoom():GetType() == RoomType.ROOM_TREASURE then
                -- When grabbing an item in a treasure room, remove all other items
                removeOtherRoomItems = true
            end

            if removeOtherRoomItems then
                table.insert(PST.specialNodes.itemRemovalProtected, pickup.InitSeed)
                PST:removeRoomItems(true)
            end
        else
            -- Keeper's Blessing node (Keeper's tree)
            if PST:getTreeSnapshotMod("keeperBlessing", false) then
                if variant == PickupVariant.PICKUP_COIN and player:GetHearts() < player:GetMaxHearts() and PST:getTreeSnapshotMod("keeperBlessingHeals") < 4 then
                    player:AddCoins(1)
                    PST:addModifiers({ keeperBlessingHeals = 1 }, true)
                end
            end

            -- Starcursed jewel pickups
            if variant == PickupVariant.PICKUP_TRINKET then
                local jewelInvFull = nil
                local isMighty = 100 * math.random() < PST:getTreeSnapshotMod("SC_SMMightyChance", 0)
                if subtype == Isaac.GetTrinketIdByName("Azure Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Azure Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    if not PST:SC_isInvFull(PSTStarcursedType.AZURE) then
                        -- Azure Starcursed Jewel pickup
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                        pickup:Remove()
                        PST:SC_addJewel(PSTStarcursedType.AZURE, isMighty, 0)
                        PST:createFloatTextFX("+ Azure Starcursed Jewel", Vector.Zero, Color(0.7, 0.7, 1, 1), 0.12, 90, true)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        jewelCollisionTimer = 0
                        return { Collide = false, SkipCollisionEffects = true }
                    else
                        jewelInvFull = PSTStarcursedType.AZURE
                    end
                elseif subtype == Isaac.GetTrinketIdByName("Crimson Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Crimson Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    if not PST:SC_isInvFull(PSTStarcursedType.CRIMSON) then
                        -- Crimson Starcursed Jewel pickup
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                        pickup:Remove()
                        PST:SC_addJewel(PSTStarcursedType.CRIMSON, isMighty, 0)
                        PST:createFloatTextFX("+ Crimson Starcursed Jewel", Vector.Zero, Color(1, 0.7, 0.7, 1), 0.12, 90, true)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        jewelCollisionTimer = 0
                        return { Collide = false, SkipCollisionEffects = true }
                    else
                        jewelInvFull = PSTStarcursedType.CRIMSON
                    end
                elseif subtype == Isaac.GetTrinketIdByName("Viridian Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Viridian Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    if not PST:SC_isInvFull(PSTStarcursedType.VIRIDIAN) then
                        -- Viridian Starcursed Jewel pickup
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                        pickup:Remove()
                        PST:SC_addJewel(PSTStarcursedType.VIRIDIAN, isMighty, 0)
                        PST:createFloatTextFX("+ Viridian Starcursed Jewel", Vector.Zero, Color(0.7, 1, 0.7, 1), 0.12, 90, true)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        jewelCollisionTimer = 0
                        return { Collide = false, SkipCollisionEffects = true }
                    else
                        jewelInvFull = PSTStarcursedType.VIRIDIAN
                    end
                elseif subtype == Isaac.GetTrinketIdByName("Ancient Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Ancient Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    -- Ancient Starcursed Jewel pickup
                    local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                    tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                    pickup:Remove()
                    PST:SC_addJewel(PSTStarcursedType.ANCIENT, false, 0)
                    PST:createFloatTextFX("+ Ancient Starcursed Jewel", Vector.Zero, Color(1, 0.65, 0.1, 1), 0.12, 120, true)
                    SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.4 + 0.1 * math.random())
                    jewelCollisionTimer = 0
                    return { Collide = false, SkipCollisionEffects = true }
                end

                -- Jewel inventory full
                if jewelInvFull ~= nil then
                    if jewelCollisionTimer == 0 then
                        PST:createFloatTextFX(jewelInvFull .. " Inventory Full!", Vector.Zero, Color(0.9, 0.2, 0.2, 1), 0.12, 90, true)
                        jewelCollisionTimer = 40
                    else
                        jewelCollisionTimer = jewelCollisionTimer - 1
                    end
                    return { Collide = false, SkipCollisionEffects = true }
                end
            end

            -- Ancient starcursed jewel: Crimson Warpstone
            if PST:SC_getSnapshotMod("crimsonWarpstone", false) then
                if pickup.Variant == PickupVariant.PICKUP_TAROTCARD and pickup.SubType == Card.CARD_CRACKED_KEY and not pickup:IsShopItem() and
                (player:GetCard(0) == Card.CARD_CRACKED_KEY or player:GetCard(1) == Card.CARD_CRACKED_KEY) then
                    local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                    tmpFX.Color = Color(1, 0.2, 0.2, 1, 1, 0.2, 0.2)
                    pickup:Remove()
                    PST:addModifiers({ SC_crimsonWarpKeyStacks = 1 }, true)
                    PST:createFloatTextFX("+ Cracked Key", Vector.Zero, Color(1, 0.7, 0.7, 1), 0.12, 100, true)
                    SFXManager():Play(SoundEffect.SOUND_UNLOCK00, 0.8, 2, false, 1.2)
                    return { Collide = false, SkipCollisionEffects = true }
                end
            end

            -- Starcursed mod: chance for coins, keys or bombs to vanish on pickup
            local tmpMod = PST:SC_getSnapshotMod("pickupsVanish", 0)
            if tmpMod > 0 and (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
            variant == PickupVariant.PICKUP_KEY) and 100 * math.random() < tmpMod then
                PST:vanishPickup(pickup)
                return false
            end
            -- Starcursed mod: chance for heart pickups to vanish when collected
            tmpMod = PST:SC_getSnapshotMod("heartsVanish", 0)
            if tmpMod > 0 and variant == PickupVariant.PICKUP_HEART and 100 * math.random() < tmpMod then
                PST:vanishPickup(pickup)
                return false
            end

            -- Cosmic Realignment node
            local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
            local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
            if PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY) then
                -- Blue baby, make first 2 non soul heart pickups vanish
                if cosmicRCache.blueBabyHearts < 2 then
                    if (variant == PickupVariant.PICKUP_HEART and subtype ~= HeartSubType.HEART_SOUL) or
                    variant == PickupVariant.PICKUP_BOMB or variant == PickupVariant.PICKUP_KEY or
                    variant == PickupVariant.PICKUP_COIN then
                        PST:vanishPickup(pickup)

                        cosmicRCache.blueBabyHearts = cosmicRCache.blueBabyHearts + 1
                        PST:save()
                        return false
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST) then
                -- The Lost, non-red hearts vanish on pickup
                if variant == PickupVariant.PICKUP_HEART and subtype ~= HeartSubType.HEART_FULL and
                subtype ~= HeartSubType.HEART_HALF then
                    PST:vanishPickup(pickup)
                    return false
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER) then
                -- Keeper, 25% chance for coins to vanish, 25% chance to deal 1/2 heart dmg on vanish
                if variant == PickupVariant.PICKUP_COIN then
                    if 100 * math.random() < 25 then
                        PST:vanishPickup(pickup)
                        if 100 * math.random() < 25 then
                            player:TakeDamage(1, 0, EntityRef(player), 0)
                        end
                        return false
                    else
                        -- Track collected coins for next floor
                        cosmicRCache.keeperFloorCoins = cosmicRCache.keeperFloorCoins + 1
                        if cosmicRCache.keeperFloorCoins <= 5 then
                            local tmpColor = Color(1, 1, 1, 1)
                            if cosmicRCache.keeperFloorCoins == 5 then
                                tmpColor = Color(0.7, 1, 0.7, 1)
                            end
                            PST:createFloatTextFX("Keeper's curse: " .. cosmicRCache.keeperFloorCoins .. "/5", Vector.Zero, tmpColor, 0.1, 50, true)
                        end
                        PST:save()
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
                -- Tainted Judas, as Keeper: coins have a 50% chance to grant +0.2 damage for the current room instead of healing, up to +1
                if isKeeper and variant == PickupVariant.PICKUP_COIN then
                    if player:GetHearts() < player:GetMaxHearts() and 100 * math.random() < 50 then
                        if cosmicRCache.TJudasDmgUps < 5 then
                            cosmicRCache.TJudasDmgUps = cosmicRCache.TJudasDmgUps + 1
                            PST:addModifiers({ damage = 0.2 }, true)
                            PST:save()
                        end
                        player:AddHearts(-2)
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
                -- Tainted Lazarus, as Keeper: 33% chance for coins to spawn a blue fly instead of healing you
                if isKeeper and variant == PickupVariant.PICKUP_COIN then
                    if player:GetHearts() < player:GetMaxHearts() then
                        if 100 * math.random() < 33 then
                            Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, nil, 0, Random() + 1)
                            player:AddHearts(-2)
                        elseif player:GetNumBlueFlies() > 0 then
                            player:AddHearts(-2)
                        end
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, as Keeper: coins will only heal you up to 3 times per floor
                if isKeeper and variant == PickupVariant.PICKUP_COIN and player:GetHearts() < player:GetMaxHearts() then
                    if cosmicRCache.TLostKeeperCoins < 3 then
                        cosmicRCache.TLostKeeperCoins = cosmicRCache.TLostKeeperCoins + 1
                        PST:save()
                    else
                        player:AddHearts(-2)
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
                -- Tainted Forgotten, as Keeper: first coin per room doesn't heal you
                if isKeeper and variant == PickupVariant.PICKUP_COIN then
                    if not cosmicRCache.TForgottenTracker.keeperCoin then
                        cosmicRCache.TForgottenTracker.keeperCoin = true
                        player:AddCacheFlags(PST.allstatsCache, true)
                    end
                    if player:GetHearts() < player:GetMaxHearts() and not cosmicRCache.TForgottenTracker.keeperHeal then
                        player:AddHearts(-2)
                        cosmicRCache.TForgottenTracker.keeperHeal = true
                    end
                end
            end
        end
    end
end

function PST:onPickup(pickup, collider, low)
    local player = collider:ToPlayer()
    local variant = pickup.Variant
    local subtype = pickup.SubType

    if pickup:GetSprite():GetAnimation() ~= "Collect" then return end

    if player ~= nil and not pickup:IsShopItem() then
        if variant == PickupVariant.PICKUP_COIN then
            local coinChance = PST:getTreeSnapshotMod("coinDupe", 0)
            if coinChance > 0 and 100 * math.random() < coinChance then
                player:AddCoins(1)
            end
            PST:tryGrabBag()
        elseif variant == PickupVariant.PICKUP_KEY then
            local keyChance = PST:getTreeSnapshotMod("keyDupe", 0)
            if keyChance > 0 and 100 * math.random() < keyChance then
                player:AddKeys(1)
            end
            PST:tryGrabBag()
        elseif variant == PickupVariant.PICKUP_BOMB then
            local bombChance = PST:getTreeSnapshotMod("bombDupe", 0)
            if bombChance > 0 and 100 * math.random() < bombChance then
                player:AddBombs(1)
            end
            PST:tryGrabBag()
        elseif variant == PickupVariant.PICKUP_HEART then
            if subtype == HeartSubType.HEART_BLACK then
                -- Sacrifice Darkness node (Judas' tree)
                if PST:getTreeSnapshotMod("sacrificeDarkness", false) then
                    player:TakeDamage(2, 0, EntityRef(player), 0)
                    player:ResetDamageCooldown()
                    player:AddSoulHearts(2)
                    if PST:getTreeSnapshotMod("blackHeartSacrifices", 0) < 6 then
                        PST:addModifiers({ blackHeartSacrifices = 1 }, true)
                    end
                end

                -- Heartseeker Phantasm node (The Lost's tree)
                if PST:getTreeSnapshotMod("heartseekerPhantasm", false) then
                    -- +0.2 luck when collecting soul or black hearts. +1% all stats for every 3 hearts collected
                    PST:addModifiers({ luck = 0.2, heartseekerPhantasmCollected = 1 }, true)
                    if PST:getTreeSnapshotMod("heartseekerPhantasmCollected", 0) % 3 == 0 then
                        PST:addModifiers({ allstatsPerc = 1 }, true)
                    end
                end

                -- Mod: Black hearts grant +damage when collected, up to a total +3
                tmpBonus = PST:getTreeSnapshotMod("blackHeartDamage", 0)
                if tmpBonus ~= 0 and PST:getTreeSnapshotMod("blackHeartDamageTotal", 0) < 3 then
                    PST:addModifiers({ damage = tmpBonus, blackHeartDamageTotal = tmpBonus }, true)
                end
            elseif subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_HALF_SOUL then
                -- Mod: +% tears and range when picking up a soul heart. Resets every floor
                local tmpBonus = PST:getTreeSnapshotMod("soulHeartTearsRange", 0)
                if tmpBonus > 0 and PST:getTreeSnapshotMod("soulHeartTearsRangeTotal", 0) < 10 then
                    PST:addModifiers({
                        tearsPerc = tmpBonus,
                        rangePerc = tmpBonus,
                        soulHeartTearsRangeTotal = tmpBonus
                    }, true)
                end

                -- Heartseeker Phantasm node (The Lost's tree)
                if PST:getTreeSnapshotMod("heartseekerPhantasm", false) then
                    -- +0.2 luck when collecting soul or black hearts. +1% all stats for every 3 hearts collected
                    PST:addModifiers({ luck = 0.2, heartseekerPhantasmCollected = 1 }, true)
                    if PST:getTreeSnapshotMod("heartseekerPhantasmCollected", 0) % 3 == 0 then
                        PST:addModifiers({ allstatsPerc = 1 }, true)
                    end
                end

                -- Mod: Soul hearts grant +tears when collected, up to a total +1
                tmpBonus = PST:getTreeSnapshotMod("soulHeartTears", 0)
                if tmpBonus ~= 0 and PST:getTreeSnapshotMod("soulHeartTearsTotal", 0) < 1 then
                    PST:addModifiers({ tears = tmpBonus, soulHeartTearsTotal = tmpBonus }, true)
                end

                -- Soul Trickle node (Bethany's tree)
                if PST:getTreeSnapshotMod("soulTrickle", false) then
                    player:AddHearts(1)
                end
            elseif subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF then
                -- Mod: chance to gain a soul charge when picking up a red heart
                if 100 * math.random() < PST:getTreeSnapshotMod("redHeartsSoulCharge", 0) then
                    SFXManager():Play(SoundEffect.SOUND_BEEP)
                    player:AddSoulCharge(1)
                end
            end

            -- Heartless node (Eve's tree)
            if PST:getTreeSnapshotMod("heartless", false) then
                local heartlessTotal = PST:getTreeSnapshotMod("heartlessTotal", 0)
                if heartlessTotal > 0 then
                    PST:addModifiers({ allstatsPerc = -heartlessTotal / 2, heartlessTotal = -heartlessTotal / 2 }, true)
                end
            end

            -- The Forgotten mod updates
            if PST:getTreeSnapshotMod("forgottenSoulDamage", 0) ~= 0 or PST:getTreeSnapshotMod("forgottenSoulTears", 0) ~= 0 or
            PST:getTreeSnapshotMod("theSoulBoneDamage", 0) ~= 0 or PST:getTreeSnapshotMod("theSoulBoneTears", 0) ~= 0 then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY) then
            -- Bethany, halve soul and black heart pickups, and give -0.02 luck
            if variant == PickupVariant.PICKUP_HEART then
                if subtype == HeartSubType.HEART_BLACK then
                    player:AddBlackHearts(-1)
                    PST:addModifiers({ luck = -0.02 }, true)
                elseif subtype == HeartSubType.HEART_SOUL then
                    player:AddSoulHearts(-1)
                    PST:addModifiers({ luck = -0.02 }, true)
                end
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
            -- Tainted Judas, take 1 heart of damage when picking up a black heart
            if variant == PickupVariant.PICKUP_HEART and subtype == HeartSubType.HEART_BLACK then
                player:TakeDamage(2, 0, EntityRef(player), 0)
                local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
                if cosmicRCache.TJudasDmgUps < 3 then
                    cosmicRCache.TJudasDmgUps = cosmicRCache.TJudasDmgUps + 1
                    PST:addModifiers({ damage = 0.4 }, true)
                    PST:save()
                end
            end
        end
    end
end

function PST:onPickupInit(pickup)
    local room = PST:getRoom()
    local firstSpawn = room:GetFrameCount() >= 0 or room:IsFirstVisit()
    local isShop = room:GetType() == RoomType.ROOM_SHOP
    local variant = pickup.Variant
    local subtype = pickup.SubType

    local pickupGone = false
    -- Ancient starcursed jewel: Opalescent Purity
    if PST:SC_getSnapshotMod("opalescentPurity", false) and PST:getTreeSnapshotMod("SC_opalescentProc", false) and
    variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, subtype) then
        pickup:Remove()
        pickupGone = true
    end

    -- Ancient starcursed jewel: Baubleseeker
    if not pickupGone and PST:SC_getSnapshotMod("baubleseeker", false) and variant == PickupVariant.PICKUP_COLLECTIBLE and
    subtype ~= CollectibleType.COLLECTIBLE_MOMS_BOX and not PST:arrHasValue(PST.progressionItems, subtype) then
        local tmpTrinket = Game():GetItemPool():GetTrinket()
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpTrinket, true, true, true)
        if room:GetType() == RoomType.ROOM_CHALLENGE then
            local tmpPos = room:FindFreePickupSpawnPosition(pickup.Position, 20)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, tmpPos, Vector.Zero, nil, 0, Random() + 1)
        end
    end

    -- Ancient starcursed jewel: Crimson Warpstone
    if not pickupGone and PST:SC_getSnapshotMod("crimsonWarpstone", false) and variant == PickupVariant.PICKUP_COLLECTIBLE and
    not PST:arrHasValue(PST.progressionItems, subtype) then
        if room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_ANGEL then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, true, true, true)
        end
    end

    -- Ancient starcursed jewel: Twisted Emperor's Heirloom
    if not pickupGone and PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) and room:GetType() == RoomType.ROOM_BOSS and
    variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, subtype) then
        local heirloomRoom = PST:getTreeSnapshotMod("SC_empHeirloomRoomID", -1)
        if heirloomRoom ~= -1 and heirloomRoom == PST:getLevel():GetCurrentRoomDesc().SafeGridIndex then
            if PST:getLevel():GetStage() < 7 and not PST:getLevel():IsAscent() then
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, false, false, true)
            else
                pickup:Remove()
            end
            pickupGone = true
        end
    end

    -- Trinkets
    if variant == PickupVariant.PICKUP_TRINKET then
        -- Fickle Fortune node (Cain's tree), vanish proc
        if PST:getTreeSnapshotMod("fickleFortune", false) and PST.specialNodes.fickleFortuneVanish then
            PST:vanishPickup(pickup)
            PST.specialNodes.fickleFortuneVanish = false
            pickupGone = true
        end

        -- Harbinger Locusts node (Apollyon's tree)
        if PST:getTreeSnapshotMod("harbingerLocusts", false) then
            -- Chance to replace dropped trinkets with a random locust
            if firstSpawn and 100 * math.random() < PST:getTreeSnapshotMod("harbingerLocustsReplace", 0) and not isShop then
                pickup:Remove()
                local tmpLocust = PST.locustTrinkets[math.random(#PST.locustTrinkets)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, pickup.Position, pickup.Velocity, nil, tmpLocust, Random() + 1)
                pickupGone = true
            end
        end

        -- Mod: chance for trinkets to drop as golden, if you have them unlocked
        if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) then
            if firstSpawn and not pickupGone and 100 * math.random() < PST:getTreeSnapshotMod("goldenTrinkets", 0) and not isShop and
            (subtype & TrinketType.TRINKET_GOLDEN_FLAG) == 0 then
                pickup:Remove()
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, pickup.Position, pickup.Velocity, nil, subtype | TrinketType.TRINKET_GOLDEN_FLAG, Random() + 1)
                pickupGone = true
            end
        end
    -- Pills
    elseif variant == PickupVariant.PICKUP_PILL then
        -- Blue Gambit node (Blue Baby's tree)
        if PST:getTreeSnapshotMod("blueGambit", false) and not PST:getTreeSnapshotMod("blueGambitPillProc", false) then
            local player = PST:getPlayer()
            ---@diagnostic disable-next-line: undefined-field
            local newColor = Game():GetItemPool():GetPillColor(PillEffect.PILLEFFECT_BALLS_OF_STEEL)
            PST:blueGambitPillSwap(subtype, Game():GetItemPool():GetPillEffect(subtype, player), newColor)
        end
    -- Cards
    elseif variant == PickupVariant.PICKUP_TAROTCARD then
        -- Blue Gambit node (Blue Baby's tree)
        if PST:getTreeSnapshotMod("blueGambit", false) and not PST:getTreeSnapshotMod("blueGambitCardProc", false) then
            PST:addModifiers({ blueGambitCardProc = true }, true)
            pickup:Remove()
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, pickup.Position, pickup.Velocity, nil, Card.CARD_HIEROPHANT, Random() + 1)
            pickupGone = true
        end
    else
        -- Starcursed mod: coin, key and bomb scarcity
        local tmpMod = PST:SC_getSnapshotMod("pickupScarcity", 0)
        if (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
        variant == PickupVariant.PICKUP_KEY) and 100 * math.random() < tmpMod then
            pickup:Remove()
            pickupGone = true
        end

        -- Hearts
        if variant == PickupVariant.PICKUP_HEART then
            -- Starcursed mod: heart scarcity
            tmpMod = PST:SC_getSnapshotMod("pickupScarcity", 0)
            if 100 * math.random() < tmpMod then
                pickup:Remove()
                pickupGone = true
            end

            -- Sacrifice Darkness node (Judas' tree)
            if not pickupGone and PST:getTreeSnapshotMod("sacrificeDarkness", false) then
                -- 35% chance to replace dropped soul hearts with black hearts
                if firstSpawn and not isShop and subtype == HeartSubType.HEART_SOUL and 100 * math.random() < 35 then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_BLACK, Random() + 1)
                    pickupGone = true
                end
            end

            -- Mod: chance to replace any heart drops with black hearts
            if firstSpawn and not isShop and not pickupGone and subtype ~= HeartSubType.HEART_BLACK and
            100 * math.random() < PST:getTreeSnapshotMod("heartsToBlack", 0) then
                pickup:Remove()
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_BLACK, Random() + 1)
                pickupGone = true
            end

            -- Heartseeker Phantasm node (The Lost's tree)
            if PST:getTreeSnapshotMod("heartseekerPhantasm", false) and not isShop and not pickupGone then
                -- Convert red and eternal hearts to soul hearts
                if subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_ETERNAL then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_SOUL, Random() + 1)
                    pickupGone = true
                end
            end

            -- Soul Trickle node (Bethany's tree)
            if firstSpawn and not pickupGone and PST:getTreeSnapshotMod("soulTrickle", false) and
            (subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF) then
                local player = PST:getPlayer()
                if player:GetHearts() == player:GetMaxHearts() and not isShop and 100 * math.random() < 30 then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_SOUL, Random() + 1)
                    pickupGone = true
                end
            end
        -- Coins
        elseif variant == PickupVariant.PICKUP_COIN then
            -- Mod: chance to replace pennies with lucky pennies
            if not pickupGone and firstSpawn and subtype == CoinSubType.COIN_PENNY and 100 * math.random() < PST:getTreeSnapshotMod("luckyPennyChance", 0) then
                pickup:Remove()
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, pickup.Position, pickup.Velocity, nil, CoinSubType.COIN_LUCKYPENNY, Random() + 1)
                pickupGone = true
            end
        -- Keys
        elseif variant == PickupVariant.PICKUP_KEY then
            -- Mod: chance to replace keys with golden keys, once per floor
            if not pickupGone and firstSpawn and subtype == KeySubType.KEY_NORMAL and 100 * math.random() < PST:getTreeSnapshotMod("goldenKeyConvert", 0) and
            not PST:getTreeSnapshotMod("goldenKeyConvertProc", false) then
                pickup:Remove()
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, pickup.Position, pickup.Velocity, nil, KeySubType.KEY_GOLDEN, Random() + 1)
                PST:addModifiers({ goldenKeyConvertProc = true }, true)
                pickupGone = true
            end
        end

        if not pickupGone then
            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
                -- Tainted Magdalene, 15% chance to turn coins, bombs, keys or chests into a half red heart
                if firstSpawn and not isShop and variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
                variant == PickupVariant.PICKUP_KEY or PST:isPickupChest(variant) then
                    if 100 * math.random() < 15 then
                        pickup:Remove()
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_HALF, Random() + 1)
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
                -- Tainted Judas, convert soul hearts to black hearts
                if variant == PickupVariant.PICKUP_HEART and not isShop then
                    if subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_HALF_SOUL then
                        pickup:Remove()
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_BLACK, Random() + 1)
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, remove eternal hearts
                if variant == PickupVariant.PICKUP_HEART and subtype == HeartSubType.HEART_ETERNAL then
                    pickup:Remove()
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
                -- Tainted Keeper, convert bombs, keys, hearts and chests to coins
                if not isShop and (variant == PickupVariant.PICKUP_HEART or variant == PickupVariant.PICKUP_KEY or
                variant == PickupVariant.PICKUP_BOMB or PST:isPickupChest(variant)) then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, pickup.Position, pickup.Velocity, nil, CoinSubType.COIN_PENNY, Random() + 1)
                end
            end
        end
    end
end

local baubleseekerProc = false
-- Update stats on trinket change
function PST:onTrinketAdd(player, type, firstTime)
    -- Demonic Souvenirs node (Azazel's tree)
    if PST:getTreeSnapshotMod("demonicSouvenirs", false) and PST:arrHasValue(PST.evilTrinkets, type) then
        PST:addModifiers({ damagePerc = 6, tearsPerc = 6 }, true)
    end

    -- Mod: +luck while holding an evil trinket
    if PST:getTreeSnapshotMod("evilTrinketLuck", 0) > 0 then
        PST:addModifiers({ luck = PST:getTreeSnapshotMod("evilTrinketLuck", 0) }, true)
    end

    -- Mod: +- luck when first obtaining any trinket
    if firstTime then
        local tmpBonus = PST:getTreeSnapshotMod("trinketRandLuck", 0)
        if tmpBonus ~= 0 then
            PST:addModifiers({ luck = -tmpBonus + tmpBonus * 2 * math.random() }, true)
        end
    end

    -- Ancient starcursed jewel: Baubleseeker
    if PST:SC_getSnapshotMod("baubleseeker", false) then
        if not baubleseekerProc then
            baubleseekerProc = true
            player:TryRemoveTrinket(type)
            local wasAdded = player:AddSmeltedTrinket(type, firstTime)
            if wasAdded then
                local tmpMod = PST:getTreeSnapshotMod("SC_baubleSeekerBuff", 0)
                if tmpMod < 15 then
                    PST:addModifiers({ allstatsPerc = 1, SC_baubleSeekerBuff = 1 }, true)
                end
            end
        else
            baubleseekerProc = false
        end
    end

    PST:updateCacheDelayed()
end
function PST:onTrinketRemove(player, type)
    -- Demonic Souvenirs node (Azazel's tree)
    if PST:getTreeSnapshotMod("demonicSouvenirs", false) and PST:arrHasValue(PST.evilTrinkets, type) then
        PST:addModifiers({ damagePerc = -6, tearsPerc = -6 }, true)
    end

    -- Mod: +luck while holding an evil trinket
    if PST:getTreeSnapshotMod("evilTrinketLuck", 0) > 0 then
        PST:addModifiers({ luck = -PST:getTreeSnapshotMod("evilTrinketLuck", 0) }, true)
    end

    PST:updateCacheDelayed()
end