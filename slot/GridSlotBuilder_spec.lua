local config = require('modutram.config.defaults')
local Grid = require('modutram.grid.Grid')
local SlotConfigRepository = require('modutram.slot.SlotConfigRepository')
local t = require('modutram.types')
local SlotFactory = require('modutram.slot.SlotFactory')

local GridSlotBuilder = require('modutram.slot.GridSlotBuilder')

local slotFactory = SlotFactory:new{config = config}

describe('GridSlotBuilder', function ()
    describe('placeGridSlots', function ()
        it('places all slots at 0/0 when grid is empty', function ()
            local grid = Grid:new{config = config}

            local slotConfigRepository = SlotConfigRepository.makeWithParams({{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_DOWN,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }})
            local gridSlotBuilder = GridSlotBuilder:new{grid = grid, config = config}

            local slots = gridSlotBuilder:placeGridSlots(slotConfigRepository)

            assert.are.same(slotFactory:makeAnySlot(slotConfigRepository, 0, 0, 0), slots)
        end)
    end)
end)