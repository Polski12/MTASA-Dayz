lootRoot = createElement("loot")
local items = {};
local weaponAmmoTable = {};
local ammoWeaponTable = {};
local spawns = {};
local spawnsItems = {};
local itemsByID = {};
local itemsInLootAll = {};
function update()
  items = {};
  weaponAmmoTable = {};
  ammoWeaponTable = {};
  spawns = {};
  spawnsItems = {};
  itemsByID = {};
  local q=exports.db:q("select * from przedmioty")
  for i,v in ipairs(q)do
    table.insert(items,{v.ID, v.model, v.skala, v.obroty, v.waga})
    itemsByID[v.ID] = {v.model, v.skala, v.obroty, v.waga, v.nazwa,v.subkategoria}
    table.insert(itemsInLootAll,v.ID)
  end
  local q=exports.db:q("select * from bronie")
  for i,v in ipairs(q)do
    weaponAmmoTable[v.bron_przedmiot] = v.domyslna_amunicja
    ammoWeaponTable[v.domyslna_amunicja] = v.bron_przedmiot
  end
  local q=exports.db:q("select * from looty")
  for i,v in ipairs(q)do
    if(not spawns[v.typ])then
      spawns[v.typ] = {}
    end
    table.insert(spawns[v.typ],split(v.pozycja,","))
  end
  
  q=exports.db:q("select * from looty_typy_przedmioty")
  for i,v in ipairs(q)do
    if(not spawnsItems[v.typ])then
      spawnsItems[v.typ] = {}
    end
    table.insert(spawnsItems[v.typ],{v.przedmiot,v.szansa})
  end
end
update()

function createItemPickup(item, quantity, x, y, z)
  if item and x and y and z and itemsByID[item] then
    local object = createObject(itemsByID[item][1], x + math.random(-5, 5) / 12, y + math.random(-5, 5) / 12, z - 0.875, itemsByID[item][3], 0, math.random(0, 360), true)
    setObjectScale(object, itemsByID[item][2])
    local col = createColSphere(x, y, z, 0.75)
    setElementData(col, "interakcja", "pickup")
    setElementData(col, "opis", quantity.."x "..itemsByID[item][5])
    setElementData(col, "item", item,false)
    setElementData(col, "quantity", quantity,false)
    setElementData(col, "parent", object, false)
    local timer = setTimer(function(c,o)
      if c and o and isElement(c) and isElement(o) then
        destroyElement(c)
        destroyElement(o)
      end
    end, 1000 * 60 * 15, 1,col,object)
    setElementData(col, "timer", timer, false)
    return object
  end
end

function table.size(tab)
  local length = 0
  for _ in pairs(tab) do
    length = length + 1
  end
  return length
end

function math.percentChance(percent, repeatTime)
  local hits = 0
  for i = 1, repeatTime do
    local number = math.random(0, 200) / 2
    if percent >= number then
      hits = hits + 1
    end
  end
  return hits
end

function createItemLoot(lootType, x, y, z, i, d)
  if(spawnsItems[lootType])then
    local col = createColSphere(x, y, z, 1.25)
    col:setParent(lootRoot)
    setElementData(col, "interakcja", "loot")
    setElementData(col, "opis", lootType)
    setElementData(col, "sloty", 12, false)
    local tempItems = {}
    local weight = 0
    local thisLootItems = spawnsItems[lootType]
    local s = #thisLootItems
    for i=1,s do
      if(weight>=12)then break end
      local item = thisLootItems[i]
      local value = math.percentChance(item[2], math.random(1, 2))
      if(value > 0)then
        local itemData = itemsByID[item[1]]
        if(itemData[6] == "Amunicja")then
          value = value * (1/itemData[4])
        end
        setElementData(col, item[1], value, false)
        local ammoData = weaponAmmoTable[item[1]]
        if ammoData and value > 0 then
          local amountOfAmmo = math.random(1, 2)
          setElementData(col, ammoData, amountOfAmmo * (1/itemsByID[ammoData][4]), false)
          weight = weight + amountOfAmmo
        end
        weight = weight + itemData[4]
        table.insert(tempItems, item[1])
      end
    end
    if weight > 0 then
      refreshItemLoot(col, tempItems)
    end
    return col
  else
    return false
  end
end

function refreshItemLoot(col, itemsInLoot,doNotRefreshItems)
  if(not doNotRefreshItems)then
    local objects = getElementData(col, "Objects_In_Loot")
    if objects then
      if objects[1] and isElement(objects[1]) then
        destroyElement(objects[1])
      end
      if objects[2] and isElement(objects[2]) then
        destroyElement(objects[2])
      end
      if objects[3] and isElement(objects[3]) then
        destroyElement(objects[3])
      end
    end
    local counter = 0
    local objectItem = {}
    if(not itemsInLoot)then
      itemsInLoot = itemsInLootAll
    end
    for i, item in ipairs(itemsInLoot) do
      local it = getElementData(col, item);
      if it and it > 0 then
        if counter == 3 then
          break
        end
        local data = itemsByID[item]
        counter = counter + 1
        local x, y, z = getElementPosition(col)
        objectItem[counter] = createObject(data[1], x + math.random(-5, 5) / 10, y + math.random(-5, 5) / 10, z - 0.875, data[3], 0, 0, true)
        setObjectScale(objectItem[counter], data[2])
      end
    end
    setElementData(col, "Objects_In_Loot", objectItem,false)
  end
  if not itemsInLoot then
    local players = getElementsWithinColShape(col, "player")
    for theKey, player in ipairs(players) do
      updateLootForPlayer(col, player)
    end
  end
end

function createPickupsOnServerStart()
  for i,v in pairs(spawns)do
    local s = #v
    
    for i2,v2 in ipairs(v)do
      createItemLoot(i, v2[1],v2[2],v2[3],v2[4],v2[5])
    end
  end
end

function onPlayerTakeItemFromGround(item, col)
  itemPlus = 1
  if(ammoWeaponTable[item])then
    itemPlus = 1/itemsByID[item][4]
  end
  local x, y, z = getElementPosition(client)
  setElementData(client, item, (getElementData(client, item) or 0) + itemPlus)
  destroyElement(getElementData(col, "parent"))
  destroyElement(col)
end
addEvent("onPlayerTakeItemFromGround", true)
addEventHandler("onPlayerTakeItemFromGround", getRootElement(), onPlayerTakeItemFromGround)

function playerDropAItem(itemName)
  local x, y, z = getElementPosition(client)
  createItemPickup(item, x, y, z)
end
addEvent("playerDropAItem", true)
addEventHandler("playerDropAItem", getRootElement(), playerDropAItem)

function refreshItemLoots()
  destroyElement(lootRoot)
  lootRoot = createElement("loot")
  createPickupsOnServerStart()
  --setTimer(refreshItemLootPoints, gameplayVariables.itemrespawntimer, 1)
end

function updateLootForPlayer(loot,player)
  triggerClientEvent(player, "getLootData", player, loot, getAllElementData(loot))
  triggerClientEvent(player, "refreshInventoryManual", player)
  triggerClientEvent(player, "refreshLootManual", player)
end

addEventHandler ( "onColShapeHit", getRootElement(), function(element)
  if(getElementType(element) == "player")then
    if(source:getData("sloty"))then
      updateLootForPlayer(source,element)
    end
  end
end)

start = getTickCount()
refreshItemLoots()
stop = getTickCount()
outputChatBox(stop - start)
