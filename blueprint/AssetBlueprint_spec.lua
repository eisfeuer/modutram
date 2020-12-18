local AssetBlueprint = require("modutram.blueprint.AssetBlueprint")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

describe("AssetBlueprint", function ()
    describe("decorate", function ()
        it ("adds decoration", function ()
            local result = {}
            local blueprint = AssetBlueprint:new{moduleName = "shelter.module"}

            blueprint:decorate(3, "schedule.module")
            blueprint:decorate(4, "clock.module")

            blueprint:place(result, 3, 5, 2)

            assert.are.same({
                [Slot.makeId({type = t.ASSET, gridX = 3, gridY = 5, assetId = 2})] = "shelter.module",
                [Slot.makeId({type = t.DECORATION, gridX = 3, gridY = 5, assetId = 2, decorationId = 3})] = "schedule.module",
                [Slot.makeId({type = t.DECORATION, gridX = 3, gridY = 5, assetId = 2, decorationId = 4})] = "clock.module"
            }, result)
        end)
    end)
end)