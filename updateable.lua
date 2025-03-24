local updateables = setmetatable({}, {__mode = 'v'})

Updateable = {
    awake = true,
    visible = true,
    __gc = function(self)
        local i = 1
        while updateables[i] == self do i += 1 end
        table.remove(updateables, table.remove(updateables[i]))
    end
}


function Updateable.updateAll()
    for i=1, #updateables do
        if updateables[i].update ~= nil then updateables[i]:update() end
    end
end



function Updateable.drawAll()
    for i=1, #updateables do
        if updateables[i].draw ~= nil then updateables[i]:draw() end
    end
end

function Updateable.new(t)
    local tbl = setmetatable(t or {}, Updateable)
    table.insert(updateables, tbl)
    return tbl
end

return Updateable
