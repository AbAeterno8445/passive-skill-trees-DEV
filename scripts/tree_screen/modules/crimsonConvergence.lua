PST.crimConvergenceBuffs = {
    mundaneSlaughter = {
        name = PST:getLocalized("ui_crimconv_mundaneSlaughter"),
        desc = PST:getLocalized("ui_crimconv_mundaneSlaughter_desc")
    },
    giantSlaughter = {
        name = PST:getLocalized("ui_crimconv_giantSlaughter"),
        desc = PST:getLocalized("ui_crimconv_giantSlaughter_desc")
    },
    titanSlaughter = {
        name = PST:getLocalized("ui_crimconv_titanSlaughter"),
        desc = PST:getLocalized("ui_crimconv_titanSlaughter_desc")
    },
    blightseeking = {
        name = PST:getLocalized("ui_crimconv_blightseeking"),
        desc = PST:getLocalized("ui_crimconv_blightseeking_desc")
    },
    celerity = {
        name = PST:getLocalized("ui_crimconv_celerity"),
        desc = PST:getLocalized("ui_crimconv_celerity_desc")
    },
    bloodshield = {
        name = PST:getLocalized("ui_crimconv_bloodshield"),
        desc = PST:getLocalized("ui_crimconv_bloodshield_desc")
    },
    abundanceGoods = {
        name = PST:getLocalized("ui_crimconv_abundanceGoods"),
        desc = PST:getLocalized("ui_crimconv_abundanceGoods_desc")
    },
    abundanceVitality = {
        name = PST:getLocalized("ui_crimconv_abundanceVitality"),
        desc = PST:getLocalized("ui_crimconv_abundanceVitality_desc")
    },
    sanguineCharges = {
        name = PST:getLocalized("ui_crimconv_sanguineCharges"),
        desc = PST:getLocalized("ui_crimconv_sanguineCharges_desc")
    },
    fortuna = {
        name = PST:getLocalized("ui_crimconv_fortuna"),
        desc = PST:getLocalized("ui_crimconv_fortuna_desc")
    },
    starstruck = {
        name = PST:getLocalized("ui_crimconv_starstruck"),
        desc = PST:getLocalized("ui_crimconv_starstruck_desc")
    }
}
PST.crimConvBuffsLen = 0
for _ in pairs(PST.crimConvergenceBuffs) do
    PST.crimConvBuffsLen = PST.crimConvBuffsLen + 1
end
PST.crimConvBuffOrder = {
    "mundaneSlaughter", "giantSlaughter", "titanSlaughter", "blightseeking", "celerity",
    "bloodshield", "abundanceGoods", "abundanceVitality", "sanguineCharges", "fortuna",
    "starstruck"
}