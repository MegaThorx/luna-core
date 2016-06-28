Player = {}

Player.GetUsername = function(player)
  if localPlayer then
    if player then
      return getElementData(player, "username")
    else
      return getElementData(localPlayer, "username")
    end
  else
    return ElementData.Get(player, "username")
  end

  return false
end

Player.GetSerial = function(player)
  if player then
    return getPlayerSerial(player)
  elseif localPlayer then
    return getPlayerSerial(localPlayer)
  end

  return false
end

Player.GetPlaytime = function(player)
  if localPlayer then
    if player then
      return getElementData(player, "playtime")
    else
      return getElementData(localPlayer, "playtime")
    end
  else
    return ElementData.Get(player, "playtime")
  end

  return false
end

Player.GetSocialState = function(player)
  return "Burger"
end

Player.GetPhoneNumber = function(player)
  return "123456"
end

Player.GetFactionName = function(player)
  return "Zivilist"
end

Player.GetFaction = function(player)
  return 0
end

Player.GetPing = function(player)
  return getPlayerPing(player)
end

Player.GetPlaytimeFormated = function(player)
  return Time.FormatPlaytime(Player.GetPlaytime(player))
end


Player.GetMoney = function(player)
  if localPlayer then
    if player then
      return getElementData(player, "money")
    else
      return getElementData(localPlayer, "money")
    end
  else
    return ElementData.Get(player, "money")
  end

  return false
end

Player.GetWantedlevel = function(player)
  if localPlayer then
    if player then
      return getElementData(player, "wantedlevel")
    else
      return getElementData(localPlayer, "wantedlevel")
    end
  else
    return ElementData.Get(player, "wantedlevel")
  end

  return false
end

Player.GetAdminlevel = function(player)
  if localPlayer then
    if player then
      return getElementData(player, "adminlevel")
    else
      return getElementData(localPlayer, "adminlevel")
    end
  else
    return ElementData.Get(player, "adminlevel")
  end

  return false
end

Player.GetLocation = function(player)
  if player then
    local x, y, z = getElementPosition(player)
    return getZoneName(x, y, z, false)
  elseif localPlayer then
    local x, y, z = getElementPosition(localPlayer)
    return getZoneName(x, y, z, false)
  end
  return false
end

Player.GetCity = function(player)
  if player then
    local x, y, z = getElementPosition(player)
    return getZoneName(x, y, z, true)
  elseif localPlayer then
    local x, y, z = getElementPosition(localPlayer)
    return getZoneName(x, y, z, true)
  end
  return false
end
