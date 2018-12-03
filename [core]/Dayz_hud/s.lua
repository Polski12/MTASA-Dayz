przedmioty = {}
function zaladuj()
	q=exports.db:q("select * from przedmioty")
	przedmioty={}
	for i,v in ipairs(q) do
		table.insert(przedmioty,v)
	end
end
zaladuj()

function animacja(kto,co)
	exports["dayz-ekwipunek"]:animacja(kto,co)
end

function isToolBox(player)
	tolbox=getElementData(player,4009)
	if tolbox and tolbox>0 then
		return true
	else
		outputChatBox("Nie posiadasz skrzynki z narzędziami!",player,255,0,0)
		return false
	end
end

function refreshInventory(player)

end
zniszczItemy={
[3243]="Tent",
[983]="Wire Fence",
}

addEvent("uzyj",true)
addEventHandler("uzyj",resourceRoot,function(kolizja,akcja,opcja)
	if not kolizja then return end
	local parent=getElementData(kolizja,"parent")
	local interakcja=getElementData(kolizja,"interakcja")
  if(akcja == "Stacja paliw")then
    if(opcja == "Napełnij kanister")then
      local items1 = client:getData(4503) or 0
      if(items1 > 0)then
        local items2 = client:getData(4504) or 0
        client:setData(4503,items1 - 1)
        client:setData(4504,items2 + 1)
        return outputChatBox("Napełniłeś kanister",client,0,255,0)
      else
        return outputChatBox("Potrzebujesz pustego kanistra!",client,255,0,0)
      end
    end
  elseif(interakcja == "pojazd")then
    if(opcja == "Zatankuj")then
      local zbiorniki = kolizja:getData("zbiorniki")
      if(zbiorniki)then
        if(zbiorniki[1] > 0)then
          local paliwo = kolizja:getData("paliwo")
          if(paliwo)then
            local pelnyKanister = client:getData(4504) or 0
            if(pelnyKanister > 0)then
              local potrzeba = paliwo[2] - paliwo[1]
              if(potrzeba > 20)then
                potrzeba = 20
              end
              if(potrzeba < 1)then
                return outputChatBox("Nie ma potrzeby tankowania!",client,255,0,0)
              end
              paliwo[1] = paliwo[1] + potrzeba
              kolizja:setData("paliwo",paliwo)
              local pustyKanister = client:getData(4503) or 0
              client:setData(4503,pustyKanister + 1)
              client:setData(4504,pelnyKanister - 1)
              return outputChatBox("Zatankowałeś pomyślnie!",client,0,255,0)
            else
              return outputChatBox("Potrzebujesz pełnego kanistra!",client,255,0,0)
            end
          end
        else
           return outputChatBox("W pojeździe nie ma zbiornika na paliwo!",client,255,0,0)
        end
      end
    elseif(opcja == "Zamontuj silnik")then
      local silnik = kolizja:getData("silnik")
      if(silnik)then
        local silnikPrzedmiot = client:getData(4502) or 0
        if(silnikPrzedmiot > 0)then
          if(silnik[2] > silnik[1])then
            silnik[1] = silnik[1] + 1
            kolizja:setData("silnik",silnik)
            client:setData(4502,silnikPrzedmiot - 1)
            return outputChatBox("Silnik pomyślnie!",client,0,255,0)
          else
            return outputChatBox("Nie ma potrzeby montowania silnika!",client,255,0,0)
          end
        else
          return outputChatBox("Potrzebujesz silnika!",client,255,0,0)
        end
      end
    elseif(opcja == "Zdemontuj silnik")then
      local silnik = kolizja:getData("silnik")
      if(silnik)then
        if(isToolBox(client))then
          if(silnik[1] > 0)then
            local silnikPrzedmiot = client:getData(4502) or 0
            silnik[1] = silnik[1] - 1
            kolizja:setData("silnik",silnik)
            client:setData(4502,silnikPrzedmiot + 1)
            return outputChatBox("Silnik zdemontowany!",client,0,255,0)
          else
            return outputChatBox("Nie ma żadnego silnika w tym pojeździe!",client,255,0,0)
          end
        end
      end
    elseif(opcja == "Zamontuj koło")then
      local kolo = kolizja:getData("kola")
      if(kolo)then
        local koloPrzedmiot = client:getData(4500) or 0
        if(koloPrzedmiot > 0)then
          if(kolo[2] > kolo[1])then
            kolo[1] = kolo[1] + 1
            kolizja:setData("kola",kolo)
            client:setData(4500,koloPrzedmiot - 1)
            return outputChatBox("Koło pomyślnie!",client,0,255,0)
          else
            return outputChatBox("Nie ma potrzeby montowania koła!",client,255,0,0)
          end
        else
          return outputChatBox("Potrzebujesz koła!",client,255,0,0)
        end
      end
    elseif(opcja == "Zdemontuj koło")then
      local kolo = kolizja:getData("kola")
      if(kolo)then
        if(isToolBox(client))then
          if(kolo[1] > 0)then
            local koloPrzedmiot = client:getData(4500) or 0
            kolo[1] = kolo[1] - 1
            kolizja:setData("kola",kolo)
            client:setData(4500,koloPrzedmiot + 1)
            return outputChatBox("Koło zdemontowane!",client,0,255,0)
          else
            return outputChatBox("Nie ma żadnego koła w tym pojeździe!",client,255,0,0)
          end
        end
      end
    elseif(opcja == "Zamontuj zbiornik")then
      local zbiornik = kolizja:getData("zbiorniki")
      if(zbiornik)then
        local zbiornikPrzedmiot = client:getData(4501) or 0
        if(zbiornikPrzedmiot > 0)then
          if(zbiornik[2] > zbiornik[1])then
            zbiornik[1] = zbiornik[1] + 1
            kolizja:setData("zbiorniki",zbiornik)
            client:setData(4501,zbiornikPrzedmiot - 1)
            return outputChatBox("Zbiornik pomyślnie!",client,0,255,0)
          else
            return outputChatBox("Nie ma potrzeby montowania zbiornika!",client,255,0,0)
          end
        else
          return outputChatBox("Potrzebujesz zbiornika!",client,255,0,0)
        end
      end
    elseif(opcja == "Zdemontuj zbiornik")then
      local zbiornik = kolizja:getData("zbiorniki")
      if(zbiornik)then
        if(isToolBox(client))then
          if(zbiornik[1] > 0)then
            local zbiornikPrzedmiot = client:getData(4500) or 0
            zbiornik[1] = zbiornik[1] - 1
            kolizja:setData("zbiorniki",zbiornik)
            client:setData(4500,zbiornikPrzedmiot + 1)
            return outputChatBox("Zbiornik zdemontowany!",client,0,255,0)
          else
            return outputChatBox("Nie ma żadnego zbiornika w tym pojeździe!",client,255,0,0)
          end
        end
      end
    end
  end
end)