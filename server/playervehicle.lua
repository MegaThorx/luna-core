PlayerVehicle = {}
PlayerVehicle.vehicles = {}

PlayerVehicle.Init = function()
  local vehicles = DbPlayerVehicles.Find()

  if vehicles then
    for k, v in pairs(vehicles) do
      PlayerVehicle.Spawn(v)
    end
  end
end


PlayerVehicle.GetVehicle = function(id)
  local handle = SQL.Query("SELECT * FROM playervehicles WHERE id = ?", id)
  local result = SQL.Poll(handle, -1)

  if result then
    return result
  else
    return false
  end
end

PlayerVehicle.Spawn = function(veh)

  local vehicle = Vehicle.Create(veh.GetModel(), veh.GetX(), veh.GetY(), veh.GetZ(), veh.GetRx(), veh.GetRy(), veh.GetRz())
  setVehicleColor(vehicle, veh.GetColor1r(), veh.GetColor1g(), veh.GetColor1b(), veh.GetColor2r(), veh.GetColor2g(), veh.GetColor2b())
  setVehicleHeadLightColor(vehicle, veh.GetLightr(), veh.GetLightg(), veh.GetLightb())

  veh.CopyDataToElement(vehicle)
  ElementData.Set(vehicle, "shader", true, true)
  ElementData.Set(vehicle, "enginestate", false, true)


  table.insert(PlayerVehicle.vehicles, vehicle)
  -- files/images/textures/camo.jpg
end

PlayerVehicle.SpawnById = function(id)

end

PlayerVehicle.Destroy = function(id)
  for i,v in pairs(vehicles) do
    if ElementData.Get(v, "id") == id then
      Element.SaveData(v, "playervehicles")
      destroyElement(v)
    end
  end
end

PlayerVehicle.Respawn = function(id)
  local data = PlayerVehicle.GetVehicle(id)
  if data then
    PlayerVehicle.Destroy(id)
    PlayerVehicle.Spawn(data)
  end
  return false
end
