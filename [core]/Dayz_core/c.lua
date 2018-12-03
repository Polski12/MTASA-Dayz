function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end

function getElementSpeed(theElement,unit)
    -- Check arguments for errors
    assert(isElement(theElement),"Bad argument 1 @ getElementSpeed (element expected,got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle","Invalid element type @ getElementSpeed (player/ped/object/vehicle expected,got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"),"Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector,after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement))*mult).length
end

function update()
  przedmioty = getElementData(root,"przedmioty")
  przedmiotyKategorie = getElementData(root,"przedmiotyKategorie")
  bronie = getElementData(root,"bronie")
  if(not bronie or not przedmiotyKategorie or not przedmioty)then
    setTimer(update,500,1)
  end
end
update()