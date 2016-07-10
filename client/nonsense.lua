local weapons = {}

local shitWeapons = {}

addEvent("setWeaponRotation", true)
addEvent("fireWeapon", true)
addEvent("createWeapon", true)

addEventHandler("setWeaponRotation", root, function(id, rotation)
  if shitWeapons[id] then
    setElementRotation(shitWeapons[id], 0, 0, rotation)
  end
end)

addEventHandler("fireWeapon", root, function(id, state)
  if shitWeapons[id] then
    setWeaponState(shitWeapons[id], state)
  end
end)

addEventHandler("createWeapon", root, function(id, x, y, z)
  shitWeapons[id] = createWeapon("tec-9", x, y, z)
  setWeaponClipAmmo(shitWeapons[id], 99999)
  attachElements(shitWeapons[id], source, x, y, z, 0, 0, 90)
  setElementAlpha(shitWeapons[id], 0)
  setElementCollisionsEnabled(shitWeapons[id], false)
  setElementCollidableWith(shitWeapons[id], root, false)
end)

addEventHandler("onClientVehicleDamage", root, function(attacker, weapon, loss, x, y, z, tyre)
  if not isElementSyncer(source) then return end
  cancelEvent(true)
  local health = getElementHealth(source)
  local newhealth = health - loss / 1.5
  --outputChatBox(health.." "..tostring(attacker).." "..tostring(weapon).." "..tostring(loss))
  if newhealth <= 300 then
    setVehicleEngineState(source, false)
    setElementData(source, "enginestate", false, true)
    newhealth = 300
  end
  setElementHealth(source, newhealth)
end)

