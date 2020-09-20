local merge = require('modutram.helper.merge')

local Config = {}

function Config:new(o)
    o = o or {}

    local defaults = {
        gridModuleLength = 18,
        baseHeight = 0
    }

    o = merge(defaults, o)
    
    setmetatable(o, self)
    self.__index = self

    return o
end

return Config