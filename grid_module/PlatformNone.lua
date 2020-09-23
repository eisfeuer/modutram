local Platform = require("modutram.grid_module.Platform")

-- @module modutram.grid_module.PlatformNone
local PlatformNoneClass = {}

function PlatformNoneClass:new(Platform)
    local PlatformNone = Platform
    PlatformNone.class = 'PlatformNone'

    return PlatformNone
end

function PlatformNoneClass.getParentClass()
    return Platform
end


return PlatformNoneClass