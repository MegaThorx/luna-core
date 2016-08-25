JobFarmer = {}
JobFarmer.flowers = {}
--JobFarmer.markers = {}
JobFarmer.players = {}
JobFarmer.z = 128
JobFarmer.maxCount = 200
JobFarmer.flowerMinDistance = 4

JobFarmer.Init = function()
  for i = 1, JobFarmer.maxCount do
    JobFarmer.SpawnFlower()
  end
end

JobFarmer.CheckFlowerDistance = function(x, y, z)
  local flowerShape = createColSphere(x, y, z, JobFarmer.flowerMinDistance)
	local nearbyFlowers = getElementsWithinColShape(flowerShape, "object")
	destroyElement(flowerShape)
	if nearbyFlowers==false then return false end
	if #nearbyFlowers > 0 then return false end
	return true
end

JobFarmer.SpawnFlower = function()
  if #JobFarmer.flowers < JobFarmer.maxCount then
    local x = -1187 + math.random(0, 173)
    local y = -1057 + math.random(0, 134)
    local i = 0

    while true do
			if JobFarmer.CheckFlowerDistance(x, y, JobFarmer.z) then
				break
			else
				x = -1187 + math.random(0, 173)
				y = -1057 + math.random(0, 134)
			end

			if i > 75 then break end -- against infinite loop
			i = i + 1
		end

    local jobMarkers = createMarker(x, y, JobFarmer.z+1, "corona", 5, 0, 0, 0, 0)
    JobFarmer.flowers[jobMarkers] = createObject(855, x, y, JobFarmer.z-3)
    --table.insert(JobFarmer.markers, jobMarkers)

    addEventHandler("onMarkerHit", jobMarkers, JobFarmer.OnMarkerHit)
    moveObject(JobFarmer.flowers[jobMarkers], 60000, x, y, JobFarmer.z)
  end
end

JobFarmer.OnMarkerHit = function(object, dim)
	if getElementType(object) == "player" then
		if not JobFarmer.players[object] then return end
		if getElementModel(JobFarmer.players[object])==532 then
			local flower = JobFarmer.flowers[source]
      JobFarmer.flowers[source] = nil
			removeEventHandler("onMarkerHit", source, JobFarmer.OnMarkerHit)
			stopObject(flower)
			local x, y, z = getElementPosition(flower)

			local money = math.ceil(12*((z-125)/3))
			JobFarmer.SpawnFlower()
      Player.GiveMoney(object, money)

			destroyElement(flower)
			destroyElement(source)
		end
	end
end

JobFarmer.StartJob = function(player)
	JobFarmer.players[player] = createVehicle(532, -1049.69921875, -1153.599609375, 128.89999389648)
	setVehicleHandling (JobFarmer.players[player],"maxVelocity", 50 )
	warpPedIntoVehicle(player, JobFarmer.players[player])
	setElementData(JobFarmer.players[player], "combine", true)
	triggerClientEvent(player, "onJobVehicleCreate", player, JobFarmer.players[player])
	addEventHandler ( "onPlayerQuit", player, JobFarmer.CancelJob )
	addEventHandler ( "onPlayerWasted", player, JobFarmer.CancelJob )
	addEventHandler ( "onVehicleStartExit", JobFarmer.players[player], JobFarmer.CancelJob )
	addEventHandler ( "onVehicleExplode", JobFarmer.players[player], JobFarmer.CancelJob )
end
addCommandHandler("asdf", JobFarmer.StartJob)

JobFarmer.CancelJob = function(player, seat, jacked)
	local object = source
	local player = nil

	if(getElementType ( object ) == "vehicle")then
		player = getVehicleOccupant ( object, 0)
	else
		player = object
	end
	if(player==nil)then cancelEvent() return false end

	if(jacked~=false and jacked~=nil and isElement(jacked) and getElementType(jacked)=="player")then
		cancelEvent()
		return false
	end

	if(getElementType ( player ) == "player")then
		triggerClientEvent(player, "onJobVehicleDestroy", player, JobFarmer.players[player])
		removeEventHandler ( "onPlayerQuit", player, JobFarmer.CancelJob )
		removeEventHandler ( "onPlayerWasted", player, JobFarmer.CancelJob )
		removeEventHandler ( "onVehicleStartExit", JobFarmer.players[player], JobFarmer.CancelJob )
		removeEventHandler ( "onVehicleExplode", JobFarmer.players[player], JobFarmer.CancelJob )
		removePedFromVehicle(player,JobFarmer.players[player])
		destroyElement(JobFarmer.players[player])
		JobFarmer.players[player] = nil
	end
end
