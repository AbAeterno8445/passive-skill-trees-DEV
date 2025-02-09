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
            {"Generates 2 energy per used charge.", PST.kcolors.TEAL1}
        },
        objective = {
            desc = "Use an active item with at least 1 charge in rooms with monsters {{progress}}/30 times.",
            req = 30
        },
        energy = 2
    },

    ---- MERIDIONS ----
    galvanicMeridion = {
        name = "Galvanic Meridion",
        type = "meridion",
        desc = { -- TODO
            {"15 energy: Gain 5% all stats for 5 seconds.", PST.kcolors.TEAL1},
            "No artifact cooldown.",
        },
        energyReq = 15
    },
    glacialMeridion = {
        name = "Glacial Meridion",
        type = "meridion",
        desc = { -- TODO
            {"20 energy: Slow all enemies in the room for 4 seconds.", PST.kcolors.TEAL1},
            "4 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/40 slowed enemies.",
            req = 40
        },
        energyReq = 20,
        cooldown = 4
    },
    smitingMeridion = {
        name = "Smiting Meridion",
        type = "meridion",
        desc = { -- TODO
            {"35 energy: Damage all enemies in the room for 8 + 5% of their HP, up to 4 times per room.", PST.kcolors.TEAL1},
            "5 second artifact cooldown."
        },
        objective = {
            desc = "Clear {{progress}}/30 rooms within 7 seconds each.",
            req = 30
        },
        energyReq = 35,
        cooldown = 5
    },
    infectiousMeridion = {
        name = "Infectious Meridion",
        type = "meridion",
        desc = { -- TODO
            {"25 energy: Generate a pulse that damages nearby enemies and inflicts a status effect on them", PST.kcolors.TEAL1},
            {"for 4 seconds.", PST.kcolors.TEAL1},
            "4 second artifact cooldown",
            "Once allocated, press Allocate to choose the status effect the pulse inflicts. Causes poison by default."
        },
        objective = {
            desc = "Inflict status effects on non-boss enemies {{progress}}/200 times.",
            req = 200
        },
        energyReq = 25,
        cooldown = 4
    },
    virtuousMeridion = {
        name = "Virtuous Meridion",
        type = "meridion",
        desc = { -- TODO
            {"40 energy: Generate a random orbiting Wisp to assist you, up to 8 times per floor.", PST.kcolors.TEAL1},
            "8 second artifact cooldown."
        },
        objective = {
            desc = "Kill {{progress}}/15 boss monsters with familiar damage.",
            req = 15
        },
        energyReq = 40,
        cooldown = 8
    },
    stoneMeridion = {
        name = "stoneMeridion",
        type = "meridion",
        desc = { -- TODO
            {"30 energy: Petrify a random enemy in the room for 6 seconds, prioritizing enemies with the", PST.kcolors.TEAL1},
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
        desc = { -- TODO
            {"90 energy:", PST.kcolors.TEAL1},
            {"   Inflict burning on all enemies in the room for 5 seconds.", PST.kcolors.TEAL1},
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
        desc = { -- TODO
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
        desc = { -- TODO
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
        desc = { -- TODO
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
        desc = { -- TODO
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
        desc = { -- TODO
            {"45 energy: Inflict every monster in the room with Hemoptysis' curse, once per room.", PST.kcolors.TEAL1},
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
        desc = { -- TODO
            {"60 energy: For 6 seconds, your hits will execute monsters below 12% HP.", PST.kcolors.TEAL1},
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
        desc = { -- TODO
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
        desc = { -- TODO
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
        desc = { -- TODO
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
        desc = { -- TODO
            {"200 energy: Spawn a Sidereal Cache, up to 5 times per floor.", PST.kcolors.TEAL1},
            "3 second artifact cooldown."
        },
        objective = {
            desc = "Open {{progress}}/40 Sidereal Caches.",
            req = 40
        },
        energyReq = 200,
        cooldown = 3
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
    if PST.specialNodes.sideArtiCD == 0 then
        --PST:addModifiers({ sideArtiEnergy = energy }, true)
        print("Sidereal Artifact: generated", energy, "energy.")
    end
end