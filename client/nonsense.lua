local lastSpeed = 0
local isOnVehicle = nil

setTimer(function()
  local x, y, z = getElementPosition(localPlayer)
  local hit, _, _, _, veh = processLineOfSight(x, y, z, x, y, z - 2, false, true, false, false, false, false, false, false)

  if not getPedOccupiedVehicle(localPlayer) and hit then
    if isOnVehicle then
      isOnVehicle = veh
      local newSpeed = Utils.GetElementSpeed(veh, "km/h")

      if newSpeed < lastSpeed - 1 then
    		local x,y,z = getElementVelocity(veh)
    		setElementVelocity(localPlayer,x,y,z+5)
      end
      lastSpeed = newSpeed
    else
      isOnVehicle = veh
      lastSpeed = Utils.GetElementSpeed(veh, "km/h")
    end
  else
    isOnVehicle = nil
    lastSpeed = 0
  end
end, 50, 0)


--local atm = createObject(2942, -1985.166015625, 145.81533813477, 27.3875)
--Bank.CreateAtmMarker(atm)

function noDamageToPlayersFromCustomWeapons(_, _, _, x, y, z)
    createExplosion(x, y, z, 5)
    createExplosion(x + 1, y + 1, z, 5)
    createExplosion(x - 1, y + 1, z, 5)
    createExplosion(x + 1, y - 1, z, 5)
    createExplosion(x - 1, y - 1, z, 5)
end
addEventHandler("onClientPlayerWeaponFire", root, noDamageToPlayersFromCustomWeapons)

addCommandHandler("pos", function()
  local x, y, z = getElementPosition(localPlayer)
  local _, _, rz = getElementRotation(localPlayer)
  outputChatBox(tostring(x)..", "..tostring(y)..", "..tostring(z)..", "..tostring(rz))
end)

addCommandHandler("enfurn", function()
  for i = 0, 4 do
      setInteriorFurnitureEnabled(i, true)
  end
  outputChatBox("enabled")
end)

addCommandHandler("difurn", function()
  for i = 0, 4 do
      setInteriorFurnitureEnabled(i, false)
  end
  outputChatBox("disabled")
end)

for i = 0, 4 do
    setInteriorFurnitureEnabled(i, false)
end

for i = 0, 20, 1 do
  for id, v in ipairs(furniture) do
    removeWorldModel(v, 9999, 0, 0, 0, i)
    removeWorldModel(v, 9999, 0, 0, 0, 13)
    removeWorldModel(v, 9999, 0, 0, 1000, 0)
  end
end


addCommandHandler("goto", function(cmd, id)
  if not id then
    setElementInterior(localPlayer, 0, 0, 0, 3)
  else
    local interior = interiors[tonumber(id)]
    setElementInterior(localPlayer, interior.interior, interior.x, interior.y, interior.z + 1)
  end
end)
