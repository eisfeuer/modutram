local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")

local AssetBlueprint = {}

function AssetBlueprint:new(o)
    o = o or {}

    if not o.moduleName then
        error("AssetBlueprint object MUST have a moduleName Attribute")
    end

    o.decorations = {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetBlueprint:decorate(decorationId, moduleName)
    self.decorations[decorationId] = moduleName
    return self
end

function AssetBlueprint:place(result, gridX, gridY, assetId)
    result[Slot.makeId({type = t.ASSET, gridX = gridX, gridY = gridY, assetId = assetId})] = self.moduleName
    for decorationId, decorationModulName in pairs(self.decorations) do
        result[Slot.makeId({type = t.ASSET, gridX = gridX, gridY = gridY, assetId = assetId, decorationId = decorationId})] = decorationModulName
    end
end

return AssetBlueprint