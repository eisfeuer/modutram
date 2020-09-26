local config = require('modutram.config.defaults')
local Grid = require('modutram.grid.Grid')
local SlotConfigRepository = require('modutram.slot.SlotConfigRepository')
local t = require('modutram.types')
local SlotFactory = require('modutram.slot.SlotFactory')
local GridModuleFactory = require('modutram.grid_module.factory')
local Slot = require('modutram.slot.Slot')

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

        it('places slot for a station with one module', function ()
            local grid = Grid:new{config = config}

            local slotConfigRepository = SlotConfigRepository.makeWithParams({{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }})

            local slot = Slot:new{id = Slot.makeId({type = t.TRAM_UP}), moduleData = {
                metadata = {
                    modutram_widthInCm = 300
                }
            }}
            local gridModule = GridModuleFactory.make(slot)

            grid:set(gridModule)

            local expected = {
                slotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule),
                slotFactory:makeSlotsBelowGridModule(slotConfigRepository, gridModule)[1],
                slotFactory:makeSlotsAboveGridModule(slotConfigRepository, gridModule)[1],
                slotFactory:makeSlotsLeftFromGridModule(slotConfigRepository, gridModule)[1],
                slotFactory:makeSlotsRightFromGridModule(slotConfigRepository, gridModule)[1]
            }

            local gridSlotBuilder = GridSlotBuilder:new{grid = grid, config = config}

            local slots = gridSlotBuilder:placeGridSlots(slotConfigRepository)

            assert.are.same(expected, slots)
        end)
    end)

    describe("placeGridSlotsFromColumn",function ()
        local slotConfigRepository = SlotConfigRepository.makeWithParams({{
            type = t.TRAM_UP,
            slotType = 'modutram_austria_tram_up_300cm',
            widthInCm = 300,
            namespace = 'austria'
        }})

        local moduleData = {
            metadata = {
                modutram_widthInCm = 300
            }
        }

        local gridModule1 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY = -2, xPos = 210}),
            moduleData = moduleData
        })
        local gridModule2 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY =  2, xPos = 210}),
            moduleData = moduleData
        })
        local gridModule3 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY =  3, xPos = 210}),
            moduleData = moduleData
        })
        local gridModule4 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY =  5, xPos = 210}),
            moduleData = moduleData
        })

        local grid = Grid:new{config = config}

        grid:set(gridModule1)
        grid:set(gridModule2)
        grid:set(gridModule3)
        grid:set(gridModule4)

        local column = grid:getColumn(2)
        local gridSlotBuilder = GridSlotBuilder:new{grid = grid, config = config}

        local expected = {
            slotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule1),
            slotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule2),
            slotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule3),
            slotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule4),
            slotFactory:makeSlotsBelowGridModule(slotConfigRepository, gridModule1)[1],
            slotFactory:makeSlotsAboveGridModule(slotConfigRepository, gridModule1)[1],
            slotFactory:makeSlotsBelowGridModule(slotConfigRepository, gridModule2)[1],
            slotFactory:makeSlotsAboveGridModule(slotConfigRepository, gridModule3)[1],
            slotFactory:makeSlotsAboveGridModule(slotConfigRepository, gridModule4)[1]
        }

        local result = {}

        gridSlotBuilder:placeGridSlotsFromColumn(column, slotConfigRepository, result)

        assert.are.same(expected, result)
    end)

    describe("placeGridSlotsLeftFromColumn", function ()
        local slotConfigRepository = SlotConfigRepository.makeWithParams({{
            type = t.TRAM_UP,
            slotType = 'modutram_austria_tram_up_300cm',
            widthInCm = 300,
            namespace = 'austria'
        }})

        local moduleData = {
            metadata = {
                modutram_widthInCm = 300
            }
        }

        local gridModule1 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = -2, gridY = -2, xPos = 210}),
            moduleData = moduleData
        })
        local gridModule2 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = -2, gridY =  2, xPos = 210}),
            moduleData = moduleData
        })

        local grid = Grid:new{config = config}

        grid:set(gridModule1)
        grid:set(gridModule2)

        local column = grid:getColumn(-2)
        local gridSlotBuilder = GridSlotBuilder:new{grid = grid, config = config}

        local expected = {}

        for _, slot in pairs(slotFactory:makeSlotsLeftFromGridModule(slotConfigRepository, gridModule1)) do
            table.insert(expected, slot)
        end

        for _, slot in pairs(slotFactory:makeSlotsLeftFromGridModule(slotConfigRepository, gridModule2)) do
            table.insert(expected, slot)
        end

        local result = {}

        gridSlotBuilder:placeGridSlotsLeftFromColumn(column, slotConfigRepository, result)

        assert.are.same(expected, result)
    end)

    describe("placeGridSlotsRightFromColumn", function ()
        local slotConfigRepository = SlotConfigRepository.makeWithParams({{
            type = t.TRAM_UP,
            slotType = 'modutram_austria_tram_up_300cm',
            widthInCm = 300,
            namespace = 'austria'
        }})

        local moduleData = {
            metadata = {
                modutram_widthInCm = 300
            }
        }

        local gridModule1 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY = -2, xPos = 210}),
            moduleData = moduleData
        })
        local gridModule2 = GridModuleFactory.make(Slot:new{
            id = Slot.makeId({type = t.TRAM_UP, gridX = 2, gridY =  2, xPos = 210}),
            moduleData = moduleData
        })

        local grid = Grid:new{config = config}

        grid:set(gridModule1)
        grid:set(gridModule2)

        local column = grid:getColumn(2)
        local gridSlotBuilder = GridSlotBuilder:new{grid = grid, config = config}

        local expected = {}

        for _, slot in pairs(slotFactory:makeSlotsRightFromGridModule(slotConfigRepository, gridModule1)) do
            table.insert(expected, slot)
        end

        for _, slot in pairs(slotFactory:makeSlotsRightFromGridModule(slotConfigRepository, gridModule2)) do
            table.insert(expected, slot)
        end

        local result = {}

        gridSlotBuilder:placeGridSlotsRightFromColumn(column, slotConfigRepository, result)

        assert.are.same(expected, result)
    end)
end)