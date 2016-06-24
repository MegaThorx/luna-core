Radar = {}
Radar.isHidden = false
Radar.position = {x = 0, y = 0}
Radar.size = {x = 0, y = 0}
Radar.offset = {left = 5, right = 5, top = 5, bottom = 25}
Radar.defaultSize = {x = 350, y = 200}
--Radar.world = {w = 3072, h = 3072}
Radar.world = {w = 3000, h = 3000}
Radar.playerBlipSize = 24
Radar.zoomFactor = 1
Radar.targetZoomFactor = 1

Radar.Init = function()
  Radar.SetDefaultSizeAndPosition()
  Radar.mapTarget = dxCreateRenderTarget(6000, 6000, true)
  Radar.renderTarget = dxCreateRenderTarget(Radar.defaultSize.x, Radar.defaultSize.y, true)
  Radar.mapRenderTarget = dxCreateRenderTarget(Radar.defaultSize.x - Radar.offset.left - Radar.offset.right, Radar.defaultSize.y - Radar.offset.bottom - Radar.offset.top, true)


  local mx, my = dxGetMaterialSize(Radar.renderTarget)
  Radar.renderTargetSize = {x = mx, y = my}

  local mx, my = dxGetMaterialSize(Radar.mapRenderTarget)
  Radar.mapRenderTargetSize = {x = mx, y = my}

  setPlayerHudComponentVisible("radar", false)
  setPlayerHudComponentVisible("armour", false)
  setPlayerHudComponentVisible("breath", false)
  setPlayerHudComponentVisible("health", false)

  addEventHandler("onClientRender", root, Radar.Draw)
end

Radar.SetDefaultSizeAndPosition = function()
  local sX, sY = guiGetScreenSize()
  Radar.size.x = Radar.defaultSize.x * (1600/sX)
  Radar.size.y = Radar.defaultSize.y * (900/sY)

  Radar.position.x = 20
  Radar.position.y = sY - 20 - Radar.size.y
end

