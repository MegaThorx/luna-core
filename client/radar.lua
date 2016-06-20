Radar = {}
Radar.isHidden = false
Radar.position = {x = 0, y = 0}
Radar.size = {x = 0, y = 0}
Radar.offset = {left = 5, right = 5, top = 5, bottom = 15}
Radar.defaultSize = {x = 350, y = 200}
Radar.world = {w = 3072, h = 3072}


Radar.Init = function()
  Radar.SetDefaultSizeAndPosition()
  Radar.mapTarget = dxCreateRenderTarget(6000, 6000, true)
  Radar.renderTarget = dxCreateRenderTarget(Radar.defaultSize.x, Radar.defaultSize.y, true)
  Radar.mapRenderTarget = dxCreateRenderTarget(Radar.defaultSize.x - Radar.offset.left - Radar.offset.right, Radar.defaultSize.y - Radar.offset.bottom - Radar.offset.top, true)


  local mx, my = dxGetMaterialSize(Radar.renderTarget)
  Radar.renderTargetSize = {x = mx, y = my}

  local mx, my = dxGetMaterialSize(Radar.mapRenderTarget)
  Radar.mapRenderTargetSize = {x = mx, y = my}

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
  dxDrawImage(0, 0, 6000, 6000, "files/images/radar/radar_map.jpg")

  local px, py = getElementPosition(localPlayer)
  local mx, my =  (Radar.world.w + px),  (Radar.world.h + py)
  --local mx, my = 6000/Radar.world.w * (Radar.world.w + px), 6000/Radar.world.h * (Radar.world.h + py)
  outputChatBox(tostring(mx).." "..tostring(my))
  dxDrawImage(mx, my, 100, 100, "files/images/radar/blips/20.png")
  dxSetRenderTarget()

  dxSetRenderTarget(Radar.mapRenderTarget, true)
  local px, py = getElementPosition(localPlayer)
  local mx, my = Radar.mapRenderTargetSize.x/2 -(px/(6000/Radar.world.w)), Radar.mapRenderTargetSize.y/2 +(py/(6000/Radar.world.h))

  local _, _, camZ = getElementRotation(getCamera())
  dxDrawImage(mx - Radar.world.w/2, Radar.mapRenderTargetSize.y/5 + (my - Radar.world.h/2), Radar.world.w, Radar.world.h, Radar.mapTarget, camZ, (px/(6000/Radar.world.w)), -(py/(6000/Radar.world.h)), tocolor(255, 255, 255, 255))

  dxSetRenderTarget()

  local px, py = getElementPosition(localPlayer)
  local sX, sY = px - ((6000/Radar.world.w)* Radar.mapRenderTargetSize.x/2), py - ((6000/Radar.world.h)* Radar.mapRenderTargetSize.y/2)
  local eX, eY = px + ((6000/Radar.world.w)* Radar.mapRenderTargetSize.x/2), py + ((6000/Radar.world.h)* Radar.mapRenderTargetSize.y/2)

  dxSetRenderTarget(Radar.renderTarget, true)
  dxDrawRectangle(0, 0, Radar.renderTargetSize.x, Radar.renderTargetSize.y, tocolor(0, 0, 0, 180))
  dxDrawImage(Radar.offset.left, Radar.offset.top, Radar.mapRenderTargetSize.x, Radar.mapRenderTargetSize.y, Radar.mapRenderTarget)
  dxSetRenderTarget()

  dxDrawImage(Radar.position.x, Radar.position.y, Radar.size.x, Radar.size.y, Radar.renderTarget)
  dxDrawImage(0, 0, 650, 650, Radar.mapTarget)
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
