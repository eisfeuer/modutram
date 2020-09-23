local GridModule = require("modutram.grid_module.Base")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")
local Grid = require("modutram.grid.Grid")
local Config = require("modutram.config.Config")
local defaultConfig = require("modutram.config.defaults")

describe("Grid", function ()   
    describe("new", function ()
        it("initializes empty grid", function ()
            local grid = Grid:new{config = Config:new{}}
            assert.is_true(grid:isEmpty())
        end)
    end)

    describe("isEmpty", function ()
        it ("checks wheter grid has no grid module stored", function ()
            local grid = Grid:new{config = Config:new{}}
            assert.is_true(grid:isEmpty())

            local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridModule)
            assert.is_false(grid:isEmpty())
        end)

        it ("checks wheter grid has no grid module stored 2", function ()
            local grid = Grid:new{config = Config:new{}}
            assert.is_true(grid:isEmpty())

            local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 0,
                gridY = 0
            })}, grid = grid}

            grid:set(gridModule)
            assert.is_false(grid:isEmpty())
        end)
    end)

    describe("get/set", function ()
        it ("gets empty grid module", function ()
            local grid = Grid:new{config = Config:new{}}
            local voidGridModule = grid:get(1,2)
            assert.is_true(voidGridModule:isBlank())
            assert.are.equal(1, voidGridModule:getGridX())
            assert.are.equal(2, voidGridModule:getGridY())
        end)

        it ("sets and get grid module", function ()
            local grid = Grid:new{config = Config:new{}}
            local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 1,
                gridY = 2
            })}, grid = grid}
            
            
            grid:set(gridModule)

            assert.are.equal(gridModule, grid:get(1,2))
        end)
    end)
    
    describe("has", function ()
        it("checks wheter an grid module exists on given position", function ()
            local grid = Grid:new{config = Config:new{}}
            local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridModule)

            assert.is_false(grid:has(1,3))
            assert.is_true(grid:has(1,2))
        end)
    end)

    describe("isInBounds", function ()
        it("checks wheter position is in allowed bounds", function ()
            local grid = Grid:new{config = Config:new{}}

            assert.is_true(grid:isInBounds(1,2))
            assert.is_true(grid:isInBounds(defaultConfig.gridMaxXyPosition, defaultConfig.gridMaxXyPosition))
            assert.is_true(grid:isInBounds(-defaultConfig.gridMaxXyPosition, -defaultConfig.gridMaxXyPosition))

            assert.is_false(grid:isInBounds(defaultConfig.gridMaxXyPosition + 1, defaultConfig.gridMaxXyPosition))
            assert.is_false(grid:isInBounds(-defaultConfig.gridMaxXyPosition - 1, -defaultConfig.gridMaxXyPosition))
            assert.is_false(grid:isInBounds(defaultConfig.gridMaxXyPosition, defaultConfig.gridMaxXyPosition + 1))
            assert.is_false(grid:isInBounds(-defaultConfig.gridMaxXyPosition, -defaultConfig.gridMaxXyPosition - 1))
        end)
    end)

    describe('getActiveGridBounds', function ()
        it ('returns bounds of the square where all modules are placed', function ()
            local grid = Grid:new{config = Config:new{}}

            assert.are.same({
                top = 0,
                bottom = 0,
                left = 0,
                right = 0,
            }, grid:getActiveGridBounds())

            local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridModule)

            assert.are.same({
                top = 2,
                bottom = 0,
                left = 0,
                right = 1,
            }, grid:getActiveGridBounds())

            gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = -3
            })}, grid = grid}

            grid:set(gridModule)

            assert.are.same({
                top = 2,
                bottom = -3,
                left = 0,
                right = 1,
            }, grid:getActiveGridBounds())

            gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = -1,
                gridY = -2
            })}, grid = grid}
            
            grid:set(gridModule)

            assert.are.same({
                top = 2,
                bottom = -3,
                left = -1,
                right = 1,
            }, grid:getActiveGridBounds())

        end)
    end)

    describe('getActiveSlotGridBounds', function ()
        it ('returns bounds of the square where all possible slots are in', function ()        
            local grid = Grid:new{config = Config:new{}}

            assert.are.same({
                top = 1,
                bottom = -1,
                left = -1,
                right = 1,
            }, grid:getActiveGridSlotBounds())

            local gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = 2
            })}, grid = grid}

            grid:set(gridModule)

            assert.are.same({
                top = 3,
                bottom = -1,
                left = -1,
                right = 2,
            }, grid:getActiveGridSlotBounds())

            gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = 1,
                gridY = -3
            })}, grid = grid}

            grid:set(gridModule)

            assert.are.same({
                top = 3,
                bottom = -4,
                left = -1,
                right = 2,
            }, grid:getActiveGridSlotBounds())

            gridModule = GridModule:new{slot = Slot:new{id = Slot.makeId({
                type = t.TRACK,
                gridX = -1,
                gridY = -2
            })}, grid = grid}
            
            grid:set(gridModule)

            assert.are.same({
                top = 3,
                bottom = -4,
                left = -2,
                right = 2,
            }, grid:getActiveGridSlotBounds())
        end)
    end)

end)