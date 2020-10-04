local Slot = require("modutram.slot.Slot")
local t = require("modutram.types")
local optional = require("modutram.helper.optional")
local Decoration = require("modutram.asset_module.Decoration")

local Asset = {}

function Asset:new(o)
    o = o or {}

    if not o.slot and o.parent then
        error ("Required parameter slot or parent is missing")
    end

    o.decorations = {}
    o.handleFunction = function ()

    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function Asset:getParentGridModule()
    return self.parent
end

function Asset:getId()
    return self.slot.assetId
end

function Asset:getGrid()
    return self.parent:getGrid()
end

function Asset:getSlotId()
    return self.slot.id
end

function Asset:getType()
    return self.slot.type
end

function Asset:getGridX()
    return self.slot.gridX
end

function Asset:getGridY()
    return self.slot.gridY
end

function Asset:getOption(key, default)
    if self.options[key] == nil then
        if optional(self.slot:getOptions())[key] == nil then
            return default
        end

        return self.slot:getOptions()[key]
    end
    
    return self.options[key]
end

function Asset:getConfig()
    return self.parent:getConfig()
end

function Asset:registerDecoration(slot)
    if self.decorations[slot.decorationId] then
        error("Slot already has decoration")
    end

    local decoration = Decoration:new{slot = slot, parent = self}
    self.decorations[slot.decorationId] = decoration
    
    return decoration
end

function Asset:hasDecoration(decorationId)
    return self:getDecoration(decorationId) ~= nil
end

function Asset:getDecoration(decorationId)
    return self.decorations[decorationId]
end

function Asset:addDecorationSlot(result, decorationId, slotType, transformation, spacing, shape)
    local decorationSlotId = Slot.makeId({
        type = t.DECORATION,
        gridX = self:getGridX(),
        gridY = self:getGridY(),
        assetId = self:getId(),
        decorationId = decorationId
    })

    table.insert(result.slots, {
        id = decorationSlotId,
        transf = transformation,
        type = slotType,
        spacing = spacing or self:getConfig().defaultAssetSlotSpacing,
        shape = shape or 0
    })
end

return Asset