PlayerVehicle = {}

PlayerVehicle.Init = function()
  for k,v in pairs(getElementsByType("vehicle", root, true)) do
    if getElementData(v, "shader") then
      outputDebugString(tostring(source).." init")
      PlayerVehicle.ApplyShader(v)
    end
  end
  addEventHandler("onClientElementStreamIn", root, PlayerVehicle.OnSyncIn)
end

PlayerVehicle.ApplyShader = function(vehicle)
  local shader, technique = dxCreateShader("files/shaders/texture.fx", 0, 0, false, "vehicle")
  local texture = dxCreateTexture("files/images/textures/camo.jpg")

  dxSetShaderValue(shader, "Tex", texture)
  engineApplyShaderToWorldTexture(shader, "vehiclegrunge256", vehicle)
end
addEvent("PlayerVehicle.ApplyShader", true)
addEventHandler("PlayerVehicle.ApplyShader", root, PlayerVehicle.ApplyShader)

PlayerVehicle.OnSyncIn = function()
  if getElementData(source, "shader") then
    PlayerVehicle.ApplyShader(source)
  end
end

PlayerVehicle.OnSyncOut = function()

end
