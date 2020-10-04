local Slot = require('modutram.slot.Slot')
local t = require('modutram.types')
local optional = require('modutram.helper.optional')

local Asset = {}

function Asset:new(o)
    o = o or {}

    if not o.slot and o.parent then
        error ('Required parameter slot or parent is missing')
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

-- function Asset:registerDecoration(assetDecorationId, assetDecorationSlot, options)
--     local decorationType = assetDecorationSlot.type

--     if not self.decorations[decorationType] then
--         self.decorations[decorationType] = {}
--     end

--     if self.decorations[decorationType][assetDecorationId] then
--         error('Decoration slot ' .. assetDecorationId .. ' is occupied')
--     end

--     local decoration = AssetDecoration:new{slot = assetDecorationSlot, parent = self, options = options}
--     self.decorations[decorationType][assetDecorationId] = decoration
    
--     return decoration
-- end

-- function Asset:hasDecoration(assetDecorationId, decorationType)
--     return self:getDecoration(assetDecorationId, decorationType) ~= nil
-- end

-- function Asset:getDecoration(assetDecorationId, decorationType)
--     decorationType = decorationType or t.ASSET_DECORATION
--     return self.decorations[decorationType] and self.decorations[decorationType][assetDecorationId]
-- end

-- function Asset:addDecorationSlot(slotCollection, assetDecorationId, options)
--     if not slotCollection then
--         error('slot collection parameter is required (normally result.slots)')
--     end
--     if not assetDecorationId then
--         error('asset id parameter is required')
--     end

--     options = options or {}
--     local assetDecorationSlotId = Slot.makeId({
--         type = options.assetDecorationType or t.ASSET_DECORATION,
--         gridX = self:getGridX(),
--         gridY = self:getGridY(),
--         assetId = self:getId(),
--         assetDecorationId = assetDecorationId
--     })

--     local parent = self:getParentGridElement()
--     local position = options.position or {parent:getAbsoluteX(), parent:getAbsoluteY(), parent:getAbsoluteZ() + 2}

--     local transformation = options.transformation or {
--         1, 0, 0, 0,
--         0, 1, 0, 0,
--         0, 0, 1, 0,
--         0, 0, 0, 1
--     }

--     transformation = Transf.mul(transformation, Transf.rotZTransl(math.rad(options.rotation or 0), {x = position[1], y = position[2], z = position[3]}))

--     table.insert(slotCollection, {
--         id = assetDecorationSlotId,
--         transf = transformation,
--         type = options.slotType or self:getGrid():getModulePrefix() .. '_asset_decoration',
--         spacing = options.spacing or c.DEFAULT_ASSET_SLOT_SPACING,
--         shape = options.shape or 0
--     })
-- end

return Asset