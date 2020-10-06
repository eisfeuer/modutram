local optional = require "modutram.helper.optional"

local Theme = {}

function Theme:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Theme:get(moduleType)
    return optional(self.theme[moduleType]).moduleName or optional(self.defaultTheme[moduleType]).moduleName
end

function Theme:getWidthInCm(moduleType)
    return optional(self.theme[moduleType]).widthInCm or optional(self.defaultTheme[moduleType]).widthInCm
end

return Theme