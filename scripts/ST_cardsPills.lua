---@param RNG RNG
---@param card Card
function PST:onGetCard(RNG, card)
    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) and PST:arrHasValue(PST.blueGambitCards, card) and not PST:getTreeSnapshotMod("blueGambitCardProc", false) then
        PST:addModifiers({ blueGambitCardProc = true }, true)
        return Card.CARD_HIEROPHANT
    end

    -- Re-roll Soul of the Siren drop if not unlocked
    local sirenSoulID = Isaac.GetCardIdByName("SoulOfTheSiren")
    if sirenSoulID ~= -1 and card == sirenSoulID and not PST:isSoulOfTheSirenUnlocked() then
        local newCard = Game():GetItemPool():GetCard(RNG:GetSeed(), false, true, true)
        local failsafe = 0
        while newCard == sirenSoulID and failsafe < 200 do
            newCard = Game():GetItemPool():GetCard(RNG:Next(), false, true, true)
            failsafe = failsafe + 1
        end
        if failsafe < 200 then return newCard end
    end
end

function PST:preUseCard(card, player, useFlag)
    -- Sinistral Runemaster node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("sinistralRunemaster", false) then
        if not PST:getTreeSnapshotMod("dextralRunemaster", false) or
        (PST:getTreeSnapshotMod("dextralRunemaster", false) and 100 * math.random() < 75) then
            local showTxt = false
            if card == Card.RUNE_HAGALAZ then
                -- Hagalaz: additionally triggers Dad's Key's effect
                player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM)
                showTxt = true
            elseif card == Card.RUNE_JERA then
                -- Jera: duplicated coins/keys/bombs have an 8% chance of becoming a special version
                PST.specialNodes.jeraUseFrame = Game():GetFrameCount()
                showTxt = true
            elseif card == Card.RUNE_EHWAZ then
                -- Ehwaz: +3% all stats for the next floor if you step into a trapdoor/beam in the current room
                PST:addModifiers({ ehwazAllstatsProc = true }, true)
                showTxt = true
            elseif card == Card.RUNE_DAGAZ then
                -- Dagaz: +3% all stats for the current floor per cleansed curse
                local newBuff = PST:countSetBits(PST:getLevel():GetCurses()) * 3
                PST:addModifiers({ allstatsPerc = newBuff, dagazBuff = newBuff }, true)
                showTxt = true
            end
            if showTxt then
                PST:createFloatTextFX("Sinistral Runemaster", Vector.Zero, Color(0.7, 0.4, 1, 1), 0.12, 90, true)
            end
        end
    end

    -- Dextral Runemaster node (T. Isaac's tree)
    if PST:getTreeSnapshotMod("dextralRunemaster", false) then
        if not PST:getTreeSnapshotMod("sinistralRunemaster", false) or
        (PST:getTreeSnapshotMod("sinistralRunemaster", false) and 100 * math.random() < 75) then
            local showTxt = false
            if card == Card.RUNE_ANSUZ then
                -- Ansuz: on use, +15% chance to trigger a map reveal on the next floor
                PST:addModifiers({ ansuzMapreveal = 15 }, true)
                showTxt = true
            elseif card == Card.RUNE_PERTHRO then
                -- Perthro: a random item pedestal gains an additional item choice from the treasure room pool
                PST.specialNodes.perthroProc = true
            elseif card == Card.RUNE_BERKANO then
                -- Berkano: gain Hive Mind innately for the current floor. If you already have it, spawn twice as many spiders and flies
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
                    PST:addModifiers({ berkanoHivemind = true }, true)
                else
                    for _=1,3 do
                        Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, player.Position, Vector.Zero, player, 0, Random() + 1)
                        Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, player, 0, Random() + 1)
                    end
                end
                showTxt = true
            elseif card == Card.RUNE_ALGIZ then
                -- Algiz: +7% damage and tears for 20 seconds
                local tmpMods = {}
                if not PST:getTreeSnapshotMod("algizBuffProc", false) then
                    tmpMods["damagePerc"] = 7
                    tmpMods["tearsPerc"] = 7
                end
                tmpMods["algizBuffProc"] = true
                tmpMods["algizBuffTimer"] = 20
                PST:addModifiers(tmpMods, true)
                showTxt = true
            elseif card == Card.RUNE_BLANK then
                -- Blank: additionally trigger a rune shard's effect
                player:UseCard(Card.RUNE_SHARD, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
            if showTxt then
                PST:createFloatTextFX("Dextral Runemaster", Vector.Zero, Color(0.7, 0.4, 1, 1), 0.12, 90, true)
            end
        end
    end
end

---@param card Card
---@param player EntityPlayer
---@param useFlags UseFlag
function PST:onUseCard(card, player, useFlags)
    -- Skip if using Rev High Priestess with Nightmare Projector (ancient jewel)
    if card == Card.CARD_REVERSE_HIGH_PRIESTESS and PST:SC_getSnapshotMod("nightmareProjector", false) then
        return
    end

    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) and PST:arrHasValue(PST.blueGambitCards, card) then
        if card ~= Card.CARD_HIEROPHANT and 100 * math.random() < 20 then
            player:TakeDamage(1, 0, EntityRef(player), 0)
        end
    end

    -- Mod: chance to receive half a soul heart when using a card or pill
    if 100 * math.random() < PST:getTreeSnapshotMod("soulOnCardPill", 0) and card ~= Card.CARD_CRACKED_KEY then
        player:AddSoulHearts(1)
    end

    -- Mod: +damage when using a card, up to +3. Resets every floor
    local tmpBonus = PST:getTreeSnapshotMod("cardFloorDamage", 0)
    if tmpBonus ~= 0 and PST:getTreeSnapshotMod("cardFloorDamageTotal", 0) < 3 and card ~= Card.CARD_CRACKED_KEY then
        local tmpAdd = math.min(tmpBonus, 3 - tmpBonus)
        PST:addModifiers({ damage = tmpAdd, cardFloorDamageTotal = tmpAdd }, true)
    end

    -- Mod: +tears when using a card, up to +3. Resets every floor
    tmpBonus = PST:getTreeSnapshotMod("cardFloorTears", 0)
    if tmpBonus ~= 0 and PST:getTreeSnapshotMod("cardFloorTearsTotal", 0) < 3 and card ~= Card.CARD_CRACKED_KEY then
        local tmpAdd = math.min(tmpBonus, 3 - tmpBonus)
        PST:addModifiers({ tears = tmpAdd, cardFloorTearsTotal = tmpAdd }, true)
    end

    -- A True Ending? node (Lazarus' tree)
    if PST:getTreeSnapshotMod("aTrueEnding", false) and card == Card.CARD_SUICIDE_KING then
        PST:addModifiers({ aTrueEndingCardUses = 1 }, true)
    end

    -- Mod: % luck for the current floor when using a card
    tmpBonus = PST:getTreeSnapshotMod("cardFloorLuck", 0)
    if tmpBonus ~= 0 and PST:getTreeSnapshotMod("floorLuckPerc", 0) < 15 and card ~= Card.CARD_CRACKED_KEY then
        PST:addModifiers({ luckPerc = tmpBonus, floorLuckPerc = tmpBonus }, true)
    end

    -- Card against humanity proc
    if card == Card.CARD_HUMANITY then
        PST:addModifiers({ cardAgainstHumanityProc = true }, true)
    end

    local room = PST:getRoom()
    -- Mod: chance to turn adjacent curse room spiked door into a regular one (update doors)
    if PST:getTreeSnapshotMod("curseRoomSpikesOutProc", false) then
        for i=0,7 do
            local tmpDoor = room:GetDoor(i)
            if tmpDoor then
                if room:GetType() == RoomType.ROOM_CURSE then
                    tmpDoor:SetRoomTypes(RoomType.ROOM_DEFAULT, tmpDoor.TargetRoomType)
                elseif tmpDoor.TargetRoomType == RoomType.ROOM_CURSE then
                    tmpDoor:SetRoomTypes(room:GetType(), RoomType.ROOM_DEFAULT)
                end
            end
        end
    end

    -- Mod: +% all stats when using a soul stone matching your current character, once per run
    tmpBonus = PST:getTreeSnapshotMod("soulStoneAllstats", 0)
    if tmpBonus > 0 and not PST:getTreeSnapshotMod("soulStoneAllstatsProc", false) and card == PST:getMatchingSoulstone(player:GetPlayerType()) then
        PST:addModifiers({
            allstatsPerc = tmpBonus + math.abs(PST:getTreeSnapshotMod("soulStoneUnusedAllstats", 0)),
            soulStoneAllstatsProc = true
        }, true)
    end

    -- Mod: % chance to spawn a rune shard when using a dice shard
    tmpBonus = PST:getTreeSnapshotMod("diceShardRuneShard", 0)
    if tmpBonus > 0 and card == Card.CARD_DICE_SHARD and 100 * math.random() < tmpBonus then
        local tmpPos = room:FindFreePickupSpawnPosition(player.Position, 20)
        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.RUNE_SHARD, Random() + 1)
    end

    -- Mod: +% speed when using a rune shard
    tmpBonus = PST:getTreeSnapshotMod("runicSpeed", 0)
    local tmpTotal = PST:getTreeSnapshotMod("runicSpeedBuff", 0)
    if tmpBonus > 0 and card == Card.RUNE_SHARD and tmpTotal < 22 then
        local tmpAdd = math.min(tmpBonus, 22 - tmpTotal)
        PST:addModifiers({ speedPerc = tmpAdd, runicSpeedBuff = tmpAdd }, true)
    end

    -- Mod: rune shards can stack
    if PST:getTreeSnapshotMod("runeshardStacking", false) and card == Card.RUNE_SHARD and PST:getTreeSnapshotMod("runeshardStacks", 0) > 0 then
        player:AddCard(Card.RUNE_SHARD)
        PST:addModifiers({ runeshardStacks = -1 }, true)
    end

    -- Dextral Runemaster: Perthro effect proc
    if PST.specialNodes.perthroProc and card == Card.RUNE_PERTHRO then
        local tmpItems = {}
        for _, tmpEntity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            local tmpItem = tmpEntity:ToPickup()
            if tmpItem then table.insert(tmpItems, tmpItem) end
        end
        if #tmpItems > 0 then
            local selected = tmpItems[math.random(#tmpItems)]
            local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE)
            selected:AddCollectibleCycle(newItem)
        end
        PST.specialNodes.perthroProc = false
    end

    -- Troll bomb disarm debuff on tower card
    if card == Card.CARD_TOWER then
        PST.specialNodes.trollBombDisarmDebuffTimer = 45
    end

    -- Helping Hands node (T. Lost's tree) (Holy Card stacks)
    if PST:getTreeSnapshotMod("helpingHands", false) and card == Card.CARD_HOLY and PST:getTreeSnapshotMod("holyCardStacks", 0) > 0 then
        player:AddCard(Card.CARD_HOLY)
        PST:addModifiers({ holyCardStacks = -1 }, true)
    end

    -- Deferred Aegis node (T. Lost's tree)
    if PST:getTreeSnapshotMod("deferredAegis", false) then
        PST:addModifiers({ deferredAegisCardUses = 1 }, true)
    end

    -- Mod: +luck for the current floor when using a Holy Card
    local tmpMod = PST:getTreeSnapshotMod("holyCardLuck", 0)
    if tmpMod > 0 and card == Card.CARD_HOLY then
        PST:addModifiers({ luck = tmpMod, holyCardLuckBuff = tmpMod }, true)
    end

    -- Ancient starcursed jewel: Circadian Destructor
    if PST:SC_getSnapshotMod("circadianDestructor", false) and card == Card.CARD_TOWER then
        local tmpMod = PST:getTreeSnapshotMod("SC_circadianStatsDown", 0)
        if tmpMod > 0 then
            PST:addModifiers({ allstatsPerc = tmpMod, SC_circadianStatsDown = { value = 0, set = true } }, true)
        end
        PST.specialNodes.SC_circadianSpawnProc = false
        PST.specialNodes.SC_circadianExplImmune = 120
    end

    -- Ancient starcursed jewel: Cursed Starpiece
    if PST:SC_getSnapshotMod("cursedStarpiece", false) and card == Card.CARD_REVERSE_STARS then
        if PST:getTreeSnapshotMod("SC_cursedStarpieceDebuff", false) then
            PST:addModifiers({ allstatsPerc = 12, SC_cursedStarpieceDebuff = false }, true)
        end

        local tmpChance = 100
        if room:GetType() == RoomType.ROOM_TREASURE then
            tmpChance = 35
        end
        if 100 * math.random() < tmpChance then
            local playerCollectibles = player:GetCollectiblesList()
            local removableCollectibles = {}
            for itemID, tmpItemCount in ipairs(playerCollectibles) do
                if tmpItemCount > 0 then table.insert(removableCollectibles, itemID) end
            end
            if #removableCollectibles > 0 then
                player:RemoveCollectible(removableCollectibles[math.random(#removableCollectibles)])
            end
        end
    end

    -- Ancient starcursed jewel: Baubleseeker (remove smelted trinket with rev stars and spawn random trinket)
    if PST:SC_getSnapshotMod("baubleseeker", false) and card == Card.CARD_REVERSE_STARS then
        local smelted = {}
        for trinketID, tmpTrinket in pairs(player:GetSmeltedTrinkets()) do
            if tmpTrinket.trinketAmount > 0 or tmpTrinket.goldenTrinketAmount > 0 then
                table.insert(smelted, trinketID)
            end
        end
        if #smelted > 0 then
            player:TryRemoveSmeltedTrinket(smelted[math.random(#smelted)])
            PST:addModifiers({ allstatsPerc = -1, SC_baubleSeekerBuff = -1 }, true)
            local tmpTrinket = Game():GetItemPool():GetTrinket()
            local tmpPos = room:FindFreePickupSpawnPosition(player.Position, 20)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpTrinket, Random() + 1)
        end
    end

    -- Ancient starcursed jewel: Luminescent Die
    if PST:SC_getSnapshotMod("luminescentDie", false) then
        PST:addModifiers({ SC_luminescentUsedCard = true }, true)
        tmpMod = PST:getTreeSnapshotMod("SC_luminescentDebuff", 0)
        if tmpMod > 0 then
            PST:addModifiers({
                allstatsPerc = tmpMod / 2,
                SC_luminescentDebuff = { value = tmpMod / 2, set = true }
            }, true)
        end
    end

    -- Ancient starcursed jewel: Crimson Warpstone
    if PST:SC_getSnapshotMod("crimsonWarpstone", false) and card == Card.CARD_CRACKED_KEY and
    PST:getTreeSnapshotMod("SC_crimsonWarpKeyStacks", 0) > 0 then
        player:AddCard(Card.CARD_CRACKED_KEY)
        PST:addModifiers({ SC_crimsonWarpKeyStacks = -1 }, true)
    end

    -- Ancient starcursed jewel: Twisted Emperor's Heirloom
    if PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) and card == Card.CARD_REVERSE_EMPEROR then
        if not PST:getTreeSnapshotMod("SC_empHeirloomUsedCard", false) then
            PST:addModifiers({ SC_empHeirloomUsedCard = true }, true)
        end
    end

    -- Soul of the Siren effect
    if card == Isaac.GetCardIdByName("SoulOfTheSiren") then
        SFXManager():Play(SoundEffect.SOUND_SIREN_SING, 0.6, 2, false, 1.1)

        -- Charm all enemies in the room for 10 seconds
        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
			local tmpNPC = tmpEntity:ToNPC()
			if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
				tmpNPC:AddCharmed(EntityRef(player), 300)
			end
		end

        -- Gain a smelted friendship necklace
        local smeltedTrinkets = player:GetSmeltedTrinkets()
        if smeltedTrinkets[TrinketType.TRINKET_FRIENDSHIP_NECKLACE].trinketAmount == 0 and smeltedTrinkets[TrinketType.TRINKET_FRIENDSHIP_NECKLACE].goldenTrinketAmount == 0 then
            player:AddSmeltedTrinket(TrinketType.TRINKET_FRIENDSHIP_NECKLACE)
        end

        -- Add 3 random baby familiars as innate effects
        local rolledFamiliars = {}
        local failsafe = 0
        while #rolledFamiliars < 3 and failsafe < 500 do
            local newFamiliar = Game():GetItemPool():GetCollectibleFromList(PST.babyFamiliarItems)
            if not PST:arrHasValue(rolledFamiliars, newFamiliar) then
                player:AddInnateCollectible(newFamiliar)
                table.insert(rolledFamiliars, newFamiliar)
            end
            failsafe = failsafe + 1
        end
        table.insert(PST.specialFX.sirenSoulUses, { timer = 1800, familiars = rolledFamiliars })
    end
end

function PST:blueGambitPillSwap(oldColor, oldEffect, newColor)
    PST:addModifiers({
        blueGambitPillProc = true,
        blueGambitPillSwap = {
            value = { old = oldColor, oldEffect = oldEffect, new = newColor },
            set = true
        }
    }, true)
end

local isGoldPill = false
function PST:onPillEffect(effect, pillColor)
    if pillColor == PillColor.PILL_GOLD then
        isGoldPill = true
    end
    -- Blue Gambit node (Blue Baby's tree)
    if PST:getTreeSnapshotMod("blueGambit", false) then
        if not PST:getTreeSnapshotMod("blueGambitPillProc", false) then
            local oldPillCol = pillColor
            ---@diagnostic disable-next-line: undefined-field
            local newPillCol = Game():GetItemPool():GetPillColor(PillEffect.PILLEFFECT_BALLS_OF_STEEL)
            PST:blueGambitPillSwap(oldPillCol, effect, newPillCol)
        end
        local blueGambitPillSwap = PST:getTreeSnapshotMod("blueGambitPillSwap", nil)
        if blueGambitPillSwap then
            if pillColor == blueGambitPillSwap.old then return PillEffect.PILLEFFECT_BALLS_OF_STEEL
            elseif pillColor == blueGambitPillSwap.new then return blueGambitPillSwap.oldEffect end
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

    -- Exclude gold pills
    if isGoldPill then
        isGoldPill = false
    else
        -- Vurp once per floor
        if pillEffect ~= PillEffect.PILLEFFECT_VURP or (pillEffect == PillEffect.PILLEFFECT_VURP and not PST:getTreeSnapshotMod("vurpProc", false)) then
            if pillEffect == PillEffect.PILLEFFECT_VURP then
                PST:addModifiers({ vurpProc = true }, true)
            end

            -- Mod: chance to receive half a soul heart when using a card or pill
            if 100 * math.random() < PST:getTreeSnapshotMod("soulOnCardPill", 0) then
                player:AddSoulHearts(1)
            end

            -- Mod: % luck for the current floor when using a pill
            tmpBonus = PST:getTreeSnapshotMod("pillFloorLuck", 0)
            if tmpBonus ~= 0 and PST:getTreeSnapshotMod("floorLuckPerc", 0) < 15 then
                PST:addModifiers({ luckPerc = tmpBonus, floorLuckPerc = tmpBonus }, true)
            end
        end
    end
end