local id = 1

addCommandHandler("awesome", function(player)
  local x, y, z = getElementPosition(player)
  setElementPosition(player, x, y, z + 0.5)
  createFunnyGun(player, x, y, z)
end)

addCommandHandler("fuckAwesome", function(player)
  local x, y, z = getElementPosition(player)
  setElementPosition(player, x, y, z + 0.5)
  local gerade = false

  for x2=-2, 2, 0.5 do
    local x3 = x2
    if gerade then
      gerade = false
    else
      gerade = true
      x3 = x3 + 0.5
    end

    for y2=0, 0.5, 0.5 do
      for z2=0, 1, 0.5 do
        createFunnyGun(player, x3, y2, z2)
      end
    end
  end
end)

function createFunnyGun(player, x, y, z)
  local ids = id
  triggerClientEvent(root, "createWeapon", player, ids, x, y, z)
  local rotation = 0
  bindKey(player, "num_4", "down", function()
    rotation = rotation - 5
    if rotation < 0 then
      rotation = 360
    end
    triggerClientEvent(root, "setWeaponRotation", player, ids, rotation)
  end)

  bindKey(player, "mouse2", "both", function(player, key, state)
    if state == "down" then
      triggerClientEvent(root, "fireWeapon", player, ids, "firing")
    else
      triggerClientEvent(root, "fireWeapon", player, ids, "ready")
    end
  end)

  bindKey(player, "num_6", "down", function()
    rotation = rotation + 5
    if rotation > 360 then
      rotation = 0
    end
    triggerClientEvent(root, "setWeaponRotation", player, ids, rotation)
  end)


  id = id + 1
end

function funIt(player)
  local veh = getPedOccupiedVehicle(player)
  if veh then
    triggerClientEvent(root, "createMinigun", veh)
    bindKey(player, "lctrl", "both", function(player, key, state)
      if state == "down" then
        triggerClientEvent(root, "fireMinigun", veh, veh, "firing")
      else
        triggerClientEvent(root, "fireMinigun", veh, veh, "ready")
      end
    end)
  end
end
addCommandHandler("fun", funIt)

addCommandHandler("spawn", function(player)
  local x, y, z = getElementPosition(player)
  local ramps = {}

  --local rampi = createObject(13645, x, y, z)
  --table.insert(ramps, rampi);
  --[[
  local rampi = createObject(13645, x, y, z)
  table.insert(ramps, rampi);
  local rampi = createObject(13645, x, y, z)
  table.insert(ramps, rampi);
  --attachElements(ramps[1], veh, 0, 9, 2.8, 0, 0, 180)
  attachElements(ramps[1], veh, 2.8, 5, 0, 0, 0, 180)
  attachElements(ramps[2], veh, -2.8, 5, 0, 0, 0, 180)]]

  local veh = createVehicle(495, x, y, z)
  setVehicleDamageProof(veh, true)
  addVehicleUpgrade(veh, 1087)

  local col = createColSphere(0, 0, 0, 1)
  attachElements(col, veh, 0, 25, 0, 0, 0, 0)
  local block = false
  --[[bindKey(player, "k", "down", function()
    if block then return end
    local x, y, z = getElementPosition(col)
    block = true
    moveObject(ramps[1], 350, x, y, z)
    moveObject(ramps[2], 350, x + 2.8, y, z)
    moveObject(ramps[3], 350, x - 2.8, y, z)
    detachElements(ramps[1], veh)
    detachElements(ramps[2], veh)
    detachElements(ramps[3], veh)
    setTimer(function()
    block = false
      attachElements(ramps[1], veh, 0, 5, 0, 0, 0, 180)
      attachElements(ramps[2], veh, 2.8, 5, 0, 0, 0, 180)
      attachElements(ramps[3], veh, -2.8, 5, 0, 0, 0, 180)
    end, 400, 1)
  end)]]
--[[
    bindKey(player, "l", "down", function()
      attachElements(ramps[1], veh, 0, 5, 0, 0, 0, 180)
      attachElements(ramps[2], veh, 2.8, 5, 0, 0, 0, 180)
      attachElements(ramps[3], veh, -2.8, 5, 0, 0, 0, 180)
    end)]]
  warpPedIntoVehicle(player, veh)
  funIt(player)
end)

addCommandHandler("spawn2", function(player)
  local x, y, z = getElementPosition(player)
  local ramps = {}

  local rampi = createObject(13645, x, y, z)
  table.insert(ramps, rampi);
  local rampi = createObject(13645, x, y, z)
  table.insert(ramps, rampi);
  local rampi = createObject(13645, x, y, z)
  table.insert(ramps, rampi);
  local veh = createVehicle(411, x, y, z)
  attachElements(ramps[1], veh, 0, 5, 0, 0, 0, 180)
  attachElements(ramps[2], veh, 2.8, 5, 0, 0, 0, 180)
  attachElements(ramps[3], veh, -2.8, 5, 0, 0, 0, 180)

  warpPedIntoVehicle(player, veh)
end)
