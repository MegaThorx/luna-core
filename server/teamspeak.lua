Teamspeak = {}
Teamspeak.element = createElement("teamspeak")
Teamspeak.channels = {}
Teamspeak.clients = {}

addEvent("onTeamspeakKick")
addEvent("onTeamspeakPoke")
addEvent("onTeamspeakMessage")
addEvent("onTeamspeakChannels")
addEvent("onTeamspeakClients")




Teamspeak.Init = function()

end

Teamspeak.SendRequest = function(callback, ...)
  callRemote(Config.Get("teamspeak.api"), callback, Config.Get("teamspeak.token"), ...)
end

Teamspeak.SendRequest2 = function(callback, ...)
  callRemote(Config.Get("teamspeak.api"), callback, Config.Get("teamspeak.token"), ...)
end

Teamspeak.Kick = function(uid, kickTyp, reason, callback)
  if not uid then return end
  if not kickTyp then kickTyp = 1 end
  if not reason then reason = "" end

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(res, result, uid, kickTyp, reason)
    end
    triggerEvent("onTeamspeakKick", Teamspeak.element, res, uid, kickTyp, reason)
  end, "kick", uid, kickTyp, reason)
end

Teamspeak.Poke = function(uid, text, callback)
  if not uid then return end
  if not kickTyp then kickTyp = 1 end
  if not reason then reason = "" end

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(res, result, uid, text)
    end
    triggerEvent("onTeamspeakPoke", Teamspeak.element, res, uid, text)
  end, "poke", uid, text)
end



Teamspeak.MessageClient = function(uid, text, callback)
  if not uid then return end

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(res, result, uid, text)
    end
    triggerEvent("onTeamspeakMessage", Teamspeak.element, res, uid, text)
  end, "messageClient", uid, text)
end

Teamspeak.MessageServer = function(text, callback)

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(res, result, text)
    end
    triggerEvent("onTeamspeakMessage", Teamspeak.element, res, text)
  end, "messageServer", text)
end


Teamspeak.MoveToChannel = function(uid, channelId, text, callback)

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(res, result, uid, channelId, text)
    end
    triggerEvent("onTeamspeakMessage", Teamspeak.element, res, uid, channelId, text)
  end, "moveToChannel", uid, channelId, text)
end

Teamspeak.GetChannels = function(callback)

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(result)
    end
    triggerEvent("onTeamspeakChannels", Teamspeak.element, result)
  end, "getChannels")
end

Teamspeak.GetClients = function(callback)

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(result)
    end
    triggerEvent("onTeamspeakClients", Teamspeak.element, result)
  end, "getClients")
end

Teamspeak.GetClientServergroup = function(uid, callback)

  Teamspeak.SendRequest(function(result)
    local res = false
    if result == "Success" then
      res = true
    end

    if callback then
      callback(result, uid)
    end
    triggerEvent("onTeamspeakClients", Teamspeak.element, uid, result)
  end, "getClientServergroup", uid)
end

addCommandHandler("teste", function()
  outputDebugString("kicking em")
  Teamspeak.Kick("4/MzNBuF5NMmGPP+8h6eNrSXCDs=", 1, "Test", function(_, result)
    outputDebugString(tostring(result))
  end)
end)

addCommandHandler("poke", function(player, cmd, ...)
  local text = {...}
  text = table.concat(text, ' ')
  setTimer(function()
    Teamspeak.Poke("rJVgSGt4gXDwJ2UArtDgfbUKYVw=", text, function(_, result)
      outputServerLog(tostring(result))

    end)
  end, 500, 0)
end)

addCommandHandler("poke2", function(player, cmd, ...)
  local text = {...}
  text = table.concat(text, ' ')
  Teamspeak.Poke("rJVgSGt4gXDwJ2UArtDgfbUKYVw=", text, function(_, result)
    outputDebugString(tostring(result))
  end)
end)



addCommandHandler("pmi", function(player, cmd, ...)
  local text = {...}
  text = table.concat(text, ' ')
  Teamspeak.MessageClient("4/MzNBuF5NMmGPP+8h6eNrSXCDs=", text)

end)


addCommandHandler("sayi", function(player, cmd, ...)
  local text = {...}
  text = table.concat(text, ' ')
  Teamspeak.MessageServer(text)

end)

addCommandHandler("move", function(player, cmd, ...)
  local current = 1
  local ids = {

  }
  setTimer(function()
    Teamspeak.MoveToChannel("PNk8MvsGwWLFGX5E78sxBWnIY9Q=", Teamspeak.channels[current], "")
    current = current + 1
    if #Teamspeak.channels < current then
      current = 1
    end
    outputServerLog("Moved")
  end, 50, 0)
end)

addCommandHandler("move2", function(player, cmd, ...)
  local current = 1

  local ids = {
    "4/MzNBuF5NMmGPP+8h6eNrSXCDs=",
    "grwIaW3EwUf6jcXHBLNRPNmyp+8=",
    "rJVgSGt4gXDwJ2UArtDgfbUKYVw=",
    "8XIWZd8rPbplmTb6GJR6vRLbCBk=",
    "/Cj6boTMOONQ9skMMduG+WNUtIc=",
    "a1juOIN8Ixz5T6YSoz3FLsBvwH0=",
    "k3owyIwH17UIXthsbLK8HXSX1Ig="
  }

  setTimer(function()
    for k,v in pairs(ids) do
    outputServerLog("Moved - "..v)
      Teamspeak.MoveToChannel(v, Teamspeak.channels[current], "")
    end
    current = current + 1
    if #Teamspeak.channels < current then
      current = 1
    end
  end, 50, 0)
end)

addCommandHandler("groups", function()
  Teamspeak.GetClientServergroup("SuuUi2R/8RkF3Z085Be5jZNjSZs=",
  function(result)
    for ke,kv in pairs(result) do
      outputChatBox(tostring(ke).." "..tostring(kv))
    end
  Utils.Dump("-v", result)
  outputChatBox("loaded groups")
  end)
end)


addCommandHandler("channels", function()
  Teamspeak.GetChannels(function(result)
      for ke,kv in pairs(result) do
        table.insert(Teamspeak.channels, ke)
      end
    Utils.Dump("-v", result)
  end)
end)
addCommandHandler("clients", function()
  Teamspeak.GetClients(function(result)
      for ke,kv in pairs(result) do
        table.insert(Teamspeak.clients, kv)
        for ke2,kv2 in pairs(kv) do
          table.insert(Teamspeak.clients, kv)
          outputServerLog(tostring(ke2).." "..tostring(kv2))
        end
      end
    Utils.Dump("-v", result)
  end)
end)


addCommandHandler("clients", function()
  Teamspeak.GetClients(function(result)
    Utils.Dump("-v", result)
  end)
end)
