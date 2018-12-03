local root = getRootElement()
addEventHandler("onPlayerLogin", root, function()
  triggerClientEvent("onRollMessageStart", getRootElement(), getPlayerName(source) .. " #FFFFFFvient de se connecter", 255, 255, 255, "join")
end)
