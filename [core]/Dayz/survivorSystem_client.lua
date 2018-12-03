function setClientNight(hour, minutes)
  if hour == 21 then
    setSkyGradient(0, 100 / minutes, 196 / minutes, 136 / minutes, 170 / minutes, 212 / minutes)
    setFarClipDistance(120 + (880 - minutes * 14.6))
    setFogDistance(-150 + (250 - minutes * 4.16))
  elseif hour == 7 then
    setSkyGradient(0, 1.6 * minutes, 638.9599999999999, 307.35999999999996, 481.1, 748.36)
    setFarClipDistance(120 + minutes * 14.6)
    setFogDistance(-150 + minutes * 4.16)
  elseif hour == 22 or hour == 23 then
    setSkyGradient(0, 0, 0, 0, 0, 0)
    setFarClipDistance(120)
    setFogDistance(-150)
  elseif hour >= 0 and hour <= 7 then
    setSkyGradient(0, 0, 0, 0, 0, 0)
    setFarClipDistance(120)
    setFogDistance(-150)
  else
    setSkyGradient(0, 100, 196, 136, 170, 212)
    setFarClipDistance(1000)
    setFogDistance(100)
  end
end
function getGroundMaterial(x, y, z)
  local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z, x, y, z - 10, true, false, false, true, false, false, false, false, nil)
  return material
end
function isInBuilding(x, y, z)
  local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z, x, y, z + 10, true, false, false, true, false, false, false, false, nil)
  if hit then
    return true
  end
  return false
end
function isObjectAroundPlayer2(thePlayer, distance, height)
  material_value = 0
  local x, y, z = getElementPosition(thePlayer)
  for i = math.random(0, 360), 360 do
    local nx, ny = getPointFromDistanceRotation(x, y, distance, i)
    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z + height, nx, ny, z + height, true, false, false, false, false, false, false, false)
    if material == 0 then
      material_value = material_value + 1
    end
    if material_value > 40 then
      return 0, hitX, hitY, hitZ
    end
  end
  return false
end
function isObjectAroundPlayer(thePlayer, distance, height)
  local x, y, z = getElementPosition(thePlayer)
  for i = math.random(0, 360), 360 do
    local nx, ny = getPointFromDistanceRotation(x, y, distance, i)
    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z + height, nx, ny, z + height)
    if material == 0 then
      return material, hitX, hitY, hitZ
    end
  end
  return false
end
function getPointFromDistanceRotation(x, y, dist, angle)
  local a = math.rad(90 - angle)
  local dx = math.cos(a) * dist
  local dy = math.sin(a) * dist
  return x + dx, y + dy
end
function zombieSpawning()
  local x, y, z = getElementPosition(getLocalPlayer())
  local material, hitX, hitY, hitZ = isObjectAroundPlayer2(getLocalPlayer(), 30, 3)
  if material == 0 and not isInBuilding(x, y, z) then
    triggerServerEvent("createZomieForPlayer", getLocalPlayer(), hitX, hitY, hitZ)
  end
end
setTimer(zombieSpawning, 3000, 0)
function stopZombieSound()
  local zombies = getElementsByType("ped")
  for theKey, theZomb in ipairs(zombies) do
    setPedVoice(theZomb, "PED_TYPE_DISABLED")
  end
end
setTimer(stopZombieSound, 5000, 0)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
function getWeaponDamage(weapon)
  for i, weapon2 in ipairs(damageTable) do
    local t, weapon1 = getWeaponAmmoType(weapon2[1])
    if weapon1 == weapon then
      if getElementData(getLocalPlayer(), "humanity") == 5000 and (weapon2[1] == "M1911" or weapon2[1] == "M9 SD" or weapon2[1] == "PDW") then
        return weapon2[2] * 0.3
      end
      return weapon2[2]
    end
  end
end
function playRandomHitSound()
  local number = math.random(1, 3)
  local sound = playSound("sounds/hit" .. number .. ".mp3")
end

function pedGetDamageDayZ(attacker, weapon, bodypart, loss)
  cancelEvent()
  if attacker and attacker == getLocalPlayer() then
    damage = 100
    if weapon == 37 then
      return
    end
    if weapon == 63 or weapon == 51 or weapon == 19 then
      setElementData(source, "blood", 0)
      if 0 >= getElementData(source, "blood") then
        triggerServerEvent("onZombieGetsKilled", source, attacker)
      end
    elseif weapon and weapon > 1 and attacker and getElementType(attacker) == "player" then
      damage = getWeaponDamage(weapon)
      if bodypart == 9 then
        damage = damage * 1.5
        headshot = true
      end
      setElementData(source, "blood", getElementData(source, "blood") - math.random(damage * 0.75, damage * 1.25))
      if 0 >= getElementData(source, "blood") then
        triggerServerEvent("onZombieGetsKilled", source, attacker, headshot)
      end
    end
  end
