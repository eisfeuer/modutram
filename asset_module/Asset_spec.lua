local Station = require('modutram.Station')
local Slot = require('modutram.slot.Slot')
local t = require('modutram.types')

local Asset = require('modutram.asset_module.Asset')

describe('Asset', function ()
    
    local station = Station:new{}
    local platform = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 2, gridY = 4}))
    local assetSlot = Slot:new{id = Slot.makeId({type = t.ASSET, gridX = 2, gridY = 4, assetId = 1}), moduleData = { metadata = {modutram_width = 3 }}}
    local asset = Asset:new{slot = assetSlot, parent = platform, options = {height = 23, poleRadius = 2}}
    local config = station.config
    --local decorationAssetSlot = Slot:new{id = Slot.makeId({type = t.ASSET_DECORATION, gridX = 2, gridY = 4, assetId = 1, assetDecorationId = 2 })}
    --local decoration = asset:registerDecoration(2, decorationAssetSlot, {anOption = 'value'})

    describe('getParentGridModule', function ()
        it('returns parent grid element', function ()
            assert.are.equal(platform, asset:getParentGridModule())
        end)
    end)

    describe('getSlotId', function ()
        it('returns slot id', function ()
            assert.are.equal(assetSlot.id, asset:getSlotId())
        end)
    end)

    describe('getId', function ()
        it('returns asset id', function ()
            assert.are.equal(1, asset:getId())
        end)
    end)

    describe('getType', function ()
        it ('returns type', function ()
            assert.are.equal(t.ASSET, asset:getType())
        end)
    end)

    describe('getGrid', function ()
        it('returns grid', function ()
            assert.are.equal(station.grid, asset:getGrid())
        end)
    end)

    describe('getGridX', function ()
        it('returns grid x', function ()
            assert.are.equal(2, asset:getGridX())
        end)
    end)

    describe('getGridY', function ()
        it('returns grid y', function ()
            assert.are.equal(4, asset:getGridY())
        end)
    end)

    describe("getOption", function ()
        it ('returns option', function ()
            assert.are.equal(23, asset:getOption('height', 34))
        end)

        it ('returns nil when option does not exists', function ()
            assert.are.equal(nil, asset:getOption('an_option'))
        end)

        it ('returns default when option does not exists', function ()
            assert.are.equal(42, asset:getOption('an_option', 42))
        end)

        it ('returns option from slot', function ()
            assert.are.equal(3, asset:getOption("width", 3))
        end)
    end)

    describe('getConfig', function ()
        it ('returns config', function ()
            assert.are.equal(config, asset:getConfig())
        end)
    end)

    -- describe("registerDecoration / getDecoration / hasDecoration", function ()
    --     it("registers asset", function ()
    --         assert.is_true(asset:hasDecoration(2))
    --         assert.are.equal(decorationAssetSlot.id, asset:getDecoration(2):getSlotId())
    --         assert.are.equal("value", asset:getDecoration(2):getOption('anOption'))
    --     end)

    --     it("returns nil when no asset is at given slot", function ()
    --         assert.is_nil(asset:getDecoration(3))
    --         assert.is_false(asset:hasDecoration(3))
    --     end)
    -- end)

    -- describe("addDecorationSlot", function ()
    --     it("adds asset slot to collection (2m above the base slot)", function ()
    --         local slots = {}

    --         asset:addDecorationSlot(slots, 3)
    --         local gridElement = asset:getParentGridModule()

    --         assert.are.same({{
    --             id = Slot.makeId({type = t.ASSET_DECORATION, gridX = 2, gridY = 4, assetId = 1, assetDecorationId = 3}),
    --             transf = {
    --                 1, 0, 0, 0,
    --                 0, 1, 0, 0,
    --                 0, 0, 1, 0,
    --                 gridElement:getAbsoluteX(), gridElement:getAbsoluteY(), 2, 1
    --             },
    --             type = 'motras_asset_decoration',
    --             spacing = c.DEFAULT_ASSET_SLOT_SPACING,
    --             shape = 0
    --         }}, slots)
    --     end)

    --     it("adds custom asset slot", function ()
    --         local slots = {}
    --         local gridElement = asset:getParentGridModule()

    --         asset:addDecorationSlot(slots, 3, {
    --             assetType = t.ASSET_DECORATION,
    --             slotType = 'decoration',
    --             position = {1, 2, 4},
    --             global = false,
    --             spacing = {1,1,1,1},
    --             shape = 2
    --         })

    --         assert.are.same({{
    --             id = Slot.makeId({type = t.ASSET_DECORATION, gridX = 2, gridY = 4, assetId = 1, assetDecorationId = 3}),
    --             transf = {
    --                 1, 0, 0, 0,
    --                 0, 1, 0, 0,
    --                 0, 0, 1, 0,
    --                 1, 2, 4, 1
    --             },
    --             type = 'decoration',
    --             spacing = {1, 1, 1, 1},
    --             shape = 2
    --         }}, slots)
    --     end)
    -- end)

end)