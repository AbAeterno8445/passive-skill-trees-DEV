-- Check for the grabBag tree mod, and roll to spawn one on the player
function PST:tryGrabBag()
    local grabBagChance = PST:getTreeSnapshotMod("grabBag", 0)
    if grabBagChance > 0 and 100 * math.random() < grabBagChance then
        Game():Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_GRAB_BAG,
            Isaac.GetPlayer().Position,
            Vector(0, 0),
            nil,
            SackSubType.SACK_NORMAL,
            Game():GetRoom():GetSpawnSeed()
        )
    end
end

function PST:isPickupChest(variant)
    return variant == PickupVariant.PICKUP_CHEST or variant == PickupVariant.PICKUP_REDCHEST or
    variant == PickupVariant.PICKUP_LOCKEDCHEST or variant == PickupVariant.PICKUP_SPIKEDCHEST or
    variant == PickupVariant.PICKUP_WOODENCHEST or variant == PickupVariant.PICKUP_BOMBCHEST
end

function PST:vanishPickup(pickup)
    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, pickup.Position, Vector(0, 0), nil, 1, 0)
    pickup:Remove()
end

function PST:prePickup(pickup, collider, low)
    local player = collider:ToPlayer()
    local variant = pickup.Variant
    local subtype = pickup.SubType

    if player ~= nil then
        -- Cosmic Realignment node
        local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
        local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
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
                        PST:createFloatTextFX("Keeper's curse: " .. cosmicRCache.keeperFloorCoins .. "/5", Vector(0, 0), tmpColor, 0.1, 50, true)
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
                        Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector(0, 0), nil, 0, Random() + 1)
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
                    player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
                end
                if player:GetHearts() < player:GetMaxHearts() and not cosmicRCache.TForgottenTracker.keeperHeal then
                    player:AddHearts(-2)
                    cosmicRCache.TForgottenTracker.keeperHeal = true
                end
            end
        end
    end
end

function PST:onPickup(pickup, collider, low)
    local player = collider:ToPlayer()
    local variant = pickup.Variant
    local subtype = pickup.SubType

    if player ~= nil then
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
                local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
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
    local variant = pickup.Variant
    local subtype = pickup.SubType

    -- Cosmic Realignment node
	if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
        -- Tainted Magdalene, 15% chance to turn coins, bombs, keys or chests into a half red heart
        if variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
        variant == PickupVariant.PICKUP_KEY or PST:isPickupChest(variant) then
            local room = Game():GetRoom()
            if room:GetFrameCount() >= 0 or room:IsFirstVisit() then
                if 100 * math.random() < 15 then
                    pickup:Remove()
                    Game():Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_HEART,
                        pickup.Position,
                        pickup.Velocity,
                        nil,
                        HeartSubType.HEART_HALF,
                        Random() + 1
                    )
                end
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
        -- Tainted Judas, convert soul hearts to black hearts
        if variant == PickupVariant.PICKUP_HEART then
            if subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_HALF_SOUL then
                pickup:Remove()
                Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    pickup.Position,
                    pickup.Velocity,
                    nil,
                    HeartSubType.HEART_BLACK,
                    Random() + 1
                )
            end
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
        -- Tainted Lost, remove eternal hearts
        if variant == PickupVariant.PICKUP_HEART and subtype == HeartSubType.HEART_ETERNAL then
            pickup:Remove()
        end
    elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
        -- Tainted Keeper, convert bombs, keys, hearts and chests to coins
        if variant == PickupVariant.PICKUP_HEART or variant == PickupVariant.PICKUP_KEY or
        variant == PickupVariant.PICKUP_BOMB or PST:isPickupChest(variant) then
            pickup:Remove()
            Game():Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COIN,
                pickup.Position,
                pickup.Velocity,
                nil,
                CoinSubType.COIN_PENNY,
                Random() + 1
            )
        end
    end
end