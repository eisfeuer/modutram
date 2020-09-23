local Modutram = require('modutram.modutram')
local Slot = require('modutram.slot.Slot')
local t = require('modutram.types')

describe('modutram', function ()
    describe('initialize', function ()
        it('initializes the modular tram station', function ()
            local modulesFromParams = {
                [Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2})] = {
                    metadata = {
                        modutram = {
                            trackGauge = 1435
                        },
                    }
                },
                [Slot.makeId({type = t.TRAM_UP, gridX = 3, gridY = 2})] = {
                    metadata = {
                        modutram = {
                            trackGauge = 1000
                        },
                    }
                },
                [Slot.makeId({type = t.TRAM_UP, gridX = -1, gridY = 3})] = {
                    metadata = {
                        modutram = {
                            trackGauge = 1100
                        },
                    }
                }
            }
            local params = {
                modules = modulesFromParams
            }

            local result = {}

            Modutram.initialize(params, {}):bindToResult(result)

            assert.are.equal('TramUp', result.modutram.grid:get(1,2).class)
            assert.are.equal('TramUp', result.modutram.grid:get(3,2).class)
            assert.are.equal('TramUp', result.modutram.grid:get(-1,3).class)

            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, result.models)
        end)
    end)
end)