Teamspeak = {}
Teamspeak.element = createElement("teamspeak")

addEvent("onTeamspeakKick")
addEvent("onTeamspeakPoke")

Teamspeak.Init = function()

end

Teamspeak.SendRequest = function(callback, ...)
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
      callback(res, uid, kickTyp, reason)
    end
    triggerEvent("onTeamspeakKick", Teamspeak.element, res, uid, kickTyp, reason))
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
      callback(res, uid, text)
    end
    triggerEvent("onTeamspeakPoke", Teamspeak.element, res, uid, text)
  end, "poke", uid, text)
end
