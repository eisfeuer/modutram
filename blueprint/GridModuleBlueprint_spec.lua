local t = require("modutram.types")
local Slot = require("modutram.slot.Slot")
local AssetCollection = require("modutram.blueprint.AssetCollection")

local GridModuleBlueprint = require("modutram.blueprint.GridModuleBlueprint")

describe("GridModuleBlueprint", function ()
    describe("place", function ()
        it ("adds blueprint to the result list", function ()
            local result = {}

            local bleuprint = GridModuleBlueprint:new{slotType = t.PLATFORM_LEFT, moduleName = "platform_left.module"}
            bleuprint:place(result, 300, 2, 1)

            assert.are.same({
                [Slot.makeId({type = t.PLATFORM_LEFT, gridX = 2, gridY = 1, xPos = 300})] = "platform_left.module"
            }, result)
        end)

        it ("adds blueprint to the result list with assets", function ()
            local result = {}

            local assetCollection = AssetCollection:new{}:addModule(2, "shelter.module"):addModule(4, "lamp.module")

            local bleuprint = GridModuleBlueprint:new{slotType = t.PLATFORM_LEFT, moduleName = "platform_left.module", assets = assetCollection}
            bleuprint:place(result, 300, 2, 1)

            assert.are.same({
                [Slot.makeId({type = t.PLATFORM_LEFT, gridX = 2, gridY = 1, xPos = 300})] = "platform_left.module",
                [Slot.makeId({type = t.ASSET, gridX = 2, gridY = 1, assetId = 2})] = "shelter.module",
                [Slot.makeId({type = t.ASSET, gridX = 2, gridY = 1, assetId = 4})] = "lamp.module",
            }, result)
        end)
    end)
end)