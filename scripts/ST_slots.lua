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
        local player = PST:getPlayer()
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts()

        local spentCoins = player:GetNumCoins() < lastResources.coins
        local spentHearts = playerHearts < lastResources.hearts
        local spentKeys = player:GetNumKeys() < lastResources.keys
        local spentBombs = player:GetNumBombs() < lastResources.bombs

        -- Blood donation machine
        if slot.Variant == SlotVariant.BLOOD_DONATION_MACHINE and spentHearts then
            -- Blood Donor node (Magdalene's tree)
            if PST:getTreeSnapshotMod("bloodDonor", false) then
                SFXManager():Play(SoundEffect.SOUND_BEEP)
                player:AddActiveCharge(1, 0, true, false, false)
                if player:GetActiveItem(0) == CollectibleType.COLLECTIBLE_YUM_HEART and 100 * math.random() < 50 then
                    player:AddActiveCharge(1, 0, true, false, false)
                end
            end

            -- Mod: +luck when using a Blood Donation Machine
            local tmpTreeMod = PST:getTreeSnapshotMod("bloodDonationLuck", 0)
            if tmpTreeMod > 0 then
                PST:addModifiers({ luck = tmpTreeMod, bloodDonationLuckBuff = tmpTreeMod }, true)
            end

            -- Mod: chance to spawn an additional nickel when using a Blood Donation Machine
            tmpTreeMod = PST:getTreeSnapshotMod("bloodDonationNickel", 0)
            if tmpTreeMod > 0 and 100 * math.random() < tmpTreeMod then
                local tmpPos = Isaac.GetFreeNearPosition(slot.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
            end

            -- Mod: chance to spawn a temporary half red heart when using a Blood Donation Machine
            tmpTreeMod = PST:getTreeSnapshotMod("bloodDonoTempHeart", 0)
            if tmpTreeMod > 0 and 100 * math.random() < tmpTreeMod then
                local tmpHeart = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, slot.Position, RandomVector() * 3, nil, HeartSubType.HEART_HALF, Random() + 1)
                tmpHeart:ToPickup().Timeout = 60 + math.floor(PST:getTreeSnapshotMod("temporaryHeartTime", 0) * 30)
            end
        -- Crane game
        elseif slot.Variant == SlotVariant.CRANE_GAME and spentCoins then
            -- Impromptu Gambler node (Cain's tree)
            if PST:getTreeSnapshotMod("impromptuGambler", false) then
                if PST:getRoom():GetType() == RoomType.ROOM_TREASURE then
                    player:AddCoins(-3)

                    -- Remove natural treasure room items
                    if #PST.specialNodes.impromptuGamblerItems > 0 and not PST:getTreeSnapshotMod("impromptuGamblerItemRemoved", false) then
                        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                            if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE and
                            not PST:arrHasValue(PST.progressionItems, tmpEntity.SubType) then
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
                        PST:addModifiers({ impromptuGamblerItemRemoved = true }, true)
                    end
                end
            end
        else
            -- Beggar luck mod
            local beggarLuck = PST:getTreeSnapshotMod("beggarLuck", 0)
            local tmpTotal = PST:getTreeSnapshotMod("beggarLuckTotal", 0)
            if isBeggar and beggarLuck > 0 and tmpTotal < 1 then
                if spentCoins or spentHearts or spentKeys or spentBombs then
                    PST:addModifiers({ luck = beggarLuck, beggarLuckTotal = beggarLuck }, true)
                end
            end

            -- Mod: chance for devil beggar to grant half a black heart when helped
            if PST:getTreeSnapshotMod("devilBeggarBlackHeart", 0) > 0 then
                if slot.Variant == SlotVariant.DEVIL_BEGGAR and spentHearts and 100 * math.random() < PST:getTreeSnapshotMod("devilBeggarBlackHeart", 0) then
                    player:AddBlackHearts(1)
                end
            end

            -- Reduce troll bomb disarm proc chance on bomb bums
            if slot.Variant == SlotVariant.BOMB_BUM then
                PST.specialNodes.trollBombDisarmDebuffTimer = 45
            end
        end

        -- Machine-specific
        if spentCoins and (slot.Variant == SlotVariant.FORTUNE_TELLING_MACHINE or slot.Variant == SlotVariant.SHOP_RESTOCK_MACHINE or
        slot.Variant == SlotVariant.SLOT_MACHINE or slot.Variant == SlotVariant.CRANE_GAME) then
            -- Mod: chance for machines that use coins to cost nothing on use
            local tmpMod = PST:getTreeSnapshotMod("freeMachinesChance", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                player:AddCoins(lastResources.coins - player:GetNumCoins())
                PST:createFloatTextFX("Free use!", Vector.Zero, Color(1, 1, 0.5, 1), 0.12, 50, true)
                SFXManager():Play(SoundEffect.SOUND_PENNYPICKUP)
            end
        end
    end

    -- Beggar gives prize
    local slotSpr = slot:GetSprite()
    if slotSpr:GetAnimation() == "Teleport" and slotSpr:GetFrame() == 1 then
        -- Demon Helpers node (Azazel's tree)
        if PST:getTreeSnapshotMod("demonHelpers", false) then
            if slot.Variant == SlotVariant.DEVIL_BEGGAR and 100 * math.random() < 33 then
                local tmpPos = Isaac.GetFreeNearPosition(slot.Position, 40)
                local tmpItem = PST.demonFamiliars[math.random(#PST.demonFamiliars)]
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, tmpItem, Random() + 1)
            end
        end
    end
end