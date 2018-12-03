function updateWeapons(player)
  player:takeAllWeapons()
  for i=1,3 do
  local aktualnabron = player:getData("aktualnabron_"..i)
    if(aktualnabron)then
      if(przedmioty[aktualnabron])then
        local bronDane = bronie[aktualnabron]
        if(bronDane)then
          player:giveWeapon(bronDane[2],99999999) -- 99999999 to nie błąd, pozwala to na trzymanie w rękach broni która nie ma amunicji
        end
      end
    end
  end
end

function getCurrentSlotFromWeapon(player,weapon)
  local aktualnabron;
  for i=1,3 do
    local aktualnabron = player:getData("aktualnabron_"..i)
    if(aktualnabron and bronie[aktualnabron])then
      local bron = bronie[aktualnabron]
      if(bron[2] == weapon)then
        return i,aktualnabron
      end
    end
  end
  return false
end