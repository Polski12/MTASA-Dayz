function createBloodForkrwawieniePlayers()
  if getElementData(localPlayer, "logedin") then
    local x, y, z = getElementPosition(localPlayer)
    for i, player in ipairs(getElementsByType("player")) do
      local krwawienie = getElementData(player, "krwawienie") or 0
      if krwawienie > 0 then
        local px, py, pz = getPedBonePosition(player, 3)
        local pdistance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if krwawienie > 600 then
          number = 5
        elseif krwawienie > 300 then
          number = 3
        elseif krwawienie > 100 then
          number = 1
        else
          number = 0
        end
        if pdistance <= 120 then
          fxAddBlood(px, py, pz, 0, 0, 0, number, 1)
        end
      end
    end
  end
end
setTimer(createBloodForkrwawieniePlayers, 300, 0)
function checkBrokenbone()
  if getElementData(localPlayer, "zyje") then
    if getElementData(localPlayer, "zlamana_noga") then
      if not isPedDucked(localPlayer) then
      end
      toggleControl("jump", false)
      toggleControl("sprint", false)
    else
      toggleControl("jump", true)
      toggleControl("sprint", true)
    end
  end
end
setTimer(checkBrokenbone, 1400, 0)
function setPain()
  if getElementData(localPlayer, "zyje") and getElementData(localPlayer, "bolglowy") then
    local x, y, z = getElementPosition(localPlayer)
    createExplosion(x, y, z + 15, 8, false, 1, false)
    local x, y, z, lx, ly, lz = getCameraMatrix()
    x, lx = x + 1, lx + 1
    setCameraMatrix(x, y, z, lx, ly, lz)
    setCameraTarget(localPlayer)
  end
end
setTimer(setPain, 1500, 0)

function setCold()
  if getElementData(localPlayer, "zyje") and getElementData(localPlayer, "temperatura") <= 31 then
    local x, y, z = getElementPosition(localPlayer)
    createExplosion(x, y, z + 15, 8, false, 0.5, false)
    local x, y, z, lx, ly, lz = getCameraMatrix()
  end
end
setTimer(setCold, 1500, 0)

function updateVolumeAndVisibility()
  local value;
  local state = getPedMoveState(localPlayer)
  if jumping or isPedInVehicle(localPlayer) or getElementData(localPlayer, "shooting") and getElementData(localPlayer, "shooting") > 0 then
    value = 80
  else
    if state == "stand" then
      value = 0
    elseif state == "walk" then
      value = 20
    elseif state == "powerwalk" then
      value = 40
    elseif state == "jog" then
      value = 60
    elseif state == "sprint" or state == "fall" then
      value = 80
    elseif state == "crouch" then
      value = 0
    else
      value = 20
    end
  end
  setElementData(localPlayer, "halas", value, false)
    
  if jumping then
    value = 80
  else
    if state == "stand" then
      value = 40
    elseif state == "walk" then
      value = 60
    elseif state == "powerwalk" then
      value = 60
    elseif state == "jog" then
      value = 60
    elseif state == "sprint" then
      value = 80
    elseif state == "crouch" then
      value = 20
    else
      value = 20
    end
  end
  if isPedInVehicle(localPlayer) then
    value = 0
  end
  setElementData(localPlayer, "widzialnosc", value)
end
setTimer(updateVolumeAndVisibility, 100, 0)

function debugJump()
  if getControlState("jump") then
    jumping = true
    setTimer(debugJump2, 650, 1)
  end
end
setTimer(debugJump, 100, 0)

function debugJump2()
  jumping = false
end

weaponNoiseTable = {
  {22, 20},
  {23, 0},
  {24, 60},
  {28, 40},
  {32, 40},
  {29, 40},
  {30, 60},
  {31, 60},
  {25, 40},
  {26, 60},
  {27, 60},
  {33, 40},
  {34, 60},
  {36, 60},
  {35, 60}
}
function getWeaponNoise(weapon)
  for i, weapon2 in ipairs(weaponNoiseTable) do
    if weapon == weapon2[1] then
      return weapon2[2]
    end
  end
  return 0
