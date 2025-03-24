function Bool2Int(val)
    return val and 1 or 0
end

function table.randomizearray(arr)
    for i=1, #arr do
        local randPos = math.random(#arr)
        local a = arr[i]
        local b = arr[randPos]
        arr[i] = b
        arr[randPos] = a
    end
end
function math.inarrbounds(max, val)
    return val >= 1 and val <= max;
end
