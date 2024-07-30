function PST:onGetCard(RNG, card)
    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) then
        if not PST:getTreeSnapshotMod("blueGambitCardProc", false) then
            PST:addModifiers({ blueGambitCardProc = true }, true)
            return Card.CARD_HIEROPHANT
        end
    end
end

function PST:onUseCard(card, player, useFlags)
    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) then
        if card ~= Card.CARD_HIEROPHANT and 100 * math.random() < 20 then
            player:TakeDamage(1, 0, EntityRef(player), 0)
        end
    end

    -- Mod: chance to receive half a soul hart when using a card or pill
    if 100 * math.random() < PST:getTreeSnapshotMod("soulOnCardPill", 0) then
        player:AddSoulHearts(1)
    end
end

function PST:onPillEffect(effect, pillColor)
    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) then
        if not PST:getTreeSnapshotMod("blueGambitPillProc", false) then
            PST:addModifiers({ blueGambitPillProc = true }, true)
            return PillEffect.PILLEFFECT_BALLS_OF_STEEL
        end
    end
end

function PST:onUsePill(pillEffect, player, useFlags)
    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) then
        if pillEffect ~= PillEffect.PILLEFFECT_BALLS_OF_STEEL and 100 * math.random() < 20 then
            player:TakeDamage(1, 0, EntityRef(player), 0)
        end
    end

    -- Mod: chance to receive half a soul hart when using a card or pill
    if 100 * math.random() < PST:getTreeSnapshotMod("soulOnCardPill", 0) then
        player:AddSoulHearts(1)
    end
end