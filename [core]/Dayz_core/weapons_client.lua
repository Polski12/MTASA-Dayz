function getCurrentSlotFromWeapon(weapon)
  local aktualnabron;
  for i=1,3 do
    local aktualnabron = localPlayer:getData("aktualnabron_"..i)
    if(aktualnabron and bronie[aktualnabron])then
      local bron = bronie[aktualnabron]
      if(bron[2] == weapon)then
        return i,aktualnabron
      end
    end
  end
  return false
end

function weaponSwitch(weapon)
  if source == localPlayer then
    if(weapon > 15)then
      local slot = getCurrentSlotFromWeapon(weapon)
      if(not slot)then
        return toggleControl("fire",false) 
      else
        local ammo = localPlayer:getData("aktualnabron_"..slot.."_amunicja")
        if(not ammo)then
          return toggleControl("fire",false) 
        end
        local ammountOfAmmo = localPlayer:getData(ammo)
        if(ammountOfAmmo and ammountOfAmmo > 0)then
          localPlayer:setData(ammo,ammountOfAmmo - 1)
          return toggleControl("fire",true)
        else
          return toggleControl("fire",false)
        end
      end
    else
      toggleControl("fire",true) 
    end
  end
end

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon)
  if(weapon > 15)then
    toggleControl("fire",false)
    local slot = getCurrentSlotFromWeapon(weapon)
    if(slot)then
      local ammo = localPlayer:getData("aktualnabron_"..slot.."_amunicja")
      if(ammo)then
        local ammountOfAmmo = localPlayer:getData(ammo)
        if(ammountOfAmmo and ammountOfAmmo > 0)then
          localPlayer:setData(ammo,ammountOfAmmo - 1)
          if(ammountOfAmmo - 1 > 0)then
            return toggleControl("fire",true)
          else
            return toggleControl("fire",false)
          end
        end
      end
    end
  else
    toggleControl("fire",true)
  end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prevSlot, weapon)
  local weapon = localPlayer:getWeapon(weapon)
  if(weapon > 15)then
    toggleControl("fire",false)
    local slot = getCurrentSlotFromWeapon(weapon)
    if(slot)then
      local ammo = localPlayer:getData("aktualnabron_"..slot.."_amunicja")
      if(ammo)then
        local ammountOfAmmo = localPlayer:getData(ammo)
        if(ammountOfAmmo and ammountOfAmmo > 0)then
          toggleControl("fire",true)
        end
      end
    end
  else
    toggleControl("fire",true)
  end
end)