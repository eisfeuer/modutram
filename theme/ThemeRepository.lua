local optional = require("modutram.helper.optional")

local ThemeRepository = {}

function ThemeRepository:new(o)
    o = o or {}

    o.themes = {}
    o.years = {}
    o.extends = {}
    o.translations = {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function ThemeRepository:addModule(moduleName, conModule)
    local themes = self:getModuleMetadataParam(conModule, "themes")
    local themeType = self:getModuleMetadataParam(conModule, "themeType")
    local widthInCm = self:getModuleMetadataParam(conModule, "widthInCm")
    local yearFrom = optional(conModule.availability).yearFrom or 0
    local extends = self:getModuleMetadataParam(conModule, "themeExtends")
    local translations = self:getModuleMetadataParam(conModule, "themeTranslations") or {}
    
    if not (themes and themeType) then
        return
    end

    for _, theme in pairs(themes) do
        self:addTheme(theme, themeType, moduleName, widthInCm)
        self:addYear(theme, yearFrom)
        if extends then
            self.extends[theme] = extends
        end
        for themeName, translation in pairs(translations) do
            self.translations[themeName] = translation
        end
    end
end

function ThemeRepository:getDefaultTheme()
    return self.themes[self.defaultTheme]
end

function ThemeRepository:addTheme(theme, themeType, moduleName, widthInCm)
    if not self.themes[theme] then
        self.themes[theme] = {}
    end

    self.themes[theme][themeType] = {
        moduleName = moduleName,
        widthInCm = widthInCm
    }
end

function ThemeRepository:getRepositoryTable()
    local repository = {}

    for _, theme in pairs(self:getThemeSort()) do
        table.insert(repository, self:extendTheme(theme.theme))
    end

    return repository
end

function ThemeRepository:getConstructionParams()
    local params = {}

    local sortedThemes = self:getThemeSort()
    if #sortedThemes == 0 then
        return {}
    end

    for i, theme in ipairs(sortedThemes) do
        local yearFrom = theme.year
        local yearTo = optional(sortedThemes[i + 1]).year or 0

        if yearFrom ~= yearTo then
            local values = {}
            for _, value in pairs(sortedThemes) do
                if yearTo == 0 or value.year < yearTo then
                    table.insert(values, self.translations[value.theme] or value.theme)
                end
            end

            table.insert(params, {
                key = "modutram_theme",
                name = self.paramName,
                values = values,
                uiType = "COMBOBOX",
                defaultIndex = 0,
                yearFrom = yearFrom,
                yearTo = yearTo,
            })
        end
    end

    return params
end

function ThemeRepository:extendTheme(theme)
    if not theme then
        return {}
    end

    local extended = self:extendTheme(self.extends[theme])

    for key, value in pairs(self.themes[theme] or {}) do
        extended[key] = value
    end

    return extended
end

function ThemeRepository:getThemeSort()
    local themeTable = {}

    for theme, year in pairs(self.years) do
        table.insert(themeTable, {theme = theme, year = year})
    end

    table.sort(themeTable, function (a, b)
        if a.year == b.year then
            return a.theme < b.theme
        end

        return a.year < b.year
    end)

    return themeTable
end

function ThemeRepository:addYear(theme, year)
    if not self.years[theme] then
        self.years[theme] = year
        return
    end

    self.years[theme] = math.max(self.years[theme], year)
end

function ThemeRepository:getModuleMetadataParam(conModule, key)
    if not conModule.metadata then
        return nil
    end

    if conModule.metadata["modutram_" .. key] then
        return conModule.metadata["modutram_" .. key]
    end

    return optional(conModule.metadata.modutram)[key]
end

return ThemeRepository