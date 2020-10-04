local AssetBlueprint = require("modutram.blueprint.AssetBlueprint")

local AssetCollection = {}

function AssetCollection:new(o)
    o = o or {}

    o.assets = {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetCollection:addBlueprint(assetId, assetBlueprint)
    self.assets[assetId] = assetBlueprint
    return self
end

function AssetCollection:addModule(assetId, assetModuleName)
    self:addBlueprint(assetId, AssetBlueprint:new{moduleName = assetModuleName})
    return self
end

function AssetCollection:place(result, gridX, gridY)
    for assetId, assetBlueprint in pairs(self.assets) do
        assetBlueprint:place(result, gridX, gridY, assetId)
    end
end

return AssetCollection