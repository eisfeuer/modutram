local except = require("modutram.helper.except")
local t = require("modutram.types")

local PlatformClass = {}

function PlatformClass:new(GridModule)
    local Platform = GridModule
    Platform.class = 'Platform'
    Platform.possibleLeftNeighbors = except(
        GridModule.possibleLeftNeighbors,
        {t.PLATFORM_ISLAND, t.PLATFORM_LEFT, t.PLATFORM_RIGHT}
    )
    Platform.possibleRightNeighbors = except(
        GridModule.possibleRightNeighbors,
        {t.PLATFORM_ISLAND, t.PLATFORM_LEFT, t.PLATFORM_RIGHT}
    )

    return Platform
end

return PlatformClass