local Decoration = {}

function Decoration:new(o)
    o = o or {}

    if not o.slot and o.parent then
        error ('Required parameter slot or parent is missing')
    end

    o.options = o.options or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Decoration:getId()
    return self.slot.decorationId
end

function Decoration:getSlotId()
    return self.slot.id
end

function Decoration:getGridX()
    return self.slot.gridX
end

function Decoration:getGridY()
    return self.slot.gridY
end

function Decoration:getAssetId()
    return self.slot.assetId
end

function Decoration:getParentAsset()
    return self.parent
end

function Decoration:getParentGridModule()
    return self.parent:getParentGridModule()
end

function Decoration:getOption(option, default)
    return self.options[option] or default
end

function Decoration:getConfig()
    return self.parent:getConfig()
end

return Decoration