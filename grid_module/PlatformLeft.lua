local Platform = require("modutram.grid_module.Platform")

-- @module modutram.grid_module.PlatformLeft
local PlatformLeftClass = {}

function PlatformLeftClass:new(Platform)
    local PlatformLeft = Platform
    PlatformLeft.class = 'PlatformLeft'

    return PlatformLeft
end

function PlatformLeftClass.getParentClass()
    return Platform
end


return PlatformLeftClass