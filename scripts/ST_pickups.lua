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
        end
    end
end