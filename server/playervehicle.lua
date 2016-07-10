PlayerVehicle = {}
PlayerVehicle.vehicles = {}

PlayerVehicle.Init = function()
  local handle = SQL.Query("SELECT * FROM playervehicles")
  local result = SQL.Poll(handle, -1)

  for k,v in pairs(result) do
    PlayerVehicle.Spawn(v)
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

PlayerVehicle.Spawn = function(result)
  local vehicle = Vehicle.Create(result["model"], result["x"], result["y"], result["z"], result["rx"], result["ry"], result["rz"])
  setVehicleColor(vehicle, result["color1r"], result["color1g"], result["color1b"], result["color2r"], result["color2g"], result["color2b"])
  setVehicleHeadLightColor(vehicle, result["lightr"], result["lightb"], result["lightg"])

  Element.SetData(vehicle, result, "playervehicles")
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
