HUD = {}
HUD.isHidden = false
HUD.position = {x = 0, y = 0}
HUD.size = {x = 0, y = 0}
HUD.defaultSize = {x = 250, y = 200}
HUD.border = {x = 20, y = 20}

HUD.Init = function()
  HUD.SetDefaultSizeAndPosition()
  HUD.renderTarget = dxCreateRenderTarget(HUD.defaultSize.x, HUD.defaultSize.y, true)

  setPlayerHudComponentVisible("ammo", false)
  setPlayerHudComponentVisible("clock", false)
  setPlayerHudComponentVisible("money", false)
  setPlayerHudComponentVisible("weapon", false)
  setPlayerHudComponentVisible("wanted", false)
  setPlayerHudComponentVisible("area_name", false)

  addEventHandler("onClientRender", root, HUD.Draw)
end

HUD.SetDefaultSizeAndPosition = function()
  local sX, sY = guiGetScreenSize()
  HUD.size.x = HUD.defaultSize.x * (1600/sX)
  HUD.size.y = HUD.defaultSize.y * (900/sY)

  HUD.position.x = sX - HUD.border.x - HUD.size.x
  HUD.position.y = HUD.border.y
end

HUD.Draw = function()
  if HUD.isHidden then return end

  dxSetRenderTarget(HUD.renderTarget, true)
  dxDrawRectangle(0, 0, HUD.defaultSize.x, HUD.defaultSize.y, tocolor(0, 0, 0, 200))
  dxDrawText(Time.GetTime(), 10, 10)
  dxDrawText("€ "..tostring(Player.GetMoney()), 10, 25)
  dxDrawText(tostring(Player.GetWantedlevel()).." Wanteds", 10, 40)
  dxDrawText(tostring(Player.GetLocation()).." - "..tostring(Player.GetCity()), 10, 55)
  dxSetRenderTarget()

  dxDrawImage(HUD.position.x, HUD.position.y, HUD.size.x, HUD.size.y, HUD.renderTarget)
end

HUD.Hide = function(radar)
  if radar then
    Radar.Hide()
  end
  HUD.isHidden = true
end

HUD.Show = function(radar)
  if radar then
    Radar.Show()
  end
  HUD.isHidden = false
end

HUD.IsVisible = function()
  return not HUD.isHidden
end
