przedmioty = {}
local headline = {}
local gridlistItems = {}
local buttonItems = {}
inventoryWindows = guiCreateWindow(0.15, 0.28, 0.72, 0.63, "", true)
headline.loot = guiCreateLabel(0.06, 0.05, 0.34, 0.09, "Loot", true, inventoryWindows)
guiLabelSetHorizontalAlign(headline.loot, "center")
guiSetFont(headline.loot, "default-bold-small")
headline.inventory = guiCreateLabel(0.6, 0.05, 0.34, 0.09, "Ekwipunek", true, inventoryWindows)
guiLabelSetHorizontalAlign(headline.inventory, "center")
guiSetFont(headline.inventory, "default-bold-small")
gridlistItems.loot = guiCreateGridList(0.03, 0.1, 0.39, 0.83, true, inventoryWindows)
gridlistItems.loot_colum = guiGridListAddColumn(gridlistItems.loot, "Loot", 0.7)
gridlistItems.loot_colum_amount = guiGridListAddColumn(gridlistItems.loot, "", 0.2)
gridlistItems.inventory = guiCreateGridList(0.57, 0.11, 0.39, 0.83, true, inventoryWindows)
gridlistItems.inventory_colum = guiGridListAddColumn(gridlistItems.inventory, "Inventory", 0.7)
gridlistItems.inventory_colum_amount = guiGridListAddColumn(gridlistItems.inventory, "", 0.2)
buttonItems.loot = guiCreateButton(0.42, 0.17, 0.04, 0.69, "->", true, inventoryWindows)
buttonItems.inventory = guiCreateButton(0.53, 0.17, 0.04, 0.69, "<-", true, inventoryWindows)
headline.slots = guiCreateLabel(0.62, 0.94, 0.29, 0.04, "Sloty:", true, inventoryWindows)
guiLabelSetHorizontalAlign(headline.slots, "center")
guiLabelSetVerticalAlign(headline.slots, "center")
guiSetFont(headline.slots, "default-bold-small")
headline.slots_loot = guiCreateLabel(0.07, 0.94, 0.29, 0.04, "Sloty:", true, inventoryWindows)
guiLabelSetHorizontalAlign(headline.slots_loot, "center")
guiLabelSetVerticalAlign(headline.slots_loot, "center")
guiSetFont(headline.slots_loot, "default-bold-small")
guiSetVisible(inventoryWindows, false)

-- right click menu
rightclickWindow = guiCreateStaticImage(0, 0, 0.05, 0.0215, "bg.png", true)
headline.rightclickmenu = guiCreateLabel(0, 0, 1, 1, "", true, rightclickWindow)
guiLabelSetHorizontalAlign(headline.rightclickmenu, "center")
guiLabelSetVerticalAlign(headline.rightclickmenu, "center")
guiSetFont(headline.rightclickmenu, "default-bold-small")
guiSetVisible(rightclickWindow, false)

function updateData()
    przedmioty = getElementData(root,"przedmioty")
    przedmiotyKategorie = getElementData(root,"przedmiotyKategorie")
end
updateData()

function showInventory(key, keyState)
  if getElementData(localPlayer, "logedin") and keyState == "down" then
    updateData()
    guiSetVisible(inventoryWindows, not guiGetVisible(inventoryWindows))
    showCursor(not isCursorShowing())
    refreshInventory()
    if guiGetVisible(inventoryWindows) == true then
      onClientOpenInventoryStopMenu()
    else
      hideRightClickInventoryMenu()
    end
    currentLoot= getCurrentLoot()
    if currentLoot and currentLoot:getData("sloty") then
      local gearName = getElementData(currentLoot, "opis")
      refreshLoot(currentLoot, gearName)
    end
  end
end
bindKey("j", "down", showInventory)

function showInventoryManual()
  guiSetVisible(inventoryWindows, not guiGetVisible(inventoryWindows))
  showCursor(not isCursorShowing())
  refreshInventory()
  if guiGetVisible(inventoryWindows) == true then
    onClientOpenInventoryStopMenu()
  end
end

addEvent("hideInventoryManual", true)
addEventHandler("hideInventoryManual", localPlayer, function()
  guiSetVisible(inventoryWindows, false)
  showCursor(false)
  hideRightClickInventoryMenu()
end)

function refreshInventory()
  if gridlistItems.inventory_colum then
    local waga = 0
    row1, column1 = guiGridListGetSelectedItem(gridlistItems.inventory)
    guiGridListClear(gridlistItems.inventory)
    for i,v in pairs(przedmiotyKategorie)do
      local row = guiGridListAddRow(gridlistItems.inventory)
      guiGridListSetItemText(gridlistItems.inventory, row, 1, i, true, false)
      for i2,v2 in pairs(v)do
        local row2 = guiGridListAddRow(gridlistItems.inventory)
        guiGridListSetItemText(gridlistItems.inventory, row2, 1, "->"..i2, true, false)
        for i3,v3 in ipairs(v2)do
          local item = getElementData(localPlayer, v3)
          if(item and item > 0)then
            local row3 = guiGridListAddRow(gridlistItems.inventory)
            guiGridListSetItemText(gridlistItems.inventory, row3, 1, " "..przedmioty[v3].nazwa,false,true)
            guiGridListSetItemData(gridlistItems.inventory, row3, 1, v3)
            guiGridListSetItemText(gridlistItems.inventory, row3, 2,item,false,true)
            waga = waga + przedmioty[v3].waga * item
          end
        end
      end
    end
    if row1 and column1 then
      guiGridListSetSelectedItem(gridlistItems.inventory, row1, column1)
    end
    guiSetText(headline.slots, "Sloty: " ..waga.. "/" .. getElementData(localPlayer,"sloty"))
  end
