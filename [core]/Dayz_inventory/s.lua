function update()
  local qPrzedmioty=exports.db:q("select * from przedmioty")
  local qBronie=exports.db:q("select * from bronie")
  local qBronieAmunicja=exports.db:q("select * from bronie_amunicja")
  local qSkiny=exports.db:q("select * from skiny")
  local qJedzenie=exports.db:q("select * from jedzenie")
  przedmiotyKategorie = {}
  przedmioty = {}
  bronie = {}
  bronieAmunicja = {}
  skinyPrzedmiot = {}
  przedmiotSkiny = {}
  jedzenie = {}
  for i,v in ipairs(qPrzedmioty)do
    if(not przedmiotyKategorie[v.kategoria])then
      przedmiotyKategorie[v.kategoria]={}
    end
    if(v.subkategoria and not przedmiotyKategorie[v.kategoria][v.subkategoria])then
      przedmiotyKategorie[v.kategoria][v.subkategoria]={}
    end
    if(v.subkategoria)then
      table.insert(przedmiotyKategorie[v.kategoria][v.subkategoria],v.ID)
    else
      table.insert(przedmiotyKategorie[v.kategoria],v.ID)
    end
    przedmioty[v.ID] = v
  end
  for i,v in ipairs(qBronie)do
    bronie[v.bron_przedmiot] = {v.obrazenia,v.bron_gta,v.domyslna_amunicja}
  end
  for i,v in ipairs(qBronieAmunicja)do
    bronieAmunicja[v.ID_amunicji] = v.ID_broni
  end
  for i,v in ipairs(qSkiny)do
    przedmiotSkiny[v.przedmiot] = v.skin
    skinyPrzedmiot[v.skin] = v.przedmiot
  end
  for i,v in ipairs(qJedzenie)do
    jedzenie[v.ID] = {v.glod, v.pragnienie, v.hp}
  end
end
update()

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getItemWeight(element)
  local waga = 0
  for item,data in pairs(przedmioty)do
    local item = getElementData(element, item)
    if(item and item > 0)then
      waga = waga + data.waga * item
    end
  end
  return waga;
end

addEvent ( "onPlayerMoveItemInInventory", true )
addEventHandler ( "onPlayerMoveItemInInventory", resourceRoot,function(loot, itemID, quantity)
  if( not loot or not isElement(loot) or not itemID or math.floor(quantity)~=quantity or quantity < 1)then
    return
  end
  
  local cx,cy,cz = getElementPosition (client)
  local lx,ly,lz = getElementPosition (loot)
  if(getDistanceBetweenPoints3D(cx,cy,cz,lx,ly,lz) > 3)then
    return triggerClientEvent(client, "hideInventoryManual", client)
  end

  local currentItemsInLoot = loot:getData(itemID)
  if(currentItemsInLoot < quantity)then
    return exports.dayz_pickups:updateLootForPlayer(loot,client)
  end
  local weightOfNewItems = przedmioty[itemID].waga * quantity
  local slotsLimit = client:getData("sloty")
  if(math.round(getItemWeight(client),2) + math.round(weightOfNewItems,2) <= slotsLimit)then
    local doNotRefreshItems = true
    if(currentItemsInLoot - quantity == 0)then
      loot:removeData(itemID)
      doNotRefreshItems = false
    else
        setElementData(loot,itemID,currentItemsInLoot - quantity,false)
    end
    setElementData(client,itemID,(getElementData(client,itemID) or 0) + quantity)
    return exports.dayz_pickups:refreshItemLoot(loot,false,doNotRefreshItems)
  else
    outputChatBox("brak miejsca")
  end
end)

addEvent ( "onPlayerMoveItemOutInventory", true )
addEventHandler ( "onPlayerMoveItemOutInventory", resourceRoot,function(loot, itemID, quantity)
  local cx,cy,cz = getElementPosition (client)
  if(loot and isElement(loot) and getElementData(loot,"sloty"))then
    if(not itemID or math.floor(quantity)~=quantity or quantity < 1)then
      return
    end
    local lx,ly,lz = getElementPosition (loot)
    if(getDistanceBetweenPoints3D(cx,cy,cz,lx,ly,lz) > 3)then
      return triggerClientEvent(client, "hideInventoryManual", client)
    end

    local currentItemsInLoot = loot:getData(itemID) or 0
    local currentItemsInInventory = client:getData(itemID) or 0
    local weightOfNewItems = przedmioty[itemID].waga * quantity
    local slotsLimit = loot:getData("sloty")
    if(math.round(getItemWeight(loot),2) + math.round(weightOfNewItems,2) <= slotsLimit)then
      local doNotRefreshItems = true
      if(currentItemsInInventory - quantity == 0)then
        client:removeData(itemID)
        doNotRefreshItems = false
      else
        setElementData(loot,itemID,currentItemsInLoot + quantity,false)
      end
      setElementData(client,itemID,(getElementData(client,itemID) or 0) - quantity)
      return exports.dayz_pickups:refreshItemLoot(loot,false,doNotRefreshItems)
    else
      outputChatBox("brak miejsca")
    end
  else
    setElementData(client,itemID,(getElementData(client,itemID) or 0) - quantity)
    exports.dayz_pickups:createItemPickup(itemID, quantity, cx,cy,cz)
  end
end)