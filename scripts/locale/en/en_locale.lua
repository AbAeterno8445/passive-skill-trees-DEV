local englishLocale = {}

local function includeLocaleFile(localeData)
    for tmpKey, tmpText in pairs(localeData) do
        englishLocale[tmpKey] = tmpText
    end
end
includeLocaleFile(include("scripts.locale.en.en_globalTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_charTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_taintedTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_starTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_siderealTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_expeditions"))
includeLocaleFile(include("scripts.locale.en.en_starcursed"))
includeLocaleFile(include("scripts.locale.en.en_astralForge"))
includeLocaleFile(include("scripts.locale.en.en_siderealArtifact"))
includeLocaleFile(include("scripts.locale.en.en_ui"))

return englishLocale