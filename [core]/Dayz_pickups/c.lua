setDevelopmentMode(true)


addEvent("getLootData", true)
addEventHandler("getLootData", localPlayer, function(loot, data)
  for i,v in pairs(data)do
    loot:setData(i,v)
  end
end)