Radar.Draw = function()
  if Radar.isHidden then return end

  dxSetRenderTarget(Radar.mapTarget, true)
  dxSetBlendMode("modulate_add")
  dxDrawImage(0, 0, 6000, 6000, "files/images/radar/radar_map.jpg")
  dxSetBlendMode("blend")
  local px, py = getElementPosition(localPlayer)
  local _, _, rotZ = getElementRotation(localPlayer)
  local lx = Radar.world.w + px
  local ly = Radar.world.h * 2 - (Radar.world.h + py)

  local mx = lx * (6000/(Radar.world.w*2))
  local my = ly * (6000/(Radar.world.h*2))

  --outputChatBox(tostring(lx).." "..tostring(ly).." | "..tostring(mx).." "..tostring(my))
  dxSetBlendMode("modulate_add")
  dxDrawImage(mx - Radar.playerBlipSize/2, my - Radar.playerBlipSize/2, Radar.playerBlipSize, Radar.playerBlipSize, "files/images/radar/blips/2.png", rotZ*-1)
  dxSetBlendMode("blend")

  --dxDrawLine(0, 0, 6000, 6000, tocolor(0, 0, 0))
  --dxDrawLine(0, 6000, 6000, 0, tocolor(0, 0, 0))
  dxSetRenderTarget()

  dxSetRenderTarget(Radar.mapRenderTarget, true)
  --dxDrawImage(mx - Radar.world.w/2, Radar.mapRenderTargetSize.y/5 + (my - Radar.world.h/2), Radar.world.w, Radar.world.h, Radar.mapTarget, camZ, (px/(6000/Radar.world.w)), -(py/(6000/Radar.world.h)), tocolor(255, 255, 255, 255))
  --dxDrawImage(mx - Radar.world.w/2, Radar.mapRenderTargetSize.y/5 + (my - Radar.world.h/2), Radar.world.w, Radar.world.h, Radar.mapTarget, 0, (px/(6000/Radar.world.w)), -(py/(6000/Radar.world.h)), tocolor(255, 255, 255, 255))
  local speed = Utils.GetElementSpeed(localPlayer, "km/h")
  if speed < 0 then speed = speed * -1 end


  local mx = lx * (6000*Radar.zoomFactor/(Radar.world.w*2))
  local my = ly * (6000*Radar.zoomFactor/(Radar.world.h*2))
  dxDrawImage(-1*(mx - Radar.defaultSize.x / 2) - Radar.playerBlipSize/2, -1*(my - Radar.defaultSize.y / 2) - Radar.playerBlipSize/2, 6000*Radar.zoomFactor, 6000*Radar.zoomFactor, Radar.mapTarget)
  dxSetRenderTarget()

  dxSetRenderTarget(Radar.renderTarget, true)
  dxDrawRectangle(0, 0, Radar.renderTargetSize.x, Radar.renderTargetSize.y, tocolor(0, 0, 0, 180))
  dxDrawImage(Radar.offset.left, Radar.offset.top, Radar.mapRenderTargetSize.x, Radar.mapRenderTargetSize.y, Radar.mapRenderTarget)

  local displayCount = 1

  if getPedArmor(localPlayer) ~= 0 then
    displayCount = displayCount + 1
  end

  if getPedOxygenLevel(localPlayer) < 1000 then
    displayCount = displayCount + 1
  end

  if displayCount == 1 then
    dxDrawRectangle(Radar.offset.left, Radar.defaultSize.y - Radar.offset.bottom + 5, 340, 15, tocolor(27, 122, 35))
    dxDrawRectangle(Radar.offset.left, Radar.defaultSize.y - Radar.offset.bottom + 5, 340 * (getElementHealth(localPlayer)/100), 15, tocolor(20, 222, 33))
  else
    if displayCount == 2 then
      dxDrawRectangle(Radar.offset.left, Radar.defaultSize.y - Radar.offset.bottom + 5, 335 / 2, 15, tocolor(27, 122, 35))
      dxDrawRectangle(Radar.offset.left, Radar.defaultSize.y - Radar.offset.bottom + 5, (335 / 2) * (getElementHealth(localPlayer)/100), 15, tocolor(20, 222, 33))

      if getPedArmor(localPlayer) ~= 0 then
        dxDrawRectangle(Radar.offset.left + 335 / 2 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, 335 / 2, 15, tocolor(19, 77, 99))
        dxDrawRectangle(Radar.offset.left + 335 / 2 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, (335 / 2) * (getPedArmor(localPlayer)/100), 15, tocolor(0, 152, 199))
      end

      if getPedOxygenLevel(localPlayer) < 1000 then
        dxDrawRectangle(Radar.offset.left + 335 / 2 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, 335 / 2, 15, tocolor(149, 156, 23))
        dxDrawRectangle(Radar.offset.left + 335 / 2 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, (335 / 2) * (getPedOxygenLevel(localPlayer)/1000), 15, tocolor(200, 209, 23))
      end
    end

    if displayCount == 3 then
      dxDrawRectangle(Radar.offset.left, Radar.defaultSize.y - Radar.offset.bottom + 5, 330 / 3, 15, tocolor(27, 122, 35))
      dxDrawRectangle(Radar.offset.left, Radar.defaultSize.y - Radar.offset.bottom + 5, (330 / 3) * (getElementHealth(localPlayer)/100), 15, tocolor(20, 222, 33))

      dxDrawRectangle(Radar.offset.left + (330 / 3)*1 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, (330 / 3)*1, 15, tocolor(19, 77, 99))
      dxDrawRectangle(Radar.offset.left + (330 / 3)*1 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, (330 / 3)*1 * (getPedArmor(localPlayer)/100), 15, tocolor(0, 152, 199))

      dxDrawRectangle(Radar.offset.left + (330 / 3)*2 + 10, Radar.defaultSize.y - Radar.offset.bottom + 5, (330 / 3)*1, 15, tocolor(149, 156, 23))
      dxDrawRectangle(Radar.offset.left + (330 / 3)*2 + 10, Radar.defaultSize.y - Radar.offset.bottom + 5, (330 / 3)*1 * (getPedOxygenLevel(localPlayer)/1000), 15, tocolor(200, 209, 23))
    end
  end


  --dxDrawRectangle(Radar.offset.left + 167.5 + 5, Radar.defaultSize.y - Radar.offset.bottom + 5, 167, 15, tocolor(0, 152, 199))
  --dxDrawLine(Radar.offset.left, Radar.offset.top, Radar.mapRenderTargetSize.x, Radar.mapRenderTargetSize.y, tocolor(0, 0, 0))
  --dxDrawLine(Radar.mapRenderTargetSize.x, Radar.offset.top, Radar.offset.right, Radar.mapRenderTargetSize.y, tocolor(0, 0, 0))
  dxSetRenderTarget()

  dxDrawImage(Radar.position.x, Radar.position.y, Radar.size.x, Radar.size.y, Radar.renderTarget)
  --dxDrawImage(0, 0, 650, 650, Radar.mapTarget)
end

Radar.Hide = function()
  Radar.isHidden = true
end

Radar.Show = function()
  Radar.isHidden = false
end

Radar.IsVisible = function()
  return not Radar.isHidden
end
