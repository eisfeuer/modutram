local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

local GridModule = require("modutram.GridModule.Base")

describe("GridModule", function()
    local slotId = Slot.makeId({
        type = t.TRAM_UP,
        gridX = 1,
        gridY = 2,
        xPos = 280
    })
    local slot = Slot:new{id = slotId, moduleData = {
        metadata = {
            modutram = {
                TheAnswerToTheUltimateQuestionOfLifeTheUniverseAndEverything = 42
            }
        }
    }}

    local config = {
        gridModuleLength = 20,
        baseHeight = 10
    }
    local gridModule = GridModule:new{slot = slot, options = {platformHeight = 0.96}, config = config}

    describe("getSlotId", function ()
        it ("returns slot id", function ()
            assert.are.equal(slotId, gridModule:getSlotId())
        end)
    end)

    describe("getModuleType", function ()
        it ("returns module type", function ()
            assert.are.equal(t.TYPE_TRAM, gridModule:getModuleType())
        end)
    end)

    describe("getType", function ()
        it ("returns type", function ()
            assert.are.equal(t.TRAM_UP, gridModule:getType())
        end)
    end)

    describe("getGridX", function ()
        it ("returns grid x", function ()
            assert.are.equal(1, gridModule:getGridX())
        end)
    end)

    describe("getGridY", function ()
        it ("returns grid y", function ()
            assert.are.equal(2, gridModule:getGridY())
        end)
    end)

    describe("getAbsoluteX", function ()
        it ('returns the local absulute x coord', function ()
            assert.are.equal(2.8, gridModule:getAbsoluteX())
        end)
    end)

    describe("getAbsoluteY", function ()
        it ('returns the local absulute x coord', function ()
            assert.are.equal(2 * config.gridModuleLength, gridModule:getAbsoluteY())
        end)
    end)

    describe("getAbsoluteZ", function ()
        it ('returns base grid height', function ()
            assert.are.equal(config.baseHeight, gridModule:getAbsoluteZ())
        end)
    end)

    describe("getOption", function ()
        it ('returns option', function ()
            assert.are.equal(0.96, gridModule:getOption('platformHeight', 0.55))
        end)

        it ('returns nil when option does not exists', function ()
            assert.are.equal(nil, gridModule:getOption('an_option'))
        end)

        it ('returns default when option does not exists', function ()
            assert.are.equal(42, gridModule:getOption('an_option', 42))
        end)

        it ('returns value from module data', function ()
            assert.are.equal(42, gridModule:getOption('TheAnswerToTheUltimateQuestionOfLifeTheUniverseAndEverything'))
        end)
    end)

    -- describe('hasNeighborLeft', function ()
    --     it('checks weather grid element has left neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local leftNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))

    --         assert.is_true(testGridElement:hasNeighborLeft())
    --         assert.is_false(leftNeighbor:hasNeighborLeft())
    --     end)
    -- end)

    -- describe('getNeighborLeft', function ()
    --     it('returns left neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local leftNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = -1, gridY = 0}))

    --         assert.are.equal(leftNeighbor, testGridElement:getNeighborLeft())
    --     end)
    -- end)

    -- describe('hasNeighborRight', function ()
    --     it('checks weather grid element has right neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local rightNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

    --         assert.is_true(testGridElement:hasNeighborRight())
    --         assert.is_false(rightNeighbor:hasNeighborRight())
    --     end)
    -- end)

    -- describe('getNeighborRight', function ()
    --     it('returns right neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local rightNeighbor = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 1, gridY = 0}))

    --         assert.are.equal(rightNeighbor, testGridElement:getNeighborRight())
    --     end)
    -- end)

    -- describe('hasNeighborTop', function ()
    --     it('checks weather grid element has top neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local neightborTop = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))

    --         assert.is_true(testGridElement:hasNeighborTop())
    --         assert.is_false(neightborTop:hasNeighborTop())
    --     end)
    -- end)

    -- describe('getNeighborTop', function ()
    --     it('returns top neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local neighborTop = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 1}))

    --         assert.are.equal(neighborTop, testGridElement:getNeighborTop())
    --     end)
    -- end)

    -- describe('hasNeighborBottom', function ()
    --     it('checks weather grid element has bottom neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local neightborBottom = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

    --         assert.is_true(testGridElement:hasNeighborBottom())
    --         assert.is_false(neightborBottom:hasNeighborBottom())
    --     end)
    -- end)

    -- describe('getNeighborBottom', function ()
    --     it('returns bottom neighbor', function ()
    --         local station = Station:new{}
    --         local testGridElement = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = 0}))
    --         local neighborBottom = station:initializeAndRegister(Slot.makeId({type = t.PLATFORM, gridX = 0, gridY = -1}))

    --         assert.are.equal(neighborBottom, testGridElement:getNeighborBottom())
    --     end)
    -- end)

    describe('setOptions', function ()
        it('set options', function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})}
            local testGridModule = GridModule:new{slot = slot}
            testGridModule:setOptions({opt1 = 'val1', opt2 = 'val2'})
            assert.are.equal('val1', testGridModule:getOption('opt1'))
            assert.are.equal('val2', testGridModule:getOption('opt2'))
        end)

        it('keeps old options', function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})}
            local testGridModule = GridModule:new{slot = slot}
            testGridModule:setOption('opt1', 'val1')
            testGridModule:setOptions({opt2 = 'val2'})
            assert.are.equal('val1', testGridModule:getOption('opt1'))
            assert.are.equal('val2', testGridModule:getOption('opt2'))
        end)
    end)
end)