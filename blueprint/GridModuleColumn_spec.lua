local GridModuleBlueprint = require("modutram.blueprint.GridModuleBlueprint")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

local GridModuleColumn = require("modutram.blueprint.GridModuleColumn")

describe("GridModuleColumn", function ()
    describe("addBlueprint", function ()
        it ("adds a grid module blueprint", function ()
            local result = {}

            local blueprint = GridModuleBlueprint:new{slotType = t.PLATFORM_ISLAND, moduleName = "island_platform.module"}
            
            local column = GridModuleColumn:new{}
            column:addBlueprint(1, blueprint):addBlueprint(2, blueprint)
            column:place(result, 700, 3)

            assert.are.same({
                [Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 3, gridY = 1, xPos = 700})] = "island_platform.module",
                [Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 3, gridY = 2, xPos = 700})] = "island_platform.module"
            }, result)
        end)
    end)
end)