local englishLocale = {}

local function includeLocaleFile(localeData)
    for tmpKey, tmpText in pairs(localeData) do
        englishLocale[tmpKey] = tmpText
    end
end
includeLocaleFile(include("scripts.locale.en.en_globalTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_charTreeNodes"))
includeLocaleFile(include("scripts.locale.en.en_taintedTreeNodes"))

return englishLocale