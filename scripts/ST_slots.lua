local lastResources = { hearts = 0, coins = 0, keys = 0, bombs = 0 }

function PST:preSlotCollision(slot, collider, low)
    local player = collider:ToPlayer()
    if player then
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts()
        lastResources.hearts = playerHearts
        lastResources.coins = player:GetNumCoins()
        lastResources.keys = player:GetNumKeys()
        lastResources.bombs = player:GetNumBombs()
    end
end

function PST:onSlotUpdate(slot)
    local isBeggar = slot.Variant == SlotVariant.BEGGAR or slot.Variant == SlotVariant.BATTERY_BUM or
    slot.Variant == SlotVariant.ROTTEN_BEGGAR or slot.Variant == SlotVariant.DEVIL_BEGGAR or
    slot.Variant == SlotVariant.KEY_MASTER or slot.Variant == SlotVariant.BOMB_BUM

    -- Player collided with slot
    if slot:GetTouch() > 0 then
        local player = Isaac.GetPlayer()
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts()
        
        local spentCoins = player:GetNumCoins() < lastResources.coins
        local spentHearts = playerHearts < lastResources.hearts
        local spentKeys = player:GetNumKeys() < lastResources.keys
        local spentBombs = player:GetNumBombs() < lastResources.bombs

        -- Blood donation machine
        if slot.Variant == SlotVariant.BLOOD_DONATION_MACHINE and spentHearts then
            -- Blood Donor node (Magdalene's tree)
            if PST:getTreeSnapshotMod("bloodDonor", false) and player:GetActiveCharge(0) < player:GetActiveMaxCharge(0) then
                SFXManager():Play(SoundEffect.SOUND_BEEP)
                player:SetActiveCharge(player:GetActiveCharge(0) + 1, 0)
                if Isaac.GetPlayer():GetActiveItem(0) == CollectibleType.COLLECTIBLE_YUM_HEART and 100 * math.random() < 50 then
                    player:SetActiveCharge(player:GetActiveCharge(0) + 1, 0)
                end
            end

            -- Mod: +luck when using a Blood Donation Machine
            local tmpTreeMod = PST:getTreeSnapshotMod("bloodDonationLuck", 0)
            if tmpTreeMod > 0 then
                PST:addModifiers({ luck = tmpTreeMod }, true)
            end

            -- Mod: chance to spawn an additional nickel when using a Blood Donation Machine
            if 100 * math.random() < PST:getTreeSnapshotMod("bloodDonationNickel", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(slot.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
            end
        -- Crane game
        elseif slot.Variant == SlotVariant.CRANE_GAME and spentCoins then
            -- Impromptu Gambler node (Cain's tree)
            if PST:getTreeSnapshotMod("impromptuGambler", false) then
                if Game():GetRoom():GetType() == RoomType.ROOM_TREASURE then
                    player:AddCoins(-3)

                    -- Remove natural treasure room items
                    if #PST.specialNodes.impromptuGamblerItems > 0 then
                        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                            if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                                local tmpX = math.floor(tmpEntity.Position.X / 40)
                                local tmpY = math.floor(tmpEntity.Position.Y / 40)
                                for _, itemPos in ipairs(PST.specialNodes.impromptuGamblerItems) do
                                    if tmpX == itemPos.X and tmpY == itemPos.Y then
                                        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, 0)
                                        tmpEntity:Remove()
                                    end
                                end
                            end
                        end
                        PST.specialNodes.impromptuGamblerItems = {}
                    end
                end
            end
        else
            -- Beggar luck mod
            local beggarLuck = PST:getTreeSnapshotMod("beggarLuck", 0)
            if isBeggar and beggarLuck > 0 then
                if spentCoins or spentHearts or spentKeys or spentBombs then
                    PST:addModifiers({ luck = beggarLuck }, true)
                end
            end
        end

        -- Machine-specific
        if spentCoins and (slot.Variant == SlotVariant.FORTUNE_TELLING_MACHINE or slot.Variant == SlotVariant.SHOP_RESTOCK_MACHINE or
        slot.Variant == SlotVariant.SLOT_MACHINE or slot.Variant == SlotVariant.CRANE_GAME) then
            -- Mod: chance for machines that use coins to cost nothing on use
            if 100 * math.random() < PST:getTreeSnapshotMod("freeMachinesChance", 0) then
                player:AddCoins(lastResources.coins - player:GetNumCoins())
                PST:createFloatTextFX("Free use!", Vector.Zero, Color(1, 1, 0.5, 1), 0.12, 50, true)
                SFXManager():Play(SoundEffect.SOUND_PENNYPICKUP)
            end
        end
    end
end