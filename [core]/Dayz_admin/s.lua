addCommandHandler("giveitem",function(plr,cmd,itemID,ammount)
  if(itemID and ammount)then
    itemID = tonumber(itemID)
    ammount = tonumber(ammount)
    if(itemID and ammount)then
      local currentItems = plr:getData(itemID) or 0
      plr:setData(itemID, currentItems + ammount)
      plr:outputChat("otrzymałeś "..ammount.." przedmiotów o id "..itemID)
    end
  end
end)

a = createObject(1337,0,0,0)
iprint(a.parent.parent)