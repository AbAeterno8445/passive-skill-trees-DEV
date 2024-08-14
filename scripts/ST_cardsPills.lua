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

    -- Mod: +damage when using a card, up to +3. Resets every floor
    local tmpBonus = PST:getTreeSnapshotMod("cardFloorDamage", 0)
    if tmpBonus ~= 0 and PST:getTreeSnapshotMod("cardFloorDamageTotal", 0) < 3 then
        local tmpAdd = math.min(tmpBonus, 3 - tmpBonus)
        PST:addModifiers({ damage = tmpAdd, cardFloorDamageTotal = tmpAdd }, true)
    end

    -- Mod: +tears when using a card, up to +3. Resets every floor
    tmpBonus = PST:getTreeSnapshotMod("cardFloorTears", 0)
    if tmpBonus ~= 0 and PST:getTreeSnapshotMod("cardFloorTearsTotal", 0) < 3 then
        local tmpAdd = math.min(tmpBonus, 3 - tmpBonus)
        PST:addModifiers({ tears = tmpAdd, cardFloorTearsTotal = tmpAdd }, true)
    end

    -- A True Ending? node (Lazarus' tree)
    if PST:getTreeSnapshotMod("aTrueEnding", false) and card == Card.CARD_SUICIDE_KING then
        PST:addModifiers({ aTrueEndingCardUses = 1 }, true)
    end

    -- Mod: % luck for the current floor when using a card
    tmpBonus = PST:getTreeSnapshotMod("cardFloorLuck", 0)
    if tmpBonus ~= 0 then
        PST:addModifiers({ luckPerc = tmpBonus, floorLuckPerc = tmpBonus }, true)
    end

    -- Card against humanity proc
    if card == Card.CARD_HUMANITY then
        PST:addModifiers({ cardAgainstHumanityProc = true }, true)
    end

    -- Ancient starcursed jewel: Circadian Destructor
    if PST:SC_getSnapshotMod("circadianDestructor", false) and card == Card.CARD_TOWER then
        if PST.specialNodes.SC_circadianStatsDown > 0 then
            PST:addModifiers({ allstatsPerc = PST.specialNodes.SC_circadianStatsDown }, true)
            PST.specialNodes.SC_circadianStatsDown = 0
        end
        PST.specialNodes.SC_circadianSpawnProc = false
        PST.specialNodes.SC_circadianExplImmune = 120
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

    -- Mod: chance to receive half a soul heart when using a card or pill
    if 100 * math.random() < PST:getTreeSnapshotMod("soulOnCardPill", 0) then
        player:AddSoulHearts(1)
    end

    -- Mod: % luck for the current floor when using a pill
    tmpBonus = PST:getTreeSnapshotMod("pillFloorLuck", 0)
    if tmpBonus ~= 0 then
        PST:addModifiers({ luckPerc = tmpBonus, floorLuckPerc = tmpBonus }, true)
    end
end