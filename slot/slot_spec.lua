describe("slot", function ()
    local natbomb = require('modutram.slot.natbomb')
    local t = require('modutram.types')

    local Slot = require('modutram.slot.Slot')

    describe('makeId', function ()

        it('generates module id of a grid module', function ()
            local id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = 3,
                gridY = 1,
                xPos = 250,
            })

            assert.are.equal(natbomb.implode({6, 6, 14}, {t.TRAM_UP, 3 +  32, 1 + 32, 250}), id)
        end)

        it('generates module id of a grid module with negative xPos', function ()
            local id = Slot.makeId({
                type = t.TRAM_UP,
                gridX = -3,
                gridY = 1,
                xPos = -250,
            })

            assert.are.equal(natbomb.implode({6, 6, 14}, {t.TRAM_UP, -3 +  32, 1 + 32, 250}), id)
        end)

        it('generates module id of an asset module', function ()
            local id = Slot.makeId({
                type = t.DECORATION,
                gridX = -3,
                gridY = 1,
                assetId = 4,
                decorationId = 15
            })

            assert.are.equal(natbomb.implode({6, 6, 8, 6}, {t.DECORATION, -3 +  32, 1 + 32, 4, 15}), id)
        end)
    end)

    describe('asset module', function ()
        local slotId = natbomb.implode({6, 6, 8, 6}, {t.DECORATION, 3 +  32, 1 + 32, 2, 3})
        local slot = Slot:new{id = slotId}

        it('is not a grid module', function ()
            assert.is_false(slot:isGridModule())
        end)

        it('is an asset module', function ()
            assert.is_true(slot:isAssetModule())
        end)

        it('has id', function ()
            assert.are.equal(slotId, slot.id)
        end)

        it('has grid type', function ()
            assert.are.equal(t.TYPE_DECORATION, slot.moduleType)
        end)

        it('has type', function ()
            assert.are.equal(t.DECORATION, slot.type)
        end)

        it('has grid x position', function ()
            assert.are.equal(3, slot.gridX)
        end)

        it('has grid y position', function ()
            assert.are.equal(1, slot.gridY)
        end)

        it('has asset id', function ()
            assert.are.equal(2, slot.assetId)
        end)

        it('has asset decoration id', function ()
            assert.are.equal(3, slot.decorationId)
        end)

        it ('has no xPos', function ()
            assert.is_nil(slot.xPos)
        end)
    end)

    describe('grid module', function ()
        local slotId = natbomb.implode({6, 6, 14}, {t.TRAM_UP, 3 +  32, 1 + 32, 250})
        local slot = Slot:new{id = slotId}

        it('is a grid module', function ()
            assert.is_true(slot:isGridModule())
        end)

        it('is not an asset module', function ()
            assert.is_false(slot:isAssetModule())
        end)

        it('has id', function ()
            assert.are.equal(slotId, slot.id)
        end)

        it('has grid type', function ()
            assert.are.equal(t.TYPE_TRAM, slot.moduleType)
        end)

        it('has type', function ()
            assert.are.equal(t.TRAM_UP, slot.type)
        end)

        it('has grid x position', function ()
            assert.are.equal(3, slot.gridX)
        end)

        it('has grid y position', function ()
            assert.are.equal(1, slot.gridY)
        end)

        it('has no asset id', function ()
            assert.is_nil(slot.assetId)
        end)

        it('has no asset decoration id', function ()
            assert.is_nil(slot.decorationId)
        end)

        it('has y position', function ()
            assert.are.equal(250, slot.xPos)
        end)
    end)

    describe('grid module at negative position', function ()
        it ('has negative x position', function ()
            local slotId = natbomb.implode({6, 6, 14}, {t.TRAM_UP, -3 +  32, 1 + 32, 250})
            local slot = Slot:new{id = slotId}

            assert.are.equal(-250, slot.xPos)
        end)
    end)

    describe('moduleType', function ()
        it('returns tram', function ()
            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0, yPos = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.TYPE_TRAM, slot.moduleType)
        end)
        it('returns bus', function ()
            local slotId = Slot.makeId({type = t.BUS_BIDIRECTIONAL, gridX = 0, gridY = 0, yPos = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.TYPE_BUS, slot.moduleType)
        end)
        it('returns train', function ()
            local slotId = Slot.makeId({type = t.TRAIN, gridX = 0, gridY = 0, yPos = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.TYPE_TRAIN, slot.moduleType)
        end)
        it('returns platform', function ()
            local slotId = Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0, yPos = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.TYPE_PLATFORM, slot.moduleType)
        end)
        it('returns asset', function ()
            local slotId = Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 1, assetDecorationId = 0})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.TYPE_ASSET, slot.moduleType)
        end)
        it('returns decoration', function ()
            local slotId = Slot.makeId({type = t.DECORATION, gridX = 0, gridY = 0, assetId = 1, assetDecorationId = 1})
            local slot = Slot:new{id = slotId}

            assert.are.equal(t.TYPE_DECORATION, slot.moduleType)
        end)
    end)

    describe('getModuleData', function ()
        it ('returns empty table when not module data given', function ()
            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId}

            assert.are.same({}, slot:getModuleData())
        end)

        it ('returns module data', function ()
            local moduleData = {name = 'a.module'}

            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId, moduleData = moduleData}
            assert.are.equal(moduleData, slot:getModuleData())
        end)
    end)

    describe('getOptions', function ()
        it ('returns empty array when no module data given', function ()
            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId}

            assert.are.same({}, slot:getOptions())
        end)

        it ('returns options', function ()
            local moduleData = {
                name = 'a.module',
                metadata = {
                    modutram = {
                        speed = 120
                    },
                    modutram_hasCatenary = true,
                    katze = 'Mauz'
                }
            }

            local slotId = Slot.makeId({type = t.TRAM_UP, gridX = 0, gridY = 0})
            local slot = Slot:new{id = slotId, moduleData = moduleData}
            assert.are.same({
                moduleName = 'a.module',
                speed = 120,
                hasCatenary = true
            }, slot:getOptions())
        end)
    end)
end)