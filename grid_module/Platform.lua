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

    function Platform:isPlatform()
        return true
    end

    function Platform:canCallTerminalHandleFunc(terminalGroup)
        if not self.terminalHandleFunc then
            return false
        end
        
        if terminalGroup.trackDirection == 'left' then
            return self:canCallLeftTerminalHandleFunc()
        end
        if terminalGroup.trackDirection == 'right' then
            return self:canCallRightTerminalHandleFunc()
        end
    
        return false
    end

    return Platform
end

return PlatformClass