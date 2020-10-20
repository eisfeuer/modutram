local TerminalHandler = require("modutram.terminal.TerminalHandler")
local Station = require("modutram.Station")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

describe("TerminalHandler", function ()
    local moduleData = {
        metadata = {
            modutram_widthInCm = 100
        }
    }

    describe("addTerminalsFromGrid", function ()
        local identMatrix = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}

        it ("creates terminals for a small even tram station", function ()
            local result = {models = {}}
            local terminalHandler = TerminalHandler:new{}

            local station = Station:new{}

            station:registerModule(Slot.makeId({type = t.TRAM_DOWN, gridX = 4, gridY = 0, yPos = 400}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_DOWN, gridX = 4, gridY = 1, yPos = 400}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_DOWN, gridX = 4, gridY = 2, yPos = 400}), moduleData)

            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 3, gridY = -1, yPos = 300}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 3, gridY = 0, yPos = 300}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 3, gridY = 1, yPos = 300}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 3, gridY = 2, yPos = 300}), moduleData)

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY = 0, yPos = 200}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY = 1, yPos = 200}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY = 2, yPos = 200}), moduleData)

            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 0, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 1, yPos = 100}), moduleData)

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 1, yPos = 0}), moduleData)

            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = -1, gridY = -1, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = -1, gridY = 0, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = -1, gridY = 1, yPos = 100}), moduleData)

            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = -2, gridY = -1, yPos = 200}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = -2, gridY = 0, yPos = 200}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = -2, gridY = 1, yPos = 200}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_BIDIRECTIONAL_RIGHT, gridX = -2, gridY = 2, yPos = 200}), moduleData)

            station:registerModule(Slot.makeId({type = t.PLATFORM_RIGHT, gridX = -3, gridY = -1, yPos = 300}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_RIGHT, gridX = -3, gridY = 0, yPos = 300}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_RIGHT, gridX = -3, gridY = 1, yPos = 300}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_RIGHT, gridX = -3, gridY = 2, yPos = 300}), moduleData)

            local function doNotHandleThis(terminalGroup)
                assert.is_true(false)
            end

            -- Terminals
            local function handleLeftTerminalsForPlatform(terminalGroup)
                assert.are.equal('left', terminalGroup.trackDirection)

                terminalGroup:addTerminalModel('passenger_terminal_left.mdl', identMatrix)
            end
            local function handleRightTerminalsForPlatform(terminalGroup)
                assert.are.equal('right', terminalGroup.trackDirection)

                terminalGroup:addTerminalModel('passenger_terminal_right.mdl', identMatrix)
            end
            local function handleIslandTerminalsForPlatform(terminalGroup)
                assert.is_true(terminalGroup.trackDirection == 'left' or terminalGroup.trackDirection == 'right')

                terminalGroup:addTerminalModel('passenger_terminal_island.mdl', identMatrix)
            end

            -- Tracks
            station.grid:get(-2,0):handleTerminals(function(terminalGroup)
                local isLeftSide = terminalGroup.platformDirection == 'left' and  terminalGroup.vehicleStopAlignment == 'top'
                local isRightSide = terminalGroup.platformDirection == 'right' and  terminalGroup.vehicleStopAlignment == 'middle'
                assert.is_true(isLeftSide or isRightSide)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_bidiretional.mdl', identMatrix)
            end)
            station.grid:get(0,0):handleTerminals(function(terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('top', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_top_right.mdl', identMatrix)
            end)
            station.grid:get(2,1):handleTerminals(function(terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('middle', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_mid_right.mdl', identMatrix)
            end)
            station.grid:get(4,1):handleTerminals(function(terminalGroup)
                assert.are.equal('left', terminalGroup.platformDirection)
                assert.are.equal('middle', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_mid_left.mdl', identMatrix)
            end)

            -- Non Terminal Track Parts
            station.grid:get(-2,-1):handleTerminals(doNotHandleThis)
            station.grid:get(-2,1):handleTerminals(doNotHandleThis)
            station.grid:get(-2,2):handleTerminals(doNotHandleThis)
            station.grid:get(0,1):handleTerminals(doNotHandleThis)
            station.grid:get(2,0):handleTerminals(doNotHandleThis)
            station.grid:get(2,2):handleTerminals(doNotHandleThis)
            station.grid:get(4,0):handleTerminals(doNotHandleThis)
            station.grid:get(4,2):handleTerminals(doNotHandleThis)

            -- Passenger Terminals
            station.grid:get(-3,-1):handleTerminals(handleRightTerminalsForPlatform)
            station.grid:get(-3,0):handleTerminals(handleRightTerminalsForPlatform)
            station.grid:get(-3,1):handleTerminals(handleRightTerminalsForPlatform)
            station.grid:get(-3,2):handleTerminals(handleRightTerminalsForPlatform)

            station.grid:get(-1,-1):handleTerminals(handleLeftTerminalsForPlatform)
            station.grid:get(-1,0):handleTerminals(handleLeftTerminalsForPlatform)
            station.grid:get(-1,1):handleTerminals(handleLeftTerminalsForPlatform)

            station.grid:get(1,0):handleTerminals(handleLeftTerminalsForPlatform)
            station.grid:get(1,1):handleTerminals(handleLeftTerminalsForPlatform)

            station.grid:get(3,-1):handleTerminals(doNotHandleThis)
            station.grid:get(3,0):handleTerminals(handleIslandTerminalsForPlatform)
            station.grid:get(3,1):handleTerminals(handleIslandTerminalsForPlatform)
            station.grid:get(3,2):handleTerminals(handleIslandTerminalsForPlatform)

            terminalHandler:addTerminalsFromGrid(station.grid, result)
            
            assert.are.same({
                models = {{
                    id = 'passenger_terminal_right.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_right.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_right.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_right.mdl',
                    transf = identMatrix
                }, {
                    id = 'vehicle_terminal_bidiretional.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_left.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_left.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_left.mdl',
                    transf = identMatrix
                }, {
                    id = 'vehicle_terminal_bidiretional.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_left.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_left.mdl',
                    transf = identMatrix
                }, {
                    id = 'vehicle_terminal_top_right.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_island.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_island.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_island.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_island.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_island.mdl',
                    transf = identMatrix
                }, {
                    id = 'passenger_terminal_island.mdl',
                    transf = identMatrix
                }, {
                    id = 'vehicle_terminal_mid_right.mdl',
                    transf = identMatrix
                },{
                    id = 'vehicle_terminal_mid_left.mdl',
                    transf = identMatrix
                }},
                terminalGroups = {
                    {
                        terminals = {{4, 0}, {0, 0}, {1, 0}, {2, 0}, {3, 0}}
                    }, {
                        terminals = {{8, 0}, {5, 0}, {6, 0}, {7, 0}}
                    }, {
                        terminals = {{11, 0}, {9, 0}, {10, 0}}
                    }, {
                        terminals = {{18, 0}, {12, 0}, {14, 0}, {16, 0}}
                    }, {
                        terminals = {{19, 0}, {13, 0}, {15, 0}, {17, 0}}
                    }
                }
            }, result)
        end)
    end)

    describe('addNonTerminalLanesFromGrid', function ()
        it ('handles all non terminal grid modules', function ()
            local result = {models = {}}
            local terminalHandler = TerminalHandler:new{}

            local station = Station:new{}

            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 1, yPos = 100}), moduleData)

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 1, yPos = 0}), moduleData)

            local testResult = {}

            station.grid:get(0,0):handleLanes(function ()
                table.insert(testResult, 1)
            end)
            station.grid:get(0,1):handleLanes(function ()
                table.insert(testResult, 2)
            end)
            station.grid:get(1,1):handleLanes(function ()
                table.insert(testResult, 3)
            end)

            terminalHandler:addTerminalsFromGrid(station.grid, result)
            terminalHandler:addNonTerminalLanesFromGrid(station.grid)

            assert.are.same({1, 2, 3}, testResult)
        end)
    end)
end)