end
function debugShooting()
  if getControlState("fire") then
    local weapon = getPedWeapon(localPlayer)
    local noise = getWeaponNoise(weapon) or 0
    setElementData(localPlayer, "shooting", noise, false)
    if shootTimer then
      killTimer(shootTimer)
    end
    shootTimer = setTimer(debugShooting2, 100, 1)
  end
end
setTimer(debugShooting, 100, 0)
function debugShooting2()
  setElementData(localPlayer, "shooting", 0, false)
  shootTimer = false
end
function checkZombies()
  zombiesalive = 0
  zombiestotal = 0
  for i, ped in ipairs(getElementsByType("ped")) do
    if getElementData(ped, "zombie") then
      zombiesalive = zombiesalive + 1
    end
    if getElementData(ped, "deadzombie") then
      zombiestotal = zombiestotal + 1
    end
  end
  setElementData(getRootElement(), "zombiesalive", zombiesalive, false)
  setElementData(getRootElement(), "zombiestotal", zombiestotal + zombiesalive, false)
end
setTimer(checkZombies, 5000, 0)
function checkZombies3()
  local x, y, z = getElementPosition(localPlayer)
  for i, ped in ipairs(getElementsByType("ped",getRootElement(),true)) do
    if getElementData(ped, "zombie") then
      local sound = getElementData(localPlayer, "halas") / 5
      local visibly = getElementData(localPlayer, "widzialnosc") / 5
      local xZ, yZ, zZ = getElementPosition(ped)
      if getDistanceBetweenPoints3D(x, y, z, xZ, yZ, zZ) < sound + visibly + 7 then
        if getElementData(ped, "leader") == nil then
          triggerServerEvent("botAttack", localPlayer, ped)
        end
      else
        if getElementData(ped, "target") == localPlayer then
          setElementData(ped, "target", nil)
        end
        if getElementData(ped, "leader") == localPlayer then
          triggerServerEvent("botStopFollow", localPlayer, ped)
        end
      end
    end
  end
end
setTimer(checkZombies3, 500, 0)

function playerZoom(key, keyState)
  if key == "n" then
    if getElementData(localPlayer, "Night Vision Goggles") > 0 then
      if nightvision then
        nightvision = false
        setCameraGoggleEffect("normal")
        do
          local hour, minutes = getTime()
          if gameplayVariables.enablenight then
            setClientNight(hour, minutes)
          end
        end
      else
        nightvision = true
        setCameraGoggleEffect("nightvision")
        setFarClipDistance(1000)
      end
    end
  elseif key == "i" and 0 < getElementData(localPlayer, "Infrared Goggles") then
    if infaredvision then
      infaredvision = false
      setCameraGoggleEffect("normal")
      if gameplayVariables.enablenight then
        setClientNight(hour, minutes)
      end
    else
      infaredvision = true
      setCameraGoggleEffect("thermalvision")
      if gameplayVariables.enablenight then
        setClientNight(hour, minutes)
      end
    end
  end
end
bindKey("n", "down", playerZoom)
bindKey("i", "up", playerZoom)

function makeRadioStayOff()
  --setRadioChannel(0)
  --cancelEvent()
end
addEventHandler("onClientPlayerVehicleEnter", getRootElement(), makeRadioStayOff)
addEventHandler("onClientPlayerRadioSwitch", getRootElement(), makeRadioStayOff)

setTimer(function()
  if(localPlayer:getData("zyje"))then
    if(math.random(1,2) == 1)then
      local glod = localPlayer:getData("glod")
      if(glod > 0)then
        localPlayer:setData("glod",glod-1)
      end
    end
    local pragnienie = localPlayer:getData("pragnienie")
    if(pragnienie > 0)then
      localPlayer:setData("pragnienie",pragnienie-1)
    end
  end
end,1000*30,0)