end

function clearLootGridList()
    guiGridListClear(gridlistItems.loot)
end

function refreshLoot(loot, gearName)
  if gridlistItems.loot_colum then
    if(not loot)then
      loot = getCurrentLoot()
    end
    if(not loot)then return false end
    local sloty = getElementData(loot,"sloty")
    if(sloty)then
      local waga = 0
      row1, column1 = guiGridListGetSelectedItem(gridlistItems.loot)
      guiGridListClear(gridlistItems.loot)
      for i,v in pairs(przedmiotyKategorie)do
        local row = guiGridListAddRow(gridlistItems.loot)
        guiGridListSetItemText(gridlistItems.loot, row, 1, i, true, false)
        for i2,v2 in pairs(v)do
          local row2 = guiGridListAddRow(gridlistItems.loot)
          guiGridListSetItemText(gridlistItems.loot, row2, 1, "->"..i2, true, false)
          for i3,v3 in ipairs(v2)do
            local item = getElementData(loot, v3)
            if(item and item > 0)then
              local row3 = guiGridListAddRow(gridlistItems.loot)
              guiGridListSetItemText(gridlistItems.loot, row3, 1, " "..przedmioty[v3].nazwa,false,true)
              guiGridListSetItemData(gridlistItems.loot, row3, 1, v3)
              guiGridListSetItemText(gridlistItems.loot, row3, 2,item,false,true)
              waga = waga + przedmioty[v3].waga * item
            end
          end
        end
      end
      if row1 and column1 then
        guiGridListSetSelectedItem(gridlistItems.loot, row1, column1)
      end
      guiSetText(headline.slots_loot, "Sloty: " ..waga.. "/" .. sloty)
    end
  end
end

addEventHandler("onClientGUIClick", buttonItems.inventory, function()
  local itemID = guiGridListGetItemData(gridlistItems.inventory, guiGridListGetSelectedItem(gridlistItems.inventory), 1)
  local quantity = 1
  local max = localPlayer:getData(itemID)
  if(przedmioty[itemID].waga < 1)then
    quantity = 1/przedmioty[itemID].waga
  end
  if(getKeyState("lalt") or getKeyState("ralt"))then
    quantity = 1
  elseif(getKeyState("lshift") or getKeyState("rshift"))then
    quantity = localPlayer:getData(itemID)
  end
  if(quantity > max)then
    quantity = max
  end
  triggerServerEvent("onPlayerMoveItemOutInventory", resourceRoot,getCurrentLoot(), itemID, quantity)
end,false)

addEventHandler("onClientGUIClick", buttonItems.loot, function()
  if getCurrentLoot() then
    local itemID = guiGridListGetItemData(gridlistItems.loot, guiGridListGetSelectedItem(gridlistItems.loot), 1)
    triggerServerEvent("onPlayerMoveItemInInventory", resourceRoot,getCurrentLoot(), itemID, 1)
  end
end,false)

function onClientOpenInventoryStopMenu()
  triggerEvent("disableMenu", localPlayer)
end

function getCurrentLoot()
  return getElementData(localPlayer, "currentCol")
end

bindKey("mouse2", "down", function()
  if isCursorShowing() and guiGetVisible(inventoryWindows) then
    local itemID = guiGridListGetItemData(gridlistItems.inventory, guiGridListGetSelectedItem(gridlistItems.inventory), 1)
    if(itemID)then
      local useDesc = przedmioty[itemID].uzycie
      if(useDesc)then
        showRightClickInventoryMenu(itemID, useDesc)
      end
    end
  end
end)

function showRightClickInventoryMenu(itemID, itemInfo)
  if itemInfo and itemID then
    local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
    guiSetVisible(rightclickWindow, true)
    guiSetText(headline.rightclickmenu, itemInfo)
    local whith = guiLabelGetTextExtent(headline.rightclickmenu)
    guiSetPosition(rightclickWindow, screenx, screeny, true)
    local x, y = guiGetSize(rightclickWindow, false)
    guiSetSize(rightclickWindow, whith, y, false)
    guiBringToFront(rightclickWindow)
    setElementData(rightclickWindow, "itemID", itemID, false)
  end
end

function hideRightClickInventoryMenu()
  guiSetVisible(rightclickWindow, false)
end

addEventHandler("onClientGUIClick", headline.rightclickmenu, function(button,state)
  if button == "left" then
    local itemID = getElementData(rightclickWindow, "itemID")
    hideRightClickInventoryMenu()
    triggerServerEvent("onPlayerUseItem", resourceRoot, itemID)
  end
end, false)

addEvent("refreshInventoryManual", true)
addEventHandler("refreshInventoryManual", localPlayer, refreshInventory)

addEvent("refreshLootManual", true)
addEventHandler("refreshLootManual", localPlayer, refreshLoot)