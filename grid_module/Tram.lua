local TramClass = {}

function TramClass:new(GridModule)
    local Tram = GridModule
    Tram.class = 'Tram'

    return Tram
end

return TramClass