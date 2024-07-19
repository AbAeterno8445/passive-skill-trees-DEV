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

function PST:onPickup(pickup, collider, low)
    local player = collider:ToPlayer()
    local variant = pickup.Variant
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
    end
end