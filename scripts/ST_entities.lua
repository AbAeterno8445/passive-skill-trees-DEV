function PST:onEntitySpawn(type, variant, subtype, position, velocity, spawner, seed)
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