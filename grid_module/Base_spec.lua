local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")
local Station = require("modutram.Station")

local GridModule = require("modutram.grid_module.Base")
local TerminalGroup = require("modutram.terminal.TerminalGroup")

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
        baseHeight = 10,
        defaultAssetSlotSpacing = {1, 1, 1, 1}
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

    describe("getXPosInCm", function ()
        it ('returns the X Position in centimeters', function ()
            assert.are.equal(280, gridModule:getXPosInCm())
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

    describe("isBlank", function ()
        it ('returns true when type is void', function ()
            assert.is_false(gridModule:isBlank())

            local slot = Slot:new{id = Slot.makeId({type = t.VOID})}
            local voidModule = GridModule:new{slot = slot}

            assert.is_true(voidModule:isBlank())
        end)
    end)

    describe('hasNeighborLeft', function ()
        it('checks weather grid element has left neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local leftNeighbor = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = -1, gridY = 0}))

            assert.is_true(testGridElement:hasNeighborLeft())
            assert.is_false(leftNeighbor:hasNeighborLeft())
        end)
    end)

    describe('getNeighborLeft', function ()
        it('returns left neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local leftNeighbor = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = -1, gridY = 0}))

            assert.are.equal(leftNeighbor, testGridElement:getNeighborLeft())
        end)
    end)

    describe('hasNeighborRight', function ()
        it('checks weather grid element has right neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local rightNeighbor = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 0}))

            assert.is_true(testGridElement:hasNeighborRight())
            assert.is_false(rightNeighbor:hasNeighborRight())
        end)
    end)

    describe('getNeighborRight', function ()
        it('returns right neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local rightNeighbor = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 0}))

            assert.are.equal(rightNeighbor, testGridElement:getNeighborRight())
        end)
    end)

    describe('hasNeighborTop', function ()
        it('checks weather grid element has top neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local neightborTop = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 1}))

            assert.is_true(testGridElement:hasNeighborTop())
            assert.is_false(neightborTop:hasNeighborTop())
        end)
    end)

    describe('getNeighborTop', function ()
        it('returns top neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local neighborTop = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 1}))

            assert.are.equal(neighborTop, testGridElement:getNeighborTop())
        end)
    end)

    describe('hasNeighborBottom', function ()
        it('checks weather grid element has bottom neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local neightborBottom = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = -1}))

            assert.is_true(testGridElement:hasNeighborBottom())
            assert.is_false(neightborBottom:hasNeighborBottom())
        end)
    end)

    describe('getNeighborBottom', function ()
        it('returns bottom neighbor', function ()
            local station = Station:new{}
            local testGridElement = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
            local neighborBottom = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = -1}))

            assert.are.equal(neighborBottom, testGridElement:getNeighborBottom())
        end)
    end)

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

    describe('handleTerminals / callTerminalHandleFunc', function ()
        it('handles terminals', function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})}
            local testGridModule = GridModule:new{slot = slot}

            assert.is_false(testGridModule.hasTerminalsLeft)
            assert.is_false(testGridModule.hasTerminalsRight)
            local called = false

            testGridModule:handleTerminals(function ()
                called = true
            end)

            testGridModule:callTerminalHandleFunc(TerminalGroup:new{platformDirection = 'left'})

            assert.is_true(called)
            assert.is_true(testGridModule.hasTerminalsLeft)
            assert.is_false(testGridModule.hasTerminalsRight)
        end)

        it('handles terminals on bidirectional tracks', function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = 0, gridY = 0})}
            local testGridModule = GridModule:new{slot = slot}

            assert.is_false(testGridModule.hasTerminalsLeft)
            assert.is_false(testGridModule.hasTerminalsRight)
            local called = false

            testGridModule:handleTerminals(function ()
                called = true
            end)

            testGridModule:callTerminalHandleFunc(TerminalGroup:new{platformDirection = 'left'})

            assert.is_true(called)
            assert.is_true(testGridModule.hasTerminalsLeft)
            assert.is_false(testGridModule.hasTerminalsRight)
        end)
    end)

    describe('handleLanes / callLaneHandleFunc', function ()
        it('handles non terminal lanes', function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})}
            local testGridModule = GridModule:new{slot = slot}

            local called = false

            testGridModule:handleLanes(function (hasTerminalsLeft, hasTerminalsRight)
                assert.is_false(hasTerminalsLeft)
                assert.is_false(hasTerminalsRight)
                called = true
            end)

            testGridModule:callLaneHandleFunc()

            assert.is_true(called)
        end)

        it('handles non terminal lanes from a module with terminals', function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})}
            local testGridModule = GridModule:new{slot = slot}
            testGridModule.hasTerminalsLeft = true

            local called = false

            testGridModule:handleLanes(function (hasTerminalsLeft, hasTerminalsRight)
                assert.is_true(hasTerminalsLeft)
                assert.is_false(hasTerminalsRight)
                called = true
            end)

            testGridModule:callLaneHandleFunc()

            assert.is_true(called)
        end)
    end)

    describe("hasTerminals", function ()
        it ("checks whether gridmodule has any terminals", function ()
            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})}
            local testGridModule1 = GridModule:new{slot = slot}
            testGridModule1.hasTerminalsLeft = true
            local testGridModule2 = GridModule:new{slot = slot}
            testGridModule2.hasTerminalsRight = true
            local testGridModule3 = GridModule:new{slot = slot}

            assert.is_true(testGridModule1:hasTerminals())
            assert.is_true(testGridModule2:hasTerminals())
            assert.is_false(testGridModule3:hasTerminals())
        end)
    end)

    describe('getConfig', function ()
        it('returns config', function ()
            assert.are.equal(config, gridModule:getConfig())
        end)
    end)

    describe("registerAsset", function ()
        it("registers asset", function ()
            local assetSlotId = Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 12})
            local assetSlot = Slot:new{id = assetSlotId}
            local asset = gridModule:registerAsset(assetSlot)

            assert.are.equal(assetSlotId, asset:getSlotId())
            assert.are.equal(1, asset:getGridX())
            assert.are.equal(2, asset:getGridY())
        end)
    end)

    describe("hasAsset", function ()
        it ("checks whether grid element has asset", function ()
            assert.is_true(gridModule:hasAsset(12))
            assert.is_false(gridModule:hasAsset(14))
        end)
    end)

    describe("getAsset", function ()
        it ("returns asset", function ()
            local assetSlotId = Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 12})
            local asset = gridModule:getAsset(12)

            assert.are.equal(assetSlotId, asset:getSlotId())
            assert.are.equal(1, asset:getGridX())
            assert.are.equal(2, asset:getGridY())

            assert.are.equal(nil, gridModule:getAsset(14))
        end)
    end)

    describe("addAssetSlot", function ()
        it("adds asset slot to collection (1m above the base slot)", function ()
            local result = {
                slots = {}
            }

            local matrix = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                2, 1, 0, 1
            }

            gridModule:addAssetSlot(result, 3, 'modutram_asset', matrix)

            assert.are.same({{
                id = Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3}),
                transf = matrix,
                type = 'modutram_asset',
                spacing = gridModule.config.defaultAssetSlotSpacing,
                shape = 0
            }}, result.slots)
        end)

        it("adds custom asset slot", function ()
            local result = {
                slots = {}
            }

            local matrix = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                2, 1, 0, 1
            }

            gridModule:addAssetSlot(result, 3, 'modutram_asset_building', matrix, {1, 2, 3, 4}, 2)

            assert.are.same({{
                id = Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3}),
                transf = matrix,
                type = 'modutram_asset_building',
                spacing = {1, 2, 3, 4},
                shape = 2
            }}, result.slots)
        end)
    end)
    
    describe('isBidirectionalLeftTrack', function ()
        it ('checks whether grid module is a bidirectional track (left hand traffic)', function ()
            local station = Station:new()

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_LEFT, gridX = 1, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = 2, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = 3, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.BUS_BIDIRECTIONAL_LEFT, gridX = 4, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 5, gridY = 0}))

            assert.is_false(station.grid:get(0,0):isBidirectionalLeftTrack())
            assert.is_true(station.grid:get(1,0):isBidirectionalLeftTrack())
            assert.is_false(station.grid:get(2,0):isBidirectionalLeftTrack())
            assert.is_false(station.grid:get(3,0):isBidirectionalLeftTrack())
            assert.is_true(station.grid:get(4,0):isBidirectionalLeftTrack())
            assert.is_false(station.grid:get(5,0):isBidirectionalLeftTrack())
        end)
    end)

    describe('isBidirectionalLeftTrack', function ()
        it ('checks whether grid module is a bidirectional track (right hand traffic)', function ()
            local station = Station:new()

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_LEFT, gridX = 1, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = 2, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_DOWN, gridX = 3, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.BUS_BIDIRECTIONAL_RIGHT, gridX = 4, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 5, gridY = 0}))

            assert.is_false(station.grid:get(0,0):isBidirectionalRightTrack())
            assert.is_false(station.grid:get(1,0):isBidirectionalRightTrack())
            assert.is_true(station.grid:get(2,0):isBidirectionalRightTrack())
            assert.is_false(station.grid:get(3,0):isBidirectionalRightTrack())
            assert.is_true(station.grid:get(4,0):isBidirectionalRightTrack())
            assert.is_false(station.grid:get(5,0):isBidirectionalRightTrack())
        end)
    end)

    describe('isUpGoingTrack', function ()
        it ('checks whether grid module is a up going track', function ()
            local station = Station:new()

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_LEFT, gridX = 1, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = 2, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_DOWN, gridX = 3, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.BUS_UP_LEFT, gridX = 4, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 5, gridY = 0}))

            assert.is_true(station.grid:get(0,0):isUpGoingTrack())
            assert.is_false(station.grid:get(1,0):isUpGoingTrack())
            assert.is_false(station.grid:get(2,0):isUpGoingTrack())
            assert.is_false(station.grid:get(3,0):isUpGoingTrack())
            assert.is_true(station.grid:get(4,0):isUpGoingTrack())
            assert.is_false(station.grid:get(5,0):isUpGoingTrack())
        end)
    end)

    describe('isDownGoingTrack', function ()
        it ('checks whether grid module is a up going track', function ()
            local station = Station:new()

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_LEFT, gridX = 1, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = 2, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.TRAM_DOWN, gridX = 3, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.BUS_DOWN_LEFT, gridX = 4, gridY = 0}))
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 5, gridY = 0}))

            assert.is_false(station.grid:get(0,0):isDownGoingTrack())
            assert.is_false(station.grid:get(1,0):isDownGoingTrack())
            assert.is_false(station.grid:get(2,0):isDownGoingTrack())
            assert.is_true(station.grid:get(3,0):isDownGoingTrack())
            assert.is_true(station.grid:get(4,0):isDownGoingTrack())
            assert.is_false(station.grid:get(5,0):isDownGoingTrack())
        end)
    end)

    describe('getColumn', function ()
        it('returns the column where this module belongs to', function ()
            local station = Station:new()
            local slotId2 = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY = 0})

            station:registerModule(slotId2)

            local gridModule2 = station:getModule(slotId2)

            assert.are.equal(station.grid:getColumn(2), gridModule2:getColumn())
        end)
    end)
end)