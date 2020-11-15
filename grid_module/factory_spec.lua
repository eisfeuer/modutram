local Slot = require('modutram.slot.Slot')
local t = require('modutram.types')
local factory = require('modutram.grid_module.factory')

local testingData = {
    [t.VOID] = "Base",
    [t.TRAM_BIDIRECTIONAL_LEFT] = "TramBidirectionalLeft",
    [t.TRAM_BIDIRECTIONAL_RIGHT] = "TramBidirectionalRight",
    [t.TRAM_UP] = "TramUp",
    [t.TRAM_DOWN] = "TramDown",
    [t.BUS_BIDIRECTIONAL_LEFT] = "BusBidirectionalLeft",
    [t.BUS_BIDIRECTIONAL_RIGHT] = "BusBidirectionalRight",
    [t.BUS_UP_LEFT] = "BusUpLeft",
    [t.BUS_UP_RIGHT] = "BusUpRight",
    [t.BUS_DOWN_LEFT] = "BusDownLeft",
    [t.BUS_DOWN_RIGHT] = "BusDownRight",
    [t.TRAIN] = "Train",
    [t.PLATFORM_NONE] = "PlatformNone",
    [t.PLATFORM_ISLAND] = "PlatformIsland",
    [t.PLATFORM_LEFT] = "PlatformLeft",
    [t.PLATFORM_RIGHT] = "PlatformRight",
}

describe('factory', function ()
    describe('getClass', function ()
        it ('returns correct class', function ()
            local params = {slot = Slot:new{id = Slot.makeId({type = t.VOID})}}

            for slotType, gridModuleClass in pairs(testingData) do
                assert.are.equal(gridModuleClass, factory.getClass(slotType):new(params).class)
            end
        end)
    end)

    describe('make', function ()
        it ('makes grid module from slot', function ()
            for slotType, gridModuleClass in pairs(testingData) do
                local slot =  Slot:new{id = Slot.makeId({type = slotType})}

                assert.are.equal(gridModuleClass, factory.make(slot).class)
            end
        end)
    end)
end)