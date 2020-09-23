local Platform = require("modutram.grid_module.Platform")

-- @module modutram.grid_module.PlatformIsland
local PlatformIslandClass = {}

function PlatformIslandClass:new(Platform)
    local PlatformIsland = Platform
    PlatformIsland.class = 'PlatformIsland'

    return PlatformIsland
end

function PlatformIslandClass.getParentClass()
    return Platform
end

return PlatformIslandClass