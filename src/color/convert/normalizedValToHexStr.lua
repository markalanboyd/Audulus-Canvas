function normalizedValToHexStr(nVal)
    return "#" .. string.format("%08X", math.floor(nVal * 0xFFFFFFFF))
end