addEvent("createMinigun", true)
addEventHandler("createMinigun", root, function()
weapons[source] = {}

for i=1,54 do
  local gun = createWeapon("minigun", 0, 0, 0)
  setWeaponClipAmmo(gun, 99999)
  table.insert(weapons[source], gun)
end

attachElements(weapons[source][1], source, 0, 2.5, 0, 0, 0, 90)
attachElements(weapons[source][2], source, 0.8, 2.5, 0, 0, 0, 90)
attachElements(weapons[source][3], source, -0.8, 2.5, 0, 0, 0, 90)

attachElements(weapons[source][4], source, 0, 2.5, 0.5, 0, 0, 90)
attachElements(weapons[source][5], source, 0.8, 2.5, 0.5, 0, 0, 90)
attachElements(weapons[source][6], source, -0.8, 2.5, 0.5, 0, 0, 90)

attachElements(weapons[source][7], source, 0, 2.5, 1, 0, 0, 90)
attachElements(weapons[source][8], source, 0.8, 2.5, 1, 0, 0, 90)
attachElements(weapons[source][9], source, -0.8, 2.5, 1, 0, 0, 90)

attachElements(weapons[source][10], source, 0, 2.5, -0.2, 0, 0, 90)
attachElements(weapons[source][11], source, 0.8, 2.5, -0.2, 0, 0, 90)
attachElements(weapons[source][12], source, -0.8, 2.5, -0.2, 0, 0, 90)

attachElements(weapons[source][13], source, 1, 2.5, 1, 0, 0, 45)
attachElements(weapons[source][14], source, 1, 2.5, 0.5, 0, 0, 45)
attachElements(weapons[source][15], source, 1, 2.5, -0.2, 0, 0, 45)

attachElements(weapons[source][16], source, -1, 2.5, 1, 0, 0, 135)
attachElements(weapons[source][17], source, -1, 2.5, 0.5, 0, 0, 135)
attachElements(weapons[source][18], source, -1, 2.5, -0.2, 0, 0, 135)

attachElements(weapons[source][19], source, 0, -2.5, 0, 0, 0, -90)
attachElements(weapons[source][20], source, 0.8, -2.5, 0, 0, 0, -90)
attachElements(weapons[source][21], source, -0.8, -2.5, 0, 0, 0, -90)

attachElements(weapons[source][22], source, 0, -2.5, 0.5, 0, 0, -90)
attachElements(weapons[source][23], source, 0.8, -2.5, 0.5, 0, 0, -90)
attachElements(weapons[source][24], source, -0.8, -2.5, 0.5, 0, 0, -90)

attachElements(weapons[source][25], source, 0, -2.5, 1, 0, 0, -90)
attachElements(weapons[source][26], source, 0.8, -2.5, 1, 0, 0, -90)
attachElements(weapons[source][27], source, -0.8, -2.5, 1, 0, 0, -90)

attachElements(weapons[source][28], source, 0, -2.5, -0.2, 0, 0, -90)
attachElements(weapons[source][29], source, 0.8, -2.5, -0.2, 0, 0, -90)
attachElements(weapons[source][30], source, -0.8, -2.5, -0.2, 0, 0, -90)

attachElements(weapons[source][31], source, 1, -2.5, 1, 0, 0, -45)
attachElements(weapons[source][32], source, 1, -2.5, 0.5, 0, 0, -45)
attachElements(weapons[source][33], source, 1, -2.5, -0.2, 0, 0, -45)

attachElements(weapons[source][34], source, -1, -2.5, 1, 0, 0, -135)
attachElements(weapons[source][35], source, -1, -2.5, 0.5, 0, 0, -135)
attachElements(weapons[source][36], source, -1, -2.5, -0.2, 0, 0, -135)

attachElements(weapons[source][37], source, 1.2, 0, 0, 0, 0, 0)
attachElements(weapons[source][38], source, 1.2, 1, 0, 0, 0, 0)
attachElements(weapons[source][39], source, 1.2, -1, 0, 0, 0, 0)

attachElements(weapons[source][40], source, 1.2, 0, 0.5, 0, 0, 0)
attachElements(weapons[source][41], source, 1.2, 1, 0.5, 0, 0, 0)
attachElements(weapons[source][42], source, 1.2, -1, 0.5, 0, 0, 0)

attachElements(weapons[source][43], source, 1.2, 0, 1, 0, 0, 0)
attachElements(weapons[source][44], source, 1.2, 1, 1, 0, 0, 0)
attachElements(weapons[source][45], source, 1.2, -1, 1, 0, 0, 0)

attachElements(weapons[source][46], source, -1.2, 0, 0, 0, 0, 180)
attachElements(weapons[source][47], source, -1.2, 1, 0, 0, 0, 180)
attachElements(weapons[source][48], source, -1.2, -1, 0, 0, 0, 180)

attachElements(weapons[source][49], source, -1.2, 0, 0.5, 0, 0, 180)
attachElements(weapons[source][50], source, -1.2, 1, 0.5, 0, 0, 180)
attachElements(weapons[source][51], source, -1.2, -1, 0.5, 0, 0, 180)

attachElements(weapons[source][52], source, -1.2, 0, 1, 0, 0, 180)
attachElements(weapons[source][53], source, -1.2, 1, 1, 0, 0, 180)
attachElements(weapons[source][54], source, -1.2, -1, 1, 0, 0, 180)
end)

addEvent("fireMinigun", true)
addEventHandler("fireMinigun", root, function(veh, state)
  if weapons[veh] then
    for k,v in pairs(weapons[veh]) do
      setWeaponState(v, state)
    end
  end
end)


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
--[[
function noDamageToPlayersFromCustomWeapons(_, _, _, x, y, z)
    createExplosion(x, y, z, 5)
    createExplosion(x + 1, y + 1, z, 5)
    createExplosion(x - 1, y + 1, z, 5)
    createExplosion(x + 1, y - 1, z, 5)
    createExplosion(x - 1, y - 1, z, 5)
end
addEventHandler("onClientPlayerWeaponFire", root, noDamageToPlayersFromCustomWeapons)
]]
addCommandHandler("pos", function()
  local x, y, z = getElementPosition(localPlayer)
  local _, _, rz = getElementRotation(localPlayer)
  outputChatBox(tostring(x)..", "..tostring(y)..", "..tostring(z)..", "..tostring(rz))
end)

addCommandHandler("cam", function()
  local x, y, z, lx, ly, lz, roll, fov = getCameraMatrix()

  outputChatBox(tostring(x)..", "..tostring(y)..", "..tostring(z)..", "..tostring(lx)..", "..tostring(ly)..", "..tostring(lz))
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
