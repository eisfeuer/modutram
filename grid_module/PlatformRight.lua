local Platform = require("modutram.grid_module.Platform")

-- @module modutram.grid_module.PlatformRight
local PlatformRightClass = {}

function PlatformRightClass:new(Platform)
    local PlatformRight = Platform
    PlatformRight.class = 'PlatformRight'

    return PlatformRight
end

function PlatformRightClass.getParentClass()
    return Platform
end


return PlatformRightClass