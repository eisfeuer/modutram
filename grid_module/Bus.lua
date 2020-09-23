local BusClass = {}

function BusClass.new(GridModule)
    local bus = GridModule
    bus.class = 'Bus'

    return bus
end

return BusClass