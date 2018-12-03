function giveItem(player,itemID,ammount)
  player:setData(itemID,(player:getData(itemID) or 0) + ammount)
end

addEvent ( "onPlayerUseItem", true )
addEventHandler ( "onPlayerUseItem", resourceRoot,function(itemID)
  if(itemID)then
    local dane = przedmioty[itemID]
    if(not dane)then return false end
    local quantity = client:getData(itemID)
    if(quantity < 1)then return false end
    
    if(dane.kategoria == "Bronie")then
      if(dane.subkategoria == "Główna")then
        setElementData(client,"aktualnabron_1",itemID)
        setElementData(client,"aktualnabron_1_amunicja",bronie[itemID][3])
      elseif(dane.subkategoria == "Poboczna")then
        setElementData(client,"aktualnabron_2",itemID)
        setElementData(client,"aktualnabron_2_amunicja",bronie[itemID][3])
      elseif(dane.subkategoria == "Specjalne")then
        setElementData(client,"aktualnabron_3",itemID)
        setElementData(client,"aktualnabron_3_amunicja",bronie[itemID][3])
      elseif(dane.subkategoria == "Amunicja")then
        local data = przedmioty[bronieAmunicja[itemID]]
        local slot = false
        if(data.subkategoria == "Główna")then
          slot = 1;
        elseif(data.subkategoria == "Poboczna")then
          slot = 2;
        elseif(data.subkategoria == "Specjalna")then
          slot = 3;
        end
        setElementData(client,"aktualnabron_"..slot.."_amunicja",itemID)
      end
      exports.dayz_core:updateWeapons(client)
    elseif(dane.kategoria == "Przedmioty")then
      if(dane.subkategoria == "Ubrania")then
        local nowySkin = przedmiotSkiny[itemID]
        if(nowySkin ~= client.model)then
          local starySkinPrzedmiot = skinyPrzedmiot[client.model] or 73
          client.model = nowySkin
          giveItem(client,itemID, -1)
          client:setData(starySkinPrzedmiot,(client:getData(starySkinPrzedmiot) or 0) + 1)
          exports.dayz_core:animacja("uzywa")
        else
          client:outputChat("Już posiadasz to ubranie!",255,0,0)
        end
      elseif(dane.subkategoria == "Lekarstwa")then
        if(itemID == 3000)then
          local krwawienie = client:getData("krwawienie")
          if(krwawienie > 0)then
            krwawienie = krwawienie - 200
            if(krwawienie < 0)then
              krwawienie = 0
            end
            client:setData("krwawienie",krwawienie)
            exports.dayz_core:animacja("uzywa")
            giveItem(client,itemID, -1)
          else
            client:outputChat("Nie krwawisz!",255,0,0)
          end
        elseif(itemID == 3001)then
          local bolglowy = client:getData("bolglowy")
          if(bolglowy)then
            client:setData("bolglowy",false)
            exports.dayz_core:animacja("uzywa")
            giveItem(client,itemID, -1)
          else
            client:outputChat("Nie boli cię głowa!",255,0,0)
          end
        elseif(itemID == 3002)then
          local temperatura = client:getData("temperatura")
          if(temperatura < 40)then
            temperatura = temperatura + 2
            client:setData("temperatura",temperatura)
            exports.dayz_core:animacja("uzywa")
            giveItem(client,itemID, -1)
          else
            client:outputChat("Nie potrzebujesz się ogrzać!",255,0,0)
          end
        elseif(itemID == 3003)then
          local temperatura = client:getData("temperatura")
          if(temperatura > 34)then
            temperatura = temperatura - 2
            client:setData("temperatura",temperatura)
            exports.dayz_core:animacja("uzywa")
            giveItem(client,itemID, -1)
          else
            client:outputChat("Nie potrzebujesz się ochłodzić!",255,0,0)
          end
        elseif(itemID == 3004)then
          local zlamana_noga = client:getData("zlamana_noga")
          if(zlamana_noga)then
            client:setData("zlamana_noga",false)
            exports.dayz_core:animacja("uzywa")
            giveItem(client,itemID, -1)
          else
            client:outputChat("Nie masz złamanej nogi!",255,0,0)
          end
        elseif(itemID == 3006)then
          local krew = client:getData("krew")
          if(krew <= 12000)then
            krew = krew + 6000
            if(krew > 12000)then
              krew = 12000
            end
            client:setData("krew",krew)
            exports.dayz_core:animacja("uzywa")
            giveItem(client,itemID, -1)
          else
            client:outputChat("Nie musisz użyć zestawu medycznego!",255,0,0)
          end
        end
      elseif(dane.subkategoria == "Do postawienia")then
        placeData = forPlacing[itemID]
        if(placeData)then
          if(placeData[9])then
            placeData[9](client)
          else
            local x,y,z = getElementPosition(client)
            local obj = createObject(placeData[6],x,y,z,0,0,0,true)
            if(placeData[5] and placeData[5] > 0)then
              setTimer(destroyElement,placeData[5],1,obj)
            end
            if(placeData[7] and placeData[7] > 0)then
              col = createColSphere(0,0,0,placeData[7])
              attachElements(col,obj)
              setElementParent(col,obj)
            end
            setElementParent(obj,rootDayzElements)
            placeData[8](client,obj)
          end
        end
      end
    elseif(dane.kategoria == "Jedzenie i picie")then
      if(jedzenie[itemID])then
        local glod = client:getData("glod")
        local pragnienie = client:getData("pragnienie")
        local krew = client:getData("krew")
        glod = glod + jedzenie[itemID][1]
        pragnienie = pragnienie + jedzenie[itemID][2]
        krew = krew + jedzenie[itemID][3]
        if(glod > 100)then glod = 100 end
        if(pragnienie > 100)then pragnienie = 100 end
        if(krew > 12000)then krew = 12000 end
        client:setData("glod",glod)
        client:setData("pragnienie",pragnienie)
        client:setData("krew",krew)
        exports.dayz_core:animacja("jedz")
        giveItem(client,itemID, -1)
      end
    end
    triggerClientEvent(client, "refreshInventoryManual", client)
  end
end)
