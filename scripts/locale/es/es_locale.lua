local spanishLocale = {}

local function includeLocaleFile(localeData)
    for tmpKey, tmpText in pairs(localeData) do
        spanishLocale[tmpKey] = tmpText
    end
end
includeLocaleFile(include("scripts.locale.es.es_globalTreeNodes"))
includeLocaleFile(include("scripts.locale.es.es_charTreeNodes"))
includeLocaleFile(include("scripts.locale.es.es_taintedTreeNodes"))
includeLocaleFile(include("scripts.locale.es.es_astralForge"))
includeLocaleFile(include("scripts.locale.es.es_expeditions"))
includeLocaleFile(include("scripts.locale.es.es_starTreeNodes"))
includeLocaleFile(include("scripts.locale.es.es_starcursed"))
includeLocaleFile(include("scripts.locale.es.es_siderealArtifact"))
includeLocaleFile(include("scripts.locale.es.es_siderealTreeNodes"))
includeLocaleFile(include("scripts.locale.es.es_ui"))

return spanishLocale