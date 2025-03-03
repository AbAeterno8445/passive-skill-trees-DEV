PST.sideArtiData = {
    ---- SEPTENTRIONS ----
    bloodSeptentrion = {
        name = "Blood Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Kill a monster", PST.kcolors.BLUE1},
            {"Generates 3 energy.", PST.kcolors.TEAL1}
        },
        energy = 3
    },
    taintbloodSeptentrion = {
        name = "Taintblood Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Kill a monster affected by any status effect", PST.kcolors.BLUE1},
            {"Generates 4 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Kill {{progress}}/100 monsters affected by any status effect.",
            req = 100
        },
        energy = 4
    },
    icySeptentrion = {
        name = "Icy Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Destroy a frozen monster.", PST.kcolors.BLUE1},
            {"Generates 3 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Destroy {{progress}}/100 frozen monsters.",
            req = 100
        },
        energy = 3
    },
    beastseekerSeptentrion = {
        name = "Beastseeker Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Hit a boss monster 3 times.", PST.kcolors.BLUE1},
            {"Generates 1 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Defeat 15 boss monsters in a single run.",
            req = 1
        },
        energy = 1
    },
    giantseekerSeptentrion = {
        name = "Giantseeker Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Hit a boss monster 8 times.", PST.kcolors.BLUE1},
            {"Generates 4 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Clear {{progress}}/7 boss rooms without taking damage.",
            req = 7
        },
        energy = 4
    },
    rotseekerSeptentrion = {
        name = "Rotseeker Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Hit a boss affected by any status effect.", PST.kcolors.BLUE1},
            {"Generates 3 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Inflict status effects on bosses {{progress}}/50 times.",
            req = 50
        },
        energy = 3
    },
    titanseekerSeptentrion = {
        name = "Titanseeker Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Hit a final boss.", PST.kcolors.BLUE1},
            {"Generates 2 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Defeat any final boss without taking damage more than once.",
            req = 1
        },
        energy = 2
    },
    assassinSeptentrion = {
        name = "Assassin Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Hit a non-boss monster above 90% HP or below 10% HP.", PST.kcolors.BLUE1},
            {"Generates 2 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Kill {{progress}}/300 monsters that have at least 10 HP.",
            req = 300
        },
        energy = 2
    },
    deathseekerSeptentrion = {
        name = "Deathseeker Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Hit an undead monster.", PST.kcolors.BLUE1},
            {"Generates 3 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Kill {{progress}}/100 undead monsters with at least 10 HP.",
            req = 100
        },
        energy = 3
    },
    allianceSeptentrion = {
        name = "Alliance Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Kill a monster with familiar damage.", PST.kcolors.BLUE1},
            {"Generates 5 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Kill {{progress}}/50 monsters with familiar damage.",
            req = 50
        },
        energy = 5
    },
    slayerSeptentrion = {
        name = "Slayer Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Kill a champion monster.", PST.kcolors.BLUE1},
            {"Generates 7 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Kill {{progress}}/100 champion monsters.",
            req = 100
        },
        energy = 7
    },
    magicSeptentrion = {
        name = "Magic Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Use an active item.", PST.kcolors.BLUE1},
            {"Generates 4 energy per used charge.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Use an active item with at least 1 charge in rooms with monsters {{progress}}/30 times.",
            req = 30
        },
        energy = 4
    },
    solarSeptentrion = {
        name = "Solar Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Enter a treasure room for the first time in the floor.", PST.kcolors.BLUE1},
            {"Generates 2 energy per second for 60 seconds.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Enter {{progress}}/30 different treasure rooms.",
            req = 30
        },
        energy = 2
    },
    lunarSeptentrion = {
        name = "Lunar Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Enter a secret room for the first time in the floor.", PST.kcolors.BLUE1},
            {"Generates 4 energy per second for 30 seconds.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Enter {{progress}}/30 different secret rooms.",
            req = 30
        },
        energy = 4
    },
    superstitiousSeptentrion = {
        name = "Superstitious Septentrion",
        type = "septentrion",
        desc = {
            {"Condition: Use any consumable pocket item.", PST.kcolors.BLUE1},
            {"Generates 15 energy.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Use consumable pocket items {{progress}}/40 times.",
            req = 40
        },
        energy = 15
    },

    ---- MERIDIONS ----
    galvanicMeridion = {
        name = "Galvanic Meridion",
        type = "meridion",
        desc = {
            {"15 energy: Gain 3% all stats for 5 seconds.", PST.kcolors.TEAL1},
            "No artifact cooldown.",
        },
        energyReq = 15
    },
    glacialMeridion = {
        name = "Glacial Meridion",
        type = "meridion",
        desc = {
            {"25 energy: Triggers Hourglass' effect.", PST.kcolors.TEAL1},
            "4 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/40 slowed enemies.",
            req = 40
        },
        energyReq = 25,
        cooldown = 4
    },
    smitingMeridion = {
        name = "Smiting Meridion",
        type = "meridion",
        desc = {
            {"30 energy: Damage all enemies in the room for 5 + 7% of their max HP, up to 4 times per room.", PST.kcolors.TEAL1},
            {"Flat damage dealt goes up as you progress through floors.", PST.kcolors.TEAL1},
            "3 second artifact cooldown."
        },
        objective = {
            desc = "Clear {{progress}}/30 rooms within 7 seconds each.",
            req = 30
        },
        energyReq = 30,
        cooldown = 3
    },
    infectiousMeridion = {
        name = "Infectious Meridion",
        type = "meridion",
        desc = {
            {"20 energy: Generate a pulse that damages nearby enemies and inflicts a status effect on them", PST.kcolors.TEAL1},
            {"for 4 seconds.", PST.kcolors.TEAL1},
            "2 second artifact cooldown"
        },
        objective = {
            desc = "Inflict status effects on non-boss enemies {{progress}}/200 times.",
            req = 200
        },
        energyReq = 20,
        cooldown = 2
    },
    virtuousMeridion = {
        name = "Virtuous Meridion",
        type = "meridion",
        desc = {
            {"60 energy: Generate a random orbiting Wisp to assist you, up to 5 times per floor.", PST.kcolors.TEAL1},
            "7 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/15 boss monsters with familiar damage.",
            req = 15
        },
        energyReq = 60,
        cooldown = 7
    },
    stoneMeridion = {
        name = "stoneMeridion",
        type = "meridion",
        desc = {
            {"30 energy: Petrify a random enemy in the room for 7 seconds, prioritizing enemies with the", PST.kcolors.TEAL1},
            {"highest health.", PST.kcolors.TEAL1},
            "4 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/50 petrified enemies.",
            req = 50
        },
        energyReq = 30,
        cooldown = 4
    },
    infernalMeridion = {
        name = "infernalMeridion",
        type = "meridion",
        desc = {
            {"90 energy:", PST.kcolors.TEAL1},
            {"   Inflict burning on all enemies in the room for 6 seconds.", PST.kcolors.TEAL1},
            {"   For the rest of the room, burning enemies explode on death, damaging other nearby enemies.", PST.kcolors.TEAL1},
            "6 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/50 burning enemies",
            req = 50
        },
        energyReq = 90,
        cooldown = 6
    },
    deadSeaMeridion = {
        name = "Dead Sea Meridion",
        type = "meridion",
        desc = {
            {"30 energy: Trigger Dead Sea Scrolls' effect, up to 4 times per room.", PST.kcolors.TEAL1},
            "4 second artifact cooldown."
        },
        objective = {
            desc = "Use active items with at least 3 charges in boss rooms {{progress}}/20 times",
            req = 20
        },
        energyReq = 30,
        cooldown = 4
    },
    flowingMeridion = {
        name = "Flowing Meridion",
        type = "meridion",
        desc = {
            {"20 energy: Trigger Isaac's Tears' effect.", PST.kcolors.TEAL1},
            "3 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/300 monsters with tears.",
            req = 300
        },
        energyReq = 20,
        cooldown = 3
    },
    osseousMeridion = {
        name = "Osseous Meridion",
        type = "meridion",
        desc = {
            {"70 energy:", PST.kcolors.TEAL1},
            {"   Floors 1-3: Spawn 2 friendly Bonys, up to 3 times per floor.", PST.kcolors.TEAL1},
            {"   Floors 4-6: Spawn 3 friendly Bonys, up to 3 times per floor.", PST.kcolors.TEAL1},
            {"   Floors 7-9: Spawn 1 friendly Holy Bony, once per floor.", PST.kcolors.TEAL1},
            {"   Floors 10+: Spawn 1 friendly Holy Bony, up to twice per floor.", PST.kcolors.TEAL1},
            "5 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/100 Bonys or its variants.",
            req = 100
        },
        energyReq = 70,
        cooldown = 5
    },
    monstrousMeridion = {
        name = "Monstrous Meridion",
        type = "meridion",
        desc = {
            {"50 energy: Trigger Monster Manual's effect, up to 4 times per floor.", PST.kcolors.TEAL1},
            "3 second artifact cooldown."
        },
        objective = {
            desc = "Clear {{progress}}/20 boss rooms while having at least 6 familiars.",
            req = 20
        },
        energyReq = 50,
        cooldown = 3
    },
    brimMeridion = {
        name = "Brim Meridion",
        type = "meridion",
        desc = {
            {"45 energy: Inflict every monster in the room with Hemoptysis' curse for 7 seconds,", PST.kcolors.TEAL1},
            {"once per room.", PST.kcolors.TEAL1},
            "No artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/200 monsters with lasers.",
            req = 200
        },
        energyReq = 45
    },
    executionerMeridion = {
        name = "Executioner Meridion",
        type = "meridion",
        desc = {
            {"60 energy: For 8 seconds, your hits will execute monsters below 15% HP.", PST.kcolors.TEAL1},
            "4 second artifact cooldown."
        },
        objective = {
            desc = "Defeat 2 final bosses within the same run {{progress}}/3 times.",
            req = 3
        },
        energyReq = 60,
        cooldown = 4
    },
    blastingMeridion = {
        name = "Blasting Meridion",
        type = "meridion",
        desc = {
            {"60 energy: Trigger XVI - The Tower's effect and become immune to explosions for 4 seconds,", PST.kcolors.TEAL1},
            {"up to twice per room.", PST.kcolors.TEAL1},
            "5 second artifact cooldown."
        },
        objective = {
            desc = "Win a run with the Circadian Destructor ancient starcursed jewel equipped.",
            req = 1
        },
        energyReq = 60,
        cooldown = 5
    },
    gildedMeridion = {
        name = "Gilded Meridion",
        type = "meridion",
        desc = {
            {"50 energy: For 7 seconds, killing enemies will drop double pennies that vanish in 3 seconds, once", PST.kcolors.TEAL1},
            {"per room.", PST.kcolors.TEAL1},
            "5 second artifact cooldown."
        },
        objective = {
            desc = "Purchase 12 items within the same run.",
            req = 1
        },
        energyReq = 50,
        cooldown = 5
    },
    smelterMeridion = {
        name = "Smelter Meridion",
        type = "meridion",
        desc = {
            {"200 energy: Smelt a random trinket you don't currently have for the current floor, up to 3 per floor.", PST.kcolors.TEAL1},
            "3 second artifact cooldown."
        },
        objective = {
            desc = "Win a run with at least 4 smelted trinkets.",
            req = 4
        },
        energyReq = 200,
        cooldown = 3
    },
    siderealMeridion = {
        name = "Sidereal Meridion",
        type = "meridion",
        desc = {
            {"200 energy: Spawn a Sidereal Cache, up to 5 times per floor.", PST.kcolors.TEAL1},
            "3 second artifact cooldown."
        },
        objective = {
            desc = "Open {{progress}}/40 Sidereal Caches.",
            req = 40
        },
        energyReq = 200,
        cooldown = 3
    },
    snakeyeMeridion = {
        name = "Snake-Eye Meridion",
        type = "meridion",
        desc = {
            {"250 energy: Spawn a Dice Shard, up to 3 times per floor.", PST.kcolors.TEAL1},
            "5 second artifact cooldown."
        },
        objective = {
            desc = "Use dice active items {{progress}}/40 times.",
            req = 40
        },
        energyReq = 250,
        cooldown = 5
    },
    bloodmoonMeridion = {
        name = "Bloodmoon Meridion",
        type = "meridion",
        desc = {
            {"350 energy: Spawn a Cracked Key. 6% chance to reveal the Ultra Secret Room on trigger.", PST.kcolors.TEAL1},
            "5 second artifact cooldown."
        },
        objective = {
            desc = "Enter the Ultra Secret Room {{progress}}/5 times.",
            req = 5
        },
        energyReq = 350,
        cooldown = 5
    }
}

