local AssetBlueprint = require("modutram.blueprint.AssetBlueprint")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

local AssetCollection = require("modutram.blueprint.AssetCollection")

describe("AssetCollection", function ()
    describe("addBlueprint", function ()
        it("adds asset blueprint", function ()
            local result = {}

            local collection = AssetCollection:new{}
            collection:addBlueprint(3, AssetBlueprint:new{moduleName = "shelter.module"})
                :addBlueprint(5, AssetBlueprint:new{moduleName = "lamp.module"})

            collection:place(result, 1, 2)

            assert.are.same({
                [Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3})] = "shelter.module",
                [Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 5})] = "lamp.module",
            }, result)
        end)
    end)

    describe("addModule", function ()
        it("adds asset", function ()
            local result = {}

            local collection = AssetCollection:new{}
            collection:addModule(3, "shelter.module")
                :addModule(5, "lamp.module")

            collection:place(result, 1, 2)

            assert.are.same({
                [Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3})] = "shelter.module",
                [Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 5})] = "lamp.module",
            }, result)
        end)
    end)
end)