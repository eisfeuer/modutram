local EdgeListMap = require('modutram.edge_list.EdgeListMap')

describe('EdgeListMap', function ()
    local edgeList1 = {
        type = 'TRACK',
        params = {
            type = 'standard.lua',
            catenary = false
        },
        edges = {},
        snapNodes = {},
        tag2nodes = {},
    }

    local edgeList2 = {
        type = 'TRACK',
        params = {
            type = 'standard.lua',
            catenary = true
        },
        edges = {},
        snapNodes = {},
        tag2nodes = {},
    }

    local edgeList3 = {
        type = 'TRACK',
        params = {
            type = 'high_speed.lua',
            catenary = false
        },
        edges = {},
        snapNodes = {},
        tag2nodes = {},
    }

    local edgeList4 = {
        type = 'STREET',
        params = {
            type = 'country_small.lua',
            tramTrackType = 'ELECTRIC'
        },
        edges = {},
        snapNodes = {},
        tag2nodes = {},
    }

    local edgeLists = {
        edgeList1, edgeList2, edgeList3, edgeList4
    }

    local edgeListMap = EdgeListMap:new{edgeLists = edgeLists}

    describe('getOrCreateEdgeList', function ()
        it('returns existing edge list', function ()
            assert.are.equal(edgeList1, edgeListMap:getOrCreateEdgeList('standard.lua', false))
            assert.are.equal(edgeList2, edgeListMap:getOrCreateEdgeList('standard.lua', true))
            assert.are.equal(edgeList3, edgeListMap:getOrCreateEdgeList('high_speed.lua', false))
            assert.are.equal(edgeList4, edgeListMap:getOrCreateEdgeList('country_small.lua', 'ELECTRIC'))
            
            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = true
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'STREET',
                    params = {
                        type = 'country_small.lua',
                        tramTrackType = 'ELECTRIC'
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }
            }, edgeLists)
        end)

        it('creates new edge lists', function ()
            assert.are.same({
                type = 'TRACK',
                params = {
                    type = 'high_speed.lua',
                    catenary = true
                },
                edges = {},
                snapNodes = {},
                tag2nodes = {},
                freeNodes = {},
            }, edgeListMap:getOrCreateEdgeList('high_speed.lua', true))

            assert.are.same({
                type = 'TRACK',
                params = {
                    type = 'monorail.lua',
                    catenary = false
                },
                edges = {},
                snapNodes = {},
                tag2nodes = {},
                freeNodes = {},
            }, edgeListMap:getOrCreateEdgeList('monorail.lua', false))

            assert.are.same({
                type = 'STREET',
                params = {
                    type = 'country_small.lua',
                    tramTrackType = "YES"
                },
                edges = {},
                snapNodes = {},
                tag2nodes = {},
                freeNodes = {},
            }, edgeListMap:getOrCreateEdgeList('country_small.lua', 'YES'))

            assert.are.same({
                {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'standard.lua',
                        catenary = true
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'STREET',
                    params = {
                        type = 'country_small.lua',
                        tramTrackType = 'ELECTRIC'
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'high_speed.lua',
                        catenary = true
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                    freeNodes = {}
                }, {
                    type = 'TRACK',
                    params = {
                        type = 'monorail.lua',
                        catenary = false
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                    freeNodes = {}
                }, {
                    type = 'STREET',
                    params = {
                        type = 'country_small.lua',
                        tramTrackType = "YES"
                    },
                    edges = {},
                    snapNodes = {},
                    tag2nodes = {},
                    freeNodes = {}
                }
            }, edgeLists)
        end)
    end)

    describe('getEdgeLists', function ()
        it('returns edge lists table', function ()
            assert.are.equal(edgeLists, edgeListMap:getEdgeLists())
        end)
    end)

    describe('getIndexOfFirstNodeInEdgeList', function ()
        it ('returs absolute index of first index in the edge list', function ()
            local edgeList5 = {
                type = 'TRACK',
                params = {
                    type = 'standard.lua',
                    catenary = false
                },
                edges = {
                    {{-10.0, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                    {{10.0, 0.0, 0.0}, {20.0, 0.0, 0.0}},
                },
                snapNodes = {},
                tag2nodes = {},
            }
            local edgeList6 = {
                type = 'TRACK',
                params = {
                    type = 'high_speed.lua',
                    catenary = false
                },
                edges = {
                    {{-10.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},
                    {{0.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},

                    {{0.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},
                    {{10.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},
                },
                snapNodes = {},
                tag2nodes = {},
            }
            local edgeList7 = {
                type = 'TRACK',
                params = {
                    type = 'high_speed.lua',
                    catenary = true
                },
                edges = {
                    {{-10.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},
                    {{0.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},

                    {{0.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},
                    {{10.0, 0.0, 0.0}, {10.0, 0.0, 0.0}},
                },
                snapNodes = {},
                tag2nodes = {},
            }

            local edgeLists2 = {
                edgeList5, edgeList6, edgeList7
            }
        
            local edgeListMap2 = EdgeListMap:new{edgeLists = edgeLists2}

            assert.are.equal(0, edgeListMap2:getIndexOfFirstNodeInEdgeList('standard.lua', false))
            assert.are.equal(2, edgeListMap2:getIndexOfFirstNodeInEdgeList('high_speed.lua', false))
            assert.are.equal(6, edgeListMap2:getIndexOfFirstNodeInEdgeList('high_speed.lua', true))
        end)
    end)

end)