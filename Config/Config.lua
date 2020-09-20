local merge = require('modutram.helper.merge')
local defaults = require('modutram.Config.defaults')

local Config = {}

function Config:new(o)
    o = o or {}
    o = merge(defaults, o)
    
    setmetatable(o, self)
    self.__index = self

    return o
end

return Config