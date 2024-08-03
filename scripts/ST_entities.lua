function PST:onEntitySpawn(type, variant, subtype, position, velocity, spawner, seed)
    if Game():GetRoom():GetFrameCount() > 1 then
        -- Dead bird spawn, set active
        if type == EntityType.ENTITY_FAMILIAR and variant == FamiliarVariant.DEAD_BIRD and not PST.specialNodes.deadBirdActive then
            PST.specialNodes.deadBirdActive = true

            -- Active dead bird mods
            PST:addModifiers({
                damage = PST:getTreeSnapshotMod("activeDeadBirdDamage", 0),
                speed = PST:getTreeSnapshotMod("activeDeadBirdSpeed", 0),
                range = PST:getTreeSnapshotMod("activeDeadBirdRange", 0),
                tears = PST:getTreeSnapshotMod("activeDeadBirdTears", 0),
                shotSpeed = PST:getTreeSnapshotMod("activeDeadBirdShotspeed", 0)
            }, true)
        end
    end

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY) then
        local player = Isaac.GetPlayer()
        -- Bethany, as Keeper: -0.01 luck whenever a blue fly spawns, up to -2
        if type == EntityType.ENTITY_FAMILIAR and variant == FamiliarVariant.BLUE_FLY and
        (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or
        player:GetPlayerType() == PlayerType.PLAYER_KEEPERB) then
            local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.modData.treeMods.cosmicRCache)
            if cosmicRCache.bethanyKeeperLuck > -2 then
                PST:addModifiers({ luck = -0.01 }, true)
                cosmicRCache.bethanyKeeperLuck = cosmicRCache.bethanyKeeperLuck - 0.01
                PST:save()
            end
        end
    end
end

function PST:postNPCInit(npc)
    -- Mod: Greed has lower health
    if npc.Type == EntityType.ENTITY_GREED then
        npc.HitPoints = npc.HitPoints - math.min(npc.HitPoints / 2, npc.MaxHitPoints * (PST:getTreeSnapshotMod("greedLowerHealth", 0) / 100))
    end
end