end
addEventHandler("onClientPedDamage", getRootElement(), pedGetDamageDayZ)

function dayZDeathInfo()
  fadeCamera(false, 1, 0, 0, 0)
  setTimer(showDayZDeathScreen, 2000, 1)
end
addEvent("onClientPlayerDeathInfo", true)
addEventHandler("onClientPlayerDeathInfo", getRootElement(), dayZDeathInfo)
function showDayZDeathScreen()
  setTimer(fadeCamera, 1000, 1, true, 1.5)
  deadBackground = guiCreateStaticImage(0, 0, 1, 1, "images/dead.jpg", true)
  deathText = guiCreateLabel(0, 0.8, 1, 0.2, [[
You died! 
 You will respawn in 5 seconds.]], true)
  guiLabelSetHorizontalAlign(deathText, "center")
  setTimer(guiSetVisible, 5000, 1, false)
  setTimer(guiSetVisible, 5000, 1, false)
  setTimer(destroyElement, 5000, 1, deathText)
  setTimer(destroyElement, 5000, 1, deadBackground)
end
whiteWindow = guiCreateStaticImage(0, 0, 1, 1, "images/white.png", true)
guiSetVisible(whiteWindow, false)
function showPlayerDamageScreen(visibly2, stateControle2)
  guiSetVisible(whiteWindow, true)
  visibly = visibly2 or visibly
  stateControle = stateControle2 or stateControle
  if visibly >= 0.15000000000000002 and stateControle == "up" then
    stateControle = "down"
  end
  if visibly < 0 then
    guiSetVisible(whiteWindow, false)
    return
  end
  if stateControle == "up" then
    visibly = visibly + 0.025
  elseif stateControle == "down" then
    visibly = visibly - 0.025
  end
  guiSetAlpha(whiteWindow, visibly)
  setTimer(showPlayerDamageScreen, 50, 1)
end
function showWhiteScreen(attacker, weapon, bodypart)
  showPlayerDamageScreen(0, "up")
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), showWhiteScreen)
supportWindow = guiCreateStaticImage(0.05, 0.25, 0.9, 0.5, "images/scrollmenu_1.png", true)
guiSetVisible(supportWindow, false)
supportGridlist = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, supportWindow)
nameColumn = guiGridListAddColumn(supportGridlist, "Name", 0.2)
messageColumn = guiGridListAddColumn(supportGridlist, "Message", 0.8)
messageInput = guiCreateEdit(0.05, 0.825, 0.9, 0.075, "", true, supportWindow)
closeButton = guiCreateButton(0.9, 0.015, 0.09, 0.05, "Close", true, supportWindow)
function openSupportChat()
  local showing = guiGetVisible(supportWindow)
  guiSetInputMode("no_binds_when_editing")
  guiSetVisible(supportWindow, not showing)
  if getElementData(getLocalPlayer(), "supporter") or getElementData(getLocalPlayer(), "admin") then
    guiSetVisible(supporterWindow, not showing)
  end
  if showing then
    guiSetVisible(supporterWindow, false)
  end
  showCursor(not showing)
  toggleControl("chatbox", showing)
  if showing == false then
    unbindKey("o", "down", openSupportChat)
    unbindKey("j", "down", showInventory)
  else
    bindKey("o", "down", openSupportChat)
    bindKey("j", "down", showInventory)
  end
end
bindKey("o", "down", openSupportChat)
function outputEditBox()
  local showing = guiGetVisible(supportWindow)
  guiSetVisible(supportWindow, false)
  showCursor(false)
  toggleControl("chatbox", true)
  bindKey("o", "down", openSupportChat)
  bindKey("j", "down", showInventory)
