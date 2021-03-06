local ThemeRepository = require("modutram.theme.ThemeRepository")

describe("ThemeRepository", function ()
    local repo = ThemeRepository:new{defaultTheme = "default", paramName = "Theme", tooltip = "tooltip"}

    describe("addModule",function ()
        repo:addModule("hamburg_bus_stop_sign.module", {
            metadata = {
                modutram = {
                    themes = { "hamburg" },
                    themeType = "bus_stop_sign",
                    themeTranslations = {
                        hamburg = "Hamburg"
                    }
                }
            },
            availability = {
                yearFrom = 1990
            }
        })
        repo:addModule("shelter_modern.module", {
            metadata = {
                modutram = {
                    themes = { "hamburg", "leipzig" },
                    themeType = "shelter",
                    themeTranslations = {
                        leipzig = "Leipzig"
                    }
                }
            },
            availability = {
                yearFrom = 2001
            }
        })
        repo:addModule("default_bus_stop_sign.module", {
            metadata = {
                modutram = {
                    theme = "default",
                    themeType = "bus_stop_sign"
                }
            }, 
            availability = {
                yearFrom = 1901
            }
        })
        repo:addModule("default_shelter.module", {
            metadata = {
                modutram = {
                    themes = { "default" },
                    themeType = "shelter",
                    widthInCm = 300
                }
            },
            availability = {
                 yearFrom = 1902
            }
        })
        repo:addModule("hha_shelter.module", {
            metadata = {
                modutram_themes = { "hha" },
                modutram_themeTypes = {"shelter", "shelter_large"},
                modutram_themeExtends = "hamburg",
                modutram_widthInCm = 400,
                modutram_themeExcludes = { "bus_stop_sign" }
            },
            availability = {
                yearFrom = 2003
            }
        })
    end)

    describe("getDefaultTheme", function ()
        assert.are.same({
            bus_stop_sign = {
                moduleName = "default_bus_stop_sign.module",
            },
            shelter = {
                moduleName = "default_shelter.module",
                widthInCm = 300
            }
        }, repo:getDefaultTheme())
    end)

    describe("getRepositoryTable", function ()
        assert.are.same({
            {
                bus_stop_sign = {
                    moduleName = "default_bus_stop_sign.module",
                },
                shelter = {
                    moduleName = "default_shelter.module",
                    widthInCm = 300
                },
                metadata = {}
            }, {
                bus_stop_sign = {
                    moduleName = "hamburg_bus_stop_sign.module"
                },
                shelter = {
                    moduleName = "shelter_modern.module"
                },
                metadata = {}
            }, {
                shelter = {
                    moduleName = "shelter_modern.module"
                },
                metadata = {}
            }, {
                bus_stop_sign = {
                    moduleName = "hamburg_bus_stop_sign.module"
                },
                shelter = {
                    moduleName = "hha_shelter.module",
                    widthInCm = 400
                }, 
                shelter_large = {
                    moduleName = "hha_shelter.module",
                    widthInCm = 400
                }, 
                metadata = {
                    excludes = { "bus_stop_sign" }
                }
            }
        }, repo:getRepositoryTable())
    end)

    describe("getConstructionParams", function ()
        assert.are.same({
            {
                key = "modutram_theme",
                name = "Theme",
                values = { "default" },
                uiType = "COMBOBOX",
                defaultIndex = 0,
                yearFrom = 1902,
                yearTo = 2001,
                tooltip = "tooltip"
            }, {
                key = "modutram_theme",
                name = "Theme",
                values = { "default", "Hamburg", "Leipzig" },
                uiType = "COMBOBOX",
                defaultIndex = 0,
                yearFrom = 2001,
                yearTo = 2003,
                tooltip = "tooltip"
            }, {
                key = "modutram_theme",
                name = "Theme",
                values = { "default", "Hamburg", "Leipzig" , "hha"},
                uiType = "COMBOBOX",
                defaultIndex = 0,
                yearFrom = 2003,
                yearTo = 0,
                tooltip = "tooltip"
            }
        }, repo:getConstructionParams())
    end)
end)