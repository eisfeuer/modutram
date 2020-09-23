local Station = require('modutram.Station')
local Slot = require('modutram.slot.Slot')
local t = require('modutram.types')

describe('Station', function ()
    describe('bindToResults', function ()
        it('binds empty station to results', function ()
            local station = Station:new{}

            local result = {}

            station:bindToResult(result)

            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, result.models)
        end)
    end)

    describe('registerModule', function ()
        it ('adds module to the grid', function ()
            local station = Station:new{}

            local result = station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2}), {
                metadata = {
                    modutram = {
                        trackGauge = 1435
                    },
                    modutram_trackWidth = 1.5
                }
            })

            assert.are.equal(result, station.grid:get(1,2))
            assert.are.equal('TramUp', result.class)
            assert.are.equal(1435, result:getOption('trackGauge'))
            assert.are.equal(1.5, result:getOption('trackWidth'))
        end)
    end)

    describe('registerAllModules', function ()
        local modulesFromParam = {
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

        local station = Station:new{}

        station:registerAllModules(modulesFromParam)

        assert.are.equal('TramUp', station.grid:get(1,2).class)
        assert.are.equal(1435, station.grid:get(1,2):getOption('trackGauge'))
        assert.are.equal('TramUp', station.grid:get(3,2).class)
        assert.are.equal(1000, station.grid:get(3,2):getOption('trackGauge'))
        assert.are.equal('TramUp', station.grid:get(-1,3).class)
        assert.are.equal(1100, station.grid:get(-1,3):getOption('trackGauge'))
    end)

    describe('getModule', function ()
        it ('gets module by slot id', function ()
            local station = Station:new{}
            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2})

            station:registerModule(slotId)

            local result = station:getModule(slotId)

            assert.are.equal(result, station.grid:get(1,2))
            assert.are.equal('TramUp', result.class)
        end)
    end)
end)