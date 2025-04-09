local locales = {
    en = include("scripts.locale.en.en_globalTreeNodes"),
    es = include("scripts.locale.es.es_globalTreeNodes")
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

---@param text string
function PST:getLocalized(text, lang)
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

---@param text string
---@param lang string
---@param vals table
---@return string[]
function PST:getLocalizedFormatted(text, lang, vals)
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
    return newDesc
end