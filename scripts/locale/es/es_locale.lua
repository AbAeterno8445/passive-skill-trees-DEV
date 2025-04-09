local spanishLocale = {}

local function includeLocaleFile(localeData)
    for tmpKey, tmpText in pairs(localeData) do
        spanishLocale[tmpKey] = tmpText
    end
end
includeLocaleFile(include("scripts.locale.es.es_globalTreeNodes"))
includeLocaleFile(include("scripts.locale.es.es_charTreeNodes"))

return spanishLocale