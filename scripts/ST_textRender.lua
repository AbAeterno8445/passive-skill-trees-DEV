local locales = {
    en = include("scripts.locale.en.en_locale"),
    es = include("scripts.locale.es.es_locale")
}

-- Fonts
PST.miniFont = Font()
PST.miniFont:Load("font/cjk/lanapixel.fnt")

PST.normalFont = Font()
PST.normalFont:Load("font/terminus8.fnt")

PST.luaminiFont = Font()
PST.luaminiFont:Load("font/luamini.fnt")

PST.lanaPixelFont = Font()
PST.lanaPixelFont:Load("font/cjk/lanapixel.fnt")

-- Switch to compatible fonts when required for certain languages
if Options.Language ~= 'en' then
    PST.luaminiFont = PST.lanaPixelFont
end

-- Can return a single string or a table of strings, depending on multi-lines
---@param text string
---@param lang? string
function PST:getLocalized(text, lang)
    if not lang then lang = Options.Language end
    if PST.config.forceEnglishLocale then lang = 'en' end

    if text:sub(1, 1) == '#' then
        text = text:sub(2)
    end
    local tmpStr
    if locales[lang] and locales[lang][text] then
        tmpStr = locales[lang][text]
    elseif locales.en[text] then
        tmpStr = locales.en[text]
    end
    if not tmpStr then tmpStr = text end
    return tmpStr
end

-- Can return a single string or a table of strings, depending on multi-lines
---@param text string
---@param vals table
---@param lang? string
---@return string|string[]
function PST:getLocalizedFormat(text, vals, lang)
    if not lang then lang = Options.Language end
    if PST.config.forceEnglishLocale then lang = 'en' end

    local newDesc = {}
    local tmpDesc = PST:getLocalized(text, lang)
    if type(tmpDesc) == "table" then
        for _, tmpLine in ipairs(tmpDesc) do
            if type(tmpLine) == "table" then
                table.insert(newDesc, PST:formatString(tmpLine[1], vals or {}))
            else
                table.insert(newDesc, PST:formatString(tmpLine, vals or {}))
            end
        end
    else
        table.insert(newDesc, PST:formatString(tmpDesc, vals or {}))
    end
    if #newDesc == 1 then return newDesc[1] end
    return newDesc
end

--- Always returns a string
---@param text string
---@param vals table
---@param lang? string
---@return string
function PST:getLocalizedFormatStr(text, vals, lang)
    local tmpLocalized = PST:getLocalizedFormat(text, vals, lang)
    if type(tmpLocalized) == "table" then
        return tmpLocalized[1]
    end
    return tmpLocalized
end

-- Returns whether the given localization key/id is defined
function PST:localeIDExists(id, lang)
    if not lang then lang = Options.Language end
    return locales[lang] and locales[lang][id]
end