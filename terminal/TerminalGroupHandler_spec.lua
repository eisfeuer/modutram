local TerminalGroupHandler = require("modutram.terminal.TerminalGroupHandler")
local Station = require("modutram.Station")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

describe('TerminalGroupHandler', function ()
    local identMatrix = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}

    local moduleData = {
        metadata = {
            modutram_widthInCm = 100
        }
    }

    describe('handle / finalize', function ()
        it ('handles terminal group', function ()
            local result = {models = {}}

            local station = Station:new{}
            local grid = station.grid


            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 0, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 1, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 2, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 3, yPos = 100}), moduleData)

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 1, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 3, yPos = 0}), moduleData)

            local function handlePassengerTerminal(terminalGroup)
                assert.are.equal('left', terminalGroup.trackDirection)
                terminalGroup:addTerminalModel('passenger_terminal.mdl', identMatrix)
            end

            grid:get(1, 0):handleTerminals(handlePassengerTerminal)
            grid:get(1, 1):handleTerminals(handlePassengerTerminal)
            grid:get(1, 2):handleTerminals(handlePassengerTerminal)
            grid:get(1, 3):handleTerminals(handlePassengerTerminal)

            grid:get(0, 0):handleTerminals(function (terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('top', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_1.mdl', identMatrix)
            end)
            grid:get(0, 1):handleTerminals(function ()
                assert.is_true('false')
            end)
            grid:get(0, 3):handleTerminals(function (terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('middle', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_2.mdl', identMatrix)
            end)

            local terminalGroupHandler = TerminalGroupHandler:new{
                neighborDirection = 'left',
                neighborGridX = 0,
                grid = grid,
                result = result
            }

            terminalGroupHandler:handle(grid:get(1, 0))
            terminalGroupHandler:handle(grid:get(1, 1))
            terminalGroupHandler:handle(grid:get(1, 2))
            terminalGroupHandler:handle(grid:get(1, 3))
            terminalGroupHandler:finalize()

            assert.are.same({{
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'vehicle_terminal_1.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            },{
                id = 'vehicle_terminal_2.mdl',
                transf = identMatrix
            }}, result.models)

            assert.are.same({{
                terminals = {{2, 0}, {0, 0}, {1, 0}}
            }, {
                terminals = {{4, 0}, {3, 0}}
            }}, result.terminalGroups)
        end)

        it ('ignores disabled modules', function ()
            local result = {models = {}}

            local station = Station:new{}
            local grid = station.grid


            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 0, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 1, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 2, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 3, yPos = 100}), moduleData)

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 1, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 2, yPos = 0}), {
                metadata = {
                    modutram_widthInCm = 100,
                    modutram_hasTerminals = false
                }
            })
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 3, yPos = 0}), moduleData)

            local function handlePassengerTerminal(terminalGroup)
                assert.are.equal('left', terminalGroup.trackDirection)
                terminalGroup:addTerminalModel('passenger_terminal.mdl', identMatrix)
            end

            grid:get(1, 0):handleTerminals(handlePassengerTerminal)
            grid:get(1, 1):handleTerminals(handlePassengerTerminal)
            grid:get(1, 2):handleTerminals(handlePassengerTerminal)
            grid:get(1, 3):handleTerminals(handlePassengerTerminal)

            grid:get(0, 0):handleTerminals(function (terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('top', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_1.mdl', identMatrix)
            end)
            grid:get(0, 1):handleTerminals(function ()
                assert.is_true('false')
            end)
            grid:get(0, 2):handleTerminals(function ()
                assert.is_true('false')
            end)
            grid:get(0, 3):handleTerminals(function (terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('middle', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_2.mdl', identMatrix)
            end)

            local terminalGroupHandler = TerminalGroupHandler:new{
                neighborDirection = 'left',
                neighborGridX = 0,
                grid = grid,
                result = result
            }

            terminalGroupHandler:handle(grid:get(1, 0))
            terminalGroupHandler:handle(grid:get(1, 1))
            terminalGroupHandler:handle(grid:get(1, 2))
            terminalGroupHandler:handle(grid:get(1, 3))
            terminalGroupHandler:finalize()

            assert.are.same({{
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'vehicle_terminal_1.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            },{
                id = 'vehicle_terminal_2.mdl',
                transf = identMatrix
            }}, result.models)

            assert.are.same({{
                terminals = {{2, 0}, {0, 0}, {1, 0}}
            }, {
                terminals = {{4, 0}, {3, 0}}
            }}, result.terminalGroups)
        end)

        it ('setparates cargo and passenger modules', function ()
            local result = {models = {}}

            local station = Station:new{}
            local grid = station.grid

            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 0, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 1, yPos = 100}), moduleData)
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 2, yPos = 100}), {
                metadata = {
                    modutram_widthInCm = 100,
                    modutram_load = "cargo"
                }
            })
            station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 1, gridY = 3, yPos = 100}), {
                metadata = {
                    modutram_widthInCm = 100,
                    modutram_load = "cargo"
                }
            })

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 1, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 2, yPos = 0}), moduleData)
            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 3, yPos = 0}), moduleData)

            local function handlePassengerTerminal(terminalGroup)
                assert.are.equal('left', terminalGroup.trackDirection)
                terminalGroup:addTerminalModel('passenger_terminal.mdl', identMatrix)
            end

            grid:get(1, 0):handleTerminals(handlePassengerTerminal)
            grid:get(1, 1):handleTerminals(handlePassengerTerminal)
            grid:get(1, 2):handleTerminals(handlePassengerTerminal)
            grid:get(1, 3):handleTerminals(handlePassengerTerminal)

            grid:get(0, 0):handleTerminals(function (terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('top', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_1.mdl', identMatrix)
            end)
            grid:get(0, 1):handleTerminals(function ()
                assert.is_true('false')
            end)
            grid:get(0, 2):handleTerminals(function (terminalGroup)
                assert.are.equal('right', terminalGroup.platformDirection)
                assert.are.equal('top', terminalGroup.vehicleStopAlignment)

                terminalGroup:addVehicleTerminalModel('vehicle_terminal_2.mdl', identMatrix)
            end)
            grid:get(0, 3):handleTerminals(function (terminalGroup)
                assert.is_true(false)
            end)

            local terminalGroupHandler = TerminalGroupHandler:new{
                neighborDirection = 'left',
                neighborGridX = 0,
                grid = grid,
                result = result
            }

            terminalGroupHandler:handle(grid:get(1, 0))
            terminalGroupHandler:handle(grid:get(1, 1))
            terminalGroupHandler:handle(grid:get(1, 2))
            terminalGroupHandler:handle(grid:get(1, 3))
            terminalGroupHandler:finalize()

            assert.are.same({{
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'vehicle_terminal_1.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'passenger_terminal.mdl',
                transf = identMatrix
            }, {
                id = 'vehicle_terminal_2.mdl',
                transf = identMatrix
            }}, result.models)

            assert.are.same({{
                terminals = {{2, 0}, {0, 0}, {1, 0}}
            }, {
                terminals = {{5, 0}, {3, 0},{4, 0}}
            }}, result.terminalGroups)
        end)
    end)
end)