setTimer(function()
  if(localPlayer:getData("zyje"))then
    local zabierzHp = 0
    local glod = localPlayer:getData("glod")
    local pragnienie = localPlayer:getData("pragnienie")
    local krwawienie = localPlayer:getData("krwawienie")
    if(glod <= 0)then
      zabierzHp = zabierzHp + math.random(30,70)
    end
    if(pragnienie <= 0)then
      zabierzHp = zabierzHp + math.random(50,80)
    end
    zabierzHp = zabierzHp + krwawienie
    local krew = localPlayer:getData("krew")
    if(krew - zabierzHp > 0)then
      localPlayer:setData("krew", krew - zabierzHp)
    else
      triggerServerEvent("kill", localPlayer, localPlayer)
    end
  end
end,1000*10,0)

function playerGetDamageDayZ(attacker, weapon, bodypart, loss)
  cancelEvent()
  if(localPlayer:getData("zgon"))then return false end
  damage = 100
  headshot = false
  if weapon == 37 then
    return
  end
  if(attacker)then
    if(getElementType(attacker) == "player")then
      if weapon == 49 then
        if loss > 30 then
          setElementData(localPlayer, "brokenbone", true)
          setControlState("jump", true)
          setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") - math.floor(loss * 10))
        end
        setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") - math.floor(loss * 5))
      elseif weapon == 63 or weapon == 51 or weapon == 19 then
        setElementData(localPlayer, "blood", 0)
        if getElementData(localPlayer, "blood") <= 0 and not getElementData(localPlayer, "isDead") == true then
          triggerServerEvent("kilLDayZPlayer", localPlayer, attacker, headshot)
        end
      elseif weapon and weapon > 1 and attacker and getElementType(attacker) == "player" then
        local number = math.random(1, 8)
        if number >= 6 or number <= 8 then
          setElementData(localPlayer, "bleeding", getElementData(localPlayer, "bleeding") + math.floor(loss * 10))
        end
        local number = math.random(1, 7)
        if number == 2 then
          setElementData(localPlayer, "pain", true)
        end
        damage = getWeaponDamage(weapon)
        if bodypart == 9 then
          damage = damage * 1.5
          headshot = true
        end
        if bodypart == 7 or bodypart == 8 then
          setElementData(localPlayer, "brokenbone", true)
        end
        playRandomHitSound()
        setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") - math.random(damage * 0.75, damage * 1.25))
        if not getElementData(localPlayer, "bandit") then
          setElementData(attacker, "humanity", getElementData(attacker, "humanity") - math.random(40, 200))
          if 0 > getElementData(attacker, "humanity") then
            setElementData(attacker, "bandit", true)
          end
        else
          setElementData(attacker, "humanity", getElementData(attacker, "humanity") + math.random(40, 200))
          if getElementData(attacker, "humanity") > 5000 then
            setElementData(attacker, "humanity", 5000)
          end
          if getElementData(attacker, "humanity") > 2000 then
            setElementData(attacker, "bandit", false)
          end
        end
        if getElementData(localPlayer, "blood") <= 0 and not getElementData(localPlayer, "isDead") then
          triggerServerEvent("kilLDayZPlayer", localPlayer, attacker, headshot, getWeaponNameFromID(weapon))
          setElementData(localPlayer, "isDead", true)
        end
      end
    elseif(getElementType(attacker) == "ped")then
      if getElementData(attacker, "zombie") then
        setElementData(localPlayer, "blood", getElementData(localPlayer, "blood") - gameplayVariables.zombiedamage)
        local number = math.random(1, 7)
        if number == 4 then
          setElementData(localPlayer, "bleeding", getElementData(localPlayer, "bleeding") + math.floor(loss * 10))
        end
      end
    end
  elseif(weapon == 54 or weapon == 63 or weapon == 49 or weapon == 51)then
    damage = loss * loss * 1.5
    if(loss == 100)then
      damage = 696969
    end
    if(damage > 1000 and math.random(1,2) == 1)then
      localPlayer:setData("zlamana_noga",true)
    end
    local number = math.random(1, 11)
    if number == 3 then
      localPlayer:setData("bolglowy", true)
    end
    local krew = localPlayer:getData("krew")
    if(krew - damage > 0)then
      localPlayer:setData("krew",math.floor(krew - damage))
    else
      triggerServerEvent("kill", localPlayer, localPlayer, false,false,false)
    end
  end
end
addEventHandler("onClientPlayerDamage", localPlayer, playerGetDamageDayZ)