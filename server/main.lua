addEventHandler("onResourceStart", resourceRoot, function()
  local time = Time.GetRealTime()
  setTime(time.hour, time.minute)
  setMinuteDuration(60 * 1000)

  SQL.Connect()
  SQL_MANAGER.Validate()
  Translations.Init()
  Bank.Init()
  PlayerVehicle.Init()
  setFPSLimit(60)
end)

addEventHandler("onResourceStop", resourceRoot, function()
  for k,v in pairs(getElementsByType("player")) do
    Account.SavePlayerData(v)
    for i,_ in pairs(getAllElementData(v)) do
      setElementData(v, i, false)
    end
  end
end)

addEventHandler("onClientReady", root, function(token)
  if token then
    if not Account.Autologin(client, token) then
      triggerClientEvent(client, "showAccountLogin", client)
    end
  else
    triggerClientEvent(client, "showAccountLogin", client)
  end

end)

addEventHandler("onPlayerWasted", root, function(_, killer)
  spawnPlayer(source, -1983 + math.random(-5, 5), 138 + math.random(-5, 5), 28)
  fadeCamera(source, true)
  setCameraTarget(source, source)
end)