end
addEventHandler("onClientGUIClick", closeButton, outputEditBox, false)
bindKey("o", "down", outputEditBox)
addEventHandler("onClientGUIAccepted", messageInput, function(theElement)
  if not isSpamTimer() then
    local text = guiGetText(theElement)
    triggerServerEvent("onServerSupportChatMessage", getLocalPlayer(), getLocalPlayer(), text)
  end
  setAntiSpamActive()
  guiSetText(messageInput, "")
end)
function outputSupportChat(sourcePlayer, text)
  local row = guiGridListAddRow(supportGridlist)
  if sourcePlayer == "Sandra" or sourcePlayer == "James" or sourcePlayer == "Paul" then
    name = sourcePlayer .. " (Bot)"
  elseif not getElementData(sourcePlayer, "logedin") then
    name = string.gsub(getPlayerName(sourcePlayer), "#%x%x%x%x%x%x", "") .. " (Guest)"
  elseif getElementData(sourcePlayer, "admin") then
    name = string.gsub(getPlayerName(sourcePlayer), "#%x%x%x%x%x%x", "") .. " (Admin)"
  elseif getElementData(sourcePlayer, "supporter") then
    name = string.gsub(getPlayerName(sourcePlayer), "#%x%x%x%x%x%x", "") .. " (Supporter)"
  else
    name = string.gsub(getPlayerName(sourcePlayer), "#%x%x%x%x%x%x", "") .. " (Player)"
  end
  guiGridListSetItemText(supportGridlist, row, nameColumn, name, false, false)
  guiGridListSetItemText(supportGridlist, row, messageColumn, text, false, false)
  if sourcePlayer == "Sandra" then
    r, g, b = 255, 30, 120
  elseif sourcePlayer == "James" or sourcePlayer == "Paul" then
    r, g, b = 255, 255, 22
  elseif getElementData(sourcePlayer, "admin") then
    r, g, b = 255, 22, 0
  elseif getElementData(sourcePlayer, "supporter") then
    r, g, b = 22, 255, 0
  else
    r, g, b = 255, 255, 255
  end
  guiGridListSetItemColor(supportGridlist, row, nameColumn, r, g, b)
end
addEvent("onSupportChatMessage", true)
addEventHandler("onSupportChatMessage", getRootElement(), outputSupportChat, true)
local antiSpamTimer = {}
function setAntiSpamActive()
  if not isTimer(antiSpamTimer) then
    antiSpamTimer = setTimer(killAntiSpamTimer, 1000, 1)
  else
    killTimer(antiSpamTimer)
    antiSpamTimer = setTimer(killAntiSpamTimer, 2500, 1)
  end
end
function isSpamTimer()
  if isTimer(antiSpamTimer) then
    outputChatBox("Please do not spam the support chat!", 255, 255, 0, true)
    return true
  else
    return false
  end
end
function killAntiSpamTimer()
  killTimer(antiSpamTimer)
end
function getRankingPlayer(place)
  return playerRankingTable[place].Player
end
function getElementDataPosition(key, value)
  if key and value then
    local result = 1
    for i, player in pairs(getElementsByType("player")) do
      local data = tonumber(getElementData(player, key))
      if data and value < data then
        result = result + 1
      end
    end
    return result
  end
end


function formatTimeFromMinutes(value)
  if value then
    local hours = math.floor(value / 60)
    local minutes = math.round((value / 60 - math.floor(value / 60)) * 100 / 1.6666666666666667)
    if minutes < 10 then
      minutes = "0" .. minutes
    end
    value = hours .. ":" .. minutes
    return value
  end
  return false
