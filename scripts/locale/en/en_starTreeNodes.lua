return {
    ---- STAR TREE NODE MODIFIERS ----
    ["node_startree_lite"] = "Begin your communion with the stars.",

    ["node_azuresocket1_name"] = "Azure Socket 1",
    ["node_azuresocket2_name"] = "Azure Socket 2",
    ["node_azuresocket3_name"] = "Azure Socket 3",
    ["node_azuresocket4_name"] = "Azure Socket 4",
    ["node_azuresocket"] = "Once allocated, you may socket Azure Starcursed Jewels here.",
    ["node_azurestarmight_name"] = "Azure Starmight",
    ["node_azurestarmight"] = "+{{azureStarmight}} starmight per socketed Azure Starcursed Jewel.",
    ["node_azureinv_name"] = "Azure Inventory",
    ["node_azureinv"] = {
        "Allocate to unlock the Azure Starcursed Jewel inventory.",
        "Once allocated, press allocate again to open inventory.",
        "Azure Starcursed Jewels can roll modifiers that affect monsters' might."
    },

    ["node_crimsonsocket1_name"] = "Crimson Socket 1",
    ["node_crimsonsocket2_name"] = "Crimson Socket 2",
    ["node_crimsonsocket3_name"] = "Crimson Socket 3",
    ["node_crimsonsocket4_name"] = "Crimson Socket 4",
    ["node_crimsonsocket"] = "Once allocated, you may socket Crimson Starcursed Jewels here.",
    ["node_crimsonstarmight_name"] = "Crimson Starmight",
    ["node_crimsonstarmight"] = "+{{crimsonStarmight}} starmight per socketed Crimson Starcursed Jewel.",
    ["node_crimsoninv_name"] = "Crimson Inventory",
    ["node_crimsoninv"] = {
        "Allocate to unlock the Crimson Starcursed Jewel inventory.",
        "Once allocated, press allocate again to open inventory.",
        "Crimson Starcursed Jewels can roll modifiers that affect monsters' vitality."
    },

    ["node_viridiansocket1_name"] = "Viridian Socket 1",
    ["node_viridiansocket2_name"] = "Viridian Socket 2",
    ["node_viridiansocket3_name"] = "Viridian Socket 3",
    ["node_viridiansocket4_name"] = "Viridian Socket 4",
    ["node_viridiansocket"] = "Once allocated, you may socket Viridian Starcursed Jewels here.",
    ["node_viridianstarmight_name"] = "Viridian Starmight",
    ["node_viridianstarmight"] = "+{{viridianStarmight}} starmight per socketed Viridian Starcursed Jewel.",
    ["node_viridianinv_name"] = "Viridian Inventory",
    ["node_viridianinv"] = {
        "Allocate to unlock the Viridian Starcursed Jewel inventory.",
        "Once allocated, press allocate again to open inventory.",
        "Viridian Starcursed Jewels can roll modifiers that affects the run directly."
    },

    ["node_ancientsocket1_name"] = "Ancient Socket 1",
    ["node_ancientsocket2_name"] = "Ancient Socket 2",
    ["node_ancientsocket"] = "Once allocated, you may socket Ancient Starcursed Jewels here.",
    ["node_ancientstarmight_name"] = "Ancient Starmight",
    ["node_ancientstarmight"] = "+{{ancientStarmight}} starmight per socketed Ancient Starcursed Jewel.",
    ["node_ancientinv_name"] = "Ancient Inventory",
    ["node_ancientinv"] = {
        "Allocate to unlock the Ancient Starcursed Jewel inventory.",
        "Once allocated, press allocate again to open inventory.",
        "Ancient Starcursed Jewels can roll unique run-altering modifiers."
    },


    ---- EXPEDITION NODES ----
    ["node_arcaneastrolabe_name"] = "Arcane Astrolabe",
    ["node_arcaneastrolabe"] = {
        "Unlocks Astral Expeditions.",
        "Once allocated, press the Allocate button to access the expeditions menu.",
        "Access requires the currently selected character to be level 60+."
    },

    ["node_siderealtree_name"] = "Sidereal Tree",
    ["node_siderealtree"] = {
        "Unlocks the Sidereal Tree.",
        "Each character has their own Sidereal Tree progression.",
        "Utilize Arcane Obols from Astral Expeditions to unlock new features and power for",
        "the currently selected character.",
        "Initially this tree applies exclusively to expedition runs, but further unlocks",
        "allow applying its features to all runs."
    },

    ["node_deepspaceastrolabe_name"] = "Deep-Space Astrolabe",
    ["node_deepspaceastrolabe"] = {
        "Allocate to unlock Uber Expeditions, a more challenging variant of expeditions.",
        "Once allocated, a toggle button will appear in the Astrolabe menu.",
        "Gain Deep-Space Skill Points by completing uber expedition nodes.",
        "Every 2 nodes in an uber expedition, as well as the final node, grant 1 Deep-Space SP."
    },
    ["dsnode_finalboss_sp_name"] = "Final Boss Global SP",
    ["dsnode_finalboss_sp"] = "{{finalBossGSP}}% chance to gain a Global Skill Point when defeating a final boss without taking damage.",
    ["dsnode_addrewardchoice_name"] = "Additional Reward Choice",
    ["dsnode_addrewardchoice"] = "{{expedChoiceAdd}}% chance for choice reward nodes to include an additional choice.",
    ["dsnode_oboldrops_name"] = "Obol Drops",
    ["dsnode_oboldrops"] = "+{{obolsFound}}% Obols dropped in expedition runs.",
    ["dsnode_uberoboldrops_name"] = "Uber Obols Found",
    ["dsnode_uberoboldrops"] = "+{{obolsFoundUber}}% Obols dropped in uber expedition runs.",
    ["dsnode_entropicobols_name"] = "Uber Entropic Obols Found",
    ["dsnode_entropicobols"] = "+{{obolsFoundEntropy}}% Obols dropped in uber expedition runs per entropy.",
    ["dsnode_uberxp_name"] = "Uber XP Gain",
    ["dsnode_uberxp"] = "+{{xpgainUber}}% XP gain in uber expedition runs.",
    ["dsnode_orderfreq_name"] = "Order Node Frequency",
    ["dsnode_orderfreq"] = "+{{orderNodeFreq}}% chance for nodes with Order as a reward to show up.",
    ["dsnode_ordergain_name"] = "Order Gain",
    ["dsnode_ordergain"] = {
        "+{{orderGain}}% Order gained from node rewards.",
        "This effect is applied when generating an uber expedition run while allocated."
    },
    ["dsnode_entropygainred_name"] = "Entropy Gain Reduction",
    ["dsnode_entropygainred"] = "Whenever you gain entropy, {{entropyGainRed}}% chance to reduce gained amount by 1.",
    ["dsnode_obolsharing_name"] = "Obol Sharing",
    ["dsnode_obolsharing"] = "When picking up obols, +{{obolSharing}}% chance to grant 33% of the gained obols to all other characters.",

    ["dsnode_entropictradeoff_name"] = "Entropic Tradeoff",
    ["dsnode_entropictradeoff"] = {
        "Uber expeditions start with 40 entropy.",
        "You can only gain up to 20 entropy per run, or 40 if you have Eldritch Exchange.",
        "This effect is applied when generating an uber expedition run while allocated."
    },
    ["dsnode_bringthechaos_name"] = "Bring The Chaos",
    ["dsnode_bringthechaos"] = {
        "While an uber expedition has at least 100 entropy, +30% Obols dropped and +30% xp gain.",
        "While an uber expedition has at least 150 entropy, +12% ancient weapon drop rate.",
        "While an uber expedition has at least 200 entropy, 20% chance to gain a Crimson Starcore",
        "when defeating a final boss, once per run.",
        "{{orderGain}}% order gained from nodes."
    },
    ["dsnode_bringtheorder_name"] = "Bring The Order",
    ["dsnode_bringtheorder"] = {
        "Uber expeditions start with 50 order.",
        "While you have at least 30 order, losing a run doesn't subtract attempts from the",
        "uber expedition.",
        "Whenever you gain entropy, 25% chance to gain none instead.",
        "-0.03 luck per order, applied once when beginning a run.",
        "This effect is applied when generating an uber expedition run while allocated."
    },
    ["dsnode_eldritchexchange_name"] = "Eldritch Exchange",
    ["dsnode_eldritchexchange"] = {
        "Gain twice as much entropy from uber expedition node modifiers.",
        "+2 initial uber expedition attempts.",
        "No longer lose max attempts from entropy effects.",
        "This effect is applied when generating an uber expedition run while allocated."
    },
    ["dsnode_obscurebazaar_name"] = "Obscure Bazaar",
    ["dsnode_obscurebazaar"] = {
        "Once allocated, press Allocate again to access the Obscure Bazaar.",
        "This shop allows exchanging large amounts of obols for rare items."
    },
    ["dsnode_obscurebazaardisc_name"] = "Obscure Bazaar Discount",
    ["dsnode_obscurebazaardisc"] = "{{obsBazaarDiscount}}% reduced obol costs in the Obscure Bazaar.",
    ["dsnode_cosmicaltruism_name"] = "Cosmic Altruism",
    ["dsnode_cosmicaltruism"] = {
        "Increase rate of obols shared to other characters to 70%.",
        "{{obolsFound}}% Obols dropped in expedition runs."
    }
}