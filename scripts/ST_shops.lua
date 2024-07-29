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
    end
end