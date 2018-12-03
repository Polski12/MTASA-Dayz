function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

addCommandHandler("gp1",function(cmd)
  local x,y,z = getElementPosition(localPlayer)
  local position = string.format("%s,%s,%s",math.round(x,2),math.round(y,2),math.round(z,2))
  outputChatBox(position)
  setClipboard(position)
end)

addCommandHandler("gp2",function(cmd)
  local x,y,z = getElementPosition(localPlayer)
  local _,_,r = getElementRotation(localPlayer)
  local position = string.format("%s,%s,%s,%s",math.round(x,2),math.round(y,2),math.round(z,2),math.ceil(r))
  outputChatBox(position)
  setClipboard(position)
end)

addCommandHandler("gpc",function(cmd)
  local x,y,z = getCameraMatrix(localPlayer)
  local position = string.format("%s,%s,%s",math.round(x,2),math.round(y,2),math.round(z,2))
  outputChatBox(position)
  setClipboard(position)
end)