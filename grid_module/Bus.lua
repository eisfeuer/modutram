local BusClass = {}

function BusClass.new(GridModule)
    local Bus = GridModule
    Bus.class = 'Bus'

    function Bus:isBus()
        return true
    end

    return Bus
end

return BusClass