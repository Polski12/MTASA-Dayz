local spawnPositions = {};
local items = {};
local itemsList = {}
local defaultData = {};
local weaponAmmoTable = {};
local ammoWeaponTable = {};
local weapons = {};
local startItems = {};
local saveSkip = {
  ["czas_gry"]=true,
  ["skin"]=true,
  ["pozycja"]=true,
  ["zyje"]=true,
}

function update()
  spawnPositions = {}
  local q = exports.db:q("select * from spawny")
  for i,v in ipairs(q)do
    table.insert(spawnPositions,{v.x,v.y,v.z})
  end
  q=exports.db:q("select ID from przedmioty")
  for i,v in ipairs(q)do
    items[v.ID] = true
    table.insert(itemsList,v.ID)
  end
  defaultData = exports.db:q("select * from dane_gracz")
  local q=exports.db:q("select * from bronie_amunicja")
  for i,v in ipairs(q)do
    weaponAmmoTable[v.ID_broni] = v.ID_amunicji
    ammoWeaponTable[v.ID_amunicji] = v.ID_broni
  end
  q = exports.db:q("select * from bronie")
  for i,v in ipairs(q)do
    weapons[v.bron_przedmiot] = v.bron_gta
  end
  q = exports.db:q("select * from startowe_przedmioty")
  for i,v in ipairs(q)do
    startItems[v.przedmiot] = v.ilosc
  end
end
update()

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function cleanPlayer(player)
  local playerCol = player:getData("playerCol")
  if(playerCol and isElement(playerCol))then
    playerCol:destroy()
    player:removeData("playerCol")
  end
end