end
playerRankingTable = {}
function checkTopPlayer()
  playerRankingTable = positionGetElementData("alivetime", #getElementsByType("player"))
end
checkTopPlayer()
setTimer(checkTopPlayer, 10000, 0)
function onQuitGame(reason)
  checkTopPlayer()
end
addEventHandler("onClientPlayerQuit", getRootElement(), onQuitGame)
yA = 0
local screenWidth, screenHeight = guiGetScreenSize()
function scoreBoard()
  if getKeyState("tab") == false then
    return
  end
  if getElementData(getLocalPlayer(), "logedin") then
    local offset = dxGetFontHeight(1.55, "default-bold")
    dxDrawImage(screenWidth * 0.15, screenHeight * 0.2, screenWidth * 0.7, screenHeight * 0.2 + yA, "images/window_bg.png", 0, 0, 0, tocolor(255, 255, 255))
    dxDrawRectangle(screenWidth * 0.15, screenHeight * 0.2 + offset * 2, screenWidth * 0.7, screenHeight * 0.0025, tocolor(255, 255, 255, 220))
    dxDrawText("Name", screenWidth * 0.175, screenHeight * 0.2 + offset, screenWidth * 0.175, screenHeight * 0.2 + offset, tocolor(50, 255, 50, 200), 1.5, "default-bold")
    w1 = dxGetTextWidth("Name", 1.5, "default-bold")
    dxDrawText("Murders", screenWidth * 0.3 + w1 * 1.6, screenHeight * 0.2 + offset, screenWidth * 0.3 + w1 * 1.6, screenHeight * 0.2 + offset, tocolor(50, 255, 50, 200), 1.5, "default-bold")
    w2 = dxGetTextWidth("Murders", 1.5, "default-bold")
    dxDrawRectangle(screenWidth * 0.3 + w1 * 1.6 - w2 * 0.1 - screenWidth * 0.0025 / 2, screenHeight * 0.2, screenWidth * 0.0025, screenHeight * 0.2 + yA, tocolor(255, 255, 255, 220))
    dxDrawRectangle(screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 - screenWidth * 0.0025 / 2, screenHeight * 0.2, screenWidth * 0.0025, screenHeight * 0.2 + yA, tocolor(255, 255, 255, 220))
    dxDrawText("Zombies Killed", screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 - screenWidth * 0.0025 / 2 + w2 * 0.1, screenHeight * 0.2 + offset, screenWidth * 0.3 + w1 * 1.6, screenHeight * 0.2 + offset, tocolor(50, 255, 50, 200), 1.5, "default-bold")
    w3 = dxGetTextWidth("Zombies Killed", 1.5, "default-bold")
    dxDrawRectangle(screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 + w3 + w2 * 0.1 + screenWidth * 0.0025 / 2, screenHeight * 0.2, screenWidth * 0.0025, screenHeight * 0.2 + yA, tocolor(255, 255, 255, 220))
    dxDrawText("Alive Time", screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 + w3 + w2 * 0.1 + screenWidth * 0.0025 / 2 + w2 * 0.1, screenHeight * 0.2 + offset, screenWidth * 0.3 + w1 * 1.6, screenHeight * 0.2 + offset, tocolor(50, 255, 50, 200), 1.5, "default-bold")
    w4 = dxGetTextWidth("Alive Time", 1.5, "default-bold")
    dxDrawRectangle(screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 + w3 + w2 * 0.1 + screenWidth * 0.0025 / 2 + w2 * 0.1 + w4 + w2 * 0.1, screenHeight * 0.2, screenWidth * 0.0025, screenHeight * 0.2 + yA, tocolor(255, 255, 255, 220))
    dxDrawText("Players:" .. #getElementsByType("player"), screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 + w3 + w2 * 0.1 + screenWidth * 0.0025 / 2 + w2 * 0.1 + w4 + w2 * 0.1 + w4 / 3, screenHeight * 0.2 + offset, screenWidth * 0.8, screenHeight * 0.2 + offset, tocolor(50, 255, 50, 200), 1.5, "default-bold")
    playerInList = false
    local playerAmount = #getElementsByType("player")
    if playerAmount > 10 then
      playerAmount = 10
    end
    for i = 1, playerAmount do
      yA = i * offset
      local offset2 = dxGetFontHeight(1.5, "default-bold")
      local player = getRankingPlayer(i) or false
      if not player then
        break
      end
      r, g, b = 255, 255, 255
      if getPlayerName(player) == getPlayerName(getLocalPlayer()) then
        r, g, b = 50, 255, 50
        playerInList = true
      end
      dxDrawText(i, screenWidth * 0.155, screenHeight * 0.2 + offset * 2 + yA, screenWidth * 0.175, screenHeight * 0.2 + offset + yA, tocolor(r, g, b, 200), 1.5, "default-bold")
      dxDrawText(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", ""), screenWidth * 0.175, screenHeight * 0.2 + offset * 2 + yA, screenWidth * 0.175, screenHeight * 0.2 + offset + yA, tocolor(r, g, b, 200), 1.5, "default-bold")
      local murders = getElementData(player, "murders")
      dxDrawText(murders, screenWidth * 0.3 + w1 * 1.6, screenHeight * 0.2 + offset * 2 + yA, screenHeight * 0.2 + offset * 2 + yA, screenHeight * 0.2 + offset + yA, tocolor(r, g, b, 200), 1.5, "default-bold")
      local zombieskilled = getElementData(player, "zombieskilled")
      dxDrawText(zombieskilled, screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 - screenWidth * 0.0025 / 2 + w2 * 0.1, screenHeight * 0.2 + offset * 2 + yA, screenWidth * 0.175, screenHeight * 0.2 + offset + yA, tocolor(r, g, b, 200), 1.5, "default-bold")
      local alivetime = getElementData(player, "alivetime") or 0
      dxDrawText(formatTimeFromMinutes(alivetime), screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 + w3 + w2 * 0.1 + screenWidth * 0.0025 / 2 + w2 * 0.1, screenHeight * 0.2 + offset * 2 + yA, screenWidth * 0.175, screenHeight * 0.2 + offset + yA, tocolor(r, g, b, 200), 1.5, "default-bold")
    end
    playerLocalAdd = 0
    if not playerInList then
      playerLocalAdd = offset
      r, g, b = 50, 255, 50
      dxDrawRectangle(screenWidth * 0.15, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset - offset / 2, screenWidth * 0.7, screenHeight * 0.0025, tocolor(255, 255, 255, 220))
      local rank = getElementDataPosition("alivetime", getElementData(getLocalPlayer(), "alivetime"))
      dxDrawText(rank, screenWidth * 0.155, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset, screenWidth * 0.175, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset, tocolor(r, g, b, 200), 1.5, "default-bold")
      dxDrawText(string.gsub(getPlayerName(getLocalPlayer()), "#%x%x%x%x%x%x", ""), screenWidth * 0.175, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset, screenWidth * 0.175, screenHeight * 0.2 + offset + (playerAmount + 2) * offset, tocolor(r, g, b, 200), 1.5, "default-bold")
      local murders = getElementData(getLocalPlayer(), "murders")
      dxDrawText(murders, screenWidth * 0.3 + w1 * 1.6, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset, screenWidth * 0.175, screenHeight * 0.2 + offset + (playerAmount + 2) * offset, tocolor(r, g, b, 200), 1.5, "default-bold")
      local zombieskilled = getElementData(getLocalPlayer(), "zombieskilled")
      dxDrawText(zombieskilled, screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 - screenWidth * 0.0025 / 2 + w2 * 0.1, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset, screenWidth * 0.175, screenHeight * 0.2 + offset + (playerAmount + 2) * offset, tocolor(r, g, b, 200), 1.5, "default-bold")
      local alivetime = getElementData(getLocalPlayer(), "alivetime") or 0
      dxDrawText(formatTimeFromMinutes(alivetime), screenWidth * 0.3 + w1 * 1.6 + w2 * 1.1 + w3 + w2 * 0.1 + screenWidth * 0.0025 / 2 + w2 * 0.1, screenHeight * 0.2 + offset * 2 + (playerAmount + 2) * offset, screenWidth * 0.175, screenHeight * 0.2 + offset + (playerAmount + 2) * offset, tocolor(r, g, b, 200), 1.5, "default-bold")
    end
    yA = playerAmount * offset + playerLocalAdd
  end
end
addEventHandler("onClientRender", getRootElement(), scoreBoard)
function checkVehicleInWaterClient()
  vehiclesInWater = {}
  for i, veh in ipairs(getElementsByType("vehicle")) do
    if isElementInWater(veh) then
      table.insert(vehiclesInWater, veh)
    end
  end
  triggerServerEvent("respawnVehiclesInWater", getLocalPlayer(), vehiclesInWater)
end
addEvent("checkVehicleInWaterClient", true)
addEventHandler("checkVehicleInWaterClient", getRootElement(), checkVehicleInWaterClient)
function updatePlayTime()
  if getElementData(getLocalPlayer(), "logedin") then
    local playtime = getElementData(getLocalPlayer(), "alivetime")
    setElementData(getLocalPlayer(), "alivetime", playtime + 1)
  end
end
setTimer(updatePlayTime, 60000, 0)
bindKey("u", "down", "chatbox", "radiochat")
local pingFails = 0
function playerPingCheck()
  if getPlayerPing(getLocalPlayer()) > gameplayVariables.ping then
    pingFails = pingFails + 1
    if pingFails == 5 then
      triggerServerEvent("kickPlayerOnHighPing", getLocalPlayer())
      return
    end
    startRollMessage2("Ping", "Your ping is over " .. gameplayVariables.ping .. "! (" .. pingFails .. "/5)", 255, 22, 0)
    if isTimer(pingTimer) then
      return
    end
    pingTimer = setTimer(function()
      pingFails = 0
    end, 30000, 1)
  end
end
setTimer(playerPingCheck, 4000, 0)
