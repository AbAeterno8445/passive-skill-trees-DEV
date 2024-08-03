function PST:onShopPurchase(pickupBought, player, spent)
    if spent > 0 then
        local room = Game():GetRoom()

        -- Mod: chance to steal shop item instead of purchasing
        if room:GetType() == RoomType.ROOM_SHOP then
            local stealChance = PST:getTreeSnapshotMod("stealChance", 0)
            if 100 * math.random() < stealChance then
                player:AddCoins(spent)
                PST:addModifiers({ luck = spent / 100 }, true)

                local tmpColor = Color(1, 1, 1, 1)
                -- Thievery node (Cain's tree)
                if PST:getTreeSnapshotMod("thievery", false) and not PST:getTreeSnapshotMod("thieveryGreedProc", false) then
                    if 100 * math.random() < spent * 3 then
                        PST:addModifiers({ thieveryGreedProc = true }, true)
                        SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
                        tmpColor = Color(1, 0.4, 0.4, 1)
                    end
                end
                PST:createFloatTextFX("Stolen!", Vector.Zero, tmpColor, 0.13, 100, true)
            end
        end

        -- Mod: +luck when purchasing an item
        local tmpMod = PST:getTreeSnapshotMod("itemPurchaseLuck", 0)
        if tmpMod ~= 0 then
            PST:addModifiers({ luck = tmpMod }, true)
        end

        -- Mod: chance to keep 1-3 coins when purchasing an item
        if 100 * math.random() < PST:getTreeSnapshotMod("purchaseKeepCoins", 0) then
            player:AddCoins(math.random(3))
        end
    elseif spent < 0 then
        -- Mod: chance to gain a black heart when spending hearts on deals
        if 100 * math.random() < PST:getTreeSnapshotMod("blackHeartOnDeals", 0) then
            player:AddBlackHearts(2)
        end
    end
end