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

        it ('ignores asset, when there are no grid module to bind', function ()
            local station = Station:new{}

            local result = station:registerModule(Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3}), {
                metadata = {
                    modutram = {
                        trackGauge = 1435
                    },
                    modutram_trackWidth = 1.5
                }
            })

            assert.is_nil(result)
            assert.is_false(station.grid:has(1,2))
        end)

        it ('registers asset module', function ()
            local station = Station:new{}

            station:registerModule(Slot.makeId({type = t.PLATFORM_ISLAND, gridX = 1, gridY = 2}))
            local result = station:registerModule(Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3}), {
                metadata = {
                    modutram = {
                        trackGauge = 1435
                    },
                    modutram_trackWidth = 1.5
                }
            })

            assert.are_not.is_nil(result)
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
            [Slot.makeId({type = t.ASSET, gridX = -1, gridY = 3, assetId = 9})] = {
                metadata = {
                    modutram = {
                        height = 1500
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

        it ('gets asset module', function ()
            local station = Station:new{}

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2}))
            local slotId = Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3})

            local result = station:getModule(slotId)

            assert.are.equal(result, station.grid:get(1,2):getAsset(3))
        end)

        it ('gets decoration module', function ()
            local station = Station:new{}

            station:registerModule(Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2}))
            station:registerModule(Slot.makeId({type = t.ASSET, gridX = 1, gridY = 2, assetId = 3}))
            local slotId = Slot.makeId({type = t.DECORATION, gridX = 1, gridY = 2, assetId = 3, decorationId = 4})

            local result = station:getModule(slotId)

            assert.are.equal(result, station.grid:get(1,2):getAsset(3):getDecoration(4))
        end)
    end)

    describe('getModuleAt', function ()
        it ('get modules at given grid position', function ()
            local station = Station:new{}
            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2})

            station:registerModule(slotId)

            local result = station:getModuleAt(1,2)

            assert.are.equal(result, station.grid:get(1,2))
            assert.are.equal('TramUp', result.class)
        end)
    end)

    describe('isModuleAt', function ()
        it ('checks whether there is a module at given grid position', function ()
            local station = Station:new{}
            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 1, gridY = 2})

            station:registerModule(slotId)

            assert.is_true(station:isModuleAt(1,2))
            assert.is_false(station:isModuleAt(1,3))
        end)
    end)

    describe('addStreet', function ()
        it ('adds a street to construction', function ()
            local station = Station:new{}
            local result = {}

            station:bindToResult(result)

            assert.are.equal(0, station:addStreet('autobahn.lua', 'NO', {
                { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
            }))

            assert.are.same({
                {
                    type = 'STREET',
                    params = {
                        type = 'autobahn.lua',
                        tramTrackType = 'NO'
                    },
                    edges = {
                        { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {},
                    freeNodes = {},
                    tag2nodes = {},
                }
            }, result.edgeLists)

            assert.are.equal(2, station:addStreet('autobahn.lua', 'NO', {
                { { -1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                { {  1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
            }, {1}))

            assert.are.same({
                {
                    type = 'STREET',
                    params = {
                        type = 'autobahn.lua',
                        tramTrackType = 'NO'
                    },
                    edges = {
                        { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { { -1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {3},
                    freeNodes = {},
                    tag2nodes = {},
                }
            }, result.edgeLists)

            assert.are.equal(0, station:addStreet('landstrasse.lua', 'ELECTRIC', {
                { { -1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                { {  1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
            }, {1}))


            assert.are.same({
                {
                    type = 'STREET',
                    params = {
                        type = 'autobahn.lua',
                        tramTrackType = 'NO'
                    },
                    edges = {
                        { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { { -1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {3},
                    freeNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'STREET',
                    params = {
                        type = 'landstrasse.lua',
                        tramTrackType = 'ELECTRIC'
                    },
                    edges = {
                        { { -1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {1},
                    freeNodes = {},
                    tag2nodes = {},
                }
            }, result.edgeLists)
        end)
    end)

    describe('addTrack', function ()
        it ('adds a track to construction', function ()
            local station = Station:new{}
            local result = {}

            station:bindToResult(result)

            assert.are.equal(0, station:addTrack('monorail.lua', false, {
                { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
            }))

            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'monorail.lua',
                        catenary = false
                    },
                    edges = {
                        { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {},
                    freeNodes = {},
                    tag2nodes = {},
                }
            }, result.edgeLists)

            assert.are.equal(2, station:addStreet('monorail.lua', false, {
                { { -1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                { {  1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
            }, {1}))

            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'monorail.lua',
                        catenary = false
                    },
                    edges = {
                        { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { { -1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {3},
                    freeNodes = {},
                    tag2nodes = {},
                }
            }, result.edgeLists)

            assert.are.equal(0, station:addStreet('high_speed.lua', true, {
                { { -1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                { {  1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
            }, {1}))


            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'monorail.lua',
                        catenary = false
                    },
                    edges = {
                        { { -1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 0.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { { -1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, 1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {3},
                    freeNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = true
                    },
                    edges = {
                        { { -1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                        { {  1.0, -1.0, 0.0 }, { 2.0, 0.0, 0.0 } },
                    },
                    snapNodes = {1},
                    freeNodes = {},
                    tag2nodes = {},
                }
            }, result.edgeLists)
        end)
    end)

end)