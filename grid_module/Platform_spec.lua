local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")
local TerminalGroup = require("modutram.terminal.TerminalGroup")
local Station = require("modutram.Station")

describe('Platform', function ()
    describe('callTerminalFunc', function (arg1, arg2, arg3)
        it('handles terminals on island platforms', function ()
            local testGridModule = Station:new{}:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 0, gridY = 0}))

            assert.is_false(testGridModule.hasTerminalsLeft)
            assert.is_false(testGridModule.hasTerminalsRight)
            local called = false

            testGridModule:handleTerminals(function ()
                called = true
            end)

            testGridModule:callTerminalHandleFunc(TerminalGroup:new{trackDirection = 'left'})

            assert.is_true(called)
            assert.is_true(testGridModule.hasTerminalsLeft)
            assert.is_false(testGridModule.hasTerminalsRight)
        end)
    end)
end)