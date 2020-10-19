local config = require("modutram.config.defaults")
local t = require("modutram.types")
local Slot = require("modutram.slot.Slot")
local SlotConfigRepository = require("modutram.slot.SlotConfigRepository")
local factory = require("modutram.grid_module.factory")

local SlotFactory = require("modutram.slot.SlotFactory")

describe("SlotFactory", function ()
    local slotFactory = SlotFactory:new{config = config}

    describe("make", function ()
        it ("makes single slot", function ()
            local slotConfig = {
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }

            assert.are.same({
                id = Slot.makeId({type = t.TRAM_UP, gridX = 3, gridY = 2, xPos = 180}),
                type = 'modutram_austria_tram_up_300cm',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    1.8, 2 * config.gridModuleLength, 0, 1,
                },
                spacing = {
                    1.5 - 0.1, 1.5 - 0.1, config.gridModuleLength / 2 - 0.1, config.gridModuleLength / 2 - 0.1
                }
            }, slotFactory:make(slotConfig, 3, 2, 180))
        end)
    end)

    describe("makeAnySlot", function ()
        it ("makes any possible slot", function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_DOWN,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }}

            local expected = {
                slotFactory:make(slotConfigs[1], 1, 2, 150),
                slotFactory:make(slotConfigs[2], 1, 2, 150)
            }

            local slotConfigRepo = SlotConfigRepository.makeWithParams(slotConfigs)

            assert.are.same(expected, slotFactory:makeAnySlot(slotConfigRepo, 1, 2, 150))
        end)
    end)

    describe("makeSlotsLeftFromGridModule", function ()
        it ("makes any slot left from grid module", function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.PLATFORM_ISLAND,
                slotType = 'modutram_austria_platform_island_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.TRAIN,
                slotType = 'modutram_austria_train_350cm',
                widthInCm = 200,
                namespace = 'austria'
            }}

            local gridModule = factory.make(Slot:new{id = Slot.makeId({
                type = t.PLATFORM_RIGHT,
                gridX = 2,
                gridY = 3,
                xPos = 400
            }), moduleData = { metadata =  { modutram_widthInCm = 200 } }})

            local expected = {
                slotFactory:make(slotConfigs[1], 1, 3, 150),
                slotFactory:make(slotConfigs[2], 1, 3, 125),
                slotFactory:make(slotConfigs[4], 1, 3, 200)
            }

            local slotConfigRepo = SlotConfigRepository.makeWithParams(slotConfigs)

            assert.are.same(expected, slotFactory:makeSlotsLeftFromGridModule(slotConfigRepo, gridModule))
        end)
    end)
    
    describe("makeSlotsFromGridModule", function ()
        it ("makes any slot right from grid module", function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.PLATFORM_ISLAND,
                slotType = 'modutram_austria_platform_island_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.TRAIN,
                slotType = 'modutram_austria_train_350cm',
                widthInCm = 200,
                namespace = 'austria'
            }}

            local gridModule = factory.make(Slot:new{id = Slot.makeId({
                type = t.PLATFORM_LEFT,
                gridX = 2,
                gridY = 3,
                xPos = 400
            }), moduleData = { metadata =  { modutram_widthInCm = 200 } }})

            local expected = {
                slotFactory:make(slotConfigs[1], 3, 3, 650),
                slotFactory:make(slotConfigs[2], 3, 3, 675),
                slotFactory:make(slotConfigs[4], 3, 3, 600)
            }

            local slotConfigRepo = SlotConfigRepository.makeWithParams(slotConfigs)

            assert.are.same(expected, slotFactory:makeSlotsRightFromGridModule(slotConfigRepo, gridModule))
        end)
    end)

    describe("makeSlotsAboveGridModule", function ()
        it ("makes a slot avove given grid module", function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.PLATFORM_ISLAND,
                slotType = 'modutram_austria_platform_island_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.TRAIN,
                slotType = 'modutram_austria_train_350cm',
                widthInCm = 200,
                namespace = 'austria'
            }}

            local gridModule = factory.make(Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 2,
                gridY = 3,
                xPos = 350
            }), moduleData = { metadata =  { modutram_widthInCm = 350 } }})

            local slotConfigRepo = SlotConfigRepository.makeWithParams(slotConfigs)

            assert.are.same({slotFactory:make(slotConfigs[2], 2, 4, 350)}, slotFactory:makeSlotsAboveGridModule(slotConfigRepo, gridModule))
        end)
    end)

    describe("makeSlotsBelowGridModule", function ()
        it ("makes a slot avove given grid module", function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.PLATFORM_ISLAND,
                slotType = 'modutram_austria_platform_island_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.TRAIN,
                slotType = 'modutram_austria_train_350cm',
                widthInCm = 200,
                namespace = 'austria'
            }}

            local gridModule = factory.make(Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 2,
                gridY = 3,
                xPos = 350
            }), moduleData = { metadata =  { modutram_widthInCm = 350 } }})

            local slotConfigRepo = SlotConfigRepository.makeWithParams(slotConfigs)

            assert.are.same({slotFactory:make(slotConfigs[2], 2, 2, 350)}, slotFactory:makeSlotsBelowGridModule(slotConfigRepo, gridModule))
        end)
    end)

    describe("makeSlotAtGridModule", function ()
        it ("makes a slot avove given grid module", function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }, {
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.PLATFORM_ISLAND,
                slotType = 'modutram_austria_platform_island_350cm',
                widthInCm = 350,
                namespace = 'austria'
            }, {
                type = t.TRAIN,
                slotType = 'modutram_austria_train_350cm',
                widthInCm = 200,
                namespace = 'austria'
            }}

            local gridModule = factory.make(Slot:new{id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 2,
                gridY = 3,
                xPos = 350
            }), moduleData = { metadata =  { modutram_widthInCm = 350 } }})

            local slotConfigRepo = SlotConfigRepository.makeWithParams(slotConfigs)

            assert.are.same(slotFactory:make(slotConfigs[2], 2, 3, 350), slotFactory:makeSlotAtGridModule(slotConfigRepo, gridModule))
        end)
    end)
end)