function PST:isSideArtiUnlocked(artiName)
    if not PST.sideArtiData[artiName] then return false end
    if not PST.sideArtiData[artiName].objective then return true end
    local unlockProg = PST.modData.sideArtiUnlockProg[artiName]
    return unlockProg ~= nil and unlockProg >= PST.sideArtiData[artiName].objective.req
end

-- Add progress to the given Sidereal Artifact's unlock objective, up to the objective requirement
function PST:sideArtiObjProgress(artiName, prog, set)
    local sideArtiData = PST.sideArtiData[artiName]
    if sideArtiData and sideArtiData.objective then
        if not PST.modData.sideArtiUnlockProg[artiName] then
            PST.modData.sideArtiUnlockProg[artiName] = 0
        end
        PST.modData.sideArtiUnlockProg[artiName] = math.min(sideArtiData.objective.req, PST.modData.sideArtiUnlockProg[artiName] + prog)
        if set then
            PST.modData.sideArtiUnlockProg[artiName] = math.min(sideArtiData.objective.req, prog)
        end
    end
end

function PST:sideArtiAddEnergy(energy)
    if PST:isRunSidereal() and PST.specialNodes.sideArtiCD == 0 then
        PST:addModifiers({ sideArtiEnergy = energy }, true)
        local newEnergy = PST:getTreeSnapshotMod("sideArtiEnergy", 0)

        -- Meridional Artifact effects
        for tmpArti, artiData in pairs(PST.sideArtiData) do
            if artiData.type == "meridion" and PST:getTreeSnapshotMod(tmpArti, false) and newEnergy >= artiData.energyReq then
                if artiData.cooldown and artiData.cooldown > 0 then
                    PST.specialNodes.sideArtiCD = artiData.cooldown * 30
                end
                PST:addModifiers({ sideArtiEnergy = { value = 0, set = true } }, true)

                if PST.config.sideArtiText then
                    PST:createFloatTextFX(artiData.name, Vector(0, 8), PST:RGBColor(80, 255, 255), 0.12, 90, true)
                end
                SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_STRONG, 0.5, 2, false, 1.2)

                -- Galvanic Meridion
                if tmpArti == "galvanicMeridion" then
                    if PST.specialNodes.arti_galvanicBuffTimer == 0 then
                        PST:updateCacheDelayed()
                    end
                    PST.specialNodes.arti_galvanicBuffTimer = 150

                -- Glacial Meridion
                elseif tmpArti == "glacialMeridion" then
                    PST:getPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, UseFlag.USE_NOANIM)

                -- Smiting Meridion
                elseif tmpArti == "smitingMeridion" then
                    if PST.specialNodes.arti_smitingProcs < 4 then
                        local tmpMobs = Isaac.GetRoomEntities()
                        for _, tmpMob in ipairs(tmpMobs) do
                            local tmpNPC = tmpMob:ToNPC()
                            if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
                                local tmpDmg = 5 + PST:getLevel():GetStage() - 1 + tmpNPC.MaxHitPoints * 0.07
                                tmpNPC:TakeDamage(tmpDmg, 0, EntityRef(PST:getPlayer()), 0)
                            end
                        end
                        PST.specialNodes.arti_smitingProcs = PST.specialNodes.arti_smitingProcs + 1
                    end

                -- Infectious Meridion
                elseif tmpArti == "infectiousMeridion" then
                    local charData = PST:getCurrentCharData()
                    local tmpPlayer = PST:getPlayer()
                    local pulseSprite = PST:createAnimFXAt("gfx/1000.164_siren ring.anm2", "Idle", tmpPlayer.Position)
                    pulseSprite.Color = Color(1, 1, 1, 1)
                    pulseSprite.PlaybackSpeed = 1.5
                    pulseSprite.Scale = Vector(0.8, 0.8)
                    SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.8, 2, false, 1.3 + 0.2 * math.random())

                    if charData then
                        local nearbyEnem = Isaac.FindInRadius(tmpPlayer.Position, 200, EntityPartition.ENEMY)
                        for _, tmpEnemy in ipairs(nearbyEnem) do
                            if tmpEnemy:IsActiveEnemy(false) and tmpEnemy:IsVulnerableEnemy() and not EntityRef(tmpEnemy).IsFriendly then
                                local pickedStatus = PST:getTreeSnapshotMod("infMeridionStatus", "")
                                if pickedStatus == "poison" then
                                    tmpEnemy:AddPoison(EntityRef(tmpPlayer), 120, math.min(tmpPlayer.Damage, 20))
                                elseif pickedStatus == "fear" then
                                    tmpEnemy:AddFear(EntityRef(tmpPlayer), 120)
                                elseif pickedStatus == "charm" then
                                    tmpEnemy:AddCharmed(EntityRef(tmpPlayer), 120)
                                elseif pickedStatus == "slow" then
                                    tmpEnemy:AddSlowing(EntityRef(tmpPlayer), 120, 0.8, Color(0.8, 0.8, 0.8, 1))
                                elseif pickedStatus == "burn" then
                                    tmpEnemy:AddBurn(EntityRef(tmpPlayer), 120, math.min(tmpPlayer.Damage, 20))
                                end
                                local tmpDmg = 7 + PST:getLevel():GetStage() - 1
                                tmpEnemy:TakeDamage(tmpDmg, 0, EntityRef(tmpPlayer), 0)
                            end
                        end
                    end

                -- Virtuous Meridion
                elseif tmpArti == "virtuousMeridion" then
                    if PST:getTreeSnapshotMod("arti_virtuousWisps", 0) < 5 then
                        PST:addModifiers({ arti_virtuousWisps = 1 }, true)
                        PST:addRandomWisp()
                    end

                -- Stone Meridion
                elseif tmpArti == "stoneMeridion" then
                    local tmpEnemy = nil
                    local tmpHP = 0
                    for _, tmpMob in ipairs(Isaac.GetRoomEntities()) do
                        local tmpNPC = tmpMob:ToNPC()
                        if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly and
                        tmpNPC.MaxHitPoints > tmpHP then
                            tmpHP = tmpNPC.MaxHitPoints
                            tmpEnemy = tmpNPC
                        end
                    end
                    if tmpEnemy then
                        tmpEnemy:AddFreeze(EntityRef(PST:getPlayer()), 210)
                    end

                -- Infernal Meridion
                elseif tmpArti == "infernalMeridion" then
                    for _, tmpMob in ipairs(Isaac.GetRoomEntities()) do
                        local tmpNPC = tmpMob:ToNPC()
                        if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
                            tmpNPC:AddBurn(EntityRef(PST:getPlayer()), 180, math.min(PST:getPlayer().Damage, 20))
                            PST:addModifiers({ arti_infernalProc = true }, true)
                        end
                    end

                -- Dead Sea Meridion
                elseif tmpArti == "deadSeaMeridion" then
                    if PST.specialNodes.arti_deadSeaProcs < 4 then
                        PST:getPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS, UseFlag.USE_NOANIM)
                        PST.specialNodes.arti_deadSeaProcs = PST.specialNodes.arti_deadSeaProcs + 1
                    end

                -- Flowing Meridion
                elseif tmpArti == "flowingMeridion" then
                    PST:getPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_ISAACS_TEARS, UseFlag.USE_NOANIM)

                -- Osseous Meridion
                elseif tmpArti == "osseousMeridion" then
                    local tmpStage = PST:getLevel():GetStage()
                    if tmpStage <= 6 then
                        if PST:getTreeSnapshotMod("arti_osseousProcs", 0) < 3 then
                            PST:addModifiers({ arti_osseousProcs = 1 }, true)

                            local maxSpawns = 2
                            if tmpStage > 3 then maxSpawns = 3 end
                            for _=1,maxSpawns do
                                local tmpPos = Isaac.GetFreeNearPosition(PST:getPlayer().Position, 10)
                                local newBony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, tmpPos, Vector.Zero, nil)
                                newBony:AddCharmed(EntityRef(PST:getPlayer()), -1)
                            end
                        end
                    else
                        local maxProcs = 1
                        if tmpStage >= 10 then maxProcs = 2 end
                        if PST:getTreeSnapshotMod("arti_osseousProcs", 0) < maxProcs then
                            PST:addModifiers({ arti_osseousProcs = 1 }, true)

                            local tmpPos = Isaac.GetFreeNearPosition(PST:getPlayer().Position, 10)
                            local newBony = Isaac.Spawn(EntityType.ENTITY_BONY, 1, 0, tmpPos, Vector.Zero, nil)
                            newBony:AddCharmed(EntityRef(PST:getPlayer()), -1)
                        end
                    end

                -- Monstrous Meridion
                elseif tmpArti == "monstrousMeridion" then
                    if PST:getTreeSnapshotMod("arti_monstrousProcs", 0) < 4 then
                        PST:getPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, UseFlag.USE_NOANIM)
                        PST:addModifiers({ arti_monstrousProcs = 1 }, true)
                    end

                -- Brim Meridion
                elseif tmpArti == "brimMeridion" then
                    if not PST.specialNodes.arti_brimProc then
                        PST.specialNodes.arti_brimProc = true
                        for _, tmpMob in ipairs(Isaac.GetRoomEntities()) do
                            local tmpNPC = tmpMob:ToNPC()
                            if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
                                tmpNPC:AddBrimstoneMark(EntityRef(PST:getPlayer()), 210)
                            end
                        end
                    end

                -- Executioner Meridion
                elseif tmpArti == "executionerMeridion" then
                    SFXManager():Play(SoundEffect.SOUND_SIREN_SING_STAB, 0.4, 2, false, 1.3)
                    PST.specialNodes.arti_executionerBuffTimer = 240

                -- Blasting Meridion
                elseif tmpArti == "blastingMeridion" then
                    if PST:getTreeSnapshotMod("arti_blastingProcs", 0) < 2 then
                        PST:addModifiers({ arti_blastingProcs = 1 }, true)
                        PST:getPlayer():UseCard(Card.CARD_TOWER, UseFlag.USE_NOANIM)
                        PST.specialNodes.explosionImmunityTimer = 120
                    end

                -- Gilded Meridion
                elseif tmpArti == "gildedMeridion" then
                    if not PST:getTreeSnapshotMod("arti_gildedProc", false) then
                        PST.specialNodes.arti_gildedTimer = 210
                        SFXManager():Play(SoundEffect.SOUND_GOLD_HEART, 0.4, 2, false, 1.3)
                        PST:addModifiers({ arti_gildedProc = true }, true)
                    end

                -- Smelter Meridion
                elseif tmpArti == "smelterMeridion" then
                    if PST:getTreeSnapshotMod("arti_smelterProcs", 0) < 3 then
                        local newTrinket = Game():GetItemPool():GetTrinket()
                        local smeltedTrinkets = PST:getPlayer():GetSmeltedTrinkets()
                        local failsafe = 0
                        while (smeltedTrinkets[newTrinket] and (smeltedTrinkets[newTrinket].trinketAmount > 0 or smeltedTrinkets[newTrinket].goldenTrinketAmount > 0)) and failsafe < 200 do
                            newTrinket = Game():GetItemPool():GetTrinket()
                            failsafe = failsafe + 1
                        end
                        if failsafe < 200 then
                            PST:getPlayer():AddSmeltedTrinket(newTrinket)
                            PST:addModifiers({ arti_smelterProcs = 1 }, true)
                        end
                    end

                -- Sidereal Meridion
                elseif tmpArti == "siderealMeridion" then
                    if PST:getTreeSnapshotMod("arti_siderealProcs", 0) < 5 then
                        local tmpPos = Isaac.GetFreeNearPosition(PST:getPlayer().Position, 20)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, Isaac.GetEntityVariantByName("Sidereal Cache"), 0, tmpPos, Vector.Zero, nil)
                        SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 2, false, 1.2)
                        PST:addModifiers({ arti_siderealProcs = 1 }, true)
                    end

                -- Snake-Eye Meridion
                elseif tmpArti == "snakeyeMeridion" then
                    if PST:getTreeSnapshotMod("arti_snakeyeProcs", 0) < 3 then
                        local tmpPos = Isaac.GetFreeNearPosition(PST:getPlayer().Position, 20)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD, tmpPos, Vector.Zero, nil)
                        PST:addModifiers({ arti_snakeyeProcs = 1 }, true)
                    end

                -- Bloodmoon Meridion
                elseif tmpArti == "bloodmoonMeridion" then
                    local tmpPos = Isaac.GetFreeNearPosition(PST:getPlayer().Position, 20)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, tmpPos, Vector.Zero, nil)
                    if 100 * math.random() < 6 then
                        -- Reveal Ultra Secret Room
                        local level = PST:getLevel()
                        local roomIdx = level:QueryRoomTypeIndex(RoomType.ROOM_ULTRASECRET, false, RNG())
                        local ultraSecretRoom = level:GetRoomByIdx(roomIdx)
                        if ultraSecretRoom and ultraSecretRoom.Data.Type == RoomType.ROOM_ULTRASECRET then
                            ultraSecretRoom.DisplayFlags = 1 << 2
                            level:UpdateVisibility()
                            if PST.config.sideArtiText then
                                PST:createFloatTextFX("The Blood Moon Reveals...", Vector(0, 8), PST:RGBColor(200, 55, 55), 0.12, 180, true)
                            end
                        end
                    end
                end
                break
            end
        end
    end
end