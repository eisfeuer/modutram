local Theme = require("modutram.theme.Theme")

describe("Theme", function ()
    local theme = Theme:new{
        theme = {
            platformLeft = {
                moduleName = "hamburg_platform_left.module",
                widthInCm = 300
            },
            metadata = {
                excludes = { "shelter" }
            }
        },
        defaultTheme = {
            platformLeft = {
                moduleName = "platform_left.module",
                widthInCm = 250
            },
            platformRight = {
                moduleName = "platform_right.module",
                widthInCm = 200
            },
            shelter = {
                moduleName = "shelter.module",
            },
            metadata = {}
        }
    }

    describe("get", function ()
        it ("returns theme module", function ()
            assert.are.equal("hamburg_platform_left.module", theme:get("platformLeft"))
        end)    

        it ("returns default when module is not available in given theme", function ()
            assert.are.equal("platform_right.module", theme:get("platformRight"))
        end)
    end)

    describe("getWidthInCm", function ()
        it ("returns module width in cm from theme module", function ()
            assert.are.equal(300, theme:getWidthInCm("platformLeft"))
        end)

        it ("returns default theme width in cm", function ()
            assert.are.equal(200, theme:getWidthInCm("platformRight"))
        end)
    end)

    describe("has", function ()
        it ("checks whether there is a module for given theme type", function ()
            assert.is_true(theme:has("platformLeft"))
            assert.is_false(theme:has("platformIsland"))
        end)

        it ("returns false when given theme type is excluded", function ()
            assert.is_false(theme:has("shelter"))
        end)
    end)
end)