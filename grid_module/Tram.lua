local TramClass = {}

function TramClass:new(GridModule)
    local Tram = GridModule
    Tram.class = 'Tram'

    function Tram:isTram()
        return true
    end

    function Tram:isTrack()
        return true
    end

    return Tram
end

return TramClass