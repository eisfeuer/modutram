local PlatformClass = {}

function PlatformClass:new(GridModule)
    local Platform = GridModule
    Platform.class = 'Platform'

    return Platform
end

return PlatformClass