local Station = require("modutram.Station")
local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

describe("AssetDecoration", function ()
    
    local station = Station:new{}
    local platform = station:registerModule(Slot.makeId({type = t.PLATFORM_LEFT, gridX = 0, gridY = 0}))
    local asset = station:registerModule(Slot.makeId({type = t.ASSET, gridX = 0, gridY = 0, assetId = 4}))
    local deco = station:registerModule(Slot.makeId({type = t.DECORATION, gridX = 0, gridY = 0, assetId = 4, decorationId = 7}), {
        metadata = {modutram = {length = 3}}
    })

    describe('getId', function ()
        it('returns asset decoration id', function ()
            assert.are.equal(7, deco:getId())
        end)
    end)

    describe('getSlotId', function ()
        it('returns slot id', function ()
            assert.are.equal(Slot.makeId({type = t.DECORATION, gridX = 0, gridY = 0, assetId = 4, decorationId = 7}), deco:getSlotId())
        end)
    end)

    describe('getParentAsset', function ()
        it('returns parent asset', function ()
            assert.are.equal(asset, deco:getParentAsset())
        end)
    end)

    describe('getParentGridModule', function ()
        it('returns parent grid module', function ()
            assert.are.equal(platform, deco:getParentGridModule())
        end)
    end)

    describe('getGridX', function ()
        it('returns grid x', function ()
            assert.are.equal(platform:getGridX(), deco:getGridX())
        end)
    end)

    describe('getGridY', function ()
        it('returns grid y', function ()
            assert.are.equal(platform:getGridY(), deco:getGridY())
        end)
    end)

    describe('getAssetId', function ()
        it('returns asset id', function ()
            assert.are.equal(asset:getId(), deco:getAssetId())
        end)
    end)

    describe("getOption", function ()
        it ('returns nil when option does not exists', function ()
            assert.are.equal(nil, deco:getOption('an_option'))
        end)

        it ('returns default when option does not exists', function ()
            assert.are.equal(42, deco:getOption('an_option', 42))
        end)

        it ('gets option from module data', function ()
            assert.are.equal(3, deco:getOption('length', 3))
        end)
    end)
end)