function spawnDayZPlayer(player,loadData)
  local playerID = player:getData("uid")
  if(not playerID)then
    return false
  end
  createZombieTable(player)
  fadeCamera(player, true)
  setCameraTarget(player, player)
  playerCol = createColSphere(0,0,0, 1.5)
  setElementData(player, "playerCol", playerCol)
  attachElements(playerCol, player, 0, 0, 0)
  setElementData(playerCol, "parent", player)
  setElementData(playerCol, "interaction", "player")
  setElementData(playerCol, "interaction", player.name)
  setElementData(player, "isDead", false)
  setElementData(player, "logedin", true)
  skin = 73
  local playerItems = {};
  for i,v in pairs(defaultData)do
    if(v.typ=="number")then
      setElementData(player,v.klucz,tonumber(v.wartosc))
    elseif(v.typ=="boolean")then
      setElementData(player,v.klucz,v.wartosc == "true")
    else
      setElementData(player,v.klucz,v)
    end
  end
  if(loadData)then
    playerItems = {}
    local q = exports.db:q("select przedmioty from konta where ID = ? limit 1",playerID)
    if(#q > 0)then
      local group = fromJSON(q[1]["przedmioty"])
      if(group)then
      for i,v in pairs(group)do
        player:setData(i,v)
      end
      end
    end
    local playerData = exports.db:q("select klucz,wartosc,typ from konta_dane where konto = ?",playerID)
    for i,v in ipairs(playerData)do
      if(v.typ == "number")then
        v.wartosc = tonumber(v.wartosc)
      elseif(v.typ == "boolean")then
        v.wartosc = v.wartosc == "true"
      end
      setElementData(player,v.klucz,v.wartosc)
      if(v.klucz == "skin")then
        skin = tonumber(v.wartosc)
      elseif(v.klucz == "pozycja")then
        x,y,z,i,d = unpack(fromJSON(v.wartosc))
      elseif(v.klucz == "aktualnabron_1" or v.klucz == "aktualnabron_2" or v.klucz == "aktualnabron_3")then
        if v.wartosc and v.wartosc~= 0 and type(v.wartosc)=="number" then
          local ammo = weaponAmmoTable[v.wartosc]
          giveWeapon(player, weapID, getElementData(player, ammo), true)
        end
      end
    end
  end
  if(not x or tonumber(x)==0 and tonumber(y)==0 and tonumber(z)==0)then
    local number = math.random(#spawnPositions)
    x, y, z = spawnPositions[number][1], spawnPositions[number][2], spawnPositions[number][3]
    i, d = 0, 0
  end
  spawnPlayer(player, x, y, z, math.random(0, 360), skin, i, d)
  --triggerClientEvent(player, "onClientPlayerDayZLogin", player)
end

function notifyAboutExplosion2()
  for i, player in pairs(getVehicleOccupants(source)) do
    triggerEvent("kilLDayZPlayer", player)
  end
end
addEventHandler("onVehicleExplode", getRootElement(), notifyAboutExplosion2)

function destroyDeadPlayer(ped, pedCol)
  destroyElement(ped)
  destroyElement(pedCol)
end

function createDeadBody(player)
  local x, y, z = getElementPosition(player)
  local rotX, rotY, rotZ = getElementRotation(player)
  local skin = getElementModel(player)
  local ped = createPed(skin, x, y, z, rotZ)
  pedCol = createColSphere(x, y, z, 1.5)
  killPed(ped)
  setTimer(destroyDeadPlayer, 2700000, 1, ped, pedCol)
  attachElements(pedCol, ped, 0, 0, 0)
  setElementData(pedCol, "parent", ped)
  setElementData(pedCol, "interakcja", "zwloki")
  setElementData(pedCol, "sloty", getElementData(player, "sloty"))
  local time = getRealTime()
  local hours = time.hour
  local minutes = time.minute
  setElementData(pedCol, "opis", getPlayerName(player) .. ". Data zgonu: " .. hours .. ":" .. minutes .. ".")
  for i,v in pairs(items)do
    pedCol:setData(i,player:getData(i))
    player:removeData(i)
  end
end

addEvent ( "kill", true ) -- source == attacker
addEventHandler ( "kill", getRootElement(),function(killer, headshot, weapon, otherSourceOfDeath)
  if(source:getData("zyje"))then
    source:setData("zyje",false)
    killPed(source)
    triggerClientEvent(source, "hideInventoryManual", source)
    cleanPlayer(source)
    createDeadBody(source)
    if killer then
    end
    setTimer(spawnDayZPlayer, 5000, 1, source)
    setTimer(savePlayer, 7000, 1, source)
  end
end)

function setDayzAccountData(playerId,key,value)
  if(value == nil)then
    return exports.db:e("delete from konta_dane where konto=? and klucz=? limit 1",playerId,key)
  end
  local typ = type(value)
  if(typ=="table")then
    value=toJSON(value,true)
  end
  local q=exports.db:q("select klucz,wartosc,typ from konta_dane where konto=? and klucz=? limit 1",playerId,key)
  if(#q == 0)then
    return exports.db:e("insert into konta_dane values(null,?,?,?,?)",playerId,key,tostring(value),typ)
  else
    return exports.db:e("update konta_dane set wartosc = ? where konto=? and klucz=? limit 1",tostring(value),playerId,key)
  end
end

function savePlayer(player)
  local id = player:getData("uid")
  if(not id)then return false end
  for i,v in ipairs(defaultData)do
    if(not saveSkip[v.klucz])then
      setDayzAccountData(id,v.klucz,player:getData(v.klucz))
    end
  end
  local x,y,z = getElementPosition(player)
  local i,d = player.interior, player.interior
  setDayzAccountData(id,"pozycja",{math.round(x,2),math.round(y,2),math.round(z,2),i,d})
  setDayzAccountData(id,"skin",player.model)
  setDayzAccountData(id,"czas_gry",(player:getData("czas_gry") or 0) + getTickCount() - player:getData("joinTime"))
  local playerItems = {}
  for i=1,#itemsList do
    local quantity = player:getData(itemsList[i])
    if(quantity and quantity > 0)then
      playerItems[itemsList[i]] = quantity
    end
  end
  exports.db:e("update konta set przedmioty = ? where ID = ? limit 1",toJSON(playerItems,true),id)
end

addEventHandler("onPlayerQuit", getRootElement(), function()
  savePlayer(source)
end)

function createZombieTable(player)
  setElementData(player, "playerZombies", {
    "no",
    "no",
    "no",
    "no",
    "no",
    "no",
    "no",
    "no",
    "no"
  })
  setElementData(player, "spawnedzombies", 0)
end

--spawnDayZPlayer(getRandomPlayer())