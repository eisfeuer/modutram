local Modutram = require('modutram.modutram')
local Slot = require('modutram.slot.Slot')
local t = require('modutram.types')
local defaults = require("modutram.config.defaults")

describe('modutram', function ()
    describe('initialize', function ()
        it('initializes the modular tram station', function ()
            local slotConfigs = {{
                type = t.TRAM_UP,
                slotType = 'modutram_austria_tram_up_300cm',
                widthInCm = 300,
                namespace = 'austria'
            }}

            local modulesFromParams = {
                [Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2, xPos = 100})] = {
                    metadata = {
                        modutram = {
                            trackGauge = 1435
                        },
                        modutram_widthInCm = 300
                    }
                },
                [Slot.makeId({type = t.TRAM_UP, gridX = 3, gridY = 2, xPos = 300})] = {
                    metadata = {
                        modutram = {
                            trackGauge = 1000
                        },
                        modutram_widthInCm = 300
                    }
                },
                [Slot.makeId({type = t.TRAM_UP, gridX = -1, gridY = 3, xPos = 100})] = {
                    metadata = {
                        modutram = {
                            trackGauge = 1100
                        },
                        modutram_widthInCm = 300
                    }
                }
            }

            local params = {
                modules = modulesFromParams
            }
            local paramsFromModLua = {
                modules = slotConfigs
            }

            local result = {}

            Modutram.initialize(params, paramsFromModLua):bindToResult(result)

            assert.are.equal('TramUp', result.modutram.grid:get(1,2).class)
            assert.are.equal('TramUp', result.modutram.grid:get(3,2).class)
            assert.are.equal('TramUp', result.modutram.grid:get(-1,3).class)

            assert.are.same({{
                id = defaults.emptyModel,
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, result.models)
        end)
    end)
end)