Vehicle = {}

Vehicle.Create = function(...)
  return createVehicle(...)
end

Vehicle.Blow = function(...)
  return blowVehicle(...)
end

Vehicle.Fix = function(veh)
  setVehicleDamageProof(veh, false)
  return fixVehicle(veh)
end

addEventHandler("onVehicleExplode", root, function()

end)

addEventHandler("onVehicleDamage", root, function()
  local health = getElementHealth(source)

  if health <= 300 then
    setVehicleDamageProof(source, true)
    setElementHealth(source, 300)
    setVehicleEngineState(source, false)
    ElementData.Set(source, "enginestate", false, true)
  end
end)

addCommandHandler("repair", function(player)
  local veh = getPedOccupiedVehicle(player)
  if veh then
    Vehicle.Fix(veh)
  end
end)

Vehicle.ToggleLight = function(player)
  local veh = getPedOccupiedVehicle(player)
  if veh then
    if ( getVehicleOverrideLights(veh) ~= 2) then
      setVehicleOverrideLights(veh, 2)
    else
      setVehicleOverrideLights(veh, 1)
    end
  end
end

Vehicle.ToggleEngine = function(player)
  local veh = getPedOccupiedVehicle(player)
  if veh then
    local health = getElementHealth(veh)

    if health <= 300 then
      return
    end
    setVehicleEngineState(veh, not getVehicleEngineState(veh))
    ElementData.Set(veh, "enginestate", getVehicleEngineState(veh), true)
  end
end

addEventHandler("onVehicleEnter", root, function(player, seat, jacked)
  bindKey(player, "l", "down", Vehicle.ToggleLight)
  bindKey(player, "x", "down", Vehicle.ToggleEngine)

  local health = getElementHealth(source)

  if health > 300 and ElementData.Get(source, "enginestate") then
    setVehicleEngineState(source, true)
    ElementData.Set(source, "enginestate", true, true)
  else
    setVehicleEngineState(source, false)
    ElementData.Set(source, "enginestate", false, true)
  end
end)

addEventHandler("onVehicleExit", root, function(player, seat, jacked)
  unbindKey(player, "l", "down", Vehicle.ToggleLight)
  unbindKey(player, "x", "down", Vehicle.ToggleEngine)
end)
