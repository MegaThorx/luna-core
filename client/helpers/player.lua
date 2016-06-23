Player = {}

Player.GetUsername = function(player)
  if player then
    return getElementData(player, "username")
  else
    return getElementData(localPlayer, "username")
  end
end

Player.GetSerial = function(player)
  if player then
    return getPlayerSerial(player)
  else
    return getPlayerSerial(localPlayer)
  end
end

Player.GetPlaytime = function(player)
  if player then
    return getElementData(player, "playtime")
  else
    return getElementData(localPlayer, "playtime")
  end
end

Player.GetMoney = function(player)
  if player then
    return getElementData(player, "money")
  else
    return getElementData(localPlayer, "money")
  end
end

Player.GetWantedlevel = function(player)
  if player then
    return getElementData(player, "wantedlevel")
  else
    return getElementData(localPlayer, "wantedlevel")
  end
end

Player.GetAdminlevel = function(player)
  if player then
    return getElementData(player, "adminlevel")
  else
    return getElementData(localPlayer, "adminlevel")
  end
end

Player.GetLocation = function(player)
  if player then
    local x, y, z = getElementPosition(player)
    return getZoneName(x, y, z, false)
  else
    local x, y, z = getElementPosition(localPlayer)
    return getZoneName(x, y, z, false)
  end
end

Player.GetCity = function(player)
  if player then
    local x, y, z = getElementPosition(player)
    return getZoneName(x, y, z, true)
  else
    local x, y, z = getElementPosition(localPlayer)
    return getZoneName(x, y, z, true)
  end
end
